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

class SayHelloForm extends StatefulWidget {
  const SayHelloForm({Key key}) : super(key: key);

  @override
  _SayHelloFormState createState() => _SayHelloFormState();
}

class _SayHelloFormState extends State<SayHelloForm> {
  final formKey = GlobalKey<FormState>();
  String name;

  @override
  Widget build(BuildContext context) => Center(
      child: Card(
          color: Theme.of(context).dialogBackgroundColor,
          child: Form(
              key: formKey,
              autovalidate: true,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                cardTitle(context),
                nameField(context),
                actionBar(context)
              ]))));

  Widget cardTitle(BuildContext context) => const ListTile(
        leading: const Icon(Icons.power),
        title: Text('Say Hello'),
      );

  Widget nameField(BuildContext context) => Container(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0),
      child: TextFormField(
        onSaved: (value) => setState(() => name = value),
          decoration: const InputDecoration(
              labelText: 'Name', hintText: "What is your name?")));

  Widget actionBar(BuildContext context) => ButtonTheme.bar(
          child: ButtonBar(children: <Widget>[
        FlatButton(
            child: const Text('CALL'),
            onPressed: () => actionSayHello(context)),
      ]));

  void actionSayHello(BuildContext context) {
    final form = formKey.currentState;
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    if (form.validate()) {
      form.save();
      appBloc.dispatch(AppEventCall(AppEventMethod.SayHello,name:this.name));
    }
  }
}
