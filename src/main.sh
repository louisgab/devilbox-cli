safe_cd() {
    local path=$1
    local error_msg=$2
    if [[ ! -d "$path" ]]; then
        error "$error_msg"
    fi
    cd "$path" >/dev/null || error "$error_msg"
}

get_devilbox_path() {
    if [ -n "$DEVILBOX_PATH" ]; then
        printf %s "${DEVILBOX_PATH}"
    else
        printf %s "$HOME/.devilbox"
    fi
}

main () {
    safe_cd "$(get_devilbox_path)" "Devilbox not found, please make sure it is installed in your home directory or use DEVILBOX_PATH in your profile."
    if [[ $# -eq 0 ]] ; then
        version_command
        help_command
    else
        case $1 in
            check) shift; check_command;;
            c|config) shift; config_command "$@";;
            e|enter) shift; enter_command;;
            x|exec) shift; exec_command "$@";;
            h|help|-h|--help) shift; help_command;;
            mysql) shift; mysql_command "$@";;
            o|open) shift; open_command "$@";;
            restart) shift; restart_command "$@";;
            r|run) shift; run_command "$@";;
            s|stop) shift; stop_command;;
            u|update) shift; update_command;;
            v|version|-v|--version) shift; version_command;;
            *) error "Unknown command $arg, see -h for help.";;
        esac
    fi
}

main "$@"
