/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:grpc/grpc.dart';
import 'package:grpc_client/providers/grpc/reflection/v1alpha/reflection.pbgrpc.dart';

/////////////////////////////////////////////////////////////////////

class ServerReflection extends ClientChannel {
  final String hostName;
  final int portNumber;
  static const channelOptions = ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        connectionTimeout: Duration(seconds: 1),
        idleTimeout: Duration(minutes: 1)
  );
  ServerReflectionClient stub;

  ServerReflection(this.hostName,this.portNumber) : super(hostName, port: portNumber, options: channelOptions) {
    stub = ServerReflectionClient(this);
  }
}

