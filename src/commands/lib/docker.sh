is_running () {
    local all
    all=$(docker-compose ps 2> /dev/null | grep "devilbox" | awk '{print $3}' | grep "Exit")
    if was_success && [ -z "$all" ]; then
        return "$OK_CODE";
    else
        return "$KO_CODE";
    fi
}
