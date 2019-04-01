#!/bin/bash

SCRIPT="devilbox-cli.sh"
DIST_PATH="./dist/"
BUILD="${DIST_PATH}${SCRIPT}"

cd ..
if [ ! -e "$DIST_PATH" ]; then
    mkdir -p "$DIST_PATH"
fi
if [ -f "$BUILD" ]; then
    rm "$BUILD"
fi

echo "Done."
exit 0
