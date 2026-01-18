#!/usr/bin/env bash

# This RetroPie scriptmodule provides Joystick/Gamepad the device-tree based
# driver for GPIO connected devices.
#
# Copyright 2026 Gemba @ Github

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

# **Before usage**
#
# - Have input Joystick/Gamepad device(s) connected to GPIO
# - Have MCP23017 wired when using more than two devices
# - Uninstall other GPIO based drivers (`db9_gpio_rpi`,`mk_arcade_joystick_rpi`)
#   of RetroPie: `sudo ~/RetroPie-Setup/retropie_packages.sh db9_gpio_rpi
#   remove`, `sudo ~/RetroPie-Setup/retropie_packages.sh mk_arcade_joystick_rpi
#   remove`.
#
# **Additional Notes**
#
# ??? Wie Änderungen vom user hier halten (dtbc files)

rp_module_id="arcadedt"
rp_module_desc="Lowest latency Joystick/Gamepad driver for GPIO connected devices."
rp_module_licence="GPL2 https://github.com/Gemba/arcade-dt/blob/master/LICENSE"
rp_module_section="opt"
rp_module_flags="!all rpi1 rpi2 rpi3 rpi4 rpi5"
rp_module_help="Requires manual configuration before fully usable, see: https://github.com/gemba/arcade-dt"


function depends_arcadedt() {
    local deb_pkgs=(
        cpp 
        device-tree-compiler 
        evtest
        gpiod 
        make 
    )
    if [[ "$__os_debian_ver" -gt 10 ]] ; then
        deb_pkgs+=(innoextract)
    fi
    getDepends ${deb_pkgs[*]}
}

function sources_arcadedt() {
    gitPullOrClone
}

function build_arcadedt() {
    download https://raw.githubusercontent.com/raspberrypi/utils/refs/heads/master/ovmerge/ovmerge && chmod a+x ovmerge
}

function install_arcadedt() {

    downloadAndExtract 'http://downloads.sourceforge.net/project/java-game-lib/Official%20Releases/LWJGL%202.9.3/lwjgl-2.9.3.zip' "$md_build"
    mkUserDir "$_edna_romdir"/lib
    cp -p "$md_build/lwjgl-2.9.3/jar/lwjgl.jar" "$_edna_romdir"/lib
    chown "$user": "$_edna_romdir"/lib/*.jar
    chmod a+x "$_edna_romdir"/lib/*.jar
}

function configure_arcadedt() {
    addPort "$md_id" "edna" "Edna & Harvey: The Breakout" "XINIT:$md_inst/EdnaBreakout.sh"

    [[ $md_mode != "install" ]] && return

    local pulse_client_confd="/etc/pulse/client.conf.d"
    # set Pulseaudio autospawn
    if [[ -f "$pulse_client_confd/00-disable-autospawn.conf" ]] ; then
        mv "$pulse_client_confd/00-disable-autospawn.conf" "$pulse_client_confd/00-disable-autospawn.conf.pre_edna"
    fi
    echo "# Allow per user autospawning of PA (triggered by openal) for Edna" > "$pulse_client_confd/00-set-autospawn.conf"
    echo "autospawn=yes" >> "$pulse_client_confd/00-set-autospawn.conf"

    local openal_conf="$home/.config/alsoft.conf"

    if [[ -f "$openal_conf" ]] && [[ ! -f "$openal_conf.pre_edna" ]] ; then
        mv "$openal_conf" "$openal_conf.pre_edna"
    fi

    if [[ ! -f "$openal_conf" ]] ; then
        iniConfig " = " "" "$openal_conf"
        echo "# for RetroPie: ports/edna" >> "$openal_conf"
        iniSet "drivers" "pulse"
        iniSet "rt-prio" "10"
        iniSet "channels" "stereo"
        iniSet "stereo-mode" "speakers"
        echo "[pulse]" >> "$openal_conf"
        iniSet "spawn-server" "true"

        chown "$user": "$openal_conf"
    fi

    mkdir -p "$md_inst"
    mkdir -p "$_edna_romdir"

    cat >"$md_inst/EdnaBreakout.sh" << _EOF_
#! /usr/bin/env bash
xset -dpms s off s noblank
cd "$_edna_romdir"
# ALSOFT_LOGLEVEL=3 java -jar ... for openal verbose output
export JAVA_HOME="$_edna_romdir/jdk1.8.0"
\$JAVA_HOME/bin/java -jar -Xms256M -Xmx768M -Dsun.java2d.opengl=true -Djava.library.path=/usr/lib/jni/ Edna.jar
unset JAVA_HOME
killall xinit
_EOF_
    chmod +x "$md_inst/EdnaBreakout.sh"

    # adjust game's preferen.ces
    for k in accelerated bufferStrategy fullscreen isFullscreen; do
        xmlstarlet ed --inplace -u "//node[@name='edna']/map/entry[@key='$k']/@value" -v 'true' "$_edna_romdir/ednaPreferen.ces"
    done
}
