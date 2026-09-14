<h1 align="center">
  <img src="docs/img/RetroPie-BSides-logo.png" alt="RetroPie BSides" width="640px">
  <br>
</h1>

<p align="center">
  <a href="#installation-and-usage">Installation</a> •
  <a href="#what-do-i-find-at-the-bsides">What is in the box?</a> •
  <a href="#other-tricks">What else is to discover?</a> •
</p>

---

Welcome to RetroPie BSides an add-on repository to your existing RetroPie installation. This repo contains a few scriptmodules, but it will be expanded over time. In majority it holds my contributions I made in the RetroPie forum. However, if you have an orphaned scriptmodule: Your contribution is welcome.  
The scriptmodules come with extensive documentation or a Mini How-To on how to handle it. You can find it on this website or at the header of each script file.

**Why the Title RetroPie-BSides?**

Sometimes, at the hey-days of vinyl records, you could find gems on the B side of a music album, which may have given you more joy than the hits from the A side. This is also how this repo works: You will need a little time to discover the B side, but chances are you find a gem.

## Installation and Usage

On your RetroPie-Setup:

```bash
cd ~/RetroPie-Setup/ext
git clone --depth 1 https://github.com/Gemba/RetroPie-BSides bsides
cd bsides
git sparse-checkout set --no-cone scriptmodules
```

To update:

```bash
cd ~/RetroPie-Setup/ext/bsides
git pull
```

For usage see subsequent sections:

- [Game Ports](#game-ports)
- [Emulators and Libretro Cores](#emulators-and-libretro-cores)
- [Supplementary Modules](#supplementary-tools)


## What do I find at the BSides?

### Game Ports

The actual games/ROMs are not included for copyright/license reasons. You can find them on the internet and also how to get a license. I have got mine from GOG.com and humblebumble.com.

#### Baba Is You

![Screenshot of 'Baba Is You'](docs/img/Baba%20Is%20You.png)  
Installation: [Mini How-To](docs/Baba_Is_You.md) • Scriptmodule: [Source](scriptmodules/ports/babaisyou.sh)

#### Donut Dodo

![Screenshot of 'Donut Dodo'](docs/img/Donut%20Dodo%20Logo.png) 
Installation: [Mini How-To](docs/Donut_Dodo_64.md) • Scriptmodule: [Source](scriptmodules/ports/donutdodo64.sh)

#### Papers, Please

![Screenshot of 'Papers, Please'](docs/img/Papers,%20Please.png)  
Installation: [Mini How-To](docs/Papers_Please.md) • Scriptmodule: [Source](scriptmodules/ports/papersplease.sh)

#### Head over Heels

![Screenshot of 'Head over Heels'](docs/img/Head%20over%20Heels.png)  
Installation: [Mini How-To](docs/Head_over_Heels.md) • Scriptmodule: [Source](scriptmodules/ports/hoh.sh)

#### Edna Bricht Aus (Edna & Harvey: The Breakout)

![Screenshot of 'Edna & Harvey: The Breakout'](docs/img/Edna%20&%20Harvey:%20The%20Breakout.png)  
Installation: [Mini How-To](docs/Edna_Breakout.md) • Scriptmodule: [Source](scriptmodules/ports/ednabreakout.sh)

### Emulators and libretro-cores

#### Libretro Core of AppleWin emulator (lr-applewin)

![Screenshot of 'lr-applewin'](docs/img/Libretro%20AppleWin.png)  
Installation: [Mini How-To](docs/Libretro_AppleWin.md) • Scriptmodule: [Source](scriptmodules/libretrocores/lr-applewin.sh)

#### Libretro Core of b2 emulator (lr-b2)

![Image for 'Libretro BBC Micro'](docs/img/Libretro%20BBC%20Micro.png)  
Installation: [Mini How-To](docs/Libretro_bbcmicro.md) • Scriptmodule: [Source](scriptmodules/libretrocores/lr-b2.sh)

### Supplementary Tools

#### Enhanced Bash Welcome on Login (rb_bashwelcome)

This is a drop-in replacement, it will de-install the official RetroPie scriptmodule.

![Screenshot of 'Bash Welcome Tweak'](docs/img/Bash%20Welcome.png)  

Installation: [Mini How-To](docs/Bashwelcome.md) • Scriptmodule: [Source](scriptmodules/supplementary/rb_bashwelcome.sh)

#### Installer for Arcade DT (arcadedt)

Just you, the game and your Arcade Joystick. No fuzz, no indirection latency.

![Logo of 'Arcade DT'](docs/img/arcadedt.png)  

Installation: [Mini How-To](docs/ArcadeDT.md) • Scriptmodule: [Source](scriptmodules/supplementary/arcadedt.sh)

## Other Tricks

These are not maintained via scriptmodule as they either do not fit into the one-size-fits approach of a scriptmodule or are one-off scripts. However, they may come in handy.

### Game 'Donut Dodo' Controller Mapping Helper

If you own the game [Donut Dodo](https://zapposh.itch.io/donut-dodo-retropie-edition) for RetroPie (32 bit/armhf) you may notice that the joystick mapping does not work in some cases. 

![Controller Mapping of 'Donut Dodo'](docs/img/Donut%20Dodo%20Config.png)

The script addresses this issue by editing the Donutdodo mapping file outside of the game to remap the buttons (shown in green above) to your RetroPie controller configuration. See the comments and hints in [the gist](https://gist.github.com/Gemba/bb54d2b6fb086ae239c8add50471b001) itself for usage. 

For running Donut Dodo on RetroPie (64 bit/aarch64), see this repo. :)

### To be continued ...

In the meantime you may browse the extensive [RetroPie-Extra](https://github.com/Exarkuniv/RetroPie-Extra/) repo it hosts broad set of scriptmodules. Also the [RetroPie-Share](https://github.com/FollyMaddy/RetroPie-Share/blob/main/README.md) repo has various gems, especially for BBC Micro.

