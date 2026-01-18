
## How-To for 'Bash Welcome' Scriptmodule

Adds extra version info (Raspberry Pi model, RetroPie-Setup, RetroArch, SDL) to the message-of-the-day logon banner.  

![Screenshot of 'Bash Welcome'](img/Bash%20Welcome.png)

_Displays the RetroPie ASCII-art alongside with additional information about thesystem when the pi account logs in similar to the genuine bashwelcometweakscriptmodule. Extra output of Raspbery model, RetroPie-Setup and RetroArchSDL version. Temperature (C/F) is shown according to locale._

**Additional Notes**

- On message of the day (MOTD) screen there will be also the Pi Model, the version of RetroPie-Setup and the RetroArch version as well as the SDL version displayed. Note the extra green lines in output.
- To change the locale run `sudo raspi-config`, then _3 Localisation Options_ 
    -> _L1 Locales_. There set your wanted locale options.
- To get locale specific measurements (metric/imperial) for temperatures, set the environment variable `LC_MEASUREMENT` in your `~/.bashrc` like this: `export LC_MEASUREMENT=en_US` for imperial (Fahrenheit). Default is `LC_MEASUREMENT=en_GB`, thus metric (Celsius).
- RetroPie-Setup may revert to the pristine bashwelcometweak in some conditions. If this happens, re-execute this scriptmodule again.

**Execute Scriptmodule to Deploy Content**

`sudo ~/RetroPie-Setup/retropie_packages.sh rb_bashwelcome`

