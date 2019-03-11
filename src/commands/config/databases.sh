get_current_databases_path () {
    get_readable_current_config "Databases path" "$DBPATH_CONFIG"
}

set_databases_path () {
    local new=$1
    set_readable_config "Databases path" "$DBPATH_CONFIG" "$new"
}
