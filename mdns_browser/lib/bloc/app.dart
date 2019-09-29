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
// STATE

class AppState {
  final ServiceList services;

  AppState(ServiceList services) : services = services;
}

class AppStateUninitialized extends AppState {
  AppStateUninitialized(ServiceList services) : super(services);

  @override
  String toString() => 'AppStateUninitialized';
}

class AppStarted extends AppState {
  AppStarted(ServiceList services) : super(services);

  @override
  String toString() => 'AppStarted';
}


class AppUpdatedServiceList extends AppState {
  AppUpdatedServiceList(ServiceList services) : super(services);

  @override
  String toString() => 'AppUpdatedServiceList(items=${services.count})';
}

/////////////////////////////////////////////////////////////////////
// BLOC

class AppBloc extends Bloc<AppEvent, AppState> implements DiscoveryDelegate {
  Discovery _discovery;

  AppBloc() : super() {
     _discovery = Discovery(delegate: this,type: "_googlecast._tcp");
  }

  void onScanStarted() {
    this.dispatch(AppEventScanStarted());
  }
  void onScanStopped() {
    this.dispatch(AppEventScanStopped());
  }
  void onServiceFound(ServiceItem srv) {
    this.dispatch(AppEventServiceFound(srv));
  }
  void onServiceLost(ServiceItem srv) {
    this.dispatch(AppEventServiceLost(srv));
  }
  void onScanError() {
    this.dispatch(AppEventScanError());
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppEventStart) {
      // Start discovery
      _discovery.start();
      // Set AppStarted state
      yield AppStarted(_discovery.services);
    }
    if (event is AppEventServiceFound) {
      yield AppUpdatedServiceList(_discovery.services);
    }
    if (event is AppEventServiceLost) {
      yield AppUpdatedServiceList(_discovery.services);
    }
    if (event is AppEventScanError) {
      // Stop discovery
      _discovery.stop();
      yield AppStateUninitialized(_discovery.services);
    }
  }

  // Getters and setters
  @override
  AppState get initialState => AppStateUninitialized(null);
}


