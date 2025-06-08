#!/usr/bin/env bash

git clone https://gitlab.redox-os.org/willnode/redox -b faster-libtool-clone --depth 1
(cd redox && git submodule update --init --recursive --depth 1)
export PATH=~/.cargo:$PATH
. redox/podman/rustinstall.sh
cp config ./redox/.config
(cd redox && make build/x86_64/base/repo.tag)
