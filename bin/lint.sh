#!/usr/bin/env bash

SCRIPT="devilbox-cli.sh"
SRC_PATH="./src/"

command -v shellcheck >/dev/null 2>&1 || { echo >&2 "Shellcheck is required but it's not installed.  Aborting."; exit 1; }

cd "$SRC_PATH" && shellcheck --shell=bash -x "$SCRIPT"

if [ "$?" -eq 0 ]; then
    echo "Valid."
    exit 0
else
    echo "Invalid."
    exit 1
fi
