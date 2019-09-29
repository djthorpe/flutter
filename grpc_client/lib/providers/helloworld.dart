import 'package:grpc/grpc.dart';
import 'google/protobuf/empty.pb.dart';
import "helloworld.pbgrpc.dart";

class HelloWorld {
  ClientChannel _channel;
  GreeterClient _greeter;

  HelloWorld(String address, int port) {
    var options =
        const ChannelOptions(credentials: const ChannelCredentials.insecure());
    _channel = ClientChannel(address, port: port, options: options);
    _greeter = GreeterClient(_channel);
  }

  void disconnect() async {
    await _channel.shutdown();
    _greeter = null;
    _channel = null;
  }

  Future<String> sayHello(String name) async {
    HelloReply reply = await _greeter.sayHello(HelloRequest());
    return reply.message;
  }

  Future<void> ping() async {
    await _greeter.ping(Empty());
  }
}
