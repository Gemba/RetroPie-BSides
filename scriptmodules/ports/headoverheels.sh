#! /usr/bin/env bash

# Copyright 2023 Gemba @ Github
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
# **Additional Notes**
#
# - In its current state, the game only runs smoothly on a Raspberry Pi 4 
#   and onwards or on x86.
# - Preferences are in `~/.headoverheels/preferences.xml`.
# - Savegames are held in `~/.headoverheels/savegame/*`.

# **Notes for the First Start of the Game**
#
# Do set in RetroPie's runcommand menu the resolution to 640x480 for performance
# reasons.

rp_module_id="hoh"
rp_module_desc="Open sourced and enhanced remake of 'Head over Heels'"
rp_module_licence="GPL3 https://github.com/dougmencken/HeadOverHeels/blob/master/LICENSE"
rp_module_repo="git https://github.com/dougmencken/HeadOverHeels.git v1.4dev-3ffeabbe"
rp_module_help="Batteries included: No extra gamefiles needed."
rp_module_section="opt"
rp_module_flags="!all rpi4 rpi5 x86"

_hoh_romdir="$romdir/ports/headoverheels"
_hoh_executable="bin/headoverheels"

function depends_hoh() {
    local deb_pkgs=(
        autoconf
        cmake
        liballegro-acodec5-dev
        liballegro-audio5-dev
        liballegro-image5-dev
        liballegro5-dev
        libpng-dev
        libtinyxml2-dev
        libtool
        libvorbis-dev
        x11-utils
        xorg
    )
    getDepends ${deb_pkgs[*]}
}

function sources_hoh() {
    gitPullOrClone
}

function build_hoh() {
    mkdir -p m4
    [ -f ./configure -a -f source/Makefile.in ] || autoreconf -f -i

    ./configure --with-allegro5 --prefix="$_hoh_romdir" #--enable-debug=yes

    make clean
    make 
    md_ret_require="$md_build/source/$(basename "$_hoh_executable")"
}

function install_hoh() {
    make install
    cp -p "$md_build"/LICENSE "$_hoh_romdir"
    chown -R "$user": "$_hoh_romdir"
}

function configure_hoh() {

    local ports_cfg_dir="headoverheels"
    local launcher="$md_inst/launcher.sh"

    addPort "$md_id" "$ports_cfg_dir" "Head over Heels" "XINIT:$launcher"
    [[ "$md_mode" != "install" ]] && return

    local pref_dir="$home"/.headoverheels
    local pref_file="$pref_dir"/preferences.xml

    mkUserDir "$pref_dir"
    moveConfigDir "$pref_dir" "$md_conf_root/$ports_cfg_dir"

    if [[ ! -e "$pref_file" ]] ; then
        cat >"$pref_file" << _EOF_
<preferences>
    <language>en_US</language>
    <keyboard>
        <movenorth>Left</movenorth>
        <movesouth>Right</movesouth>
        <moveeast>Up</moveeast>
        <movewest>Down</movewest>
        <jump>Space</jump>
        <take>c</take>
        <takeandjump>b</takeandjump>
        <doughnut>n</doughnut>
        <swap>x</swap>
        <pause>Esc</pause>
        <automap>Tab</automap>
    </keyboard>
    <audio>
        <fx>80</fx>
        <music>75</music>
        <roomtunes>true</roomtunes>
    </audio>
    <video>
        <fullscreen>true</fullscreen>
        <shadows>true</shadows>
        <background>true</background>
        <graphics>gfx</graphics>
    </video>
</preferences>
_EOF_
        chown "$user": "$pref_file"
    fi

    cat >"$launcher" << _EOF_
#! /usr/bin/env bash
xset -dpms s off s noblank
cd "$_hoh_romdir"
bin/headoverheels
killall xinit
_EOF_

    chown "$user": "$launcher"
    chmod a+x "$launcher"
}
