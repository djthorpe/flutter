/*
  mDNS Plugin Example
  Flutter client demonstrating browsing for Chromecasts
  on your local network

  Copyright (c) David Thorpe 2019
  Please see the LICENSE file for licensing information
*/

import 'package:mdns_plugin/mdns_plugin.dart';

/////////////////////////////////////////////////////////////////////

class ServiceList {
  List<MDNSService> _list = List<MDNSService>();

  // METHODS ////////////////////////////////////////////////////////

  void removeAll() {
    _list.clear();
  }

  void add(MDNSService service) {
    assert(service != null);
    var pos = _indexForItem(service);
    if (pos == -1) {
      _list.add(service);
    } else {
      _list[pos] = service;
    }
  }

  void update(MDNSService service) {
    this.add(service);
  }

  MDNSService remove(MDNSService service) {
    assert(service != null);
    var pos = _indexForItem(service);
    if (pos >= 0) {
      return _list.removeAt(pos);
    } else {
      return null;
    }
  }

  // PRIVATE METHODS ////////////////////////////////////////////////

  int _indexForItem(MDNSService service) {
    // We key items by their name
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].name == service.name) {
        return i;
      }
    }
    // Return -1 in case name isn't found
    return -1;
  }

  // GETTERS AND SETTERS ////////////////////////////////////////////

  MDNSService itemAtIndex(int index) => _list[index];

  int get count => _list.length;
}
