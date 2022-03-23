#!/bin/bash

set -e # breack on error
# curl ... | bash -s -- <options>

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
    echo -e "${OUTPUT}Description : $1 ${RESET}"
}

warning_out() {
    echo -e "${WARN}Warning : $1 ${RESET}"
}

error_out() {
    echo -e "${ERROR}Error : $1 ${RESET}"
    return 1
}

setup_laxzhome() {
    LAXZHOME=$HOME/.laxz
    mkdir -p $LAXZHOME
    test -f $LAXZHOME/.laxzrc || touch $LAXZHOME/.laxzrc
    # test -f $LAXZHOME/laxz.alias || touch $LAXZHOME/laxz.alias
}

install_cra() {
    heading_out "Installing CRA ..."
    check_and_remove_cra() {
        if [ -f $LAXZHOME/cra.sh ]; then
            warning_out "CHECK - found cra, removing ... "
            /usr/bin/rm -rf $LAXZHOME/cra.sh
        fi
        warning_out "cra is removed."
    }
    download_cra() {
        curl -fsSL https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.sh -o $LAXZHOME/cra.sh
        chmod 755 $LAXZHOME/cra.sh
        description_out "DONE - downloaded cra."
    }
    update_rc_cra() {
        sed -i '/alias cra/d' $LAXZHOME/.laxzrc # clean alias about cra in laxzrc
        warning_out "DONE - cra alias is cleaned from laxzrc"

        if [ -f $LAXZHOME/cra.sh ]; then
            # cra exists
            cat <<EOF >>$LAXZHOME/.laxzrc
alias cra="$HOME/.laxz/cra.sh"
EOF
            description_out "DONE - cra alias is added to laxzrc"
        fi
    }
    finish_up_cra() {
        # source /home/laxz/.laxz/.laxzrc
        # sed -i '/source $HOME\/\.laxz\/\.laxzrc/d' $HOME/.zshrc
        sed -i "/source \/home\/laxz\/\.laxz\/\.laxzrc/d" $HOME/.zshrc
        warning_out "DONE - laxzrc is cleaned from zshrc"
        echo "source $HOME/.laxz/.laxzrc" >>$HOME/.zshrc
        description_out "ya're good to go!\nJus run 'cra'"
    }
    check_and_remove_cra
    download_cra
    update_rc_cra
    finish_up_cra
}

installer_help() {
    warning_out "Unknown installer: $1"
    echo "Options:"
    echo "    laxz : Install LAXZ"
    echo "    cra  :  Install cra"
    exit 1
}

installer() {
    case $1 in
    "laxz")
        heading_out "Installing laxz"
        # Install laxz
        echo "Installed laxz"
        ;;
    "cra") install_cra ;;
    *) installer_help $1 ;;
    esac
}

sys_installer_help() {
    warning_out "Unknown install unit: $1"
    echo "Available Units:"
    echo "    docker : Install docker and docker-compose"
    exit 1
}

sys_installer() {
    case $1 in
    "docker")
        heading_out "Installing $1 and docker-compose"
        curl -fsSL https://raw.githubusercontent.com/minlaxz/my-scripts/main/install_docker.sh -o /tmp/install_docker.sh
        chmod 755 /tmp/install_docker.sh && /tmp/install_docker.sh
        /usr/bin/rm -rf /tmp/install_docker.sh
        echo "Caller : Cleaned up tmp."
        echo "Caller : docker and docker-compose"
        ;;
    *) sys_installer_help $1 ;;
    esac

}

check_shell() {
    # ps | grep $(echo $$) | awk '{ print $4 }'
    base_shell=$(basename $SHELL)
    if [[ $base_shell != "bash" ]]; then
        error_out "Only support 'bash' shell not ${base_shell}"
        exit 1
    fi
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

main() {
    check_root
    check_shell
    setup_laxzhome
    case $1 in
    "" | "-h" | "--help")
        curl -s https://raw.githubusercontent.com/minlaxz/my-scripts/main/helpers/main.help.sh 2>&1 
        ;;
    "-i" | "--install")
        installer "$2"
        ;;
    "-u" | "--uninstall")
        echo "Uninstalling"
        ;;
    "-s" | "--setup")
        sys_installer "$2"
        ;;
    "-t" | "--template")
        echo "Template"
        ;;
    "-X")
        warning_out "Cleaning up everything about laxz."
        rm -rf $LAXZHOME
        ;;
    *)
        main_help "$1"
        ;;
    esac

}

main "$@"
