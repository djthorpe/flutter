/*
	mDNS Browser
	Flutter client demonstrating browsing for items
	on the network

	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdns_browser/bloc/app.dart';

/////////////////////////////////////////////////////////////////////

class Services extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _bloc(context),
      ),
    );
  }

  Widget _bloc(BuildContext context) => BlocBuilder(
        bloc: BlocProvider.of<AppBloc>(context),
        builder: (BuildContext context, int state) {          
          return _listView(context, state);
        },
      );

  Widget _listView(BuildContext context, int state) =>
      ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Placeholder();
        },
      );
}