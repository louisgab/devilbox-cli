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
