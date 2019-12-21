# mdns_plugin

Yet another package which discovers network services on the local
network. Presently, this package is in development, and should
work for iOS targets. Android targets work with one caveat mentioned
below.

Please file any issues or feature requests on github, thanks.

## Using the plugin

You use the plugin by calling `startDiscovery` and `stopDiscovery` on an instance of `MDNSPlugin`, which
you need to create by passing a delegate instance. The `MDNSPlugin` class provides two methods and a constructor:

```dart
class MDNSPlugin {
    /// Constructor
    MDNSPlugin(MDNSPluginDelegate)

    /// platformVersion returns the underlying platform version of the
    /// running plugin
    static Future<String> get platformVersion async;

    /// startDiscovery is invoked to start discovery of services on
    /// the local network, for a serviceType, which should be, for
    /// example "_googlecast._tcp" or similar. When the optional
    /// enableUpdating flag is set to true, resolved services
    /// respond to updates to the TXT record for the service
    Future<void> startDiscovery(String serviceType,{ bool enableUpdating = false }) async;

    /// stopDiscovery should be invoked to shutdown the discovery
    /// of services on your local network
    Future<void> stopDiscovery() async;
}
```

One limitation is that on Android, the `enableUpdating` flag is currently ignored. Future work will correct this to bring the platforms in parity. The delegate instance will receive messages from the plugin. Your delegate
class should implement the following methods:

```dart
abstract class MDNSPluginDelegate {

  /// onDiscoveryStarted is called when discovery on the local 
  /// network has started
  void onDiscoveryStarted();

  /// onDiscoveryStopped is called when discovery on the local
  /// network has stopped
  void onDiscoveryStopped();

  /// onServiceFound is called when a service on the local network 
  /// has been discovered. Your function implementation should 
  /// return true if you want the service to be resolved
  bool onServiceFound(MDNSService service);

  /// onServiceResolved is called when resolution has occurred,
  /// filling in the details (hostname, addresses, etc) of the
  /// service
  void onServiceResolved(MDNSService service);

  /// onServiceUpdated is called when a found service has updated 
  /// the TXT record
  void onServiceUpdated(MDNSService service);

  /// onServiceRemoved is called when a found service has been
  /// removed from the local network
  void onServiceRemoved(MDNSService service);
}
```

## Example

Here's a basic example which implements a delegate, that can respond to
mDNS services being discovered and updated:

```dart
import 'dart:async';
import 'package:mdns_plugin/mdns_plugin.dart';

void main() async {
    MDNSPlugin mdns = new MDNSPlugin(Delegate());
    await mdns.startDiscovery("_googlecast._tcp",enableUpdating: true);
    sleep();
    await mdns.stopDiscovery();
    sleep();
}

Future sleep() {
  return new Future.delayed(const Duration(seconds: 5), () => "5");
}

class Delegate implements MDNSPluginDelegate {
  void onDiscoveryStarted() {
      print("Discovery started");
  }
  void onDiscoveryStopped() {
      print("Discovery stopped");
  }
  bool onServiceFound(MDNSService service) {
      print("Found: $service");
      // Always returns true which begins service resolution
      return true;
  }
  void onServiceResolved(MDNSService service) {
      print("Resolved: $service");
  }
  void onServiceUpdated(MDNSService service) {
      print("Updated: $service");
  }
  void onServiceRemoved(MDNSService service) {
      print("Removed: $service");
  }
}
```

For a fuller example please see the application in the `example` folder.

## Publishing this plugin

(Some notes for me) In order to publish the plugin, edit 
the `pubspec.yaml` and `CHANGELOG.md` files in the root directory and 
the `example` directory to bump the version number $TAG 
and then run the following commands:

```bash
bash% TAG=v`sed -n 's/version\: \(.*\)/\1/p' pubspec.yaml`
bash% echo $TAG && flutter format .
bash% git commit -a -m "Updated version to $TAG"
bash% git push && git tag $TAG && git push --tags
bash% flutter pub pub publish
```

You should then merge `v1` into the `master` branch.

