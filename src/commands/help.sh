add_usage_command () {
    local command=$1
    local description=$2
    printf '%-30s\t %s\n' "$command" "${COLOR_DARK_GRAY}$description${COLOR_DEFAULT}"
}

add_usage_arg () {
    local arg=$1
    local description=$2
    printf '%-30s\t %s\n' "  ${COLOR_LIGHT_GRAY}$arg" "${COLOR_DARK_GRAY}$description${COLOR_DEFAULT}"
}

help_command () {
    printf "\n"
    printf "%s\n" "Usage: $0 <command> [--args]... "
    printf "\n"
    add_usage_command "check" "Check your .env file for potential errors"
    add_usage_command "c,config" "Show / Edit the current config"
    add_usage_arg "-a=<x.x>,--apache=<x.x>" "Set a specific apache version"
    add_usage_arg "-a=*,--apache=*" "Get all available apache versions"
    add_usage_arg "-p=*,--php=*" "Get all available php versions"
    add_usage_arg "-m=*,--mysql=*" "Get all available mysql versions"
    add_usage_arg "-p,--php" "Get current php version"
    add_usage_arg "-a,--apache" "Get current apache version"
    add_usage_arg "-m,--mysql" "Get current mysql version"
    add_usage_arg "-r=<path>,--root=<path>" "Set the document root"
    add_usage_arg "-r,--root" "Get the current document root"
    add_usage_arg "-w=<path>,--www=<path>" "Set the path to projects"
    add_usage_arg "-w,--www" "Get the current path to projects"
    add_usage_arg "-d=<path>,--database=<path>" "Set the path to databases"
    add_usage_arg "-d,--database" "Get the current path to databases"
    add_usage_arg "-p=<x.x>,--php=<x.x>" "Set a specific php version"
    add_usage_arg "-m=<x.x>,--mysql=<x.x>" "Set a specific mysql version"
    add_usage_command "e,enter" "Enter the devilbox shell"
    add_usage_command "x, exec '<command>'" "Execute a command inside the container without entering it"
    add_usage_command "h, help" "List all available commands"
    add_usage_command "mysql ['<query>']" "Launch a preconnected mysql shell, with optional query"
    add_usage_command "o,open" "Open the devilbox intranet"
    add_usage_arg "-h,--http" "Use non-https url"
    add_usage_command "restart" "Restart the devilbox docker containers"
    add_usage_arg "-s,--silent" "Hide errors and run in background"
    add_usage_command "r,run" "Run the devilbox docker containers"
    add_usage_arg "-s,--silent" "Hide errors and run in background"
    add_usage_command "s,stop" "Stop devilbox and docker containers"
    add_usage_command "u,update" "Update devilbox and docker containers"
    add_usage_command "v, version" "Show version information"
    printf "\n"
}
