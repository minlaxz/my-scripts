#!/bin/bash

set -e # breack on error
# curl ... | bash -s -- <options>

HEAD='\e[7;36m'
RESET='\e[m'
OUTPUT='\e[32m'
NL='\n'
ERROR='\e[3;31m'
WARN='\e[3;33m'

heading_output() {
    echo -e "${HEAD}$1${RESET}"
}

description_utput() {
    echo -e "${OUTPUT}Description : $1 ${RESET}"
}

warning_output() {
    echo -e "${WARN}Warning : $1 ${RESET}"
}

error_output() {
    echo -e "${ERROR}Error : $1 ${RESET}"
}

setup_laxzhome() {
    LAXZHOME=$HOME/.laxz
    mkdir -p $LAXZHOME
    test -f $LAXZHOME/laxzrc || touch $LAXZHOME/laxzrc
    test -f $LAXZHOME/laxz.alias || touch $LAXZHOME/laxz.alias
}

installer_help() {
    warning_output "Unknown installer: $1"
    echo "Options:"
    echo "    laxz : Install LAXZ"
    echo "    cra  :  Install cra"
    exit 1
}

installer() {
    case $1 in
    "laxz")
        heading_output "Installing laxz"
        # Install laxz
        echo "Installed laxz"
        ;;
    "cra")
        heading_output "Installing CRA"
        # Install cra
        echo "Installed CRA"
        ;;
    *)
        installer_help $1
        ;;
    esac
}

main_help() {
    warning_output "Unknown option: $1"
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help     show help"
    exit 1
}

main() {
    case $1 in
    "" | "-h" | "--help")
        cat <<EOF >&2
Usage: $0 [options]
    Options:
        -h, --help      show this help message and exit
        -i, --install   install something
        -u, --uninstall uninstall something
        -X              Clean up everything
EOF

        ;;
    "-i" | "--install")
        installer "$2"
        ;;
    "-u" | "--uninstall")
        echo "Uninstalling"
        ;;
    "-X")
        warning_output "Cleaning up everything."
        ;;
    *)
        main_help "$1"
        ;;
    esac

}

main "$@"
