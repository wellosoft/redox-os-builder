#!/usr/bin/env bash

. init.sh

export PREFIX_BINARY=0
PREFIX=prefix/$ARCH-unknown-redox
mkdir -p ./toolchain/$ARCH-unknown-redox
(cd redox && make $PREFIX/rust-install.tar.gz $PREFIX/relibc-install.tar.gz $PREFIX/gcc-install.tar.gz)
cp -a redox/$PREFIX/rust-install.tar.gz redox/$PREFIX/relibc-install.tar.gz redox/$PREFIX/gcc-install.tar.gz ./toolchain/$ARCH-unknown-redox/

