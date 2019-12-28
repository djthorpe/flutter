/*
  Cast Client
  Copyright (c) David Thorpe 2019-2020
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

abstract class AppState {}

class AppStateUninitialized extends AppState {
  @override
  String toString() => 'AppStateUninitialized';
}

/////////////////////////////////////////////////////////////////////
// BLOC

class AppBloc extends Bloc<AppEvent, AppState> {

  // EVENT MAPPING //////////////////////////////////////////////////

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {

  }

  // GETTERS AND SETTERS ////////////////////////////////////////////

  @override
  AppState get initialState => AppStateUninitialized();
}

