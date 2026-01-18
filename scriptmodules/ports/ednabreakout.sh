#!/usr/bin/env bash

# RetroPie scriptmodule for the Point and Click adventure: Edna & Harvey: The Breakout
#
# Copyright 2023 Gemba @ Github

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
#  Tested with GOG 1.4.2 release of Edna and Harvey (contains EH 1.3.1, dated
#  2018-07-31) which relies on a Java Runtime. The Anniversary Edition from 2019
#  **will not work** with this scriptmodule as it uses Unity.
#
# 1. Obtain the Oracle JDK. This [Oracle
#    site](https://www.oracle.com/de/java/technologies/javase/javase8u211-later-archive-downloads.html)
#    still has legacy JDKs.
#     - For armhf / 32-bit setups search for
#       _jdk-8u381-linux-arm32-vfp-hflt.tar.gz_ on the site.
#     - For aarch64 / 64-bit setups search for _jdk-8u461-linux-aarch64.tar.gz_
#       on the site.
#     - Download the identified JDK and transfer it to your RetroPie.
#
# 2. Install the JDK. 
#     - Execute on your RetroPie: `mkdir -p
#       ~/RetroPie/roms/ports/edna && cd ~/RetroPie/roms/ports/edna`. 
#     - Then 'un-tar'
#       the JDK inside this folder, e.g. `tar xzf
#       /path/to/jdk-8u461-linux-aarch64.tar.gz` (filename may differ). 
#     - Finally, rename the folder of the expanded tar: `mv jdk1.8.0_* jdk1.8.0` 
#     - **Tip**: If you are using RetroPie on Debian 11 or later you may now run
#       `sudo ~/RetroPie-Setup/retropie_packages.sh edna depends`. It will
#        install the tool `innoextract` whcih will be used later.
# 
# 3. Deploy the game files. 
#     - Get your GOG "Edna and Harvey" setup files (usually a `*.exe` and a
#       larger `*.bin`) and copy it to your RetroPie or when on RetroPie Buster
#       (Debian 10) then skip the innoextract step.
#     - Debian 11 and up: Run innoextract v1.8 (or later) with this command:
#       `innoextract setup_edna__harvey_the_breakout_*.exe -I edna_original`
#     - Debian 10: Install the game on Windows as usual or use `innoextract` on
#       a recent Linux distro.
#     - In both cases search for a folder `edna_original/` (and transfer that
#       folder-tree to the Raspberry Pi from the Windows installation).
#     - Change into folder `edna_original` folder on the Pi and execute: `rsync
#       -avr data lib script Edna.jar ednaPreferen* *.txt
#       ~/RetroPie/roms/ports/edna`
#     - Be patient, the copy may take a while. Remove the source `edna_original`
#       folder.
#
# 4. That's it. Now run this scriptmodule.
#
# 5. Enjoy the game!

# **Additional Notes**
#
# - Savegames are at: `~/AppData/Local/Daedalic Entertainment/Edna/savegame`
# - Change language (en/de) in file `~/RetroPie/roms/ports/edna/ednaPreferen.ces`

rp_module_id="edna"
rp_module_desc="Module for the point and click adventure 'Edna and Harvey: The breakout'"
rp_module_licence="PROP"
rp_module_section="opt"
rp_module_flags="all"
rp_module_help="Requires manual installation of GOG game files (non-anniversary edition) and Oracle JDK. See comments in this scriptmodule for details."

_edna_romdir="$romdir/ports/edna"

function depends_edna() {
    local deb_pkgs=(
        liblwjgl-java 
        libopenal-data 
        libopenal1 
        pulseaudio 
        pulseaudio-utils
		rsync
        xorg 
    )
    if [[ "$__os_debian_ver" -gt 10 ]] ; then
        deb_pkgs+=(innoextract)
    fi
    getDepends ${deb_pkgs[*]}
}

function install_edna() {
    downloadAndExtract 'http://downloads.sourceforge.net/project/java-game-lib/Official%20Releases/LWJGL%202.9.3/lwjgl-2.9.3.zip' "$md_build"
    mkUserDir "$_edna_romdir"/lib
    cp -p "$md_build/lwjgl-2.9.3/jar/lwjgl.jar" "$_edna_romdir"/lib
    chown "$user": "$_edna_romdir"/lib/*.jar
    chmod a+x "$_edna_romdir"/lib/*.jar
}

function configure_edna() {
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
