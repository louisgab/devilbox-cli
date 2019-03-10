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
