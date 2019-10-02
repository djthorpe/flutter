/*
  mDNS Plugin Example
  Flutter client demonstrating browsing for Chromecasts
  on your local network

  Copyright (c) David Thorpe 2019
  Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:mdns_plugin/mdns_plugin.dart';

/////////////////////////////////////////////////////////////////////

class ServiceTile extends StatelessWidget {
  final MDNSService service;

  // CONSTRUCTORS ///////////////////////////////////////////////////

  ServiceTile(this.service) : assert(service != null);

  // WIDGET BUILDER /////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
        leading: _icon,
        title: Text(_title),
        subtitle: Text(_subtitle));
  }

  // PROPERTIES /////////////////////////////////////////////////////

  Widget get _icon {
    var iconData = Icons.computer;
    var iconColor = Colors.black;
    if (_isChromecast) {
      switch (_chromecastModel) {
        case "Chromecast Audio":
          iconData = Icons.audiotrack;
          break;
        case "Google Home":
        case "Google Home Mini":
          iconData = Icons.home;
          break;
        case "Chromecast":
          iconData = Icons.tv;
          break;
        case "Google Cast Group":
          iconData = Icons.speaker_group;
          break;
        case "":
          break;
        default:
          print("TODO: Add icon for $_chromecastModel");
      }
      if (_chromecastState > 0) {
        iconColor = Colors.green;
      }
    }
    return Icon(iconData, color: iconColor, size: 36.0);
  }

  String get _title => _isChromecast && _chromecastName.length > 0
      ? _chromecastName
      : service.name;
  String get _subtitle =>
      _isChromecast && _chromecastName.length > 0 ? _chromecastApp : _hostName;
  bool get _isChromecast => (service.serviceType == "_googlecast._tcp.");
  String get _chromecastName =>
      MDNSService.toUTF8String(service.txt["fn"]) ?? "";
  String get _chromecastModel =>
      MDNSService.toUTF8String(service.txt["md"]) ?? "";
  String get _chromecastApp =>
      MDNSService.toUTF8String(service.txt["rs"]) ?? "";
  String get _hostName => service.hostName.length > 0 && service.port > 0
      ? "${service.hostName}:${service.port}"
      : "";
  int get _chromecastState =>
      int.parse(MDNSService.toUTF8String(service.txt["st"]) ?? "0");
}
