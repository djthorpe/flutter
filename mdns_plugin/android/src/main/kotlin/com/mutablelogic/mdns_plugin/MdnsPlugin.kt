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
  private var sink: EventSink? = null
  private var activity: Activity? = null

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      MethodChannel(registrar.messenger(), "mdns_plugin").setMethodCallHandler(MDNSPlugin(registrar))      
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
        this@MDNSPlugin.nsdManager?.resolveService(serviceInfo,ResolveListener());
        this@MDNSPlugin.activity?.runOnUiThread(java.lang.Runnable {
          // TODO - make argument map
          this@MDNSPlugin.sink?.success(mapOf("method" to "onServiceFound","name" to serviceInfo?.getServiceName()))
        })
      }
    }
    override fun onServiceLost(serviceInfo: NsdServiceInfo?) {
      serviceInfo?.let {
        this@MDNSPlugin.nsdManager?.resolveService(serviceInfo,ResolveListener());
        this@MDNSPlugin.activity?.runOnUiThread(java.lang.Runnable {
          // TODO - make argument map
          this@MDNSPlugin.sink?.success(mapOf("method" to "onServiceRemoved","name" to serviceInfo?.getServiceName()))
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
    nsdManager?.discoverServices("_googlecast._tcp", NsdManager.PROTOCOL_DNS_SD, discoveryListener)
    result.success(null);
  }

  private fun stopDiscovery(result: Result) {
    nsdManager?.stopServiceDiscovery(discoveryListener)
    result.success(null);
  }

}

class ResolveListener : NsdManager.ResolveListener {
    override fun onServiceResolved(serviceInfo: NsdServiceInfo?) {
      Log.d("MDNSPlugin", "onServiceResolved: $serviceInfo")
    }  
    override fun onResolveFailed(serviceInfo: NsdServiceInfo?, errorCode: Int) {
      Log.d("MDNSPlugin", "onResolveFailed: $serviceInfo: $errorCode")
    }
}

