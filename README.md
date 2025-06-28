# Yet Another Scoreboard

[![Steam Workshop](https://img.shields.io/static/v1?message=workshop&logo=steam&labelColor=gray&color=blue&logoColor=white&label=steam%20)](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)
[![Steam Downloads](https://img.shields.io/steam/downloads/2521826524)](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)
[![Steam Favorites](https://img.shields.io/steam/favorites/2521826524)](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/GenZmeY/KF2-YetAnotherScoreboard)](CHANGELOG.md)
[![GitHub](https://img.shields.io/github/license/GenZmeY/KF2-YetAnotherScoreboard)](COPYING)

## Description
Yet another scoreboard...  
Based on the scoreboard from [ClassicHUD](https://steamcommunity.com/sharedfiles/filedetails/?id=1963099942) and heavily modified.  

- Not whitelisted  
- Compatible with [SML](https://github.com/GenZmeY/KF2-SafeMutLoader)  

## Whitelist status
This mod is not whitelisted and will de-rank your server. Any XP earned will not be saved.  
To save your server's ranked status use [ranked patch](https://github.com/GenZmeY/KF2-Ranked-Patch) or [SML](https://github.com/GenZmeY/KF2-SafeMutLoader).  

## Usage
See [steam workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)

## Build
**Note:** If you want to build/brew/publish/test a mutator without git-bash and external scripts, follow [these instructions](https://tripwireinteractive.atlassian.net/wiki/spaces/KF2SW/pages/26247172/KF2+Code+Modding+How-to) instead of what is described here.  
1. Install [Killing Floor 2](https://store.steampowered.com/app/232090/Killing_Floor_2/), Killing Floor 2 - SDK and [git for windows](https://git-scm.com/download/win)  
2. open git-bash and go to any folder where you want to store sources:  
`cd <ANY_FOLDER_YOU_WANT>`  
3. Clone this repository and its dependencies:  
`git clone --recurse-submodules https://github.com/GenZmeY/KF2-YetAnotherScoreboard`  
4. Go to the source folder:  
`cd KF2-YetAnotherScoreboard`
5. Compile:  
`./tools/builder -c`  
The compiled files will be here:  
`%USERPROFILE%\Documents\My Games\KillingFloor2\KFGame\Unpublished`
6. (Optional) Brew:  
`./tools/builder -b`  
The brewed files will be here:  
`%USERPROFILE%\Documents\My Games\KillingFloor2\KFGame\Published`
7. (Optional) Upload to your steam workshop:  
`./tools/builder -u`  

## Contributors and Credits
**Developers:**
- [Marco](https://steamcommunity.com/profiles/76561197975509070) - GUI system  
- [ForrestMarkX](https://steamcommunity.com/profiles/76561197997881512) - ClassicHUD  

**Translators:**  
- [cheungfatzong](https://steamcommunity.com/profiles/76561199126205919) - Traditional [CHT] and Simplified [CHN] Chinese  

**Other credits:**  
- The cat on [the cover](PublicationContent/preview.png) is [Meawbin](https://x.com/meawbinneko) (original character by [Cotton Valent](https://x.com/horrormove))  

## Status: Completed
- The mutator works with the current version of the game (v1150) and I have implemented everything I planned.  
- Development has stopped: I no longer have the time or motivation to maintain this mod. No further updates or bug fixes are planned.  

## Mirrors
- https://github.com/GenZmeY/KF2-YetAnotherScoreboard  
- https://codeberg.org/GenZmeY/KF2-YetAnotherScoreboard  

## License
**GPL-3.0-or-later** (Yet Another Scoreboard)  
  
[![license](https://www.gnu.org/graphics/gplv3-with-text-136x68.png)](COPYING)  

**LGPL-3.0-or-later** (BoxPainterLib)

[![license](https://www.gnu.org/graphics/lgplv3-with-text-154x68.png)](COPYING.LESSER)  
