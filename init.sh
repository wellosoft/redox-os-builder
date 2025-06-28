#!/usr/bin/env bash

. config
git clone $REDOX_REPO -b $REDOX_BRANCH --depth 1
git -C redox submodule update --init --recursive --depth 1
sed -i '/--verbose/d' redox/cookbook/src/bin/cook.rs
export PATH=$HOME/.cargo/bin:$PATH
export BUILD_DIR=redox/cookbook/build
export REPOS_DIR=redox/cookbook/repo
. redox/podman/rustinstall.sh
cp config ./redox/.config
cp -a build ./redox/build
