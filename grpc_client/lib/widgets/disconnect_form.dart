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
  Widget build(BuildContext context) {
    return Form(
        child: Container(
            padding: const EdgeInsets.only(left: 40.0, top: 20.0),
            child: RaisedButton(
                child: const Text('Disonnect'),
                onPressed: () {
                  final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
                  appBloc.dispatch(AppEventDisconnect());
                })));
  }
}
