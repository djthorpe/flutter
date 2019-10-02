# flutter

[![CircleCI](https://circleci.com/gh/djthorpe/flutter/tree/master.svg?style=svg)](https://circleci.com/gh/djthorpe/flutter/tree/master)


This repository includes [Flutter](https://flutter.dev/) application examples which is a cross-platform application development framework. The specific examples in this repository are:

* __ReviewApp__: Example from [State management for Flutter apps with MobX](https://circleci.com/blog/state-management-for-flutter-apps-with-mobx/) (CircleCI Tutorials)
* __mDNS Plugin__: A Flutter [mDNS](https://en.wikipedia.org/wiki/Multicast_DNS) package, which is published at
[pub.dev](https://pub.dev/packages/mdns_plugin) 
* __gPRC Client__: Implements a [gRPC](https://github.com/grpc/grpc-dart) client, which requires a server in order to communicate with

The applications here are developed on the `v1` branch and currently a configuration is included to use [CircleCI](https://circleci.com/) to build Android APK's when merged into the `master` branch. The APK images can be downloaded as artifacts from CircleCI once built.

## mDNS Browser Example

Please see example of mDNS browsing [here](https://github.com/djthorpe/flutter/tree/master/mdns_plugin/example), which demonstrates browsing for Chromecast devices on your local network.

## gRPC Client

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





