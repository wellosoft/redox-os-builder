#!/usr/bin/env bash

. init.sh

export PREFIX_BINARY=0
PREFIX=prefix/$ARCH-unknown-redox
mkdir -p ./toolchain/$ARCH-unknown-redox
cat redox-gitmodules > redox/.gitmodules
(cd redox && make $PREFIX/{rust,relibc,gcc}-install.tar.gz)
cp -a redox/$PREFIX/{rust,relibc,gcc}-install.tar.gz \
    ./toolchain/$ARCH-unknown-redox/
