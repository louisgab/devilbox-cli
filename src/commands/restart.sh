restart_command() {
    stop_command
    run_command "$@"
}
