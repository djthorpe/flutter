# flutter

[![CircleCI](https://circleci.com/gh/djthorpe/flutter/tree/master.svg?style=svg)](https://circleci.com/gh/djthorpe/flutter/tree/master)


This repository includes [Flutter](https://flutter.dev/) application and packages.

The applications here are developed on the `v1` branch and currently a configuration is included to use [CircleCI](https://circleci.com/) to build Android APK's when merged into the `master` branch. The APK images can be downloaded as artifacts from CircleCI once built.

## mDNS Plugin

A Flutter [mDNS](https://en.wikipedia.org/wiki/Multicast_DNS) package, which is published at
[pub.dev](https://pub.dev/packages/mdns_plugin). The example which demonstrates the use is [here](https://github.com/djthorpe/flutter/tree/master/mdns_plugin/example).

## gRPC Plugin

A package which provides connection and reflection for remote [gRPC](https://github.com/grpc/grpc-dart) services. Please see [pub.dev](https://pub.dev/packages/grpc_plugin) for the package information, and the example which demonstrates the use is [here](https://github.com/djthorpe/flutter/tree/master/grpc_plugin/example).

## Notes on developing a gRPC Client

On a Macintosh, use the following commands in order to make a working gRPC installation, assuming you have [Homebrew](https://brew.sh/) already installed:

```bash
bash% brew install grpc && brew upgrade grpc
```

We assume that the protocol buffer files (with extension `.proto`) are in the folder `lib/protobuf` of your project. The generated output should go into the `lib/providers` folder.

For Macintosh, there is a script in order to generate the Dart files:

```bash
bash% git clone git@github.com:djthorpe/flutter.git
bash% cd flutter/grpc_client
bash% install -d lib/providers/google/protobuf
bash% install -d lib/providers/grpc/reflection/v1alpha
bash% source ../genproto-darwin.sh
bash% flutter test && flutter build ios
```





