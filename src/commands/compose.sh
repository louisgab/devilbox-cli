list_containers() {
    docker-compose ps
}

get_stack_containers() {
    info "Stack Containers ready:"
    printf "%s\n" $(get_default_containers)
    return "$OK_CODE"
}

set_stack_containers() {
    export DEVILBOX_CONTAINERS="$(get_default_containers) $1"
    #echo "$(get_default_containers) $1"
    #export DEVILBOX_CONTAINERS="$1"
}

run_services() {
    if is_running; then
        error "Devilbox containers are already running"
        return "$KO_CODE"
    fi

    FILES="-f docker-compose.yml"

    for container in $(get_default_containers)
    do
        FILE="compose/docker-compose.override.yml-${container}"
        if [ -f "$FILE" ]; then
            FILES+=" -f ${FILE}"
        fi
    done
    #echo "docker-compose ${FILES} up -d ${DEVILBOX_CONTAINERS}"

    if [[ $# -eq 1 ]] ; then
        docker-compose $FILES up $DEVILBOX_CONTAINERS
    else
        for arg in "$@"; do
            case $arg in
                -s|--silent) run_services_silent; shift;;
            esac
        done
    fi
}

run_services_silent() {
    docker-compose $FILES up -d $DEVILBOX_CONTAINERS
}

compose_command() {
    for arg in "$@"; do
        case $arg in
            -l|--list) list_containers; shift;;
            -c|--containers) get_stack_containers; shift;;
            -c=*|--containers=*) set_stack_containers "${arg#*=}"; run_services "$@"; shift;;
        esac
    done
}
