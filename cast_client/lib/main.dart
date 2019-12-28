/*
  Cast Client
  Copyright (c) David Thorpe 2019-2020
  Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cast_client/src/bloc/app.dart';

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

  // CONSTRUCTORS ///////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
  }

  // METHODS ////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Cast Client'),
            ),
            body: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
              if (state is AppStateUninitialized) {
                return Placeholder();
              } else {
                return Text("Hello, world");
              }
            })));
  }
}

