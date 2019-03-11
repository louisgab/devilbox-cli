get_current_php_version () {
    get_readable_current_choice "PHP" "$PHP_CONFIG"
}

get_all_php_versions () {
    get_readable_all_choices "PHP" "$PHP_CONFIG"
}

set_php_version () {
    local new=$1
    set_readable_choice "PHP" "$PHP_CONFIG" "$new"
}
