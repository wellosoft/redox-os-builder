#!/usr/bin/env bash

git clone https://gitlab.redox-os.org/willnode/redox -b faster-libtool-clone --depth 1
(cd redox && git submodule update --init --recursive --depth 1)
export PATH=$HOME/.cargo/bin:$PATH
. redox/podman/rustinstall.sh
cp config ./redox/.config
cp -a build ./redox/build
(cd redox && make build/x86_64/demo/repo.tag)
