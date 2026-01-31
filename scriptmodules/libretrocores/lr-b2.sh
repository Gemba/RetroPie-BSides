#! /usr/bin/env bash

# RetroPie scriptmodule to install the libretro core build of 
# b2, BBC Micro emulator

# Copyright 2026 Gemba @ Github
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
# - This libretro core set the game focus to ON by default
#   (`input_auto_game_focus=1`).
# - The key to toggle the game focus behaviour is by default _Scroll Lock_
# - The toggle game focus is set to button 3 of the joystick/gamecontroller. To
#   change, review the information at:
#   `https://retropie.org.uk/docs/RetroArch-Configuration/#determining-button-values`
# - Review `$HOME/.emulationstation/es_systems.cfg` at the
#   `<name>bbcmicro</name>` section system, if you need to add more file
#   extensions. This module sets `.dsd` and `.ssd` as extensions in that file.

rp_module_id="lr-b2"
rp_module_desc="BBC Micro emulator: b2 (current) libretro core for RetroArch"
rp_module_help="ROM Extension: .dsd .ssd .zip\n\nCopy your roms to $romdir/bbcmicro"
rp_module_licence="GPL2 https://raw.githubusercontent.com/zoltanvb/b2-libretro/refs/heads/master/src/COPYING"
rp_module_repo="git https://github.com/zoltanvb/b2-libretro.git master"
rp_module_section="exp"
rp_module_flags=""


#    if [[ $(xmlstarlet sel -t -v "count(/systemList/system[name='$name'])" "$conf") -eq 0 ]]; then
#        xmlstarlet ed -L -s "/systemList" -t elem -n "system" -v "" \
#            -s "/systemList/system[last()]" -t elem -n "name" -v "$name" \
#            -s "/systemList/system[last()]" -t elem -n "fullname" -v "$fullname" \
#            -s "/systemList/system[last()]" -t elem -n "path" -v "$path" \
#            -s "/systemList/system[last()]" -t elem -n "extension" -v "$extension" \
#            -s "/systemList/system[last()]" -t elem -n "command" -v "$command" \
#            -s "/systemList/system[last()]" -t elem -n "platform" -v "$platform" \
#            -s "/systemList/system[last()]" -t elem -n "theme" -v "$theme" \
#            "$conf"
#    else
#        xmlstarlet ed -L \
#            -u "/systemList/system[name='$name']/fullname" -v "$fullname" \
#            -u "/systemList/system[name='$name']/path" -v "$path" \
#            -u "/systemList/system[name='$name']/extension" -v "$extension" \
#            -u "/systemList/system[name='$name']/command" -v "$command" \
#            -u "/systemList/system[name='$name']/platform" -v "$platform" \
#            -u "/systemList/system[name='$name']/theme" -v "$theme" \
#            "$conf"
#    fi

# sed '/^anothervalue=.*/i before=me' test.txt
# xmlstarlet select --template --copy-of "/systemList/system[name='bbcmicro']" /etc/emulationstation/es_systems.cfg

# xmlstarlet select --template --copy-of "/systemList/system[name='bbcmicro']/extension/text()" ~/.emulationstation/es_systems.cfg| xargs
# [[ ".dsd .ssd" != *".bla"* ]] && echo "not there"


function depends_lr-b2() {
    local depends=(
        cmake
    )
    getDepends "${depends[@]}"
}

function sources_lr-b2() {
    gitPullOrClone
}

function build_lr-b2() {
	pushd "$md_build/src/libretro"
	make clean
	make
	popd
    md_ret_require="$md_build/src/libretro/b2_libretro.so"
}

function install_lr-b2() {
    md_ret_files=(
        'src/COPYING'
        'src/libretro/b2_libretro.so'
    )
}

function configure_lr-b2() {
    mkRomDir "bbcmicro"

    if [[ "$md_mode" == "install" ]] ; then
        defaultRAConfig "bbcmicro" "input_auto_game_focus" "1" # 0: off, 1: on, 2: detect
        # Disable at all if defined in parent Retroarch configs or
        # adjust button number below to your controller setup.
        # cf: https://retropie.org.uk/docs/RetroArch-Configuration/#determining-button-values
        defaultRAConfig "bbcmicro" "input_game_focus_toggle_btn" "3"
    fi

    addEmulator 0 "$md_id" "bbcmicro" "$md_inst/b2_libretro.so"
    addSystem "bbcmicro"
}
