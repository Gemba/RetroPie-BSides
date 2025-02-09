<h1 align="center">
  <img src="docs/img/FIXME_banner.png" alt="alt.rp-setup.*" width="640px">
  <br>
</h1>

<!-- FIXME -->
<p align="center">
  <a href="#how-to-install-skyscraper">Installation</a> •
  <a href="#how-to-use-skyscraper">Quick Usage</a> •
</p>

---

Welcome to alt.rp-setup.bag-of-tricks.\* an add-on repository to your existing RetroPie installation.

FIXME: Weitere 1-2 Sätze über Usage

FIXME: Entscheid für Namen

## Why the Title alt.rp-setup.*?

FIXME

## Installation and Usage

FIXME: TBV
```bash
git clone --depth 1 https://...
cd alt.rp.bag
git sparse-checkout set --no-cone scriptmodules
```

For usage see subsequent sections: 
- [Game Ports](#game-ports)
- [Emulators and Libretro Cores](#emulators-and-libretro-cores)

### Update

```bash
cd RetroPie-Setup/ext/alt.rp.bag
git pull
```


## What do I find in this Bag?

### Game Ports

**NOTE**: The actual games/ROMs are not included for copyright/license reasons. You can find them on the internet and also how to get a license.

#### Baba Is You

![Screenshot of 'Baba Is You'](docs/img/Baba%20Is%20You.png)
Installation: [Mini How-To](docs/Baba_Is_You.md)  
Scriptmodule: [Source](scriptmodules/ports/babaisyou.sh])

#### Papers, Please

![Screenshot of 'Papers, Please'](docs/img/Papers,%20Please.png)
Installation: [Mini How-To](docs/Papers_Please.md)  
Scriptmodule: [Source](scriptmodules/ports/papersplease.sh])

#### Head over Heels

![Screenshot of 'Head over Heels'](docs/img/Head%20over%20Heels.png)
Installation: [Mini How-To](docs/Head_over_Heels.md)
Scriptmodule: [Source](scriptmodules/ports/hoh.sh])


#### Edna Bricht Aus (Edna & Harvey: The Breakout)

![Screenshot of 'Edna & Harvey: The Breakout'](docs/img/Edna%20&%20Harvey:%20The%20Breakout.png)
Installation: [Mini How-To](docs/Edna_Breakout.md)
Scriptmodule: [Source](scriptmodules/ports/ednabreakout.sh])


### Emulators and libretro-cores

**NOTE**: To avoid name collision some packages from this repo contain the `alt.` prefix but they will replace the RetroPie scriptmodule with the same name. E.g. alt.scummvm will replace RetroPie's scummvm.

#### alt.scummvm and alt.lr-scummvm

This is a drop-in replacement, it will de-install the official RetroPie scriptmodules.

#### alt.jzintv (FIXME: Prio C)

This is a drop-in replacement, it will de-install the official RetroPie scriptmodule.

Installation: [Mini How-To](docs/Jzintv.md)  
Scriptmodule: [Source](scriptmodules/emulators/jzintv.sh])

#### yape

Installation: [Mini How-To](docs/Yape.md)  
Scriptmodule: [Source](scriptmodules/emulators/yape.sh])

### Supplementary Tools

**NOTE**: To avoid name collision some packages from this repo contain the `alt.` prefix but they will replace the RetroPie scriptmodule with the same name. E.g. alt.emulationstation will replace emulationsstation.

#### alt.emulationstation

This is a drop-in replacement, it will de-install the official RetroPie scriptmodule.

#### alt.bashwelcome

This is a drop-in replacement, it will de-install the official RetroPie scriptmodule.

Installation: [Mini How-To](docs/Bashwelcome.md)  
Scriptmodule: [Source](scriptmodules/supplementary/bashwelcome.sh])

#### retropie_packages.sh bashcompletion

Installation: [Mini How-To](docs/RP-Bashcompletion.md)  
Scriptmodule: [Source](scriptmodules/supplementary/rp-bashcompletion.sh])

## Other Tricks (FIXME: Prio C)

These are not maintained via scriptmodule, but may come in handy.

### ROGER

### Arcade-dt

### Donutdodo Controller Mapping

### Reset Gamecounter and Lastplayed in Gamelists


