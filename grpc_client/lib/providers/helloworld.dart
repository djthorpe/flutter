/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:grpc/grpc.dart';
import 'google/protobuf/empty.pb.dart';
import "helloworld.pbgrpc.dart";

/////////////////////////////////////////////////////////////////////

class HelloWorld {
  ClientChannel _channel;
  GreeterClient _stub;

  Future<void> connect(String address, int port) {
    var options = const ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        connectionTimeout: Duration(seconds: 1),
        idleTimeout: Duration(seconds: 1),
        userAgent: "com.mutablelogic.grpc_client.helloworld");
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

  Future<HelloReply> sayHello(String name){
    return _stub.sayHello(HelloRequest()..name = name);
  }

  Future<void> ping(){
    return _stub.ping(Empty());
  }
}
