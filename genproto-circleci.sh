#!/bin/bash
#
# Generates the "provider" files for Dart from the proto files,
# for CircleCI
#
# Syntax:
#    cd $PROJECT_DIR
#    install -d lib/providers/google/protobuf
#    genproto-circleci.sh
#

# Check paths
PROTOC_BIN=`which protoc`
DART_BIN=`which dart`
PLUGIN_BIN=`which protoc-gen-dart`
FLUTTER_BIN=`which flutter`

# Check for Protoc installations
if [ ! -x "${PROTOC_BIN}" ] ; then
    echo "Protoc is not installed, install using:"
    echo
    echo "  brew install protobuf"
    exit -1
fi

# Calculate Flutter base path
FLUTTER_PATH=$( dirname "${FLUTTER_BIN}" )
FLUTTER_PATH=$( cd "${FLUTTER_PATH}/.." && pwd )

# Check for Dart and gRPC plugins
if [ ! -x "${DART_BIN}" ] ; then
    echo "Dart is not available, add the following command to your"
    echo "login script:"
    echo
    echo "  export PATH=\"\${PATH}:${FLUTTER_PATH}/bin/cache/dart-sdk/bin/dart\""
    echo
    exit -1
fi
if [ ! -x "${PLUGIN_BIN}" ] ; then
    echo "The gPRC Dart plugin is not available. Run these commands on your command line:"
    echo
    echo "  flutter pub global activate protoc_plugin"
    echo
    echo "Add the following command to your login script:"
    echo
    echo "  export PATH=\${PATH}:${FLUTTER_PATH}/.pub-cache/bin"
    echo
    echo "Also add the following line to your pubspec.yaml file within"
    echo "your project:"
    echo
    echo "  dependencies:"
    echo "      grpc: ^2.1.2"
    echo "      protobuf: ^0.14.4"
    echo
    exit -1
fi

# Calculate folders
CURRENT_DIR=`pwd`
PROTO_DIR="${CURRENT_DIR}/lib/protobuf"
GOOGLE_PROTO_DIR="${HOME}/sdks/protoc/include"
REFLECT_PROTO_DIR=$( cd "${CURRENT_DIR}/../grpc/reflection/v1alpha" && pwd )

# Generate Local protos
if [ -d "${PROTO_DIR}" ] ; then
    echo
    echo "Local"
    echo "  Source: ${PROTO_DIR}"
    echo "  Destination: lib/providers"
    echo
    if [ ! -d "${CURRENT_DIR}/lib/providers" ] ; then
        echo "Error: lib/providers does not exist, type: install -d lib/providers"
        exit -1
    fi
    for PROTO_FILE in ${PROTO_DIR}/*.proto
    do
        PROTO_BASE=`basename ${PROTO_FILE}`
        echo "Generating: $PROTO_BASE => lib/providers"
        protoc --dart_out=grpc:lib/providers -I${PROTO_DIR} ${PROTO_BASE}
    done
else
    echo "Error: lib/protobuf does not exist, type: install -d lib/protobuf"
fi

# Generate Google protos
if [ -d "${GOOGLE_PROTO_DIR}" ] ; then
    echo
    echo "Google"
    echo "  Source: ${GOOGLE_PROTO_DIR}"
    echo "  Destination: lib/providers/google/protobuf"
    echo
    if [ ! -d "${CURRENT_DIR}/lib/providers/google/protobuf" ] ; then
        echo "   lib/providers/google/protobuf does not exist, type: install -d lib/providers/google/protobuf"
        exit -1
    fi
    for PROTO_FILE in ${GOOGLE_PROTO_DIR}/*.proto
    do
        PROTO_BASE=`basename ${PROTO_FILE}`
        echo "Generating: $PROTO_BASE => lib/providers/google/protobuf"
        protoc --dart_out=grpc:lib/providers/google/protobuf -I${GOOGLE_PROTO_DIR} ${PROTO_BASE}
    done
fi

# Generate Reflection protos
if [ -d "${REFLECT_PROTO_DIR}" ] ; then
    echo
    echo "Reflection"
    echo "  Source: ${REFLECT_PROTO_DIR}"
    echo "  Destination: lib/providers/grpc/reflection/v1alpha"
    echo
    if [ ! -d "${CURRENT_DIR}/lib/providers/grpc/reflection/v1alpha" ] ; then
        echo "   lib/providers/grpc/reflection/v1alpha does not exist, type: install -d lib/providers/grpc/reflection/v1alpha"
        exit -1
    fi
    for PROTO_FILE in ${REFLECT_PROTO_DIR}/*.proto
    do
        PROTO_BASE=`basename ${PROTO_FILE}`
        echo "Generating: $PROTO_BASE => lib/providers/grpc/reflection/v1alpha"
        protoc --dart_out=grpc:lib/providers/grpc/reflection/v1alpha -I${REFLECT_PROTO_DIR} ${PROTO_BASE}
    done
fi
