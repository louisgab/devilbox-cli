#!/bin/bash

SCRIPT="devilbox-cli.sh"
DIST_PATH="./dist/"
BUILD="${DIST_PATH}${SCRIPT}"

if [ -f "$BUILD" ]; then
    rm -rf "$BUILD"
fi

if [ ! -e "$DIST_PATH" ]; then
    mkdir -p "$DIST_PATH"
fi

echo "Done."
exit 0
