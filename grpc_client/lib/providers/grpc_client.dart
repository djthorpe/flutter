/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:grpc/grpc.dart';
import 'dart:io';

/////////////////////////////////////////////////////////////////////

bool badCertificateHandler (X509Certificate certificate,String hostPort) {
  // Ignore bad certificates
  return true;
}

class GRPCClient {
  // Constants
  static const String userAgent = "com.mutablelogic.grpc_client";
  static const Duration connectionTimeout = Duration(seconds: 1);
  static const Duration idleTimeout = Duration(minutes: 1);

  // Instance variables
  ClientChannel _channel;

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
  }

  void disconnect() async {
    await _channel.shutdown();
    _channel = null;
  }
}
