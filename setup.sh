#!/usr/bin/env bash

. init.sh

if [ -n "$PRIVATE_KEY" ] && [ -n "$PUBLIC_KEY" ]; then
  mkdir -p redox/cookbook/build
  printf "%s" "$PRIVATE_KEY" | sed 's/,/\n/g' > "redox/cookbook/build/id_ed25519.toml"
  printf "%s" "$PUBLIC_KEY" | sed 's/,/\n/g' > "redox/cookbook/build/id_ed25519.pub.toml"
else
  echo "\$PRIVATE_KEY or \$PUBLIC_KEY is not set! Skipping key write."
fi

# must sync with config: build/<ARCH>/<CONFIG>/repo.tag
(cd redox && make build/$ARCH/$CONFIG_NAME/repo.tag)
cp -a redox/cookbook/build/id_ed25519.pub.toml redox/cookbook/repo/id_ed25519.pub.toml
