get_current_mysql_version () {
    get_readable_current_version "MySql" "$MYSQL_CONFIG"
}

get_all_mysql_versions () {
    get_readable_all_versions "MySql" "$MYSQL_CONFIG"
}

set_mysql_version () {
    local new=$1
    set_readable_version "MySql" "$MYSQL_CONFIG" "$new"
}
