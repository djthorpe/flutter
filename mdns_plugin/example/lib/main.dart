import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mdns_plugin/mdns_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppDelegate implements MDNSPluginDelegate {

  void onDiscoveryStarted() {
      print("Discovery started");
  }
  void onDiscoveryStopped() {
      print("Discovery stopped");
  }
  void onServiceFound(MDNSService service) {
      print("Found: $service");
  }
  void onServiceResolved(MDNSService service) {
      print("Resolved: $service");
  }
  void onServiceUpdated(MDNSService service) {
      print("Updated: $service");
  }
  void onServiceRemoved(MDNSService service) {
      print("Removed: $service");
  }
}

class _MyAppState extends State<MyApp>  {
  String _platformVersion = 'Unknown';
  MDNSPlugin _mdns = new MDNSPlugin(_MyAppDelegate());

  @override
  void initState() {
    super.initState();
    initPlatformState();
    startDiscovery();
  }

  void startDiscovery() {      
    _mdns.startDiscovery("_googlecast._tcp").then((_) {
      print("Discovery started");
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MDNSPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
