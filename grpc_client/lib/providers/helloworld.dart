import 'package:grpc/grpc.dart';
import 'google/protobuf/empty.pb.dart';
import "helloworld.pbgrpc.dart";

class HelloWorld {
  ClientChannel _channel;
  GreeterClient _stub;

  Future<void> connect(String address, int port) async {
    var options = const ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        connectionTimeout: Duration(seconds: 1),
        idleTimeout: Duration(minutes: 1));
    _channel = ClientChannel(address, port: port, options: options);
    _stub = GreeterClient(_channel,
        options: CallOptions(timeout: Duration(seconds: 1)));
    try {
      await this.ping();
    } catch (e) {
      throw Exception("connection not successful: $e");
    }
  }

  Future<void> disconnect() async {
    _channel.shutdown().then((_) {
      _stub = null;
      _channel = null;
    });
  }

  Future<String> sayHello(String name) async {
    HelloReply reply = await _stub.sayHello(HelloRequest());
    return reply.message;
  }

  Future<void> ping() async {
    return _stub.ping(Empty());
  }
}
