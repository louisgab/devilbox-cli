#!/usr/bin/env bash

SCRIPT="devilbox-cli.sh"
DIST_PATH="./dist/"
SRC_PATH="./src/"
BUILD="${DIST_PATH}${SCRIPT}"


# Add files in same order as src
cat "$SRC_PATH"global.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"utils/format.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"utils/codes.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"utils/prompt.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"utils/env.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"utils/semver.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"utils/filesytem.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"utils/loading.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"utils/select.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"commands/lib/config.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/lib/docker.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/lib/man.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"commands/config/apache.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config/php.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config/mysql.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config/docroot.sh >> "$BUILD" && echo "" >> "$BUILD"
cat "$SRC_PATH"commands/config/projects.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"commands/config.sh >> "$BUILD" && echo "" >> "$BUILD"
# cat "$SRC_PATH"commands/help.sh >> "$BUILD" && echo "" >> "$BUILD"
# cat "$SRC_PATH"commands/open.sh >> "$BUILD" && echo "" >> "$BUILD"
# cat "$SRC_PATH"commands/update.sh >> "$BUILD" && echo "" >> "$BUILD"
# cat "$SRC_PATH"commands/version.sh >> "$BUILD" && echo "" >> "$BUILD"

cat "$SRC_PATH"main.sh >> "$BUILD" && echo "" >> "$BUILD"

chmod +x "$BUILD"

echo "Done."
exit 0
