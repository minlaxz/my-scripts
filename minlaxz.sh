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
        if [ ! -f $LAXZHOME/common.sh ]; then
            curl -fsSL ${SCRIPT_REPO_URL}/utils/common.sh -o $LAXZHOME/common.sh
            chmod 755 $LAXZHOME/common.sh && . $LAXZHOME/common.sh
        else
            . $LAXZHOME/common.sh
        fi
    else
        # set, re-create files
        touch $LAXZHOME/.laxzrc
        touch $LAXZHOME/laxz.alias
        rm -rf $LAXZHOME/common.sh
        curl -fsSL ${SCRIPT_REPO_URL}/utils/common.sh -o $LAXZHOME/common.sh
        chmod 755 $LAXZHOME/common.sh && . $LAXZHOME/common.sh
    fi
    description_out "Loaded common functions."
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

sys_installer() {
    case $1 in
    "docker")
        check_root
        heading_out "Installing $1 and docker-compose"
        curl -fsSL ${SCRIPT_REPO_URL}/functions/install_docker.sh -o /tmp/install_docker.sh
        chmod 755 /tmp/install_docker.sh && /tmp/install_docker.sh
        /usr/bin/rm -rf /tmp/install_docker.sh
        echo "Caller : Cleaned up the TMP."
        ;;
    *)
        curl -s ${SCRIPT_REPO_URL}/helpers/sys.installer.help.sh -o /tmp/help.sh
        chmod 755 /tmp/help.sh && . /tmp/help.sh
        /usr/bin/rm -rf /tmp/help.sh
        sys_installer_help $1 ;;
    esac

}

check_sys_requirements() {
    echo "Checking system requirements ..."
    sleep 1
    if [[ $(uname -s) != "Linux" ]]; then
        error_out "This script only support linux"
        exit 1
    fi
}

main() {
    echo "minlaxz is here 👻, wait! spinning yup 👽 ..."
    check_sys_requirements # check if it is >> linux
    setup_laxzhome # setup my home >> including common.sh
    sleep 1

    case $1 in
    "" | "--help")
        curl -s ${SCRIPT_REPO_URL}/helpers/main.help.sh 1>&2
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
