run_containers () {
    docker-compose up httpd php mysql
}

run_containers_silent () {
    docker-compose up -d httpd php mysql
}

run_command () {
    if is_running; then
        error "Devilbox containers are already running"
        return "$KO_CODE"
    fi
    if [[ $# -eq 0 ]] ; then
        run_containers
    else
        for arg in "$@"; do
            case $arg in
                -s|--silent) run_containers_silent; shift;;
            esac
        done
    fi
}
