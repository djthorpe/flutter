/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:bloc/bloc.dart';


/////////////////////////////////////////////////////////////////////
// EVENT

abstract class AppEvent {}

class AppEventStart extends AppEvent {
  @override
  String toString() => 'AppEventStart';
}

/////////////////////////////////////////////////////////////////////
// STATE

class AppState { }

class AppStateUninitialized extends AppState {
  @override
  String toString() => 'AppStateUninitialized';
}

class AppStarted extends AppState {
  @override
  String toString() => 'AppStarted';
}

/////////////////////////////////////////////////////////////////////
// BLOC

class AppBloc extends Bloc<AppEvent, AppState>{
  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppEventStart) {
      // Set AppStarted state
      yield AppStarted();
    }
  }

  // Getters and setters
  @override
  AppState get initialState => AppStateUninitialized();
}

