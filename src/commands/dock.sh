enter_command () {
    if ! is_running; then
        error "Devilbox containers are not running"
        return "$KO_CODE"
    fi
    sh shell.sh
}
stop_command () {
    if ! is_running; then
        error "Devilbox containers are not running"
        return "$KO_CODE"
    fi
    docker-compose stop
    docker-compose rm -f
}

run_containers () {
    docker-compose up httpd php mysql
}

run_containers_silent () {
    docker-compose up -d httpd php mysql
}

reattach_containers_logs () {
    docker-compose logs -f
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
