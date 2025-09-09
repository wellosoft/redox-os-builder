#!/usr/bin/env bash

. init.sh

if [ -n "$PRIVATE_KEY" ] && [ -n "$PUBLIC_KEY" ] && [ -n "$ARTIFACTS" ]; then
  mkdir -p $BUILD_DIR
  printf "%s" "$PRIVATE_KEY" | sed 's/,/\n/g' > "$BUILD_DIR/id_ed25519.toml"
  printf "%s" "$PUBLIC_KEY" | sed 's/,/\n/g' > "$BUILD_DIR/id_ed25519.pub.toml"
  rm -rf $REPOS_DIR
  cp -a $ARTIFACTS $REPOS_DIR
  rm -rf $REPOS_DIR/.git
else
  echo "\$PRIVATE_KEY or \$PUBLIC_KEY or \$ARTIFACTS is not set! Can't do partial build!"
  exit 1
fi

targets="$@"
(export PATH="$PWD/$PREFIX_PATH/bin:$PATH" COOKBOOK_HOST_SYSROOT="$PWD/$PREFIX_PATH" && \
  cd redox && make prefix fstools && cd cookbook && ./repo.sh --nonstop --with-package-deps $targets)
cp -a $BUILD_DIR/id_ed25519.pub.toml $REPOS_DIR/id_ed25519.pub.toml
