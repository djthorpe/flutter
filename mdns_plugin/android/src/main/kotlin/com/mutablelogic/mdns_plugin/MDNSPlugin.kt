package com.mutablelogic.mdns_plugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.content.Context
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.util.Log
import android.app.Activity
import java.util.Timer
import kotlin.concurrent.schedule

class MDNSPlugin : MethodCallHandler,StreamHandler {
  var nsdManager: NsdManager? = null
  var sink: EventSink? = null
  var activity: Activity? = null
  var discoveryListener: DiscoveryListener? = null
  val services : HashMap<String,NsdServiceInfo> = HashMap<String,NsdServiceInfo>()

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      MethodChannel(registrar.messenger(), "mdns_plugin").setMethodCallHandler(MDNSPlugin(registrar))      
    }

    fun mapFromServiceInfo(method: String,serviceInfo: NsdServiceInfo?):HashMap<String,Any> {
      val map = HashMap<String, Any>()
      map["method"] = method
      serviceInfo?.let {
        map["name"] = serviceInfo.getServiceName()
        map["type"] = serviceInfo.getServiceType().removePrefix(".").removeSuffix(".") + "." // cleanup
        map["hostName"] = serviceInfo.getHost()?.getHostName() ?: ""
        map["port"] = serviceInfo.getPort()
        map["txt"] = serviceInfo.getAttributes()

        val addr = serviceInfo.getHost()?.getHostAddress()
        addr?.let {
          map["address"] = listOf(listOf(addr,serviceInfo.getPort()))
        }
      }
      return map
    }
  }

  constructor(registrar: Registrar) {
    nsdManager = registrar.activity().getSystemService(Context.NSD_SERVICE) as NsdManager
    activity = registrar.activity()
    EventChannel(registrar.messenger(), "mdns_plugin_delegate").setStreamHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "startDiscovery" -> {
        startDiscovery(result,call.argument<String>("serviceType") ?: "",call.argument<Boolean>("enableUpdating") ?: false)
      }
      "stopDiscovery" -> {
        stopDiscovery(result)
      }
      "resolveService" -> {
        resolveService(result,call.argument<String>("name") ?: "",call.argument<Boolean>("resolve") ?: false)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onListen(p0: Any?, sink: EventSink) {   
    this.sink = sink
  }

  override fun onCancel(p0: Any?) {
    this.sink = null
  }

  private fun startDiscovery(result: Result,serviceType: String,enableUpdating: Boolean) {
    if(enableUpdating) {
      Log.w("MDNSPlugin", "startDiscovery: enableUpdating is currently ignored on the Android platform")
    }
    discoveryListener?.let {
      nsdManager?.stopServiceDiscovery(discoveryListener)
    }
    discoveryListener = DiscoveryListener(this);
    services.clear()
    nsdManager?.discoverServices(serviceType, NsdManager.PROTOCOL_DNS_SD, discoveryListener)
    result.success(null);
  }

  private fun stopDiscovery(result: Result) {
    nsdManager?.stopServiceDiscovery(discoveryListener)
    discoveryListener = null
    services.clear()
    result.success(null);
  }

  private fun resolveService(result: Result,name: String, resolve: Boolean) {
    if(services.containsKey(name)) {
      if(resolve) {
        nsdManager?.resolveService(services.get(name),ResolveListener(this));
      } else {
        services.remove(name)
      }
    } else {
      Log.w("MDNSPlugin", "resolveService: missing service with name $name")
    }
  }
}

class ResolveListener(val plugin: MDNSPlugin) : NsdManager.ResolveListener {
    override fun onServiceResolved(serviceInfo: NsdServiceInfo) {
      val serviceMap = MDNSPlugin.mapFromServiceInfo("onServiceResolved",serviceInfo)
      plugin.activity?.runOnUiThread(java.lang.Runnable {
        plugin.sink?.success(serviceMap)
      })
    }  
    override fun onResolveFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
      when (errorCode) {
        NsdManager.FAILURE_ALREADY_ACTIVE -> {
          // Resolve again after a short delay
          Timer("resolve", false).schedule(20) { 
            plugin.discoveryListener?.onServiceFound(serviceInfo)
          }
        }
        else ->
          Log.d("MDNSPlugin", "onResolveFailed: Error $errorCode: $serviceInfo")
      }
    }
}

class DiscoveryListener(val plugin: MDNSPlugin) : NsdManager.DiscoveryListener {
  override fun onDiscoveryStarted(serviceType: String?) {
    plugin.activity?.runOnUiThread(java.lang.Runnable {
      plugin.sink?.success(mapOf("method" to "onDiscoveryStarted"))
    })
  }
  override fun onDiscoveryStopped(serviceType: String) {
    plugin.activity?.runOnUiThread(java.lang.Runnable {
      plugin.sink?.success(mapOf("method" to "onDiscoveryStopped"))
    })
  }
  override fun onServiceFound(serviceInfo: NsdServiceInfo) {
    val serviceMap = MDNSPlugin.mapFromServiceInfo("onServiceFound",serviceInfo)
    val name = serviceInfo.getServiceName()
    name?.let {
      plugin.services.put(name,serviceInfo)
    }
    plugin.activity?.runOnUiThread(java.lang.Runnable {
      plugin.sink?.success(serviceMap)
    })
  }
  override fun onServiceLost(serviceInfo: NsdServiceInfo) {
    val serviceMap = MDNSPlugin.mapFromServiceInfo("onServiceRemoved",serviceInfo)
    plugin.services.remove(serviceInfo.getServiceName())
    plugin.activity?.runOnUiThread(java.lang.Runnable {
      plugin.sink?.success(serviceMap)
    })
  }
  override fun onStartDiscoveryFailed(serviceType: String?, errorCode: Int) {
    Log.d("MDNSPlugin", "onStartDiscoveryFailed: $serviceType: $errorCode")
  }
  override fun onStopDiscoveryFailed(serviceType: String?, errorCode: Int) {
    Log.d("MDNSPlugin", "onStopDiscoveryFailed: $serviceType: $errorCode")
  }
}
