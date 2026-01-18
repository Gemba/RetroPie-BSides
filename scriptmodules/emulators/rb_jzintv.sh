#!/usr/bin/env bash

# jzIntv emulator with some fixes.
# Derivate work of jzintv.sh script from RetroPie Project.

# Copyright 2026 Gemba @ Github
# SPDX-License-Identifier: GPL-3.0-or-later

# ---
# **Additional Notes**
#
# This is a drop-in replacement for the jzintv scriptmodule of RetroPie. The
# emulator/module id is `rb_jzintv` in contrast to the original `jzintv` in cass
# you have to adjust the emulator selection in the _Runcommand_ menu of
# RetroPie.
#
# This release fixes these issues:
# 1. Correct aspect ratio to 4:3 (as on old TV sets) even if connected to a
#    modern 16:9 display. The game will be pillarboxed, i.e. with black bars on
#    left and right. See also initial discussion at RetroPie forum:
#    https://retropie.org.uk/forum/topic/32433
# 2. Fix a UI freeze on Raspberry Pi Models 3 when a mouse is also connected
# 3. Fix the compile on multiarch RaspiOS installations (i.e., aarch64 and
#    armhf) due to a SDL2 upstream bug present in pre-Trixie installations.

rp_module_id="rb_jzintv"
rp_module_desc="Intellivision emulator with 16:9 aspect ratio fix"
rp_module_help="ROM Extensions: .int .bin .rom\n\nCopy your Intellivision roms to $romdir/intellivision\n\nCopy the required BIOS files exec.bin and grom.bin to $biosdir"
rp_module_licence="GPL2 http://spatula-city.org/%7Eim14u2c/intv/"
rp_module_repo="file $__archive_url/jzintv-20200712-src.zip"
rp_module_section="opt"
rp_module_flags="sdl2 nodistcc"

function depends_rb_jzintv() {
    getDepends libsdl2-dev libreadline-dev dos2unix
}

function sources_rb_jzintv() {
    rm -rf "$md_build/jzintv"
    downloadAndExtract "$md_repo_url" "$md_build"
    # jzintv-YYYYMMDD/ --> jzintv/
    mv jzintv-[0-9]* jzintv
    cd jzintv/src

    if isPlatform "rpi" ; then
        dos2unix $(find "$md_data" -iname "*.patch" -exec grep -h "^+++" {} \+ | cut -f2- -d '/' | uniq | xargs)
        applyPatch "$md_data/01_rpi_hide_cursor_sdl2.patch"
        applyPatch "$md_data/01_rpi_pillar_boxing_black_background_sdl2.patch"
        applyPatch "$md_data/02_Makefile_SDL2_multiarch.patch"
    fi

    # Add source release date information to build
    mv buildcfg/90-svn.mak buildcfg/90-svn.mak.txt
    echo "SVN_REV := $(echo $md_repo_url | grep -o -P '[\d]{8}')" > buildcfg/90-src_releasedate.mak
    sed -i.zip-dist "s/SVN Revision/Releasedate/" svn_revision.c

    # aarch64 doesn't include sys/io.h - but it's not needed so we can remove
    grep -rl "include.*sys/io.h" | xargs sed -i "/include.*sys\/io.h/d"

    # remove shipped binaries / libraries
    rm -rf ../bin
}

function build_rb_jzintv() {
    mkdir -p jzintv/bin
    cd jzintv/src

    make clean
    make

    md_ret_require="$md_build/jzintv/bin/jzintv"
}

function install_rb_jzintv() {
    rp_callModule jzintv remove
    md_ret_files=(
        'jzintv/bin'
        'jzintv/doc'
        'jzintv/src/COPYING.txt'
        'jzintv/src/COPYRIGHT.txt'
        $(find jzintv/Release*)
    )
}

function configure_rb_jzintv() {
    mkRomDir "intellivision"

    local -r start_script="$md_inst/jzintv_launcher.sh"
    cat > "$start_script" << _EOF_
#! /usr/bin/env bash

# \$1: width of display
# \$2: height of display
# \$3: --ecs=1, optional
# \$4,5,6...: more optional parameters
# last parameter: %ROM%

jzintv_bin="$md_inst/bin/jzintv"

# regular case: w>=h (rotation 90/270 not supported by jzintv)
disp_w=\$1; shift
disp_h=\$1; shift

ratio="4/3"
do_pillarboxing='\$(python3 -c "print(\$disp_w / \$disp_h >= \$ratio)")'
if [[ "\$do_pillarboxing" == "True" ]] ; then
    # le/ri padding
    intv_w=\$(python3 -c "print(round(\$disp_h * \$ratio))")
    intv_h=\$disp_h
else
    # top/btm padding (letterboxing; e.g., on 5:4 displays)
    intv_w=\$disp_w
    intv_h=\$(python3 -c "print(round(\$disp_w / (\$ratio)))")
fi

# set --gfx-verbose instead of --quiet for verbose output
options=(
    -f1 # fullscreen
    --quiet
#    --gfx-verbose
    --displaysize="\${intv_w}x\${intv_h}"
    --rom-path="$biosdir"
    --voice=1
)

echo "Launching: \$jzintv_bin \${options[@]} \"\$@\"" >> /dev/shm/runcommand.log
pushd "$romdir/intellivision" > /dev/null
\$jzintv_bin \${options[@]} "\$@"
popd
_EOF_
    chown $user:$user "$start_script"
    chmod u+x "$start_script"

    addEmulator 1 "$md_id"     "intellivision" "'$start_script' %XRES% %YRES% %ROM%"
    addEmulator 0 "$md_id-ecs" "intellivision" "'$start_script' %XRES% %YRES% --ecs=1 %ROM%"
    addSystem "intellivision"
}
