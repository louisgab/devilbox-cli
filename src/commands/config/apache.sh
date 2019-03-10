get_current_apache_version () {
    get_readable_current_version "Apache" "$APACHE_CONFIG"
}

get_all_apache_versions () {
    get_readable_all_versions "Apache" "$APACHE_CONFIG"
}

set_apache_version () {
    local new=$1
    set_readable_version "Apache" "$APACHE_CONFIG" "$new"
}
