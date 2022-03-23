sys_installer_help() {
    warning_out "Unknown install unit: $1"
    echo "Available Units:"
    echo "    docker : Install docker and docker-compose"
    exit 1
}

sys_installer_help
