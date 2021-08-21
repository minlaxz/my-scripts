#!/bin/bash

install_docker() {
    cat <<EOF 2>&1
    This script will install the following:
    - Docker
    - Docker Compose
EOF
    echo "Done - installed"
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

    echo "All check passed, installing..."
    install_docker
}

main
