#! /usr/bin/env python3

#
# Patches the "Baba is You" binary 'Chowdren' to current video resolution
# (%XRES% and %YRES% in 16:9 aspect ratio) once. The pristine game file is kept in
# 'Chowdren_unpatched'
#
# By default the game resolution is FWVGA (854x480) and setting fullscreen via
# the game options does not currently work within RetroPie.
#
# Copyright 2025 Gemba @ Github
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.


import os
import pickle
import re
import shutil
import struct
import sys
from pathlib import Path
from hashlib import sha256


def preserve_orig():
    orig = fn + "_unpatched"
    if not Path(orig).exists():
        shutil.copy2(fn, orig)
        st = os.stat(fn)
        os.chown(orig, st.st_uid, st.st_gid)
        print(f"[*] Copied original file to '{orig}'.")
    else:
        print(f"[*] '{orig}' already exists, keeping that.")


def check_version():
    # sha256 of bin32/Chowdren, bin64/Chowdren of version 478f
    exp_478f = {
        "bin32": "3fcc6a8b32fad37919dd1e29079c9aad0d20585be93823b603bdbb5a2c45a18e",
        "bin64": "bdc9d3781eaa725374adb67c09478c6ea5bec8b60242fd2a0d30faf6b03e7d7f",
    }
    exp_481d = {
        "bin32": "N/A",
        "bin64": "0cd262733efc9f383726df626c657d405b3977dd017e0fdf2c052d824db6a223",
    }
    m = sha256()
    with open(fn, "rb") as f:
        m.update(f.read())

    detected_ver = None
    if m.hexdigest() != exp_478f[arch] and m.hexdigest() != exp_481d[arch]:
        print("[-] Checksum failed. Patch may not be successful.")
    else:
        detected_ver = "478f" if m.hexdigest() == exp_478f[arch] else "481d"
    return detected_ver

def patch():
    bs = 1024
    cutoff = 0x200000
    patches = patchdata(arch)
    with open(fn, "r+b") as f:
        for k, v in patches.items():
            if 'ver' in v.keys() and detected_ver:
                if v['ver'] != detected_ver:
                    continue
            f.seek(0)
            print(f"[*] Patching '{v['hint']}' ...")
            data = f.read(bs)
            pos = 0
            found = False
            while data and pos < cutoff:
                f1 = re.search(k, data.hex())
                if f1:
                    found = True
                    break
                data = f.read(bs)
                pos += bs

            if not found:
                print("[-]   Not found. File might be already patched.")
                continue

            b = (int)(f1.start() / 2)
            off = pos + b
            print(f"[+]   Match at: 0x{off:x}")

            patch_off = off + v["tgtoffset"]
            f.seek(patch_off)
            new_val = struct.pack("<H", v["new"])
            f.write(new_val)
            print(f"[+]   OK. New value set to {v['new']}")


def patchdata(arch):
    patches = {}
    patches["bin32"] = {
        # platform_create_display()
        # 84 c0           TEST       AL,AL
        # b8 23 30        MOV        EAX,0x3023
        # 00 00
        "84c0b823300000": {
            "tgtoffset": 3,
            "expected": 0x3023,
            "new": 0x2022,
            "hint": "Always windowed mode (SDL flags)",
        },
        # c7 04 24        MOV        dword ptr [ESP]=>local_3c,0x356
        # 56 03 00 00
        # e8 1b b2        CALL       _chowlog::log                                    undefined log(int param_1)
        # 0a 00
        "c7042456030000e8": {
            "tgtoffset": 3,
            "expected": 0x0356,
            "new": width,
            "hint": "Log width",
        },
        # c7 04 24        MOV        dword ptr [ESP]=>local_3c,0x1e0
        # e0 01 00 00
        # e8 01 b2        CALL       _chowlog::log                                    undefined log(int param_1)
        # 0a 00
        "c70424e0010000e8": {
            "tgtoffset": 3,
            "expected": 0x01E0,
            "new": height,
            "hint": "Log height",
        },
        # c7 44 24        MOV        dword ptr [ESP + local_30],0x356
        # 0c 56 03
        # 00 00
        "c744240c56030000": {
            "tgtoffset": 4,
            "expected": 0x0356,
            "new": width,
            "hint": "SDL Window width",
        },
        # c7 44 24        MOV        dword ptr [ESP + local_2c],0x1e0
        # 10 e0 01
        # 00 00
        "c7442410e0010000": {
            "tgtoffset": 4,
            "expected": 0x01E0,
            "new": height,
            "hint": "SDL Window height",
        },
        # platform_set_fullscreen()
        # 31 c0           XOR        EAX,EAX
        # 84 c9           TEST       CL,CL
        # b9 01 10        MOV        ECX,0x1001
        # 00 00
        "31c084c9b901100000": {
            "tgtoffset": 5,
            "expected": 0x1001,
            "new": 0x0000,
            "hint": "Disable toggle fullscreen",
        },
    }
    patches["bin64"] = {
        # platform_create_display()
        # 85 ff           TEST       param_1,param_1
        # b8 23 30        MOV        EAX,0x3023
        # 00 00
        "85ffb823300000": {
            "tgtoffset": 3,
            "expected": 0x3023,
            "new": 0x2022,
            "hint": "Always windowed mode (SDL flags)",
        },
        # bf 56 03        MOV        param_1,0x356
        # 00 00
        # e8 e1 93        CALL       _chowlog::log                                    undefined log(int param_1)
        # 0a 00
        "bf56030000e8": {
            "tgtoffset": 1,
            "expected": 0x0356,
            "new": width,
            "hint": "Log width [...don't care if patch fails]",
            "ver":"478f",
        },
        # bf e0 01        MOV        param_1,0x1e0
        # 00 00
        # e8 c8 93        CALL       _chowlog::log                                    undefined log(int param_1)
        # 0a 00
        "bfe0010000e8": {
            "tgtoffset": 1,
            "expected": 0x01E0,
            "new": height,
            "hint": "Log height [...don't care if patch fails]",
            "ver":"478f",
        },
        # ba 00 00        MOV        EDX,0x2fff0000
        # ff 2f
        # b9 56 03        MOV        ECX,0x356
        # 00 00
        "ba0000ff2fb956030000": {
            "tgtoffset": 6,
            "expected": 0x0356,
            "new": width,
            "hint": "SDL Window width",
        },
        # 41 b8 e0        MOV        R8D,0x1e0
        # 01 00 00
        # 41 89 d9        MOV        R9D,EBX
        "41b8e001000041": {
            "tgtoffset": 2,
            "expected": 0x01E0,
            "new": height,
            "hint": "SDL Window height",
        },
        # platform_set_fullscreen() - ver 478f
        # 31 c0           XOR        EAX,EAX
        # 84 db           TEST       BL,BL
        # be 01 10        MOV        ESI,0x1001
        # 00 00
        "31c084dbbe01100000": {
            "tgtoffset": 5,
            "expected": 0x1001,
            "new": 0x0000,
            "hint": "Disable toggle fullscreen [...don't care if patch fails]",
            "ver":"478f",
        },
        # platform_set_fullscreen() - ver 481d
        # 84 db           TEST  BL,BL
        # b8 01 10 00     MOV   EAX,0x1001
        # 0f 45 e8        CMOV  EBP,EAX
        "84dbb8011000000f45e8": {
            "tgtoffset": 3,
            "expected": 0x1001,
            "new": 0x0000,
            "hint": "Disable toggle fullscreen [...don't care if patch fails]",
            "ver":"481d",
        },
    }

    return patches[arch]


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(f"[!] Usage: {sys.argv[0]} <filename> <x-resolution> <y-resolution>")
        sys.exit()

    print("[*] 'Baba Is You' screen resolution patcher for RaspiOS / RetroPie.")
    print("    Verified ok with versions: 478f and 481d. (C) 2025 Gemba @ GitHub")

    fn = sys.argv[1]
    arch = "bin32" if "bin32/" in fn else "bin64"

    dim_x = (int)(sys.argv[2])
    dim_y = (int)(sys.argv[3])

    prev_dims = (-1,-1)
    prev_fn = Path("prev_dims.p")
    if prev_fn.exists():
        prev_dims = pickle.load(open(prev_fn, "rb"))
    
    if prev_dims[0] == -1 or prev_dims[0] != dim_x:
        aspect_r = dim_x / dim_y
        width = dim_x
        height = round(0.5 + dim_x / (854 / 480))
        print(f"[*] Calculated game display dimensions {width}x{height}")

        if prev_dims[0] == -1:
            preserve_orig()
        else:
            shutil.copy2(fn + "_unpatched", fn)
            st = os.stat(fn + "_unpatched")
            os.chown(fn, st.st_uid, st.st_gid)
        detected_ver = check_version()
        if detected_ver:
            print (f"[+] Detected game version: {detected_ver}")
        patch()
        prev_dims = (dim_x, dim_y)
        pickle.dump(prev_dims, open(prev_fn, "wb"))
        print("[*] Done.")
    else:
        print(f"[*] No patching as screen resolution is unchanged.")
