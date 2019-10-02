# mdns_plugin

Yet another package which discovers network services on the local
network. Presently, this package is in development, and should
work for iOS targets. Android targets are forthcoming.

Please file any issues or feature requests on github, thanks.

## Example

Here's a basic example which implements a delegate, that can respond to
mDNS services being discovered and updated:

```dart
import 'dart:async';
import 'package:mdns_plugin/mdns_plugin.dart';

void main() {
    MDNSPlugin mdns = new MDNSPlugin(Delegate());
    startDiscovery();
    sleep();
    stopDiscovery();
    sleep();
}

void startDiscovery() {      
    _mdns.startDiscovery("_googlecast._tcp").then((_) {
        print("Discovery started");
    });
}

void stopDiscovery() {      
    _mdns.stopDiscovery().then((_) {
        print("Discovery stopped");
    });
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
  void onServiceFound(MDNSService service) {
      print("Found: $service");
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

For a fuller example please see the `example` folder.

