/*
	mDNS Browser
	Flutter client demonstrating browsing for items
	on the network

	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdns_browser/bloc/app.dart';
import 'package:mdns_browser/pages/main.dart';

/////////////////////////////////////////////////////////////////////

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

/////////////////////////////////////////////////////////////////////

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('$error, $stacktrace');
  }
}

/////////////////////////////////////////////////////////////////////

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AppBloc appBloc;

  @override
  void initState() {
    super.initState();
    appBloc = AppBloc();
    appBloc.dispatch(AppEventStart());
  }

  @override
  void dispose() {
    appBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mDNS Browser',
      home: BlocProvider<AppBloc>(
        builder: (context) => appBloc,
        child: Main(),
      ),
    );
  }
}
