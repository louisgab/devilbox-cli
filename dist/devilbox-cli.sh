#!/bin/bash

VERSION="0.1.0"
DATE="2019-03-10"
NAME="devilbox-cli"
DESCRIPTION="A devilbox cli tool to interact with devilbox from anywhere"
LINK="https://github.com/louisgab/devilbox-cli"

ENV_FILE=".env"

PHP_CONFIG="PHP_SERVER="
APACHE_CONFIG="HTTPD_SERVER=apache-"
MYSQL_CONFIG="MYSQL_SERVER=mysql-"
DOCROOT_CONFIG="HTTPD_DOCROOT_DIR="
WWWPATH_CONFIG="HOST_PATH_HTTPD_DATADIR="
DBPATH_CONFIG="HOST_PATH_MYSQL_DATADIR="

COLOR_DEFAULT=$(tput sgr0)
COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput setaf 3)
COLOR_BLUE=$(tput setaf 4)
# COLOR_PURPLE=$(tput setaf 5)
# COLOR_CYAN=$(tput setaf 6)
COLOR_LIGHT_GRAY=$(tput setaf 7)
COLOR_DARK_GRAY=$(tput setaf 0)

## Basic wrappers around exit codes

OK_CODE=0
KO_CODE=1

ok_code () {
    printf "%d" "$OK_CODE"
}

ko_code () {
    printf "%d" "$KO_CODE"
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
    printf "%-20s\n" "${COLOR_BLUE}[?]" "${COLOR_DEFAULT}$message"
}

## Functions used to acces the filesystem safely

safe_cd() {
    local path=$1
    local error_msg=$2
    if [[ ! -d "$path" ]]; then
        error "$error_msg"
    fi
    cd "$path" >/dev/null || error "$error_msg"
}

result() {
    local exit_code=$1
    local success_action=$2
    local error_action=$3
    if [ "$exit_code" -eq "$OK_CODE" ]; then
        $success_action
    else
        $error_action
    fi
    return "$exit_code"
}

has_confirmed() {
    local response=$1
    case "$response" in
        [yY][eE][sS]|[yY]) ok_code;;
        *) ko_code;;
    esac
}

ask_confirmation() {
    local question=$1
    local action=$2
    read -r -p "$(question "${question}" [y/N])" response
    isconfirmed="$(has_confirmed "$response")"
    result "$isconfirmed" "$action" die
}

## Functions used to manipulate choices values in .env file

is_choice_existing () {
    local config=$1
    local choice=$2
    local search
    search=$(grep -qF "$config$choice" "$ENV_FILE")
    if [ -z "$search" ] ;then
        ok_code
    else
        ko_code
    fi
}

get_current_choice () {
    local config=$1
    local current
    current=$(grep -Eo "^$config+[.[:digit:]]*" "$ENV_FILE" | sed "s/.*$config//g")
    if [ -z "$current" ] ;then
        printf "%s" "$current"
    else
        ko_code
    fi
}

get_all_choices () {
    local config=$1
    local all
    all=$(grep -Eo "^#*$config+[.[:digit:]]*" "$ENV_FILE" | sed "s/.*$config//g")
    printf "%s" "$all"
}

set_choice () {
    local config=$1
    local new=$2
    local current
    local isvalid
    current="$(get_current_choice "$config")"
    isvalid="$(is_choice_existing "$new")"
    if [[ $isvalid -ne 0 ]]; then
        ko_code
    else
        sed -i -e "s/\(^#*$config$current\).*/#$config$current/" "$ENV_FILE"
        sed -i -e "s/\(^#*$config$new\).*/$config$new/" "$ENV_FILE"
        current="$(get_current_choice "$config")"
        if [[ "$current" = "$new" ]]; then
            ok_code
        else
            ko_code
        fi
    fi
}

## Functions used to manipulate a config value in .env file

get_config () {
    local config=$1
    local current
    current=$(grep -Eo "^$config+[[:alnum:][:punct:]]*" "$ENV_FILE" | sed "s/.*$config//g")
    printf "%s" "$current"
}

set_config () {
    local config=$1
    local new=$2
    local current
    current="$(get_config "$config")"
    sed -i -e "s/\(^#*$config${current//\//\\\/}\).*/$config${new//\//\\\/}/" "$ENV_FILE"
    current="$(get_config "$config")"
    if [[ "$current" = "$new" ]]; then
        ok_code
    else
        ko_code
    fi
}

get_devilbox_path() {
    if [ -n "$DEVILBOX_PATH" ]; then
        printf %s "${DEVILBOX_PATH}"
    else
        printf %s "$HOME/.devilbox"
    fi
}

is_readable_version_existing () {
    local type=$1
    local config=$2
    local version=$3
    local isvalid
    isvalid=$(is_version_existing "$config" "$version")
    if [[ "$isvalid" -eq 0 ]] ;then
        success "$type version $version is available"
    else
        error "$type version $version does not exists"
    fi
}

get_readable_current_version () {
    local type=$1
    local config=$2
    local current
    current=$(get_current_version "$config")
    if [[ -n "$current" ]]; then
        info "$type current version is $current"
    else
        error "Couldnt retrieve current version of $type"
    fi
}

get_readable_all_versions () {
    local type=$1
    local config=$2
    local all
    all=$(get_all_versions "$config")
    if [[ -n "$all" ]]; then
        info "$type available versions:"
        printf "%s" "$all"
    else
        error "Couldnt retrive available versions of $type"
    fi
}

set_readable_version () {
    local type=$1
    local config=$2
    local new=$3
    if [[ "$(set_version "$config" "$new")" = "0" ]]; then
        success "$type version updated to $new"
    else
        error "$type version change failed"
    fi
}

get_readable_current_config () {
    local type=$1
    local config=$2
    local current
    current=$(get_config "$config")
    if [[ -n "$current" ]]; then
        info "$type current config is $current"
    else
        error "Couldnt retrieve current config of $type"
    fi
}

set_readable_config () {
    local type=$1
    local config=$2
    local new=$3
    if [[ "$(set_config "$config" "$new")" = "0" ]]; then
        success "$type config updated to $new"
    else
        error "$type config change failed"
    fi
}

get_current_apache_version () {
    get_readable_current_version "Apache" "$APACHE_CONFIG"
}

get_all_apache_versions () {
    get_readable_all_versions "Apache" "$APACHE_CONFIG"
}

set_apache_version () {
    local new=$1
    set_readable_version "Apache" "$APACHE_CONFIG" "$new"
}

get_current_php_version () {
    get_readable_current_version "PHP" "$PHP_CONFIG"
}

get_all_php_versions () {
    get_readable_all_versions "PHP" "$PHP_CONFIG"
}

set_php_version () {
    local new=$1
    set_readable_version "PHP" "$PHP_CONFIG" "$new"
}

get_current_mysql_version () {
    get_readable_current_version "MySql" "$MYSQL_CONFIG"
}

get_all_mysql_versions () {
    get_readable_all_versions "MySql" "$MYSQL_CONFIG"
}

set_mysql_version () {
    local new=$1
    set_readable_version "MySql" "$MYSQL_CONFIG" "$new"
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

get_current_databases_path () {
    get_readable_current_config "Databases path" "$DBPATH_CONFIG"
}

set_databases_path () {
    local new=$1
    set_readable_config "Databases path" "$DBPATH_CONFIG" "$new"
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
            -d=*|--database=*) set_databases_path "${arg#*=}"; shift;;
            -d|--database) get_current_databases_path; shift;;
        esac
    done
}

enter_command () {
    sh shell.sh
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
    add_usage_command "c,config" "Show / Edit the current config"
    add_usage_arg "--a=[x.x],--apache=[x.x]" "Set a specific apache version"
    add_usage_arg "--a=*,--apache=*" "Get all available apache versions"
    add_usage_arg "--p=*,--php=*" "Get all available php versions"
    add_usage_arg "--m=*,--mysql=*" "Get all available mysql versions"
    add_usage_arg "--p,--php" "Get current php version"
    add_usage_arg "--a,--apache" "Get current apache version"
    add_usage_arg "--m,--mysql" "Get current mysql version"
    add_usage_arg "--r=[path],--root=[path]" "Set the document root"
    add_usage_arg "--r,--root" "Get the current document root"
    add_usage_arg "--w=[path],--www=[path]" "Set the path to projects"
    add_usage_arg "--w,--www" "Get the current path to projects"
    add_usage_arg "--d=[path],--database=[path]" "Set the path to databases"
    add_usage_arg "--d,--database" "Get the current path to databases"
    add_usage_arg "--p=[x.x],--php=[x.x]" "Set a specific php version"
    add_usage_arg "--m=[x.x],--mysql=[x.x]" "Set a specific mysql version"
    add_usage_command "e,enter" "Enter the devilbox shell"
    add_usage_command "h, help" "List all available commands"
    add_usage_command "o,open" "Open the devilbox intranet"
    add_usage_arg "-h,--http" "Use non-https url"
    add_usage_command "r,run" "Run the devilbox docker containers"
    add_usage_arg "-s,--silent" "Hide errors and run in background"
    add_usage_command "s,stop" "Stop devilbox and docker containers"
    add_usage_command "u,update" "Update devilbox and docker containers"
    add_usage_command "v, version" "Show version information"
    printf "\n"
}

open_http_intranet () {
    xdg-open "http://localhost/" 2> /dev/null >/dev/null
}

open_https_intranet () {
    xdg-open "https://localhost/" 2> /dev/null >/dev/null
}

open_command () {
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

run_containers () {
    docker-compose up httpd php mysql
}

run_containers_silent () {
    docker-compose up -d httpd php mysql
}

run_command () {
    if [[ $# -eq 0 ]] ; then
        run_containers_silent
    else
        for arg in "$@"; do
            case $arg in
                -h|--http) run_containers; shift;;
            esac
        done
    fi
}

stop_command () {
    docker-compose stop
    docker-compose rm -f
}

update_command () {
    stop_command
    git pull origin master
    sh update-docker.sh
}

version_command() {
    printf "\n"
    printf "%s\n" "$NAME v$VERSION ($DATE)"
    printf "%s\n" "${COLOR_LIGHT_GRAY}$DESCRIPTION${COLOR_DEFAULT}"
    printf "%s\n" "${COLOR_LIGHT_GRAY}$LINK${COLOR_DEFAULT}"
    printf "\n"
}

main () {
    safe_cd "$(get_devilbox_path)" "Devilbox not found, please make sure it is installed in your home directory."
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

