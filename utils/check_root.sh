check_root() {
    if [[ $EUID -ne 0 ]]; then
        error_out "This script must be run as root"
        exit 1
    fi
}

check_root