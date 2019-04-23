## Functions used to display a loading animation during long process

spinner() {
    local pid=$!
    local message=${1-Loading...}
    local spin=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local delay=0.1
    printf "${CURSOR_OFF}"
    trap "kill -9 $pid 2> /dev/null" EXIT
    while kill -0 $pid 2>/dev/null; do
        for state in "${spin[@]}"; do
            printf "\r${CLEAR_LINE} $state %s" "$message"
            sleep $delay
        done
    done
    trap - EXIT
    printf "${CURSOR_ON}"
    printf "\r${CLEAR_LINE}"
}

loader () {
    "$@" &
    spinner
}
