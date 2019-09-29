/*
	mDNS Browser
	Flutter client demonstrating browsing for items
	on the network

	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:zeroconf/zeroconf.dart';
import 'package:mdns_browser/models/service.dart';

/////////////////////////////////////////////////////////////////////

abstract class DiscoveryDelegate {
  void onScanStarted();
  void onScanStopped();
  void onServiceFound(ServiceItem srv);
  void onServiceLost(ServiceItem srv);
  void onScanError();
}

class Discovery {
  final ServiceList services = ServiceList();
  final String type;
  Zeroconf _zeroconf;
  DiscoveryDelegate delegate;

  Discovery({this.delegate,this.type}) : assert(type != null) {
    _zeroconf = Zeroconf(onScanStarted: onScanStarted,onScanStopped: onScanStopped,onServiceFound: onServiceFound,onServiceLost: onServiceLost,onServiceResolved:onServiceFound );
  }

  void dispose() async {
    stop();
  }

  void start() async {
    _zeroconf.startScan(type: type);
  }

  void stop() async {
    _zeroconf.stopScan();
  }

  void onScanStarted() {
    services.removeAllItems();
    delegate.onScanStarted();
  }

  void onScanStopped() {
    services.removeAllItems();
    delegate.onScanStopped();
  }

  void onServiceFound(Service srv) {
    delegate.onServiceFound(services.add(srv));
  }

  void onServiceLost(Service srv) {
    delegate.onServiceLost(services.remove(srv));
  }

  void onScanError() {
    delegate.onScanError();
  }
}

