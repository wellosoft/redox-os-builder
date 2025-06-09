#!/usr/bin/env bash

. init.sh

if [ -n "$PRIVATE_KEY" ] && [ -n "$PUBLIC_KEY" ] && [ -n "$ARTIFACTS" ]; then
  mkdir -p redox/cookbook/build
  printf "%s" "$PRIVATE_KEY" | sed 's/,/\n/g' > "redox/cookbook/build/id_ed25519.toml"
  printf "%s" "$PUBLIC_KEY" | sed 's/,/\n/g' > "redox/cookbook/build/id_ed25519.pub.toml"
  rm -rf redox/cookbook/repo
  cp -a $ARTIFACTS redox/cookbook/repo
  rm -rf redox/cookbook/repo/.git
else
  echo "\$PRIVATE_KEY or \$PUBLIC_KEY or \$ARTIFACTS is not set! Can't do partial build!"
  exit 1
fi

targets="$@"
prefixed_targets=$(for t in $targets; do echo -n "r.$t "; done)
(cd redox && make $prefixed_targets)
cp -a redox/cookbook/build/id_ed25519.pub.toml redox/cookbook/repo/id_ed25519.pub.toml
