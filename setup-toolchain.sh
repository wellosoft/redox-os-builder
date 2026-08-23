#!/usr/bin/env bash

# Script to rebuild toolchain for given list of arch

. init.sh

export PREFIX_BINARY=0

if [ "$#" -gt 0 ]; then
    ARCH_LIST="$@"
else
    ARCH_LIST="$ARCH"
fi

for ARCH in $ARCH_LIST; do
    echo "Building toolchain for architecture: $ARCH"
    export ARCH=$ARCH

    PREFIX=prefix/$ARCH-unknown-redox
    mkdir -p ./toolchain/$ARCH-unknown-redox

    (cd redox && make $PREFIX/{rust,relibc,gcc,clang}-install.tar.gz)
    cp -a redox/$PREFIX/{rust,relibc,gcc,clang}-install.tar.gz \
        ./toolchain/$ARCH-unknown-redox/
done
