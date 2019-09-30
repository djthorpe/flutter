/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc_client/bloc/app.dart';

/////////////////////////////////////////////////////////////////////

enum ConnectFormAction { Connect }

/////////////////////////////////////////////////////////////////////

class ConnectForm extends StatefulWidget {
  final String hostName;
  final int portNumber;

  // Constructor
  ConnectForm({Key key, this.hostName, this.portNumber}) : super(key: key);

  // Overrides
  @override
  _ConnectFormState createState() => _ConnectFormState();
}

/////////////////////////////////////////////////////////////////////

class _ConnectFormState extends State {
  final formKey = GlobalKey<FormState>();
  String hostName;
  int portNumber;

  // Constructor
  _ConnectFormState({this.hostName, this.portNumber}) : super();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        autovalidate: true,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
          children: <Widget>[
            formFieldHost(context),
            formFieldPort(context),
            formFieldAction(context),
          ],
        ));
  }

  formFieldHost(BuildContext context) => TextFormField(
          inputFormatters: [
            WhitelistingTextInputFormatter(
                RegExp("[a-zA-Z0-9][a-zA-Z0-9\\.\\-]*"))
          ],
          validator: (value) {
            if (value.isEmpty) {
              return 'The value cannot be empty';
            } else {
              return null;
            }
          },
          initialValue: this.hostName,
          onSaved: (value) => setState(() => this.hostName = value),
          decoration: const InputDecoration(
              icon: const Icon(Icons.computer),
              hintText: 'Hostname of remote service',
              labelText: 'Host'));

  formFieldPort(BuildContext context) => TextFormField(
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value.isEmpty) {
          return 'The value cannot be empty';
        } else if (value == "0") {
          return 'The value cannot be zero';
        } else {
          return null;
        }
      },
      initialValue: this.portNumber == null ? null : this.portNumber.toString(),
      onSaved: (value) => setState(() => this.portNumber = int.parse(value)),
      decoration: const InputDecoration(
        icon: const Icon(Icons.power),
        hintText: 'Port of remote service',
        labelText: 'Port',
      ));

  formFieldAction(BuildContext context) => Container(
      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
      child: RaisedButton(
          child: const Text('Connect'),
          onPressed: () {
            final form = formKey.currentState;
            if (form.validate()) {
              form.save();
              action(context, ConnectFormAction.Connect);
              // DO SOMETHING HERE
            }
          }));

  action(BuildContext context, ConnectFormAction action) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    switch (action) {
      case ConnectFormAction.Connect:
        appBloc.dispatch(AppEventConnect(this.hostName, this.portNumber));
        break;
      default:
        print("No action defined for $action");
    }
  }
}
