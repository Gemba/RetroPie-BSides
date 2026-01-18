
## How-To for 'Baba Is You' Scriptmodule

Module for the puzzle game 'Baba Is You' by Hempuli  

![Screenshot of 'Baba Is You'](img/Baba%20Is%20You.png)

_This scriptmodule requires the Linux PC version of the game._

**Preparation**

_Attention_: If you run a 32-bit OS (`getconf LONG_BIT`) do use the 'Baba Is You' version 478f (dated 2024-02-24) as this is the last version which contains the 32-bit executable.
1. Obtain the PC game `BIY_linux.tar.gz` from https://hempuli.itch.io/baba and copy the archive to your Raspberry RetroPie (RPi) to the folder `~/RetroPie/roms/ports`.
2. Then run this scriptmodule via RetroPie-Setup.

**Notes for the First Start of the Game**

Only apply these if you encounter that the game screen (with the menu, not the splash screen) does not use the full width (x-resoulution):
- The game has a native resolution of 854x480 (FWVGA). You can not use fullscreen mode in this setup. But it can be perfectly played in windowed mode. Thus, you should set your video mode in the _Runcommand Menu_ of RetroPie to the closest to fully fit in the game screen FWVGA. E.g. Select video mode 1024x768 on 4:3 and 5:4 aspect ratio displays, and to 854x480 (FWVGA) on 16:9 and 16:10 aspect ratio displays in the runcommand menu _Select video mode for babaisyou_.
- You only have to do this once , unless you change your display (see Troubleshooting below in that case).
- Change _Toggle Fullscreen_ in the game settings to _off/unselected_, then restart the game: The display should be centered.

**Additional Notes**

- Game save/progress and settings are kept at: `~/.local/share/Baba_Is_You/`
- Tested with 'Baba Is You' Linux version 478f on a Raspberry Pi4 (32-bit) and with version 481d (dated 2026-01-02) on a Raspberry Pi5 (64-bit). It should also work as well on a Raspberry Pi3, Zero2w, aso.
- On RetroPie Buster: Ignore the warning of Box86 being not supported on RaspiOS Buster (RaspiOS 10), the game will run nevertheless

**Troubleshooting**

If you did not follow the steps to adjust the resolution, here is how to start over: Launch Baba again from EmulationStation and remember to divert into the _Runcommand Menu_ of RetroPie to adjust the resolution. That's all folks!

**Execute Scriptmodule to Deploy Content**

`sudo ~/RetroPie-Setup/retropie_packages.sh babaisyou`

