## Functions used for fancy output

FONT_BOLD=$(tput bold)
FONT_DEFAULT=$(tput sgr0)
FONT_RED=$(tput setaf 1)
FONT_GREEN=$(tput setaf 2)
FONT_YELLOW=$(tput setaf 3)
FONT_BLUE=$(tput setaf 4)
# FONT_MAGENTA=$(tput setaf 5)
# FONT_CYAN=$(tput setaf 6)
FONT_LIGHT_GRAY=$(tput setaf 7)
FONT_DARK_GRAY=$(tput setaf 0)
CURSOR_OFF=$(tput civis)
CURSOR_ON=$(tput cvvis)
CURSOR_UP=$(tput cuu1)
CLEAR_LINE=$(tput el)
CLEAR_SCREEN=$(tput ed)

error() {
    local message=$1
    printf "%s %s\n" "${FONT_RED}[✘]" "${FONT_DEFAULT}$message" >&2
}

success() {
    local message=$1
    printf "%s %s\n" "${FONT_GREEN}[✔]" "${FONT_DEFAULT}$message"
}

info() {
    local message=$1
    printf "%s %s\n" "${FONT_YELLOW}[!]" "${FONT_DEFAULT}$message"
}

question() {
    local message=$1
    printf "%s %s\n" "${FONT_BLUE}[?]" "${FONT_DEFAULT}$message"
}
