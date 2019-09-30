import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc_client/bloc/app.dart';
import 'package:grpc_client/widgets/connect_form.dart';
import 'package:grpc_client/widgets/disconnect_form.dart';
import 'package:grpc_client/widgets/sayhello_form.dart';

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
                        snackBarWithText(state.exception.toString()));
                  }
                  if (state is AppStateStarted && state.message != null) {
                    Scaffold.of(context)
                        .showSnackBar(snackBarWithText(state.message));
                  }
                },
                child: BlocBuilder<AppBloc, AppState>(
                    builder: (context, state) =>
                        bodyBuilder(context, state)))));
  }

  Widget bodyBuilder(BuildContext context, AppState state) {
    if (state is AppStateStarted) {
      return Column(children: [DisconnectForm(),SayHelloForm()]);
    }

    if (state is AppStateConnect && state.state == ConnectState.Disconnected) {
      return ConnectForm(state.defaults);
    }

    if (state is AppStateConnect && state.state == ConnectState.Error) {
      return ConnectForm(state.defaults);
    }

    if (state is AppStateConnect && state.state == ConnectState.Connecting) {
      return ConnectForm(state.defaults);
    }

    // Default case
    return Placeholder();
  }

  Widget snackBarWithText(String msg) => SnackBar(
    content: Text(msg),    
    duration: Duration(milliseconds: 750),
    action: SnackBarAction(
      label: "OK",
      onPressed: () => {}
    ));
}
