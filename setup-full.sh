#!/usr/bin/env bash

. init.sh

if [ -n "$PRIVATE_KEY" ] && [ -n "$PUBLIC_KEY" ]; then
  mkdir -p $BUILD_DIR
  printf "%s" "$PRIVATE_KEY" | sed 's/,/\n/g' > "$BUILD_DIR/id_ed25519.toml"
  printf "%s" "$PUBLIC_KEY" | sed 's/,/\n/g' > "$BUILD_DIR/id_ed25519.pub.toml"

  if [ -n "$ARTIFACTS" ] && [ -n "$ARCH" ]; then
    # copy existing repos (for different arch)
    rm -rf $REPOS_DIR
    cp -a $ARTIFACTS $REPOS_DIR || true
    rm -rf $REPOS_DIR/.git $REPOS_DIR/$ARCH-unknown-redox
  fi
else
  echo "\$PRIVATE_KEY or \$PUBLIC_KEY is not set! Skipping key write."
fi

(cd redox && make repo)
cp -a $BUILD_DIR/id_ed25519.pub.toml $REPOS_DIR/id_ed25519.pub.toml
