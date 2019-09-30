import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'google/protobuf/empty.pb.dart';
import "helloworld.pbgrpc.dart";

class HelloWorld {
  ClientChannel _channel;
  GreeterClient _stub;

  void connect(String address, int port) async {
    var options = const ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        connectionTimeout: Duration(seconds: 1),
        idleTimeout: Duration(minutes: 1),
        userAgent: "com.mutablelogic.grpc_client.helloworld");
    try {
      _channel = ClientChannel(address, port: port, options: options);
      _stub = GreeterClient(_channel,
          options: CallOptions(timeout: Duration(seconds: 1)));
      await ping();
    } catch(exception) {        
      _channel = null;    
      _stub = null;
      throw(Exception("Connect: $exception"));
    } 
  }

  Future<void> disconnect() async {
    _channel.shutdown().catchError((e) {
      throw (e);
    }).then((_) {
      _stub = null;
      _channel = null;
    });
  }

  Future<String> sayHello(String name) async {
    _stub.sayHello(HelloRequest()).catchError((e) {
      throw (e);
    }).then((reply) {
      return reply.message;
    });
  }

  Future<void> ping() async {
    return _stub.ping(Empty());
  }
}
