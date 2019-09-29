/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:bloc/bloc.dart';
import 'package:grpc_client/providers/helloworld.dart';

/////////////////////////////////////////////////////////////////////
// EVENT

abstract class AppEvent {}

class AppEventStart extends AppEvent {
  @override
  String toString() => 'AppEventStart';
}

class AppEventConnect extends AppEvent {
  @override
  String toString() => 'AppEventConnect';
}

class AppEventConnectError extends AppEvent {
  final Exception exception;

  AppEventConnectError(Exception e)
      : exception = e,
        super();

  @override
  String toString() => 'AppEventConnectError';
}

/////////////////////////////////////////////////////////////////////
// STATE

class AppState {}

class AppStateUninitialized extends AppState {
  @override
  String toString() => 'AppStateUninitialized';
}

class AppConnect extends AppState {
  @override
  String toString() => 'AppConnect';
}

class AppStarted extends AppState {
  @override
  String toString() => 'AppStarted';
}

class AppDisconnect extends AppState {
  @override
  String toString() => 'AppDisconnect';
}

/////////////////////////////////////////////////////////////////////
// BLOC

class AppBloc extends Bloc<AppEvent, AppState> {
  final HelloWorld _helloworld = HelloWorld();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppEventStart) {
      yield AppConnect();
    }
    if (event is AppEventConnect) {
      // Connect to gRPC
      try {
        await _helloworld.connect("127.0.0.2", 8080);
        print("connected");
      } catch(e) {
        print("not connected");
        this.dispatch(AppEventConnectError(e));
      }
    }

    if (event is AppEventConnectError) {
      var evt = event as AppEventConnectError;
      print("Error: ${evt.exception}");
      yield AppConnect();
    }
  }

  // Getters and setters
  @override
  AppState get initialState => AppStateUninitialized();
}
