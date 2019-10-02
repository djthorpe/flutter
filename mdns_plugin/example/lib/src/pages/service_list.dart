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
        body: BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              if (state is AppUpdated &&
                  state.action == AppStateAction.ShowToast) {
                Scaffold.of(context)
                    .showSnackBar(snackBarWithText("Rescanning"));
              }
            },
            child: Column(
                children: <Widget>[infoWidget(context), listWidget(context)])));
  }

  Widget snackBarWithText(String text) {
    return SnackBar(content: Text(text), duration: Duration(seconds: 1));
  }

  Widget listWidget(BuildContext context) => BlocBuilder(
      bloc: BlocProvider.of<AppBloc>(context),
      builder: (BuildContext context, AppState state) {
        if (state is AppUpdated && state.services.count > 0) {
          return Expanded(
              child: ListView.builder(
                  itemCount: state.services.count,
                  itemBuilder: (BuildContext context, int index) =>
                      ServiceTile(state.services.itemAtIndex(index))));
        } else {
          return Expanded(child: Center(child: Text("No Chromecasts Found")));
        }
      });

  Widget infoWidget(BuildContext context) => BlocBuilder(
      bloc: BlocProvider.of<AppBloc>(context),
      builder: (BuildContext context, AppState state) {
        final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
        return Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
              title: Text('FOUND CHROMECASTS'),
              subtitle: Text(
                  "The following devices were found on your local network")),
          ButtonTheme.bar(
              child: ButtonBar(children: <Widget>[
            FlatButton(
                child: const Text('RESCAN'),
                onPressed: () => appBloc.dispatch(
                    AppEventDiscovery(AppEventDiscoveryState.Restart)))
          ]))
        ]));
      });
}
