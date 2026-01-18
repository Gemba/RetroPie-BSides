#!/usr/bin/env bash

# RetroPie scriptmodule for the puzzle game 'Baba Is You' by Hempuli
# This is script requires a RetroPie setup (4.8.9 or newer).

# Copyright 2025 Gemba @ Github
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# ---
# **Preparation**
#
# _Attention_: If you run a 32-bit OS (`getconf LONG_BIT`) do use the 'Baba Is
# You' version 478f (dated 2024-02-24) as this is the last version which
# contains the 32-bit executable.
#
# 1. Obtain the PC game `BIY_linux.tar.gz` from https://hempuli.itch.io/baba and
#    copy the archive to your Raspberry RetroPie (RPi) to the folder
#    `~/RetroPie/roms/ports`.
# 2. Then run this scriptmodule via RetroPie-Setup.

# **Notes for the First Start of the Game**
#
# Only apply these if you encounter that the game screen (with the menu, not the
# splash screen) does not use the full width (x-resoulution):
#
# - The game has a native resolution of 854x480 (FWVGA). You can not use
#   fullscreen mode in this setup. But it can be perfectly played in windowed
#   mode. Thus, you should set your video mode in the _Runcommand Menu_ of
#   RetroPie to the closest to fully fit in the game screen FWVGA. E.g. Select
#   video mode 1024x768 on 4:3 and 5:4 aspect ratio displays, and to 854x480
#   (FWVGA) on 16:9 and 16:10 aspect ratio displays in the runcommand menu
#   _Select video mode for babaisyou_.
# - You only have to do this once , unless you change your display (see
#   Troubleshooting below in that case).
# - Change _Toggle Fullscreen_ in the game settings to _off/unselected_, then
#   restart the game: The display should be centered.

# **Additional Notes**
#
# - Game save/progress and settings are kept at: `~/.local/share/Baba_Is_You/`
# - Tested with 'Baba Is You' Linux version 478f on a Raspberry Pi4 (32-bit) and
#   with version 481d (dated 2026-01-02) on a Raspberry Pi5 (64-bit). It should
#   also work as well on a Raspberry Pi3, Zero2w, aso.
# - On RetroPie Buster: Ignore the warning of Box86 being not supported on
#   RaspiOS Buster (RaspiOS 10), the game will run nevertheless

# **Troubleshooting**
#
# If you did not follow the steps to adjust the resolution, here is how to start
# over:
#
# Launch Baba again from EmulationStation and remember to divert into the
# _Runcommand Menu_ of RetroPie to adjust the resolution. That's all folks!


rp_module_id="babaisyou"
rp_module_desc="Module for the puzzle game 'Baba Is You' by Hempuli"
rp_module_licence="PROP"
rp_module_section="opt"
rp_module_flags="!all rpi1 rpi2 rpi3 rpi4 rpi5"
rp_module_help="This scriptmodule requires the Linux PC version of the game."
rp_module_help+=" See comments in this scriptmodule for details."

_babaisyou_romdir="$romdir/ports/Baba Is You"

function depends_babaisyou() {
    gitPullOrClone "$home/pi-apps" https://github.com/Botspot/pi-apps
    chown -R $user: "$home/pi-apps"
    local package="Box86"
    isPlatform "64bit" && package="Box64"
    sudo -u "$user" stdbuf -o0 $home/pi-apps/manage install $package
}

function install_babaisyou() {
    mkdir -p "$_babaisyou_romdir"
    if [[ -f "$_babaisyou_romdir/../BIY_linux.tar.gz" ]] ; then
        for f in Assets.dat bin32 bin64 Data gamecontrollerdb.txt prev_dims.p ; do
          rm -rf "${_babaisyou_romdir:?}/$f"
        done
        pushd "$_babaisyou_romdir/.."
        tar xzf BIY_linux.tar.gz
        popd
        chown -R $user: "$_babaisyou_romdir"
        rm -f "$_babaisyou_romdir/../BIY_linux.tar.gz"
    else
        for f in Assets.dat bin64 Data gamecontrollerdb.txt ; do
            if [[ -e "$_babaisyou_romdir/$f" ]] ; then
                local info="\nNo tar archive found, existing installation "
                info+="kept unchanged. No action performed.\n"
                printMsgs "console" "$info"
                cp -f "$md_data/patch_is_win.py" "$md_inst"
                return
            fi
        done
        local err="\nFATAL: Mandatory game archive not found: "
        err+="$_babaisyou_romdir/../BIY_linux.tar.gz. See notes in this scriptmodule for "
        err+="expected installation archive. Quitting.\n"
        printMsgs "console" "$err"
        exit 1;
    fi
    for f in Assets.dat bin64 Data gamecontrollerdb.txt ; do
        if [[ ! -e "$_babaisyou_romdir/$f" ]] ; then
            local err="\nFATAL: Mandatory game file not found: "
            err+="$_babaisyou_romdir/$f. See notes in this scriptmodule for "
            err+="expected installation files. Quitting.\n"
            printMsgs "console" "$err"
            exit 1;
        fi
    done
    cp -f "$md_data/patch_is_win.py" "$md_inst"
}

function configure_babaisyou() {
    local name
    local baba_conf

    name="$(basename "$_babaisyou_romdir")"
    baba_conf="$home/.local/share/$(echo "$name" | tr ' ' '_')"

    addPort "$md_id" "$md_id" "$name" "XINIT:$md_inst/rplauncher.sh %XRES% %YRES%"

    [[ $md_mode == "remove" ]] && return

    mkUserDir "$baba_conf"
    moveConfigDir "$baba_conf" "$configdir/ports/$md_id"

    local box_bin="box86"
    local baba_bin="bin32/Chowdren"

    if isPlatform "64bit"; then
        box_bin="box64"
        baba_bin="bin64/Chowdren"
    fi

    cat >"$md_inst/rplauncher.sh" << _EOF_
#! /usr/bin/env bash
xset -dpms s off s noblank

x_res="\$1"
y_res="\$2"

cd "$_babaisyou_romdir"
python3 "$md_inst/patch_is_win.py" "$_babaisyou_romdir/$baba_bin" \$x_res \$y_res 1>>/dev/shm/runcommand.log

if [[ -e "$baba_conf/SettingsC.txt" ]] ; then
   sed -i s,fullscreen=1,fullscreen=0, "$baba_conf/SettingsC.txt"
fi
$box_bin $baba_bin
killall $baba_bin 2>/dev/null # sometimes game quit takes long
killall xinit
_EOF_
    chmod +x "$md_inst/rplauncher.sh"
}
