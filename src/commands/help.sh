command_help () {
    if [[ $# -eq 0 ]] ; then
        printf "\n%s\n\n" "Usage: $COMMAND <command> [--args]... "
        printf ' %s\n  %s\n' "${FONT_BOLD}$COMMAND cli${FONT_DEFAULT} [--args].." "${FONT_LIGHT_GRAY}Manages this client${FONT_DEFAULT}"
        printf ' %s\n  %s\n' "${FONT_BOLD}$COMMAND config${FONT_DEFAULT} [--args].." "${FONT_LIGHT_GRAY}Manages your .env file${FONT_DEFAULT}"
        printf ' %s\n  %s\n' "${FONT_BOLD}$COMMAND dock${FONT_DEFAULT} [--args].." "${FONT_LIGHT_GRAY}Manages your containers${FONT_DEFAULT}"
        printf ' %s\n  %s\n' "${FONT_BOLD}$COMMAND help${FONT_DEFAULT} [--args].." "${FONT_LIGHT_GRAY}Shows this manual${FONT_DEFAULT}"
        printf ' %s\n  %s\n' "${FONT_BOLD}$COMMAND version${FONT_DEFAULT}" "${FONT_LIGHT_GRAY}Displays client and devilbox versions${FONT_DEFAULT}"
    else
        case $1 in
            cli) shift; man_cli;;
            config) shift; man_config;;
            dock) shift; man_dock;;
            help) shift; man_help;;
            *) error "Unknown command $1, see -h for help.";;
        esac
    fi
}
