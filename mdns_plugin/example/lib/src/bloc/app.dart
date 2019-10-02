/*
  mDNS Plugin Example
  Flutter client demonstrating browsing for Chromecasts
  on your local network

  Copyright (c) David Thorpe 2019
  Please see the LICENSE file for licensing information
*/

import 'package:bloc/bloc.dart';

import 'package:mdns_plugin/mdns_plugin.dart';
import 'package:mdns_plugin_example/src/models/service_list.dart';

/////////////////////////////////////////////////////////////////////
// EVENT

enum AppEventDiscoveryState {
  Started, Stopped
}

enum AppEventServiceState {
  Found, Resolved, Updated, Removed
}

abstract class AppEvent {}

class AppEventStart extends AppEvent {
  @override
  String toString() => 'AppEventStart';
}

class AppEventDiscovery extends AppEvent {
  AppEventDiscoveryState state;

  // CONSTRUCTOR ////////////////////////////////////////////////////

  AppEventDiscovery(this.state);

  // GETTERS AND SETTERS ////////////////////////////////////////////

  @override
  String toString() => 'AppEventDiscovery($state)';
}

class AppEventService extends AppEvent {
  AppEventServiceState state;
  MDNSService service;

  // CONSTRUCTOR ////////////////////////////////////////////////////

  AppEventService(this.state,this.service);

  // GETTERS AND SETTERS ////////////////////////////////////////////

  @override
  String toString() => 'AppEventService($state,$service)';
}

/////////////////////////////////////////////////////////////////////
// STATE

abstract class AppState {}

class AppStateUninitialized extends AppState {
  @override
  String toString() => 'AppStateUninitialized';
}

class AppStarted extends AppState {
  @override
  String toString() => 'AppStarted';
}

class AppUpdated extends AppState {
  ServiceList services;
  MDNSService service;

  // CONSTRUCTOR ////////////////////////////////////////////////////

  AppUpdated(this.services,{this.service});

  // GETTERS AND SETTERS ////////////////////////////////////////////

  @override
  String toString() => 'AppUpdated($service)';
}

/////////////////////////////////////////////////////////////////////
// BLOC

class AppBloc extends Bloc<AppEvent, AppState> implements MDNSPluginDelegate {
  MDNSPlugin _mdns;
  ServiceList _services = ServiceList();

  // EVENT MAPPING //////////////////////////////////////////////////

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if(event is AppEventStart) {
      // Start discovery
      _mdns = MDNSPlugin(this);
      await _mdns.startDiscovery("_googlecast._tcp");
    }

    if(event is AppEventDiscovery) {
      // Remove all services and update the application
      _services.removeAll();
      yield AppUpdated(_services);
    }

    if(event is AppEventService) {
      switch(event.state) {
        case AppEventServiceState.Found:
          _services.add(event.service);
          break;
        case AppEventServiceState.Updated:
          _services.update(event.service);
          break;
        case AppEventServiceState.Resolved:
          _services.update(event.service);
          break;
        case AppEventServiceState.Removed:
          _services.remove(event.service);
          break;
      }      
      yield AppUpdated(_services,service: event.service);
    }


  }

  // MDNS PLUGIN DELEGATE  //////////////////////////////////////////

  void onDiscoveryStarted() => this.dispatch(AppEventDiscovery(AppEventDiscoveryState.Started));
  void onDiscoveryStopped() => this.dispatch(AppEventDiscovery(AppEventDiscoveryState.Stopped));
  void onServiceFound(MDNSService service) => this.dispatch(AppEventService(AppEventServiceState.Found,service)); 
  void onServiceResolved(MDNSService service) => this.dispatch(AppEventService(AppEventServiceState.Resolved,service)); 
  void onServiceUpdated(MDNSService service)  => this.dispatch(AppEventService(AppEventServiceState.Updated,service)); 
  void onServiceRemoved(MDNSService service)  => this.dispatch(AppEventService(AppEventServiceState.Removed,service)); 

  // GETTERS AND SETTERS ////////////////////////////////////////////

  @override
  AppState get initialState => AppStateUninitialized();
}

