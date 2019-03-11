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
