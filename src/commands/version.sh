command_version() {
    printf "\n"
    printf "%s\n" "${FONT_BOLD}$NAME${FONT_DEFAULT} v$VERSION ($DATE)"
    printf "%s\n" "${FONT_LIGHT_GRAY}$DESCRIPTION${FONT_DEFAULT}"
    printf "%s\n" "${FONT_LIGHT_GRAY}$LINK${FONT_DEFAULT}"
    printf "\n"
}
