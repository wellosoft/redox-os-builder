#!/usr/bin/env bash

. config
git clone $REDOX_REPO -b $REDOX_BRANCH --depth 1
export PATH=$HOME/.cargo/bin:$PATH
export BUILD_DIR=redox/build
export REPOS_DIR=redox/repo
export PREFIX_PATH=redox/prefix/$ARCH-unknown-redox/sysroot
. redox/podman/rustinstall.sh
cp config ./redox/.config
cp -a build ./redox/build
