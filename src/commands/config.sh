PHP_CONFIG="PHP_SERVER="
APACHE_CONFIG="HTTPD_SERVER=apache-"
MYSQL_CONFIG="MYSQL_SERVER=mysql-"
DOCROOT_CONFIG="HTTPD_DOCROOT_DIR="
WWWPATH_CONFIG="HOST_PATH_HTTPD_DATADIR="

update_config_choice(){
    local config=$1
    local current=$(get_env_choice "$config")
    local choices=( $(get_all_env_choices "$config") )
    local current_index=$(array_search "$current" "${choices[@]}")
    local current_value=${choices["$current_index"]}
    choices[$current_index]="$current_value (current)"
    info "Choose desired version:"
    local result=$(selector "${choices[@]}")
    choices[$current_index]="$current_value"
    set_env_choice "$config" "${choices[$result]}" && success "Version updated to ${choices[$result]}" || error "Version change failed"
}

update_config_value(){
    local config=$1
    local current=$(get_env_value "$config")
    info "Current value is: $current"
    read -r -p "$(question "Enter desired value: ")" response
    set_env_value "$config" "$response" && success "Value updated to $response" || error "Value change failed"
}

list_config () {
    info "Here is your current .env config:"
    printf "\n"
    printf " %-6s: %s\n" "Apache" "$(get_env_choice "$APACHE_CONFIG")"
    printf " %-6s: %s\n" "PHP" "$(get_env_choice "$PHP_CONFIG")"
    printf " %-6s: %s\n" "MySql" "$(get_env_choice "$MYSQL_CONFIG")"
    printf "\n"
    printf " %-6s: %s\n" "Document root" "$(get_env_value "$DOCROOT_CONFIG")"
    printf " %-6s: %s\n" "Projects path" "$(get_env_value "$WWWPATH_CONFIG")"
    printf "\n"
}

set_config () {
    if [[ $# -eq 0 ]] ; then
        die_error "You should precise which config you want to set"
    else
        for arg in "$@"; do
            case $arg in
                -a|--apache) update_config_choice "$APACHE_CONFIG"; shift;;
                -p|--php) update_config_choice "$PHP_CONFIG"; shift;;
                -m|--mysql) update_config_choice "$MYSQL_CONFIG"; shift;;
                -r|--root) update_config_value "$DOCROOT_CONFIG"; shift;;
                -w|--www) update_config_value "$WWWPATH_CONFIG"; shift;;
            esac
        done
    fi
}

man_config () {
    printf "\n%s\n\n" "Usage: $COMMAND config [--args]... "
    printf ' %s:\n  %s\n' "${FONT_BOLD}$COMMAND config help${FONT_DEFAULT}" "${FONT_LIGHT_GRAY}Shows this manual${FONT_DEFAULT}"
    printf ' %s:\n  %s\n' "${FONT_BOLD}$COMMAND config list${FONT_DEFAULT}" "${FONT_LIGHT_GRAY}Lists current configuration${FONT_DEFAULT}"
    printf ' %s:\n  %s\n' "${FONT_BOLD}$COMMAND config set${FONT_DEFAULT} [--apache] [--php] [--mysql]" "${FONT_LIGHT_GRAY}Change a configuration${FONT_DEFAULT}"
}

command_config () {
    if [[ $# -eq 0 ]] ; then
        man_config
    else
        case $1 in
            h|help) shift; man_config;;
            l|list) shift; list_config;;
            s|set) shift; set_config "$@";;
            *) error "Unknown command '$arg', see '$NAME help' for manual";;
        esac
    fi
}
