/*
	mDNS Browser
	Flutter client demonstrating browsing for items
	on the network

	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:mdns_browser/models/service.dart';
import 'package:mdns_browser/provider/discovery.dart';
import 'package:bloc/bloc.dart';

/////////////////////////////////////////////////////////////////////
// EVENT

abstract class AppEvent {}

class AppEventStart extends AppEvent {
  @override
  String toString() => 'AppEventStart';
}

class AppEventScanStarted extends AppEvent {
  @override
  String toString() => 'AppEventScanStarted';
}

class AppEventScanStopped extends AppEvent {
  @override
  String toString() => 'AppEventScanStopped';
}

class AppEventScanError extends AppEvent {
  @override
  String toString() => 'AppEventScanError';
}

class AppEventServiceFound extends AppEvent {
  AppEventServiceFound(this.service) : assert(service != null);

  @override
  String toString() => 'AppEventServiceFound: $service';

  ServiceItem service;
}

class AppEventServiceLost extends AppEvent {

  AppEventServiceLost(this.service) : assert(service != null);

  @override
  String toString() => 'AppEventServiceLost: $service';

  ServiceItem service;
}

/////////////////////////////////////////////////////////////////////
// BLOC

class AppBloc extends Bloc<AppEvent, int> {
  Discovery discovery;

  AppBloc() : super() {
     discovery = Discovery(services: Services(this), type: "_googlecast._tcp");
  }

  @override
  Stream<int> mapEventToState(AppEvent event) async* {
    if (event is AppEventStart) {
      yield 1;
    }
    if (event is AppEventServiceFound) {
      yield 2;
    }
    if (event is AppEventServiceLost) {
      yield 3;
    }
    if (event is AppEventScanError) {
      yield 4;
    }
  }

  // Getters and setters
  @override
  int get initialState => 0;
}
