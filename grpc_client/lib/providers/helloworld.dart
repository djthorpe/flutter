/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'dart:io';
import 'package:grpc/grpc.dart';
import 'google/protobuf/empty.pb.dart';
import "helloworld.pbgrpc.dart";

/////////////////////////////////////////////////////////////////////

bool badCertificateHandler (X509Certificate certificate,String hostPort) {
  // Ignore bad certificates
  return true;
}

class HelloWorld {
  // Constants
  static const String userAgent = "com.mutablelogic.grpc_client.helloworld";
  static const Duration connectionTimeout = Duration(seconds: 1);
  static const Duration idleTimeout = Duration(minutes: 1);

  // Instance variables
  ClientChannel _channel;
  GreeterClient _stub;

  Future<void> connect(String address, int port, {bool secure}) {
    ChannelOptions options;

    if (secure) {
      options = ChannelOptions(
          credentials: const ChannelCredentials.secure(
            onBadCertificate: badCertificateHandler
          ),
          connectionTimeout: connectionTimeout,
          idleTimeout: idleTimeout,
          userAgent: userAgent);
    } else {
      options = ChannelOptions(
          credentials: const ChannelCredentials.insecure(),
          connectionTimeout: connectionTimeout,
          idleTimeout: idleTimeout,
          userAgent: userAgent);
    }

    _channel = ClientChannel(address, port: port, options: options);
    _stub = GreeterClient(_channel,
        options: CallOptions(timeout: Duration(seconds: 1)));
    return ping();
  }

  void disconnect() async {
    await _channel.shutdown();
    _stub = null;
    _channel = null;
  }

  Future<HelloReply> sayHello(String name) {
    return _stub.sayHello(HelloRequest()..name = name);
  }

  Future<void> ping() {
    return _stub.ping(Empty());
  }
}
