/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'dart:io';
import 'package:grpc/grpc.dart';
import 'package:grpc_client/providers/grpc/reflection/v1alpha/reflection.pbgrpc.dart';

/////////////////////////////////////////////////////////////////////

// badCertificateHandler allows self-signed certificates
bool badCertificateHandler (X509Certificate certificate,String hostPort) {
  return true;
}

class ReflectionClient {
  // Constants
  static const String userAgent = "com.mutablelogic.grpc_client.helloworld";
  static const Duration connectionTimeout = Duration(seconds: 1);
  static const Duration idleTimeout = Duration(minutes: 1);
  static const Duration callTimeout = Duration(seconds: 5);

  // Instance variables
  final List<String> services = List<String>();
  ClientChannel _channel;
  ServerReflectionClient _stub;

  Future<void> connect(String address, int port, {bool secure}) async {
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
    _stub = ServerReflectionClient(_channel,
        options: CallOptions(timeout: callTimeout));

    return this._listServices();
  }

  void disconnect() async {
    await _channel.shutdown();
    _stub = null;
    _channel = null;
  }

  void _listServices() async {
    services.clear();
    final requests = _listServicesStream();
    await for (var response in _stub.serverReflectionInfo(requests)) {
      if(response.hasListServicesResponse()) {
        for(var service in response.listServicesResponse.service) {
          services.add(service.name);
        }
      }       
    }
  }

  Stream<ServerReflectionRequest> _listServicesStream() async* {
    yield ServerReflectionRequest()
      ..listServices = "list";
  }
}

