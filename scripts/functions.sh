#!/bin/bash

# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'

# Clear the color after that
clear='\033[0m'

# Italics
grey_italics="\e[3;2m"

# Function to format standard print out
function log {
    echo -e "${yellow}[${magenta}SCRIPT${yellow}]${clear}: $@ "
}

# Function to handle errors.
function warn {
    echo -e "${red}[WARN  ]${clear}: $1"
}

# Function to handle errors.
function error {
    echo -e "${red}================ ERROR ================${clear}\n${red}[ERROR ]${clear}: $1\n${@:2}"
    exit 1
}

function run {
    # Run the command and capture its output
    output=$($1 2>&1)  # Capture both stdout and stderr
    local exit_code=$? # Capture the exit status of the command

    # Check for errors
    if [ $exit_code -ne 0 ]; then
        error "Failed to execute: $1" "$output"
    # Print the output only if it's not empty or whitespace
    elif [[ -n "${output// /}" ]]; then
        echo "$output"
    fi
}

function prompt_for_multiselect {

    # little helpers for terminal print control and key input
    ESC=$(printf "\033")
    cursor_blink_on() { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to() { printf "$ESC[$1;${2:-1}H"; }
    print_inactive() { printf "$2 $1 "; }
    print_active() { printf "$2$ESC[7m $1 $ESC[27m"; }
    get_cursor_row() {
        IFS=';' read -sdR -p $'\E[6n' ROW COL
        echo ${ROW#*[}
    }
    key_input() {
        local key
        IFS= read -rsn1 key 2>/dev/null >&2
        if [[ $key = "" ]]; then echo enter; fi
        if [[ $key = $'\x20' ]]; then echo space; fi
        if [[ $key = $'\x1b' ]]; then
            read -rsn2 key
            if [[ $key = [A ]]; then echo up; fi
            if [[ $key = [B ]]; then echo down; fi
        fi
    }
    toggle_option() {
        local arr_name=$1
        eval "local arr=(\"\${${arr_name}[@]}\")"
        local option=$2
        if [[ ${arr[option]} == true ]]; then
            arr[option]=
        else
            arr[option]=true
        fi
        eval $arr_name='("${arr[@]}")'
    }

    local retval=$1
    local options
    local defaults

    IFS=';' read -r -a options <<<"$2"
    if [[ -z $3 ]]; then
        defaults=()
    else
        IFS=';' read -r -a defaults <<<"$3"
    fi
    local selected=()

    for ((i = 0; i < ${#options[@]}; i++)); do
        selected+=("${defaults[i]:-false}")
        printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=$(get_cursor_row)
    local startrow=$(($lastrow - ${#options[@]}))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for option in "${options[@]}"; do
            local prefix="[ ]"
            if [[ ${selected[idx]} == true ]]; then
                prefix="[x]"
            fi

            cursor_to $(($startrow + $idx))
            if [ $idx -eq $active ]; then
                print_active "$option" "$prefix"
            else
                print_inactive "$option" "$prefix"
            fi
            ((idx++))
        done

        # user key control
        case $(key_input) in
        space) toggle_option selected $active ;;
        enter) break ;;
        up)
            ((active--))
            if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi
            ;;
        down)
            ((active++))
            if [ $active -ge ${#options[@]} ]; then active=0; fi
            ;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    eval $retval='("${selected[@]}")'
}

function display_smiley {
    frames=(
        "░░░░░░░░░░░░░░░░░░░░░░█████████"
        "░░███████░░░░░░░░░░███▒▒▒▒▒▒▒▒███"
        "░░█▒▒▒▒▒▒█░░░░░░░███▒▒▒▒▒▒▒▒▒▒▒▒▒███"
        "░░░█▒▒▒▒▒▒█░░░░██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██"
        "░░░░█▒▒▒▒▒█░░░██▒▒▒▒▒██▒▒▒▒▒▒██▒▒▒▒▒███"
        "░░░░░█▒▒▒█░░░█▒▒▒▒▒▒████▒▒▒▒████▒▒▒▒▒▒██"
        "░░░█████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██"
        "░░░█▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒██"
        "░██▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒██▒▒▒▒▒▒▒▒▒▒██▒▒▒▒██"
        "██▒▒▒███████████▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒▒██"
        "█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒████████▒▒▒▒▒▒▒██"
        "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██"
        "░█▒▒▒███████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██"
        "░██▒▒▒▒▒▒▒▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█"
        "░░████████████░░░█████████████████")

    colours=("\033[38;5;196m" "\033[38;5;202m" "\033[38;5;208m" "\033[38;5;214m" "\033[38;5;220m" "\033[38;5;226m" "\033[38;5;190m" "\033[38;5;154m" "\033[38;5;118m" "\033[38;5;82m" "\033[38;5;46m" "\033[38;5;47m" "\033[38;5;48m" "\033[38;5;49m" "\033[38;5;51m" "\033[38;5;39m" "\033[38;5;27m" "\033[38;5;21m" "\033[38;5;57m" "\033[38;5;93m" "\033[38;5;129m" "\033[38;5;165m" "\033[38;5;201m" "\033[38;5;200m" "\033[38;5;199m" "\033[38;5;198m")
    i = 0
    for line in "${frames[@]}"; do
        echo -e "${colours[$i]}${line}\033[0m"
        ((i++))
        sleep 0.12
    done
}
