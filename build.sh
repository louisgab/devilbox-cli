#!/bin/bash

# Config
SCRIPT="devilbox-cli.sh"
DIST_PATH="./dist/"
SRC_PATH="./src/"
BUILD="${DIST_PATH}${SCRIPT}"

# Prevent build if code is not valid
cd "$SRC_PATH" && shellcheck --shell=bash -x "$SCRIPT" || exit

# Prepare dist
cd ..
if [ ! -e "$DIST_PATH" ]; then
    mkdir -p "$DIST_PATH"
fi
if [ -f "$BUILD" ]; then
    rm "$BUILD"
fi

# Add files in same order as src

cat "$SRC_PATH"config.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"utils/codes.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"utils/messages.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"utils/prompt.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"commands/lib/choices.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/lib/config.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/lib/docker.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"commands/config/apache.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config/php.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config/mysql.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config/docroot.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config/projects.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config/databases.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"commands/config.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/enter.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/help.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/open.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/run.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/stop.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/update.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/version.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"main.sh >> "$BUILD" && echo "" >> "$BUILD"

echo "Done."
exit 0
