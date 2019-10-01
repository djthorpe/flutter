import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

/////////////////////////////////////////////////////////////////////

abstract class MDNSPluginDelegate {
  void onDiscoveryStarted();
  void onDiscoveryStopped();
  void onServiceFound(MDNSService service);
  void onServiceResolved(MDNSService service);
  void onServiceUpdated(MDNSService service);
  void onServiceRemoved(MDNSService service);
}

/////////////////////////////////////////////////////////////////////

class MDNSService {
  final Map map;

  // CONSTRUCTORS ///////////////////////////////////////////////////

  MDNSService.fromMap(this.map) : assert(map != null);

  // PROPERTIES /////////////////////////////////////////////////////

  String get name => map["name"];
  String get hostName => map["hostName"];
  String get serviceType => map["type"];
  int get port => map["port"];
  Map get txt => map["txt"];
  List<String> get addresses {
    var addresses = map["address"];
    if (addresses is List<dynamic>) {
      var address = List<String>();
      addresses.forEach((value) {
        if (value.length == 2 && value[0] is String) {
          address.add(value[0]);
        }
      });
      return address;
    } else {
      return [];
    }
  }

  // METHODS ////////////////////////////////////////////////////////

  static String toUTF8String(List<int> bytes) {
    return Utf8Codec().decode(bytes);
  }

  String toString() {
    var parts = "";
    if (name != "") {
      parts = parts + "name='$name' ";
    }
    if (serviceType != "") {
      parts = parts + "serviceType='$serviceType' ";
    }
    if (hostName != "" && port > 0) {
      parts = parts + "host='$hostName:$port' ";
    }
    if (addresses.length > 0) {
      parts = parts + "addresses=$addresses ";
    }
    txt.forEach((k, v) {
      var vstr = toUTF8String(v);
      parts = parts + "$k='$vstr' ";
    });
    return "<MDNSService>{ $parts}";
  }
}

/////////////////////////////////////////////////////////////////////

class MDNSPlugin {
  static const MethodChannel _methodChannel =
      const MethodChannel('mdns_plugin');
  final EventChannel _eventChannel = const EventChannel('mdns_plugin_delegate');
  final MDNSPluginDelegate delegate;

  // CONSTRUCTORS ///////////////////////////////////////////////////

  MDNSPlugin(this.delegate) : assert(delegate != null) {
    _eventChannel.receiveBroadcastStream().listen((args) {
      if (args is Map && args.containsKey("method")) {
        switch (args["method"]) {
          case "onDiscoveryStarted":
            delegate.onDiscoveryStarted();
            break;
          case "onDiscoveryStopped":
            delegate.onDiscoveryStopped();
            break;
          case "onServiceFound":
            delegate.onServiceFound(MDNSService.fromMap(args));
            break;
          case "onServiceResolved":
            delegate.onServiceResolved(MDNSService.fromMap(args));
            break;
          case "onServiceUpdated":
            delegate.onServiceUpdated(MDNSService.fromMap(args));
            break;
          case "onServiceRemoved":
            delegate.onServiceRemoved(MDNSService.fromMap(args));
            break;
        }
      }
    });
  }

  // METHODS ////////////////////////////////////////////////////////

  static Future<String> get platformVersion async {
    final String version =
        await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> startDiscovery(String serviceType, {String domain}) async {
    return await _methodChannel.invokeMethod(
        "startDiscovery", {"serviceType": serviceType, "domain": domain});
  }

  Future<void> stopDiscovery() async {
    return await _methodChannel.invokeMethod('stopDiscovery', {});
  }
}
