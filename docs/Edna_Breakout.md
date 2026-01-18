
## How-To for 'Edna & Harvey: The Breakout' Scriptmodule

Module for the point and click adventure 'Edna and Harvey: The breakout'  

![Screenshot of 'Edna & Harvey: The Breakout'](img/Edna%20&%20Harvey:%20The%20Breakout.png)

_Requires manual installation of GOG game files (non-anniversary edition) and Oracle JDK._

**Preparation**

Tested with GOG 1.4.2 release of Edna and Harvey (contains EH 1.3.1, dated 2018-07-31) which relies on a Java Runtime. The Anniversary Edition from 2019 **will not work** with this scriptmodule as it uses Unity.
1. Obtain the Oracle JDK. This [Oracle site](https://www.oracle.com/de/java/technologies/javase/javase8u211-later-archive-downloads.html) still has legacy JDKs. 
    - For armhf / 32-bit setups search for _jdk-8u381-linux-arm32-vfp-hflt.tar.gz_ on the site. 
    - For aarch64 / 64-bit setups search for _jdk-8u461-linux-aarch64.tar.gz_ on the site. 
    - Download the identified JDK and transfer it to your RetroPie.
2. Install the JDK. 
    - Execute on your RetroPie: `mkdir -p ~/RetroPie/roms/ports/edna && cd ~/RetroPie/roms/ports/edna`. 
    - Then 'un-tar' the JDK inside this folder, e.g. `tar xzf /path/to/jdk-8u461-linux-aarch64.tar.gz` (filename may differ). 
    - Finally, rename the folder of the expanded tar: `mv jdk1.8.0_* jdk1.8.0` 
    - **Tip**: If you are using RetroPie on Debian 11 or later you may now run `sudo ~/RetroPie-Setup/retropie_packages.sh edna depends`. It will install the tool `innoextract` whcih will be used later.
3. Deploy the game files. 
    - Get your GOG "Edna and Harvey" setup files (usually a `*.exe` and a larger `*.bin`) and copy it to your RetroPie or when on RetroPie Buster (Debian 10) then skip the innoextract step. 
    - Debian 11 and up: Run innoextract v1.8 (or later) with this command: `innoextract setup_edna__harvey_the_breakout_*.exe -I edna_original` 
    - Debian 10: Install the game on Windows as usual or use `innoextract` on a recent Linux distro. 
    - In both cases search for a folder `edna_original/` (and transfer that folder-tree to the Raspberry Pi from the Windows installation). 
    - Change into folder `edna_original` folder on the Pi and execute: `rsync 
    -avr data lib script Edna.jar ednaPreferen* *.txt ~/RetroPie/roms/ports/edna` 
    - Be patient, the copy may take a while. Remove the source `edna_original` folder.
4. That's it. Now run this scriptmodule.
5. Enjoy the game!

**Additional Notes**

- Savegames are at: `~/AppData/Local/Daedalic Entertainment/Edna/savegame`
- Change language (en/de) in file `~/RetroPie/roms/ports/edna/ednaPreferen.ces`

**Execute Scriptmodule to Deploy Content**

`sudo ~/RetroPie-Setup/retropie_packages.sh edna`

