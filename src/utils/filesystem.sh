## Functions used to acces the filesystem safely

safe_cd() {
    local path=$1
    local error_msg=$2
    if [[ ! -d "$path" ]]; then
        error "$error_msg"
    fi
    cd "$path" >/dev/null || error "$error_msg"
}
