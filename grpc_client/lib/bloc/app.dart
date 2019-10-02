/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:bloc/bloc.dart';
import 'package:grpc_client/providers/helloworld.dart';
import 'package:grpc_client/providers/reflection.dart';
import 'package:grpc_client/providers/defaults.dart';

/////////////////////////////////////////////////////////////////////
// EVENT

abstract class AppEvent {}

enum AppEventMethod {
  SayHello, Ping
}

class AppEventStart extends AppEvent {
  @override
  String toString() => 'AppEventStart';
}

class AppEventConnect extends AppEvent {
  final String hostName;
  final int portNumber;
  final bool secure;

  AppEventConnect(this.hostName,this.portNumber,this.secure) : super();

  @override
  String toString() => 'AppEventConnect($hostName:$portNumber secure=$secure)';
}

class AppEventConnectError extends AppEvent {
  final Exception exception;

  AppEventConnectError(this.exception) : super();

  @override
  String toString() => 'AppEventConnectError($exception)';
}

class AppEventDisconnect extends AppEvent {
  @override
  String toString() => 'AppEventDisconnect';
}

class AppEventCall extends AppEvent {
  final AppEventMethod method;
  final String name;

  AppEventCall(this.method,{this.name}) : super();

  @override
  String toString() => 'AppEventCall($method,$name)';
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
  final Defaults defaults;

  AppStateConnect(this.state,{this.exception,this.defaults}) : super();

  @override
  String toString() => 'AppStateConnect($state,$exception)';
}

class AppStateStarted extends AppState {
  final String message;

  AppStateStarted({this.message});

  @override
  String toString() => 'AppStateStarted($message)';
}

/////////////////////////////////////////////////////////////////////
// BLOC

class AppBloc extends Bloc<AppEvent, AppState> {
  final HelloWorld _helloworld = HelloWorld();
  final ReflectionClient _reflection = ReflectionClient();
  final Defaults _defaults = Defaults();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    // Set state to disconnected on start
    if (event is AppEventStart) {
      // Load in preferences
      await _defaults.loadAll();   
      // Yield to connect
      yield AppStateConnect(ConnectState.Disconnected,defaults: _defaults);
    }

    // Connect
    if (event is AppEventConnect) {
      yield AppStateConnect(ConnectState.Connecting,defaults: _defaults);
      try {
        await _helloworld.connect(event.hostName,event.portNumber,secure: event.secure);
        await _reflection.connect(event.hostName,event.portNumber,secure: event.secure);
        yield AppStateStarted();
      } catch(e) {
        yield AppStateConnect(ConnectState.Error,exception: e,defaults: _defaults);
      }
    }

    // Disconnect
    if (event is AppEventDisconnect) {
      try {
        _helloworld.disconnect();
        yield AppStateConnect(ConnectState.Disconnected,defaults: _defaults);
      } catch(e) {
        yield AppStateConnect(ConnectState.Error,exception: e,defaults: _defaults);
      }
    }

    // Call SayHello
    if (event is AppEventCall && event.method == AppEventMethod.SayHello) {
      try {
        var response = await _helloworld.sayHello(event.name);
        yield AppStateStarted(message: response.message);
      } catch(e) {
        yield AppStateConnect(ConnectState.Error,exception: e,defaults: _defaults);
      }
    }

  }

  // Getters and setters
  @override
  AppState get initialState => AppStateUninitialized();

  List<String> get services => _reflection.services;
  String get hostName => _defaults.hostName;
  int get portNumber => _defaults.portNumber;
}
