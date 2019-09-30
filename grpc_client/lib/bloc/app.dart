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
  final String hostName;
  final int portNumber;

  AppEventConnect(this.hostName,this.portNumber) : super();

  @override
  String toString() => 'AppEventConnect($hostName:$portNumber)';
}

class AppEventConnectError extends AppEvent {
  final Exception exception;

  AppEventConnectError(this.exception) : super();

  @override
  String toString() => 'AppEventConnectError($exception)';
}

/////////////////////////////////////////////////////////////////////
// STATE

enum ConnectState {
  Disconnected, Connecting, Connected, Error
}

class AppState {}

class AppStateUninitialized extends AppState {
  @override
  String toString() => 'AppStateUninitialized';
}

class AppStateConnect extends AppState {
  final ConnectState state;
  final Exception exception;

  AppStateConnect(this.state,{this.exception}) : super();

  @override
  String toString() => 'AppStateConnect($state,$exception)';
}

class AppStateStarted extends AppState {
  @override
  String toString() => 'AppStateStarted';
}

/////////////////////////////////////////////////////////////////////
// BLOC

class AppBloc extends Bloc<AppEvent, AppState> {
  final HelloWorld _helloworld = HelloWorld();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {

    // Set state to disconnected on start
    if (event is AppEventStart) {
      yield AppStateConnect(ConnectState.Disconnected);
    }

    // Connect
    if (event is AppEventConnect) {
      yield AppStateConnect(ConnectState.Connecting);
      try {
        await _helloworld.connect(event.hostName,event.portNumber);
        yield AppStateStarted();
      } catch(e) {
        yield AppStateConnect(ConnectState.Error,exception: e);
      }
    }
  }

  // Getters and setters
  @override
  AppState get initialState => AppStateUninitialized();
}
