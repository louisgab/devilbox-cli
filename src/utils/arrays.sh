## Functions utilities to manipulate arrays

array_search() {
    local needle=$1
    shift
    local haystack=("$@")
    for index in "${!haystack[@]}"; do
       if [[ "${haystack[$index]}" = "${needle}" ]]; then
           printf "%s" "${index}"
           return "$OK_CODE"
       fi
    done
    return "$KO_CODE"
}

in_array() {
    local needle=$1
    shift
    local haystack=("$@")
    for item in "${haystack[@]}"; do
       if [[ "${item}" = "${needle}" ]]; then
           return "$OK_CODE"
       fi
    done
    return "$KO_CODE"
}
