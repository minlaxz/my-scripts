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
