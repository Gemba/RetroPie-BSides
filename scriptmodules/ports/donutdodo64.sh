#!/usr/bin/env bash

# RetroPie scriptmodule for "Donut Dodo" (jump-n-run game by Sebastian Kostka /
# pixel games)
#
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
# **Preparation**
#
# Do these one-time installation steps, _before_ running this scriptmodule.
#
# - Only use this module for aarch64 (64 bit) installations. For armhf (32 bit)
#   use the scriptmodule [provided by pixel
#   games](https://zapposh.itch.io/donut-dodo-retropie-edition)
# - Get a 64Bit build of the game for Linux (e.g., from GOG)
# - Place the `donut_dodo_*.sh` file onto your RetroPie at `~/RetroPie/roms/ports/`

# **Additional Notes**
#
# - Once the installation is done, you get prompted if you want to remove the
#   original installer
# - Most likely you want to adjust the Options (scaling, CRT emulation) at the
#   first start of the game
# - Configuration is held in `~/.local/share/DonutDodo`
# - Tested on a Raspberry Pi 5 (Bookworm) but should also run smooth on a
#   Raspberry Pi 4 and possible other models

# **Known Caveats**
#
# - Currently the game uses Software-Rendering, if it is sluggish reduce the
#   scaling or the CRT emulation in the game option. If you find a way to
#   utilize the GPU (via Godot Engine and Box64) feel free to file an pull request.
# - Alternative game installer fer sure work if they are packaged with the tool
#   Mojo-Setup
# - Other install media may work, key is to have a Donut Dodo binary compiled
#   for x86_64, the binary is expected at
#   `~/RetroPie/roms/ports/donutdodo64/DonutDodo.x86_64`
# - Make sure to select "Donut Dodo" as launcher in EmulationStation (not the
#   subfolder or the installer file)

rp_module_id="donutdodo64"
rp_module_desc="Module for the jump-n-run 'Donut Dodo' for 64 bit ARM installations."
rp_module_licence="PROP"
rp_module_section="opt"
rp_module_flags="!all aarch64 rpi4 rpi5"
rp_module_help="Requires GOG game binary (donut_dodo_*.sh, for Linux PC 64-bit) installer."

_donutdodo_romdir="$romdir/ports/$rp_module_id"
_donutdodo_game_bin="data/noarch/game/DonutDodo.x86_64"

function depends_donutdodo64() {
    # Box64
    gitPullOrClone "$home/pi-apps" https://github.com/Botspot/pi-apps
    chown -R $user: "$home/pi-apps"
    sudo -u "$user" stdbuf -o0 $home/pi-apps/manage install Box64
}

function build_donutdodo64() {
    mkUserDir "$md_build"

    [[ ! -f "$md_build"/gogextract.py ]] && download https://raw.githubusercontent.com/Yepoleb/gogextract/refs/heads/master/gogextract.py "$md_build"/gogextract.py

    local src_path="${_donutdodo_romdir%/*}"
    local gog_installer="$(find "$src_path"/donut_dodo_*.sh 2>/dev/null)"

    if [[ ! -z "$gog_installer" ]]; then
        mkUserDir "$_donutdodo_romdir"
        python3 gogextract.py "$gog_installer"
        7z x data.zip "$_donutdodo_game_bin"
    else
        src_path=$(printf '~%s\n' "${src_path#"${home%/}"}")
        printMsgs dialog "Game binary donut_dodo_*.sh not found in\n\n$src_path\n\nCheck documentation. Cannot continue!"
        exit 1
    fi
    md_ret_require="$md_build/$_donutdodo_game_bin"
}

function install_donutdodo64() {
    if [[ -e "$_donutdodo_game_bin" ]]; then
        mv "$_donutdodo_game_bin" "$_donutdodo_romdir"
		printMsgs console "Installed binary to $_donutdodo_romdir"
    fi
    local gog_installer="$(find "${_donutdodo_romdir%/*}"/donut_dodo_*.sh 2>/dev/null)"
    chown -R $user: "$_donutdodo_romdir"
    if [[ -e "$gog_installer" ]]; then
        dialog --title "Installation complete" --defaultno --yesno "\nRemove the installer file '$(printf '~%s\n' "${gog_installer#"${home%/}"}")'?\n\n" 8 64 2>&1 >/dev/tty && rm -f "$gog_installer"
    fi
}

function configure_donutdodo64() {
    addPort "$md_id" "$md_id" "Donut Dodo" "XINIT:$md_inst/rplauncher.sh"

    [[ $md_mode != "install" ]] && return

    mkdir -p "$home/.local/share/DonutDodo" && chown -R $user: "$home/.local/share/DonutDodo"
    moveConfigDir "$home/.local/share/DonutDodo" "$configdir/ports/$md_id"

    cat >"$md_inst/rplauncher.sh" <<_EOF_
#! /usr/bin/env bash
set -x
xset -dpms s off s noblank

cd "$_donutdodo_romdir"
export LIBGL_ALWAYS_SOFTWARE=1
box64 ./DonutDodo.x86_64
killall xinit
_EOF_
    chmod +x "$md_inst/rplauncher.sh"
}
