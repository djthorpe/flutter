import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:grpc_client/bloc/app.dart';
import 'package:grpc_client/widgets/connect_form.dart';

/////////////////////////////////////////////////////////////////////

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
            appBar: AppBar(title: Text("gRPC Demo")),
            body: BlocListener<AppBloc, AppState>(
                listener: (context, state) {
                  if (state is AppStateConnect &&
                      state.state == ConnectState.Error) {
                    Scaffold.of(context).showSnackBar(
                        errorSnackBar(state.exception.toString()));
                  }
                },
                child: BlocBuilder<AppBloc, AppState>(
                    builder: (context, state) =>
                        bodyBuilder(context, state)))));
  }

  Widget bodyBuilder(BuildContext context, AppState state) {
    if (state is AppStateUninitialized) {
      return Placeholder();
    } else if (state is AppStateConnect &&
        state.state == ConnectState.Disconnected) {
      return ConnectForm();
    } else if (state is AppStateConnect && state.state == ConnectState.Error) {
      return ConnectForm();
    } else if (state is AppStateConnect &&
        state.state == ConnectState.Connecting) {
      return Center(child: Text("Connecting"));
    } else {
      return Center(child: Text("$state"));
    }
  }

  Widget errorSnackBar(String msg) => SnackBar(content: Text(msg));
}
