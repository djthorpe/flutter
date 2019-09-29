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
import 'package:mdns_browser/widgets/service.dart';

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
      builder: (BuildContext context, AppState state) {
        return ListView.builder(
            itemCount: state.services.count,
            itemBuilder: (BuildContext context, int index) {
              var item = state.services.itemAtIndex(index);
              return ServiceItem(
                titleValue: item.name,
                subtitleValue: item.hostPort,
              );
            });
      });
}
