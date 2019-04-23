## Functions used to manipulate the files

file_exists() {
    local path=$1
    [[ -f "$path" ]]
}

directory_exists() {
    local path=$1
    [[ -d "$path" ]]
}

safe_cd() {
    local path=$1
    directory_exists "$path" && cd "$path" >/dev/null
}
