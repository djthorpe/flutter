/*
	mDNS Browser
	Flutter client demonstrating browsing for items
	on the network

	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:zeroconf/zeroconf.dart';

/////////////////////////////////////////////////////////////////////

class ServiceItem {
  final Service service;

  // Constructor
  const ServiceItem(this.service) : assert(service != null);

  // Getters and setters
  String get name => this.service.name;
  String get host => this.service.host;
  int get port => this.service.port;
  List<String> get addresses => this.service.addresses;

  String get hostPort {
    if(this.service.host != null && this.service.port != 0) {
      return "${this.service.host}:${this.service.port}";
    } else {
      return null;
    }
  }

  @override
  String toString() => this.service.toString();
}

/////////////////////////////////////////////////////////////////////

class ServiceList {
  final List<ServiceItem> _items = [];

  void removeAllItems() {
    _items.clear();
  }

  int get count => _items.length;

  ServiceItem itemAtIndex(int i) {
    return _items[i];
  }

  int indexForItemWithName(String name) {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].name == name) {
        return i;
      }
    }
    // Return -1 in case name isn't found
    return -1;
  }

  ServiceItem add(Service service) {
    assert(service != null);
    var pos = this.indexForItemWithName(service.name);
    var obj = ServiceItem(service);
    if (pos == -1) {
      _items.add(obj);
    } else {
      _items[pos] = obj;
    }
    return obj;
  }

  ServiceItem remove(Service service) {
    assert(service != null);
    var pos = this.indexForItemWithName(service.name);
    if (pos >= 0) {
      return _items.removeAt(pos);
    } else {
      return null;
    }
  }
}
