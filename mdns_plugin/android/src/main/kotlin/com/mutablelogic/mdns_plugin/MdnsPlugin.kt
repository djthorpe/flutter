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

class MDNSPlugin : MethodCallHandler,StreamHandler {
  private var nsdManager: NsdManager? = null
  private var started: Boolean = false
  var sink: EventSink? = null
  var activity: Activity? = null

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
        // TODO ADDRESSES
      }
      return map
    }
  }

  constructor(registrar: Registrar) {
    nsdManager = registrar.activity().getSystemService(Context.NSD_SERVICE) as NsdManager
    activity = registrar.activity()
    EventChannel(registrar.messenger(), "mdns_plugin_delegate").setStreamHandler(this)
  }

  val discoveryListener: NsdManager.DiscoveryListener =  object : NsdManager.DiscoveryListener {
    override fun onDiscoveryStarted(serviceType: String?) {
      this@MDNSPlugin.activity?.runOnUiThread(java.lang.Runnable {
        this@MDNSPlugin.sink?.success(mapOf("method" to "onDiscoveryStarted"))
      })
    }
    override fun onDiscoveryStopped(serviceType: String) {
      this@MDNSPlugin.activity?.runOnUiThread(java.lang.Runnable {
        this@MDNSPlugin.sink?.success(mapOf("method" to "onDiscoveryStopped"))
      })
    }
    override fun onServiceFound(serviceInfo: NsdServiceInfo?) {
      serviceInfo?.let {
        this@MDNSPlugin.nsdManager?.resolveService(serviceInfo,ResolveListener(this@MDNSPlugin));
        this@MDNSPlugin.activity?.runOnUiThread(java.lang.Runnable {
          this@MDNSPlugin.sink?.success(mapFromServiceInfo("onServiceFound",serviceInfo))
        })
      }
    }
    override fun onServiceLost(serviceInfo: NsdServiceInfo?) {
      serviceInfo?.let {
        this@MDNSPlugin.activity?.runOnUiThread(java.lang.Runnable {
          this@MDNSPlugin.sink?.success(mapFromServiceInfo("onServiceRemoved",serviceInfo))
        })
      }
    }
    override fun onStartDiscoveryFailed(serviceType: String?, errorCode: Int) {
      Log.d("MDNSPlugin", "onStartDiscoveryFailed: $serviceType: $errorCode")
    }
    override fun onStopDiscoveryFailed(serviceType: String?, errorCode: Int) {
      Log.d("MDNSPlugin", "onStopDiscoveryFailed: $serviceType: $errorCode")
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "startDiscovery" -> {
        startDiscovery(result)
      }
      "stopDiscovery" -> {
        stopDiscovery(result)
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

  private fun startDiscovery(result: Result) {
    if(this.started == true) {
      nsdManager?.stopServiceDiscovery(discoveryListener)
    }
    // TODO ALLOW FOR OTHER SERVICE TYPES
    nsdManager?.discoverServices("_googlecast._tcp", NsdManager.PROTOCOL_DNS_SD, discoveryListener)
    this.started = true
    result.success(null);
  }

  private fun stopDiscovery(result: Result) {
    nsdManager?.stopServiceDiscovery(discoveryListener)
    this.started = false
    result.success(null);
  }
}

class ResolveListener(val plugin: MDNSPlugin) : NsdManager.ResolveListener {
    override fun onServiceResolved(serviceInfo: NsdServiceInfo?) {
      var serviceInfo = MDNSPlugin.mapFromServiceInfo("onServiceResolved",serviceInfo)
      plugin.activity?.runOnUiThread(java.lang.Runnable {
        plugin.sink?.success(serviceInfo)
      })
    }  
    override fun onResolveFailed(serviceInfo: NsdServiceInfo?, errorCode: Int) {
      Log.d("MDNSPlugin", "onResolveFailed: $serviceInfo: $errorCode")
    }
}

