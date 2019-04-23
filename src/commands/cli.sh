get_latest_cli_version() {
    local latest
    echo "$!"
    latest=$(curl -s "https://api.github.com/repos/$AUTHOR/$REPO/tags" | grep '"name":' | sed -E 's/.*"([^"]+)".*/\1/' | head -n1)
    echo "$!"
    was_success && [ ! -z "$latest" ] && printf "%s\n" "$latest"
}

check_cli_version() {
    local latest
    local current
    current=$VERSION
    latest=$(get_latest_cli_version)
    die_on_error "Failed to retrieve latest cli version available"
    if [[ "$current" = "$latest" ]]; then
        info "You are already using the latest cli version"
        return "$OK_CODE"
    fi
    if is_version_newer "$latest" "$current"; then
        info "A new version of cli is available!"
        confirm "Would to like to update now?"
        was_success && update_cli_version
    fi
}

update_cli_version () {
    npm update -g "$NAME" && success "Update success" || error "Failed to update"
}

get_cli_current_version () {
    info "Cli current version is $VERSION"
}

cli_man () {
    man_command "cli" "Manages this cli"
    man_arg "-v,--version" "Get cli current version"
    man_arg "-u,--update" "Check for cli new version"
}

command_cli () {
    if [[ $# -eq 0 ]] ; then
        man_cli
    else
        case $1 in
            -t|--test) get_latest_cli_version; shift;;
            -v|--version) get_cli_current_version; shift;;
            -u|--update) check_cli_version; shift;;
            *) error "Unknown command $arg, see '$NAME help' for manual";;
        esac
    fi
}
