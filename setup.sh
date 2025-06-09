#!/usr/bin/env bash

git clone https://gitlab.redox-os.org/willnode/redox -b personal --depth 1
git -C redox submodule update --init --recursive --depth 1
sed -i '/--verbose/d' redox/cookbook/src/bin/cook.rs
export PATH=$HOME/.cargo/bin:$PATH
. redox/podman/rustinstall.sh
cp config ./redox/.config
cp -a build ./redox/build

if [ -n "$PRIVATE_KEY" ] && [ -n "$PUBLIC_KEY" ]; then
  printf "%s" "$PRIVATE_KEY" > "redox/cookbook/build/id_ed25519.toml"
  printf "%s" "$PUBLIC_KEY" > "redox/cookbook/build/id_ed25519.pub.toml"
else
  echo "PRIVATE_KEY or PUBLIC_KEY is not set! Skipping key write."
fi

# must sync with config: build/<ARCH>/<CONFIG>/repo.tag
(cd redox && make build/x86_64/dev/repo.tag)
cp -a redox/cookbook/build/id_ed25519.pub.toml redox/cookbook/repo/id_ed25519.pub.toml
