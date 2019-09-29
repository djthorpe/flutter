#!/bin/bash
brew list protobuf 1>/dev/null || exit -1

GOOGLE_PROTO_DIR=$(dirname `brew list protobuf | grep google/protobuf/empty.proto`)
CURRENT_DIR=`pwd`
PROTO_DIR="${CURRENT_DIR}/lib/protobuf"

echo Google
echo "  Source: ${GOOGLE_PROTO_DIR}"
echo "  Destination: ${CURRENT_DIR}/lib/providers/google/protobuf"
echo
echo Local
echo "  Source: ${PROTO_DIR}"
echo "  Destination: ${CURRENT_DIR}/lib/providers"
echo

if [ ! -d "${CURRENT_DIR}/lib/providers" ] ; then
    echo "   lib/providers does not exist, type: install -d lib/providers"
    exit -1
fi

if [ ! -d "${PROTO_DIR}" ] ; then
    echo "   lib/protobuf does not exist, type: install -d lib/protobuf"
    exit -1
fi

if [ ! -d "${CURRENT_DIR}/lib/providers/google/protobuf" ] ; then
    echo "   /lib/providers/google/protobuf does not exist, type: install -d lib/providers/google/protobuf"
    exit -1
fi

for PROTO_FILE in ${PROTO_DIR}/*.proto
do
    PROTO_BASE=`basename ${PROTO_FILE}`
    echo "Generating: $PROTO_BASE => lib/providers"
    protoc --dart_out=grpc:lib/providers -I${PROTO_DIR} ${PROTO_BASE}
done

for PROTO_FILE in ${GOOGLE_PROTO_DIR}/*.proto
do
    PROTO_BASE=`basename ${PROTO_FILE}`
    echo "Generating: $PROTO_BASE => lib/providers/google/protobuf"
    protoc --dart_out=grpc:lib/providers/google/protobuf -I${GOOGLE_PROTO_DIR} ${PROTO_BASE}
done
