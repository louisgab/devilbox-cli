#!/bin/bash

VERSION="0.4.1"
DATE="2020-12-06"
NAME="devilbox-cli"
DESCRIPTION="A simple and conveniant command line to manage devilbox from anywhere"
LINK="https://github.com/louisgab/devilbox-cli"

ENV_FILE=".env"

PHP_CONFIG="PHP_SERVER="
APACHE_CONFIG="HTTPD_SERVER=apache-"
MYSQL_CONFIG="MYSQL_SERVER=mysql-"
DOCROOT_CONFIG="HTTPD_DOCROOT_DIR="
WWWPATH_CONFIG="HOST_PATH_HTTPD_DATADIR="

## Basic wrappers around exit codes

OK_CODE=0
KO_CODE=1

was_success() {
    local exit_code=$?
    [ "$exit_code" -eq "$OK_CODE" ]
}

was_error() {
    local exit_code=$?
    [ "$exit_code" -eq "$KO_CODE" ]
}

die () {
    local exit_code=$1
    if [ ! -z "$exit_code" ]; then
        exit "$exit_code"
    else
        exit "$?"
    fi
}

## Functions used for fancy output

COLOR_DEFAULT=$(tput sgr0)
COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput setaf 3)
COLOR_BLUE=$(tput setaf 4)
# COLOR_PURPLE=$(tput setaf 5)
# COLOR_CYAN=$(tput setaf 6)
COLOR_LIGHT_GRAY=$(tput setaf 7)
COLOR_DARK_GRAY=$(tput setaf 0)

error() {
    local message=$1
    printf "%s %s\n" "${COLOR_RED}[✘]" "${COLOR_DEFAULT}$message" >&2
    die "$KO_CODE"
}

success() {
    local message=$1
    printf "%s %s\n" "${COLOR_GREEN}[✔]" "${COLOR_DEFAULT}$message"
}

info() {
    local message=$1
    printf "%s %s\n" "${COLOR_YELLOW}[!]" "${COLOR_DEFAULT}$message"
}

question() {
    local message=$1
    printf "%s %s\n" "${COLOR_BLUE}[?]" "${COLOR_DEFAULT}$message"
}

## Functions used for user interaction

has_confirmed() {
    local response=$1
    case "$response" in
        [yY][eE][sS]|[yY]) return "$OK_CODE";;
        *) return "$KO_CODE";;
    esac
}

ask() {
    local question=$1
    local response
    read -r -p "$(question "${question} [y/N] ")" response
    printf '%s' "$response"
    return "$OK_CODE"
}

confirm() {
    local question=$1
    if has_confirmed "$(ask "$question")"; then
        return "$OK_CODE"
    else
        return "$KO_CODE"
    fi
}

## Functions used to manipulate choices values in .env file

is_choice_existing () {
    local config=$1
    local choice=$2
    local search
    search=$(grep -Eo "^#*$config$choice" "$ENV_FILE")
    if was_success && [ ! -z "$search" ] ;then
        return "$OK_CODE"
    else
        return "$KO_CODE"
    fi
}

get_current_choice () {
    local config=$1
    local current
    current=$(grep -Eo "^$config+[.[:digit:]]*" "$ENV_FILE" | sed "s/.*$config//g")
    if was_success && [ ! -z "$current" ] ;then
        printf "%s" "$current"
        return "$OK_CODE"
    else
        return "$KO_CODE"
    fi
}

is_choice_available() {
    local config=$1
    local choice=$2
    local current
    current=$(get_current_choice "$config")
    if was_success && [ "$choice" != "$current" ] ;then
        return "$OK_CODE"
    else
        return "$KO_CODE"
    fi
}

get_all_choices () {
    local config=$1
    local all
    all=$(grep -Eo "^#*$config+[.[:digit:]]*" "$ENV_FILE" | sed "s/.*$config//g")
    if was_success && [ ! -z "$all" ] ;then
        printf "%s\n" "$all"
        return "$OK_CODE"
    else
        return "$KO_CODE"
    fi
}

set_choice () {
    local config=$1
    local new=$2
    local current
    if ! is_choice_existing "$config" "$new" ||  ! is_choice_available "$config" "$new"; then
        return "$KO_CODE"
    fi
    current=$(get_current_choice "$config")
    if was_error; then
        return "$KO_CODE"
    fi
    sed -i -e "s/\(^#*$config$current\).*/#$config$current/" "$ENV_FILE"
    if was_error; then
        return "$KO_CODE"
    fi
    sed -i -e "s/\(^#*$config$new\).*/$config$new/" "$ENV_FILE"
    if was_error; then
        return "$KO_CODE"
    fi
    current=$(get_current_choice "$config")
    if was_success && [[ "$current" = "$new" ]]; then
        return "$OK_CODE"
    else
        return "$KO_CODE"
    fi
}

### READABLE VERSIONS

is_readable_choice_existing () {
    local type=$1
    local config=$2
    local choice=$3
    if is_choice_existing "$config" "$choice"; then
        success "$type version $choice is existing"
        return "$OK_CODE"
    else
        error "$type version $choice does not exists"
        return "$K0_CODE"
    fi
}

get_readable_current_choice () {
    local type=$1
    local config=$2
    local current
    current=$(get_current_choice "$config")
    if was_success; then
        info "$type current version is $current"
        return "$OK_CODE"
    else
        error "Couldnt retrieve current version of $type"
        return "$KO_CODE"
    fi
}

is_readable_choice_available() {
    local config=$1
    local choice=$2
    local isavailable
    if is_choice_available "$config" "$choice"; then
        success "$type version $choice is available"
        return "$OK_CODE"
    else
        error "$type is already using version $choice"
        return "$K0_CODE"
    fi
}

get_readable_all_choices () {
    local type=$1
    local config=$2
    local all
    all=$(get_all_choices "$config")
    if was_success; then
        info "$type available versions:"
        printf "%s\n" "$all"
        return "$OK_CODE"
    else
        error "Couldnt retrive available versions of $type"
        return "$KO_CODE"
    fi
}

set_readable_choice () {
    local type=$1
    local config=$2
    local new=$3
    if ! is_readable_choice_existing "$type" "$config" "$new"; then
        return "$KO_CODE"
    fi
    if ! is_readable_choice_available "$config" "$new"; then
        return "$KO_CODE"
    fi
    if set_choice "$config" "$new"; then
        success "$type version updated to $new"
        return "$OK_CODE"
    else
        error "$type version change failed"
        return "$KO_CODE"
    fi
}

## Functions used to manipulate a config value in .env file

get_config () {
    local config=$1
    local current
    current=$(grep -Eo "^$config+[[:alnum:][:punct:]]*" "$ENV_FILE" | sed "s/.*$config//g")
    if was_success && [ ! -z "$current" ] ;then
        printf "%s" "$current"
        return "$OK_CODE"
    else
        return "$KO_CODE"
    fi
}

set_config () {
    local config=$1
    local new=$2
    local current
    current="$(get_config "$config")"
    if was_error; then
        return "$KO_CODE"
    fi
    sed -i -e "s/\(^#*$config${current//\//\\\/}\).*/$config${new//\//\\\/}/" "$ENV_FILE"
    if was_error; then
        return "$KO_CODE"
    fi
    current="$(get_config "$config")"
    if was_success && [[ "$current" = "$new" ]]; then
        return "$OK_CODE"
    else
        return "$KO_CODE"
    fi
}

### READABLE VERSIONS

get_readable_current_config () {
    local type=$1
    local config=$2
    local current
    current=$(get_config "$config")
    if was_success; then
        info "$type current config is $current"
        return "$OK_CODE"
    else
        error "Couldnt retrieve current config of $type"
        return "$KO_CODE"
    fi
}

set_readable_config () {
    local type=$1
    local config=$2
    local new=$3
    if set_config "$config" "$new"; then
        success "$type config updated to $new"
        return "$OK_CODE"
    else
        error "$type config change failed"
        return "$KO_CODE"
    fi
}

is_running () {
    local all
    all=$(docker-compose ps 2> /dev/null | grep "devilbox" | awk '{print $3}' | grep "Up")
    if was_success; then
        return "$OK_CODE";
    else
        return "$KO_CODE";
    fi
}

get_current_apache_version () {
    get_readable_current_choice "Apache" "$APACHE_CONFIG"
}

get_all_apache_versions () {
    get_readable_all_choices "Apache" "$APACHE_CONFIG"
}

set_apache_version () {
    local new=$1
    set_readable_choice "Apache" "$APACHE_CONFIG" "$new"
}

get_current_php_version () {
    get_readable_current_choice "PHP" "$PHP_CONFIG"
}

get_all_php_versions () {
    get_readable_all_choices "PHP" "$PHP_CONFIG"
}

set_php_version () {
    local new=$1
    set_readable_choice "PHP" "$PHP_CONFIG" "$new"
}

get_current_mysql_version () {
    get_readable_current_choice "MySql" "$MYSQL_CONFIG"
}

get_all_mysql_versions () {
    get_readable_all_choices "MySql" "$MYSQL_CONFIG"
}

set_mysql_version () {
    local new=$1
    set_readable_choice "MySql" "$MYSQL_CONFIG" "$new"
}

get_current_document_root () {
    get_readable_current_config "Document root" "$DOCROOT_CONFIG"
}

set_document_root () {
    local new=$1
    set_readable_config "Document root" "$DOCROOT_CONFIG" "$new"
}

get_current_projects_path () {
    get_readable_current_config "Projects path" "$WWWPATH_CONFIG"
}

set_projects_path () {
    local new=$1
    set_readable_config "Projects path" "$WWWPATH_CONFIG" "$new"
}

check_command () {
    ./check-config.sh
}

config_command () {
    for arg in "$@"; do
        case $arg in
            -a=\*|--apache=\*) get_all_apache_versions; shift;;
            -a=*|--apache=*) set_apache_version "${arg#*=}"; shift;;
            -a|--apache) get_current_apache_version; shift;;
            -p=\*|--php=\*) get_all_php_versions; shift;;
            -p=*|--php=*) set_php_version "${arg#*=}"; shift;;
            -p|--php) get_current_php_version; shift;;
            -m=\*|--mysql=\*) get_all_mysql_versions; shift;;
            -m=*|--mysql=*) set_mysql_version "${arg#*=}"; shift;;
            -m|--mysql) get_current_mysql_version; shift;;
            -r=*|--root=*) set_document_root "${arg#*=}"; shift;;
            -r|--root) get_current_document_root; shift;;
            -w=*|--www=*) set_projects_path "${arg#*=}"; shift;;
            -w|--www) get_current_projects_path; shift;;
        esac
    done
}

enter_command () {
    if ! is_running; then
        error "Devilbox containers are not running"
        return "$KO_CODE"
    fi
    ./shell.sh
}

exec_command() {
    if ! is_running; then
        error "Devilbox containers are not running"
        return "$KO_CODE"
    fi

    docker-compose exec -u devilbox php bash -c "$@"
}

add_usage_command () {
    local command=$1
    local description=$2
    printf '%-30s\t %s\n' "$command" "${COLOR_DARK_GRAY}$description${COLOR_DEFAULT}"
}

add_usage_arg () {
    local arg=$1
    local description=$2
    printf '%-30s\t %s\n' "  ${COLOR_LIGHT_GRAY}$arg" "${COLOR_DARK_GRAY}$description${COLOR_DEFAULT}"
}

help_command () {
    printf "\n"
    printf "%s\n" "Usage: $0 <command> [--args]... "
    printf "\n"
    add_usage_command "check" "Check your .env file for potential errors"
    add_usage_command "c,config" "Show / Edit the current config"
    add_usage_arg "-a=<x.x>,--apache=<x.x>" "Set a specific apache version"
    add_usage_arg "-a=*,--apache=*" "Get all available apache versions"
    add_usage_arg "-p=*,--php=*" "Get all available php versions"
    add_usage_arg "-m=*,--mysql=*" "Get all available mysql versions"
    add_usage_arg "-p,--php" "Get current php version"
    add_usage_arg "-a,--apache" "Get current apache version"
    add_usage_arg "-m,--mysql" "Get current mysql version"
    add_usage_arg "-r=<path>,--root=<path>" "Set the document root"
    add_usage_arg "-r,--root" "Get the current document root"
    add_usage_arg "-w=<path>,--www=<path>" "Set the path to projects"
    add_usage_arg "-w,--www" "Get the current path to projects"
    add_usage_arg "-d=<path>,--database=<path>" "Set the path to databases"
    add_usage_arg "-d,--database" "Get the current path to databases"
    add_usage_arg "-p=<x.x>,--php=<x.x>" "Set a specific php version"
    add_usage_arg "-m=<x.x>,--mysql=<x.x>" "Set a specific mysql version"
    add_usage_command "e,enter" "Enter the devilbox shell"
    add_usage_command "x, exec '<command>'" "Execute a command inside the container without entering it"
    add_usage_command "h, help" "List all available commands"
    add_usage_command "mysql ['<query>']" "Launch a preconnected mysql shell, with optional query"
    add_usage_command "o,open" "Open the devilbox intranet"
    add_usage_arg "-h,--http" "Use non-https url"
    add_usage_command "restart" "Restart the devilbox docker containers"
    add_usage_arg "-s,--silent" "Hide errors and run in background"
    add_usage_command "r,run" "Run the devilbox docker containers"
    add_usage_arg "-s,--silent" "Hide errors and run in background"
    add_usage_command "s,stop" "Stop devilbox and docker containers"
    add_usage_command "u,update" "Update devilbox and docker containers"
    add_usage_command "v, version" "Show version information"
    printf "\n"
}

mysql_command() {
    if ! is_running; then
        error "Devilbox containers are not running"
        return "$KO_CODE"
    fi

    if [ -z "$1" ]; then
        exec_command 'mysql -hmysql -uroot'
    else
        exec_command "mysql -hmysql -uroot -e '$1'"
    fi
}

open_http_intranet () {
    xdg-open "http://localhost/" 2> /dev/null >/dev/null
}

open_https_intranet () {
    xdg-open "https://localhost/" 2> /dev/null >/dev/null
}

open_command () {
    if ! is_running; then
        error "Devilbox containers are not running"
        return "$KO_CODE"
    fi
    if [[ $# -eq 0 ]] ; then
        open_https_intranet
    else
        for arg in "$@"; do
            case $arg in
                -h|--http) open_http_intranet; shift;;
            esac
        done
    fi
}

restart_command() {
    stop_command
    run_command "$@"
}

get_default_containers() {
   if [ -n "$DEVILBOX_CONTAINERS" ]; then
        printf %s "${DEVILBOX_CONTAINERS}"
    else
        printf %s "httpd php mysql"
    fi
}

run_containers () {
    docker-compose up $(get_default_containers)
}

run_containers_silent () {
    docker-compose up -d $(get_default_containers)
}

run_command () {
    if is_running; then
        error "Devilbox containers are already running"
        return "$KO_CODE"
    fi
    if [[ $# -eq 0 ]] ; then
        run_containers
    else
        for arg in "$@"; do
            case $arg in
                -s|--silent) run_containers_silent; shift;;
            esac
        done
    fi
}

stop_command () {
    if ! is_running; then
        error "Devilbox containers are not running"
        return "$KO_CODE"
    fi
    docker-compose stop
    docker-compose rm -f
}

get_recent_devilbox_versions () {
    local versions
    versions=$(git fetch --tags && git describe --abbrev=0 --tags $(git rev-list --tags --max-count=10))
    if was_success; then
        info "Devilbox available versions:"
        printf "%s\n" "$versions"
        return "$OK_CODE"
    else
        error "Couldnt retrive available versions of devilbox"
        return "$KO_CODE"
    fi
}

latest_version () {
    local latest
    latest=$(git fetch --tags && git describe --abbrev=0 --tags $(git rev-list --tags --max-count=1))
    if was_success; then
        info "Devilbox latest version is $latest"
        return "$OK_CODE"
    else
        error "Couldnt retrieve latest version of devilbox"
        return "$KO_CODE"
    fi
}

set_devilbox_version () {
    local version=$1
    confirm "Did you backup your databases before?"
    if was_success ;then
        git fetch --tags && git checkout $version
        if was_success; then
            success "Devilbox updated to $version, please restart"
            return "$OK_CODE"
        else
            error "Couldnt update devilbox"
            return "$KO_CODE"
        fi
    fi
}

update_command () {
    if is_running; then
        error "Devilbox containers are running, please use devilbox stop"
        return "$KO_CODE"
    fi
    for arg in "$@"; do
        case $arg in
            -v=\*|--version=\*) get_recent_devilbox_versions; shift;;
            -v=*|--version=*) set_devilbox_version "${arg#*=}"; shift;;
            -v=latest|--version=latest) set_devilbox_version "$(latest_version)"; shift;;
            -d|--docker) sh update-docker.sh; shift;;
        esac
    done
}

version_command() {
    printf "\n"
    printf "%s\n" "$NAME v$VERSION ($DATE)"
    printf "%s\n" "${COLOR_LIGHT_GRAY}$DESCRIPTION${COLOR_DEFAULT}"
    printf "%s\n" "${COLOR_LIGHT_GRAY}$LINK${COLOR_DEFAULT}"
    printf "\n"
}

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

