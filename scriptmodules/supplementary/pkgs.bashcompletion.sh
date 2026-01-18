#! /usr/bin/env bash

# FIXME
#
# Copyright (c) 2022 Gemba @ Github
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# ---
#
# FIXME


# FIXME: Don't assume /home/pi/ as folder for RetroPie
# use $scriptdir
# Einbauen, wenn upstream retropie-setup.sh aktualisiert wird
mkdir -p /opt/retropie/configs/all/rp-bashcompletion/
find /home/pi/RetroPie-Setup -type f \
                                  -name '*.sh' -a \
                                  \(    -path '*scriptmodules/emulators*'     \
                                     -o -path '*scriptmodules/libretrocores*' \
                                     -o -path '*scriptmodules/ports*'         \
                                     -o -path '*scriptmodules/supplementary*' \
                                  \) -print0  \
                                  | xargs -0 -I {} basename {} \
                                  | sed -e s/'\.sh$'// | sort > \
/opt/retropie/configs/all/rp-bashcompletion/scriptmodules.lst
# $configdir/all/$md_id/scriptmodules.lst





rp_module_id="pkgs.bashcompletion"

rp_module_desc="Adds extra version info (Raspberry Pi"
rp_module_desc+=" model, RetroPie-Setup, RetroArch, SDL) to the message-of-the-day logon banner."

rp_module_help="Displays the RetroPie ASCII-art alongside with additional"
rp_module_help+=" information about the\nsystem when the pi account logs in"
rp_module_help+=" similar to the genuine bashwelcometweak\nscriptmodule. Extra"
rp_module_help+=" output of Raspbery model, RetroPie-Setup and RetroArch"
rp_module_help+="\nSDL version. Temperature (C/F) is shown according to locale."

rp_module_section="config"

function install_alt.bashwelcome() {
    remove_alt.bashwelcome
    cat >>"$home/.bashrc" <<\_EOF_
# RETROPIE PROFILE START

function getIPAddress() {
    local ip_route
    ip_route=$(ip -4 route get 9.9.9.9 2>/dev/null)
    if [[ -z "$ip_route" ]]; then
        ip_route=$(ip -6 route get 2620:fe::9 2>/dev/null)
    fi
    [[ -n "$ip_route" ]] && grep -oP "src \K[^\s]+" <<< "$ip_route"
}

function retropie_welcome() {
    local upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
    local secs=$((upSeconds%60))
    local mins=$((upSeconds/60%60))
    local hours=$((upSeconds/3600%24))
    local days=$((upSeconds/86400))
    local UPTIME=$(printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" \
        "$secs")

    # calculate rough CPU and GPU temperatures and determine unit C/F:
    local cpuTemp
    local gpuTemp

    local unit="C"
    declare -A nonSI=(
        [US]=1
        [MM]=1
        [LR]=1
    )
    local country=$(locale 2> /dev/null | grep LC_MEASUREMENT | tr -d '"' | cut -d= -f2 | cut -d_ -f2 | cut -d. -f1)
    [[ ! -z "$country" ]] && [[ -n "${nonSI[$country]}" ]] && unit="F"

    if [[ -f "/sys/class/thermal/thermal_zone0/temp" ]]; then
        if cpuTemp=$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000)) && [[ "$unit" == "F" ]]; then
            cpuTemp=$((cpuTemp*9/5+32))
        fi
    fi

    if [[ -n $(command -v vcgencmd) ]]; then
        if gpuTemp=$(vcgencmd measure_temp); then
            gpuTemp=${gpuTemp:5:2}
            [[ "$unit" == "F" ]] && gpuTemp=$((gpuTemp*9/5+32))
        else
            gpuTemp=""
        fi
    fi

    local df_out=()
    local line
    while read line; do
        df_out+=("$line")
    done < <(df -h .)

    local rpi_model
    if [[ -e "/proc/device-tree/model" ]]; then
        rpi_model="$(tr -d '\0' < /proc/device-tree/model)"
    fi

    local sdl_ver="$(/usr/bin/sdl2s-config --version 2>/dev/null)"

    local retroarch_ver
    if [[ -f "/opt/retropie/emulators/retroarch/retropie.pkg" ]]; then
        retroarch_ver=$(grep pkg_repo_branch < \
            /opt/retropie/emulators/retroarch/retropie.pkg \
            | cut -d '=' -f 2 | tr -d '"')
    fi

    local rst="$(tput sgr0)"
    local fgblk="${rst}$(tput setaf 0)" # Black - Regular
    local fgred="${rst}$(tput setaf 1)" # Red
    local fggrn="${rst}$(tput setaf 2)" # Green
    local fgylw="${rst}$(tput setaf 3)" # Yellow
    local fgblu="${rst}$(tput setaf 4)" # Blue
    local fgpur="${rst}$(tput setaf 5)" # Purple
    local fgcyn="${rst}$(tput setaf 6)" # Cyan
    local fgwht="${rst}$(tput setaf 7)" # White

    local bld="$(tput bold)"
    local bfgblk="${bld}$(tput setaf 0)"
    local bfgred="${bld}$(tput setaf 1)"
    local bfggrn="${bld}$(tput setaf 2)"
    local bfgylw="${bld}$(tput setaf 3)"
    local bfgblu="${bld}$(tput setaf 4)"
    local bfgpur="${bld}$(tput setaf 5)"
    local bfgcyn="${bld}$(tput setaf 6)"
    local bfgwht="${bld}$(tput setaf 7)"

    local logo=(
        "           "
        "${fgred}   .***.   "
        "${fgred}   ***${bfgwht}*${fgred}*   "
        "${fgred}   \`***'   "
        "${bfgwht}    |*|    "
        "${bfgwht}    |*|    "
        "${bfgred}  ..${bfgwht}|*|${bfgred}..  "
        "${bfgred}.*** ${bfgwht}*${bfgred} ***."
        "${bfgred}*******${fggrn}@@${bfgred}**"
        "${fgred}\`*${bfgred}****${bfgylw}@@${bfgred}*${fgred}*'"
        "${fgred} \`*******'${fgrst} "
        "${fgred}   \`\"\"\"'${fgrst}   "
        "           "
        )

    local out
    local i
    local k
    local llen
    llen=${#logo[@]}
    for i in "${!logo[@]}"; do
        out+="  ${logo[$i]}  "
        k=$i
        # text index plus one if no device tree model info
        [[ -z "$rpi_model" ]] && [[ $i -ge 2 ]] && k=$(($i+1))
        # then also do not print last blank logo line
        [[ $k -ne $i ]] && [[ $k -eq $llen ]] && break
        case "$k" in
            0)
                out+="${fggrn}$(date +"%A, %e %B %Y, %X")"
                ;;
            1)
                out+="${fggrn}$(uname -srmo)"
                ;;
            2)
                out+="${fggrn}"
                if [[ ! -z "$rpi_model" ]]; then
                    out+="$rpi_model"
                fi
                ;;
            3)
                out+="${fggrn}RetroPie $rp_version"
                if [[ ! -z "$retroarch_ver" ]]; then
                    out+=", RetroArch $retroarch_ver"
                fi
                if [[ ! -z "$sdl_ver" ]]; then
                    out+=", SDL $sdl_ver"
                fi
                ;;
            5)
                out+="${fgylw}${df_out[0]}"
                ;;
            6)
                out+="${fgwht}${df_out[1]}"
                ;;
            7)
                out+="${fgred}Uptime.............: ${UPTIME}"
                ;;
            8)
                out+="${fgred}Memory.............: $(free -h \
                    | awk 'NR==2 {printf("%s (Free) / %s (Total)", $4, $2)}')"
                ;;
            9)
                out+="${fgred}Running Processes..: $(ps ax | wc -l | tr -d " ")"
                ;;
            10)
                out+="${fgred}IP Address.........: $(getIPAddress)"
                ;;
            11)
                if [[ ! -z "$cpuTemp" ]] ; then
                    out+="Temperature........: CPU ${cpuTemp}°${unit}"
                    [[ ! -z "$gpuTemp" ]] && out+=", GPU ${gpuTemp}°${unit}"
                fi
                ;;
            12)
                out+="${fgwht}The RetroPie Project, https://retropie.org.uk"
                ;;
        esac
        out+="${rst}\n"
    done
    echo -e "\n$out"
}

retropie_welcome
# RETROPIE PROFILE END
_EOF_

}

function remove_alt.bashwelcome() {
    sed -i '/RETROPIE PROFILE START/,/RETROPIE PROFILE END/d' "$home/.bashrc"
}

function gui_alt.bashwelcome() {
    local title="Bash Welcome"
    local cmd=(dialog --backtitle "$__backtitle" --menu "$title Configuration" 22 86 16)
    local options=(
        1 "Install $title"
        2 "Remove $title"
    )
    local choice
    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        case "$choice" in
        1)
            rp_callModule alt.bashwelcome install
            printMsgs "dialog" "Installed $title."
            ;;
        2)
            rp_callModule alt.bashwelcome remove
            printMsgs "dialog" "Removed $title."
            ;;
        esac
    fi
}
