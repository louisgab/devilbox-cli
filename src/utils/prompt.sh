result() {
    local exit_code=$1
    local success_action=$2
    local error_action=$3
    if [ "$exit_code" -eq "$OK_CODE" ]; then
        $success_action
    else
        $error_action
    fi
    return "$exit_code"
}

has_confirmed() {
    local response=$1
    case "$response" in
        [yY][eE][sS]|[yY]) ok_code;;
        *) ko_code;;
    esac
}

ask_confirmation() {
    local question=$1
    local action=$2
    read -r -p "$(question "${question}" [y/N])" response
    isconfirmed="$(has_confirmed "$response")"
    result "$isconfirmed" "$action" die
}
