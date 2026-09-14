
## Mini How-To for 'Donut Dodo' Scriptmodule

Module for the jump-n-run 'Donut Dodo' for 64 bit ARM installations.  

![Screenshot of 'Donut Dodo'](img/Donut%20Dodo%20Logo.png)

_Requires GOG game binary (donut_dodo_*.sh, for Linux PC 64-bit) installer._

**Preparation**

Do these one-time installation steps, _before_ running this scriptmodule.
- Only use this module for aarch64 (64 bit) installations. For armhf (32 bit) use the scriptmodule [provided by pixel games](https://zapposh.itch.io/donut-dodo-retropie-edition)
- Get a 64 bit build of the game for Linux (e.g., from GOG)
- Place the `donut_dodo_*.sh` file onto your RetroPie at `~/RetroPie/roms/ports/`

**Additional Notes**

- Configuration is held in `~/.local/share/DonutDodo``
- Once the installation is done, you get prompted if you want to remove the original installer
- Tested on a Raspberry Pi 5 (Bookworm) but should also run smooth on a Raspberry Pi 4 and possible other models

**Known Caveats**

- Currently the game uses Software-Rendering, if it is sluggish reduce the scaling or the CRT emulation in the game option. If you find a way to utilize the GPU feel free to file an pull request.
- Alternative game installer fer sure work if they are packaged with the tool Mojo-Setup
- Other install media may work, key is to have a Donut Dodo binary compiled for x86_64, the binary is expected at `~/RetroPie/roms/ports/donutdodo64/DonutDodo.x86_64`
- Make sure to select "Donut Dodo" as launcher in EmulationStation (not the subfolder or the installer file)

**Execute Scriptmodule to Deploy Content**

`sudo ~/RetroPie-Setup/retropie_packages.sh donutdodo64`

