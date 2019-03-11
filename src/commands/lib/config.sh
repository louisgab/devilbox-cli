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
