#!/bin/bash

SCRIPT="devilbox-cli.sh"
DIST_PATH="./dist/"
SRC_PATH="./src/"
BUILD="${DIST_PATH}${SCRIPT}"


# Add files in same order as src
cat "$SRC_PATH"config.sh > "$BUILD" && echo "" >> "$BUILD"

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

cat "$SRC_PATH"commands/check.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/enter.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/exec.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/help.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/mysql.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/open.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/restart.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/run.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/stop.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/update.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/version.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"main.sh >> "$BUILD" && echo "" >> "$BUILD"

chmod +x "$BUILD"

echo "Done."
exit 0
