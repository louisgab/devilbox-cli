main () {
    safe_cd "$(get_devilbox_path)" "Devilbox not found, please make sure it is installed in your home directory or use DEVILBOX_PATH in your profile."
    if [[ $# -eq 0 ]] ; then
        run_command
    else
        case $1 in
            c|config) shift; config_command "$@";;
            e|enter) shift; enter_command;;
            h|help|-h|--help) shift; help_command;;
            o|open) shift; open_command "$@";;
            r|run) shift; run_command "$@";;
            s|stop) shift; stop_command;;
            u|update) shift; update_command;;
            v|version|-v|--version) shift; version_command;;
            *) error "Unknown command $arg, see -h for help.";;
        esac
    fi
}

main "$@"
