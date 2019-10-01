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
import 'package:grpc_client/providers/defaults.dart';

/////////////////////////////////////////////////////////////////////

class ConnectForm extends StatefulWidget {
  final Defaults defaults;

  const ConnectForm(this.defaults, {Key key}) : super(key: key);

  @override
  _ConnectFormState createState() => _ConnectFormState(defaults);
}

class _ConnectFormState extends State<ConnectForm> {
  final formKey = GlobalKey<FormState>();
  final Defaults defaults;

  // Constructor
  _ConnectFormState(this.defaults) : super();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        autovalidate: true,
        child: ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
            children: formFields(context)));
  }

  List<Widget> formFields(BuildContext context) => [
      formFieldHost(context),
      formFieldPort(context),
      formFieldSecure(context),
      formFieldAction(context)
    ];

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
          initialValue: defaults.hostName,
          onSaved: (value) => {
                setState(() {
                  defaults.hostName = value;
                })
              },
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
      initialValue: defaults.portNumber?.toString(),
      onSaved: (value) => {
            setState(() {
              defaults.portNumber = int.parse(value);
            })
          },
      decoration: const InputDecoration(
        icon: const Icon(Icons.power),
        hintText: 'Port of remote service',
        labelText: 'Port',
      ));

  formFieldSecure(BuildContext context) => Container(
        padding: const EdgeInsets.only(left: 22.0),
        child: SwitchListTile(
          title: const Text("Secure communication"),
          subtitle: const Text("Use https"),
          value: defaults.secure,
          onChanged: (bool value) {
            setState(() => defaults.secure = value);
          },
        ));

  formFieldAction(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
        child: RaisedButton(
            child: const Text('Connect'),
            onPressed: () {
              final form = formKey.currentState;
              if (form.validate()) {
                form.save();
                action(context);
              }
            }));
  }

  void action(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    appBloc.dispatch(AppEventConnect(defaults.hostName, defaults.portNumber,defaults.secure));
  }
}
