# flutter

This repository includes [Flutter](https://flutter.dev/) application examples which is a cross-platform application development framework. The specific examples in this repository are:

* __ReviewApp__: Example from [State management for Flutter apps with MobX](https://circleci.com/blog/state-management-for-flutter-apps-with-mobx/) (CircleCI Tutorials)
* __mDNS Browser__: Implements a browser of services on the network through [mDNS](https://en.wikipedia.org/wiki/Multicast_DNS)
* __gPRC Client__: Implements a [gRPC](https://github.com/grpc/grpc-dart) client, which requires a server in order to communicate with

The applications here are developed on the `v1` branch and currently a configuration is included to use [CircleCI](https://circleci.com/) to build Android APK's when merged into the `master` branch. The APK images can be downloaded as artifacts from CircleCI once built.

## Screenshots

Some screenshots will be added here in due course.

## Some notes on gRPC

On a Macintosh, use the following commands in order to make a working gRPC installation, assuming you have [Homebrew](https://brew.sh/) already installed:

```bash
bash% brew install grpc
bash% brew upgrade grpc
```

We assume that the protocol buffer files (with extension `.proto`) are in the folder `lib/protobuf` of your
project, and the generated output should go into the `lib/providers` folder. Then, the following command
can be used to generate the stubs:

```bash
bash% protoc --dart_out=grpc:lib/providers -Ilib/protobuf helloworld.proto
```



