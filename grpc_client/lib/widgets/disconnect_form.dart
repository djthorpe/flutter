/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc_client/bloc/app.dart';

/////////////////////////////////////////////////////////////////////

class DisconnectForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Card(
          color: Theme.of(context).buttonColor,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[cardTitle(context), listView(context), actionBar(context)])));

  Widget cardTitle(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    return ListTile(
        leading: Icon(Icons.computer),
        title: Text("Connected to ${appBloc.hostName}:${appBloc.portNumber}")
      );
  }

  Widget listView(BuildContext context) { 
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);   
    return Container(
      height: 200,
      child: ListView.builder(
      itemCount: appBloc.services.length,
      itemBuilder: (context, index) {
          return ListTile(
            title: Text(appBloc.services[index]),
            contentPadding: EdgeInsets.only(left: 10.0),
          );
      },
    ));
  }

  Widget actionBar(BuildContext context) => ButtonTheme.bar(
          child: ButtonBar(children: <Widget>[
        FlatButton(
          child: const Text('DISCONNECT'),
          onPressed: () => actionDisconnect(context)
        ),
      ]));

  Widget padding(BuildContext context) => Expanded(
    flex: 1,
    child: Placeholder()
  );

  void actionDisconnect(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    appBloc.dispatch(AppEventDisconnect());
  }
}
