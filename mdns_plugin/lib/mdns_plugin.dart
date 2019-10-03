import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

/////////////////////////////////////////////////////////////////////

/// MDNSPluginDelegate encapsulates the delegate functions called
/// reacting to messages from the local network
abstract class MDNSPluginDelegate {
  /// onDiscoveryStarted is called when discovery on the local
  /// network has started
  void onDiscoveryStarted();

  /// onDiscoveryStopped is called when discovery on the local network
  /// has stopped
  void onDiscoveryStopped();

  /// onServiceFound is called when a service on the local network
  /// has been discovered. Your function implementation should
  /// return true if you want the service to be resolved
  bool onServiceFound(MDNSService service);

  /// onServiceResolved is called when resolution has occurred,
  /// filling in the details (hostname, addresses, etc) of the service
  void onServiceResolved(MDNSService service);

  /// onServiceUpdated is called when a found service has updated the
  /// TXT record
  void onServiceUpdated(MDNSService service);

  /// onServiceRemoved is called when a found service has been removed
  /// from the local network
  void onServiceRemoved(MDNSService service);
}

/////////////////////////////////////////////////////////////////////

/// MDNSService encapsulates a service discovered on the local
/// network
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

  /// toUTFString decodes a TXT value into a UTF8 string
  static String toUTF8String(List<int> bytes) {
    if (bytes == null) {
      return null;
    } else {
      return Utf8Codec().decode(bytes);
    }
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

/// MDNSPlugin is the provider of the mDNS discovery from the local
/// network
class MDNSPlugin {
  static const MethodChannel _methodChannel =
      const MethodChannel('mdns_plugin');
  static const EventChannel _eventChannel =
      const EventChannel('mdns_plugin_delegate');
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
            var service = MDNSService.fromMap(args);
            this._resolveService(service,
                resolve: delegate.onServiceFound(service));
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

  /// platformVersion returns the underlying platform version of the
  /// running plugin
  static Future<String> get platformVersion async {
    return await _methodChannel.invokeMethod('getPlatformVersion');
  }

  /// startDiscovery is invoked to start discovery of services on
  /// the local network, for a serviceType, which should be, for
  /// example "_googlecast._tcp" or similar. When the optional
  /// enableUpdating flag is set to true, resolved services
  /// respond to updates to the TXT record for the service
  Future<void> startDiscovery(String serviceType,
      {bool enableUpdating = false}) async {
    return await _methodChannel.invokeMethod("startDiscovery",
        {"serviceType": serviceType, "enableUpdating": enableUpdating});
  }

  /// stopDiscovery should be invoked to shutdown the discovery
  /// of services on your local network
  Future<void> stopDiscovery() async {
    return await _methodChannel.invokeMethod('stopDiscovery', {});
  }

  // PRIVATE METHODS ////////////////////////////////////////////////

  Future<void> _resolveService(MDNSService service,
      {bool resolve = false}) async {
    _methodChannel.invokeMethod(
        'resolveService', {"name": service.name, "resolve": resolve});
  }
}
