#!/bin/bash

# brake on error
set -e 

# curl -fsSL git.io/minlaxz.sh | bash -s -- <options>
# Usage: ... [options]

SCRIPT_REPO="my-scripts"
BRANCH="main"
GH_MINLAXZ="https://raw.githubusercontent.com/minlaxz"
SCRIPT_REPO_URL="${GH_MINLAXZ}/${SCRIPT_REPO}/${BRANCH}"

setup_laxzhome() {
    flag=$1
    LAXZHOME=$HOME/.laxz
    mkdir -p $LAXZHOME
    # check if flag is set
    if [ -z "$flag" ]; then
        # not set, so leave files as is
        test -f $LAXZHOME/.laxzrc || touch $LAXZHOME/.laxzrc
        test -f $LAXZHOME/laxz.alias || touch $LAXZHOME/laxz.alias
    else
        # set, re-create files
        touch $LAXZHOME/.laxzrc
        touch $LAXZHOME/laxz.alias
    fi
    
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
    check_root
    case $1 in
    "docker")
        heading_out "Installing $1 and docker-compose"
        curl -fsSL ${SCRIPT_REPO_URL}/utils/install_docker.sh -o /tmp/install_docker.sh
        chmod 755 /tmp/install_docker.sh && /tmp/install_docker.sh
        /usr/bin/rm -rf /tmp/install_docker.sh
        echo "Caller : Cleaned up the TMP."
        ;;
    *) sys_installer_help $1 ;;
    esac

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

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error_out "This script must be run as root"
        exit 1
    fi
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

main_help() {
    warning_out "Unknown option: $1"
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help     show help"
    exit 1
}

main() {
    curl ${SCRIPT_REPO_URL}/utils/common.sh -o /tmp/common.sh
    chmod 755 /tmp/common.sh && . /tmp/common.sh
    /usr/bin/rm -rf /tmp/common.sh
    description_out "Loaded common colors."
    sleep 0.5

    check_sys_requirements # check linuc
    setup_laxzhome # setup my home
    case $1 in
    "" | "--help")
        description_out $(curl -s ${SCRIPT_REPO_URL}/helpers/main.help.sh 1>&2)
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

    "-R" | "--refresh")
        setup_laxzhome -r
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
