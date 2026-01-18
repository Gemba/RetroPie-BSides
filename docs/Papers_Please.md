
## How-To for 'Papers, Please' Scriptmodule

Module for the simulation game 'Papers, Please' by Lucas Pope  

![Screenshot of 'Papers, Please'](img/Papers,%20Please.png)

_Requires Humble (*.deb) or GOG (setup_papers_please*.sh) installer. (any version before v1.4.0 should work)._

**Preparation**

Do these one-time installation steps, _before_ running this scriptmodule.
1. Obtain `papers-please_1.1.65_i386.deb` from your Humble account. **Note**: The Unity based version (v1.4.0 onwards) does not work with Box86 and 32-Bit Raspi OS. Continue with step 3. _-OR-_
2. If you have the GOG installer: 
    - Get the script `gogextract.py` from https://github.com/Yepoleb/gogextract 
    - Run it on the GOG Linux installer: `python3 gogextract.py setup_papers_please*.sh` 
    - Unzip the resulting file `data.zip` 
    - Locate the file `PapersPlease` in the expanded Zip archive 
    - Note that location for step 4 below, continue there.
3. Copy the `papers-please*.deb` file into `~/RetroPie-Setup/ext/bsides/scriptmodule/ports/papersplease/` on your RPi. _-OR-_
4. If you have the GOG installer: Copy the binary `PapersPlease` and all sibling files and the subdirectories (`asset/`, `loc/`) to your RPi at `~/RetroPie/roms/ports/papers-please/`. Create the folder `~/RetroPie/roms/ports/papers-please/` first.
5. That's it. Now execute this scriptmodule.
6. If Box86 claims it cannot install due to libsdl2, then unhold the mark with `sudo apt-mark unhold libsdl2-dev`. You may re-install libsdl2 from RetroPie package repository once Box86 is installed: `sudo RetroPie-Setup/retropie_packages.sh sdl2`.
7. 'Glory to Arstotzka!' :)

**Additional Notes**

- On RetroPie Buster: Ignore the warning of Box86 being not supported on RaspiOS Buster (RaspiOS 10), the game will run nevertheless
- Savegames are at: `~/.local/share/3909/PapersPlease/`

**Execute Scriptmodule to Deploy Content**

`sudo ~/RetroPie-Setup/retropie_packages.sh papersplease`

