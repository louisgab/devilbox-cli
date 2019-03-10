stop_command () {
    docker-compose stop
    docker-compose rm -f
}
