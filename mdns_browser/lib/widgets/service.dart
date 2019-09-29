/*
	mDNS Browser
	Flutter client demonstrating browsing for items
	on the network

	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  final String titleValue;
  final String subtitleValue;

  const ServiceItem({Key key, @required this.titleValue, this.subtitleValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      title: Text(titleValue),
      subtitle: Text(subtitleValue ?? ""),
      trailing: Icon(Icons.signal_wifi_4_bar, color: Colors.green),
    );
  }
}

