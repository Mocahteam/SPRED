# SPRED: SPring EDitor

SPRED is a mod designed for [Spring engine with Prog&Play](https://github.com/Mocahteam/SpringPP). SPRED enables to create missions and export them as new mods compatible with Spring engine.

SPRED is distributed with the game engine at <https://www.irit.fr/ProgAndPlay/download.php?LANG=en>.

## Repository structure

    ./launcher/      => source code of the launcher that enables to export editor dedicated
                        for Spring compatible games
    ./editor/        => source code of the generic editor that enables to build mission and
                        export them as new game
    ./player/        => source code of the player enabling to load and play scenario and missions
                        built with editor
    ./usefullFiles/  => source code shared between the editor and the player
    ./mapConception/ => source code of maps designed for Prog&Play
    ./modConception/ => source code of mods (games) linked with Prog&Play but not designed with SPRED
    ./old_versions/  => contains old source code kept for memory

## How to build SPRED

Simply launch "build_SPREDlauncher.bat", it will package all source codes into "SPRED_Launcher.sdz" file. Then copy paste this file into your Spring directory ("mods" folder), and enjoy...

## SPRED architecture

SPRED launcher includes generic editor that includes player. With SPRED launcher and a game compatible with Spring engine (Kernel Panic for instance) you can export the editor compatible with this game. Then you create your missions and scenario and export them as mods compatible with Spring engine.

    +----------------------------+  +--------------------------------+
    | SPRED launcher             |  | Spring mods (ex: Kernel Panic) |
    |                            |  +---+----------------------------+
    |   +----------------------+ |      |   +-------------------------------+
    |   | Generic SPRED editor +--------+-->| SPRED editor for Kernel Panic |
    |   |   +--------------+   | |          |   +--------------+            |   +------------+
    |   |   | SPRED player |   | |          |   | SPRED player +--------------->| Scenario 1 |
    |   |   +--------------+   | |          |   +--------------+            |   |   +------------+
    |   +----------------------+ |          +-------------------------------+   +---| Scenario 2 |
    +----------------------------+                                                  |   +------------+
                                                                                    +---|     ...    |
                                                                                        +------------+
