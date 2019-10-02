/*
  mDNS Plugin Example
  Flutter client demonstrating browsing for Chromecasts
  on your local network

  Copyright (c) David Thorpe 2019
  Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mdns_plugin_example/src/bloc/app.dart';
import 'package:mdns_plugin_example/src/widgets/service_tile.dart';

/////////////////////////////////////////////////////////////////////

class ServiceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: listWidget(context),
      ),
    );
  }

  Widget listWidget(BuildContext context) => BlocBuilder(
      bloc: BlocProvider.of<AppBloc>(context),
      builder: (BuildContext context, AppState state) {
        if (state is AppUpdated) {
          return ListView.builder(
              itemCount: state.services.count,
              itemBuilder: (BuildContext context, int index) {
                return ServiceTile(state.services.itemAtIndex(index));
              });
        } else {
          return Placeholder();
        }
      });
}
