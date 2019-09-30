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
              children: <Widget>[cardTitle(context), actionBar(context)])));

  Widget cardTitle(BuildContext context) => const ListTile(
        leading: Icon(Icons.computer),
        title: Text('Connnected'),
      );

  Widget actionBar(BuildContext context) => ButtonTheme.bar(
          child: ButtonBar(children: <Widget>[
        FlatButton(
          child: const Text('DISCONNECT'),
          onPressed: () => actionDisconnect(context)
        ),
      ]));

  void actionDisconnect(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    appBloc.dispatch(AppEventDisconnect());
  }
}
