get_recent_devilbox_versions () {
    local versions
    versions=$(git fetch --tags && git describe --abbrev=0 --tags $(git rev-list --tags --max-count=10))
    if was_success; then
        info "Devilbox available versions:"
        printf "%s\n" "$versions"
        return "$OK_CODE"
    else
        error "Couldnt retrive available versions of devilbox"
        return "$KO_CODE"
    fi
}

latest_version () {
    local latest
    latest=$(git fetch --tags && git describe --abbrev=0 --tags $(git rev-list --tags --max-count=1))
    if was_success; then
        info "Devilbox latest version is $latest"
        return "$OK_CODE"
    else
        error "Couldnt retrieve latest version of devilbox"
        return "$KO_CODE"
    fi
}

set_devilbox_version () {
    local version=$1
    confirm "Did you backup your databases before?"
    if was_success ;then
        git fetch --tags && git checkout $version
        if was_success; then
            success "Devilbox updated to $version, please restart"
            return "$OK_CODE"
        else
            error "Couldnt update devilbox"
            return "$KO_CODE"
        fi
    fi
}

update_command () {
    if is_running; then
        error "Devilbox containers are running, please use devilbox stop"
        return "$KO_CODE"
    fi
    for arg in "$@"; do
        case $arg in
            -v=\*|--version=\*) get_recent_devilbox_versions; shift;;
            -v=*|--version=*) set_devilbox_version "${arg#*=}"; shift;;
            -v=latest|--version=latest) set_devilbox_version "$(latest_version)"; shift;;
            -d|--docker) sh update-docker.sh; shift;;
        esac
    done
}
