HEAD='\e[7;36m'
RESET='\e[m'
OUTPUT='\e[32m'
NL='\n'
ERROR='\e[3;31m'
WARN='\e[3;33m'

heading_out() {
    echo -e "${HEAD}$1${RESET}"
}

description_out() {
    echo -e "${OUTPUT}>> : $1 ${RESET}"
}

warning_out() {
    echo -e "${WARN}>>> : $1 ${RESET}"
}

error_out() {
    echo -e "${ERROR}3rr0r>> : $1 ${RESET}"
    return 1
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error_out "This script must be run as root"
        exit 1
    fi
}

main_help() {
    warning_out "Unknown option: $1"
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help     show help"
    exit 1
}

check_sys_requirements() {
    description_out "Checking system requirements ..."
    sleep 0.5
    if [[ $(uname -s) != "Linux" ]]; then
        error_out "This script only support linux"
        exit 1
    fi
    check_shell
}

installer_help() {
    warning_out "Unknown installer: $1"
    echo "Options:"
    echo "    laxz : Install LAXZ"
    echo "    cra  :  Install cra"
    exit 1
}

check_shell() {
    # Supported shells: bash, zsh
    # ps | grep $(echo $$) | awk '{ print $4 }'
    description_out "Checking shell ..."
    sleep 0.5
    if [ "$SHELL" != "/bin/bash" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
        error_out "Unsupported shell: $SHELL"
        exit 1
    fi
}
