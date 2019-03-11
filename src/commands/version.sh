version_command() {
    printf "\n"
    printf "%s\n" "$NAME v$VERSION ($DATE)"
    printf "%s\n" "${COLOR_LIGHT_GRAY}$DESCRIPTION${COLOR_DEFAULT}"
    printf "%s\n" "${COLOR_LIGHT_GRAY}$LINK${COLOR_DEFAULT}"
    printf "\n"
}
