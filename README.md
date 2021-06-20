# YetAnotherScoreboard

[![Steam Workshop](https://img.shields.io/static/v1?message=workshop&logo=steam&labelColor=gray&color=blue&logoColor=white&label=steam%20)](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)
[![Steam Subscriptions](https://img.shields.io/steam/subscriptions/2521826524)](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)
[![Steam Favorites](https://img.shields.io/steam/favorites/2521826524)](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)
[![Steam Update Date](https://img.shields.io/steam/update-date/2521826524)](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/GenZmeY/KF2-YetAnotherScoreboard)](https://github.com/GenZmeY/KF2-YetAnotherScoreboard/tags)
[![GitHub](https://img.shields.io/github/license/GenZmeY/KF2-YetAnotherScoreboard)](LICENSE)

# Description
Yet another scoreboard...
Based on the scoreboard from [ClassicHUD](https://steamcommunity.com/sharedfiles/filedetails/?id=1963099942) and heavily modified.

# Features
- Doesn't block the view with the mouse when active;
- Correctly displayed in all available resolutions;
- Close to KF2 interface style;
- Displays a large number of players;
- The scoreboard adjusts to the size of the content;
- Customizing the appearance and elements of the scoreboard;
- Dynamically changing colors for some elements (depending on their value);
- Player ranks.

# Usage
[See steam workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=2521826524)

***

**Note:** If you want to build/test/brew/publish a mutator without git-bash and/or scripts, follow [these instructions](https://tripwireinteractive.atlassian.net/wiki/spaces/KF2SW/pages/26247172/KF2+Code+Modding+How-to) instead of what is described here.

# Build
1. Install [Killing Floor 2](https://store.steampowered.com/app/232090/Killing_Floor_2/), Killing Floor 2 - SDK and [git for windows](https://git-scm.com/download/win);
2. Open git-bash in the folder: `C:\Users\<USERNAME>\Documents\My Games\KillingFloor2\KFGame`
3. Clone this repository and go to the source folder:  
`git clone https://github.com/GenZmeY/KF2-YetAnotherScoreboard && cd KF2-YetAnotherScoreboard`
4. Run make.sh script:
`./make.sh --compile`
5. The compiled files will be here:  
`C:\Users\<USERNAME>\Documents\My Games\KillingFloor2\KFGame\Unpublished\BrewedPC\Script\`

# Testing
You can check your build using the `make.sh` script.  
Open git-bash in the source folder and run the script:  
`./make.sh --test`  
On first launch, the script will create `testing.ini` file and launch the game with the settings from it. Edit this file if you need to test the mutator with different parameters.

# Bug reports
If you find a bug, go to the [issue page](https://github.com/GenZmeY/KF2-YetAnotherScoreboard/issues) and check if there is a description of your bug. If not, create a new issue.  
Describe what the bug looks like and how reproduce it.  
Attach screenshots if you think it might help.

If it's a crash issue, be sure to include the `Launch.log` and `Launch_2.log` files. You can find them here:  
`C:\Users\<USERNAME>\Documents\My Games\KillingFloor2\KFGame\Logs\`  
Please note that these files are overwritten every time you start the game/server. Therefore, you must take these files immediately after the game crashes in order not to lose information.

# License
[GNU GPLv3](LICENSE)