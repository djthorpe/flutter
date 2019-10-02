/*
  mDNS Plugin Example
  Flutter client demonstrating browsing for Chromecasts
  on your local network

  Copyright (c) David Thorpe 2019
  Please see the LICENSE file for licensing information
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mdns_plugin/mdns_plugin.dart';
import 'package:mdns_plugin_example/src/pages/service_list.dart';
import 'package:mdns_plugin_example/src/bloc/app.dart';

/////////////////////////////////////////////////////////////////////

void main() {
  runApp(BlocProvider<AppBloc>(
      builder: (context) {
        return AppBloc()..dispatch(AppEventStart());
      },
      child: MyApp()));
}

/////////////////////////////////////////////////////////////////////

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  // CONSTRUCTORS ///////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // METHODS ////////////////////////////////////////////////////////

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
              title: const Text('Chromecast Browser'),
            ),
            body: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
              if (state is AppStateUninitialized) {
                return Placeholder();
              } else {
                return ServiceList();
              }
            })));
  }
}
