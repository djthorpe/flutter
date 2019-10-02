package com.mutablelogic.mdns_plugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.app.Activity
import android.util.Log

class MDNSPlugin(registrar: Registrar): MethodCallHandler, StreamHandler {
  private var sink: EventSink? = null

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val plugin = MDNSPlugin(registrar)

      val method_channel = MethodChannel(registrar.messenger(), "mdns_plugin")
      method_channel.setMethodCallHandler(plugin)
      
      val event_channel = EventChannel(registrar.messenger(), "mdns_plugin_delegate")
      event_channel.setStreamHandler(plugin)
    }
  }

  init {
    registrar.addViewDestroyListener {
      onCancel(null)
      false
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
    if (this.sink == null) {
      this.sink = sink
    }
  }

  override fun onCancel(p0: Any?) {
    this.sink = null
  }

  private fun startDiscovery(result: Result) {
    this.sink?.success(mapOf("method" to "onDiscoveryStarted"))
    result.success(null);
  }

  private fun stopDiscovery(result: Result) {
    this.sink?.success(mapOf("method" to "onDiscoveryStopped"))
    result.success(null);
  }
}

