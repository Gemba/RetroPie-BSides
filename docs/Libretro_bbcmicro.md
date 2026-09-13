
## How-To for 'Libretro BBC Micro' Scriptmodule

BBC Micro emulator: Libretro core of the b2 emulator for RetroArch  

![Image for 'Libretro BBC Micro'](img/Libretro%20BBC%20Micro.png)

**Additional Notes**

- Review `~/.emulationstation/es_systems.cfg` at the `<name>bbcmicro</name>` section system, if you need to add more file extensions. This module sets `.dsd` and `.ssd` as extensions in that file.
- This libretro core set the game focus to ON by default (`input_auto_game_focus=1`) in `/opt/retropie/configs/retroarch.cfg` respective `retroarch.cfg.rp-dist`.
- The key to toggle the game focus behaviour is by default _Scroll Lock_
- The toggle game focus is set to button 3 of the joystick/gamecontroller. To change, review the information at: `https://retropie.org.uk/docs/RetroArch-Configuration/#determining-button-values`

**References**

- Extensive [libretro core documentation](https://docs.libretro.com/library/b2/) and further links at the end of that page.
- Project site: https://github.com/zoltanvb/b2-libretro
- BBC-B keyboard picture CC-BY-SA 2.0 Barney Livingston @ Flickr

**Execute Scriptmodule to Deploy Content**

`sudo ~/RetroPie-Setup/retropie_packages.sh lr-b2`

