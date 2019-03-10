open_http_intranet () {
    xdg-open "http://localhost/" 2> /dev/null >/dev/null
}

open_https_intranet () {
    xdg-open "https://localhost/" 2> /dev/null >/dev/null
}

open_command () {
    if [[ $# -eq 0 ]] ; then
        open_https_intranet
    else
        for arg in "$@"; do
            case $arg in
                -h|--http) open_http_intranet; shift;;
            esac
        done
    fi
}
