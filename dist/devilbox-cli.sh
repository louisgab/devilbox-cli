#!/usr/bin/env bash

NAME="Devilbox CLI"
VERSION="0.3.0"
DATE="2019-04-21"
REPO="devilbox-cli"
AUTHOR="louisgab"
DESCRIPTION="A simple and conveniant command line to manage devilbox from anywhere"
LINK="https://github.com/$AUTHOR/$REPO"

## Functions used for fancy output

FONT_BOLD=$(tput bold)
FONT_DEFAULT=$(tput sgr0)
FONT_RED=$(tput setaf 1)
FONT_GREEN=$(tput setaf 2)
FONT_YELLOW=$(tput setaf 3)
FONT_BLUE=$(tput setaf 4)
# FONT_MAGENTA=$(tput setaf 5)
# FONT_CYAN=$(tput setaf 6)
FONT_LIGHT_GRAY=$(tput setaf 7)
FONT_DARK_GRAY=$(tput setaf 0)
CURSOR_OFF=$(tput civis)
CURSOR_ON=$(tput cvvis)
CURSOR_UP=$(tput cuu1)
CLEAR_LINE=$(tput el)
CLEAR_SCREEN=$(tput ed)

error() {
    local message=$1
    printf "%s %s\n" "${FONT_RED}[✘]" "${FONT_DEFAULT}$message" >&2
}

success() {
    local message=$1
    printf "%s %s\n" "${FONT_GREEN}[✔]" "${FONT_DEFAULT}$message"
}

info() {
    local message=$1
    printf "%s %s\n" "${FONT_YELLOW}[!]" "${FONT_DEFAULT}$message"
}

question() {
    local message=$1
    printf "%s %s\n" "${FONT_BLUE}[?]" "${FONT_DEFAULT}$message"
}

## Functions utilities around exit/return codes

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

die_error () {
    local message=$1
    error "$message"
    exit "$KO_CODE"
}

die_on_error () {
    local message=$1
    if was_error; then
        die_error "$message"
    fi
}

## Functions used for user confirmation

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
}

confirm() {
    local question=$1
    has_confirmed "$(ask "$question")"
}

## Functions used to manipulate a config value in .env file

ENV_FILE=".env"

get_env_value () {
    local config=$1
    local current
    current=$(grep -Eo "^$config+[[:alnum:][:punct:]]*" "$ENV_FILE" | sed "s/.*$config//g")
    was_success && [ ! -z "$current" ] && printf "%s" "$current"
}

set_env_value () {
    local config=$1
    local new=$2
    local current
    current="$(get_env_value "$config")"
    was_success || return "$KO_CODE"
    sed -i -e "s/\(^#*$config${current//\//\\\/}\).*/$config${new//\//\\\/}/" "$ENV_FILE"
    was_success || return "$KO_CODE"
    current="$(get_env_value "$config")"
    was_success && [[ "$current" = "$new" ]]
}

is_env_choice_existing () {
    local config=$1
    local choice=$2
    local search
    search=$(grep -Eo "^#*$config$choice" "$ENV_FILE")
    was_success && [ ! -z "$search" ]
}

get_env_choice () {
    local config=$1
    local current
    current=$(grep -Eo "^$config+[.[:digit:]]*" "$ENV_FILE" | sed "s/.*$config//g")
    was_success && [ ! -z "$current" ] && printf "%s" "$current"
}

is_env_choice_available() {
    local config=$1
    local choice=$2
    local current
    current=$(get_env_choice "$config")
    was_success && [ "$choice" != "$current" ]
}

get_all_env_choices () {
    local config=$1
    local all
    all=$(grep -Eo "^#*$config+[.[:digit:]]*" "$ENV_FILE" | sed "s/.*$config//g")
    was_success && [ ! -z "$all" ] && printf "%s\n" "$all"
}

set_env_choice () {
    local config=$1
    local new=$2
    local current
    is_env_choice_existing "$config" "$new" && is_env_choice_available "$config" "$new" || return "$KO_CODE"
    current=$(get_env_choice "$config")
    was_success || return "$KO_CODE"
    sed -i -e "s/\(^#*$config$current\).*/#$config$current/" "$ENV_FILE"
    was_success || return "$KO_CODE"
    sed -i -e "s/\(^#*$config$new\).*/$config$new/" "$ENV_FILE"
    was_success || return "$KO_CODE"
    current=$(get_env_choice "$config")
    was_success && [[ "$current" = "$new" ]]
}

## Functions used to manipulate a x.x.x version number

is_semver() {
    local version=$1
    [[ $version =~ ^[:digit:]+\.[:digit:]+\.[:digit:]\+$ ]]
}

get_major(){
    local version=$1
    local major
    is_semver "$version" || return "$KO_CODE"
    major=$(echo ${version//./ } | awk '{print $1}')
    was_success && printf "%s" "$major"
}

get_minor(){
    local version=$1
    local minor
    is_semver "$version" || return "$KO_CODE"
    minor=$(echo ${version//./ } | awk '{print $2}')
    was_success && printf "%s" "$minor"
}

get_patch(){
    local version=$1
    local patch
    is_semver "$version" || return "$KO_CODE"
    patch=$(echo ${version//./ } | awk '{print $3}')
    was_success && printf "%s" "$patch"
}

has_newer_major(){
    local version1=$1
    local version2=$2
    local major1
    local major2
    major1="$(get_major "$version1")"
    was_success || return "$KO_CODE"
    major2="$(get_major "$version2")"
    was_success || return "$KO_CODE"
    [[ $major1 -gt $major2 ]]
}

has_newer_minor(){
    local version1=$1
    local version2=$2
    local minor1
    local minor2
    minor1="$(get_minor "$version1")"
    was_success || return "$KO_CODE"
    minor2="$(get_minor "$version2")"
    was_success || return "$KO_CODE"
    [[ $minor1 -gt $minor2 ]]
}

has_newer_patch(){
    local version1=$1
    local version2=$2
    local patch1
    local patch2
    patch1="$(get_patch "$version1")"
    was_success || return "$KO_CODE"
    patch2="$(get_patch "$version2")"
    was_success || return "$KO_CODE"
    [[ $patch1 -gt $patch2 ]]
}

is_version_newer() {
    local version1=$1
    local version2=$2
    has_newer_major "$version1" "$version2" && return "$OK_CODE"
    has_newer_minor "$version1" "$version2" && return "$OK_CODE"
    has_newer_patch "$version1" "$version2" && return "$OK_CODE"
    return "$KO_CODE"
}

## Functions used to display a loading animation during long process

spinner() {
    local message=${1-Loading...}
    local spin=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local delay=0.1
    for state in "${spin[@]}"; do
        printf "\r${CLEAR_LINE}$state %s" "$message"
        sleep $delay
    done
}

loading() {
    local pid=$1
    while kill -0 $pid 2>/dev/null; do
        spinner
    done
    printf "\r${CLEAR_LINE}"
}

#sleep 5 & loading "$!" && echo 'bim' || echo 'error'

## Functions used for user choice

draw_menu() {
    local cursor=$1
    shift
    local menu=("$@")
    for item in "${menu[@]}"; do
        if [[ ${menu[$cursor]} == $item ]]; then
            printf "%s\n" "${FONT_BOLD} > $item${FONT_DEFAULT}"
        else
            printf "%s\n" "   $item"
        fi
    done
}

clear_menu()  {
    local menu=("$@")
    for i in "${menu[@]}"; do printf "${CURSOR_UP}"; done
    printf "${CLEAR_SCREEN}"
}

key_input() {
    local key=$1
    read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
    key+=${k1}${k2}${k3}
    case "$key" in
        $'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') printf "%s" "up";;
        $'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') printf "%s" "down";;
        $'\e[1~'|$'\e0H'|$'\e[H') printf "%s" "begin";;
        $'\e[4~'|$'\e0F'|$'\e[F') printf "%s" "end";;
        $'\e') printf "%s" "escape";;
        $'\x0a'|"") printf "%s" "enter";;
        " ") printf "%s" "space";;
        *) printf "%s" "$key";;
    esac
}

output_menu () {
    local cursor=0
    local menu=("$@")
    draw_menu "$cursor" "${menu[@]}"
    printf "${CURSOR_OFF}"
    while read -sN1 key; do
        case "$(key_input $key)" in
            up) [[ $cursor -eq 0 ]] && cursor=$(( ${#menu[@]} - 1 )) || cursor=$(( $cursor - 1 ));;
            down) [[ $cursor -eq $(( ${#menu[@]} - 1 )) ]] && cursor=0 || cursor=$(( $cursor + 1 ));;
            begin) cursor=0;;
            end) cursor=$(( ${#menu[@]} - 1 ));;
            escape|q) exit;;
            enter|space) break;;
            *);;
        esac
        clear_menu "${menu[@]}"
        draw_menu "$cursor" "${menu[@]}"
    done
    printf "${CURSOR_ON}"
    was_success && [ ! -z "$current" ] && printf "%s" "$cursor"
}

get_choice


get_readable_current_config () {
    local type=$1
    local config=$2
    local current
    current=$(get_env_value "$config")
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
    if set_env_value "$config" "$new"; then
        success "$type config updated to $new"
        return "$OK_CODE"
    else
        error "$type config change failed"
        return "$KO_CODE"
    fi
}

### READABLE VERSIONS

is_readable_choice_existing () {
    local type=$1
    local config=$2
    local choice=$3
    if is_env_choice_existing "$config" "$choice"; then
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
    current=$(get_env_choice "$config")
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
    if is_env_choice_available "$config" "$choice"; then
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
    all=$(get_all_env_choices "$config")
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
    if set_env_choice "$config" "$new"; then
        success "$type version updated to $new"
        return "$OK_CODE"
    else
        error "$type version change failed"
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
if [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q <service_name>)` ]; then
  echo "No, it's not running."
else
  echo "Yes, it's running."
fi

## Functions used to format a man page for help commands

man_usage () {
    local command=${1-<command>}
    printf "\n%s\n\n" "Usage: $NAME $command [--args]... "
}

man_command () {
    local command=$1
    local description=$2
    printf '\t%-30s %s\n' "$command" "${FONT_LIGHT_GRAY}$description${FONT_DEFAULT}"
}

man_arg () {
    local arg=$1
    local description=$2
    printf '\t%-30s %s\n' "${FONT_LIGHT_GRAY}$arg" "${FONT_LIGHT_GRAY}$description${FONT_DEFAULT}"
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
    local choices=( $(get_all_env_choices "$PHP_CONFIG") )
    str=$(ls | { read a; read a; echo $a; })
    echo $str
    # output_menu "${choices[@]}" > read a
    # echo "$a"
    # output_menu ${choices[@]}
    # read index < <(output_menu ${choices[@]})
    # local index=$(output_menu "${choices[@]}")
    # echo "OK $(output_menu "${choices[@]}")"
    # was_success && [ ${#choices[@]} -gt 0 ] && printf "${choices[*]}\n"
    # echo ${versions[2]}
    # local new=$1
    # set_readable_choice "PHP" "$PHP_CONFIG" "$new"
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

PHP_CONFIG="PHP_SERVER="
APACHE_CONFIG="HTTPD_SERVER=apache-"
MYSQL_CONFIG="MYSQL_SERVER=mysql-"
DOCROOT_CONFIG="HTTPD_DOCROOT_DIR="
WWWPATH_CONFIG="HOST_PATH_HTTPD_DATADIR="

get_array_key() {
    local value=$1
    shift
    local array=("$@")
    for index in "${!array[@]}"; do
       if [[ "${array[$index]}" = "${value}" ]]; then
           echo "${index}";
       fi
    done
}

list_config () {
    get_readable_current_choice "Apache" "$APACHE_CONFIG"
    get_readable_current_choice "PHP" "$APACHE_CONFIG"
    get_readable_current_choice "MySql" "$APACHE_CONFIG"
    get_readable_current_config "Document root" "$DOCROOT_CONFIG"
    get_readable_current_config "Projects path" "$WWWPATH_CONFIG"
}

set_config () {
    for arg in "$@"; do
        case $arg in
            -a|--apache) set_apache_version; shift;;
            -p|--php) set_php_version; shift;;
            -m|--mysql) set_mysql_version; shift;;
            -r|--root) set_document_root; shift;;
            -w|--www) set_projects_path; shift;;
        esac
    done
}

get_config () {
    for arg in "$@"; do
        case $arg in
            -a|--apache) get_all_apache_versions && get_current_apache_version; shift;;
            -p|--php) get_all_php_versions && get_current_php_version; shift;;
            -m|--mysql) get_all_mysql_versions && get_current_mysql_version; shift;;
            -r|--root) get_current_document_root; shift;;
            -w|--www) get_current_projects_path; shift;;
        esac
    done
}

command_config () {
    if [[ $# -eq 0 ]] ; then
        man_usage "config"
        #config_man
    else
        for arg in "$@"; do
            case $arg in
                l|list) shift; list_config;;
                s|set) shift; set_config "$@";;
                g|get) shift; get_config "$@";;
                # *) error "Unknown command '$arg', see '$NAME help' for manual";;
            esac
        done
    fi
}

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
            cli) shift; command_cli;;
            config) shift; command_config "$@";;
            dock) shift; dock_command "$@";;
            help|-h|--help) shift; command_help "$@";;
            version|-v|--version) shift; command_version;;
            *) error "Unknown command $1, see -h for help.";;
        esac
    fi
}

main "$@"

