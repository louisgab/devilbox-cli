## Functions used for fancy output

COLOR_DEFAULT=$(tput sgr0)
COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput setaf 3)
COLOR_BLUE=$(tput setaf 4)
# COLOR_PURPLE=$(tput setaf 5)
# COLOR_CYAN=$(tput setaf 6)
COLOR_LIGHT_GRAY=$(tput setaf 7)
COLOR_DARK_GRAY=$(tput setaf 0)

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
    printf "%s %s\n" "${COLOR_BLUE}[?]" "${COLOR_DEFAULT}$message"
}
