/*
	mDNS Browser
	Flutter client demonstrating browsing for items
	on the network

	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:mdns_browser/pages/services.dart';

/////////////////////////////////////////////////////////////////////

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _tabController(),
      ),
    );
  }

  Widget _tabController() => DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "SERVERS"),
              ],
            ),
            title: Text('mDNS Browser'),
          ),
          body: TabBarView(
            children: [
              Services(),
            ],
          ),
        ),
      );
}
