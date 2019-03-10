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
