get_devilbox_path() {
    [ -n "$DEVILBOX_PATH" ] && printf %s "${DEVILBOX_PATH}" || printf %s "$HOME/.devilbox"
}

get_env_path() {
    printf %s "$(get_devilbox_path)/.env"
}

base_checks() {
    safe_cd "$(get_devilbox_path)" || error "Devilbox not found, please make sure it is installed in your home directory or use DEVILBOX_PATH in your profile."
    file_exists "$(get_env_path)" || error ".env file not found, please initiate it with .env.example, then you will be able to manage it with this cli."
}

main () {
    base_checks
    if [[ $# -eq 0 ]] ; then
        command_help
    else
        case $1 in
            cli) shift; command_cli "$@";;
            config) shift; command_config "$@";;
            dock) shift; dock_command "$@";;
            help|-h|--help) shift; command_help "$@";;
            version|-v|--version) shift; command_version;;
            *) error "Unknown command $1, see -h for help.";;
        esac
    fi
}

main "$@"
