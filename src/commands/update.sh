update_command () {
    stop_command
    git pull origin master
    sh update-docker.sh
}
