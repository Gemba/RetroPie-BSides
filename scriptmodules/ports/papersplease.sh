#!/usr/bin/env bash

# RetroPie scriptmodule for "Papers, Please" (the puzzle simulation video game
# by Lucas Pope)
#
# Copyright 2024 Gemba @ Github
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
# Do these one-time installation steps, _before_ running this scriptmodule.
#
# 1. Obtain `papers-please_1.1.65_i386.deb` from your Humble account. **Note**: The
#    Unity based version (v1.4.0 onwards) does not work with Box86 and 32-Bit
#    Raspi OS. Continue with step 3. _-OR-_
# 2. If you have the GOG installer:
#    - Get the script `gogextract.py` from https://github.com/Yepoleb/gogextract
#    - Run it on the GOG Linux installer:
#      `python3 gogextract.py setup_papers_please*.sh`
#    - Unzip the resulting file `data.zip`
#    - Locate the file `PapersPlease` in the expanded Zip archive
#    - Note that location for step 4 below, continue there.
# 3. Copy the `papers-please*.deb` file into
#    `~/RetroPie-Setup/ext/bsides/scriptmodule/ports/papersplease/` on your RPi. _-OR-_
# 4. If you have the GOG installer: Copy the binary `PapersPlease` and all
#    sibling files and the subdirectories (`asset/`, `loc/`) to your RPi
#    at `~/RetroPie/roms/ports/papers-please/`. Create the folder 
#    `~/RetroPie/roms/ports/papers-please/` first.
# 5. That's it. Now execute this scriptmodule.
# 6. If Box86 claims it cannot install due to libsdl2, then unhold the mark with
#    `sudo apt-mark unhold libsdl2-dev`. You may re-install libsdl2 from
#    RetroPie package repository once Box86 is installed: `sudo
#    RetroPie-Setup/retropie_packages.sh sdl2`.
# 7. 'Glory to Arstotzka!' :)
#
# **Additional Notes**
#
# - On RetroPie Buster: Ignore the warning of Box86 being not supported on
#   RaspiOS Buster (RaspiOS 10), the game will run nevertheless
# - Savegames are at: `~/.local/share/3909/PapersPlease/`

rp_module_id="papersplease"
rp_module_desc="Module for the simulation game 'Papers, Please' by Lucas Pope"
rp_module_licence="PROP"
rp_module_section="opt"
rp_module_flags="!all rpi3 rpi4 rpi5"
rp_module_help="Requires Humble (*.deb) or GOG (setup_papers_please*.sh)"
rp_module_help+=" installer. (any version before v1.4.0 should work). See"
rp_module_help+=" comments in this scriptmodule for details."

_papersplease_romdir="$romdir/ports/papers-please"

function depends_papersplease() {
	if isPlatform "64bit" ; then 
	    dpkg --add-architecture armhf
		sudo apt-get update
	    apt-get install libasound2-plugins:armhf -y
	fi
    getDepends rsync
    gitPullOrClone "$home/pi-apps" https://github.com/Botspot/pi-apps
    chown -R $user: "$home/pi-apps"
    sudo -u "$user" stdbuf -o0 $home/pi-apps/manage install Box86
}

function install_papersplease() {
    if [[ "$(find $md_data/*.deb 2>/dev/null)" ]] ; then
        # unpack *.deb
        local tmpdir
        tmpdir=$(mktemp -d)
        dpkg-deb --raw-extract "$(find $md_data/*.deb)" "$tmpdir"
        mkUserDir "$_papersplease_romdir"
        rsync -aq --delete --chown="$user":"$user" "$tmpdir/opt/papers-please/" "$_papersplease_romdir"
    else
        for f in PapersPlease lime.ndll assets/ loc/ ; do
            if [[ ! -e "$_papersplease_romdir/$f" ]] ; then
                local err="FATAL: Mandatory game file not found: "
                err+="$_papersplease_romdir/$f. Fix your setup. Quitting."
                printMsgs "console" "$err"
                exit 1;
            fi
        done
    fi
}

function configure_papersplease() {
    addPort "$md_id" "$md_id" "Papers, Please" "XINIT:$md_inst/rplauncher.sh"

    [[ $md_mode != "install" ]] && return

	mkdir -p "$home/.local/share/3909/PapersPlease" && chown -R $user: "$home/.local/share/3909"
    moveConfigDir "$home/.local/share/3909/PapersPlease" "$configdir/ports/$md_id"

    # settings which contain fullscreen off, as commodity to the workaround (see
    # comments in launcher below)
    local settings
    settings="$configdir/ports/$md_id/settings.sav"
    if [[ ! -f "$settings" ]] ; then
        cat << _EOF_ | tr -d "[:space:]" | tee "$settings" >/dev/null
            3285DC0CC1903D09893CCDCC4B6B7B06FE9D50AA2FA7093B6662A1F46BA494409A9
            F9BE4995F2C9034F58F746E4D536AE81B503AC8D842B8C023F7A41A28699F0C29A3
            5E8FD94FF73F25188DC61F264C3F9083B50CAFAC2F9292ED78DE2B00AEA09A629EE
            A3BF397A0377D1E63D4C36D94102289373622A7CB21A95A62D86B53ECC373C9BC37
            4AEFF188E922F3B8489DA4CA0DC4EAFEDEBCB5870BFE91BA1B60555C7E2C92938FC
            BA7FD5C743F4C5768EE990625800DD1073B34E93E15481768D380CD438D3AAE047B
            40465FD95DEA1DA973B361DD8C79C3F8EE7DBECBBCDCC517A6798C662F9060D3847
            2F259D14AF35C146FDCC650F6F3B4307E179621252C17DE05074623B8C9378479B1
            3D329F0B1C124AB5C724F5689B22D24DFD6A409C712EAB4F02C8A111B7F628EE39C
            F50C75798BC61578749CFFD50AA0F59EC414FED6F7365D6520CA594A7827646EB9D
            E2307F0589633823F125E77176891023200B35B5AC718772948EE711CE
_EOF_
        chown -R $user: "$settings"
    fi

    cat >"$md_inst/rplauncher.sh" << _EOF_
#! /usr/bin/env bash
xset -dpms s off s noblank

# If you get a displaced game window enable the xrandr line below once, then
# launch the game again and set in the configuration (wrench) fullscreen to off.
# Quit game and then disable the xrandr line again.

# xrandr --output HDMI-1 --mode 1024x768
cd "$_papersplease_romdir"
box86 PapersPlease
killall xinit
_EOF_
    chmod +x "$md_inst/rplauncher.sh"
}
