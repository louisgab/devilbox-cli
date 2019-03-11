## Functions used for user interaction

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
    return "$OK_CODE"
}

confirm() {
    local question=$1
    if has_confirmed "$(ask "$question")"; then
        return "$OK_CODE"
    else
        return "$KO_CODE"
    fi
}
