## Basic wrappers around exit codes

OK_CODE=0
KO_CODE=1

ok_code () {
    printf "%d" "$OK_CODE"
}

ko_code () {
    printf "%d" "$KO_CODE"
}

die () {
    local exit_code=$1
    if [ ! -z "$exit_code" ]; then
        exit "$exit_code"
    else
        exit "$?"
    fi
}
