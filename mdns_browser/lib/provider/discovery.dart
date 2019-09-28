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

class Discovery {
  final Services services;
  Zeroconf _zeroconf;

  Discovery({this.services, type}) : assert(type != null && services != null) {
    _zeroconf = Zeroconf(
        onScanStarted: onScanStarted,
        onScanStopped: onScanStopped,
        onServiceResolved: onServiceFound,
        onServiceLost: onServiceLost,
        onError: onScanError);

    // Start scanning
    _zeroconf.startScan(type: type);
  }

  void dispose() async {
    // Stop scanning
    _zeroconf.stopScan();
  }

  // Scanning callbacks
  onScanStarted() => services.serviceScanStarted();
  onScanStopped() => services.serviceScanStopped();
  onServiceFound(Service srv) => services.serviceFound(srv);
  onServiceLost(Service srv) => services.serviceLost(srv);
  onScanError() => services.serviceScanError();
}
