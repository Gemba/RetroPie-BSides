
## How-To for 'Libretro Applewin' Scriptmodule

Apple2e emulator: AppleWin (current) libretro core for RetroArch  

![Screenshot of 'Libretro Applewin'](img/Libretro%20Applewin.png)

**Additional Notes**

- This libretro core set the game focus to off by default (`input_auto_game_focus=0`).
- The toggle game focus is set to button 3. To change, review the information at: `https://retropie.org.uk/docs/RetroArch-Configuration/#determining-button-values`
- You can cycle through the video modes with right shoulder button (RETRO_DEVICE_ID_JOYPAD_R). You can toggle scanlines with left shoulder button (RETRO_DEVICE_ID_JOYPAD_L).

**References**

- Project site: https://github.com/audetto/AppleWin

**Execute Scriptmodule to Deploy Content**

`sudo ~/RetroPie-Setup/retropie_packages.sh lr-applewin`

