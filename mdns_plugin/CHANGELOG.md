## 0.0.1

Initial Release

## 0.0.2

Added delegate implementation for iOS and Dart. There is no Android implementation in this version.
Remaining items to do:

  * Implement `domain` argument when calling `startDiscovery`
  * Implment the `addresses` property on `MDNSService`
  * Implement the Android version

## 0.0.4

Now allows `domain` argument when calling `startDiscovery` and
implements the `addresses` property on `MDNSService`. Remaining items to do:

  * Implement the Android version

## 0.0.5

Updated the example code.

## 0.0.6

Formatting changes

## 0.0.7

Started to implement the android code, just enough for the plugin
to work correctly, but not yet return any services.

## 0.0.8

Further work on the Android code, but quite a bit to do


## 0.0.9

Further work on the Android code, the remaining issues are:

  * Pass through the serviceType onStartDiscovery
  * Remove the domain to ensure parity between the iOS and Android implementations
  * Extract the addresses from the ServiceInfo
  * Implement some sort up update method on Android for when TXT records are updated?
  * Android: Hot reloading doesn't work since the discoverylistener is still allocated


## 0.0.10

Further work on the Android code, the remaining issues are:

  * Remove the domain to ensure parity between the iOS and Android implementations
  * Implement some sort up update method on Android for when TXT records are updated?



