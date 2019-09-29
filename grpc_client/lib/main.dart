/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:grpc_client/bloc/app.dart';
import 'package:grpc_client/pages/main.dart';

/////////////////////////////////////////////////////////////////////

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(BlocProvider<AppBloc>(
      builder: (context) {
        return AppBloc()..dispatch(AppEventStart());
      },
      child: App()));
}

/////////////////////////////////////////////////////////////////////

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print("Event <$event>");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print("Transition <$transition>");
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('Error $error, $stacktrace');
  }
}

/////////////////////////////////////////////////////////////////////

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final AppBloc _appBloc = BlocProvider.of<AppBloc>(context);
    return MaterialApp(
        title: 'gRPC Client',
        home: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
          if (state is AppStateUninitialized) {
            return Placeholder();
          } else if (state is AppConnect) {
            return Scaffold(
                body: Center(
                    child: RaisedButton(
                        child: Text("Connect"), onPressed: () {
                          _appBloc.dispatch(AppEventConnect());
                        })));
          } else if (state is AppEventConnectError) {
            return Scaffold(
                body: Center(
                    child: RaisedButton(
                        child: Text("Error"), onPressed: () {
                          _appBloc.dispatch(AppEventConnect());
                        })));
          } else {
            return Main();
          }
        }));
  }
}
