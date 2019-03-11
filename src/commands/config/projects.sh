get_current_projects_path () {
    get_readable_current_config "Projects path" "$WWWPATH_CONFIG"
}

set_projects_path () {
    local new=$1
    set_readable_config "Projects path" "$WWWPATH_CONFIG" "$new"
}
