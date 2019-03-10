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
