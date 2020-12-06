mysql_command() {
    if ! is_running; then
        error "Devilbox containers are not running"
        return "$KO_CODE"
    fi

    if [ -z "$1" ]; then
        exec_command 'mysql -hmysql -uroot'
    else
        exec_command "mysql -hmysql -uroot -e '$1'"
    fi
}
