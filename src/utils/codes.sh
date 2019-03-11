## Basic wrappers around exit codes

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

die () {
    local exit_code=$1
    if [ ! -z "$exit_code" ]; then
        exit "$exit_code"
    else
        exit "$?"
    fi
}
