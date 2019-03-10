## Functions used for fancy output

error() {
    local message=$1
    printf "%s %s\n" "${COLOR_RED}[✘]" "${COLOR_DEFAULT}$message" >&2
    die "$KO_CODE"
}

success() {
    local message=$1
    printf "%s %s\n" "${COLOR_GREEN}[✔]" "${COLOR_DEFAULT}$message"
}

info() {
    local message=$1
    printf "%s %s\n" "${COLOR_YELLOW}[!]" "${COLOR_DEFAULT}$message"
}

question() {
    local message=$1
    printf "%-20s\n" "${COLOR_BLUE}[?]" "${COLOR_DEFAULT}$message"
}
