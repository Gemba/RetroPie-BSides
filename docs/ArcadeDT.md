
## Mini How-To for 'Arcade DT' Scriptmodule

Lowest latency Joystick/Gamepad driver for GPIO connected input devices.  

![Screenshot of 'Arcade DT'](img/arcadedt.png)

_Requires manual configuration before fully usable, see: https://github.com/gemba/arcade-dt_

**Before usage**

- Have input Joystick/Gamepad device(s) connected to GPIO
- Have MCP23017 wired (only when using more than two devices)
- Uninstall other GPIO based drivers (`db9_gpio_rpi`,`mk_arcade_joystick_rpi`) of RetroPie: 
    - `sudo ~/RetroPie-Setup/retropie_packages.sh db9_gpio_rpi remove` and 
    - `sudo ~/RetroPie-Setup/retropie_packages.sh mk_arcade_joystick_rpi remove`.

**Additional Notes**

- You will have to edit at least `/boot/config.txt` to load the device tree driver. See https://github.com/gemba/arcade-dt#configuration.

**Execute Scriptmodule to Deploy Content**

`sudo ~/RetroPie-Setup/retropie_packages.sh arcadedt`

