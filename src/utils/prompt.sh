## Functions used for user confirmation

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
}

confirm() {
    local question=$1
    has_confirmed "$(ask "$question")"
}
