## Functions utilities around exit/return codes

OK_CODE=0
KO_CODE=1

was_success() {
    local exit_code=$?
    [ "$exit_code" -eq "$OK_CODE" ]
}

was_error() {
    local exit_code=$?
    [ "$exit_code" -eq "$KO_CODE" ]
}

die_error () {
    local message=$1
    error "$message"
    exit "$KO_CODE"
}

die_on_error () {
    local message=$1
    if was_error; then
        die_error "$message"
    fi
}
