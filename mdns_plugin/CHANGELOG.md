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
  * Implement some sort up update method on Android for when TXT records are updated
  * On Android, Lazy resolve service info instead of all at once (queue)

## 1.0.0

First v1 release includes the iOS and Android, the remaining issue is that
when TXT records are updated, the onServiceUpdated callback is not called
on the Android platform, since the in-built libraries don't have this
functionality available.

## 1.1.0

The plugin no longer resolves found services automatically but will only do so
after "true" is returned from the delegate `onServiceFound`. In addition, the
`startDiscovery` method now has an optional argument which is `enableUpdating`
which when set to true will call the `onServiceUpdated` delegate method when
TXT records are updated on the iOS platform. However, this doesn't yet work
on Android.

## 1.1.1

Fixed a problem with the Android manifest for the release version

## 1.1.3

Updated Android build to Gradle to 3.3.0, thanks to 
[Clement Wong](https://github.com/clementhk) and some updates for the
tests. See PR: 



