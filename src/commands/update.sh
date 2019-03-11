update_command () {
    if is_running; then
        error "Devilbox containers are running, please use devilbox stop"
        return "$KO_CODE"
    fi
    confirm "Did you backup your databases before?"
    if was_success ;then
        git pull origin master
        sh update-docker.sh
    fi
}
