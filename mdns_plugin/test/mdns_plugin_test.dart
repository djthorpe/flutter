import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdns_plugin/mdns_plugin.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('mdns_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await MDNSPlugin.platformVersion, '42');
  });
}
