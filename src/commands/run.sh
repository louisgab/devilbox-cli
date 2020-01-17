get_default_containers() {
   if [ -n "$DEVILBOX_CONTAINERS" ]; then
        printf %s "${DEVILBOX_CONTAINERS}"
    else
        printf %s "httpd php mysql"
    fi
}

run_containers () {
    docker-compose up $(get_default_containers)
}

run_containers_silent () {
    docker-compose up -d $(get_default_containers)
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
