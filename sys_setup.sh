#!/bin/bash

docker_install_options() {
    cat <<EOF 2>&1
    This script will install the following:
    - Docker
    - Docker Compose
EOF

install_options() {
    cat <<EOF 2>&1
    1) Install Docker and Docker Compose
    2) Exit
EOF

}

}

main() {
    # Check if the user is root
    # if [ "$(id -u)" != "0" ]; then
    #     echo "This script must be run as root" 1>&2
    #     exit 1
    # fi

    # Check if the script is running on Ubuntu
    if [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        if [ "$DISTRIB_ID" != "Ubuntu" ]; then
            echo "This script is only for Ubuntu" 1>&2
            exit 1
        fi
    else
        echo "This script is only for Ubuntu" 1>&2
        exit 1
    fi

    echo "All check passed, I am running..."
    install_options
    read -p "Please select an option: " option
    case $option in
        1)
            docker_install_options
            ;;
        2)
            exit 0
            ;;
        *)
            echo "Invalid option" 1>&2
            exit 1
            ;;
    esac
}

main
