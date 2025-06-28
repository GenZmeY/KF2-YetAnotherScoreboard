# Changelog

## v2.2.2 (2024-03-08)
- added a short alias for the mutator: YAS.Mut (YAS.YASMut is still available for use)

## v2.2.1 (2023-10-21)
- fixed broken server password icon

## v2.2.0 (2023-06-28)
- fixed a bug where players were not getting their default rank
- updated BoxPainterLib (included in codebase)
- slightly improved scoreboard rendering speed
- added hardcoded english localization in case localization files are missing
- added more localization files
- added mutator group (Mutator::GroupNames)

## v2.1.2 (2022-12-07)
- fix broken icons

## v2.1.1 (2022-10-23)
- fix frozen damage after rejoin

## v2.1.0 (2022-10-13)
- add damage dealt to scoreboard

## v2.0.1 (2022-09-14)
- fixed using compact mode instead of normal mode in some cases

## v2.0.0 (2022-09-14)
- massive code refactoring
- reworked replication (network code), now it works correctly and efficiently
- panel style changed: health is now displayed on the left and rank on the right of the player's name
- the panel has two types of display: normal and compact (activated if 'MaxPlayers' >= 16)
- completely removed the ability to customize the appearance of the scoreboard (maybe it will be implemented in the future)
- fixed scoreboard size scaling: now the scoreboard is rendered in a 16:9 area inscribed in the screen (looks the same in any aspect ratio)
- bevels size of UI elements is now also scaled
- fixed scaling of the size of fonts and UI elements - now the proportions are preserved at any resolution
- health box color now changes smoothly
- ping color now changes smoothly and is in sync with ping bars
- added server status icons (rank, password)
- added player death icon
- server name is now taken from 'KFOnlineGameSettings'
- added an element at the bottom of the scoreboard that allows you to display various messages
- fixed system for assigning player ranks - now it works correctly

## v1.1.0 (2022-01-24)
- update build system

## v1.0.0 (2021-06-20)
- first version
