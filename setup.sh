#!/usr/bin/env bash

git clone https://gitlab.redox-os.org/willnode/redox -b personal --depth 1
git -C redox submodule update --init --recursive --depth 1
export PATH=$HOME/.cargo/bin:$PATH
. redox/podman/rustinstall.sh
cp config ./redox/.config
cp -a build ./redox/build
# must sync with config: build/<ARCH>/<CONFIG>/repo.tag
(cd redox && make build/x86_64/dev/repo.tag || true)
