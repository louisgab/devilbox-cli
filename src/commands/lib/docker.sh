is_running () {
    local all
    all=$(docker-compose ps 2> /dev/null | grep "devilbox" | awk '{print $3}' | grep "Up")
    if was_success; then
        return "$OK_CODE";
    else
        return "$KO_CODE";
    fi
}
