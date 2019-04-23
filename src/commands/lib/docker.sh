is_running () {
    local all
    all=$(docker-compose ps 2> /dev/null | grep "devilbox" | awk '{print $3}' | grep "Up")
    if was_success; then
        return "$OK_CODE";
    else
        return "$KO_CODE";
    fi
}
if [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q <service_name>)` ]; then
  echo "No, it's not running."
else
  echo "Yes, it's running."
fi
