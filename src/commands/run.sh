run_containers () {
    docker-compose up httpd php mysql
}

run_containers_silent () {
    docker-compose up -d httpd php mysql
}

run_command () {
    if [[ $# -eq 0 ]] ; then
        run_containers_silent
    else
        for arg in "$@"; do
            case $arg in
                -h|--http) run_containers; shift;;
            esac
        done
    fi
}
