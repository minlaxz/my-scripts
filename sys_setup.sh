#!/bin/bash

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
}

main
