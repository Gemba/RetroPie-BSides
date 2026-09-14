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

# ---
# **Before usage**
#
# - Have input Joystick/Gamepad device(s) connected to GPIO
# - Have MCP23017 wired (only when using more than two devices)
# - Uninstall other GPIO based drivers (`db9_gpio_rpi`,`mk_arcade_joystick_rpi`)
#   of RetroPie:
#   - `sudo ~/RetroPie-Setup/retropie_packages.sh db9_gpio_rpi remove` and
#   - `sudo ~/RetroPie-Setup/retropie_packages.sh mk_arcade_joystick_rpi remove`.

# **Additional Notes**
#
# - You will have to edit at least `/boot/config.txt` to load the device tree
#   driver. See https://github.com/gemba/arcade-dt#configuration.

rp_module_id="arcadedt"
rp_module_desc="Lowest latency Joystick/Gamepad driver for GPIO connected input devices."
rp_module_licence="GPL2 https://github.com/Gemba/arcade-dt/blob/master/LICENSE"
rp_module_section="opt"
rp_module_flags="!all rpi1 rpi2 rpi3 rpi4 rpi5"
rp_module_help="Requires manual configuration before fully usable, see: https://github.com/gemba/arcade-dt"
rp_module_repo="git https://github.com/gemba/arcade-dt master"

function depends_arcadedt() {
    local deb_pkgs=(
        cpp
        device-tree-compiler
        evtest
        gpiod
        make
    )
    local kernel=$(uname -r | cut -f 2- -d'-')
    if LANG=C apt-cache policy "linux-headers-$kernel" | grep -q Version; then
        deb_pkgs+=("linux-headers-$kernel")
    else
        # RetroPie Buster
        deb_pkgs+=(linux-headers-rpi)
    fi
    getDepends ${deb_pkgs[*]}
}

function sources_arcadedt() {
    gitPullOrClone
    git submodule init
    git submodule update
}

function build_arcadedt() {
    make
}

function install_arcadedt() {
    make install
}

function configure_arcadedt() {
    [[ $md_mode != "install" ]] && return
    local msg=(
        "You must configure at least /boot/config.txt before Arcade DT is fully usable!"
        "See: https://github.com/gemba/arcade-dt#configuration"
		" "
        "If you have different GPIO wiring than the default or use MCP23017, then rerun this scriptmodule in steps:"
		" "
        "1. Run: retropie_packages.sh arcadedt sources"
        "2. Make changes according to your setup, see URL above."
        "3. Run: retropie_packages.sh arcadedt build"
        "4. Run: retropie_packages.sh arcadedt install"
    )

    printMsgs dialog "$(printf "%s\n" "${msg[@]}")"
}
