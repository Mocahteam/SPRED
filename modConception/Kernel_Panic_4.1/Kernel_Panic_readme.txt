
====================================================
		Kernel Panic 4.1
====================================================

Kernel Panic is a mod about computers. Bits and bytes wage war in a matrix of DOOM! The only resources are time and space, there is no metal or energy economy in KP. Since all units are free, every factory you have will be spamming units at all times. You can build more factories, but only on datavents. KP makes for a very fast-paced, action-oriented strategy game, with an unique graphical style.

====================================================
URL http://spring.clan-sy.com/wiki/Kernel_Panic
===================---------------------------------
Installation Notes
-------------------


  * From installer (Kernel_Panic_4.1_Including_Spring_0.82.3_InstallerXX.exe) :


      > If you never heard of Spring:
        + Just click next, leave all at default, and you'll be set.
        + Then use the shorcuts from start menu or desktop to play.


      > If you already know about Spring:

        Kernel Panic 4.1 requires Spring 0.82.3
        Actually, older Spring works as well, but for online play you need lastest Spring version.

        + If you have an old version of Spring around:
          - Either uninstall it
          - Either make sure to tick the "engine" install so as to overwrite it

        + If you have an up-to-date version of Spring
          - Sadly having several Spring installs side by side may cause issues
          - So you have to install KP in the same folder as your current Spring 0.82.3
            x No user file should be lost or modified
            x But feel free to untick the "engine" install so as to be more safe

        + If you have a version of Spring over 0.82.3:
          - The installer will detect that your Spring version is one it doesn't know,
            and then use a default of unticked "Spring engine" install.
            This way it will only install the mod specific files, leaving the engine as it is.
          - Should KP have nonetheless installed an oudated version of the Spring engine:
            x Download and reinstall newest Spring into the same folder, to overwrite the engine



  * From zip (Kernel_Panic_41.zip) :


      > Kernel Panic requires the Spring engine:

        + If you don't have Spring, or have a version lower than 0.78.2
          - Go to http://spring.clan-sy.com
          - Go to the download section
          - If you are running Windows:
            x Download spring_0.82.3.exe (or higher)
            x It's an installer, you have to run it to install Spring
            x In the list of things to install, tick TASClient, as it's a nicer client than default SpringLobby


        + Once you have Spring 0.82.3

          - Unzip Kernel_Panic_41.zip into your Spring folder
          - Do not create the folder named as the file
          - Unzip zipped folders as folders
          - I mean, contents of /maps/ goes into /maps/, contents of /mods/ goes into /mods/
          - Inside the zip, there may be two other zip, containing Shard & Baczek's KP AI:
            x Shard and Baczek's KP AI are made of several files and folder trees (as opposed to the mod integrated Lua AI)
            x Shard and Baczek's KP AI are for Windows O.S. only
            x Shard and Baczek's KP AI play harder than the Lua AI, but are less stable, and ignore most special abilities
            x Unziping Shard and Baczek's KP AI is recommended, but not compulsory:
              ~ The single player launchers will not use Shard and will only use Baczek's AI if it is present.
              ~ The Lua AI gives nice matches already.
          - In the Spring settings:
            x Enable LuaUI (provide a more efficient and prettier User Interface)
            x Enable ground decals
            x Turn up sound's master volume



  * From sd7 (Kernel_Panic_4.1.sd7) :

      > That file goes into the /mods/ subfolder of your Spring folder


      > Kernel Panic is best played on custom Kernel Panic maps
        (That go into the /maps/ subfolder of your Spring folder)
        Get the following maps:
          x Marble_Madness_Map.sd7  ( 118 KB)
          x Direct_Memory_Access_0.5c_beta.sd7  ( 64 KB)
          x Direct_Memory_Access_0.5e_beta.sd7  ( 64 KB)
          x Major_Madness3.0.sd7  ( 285 KB)
          x Speed_Balls_16_Way.sdz  ( 3729 KB)
          x DigitalDivide_PT2.sd7  ( 293 KB)
          x Spooler_Buffer_0.5_beta.sd7  ( 34 KB)
          x Data_Cache_L1.sd7  ( 43 KB)
          x Palladium_0.5_(beta).sd7  ( 179 KB)
          x Central_Hub.sd7  ( 229 KB)
          x Corrupted_Core.sd7  ( 181 KB)
          x Dual_Core.sd7  ( 245 KB)
          x Quad_Core.sd7  ( 356 KB)
        If you don't have those maps, I suggest getting Kernel_Panic_41.zip wich contains maps and mods, or to check:
          x http://spring.clan-sy.com/wiki/Kernel_Panic
          x http://www.springfiles.com
          x http://spring.jobjol.nl
          x http://caspring.org/wiki/sd
          x http://www.springinfo.info/ (also community portal)
          x AF: http://www.darkstars.co.uk/downloads/
          x BLC: http://spring-portal.com
          x FA: http://evolutionrts.info/maps/
          x M_A_D: http://www.tasdownloads.com/
          x iamacup: http://www.unknown-files.net/



  * To play:


      > Use the custom maps!
        Kernel Panic is meant to be played on maps specially made for it, both for the graphics and the datavent placement.
        It could technically be played on any map, thanks to a gadget planting datavent on every metal spot when datavent count is too low.
        But both graphical integrity and gameplay will suffer.


      > Use "Fixed" or "Random" start position!
        Kernel Panic is meant to be played with "Start position" set to either "Fixed" or "Random" but not "Choose in game".
        Exception being the Springie based autohosts: They do not support "Fixed" nor Random" so have to use "Choose in game".
        This is even more important when using bot, which are unable to pick a start point and click ready.


      > To play single player, either:

        + Use the appropriate shorcut: / Start Menu / Kernel Panic / Kernel Panic - Single Player

        + Run Spring.exe directly:
          On the first menu, the one with a tropical beach background:
            - Pick the script empty script
            - Pick the mod Kernel Panic
            - Pick any map
          A special Lua UI widget should then detect Spring has been direct-launched
          and propose you a menu (in greenish tone).

        + The same menu can be reached any time ingame by pressing the Esc key (excepts in multiplayer)

        + Go to where Spring is installed and run Kernel_Panic_4.1_Launcher.exe
          For Kernel Panic version 3.0 to 3.6 this was the recommended weapon
          For Kernel Panic version 3.7 and over it is deprecated, use the Lua menu instead.

        + Run any "multiplayer" lobby:
          Spring multiplayer clients can also be used for single player.
          There will be lots of confusing windows, and they'll be more complex
          But as a counterpart, you will be able to cutomise the game much more
          To add bots:
            - Most regular *.dll AI will fail
            - Make sure to only use either:
              x LuaAI: Kernel Panic AI (Always working, use more special abilities)
              x LuaAI: Fair KPAI (Always working, use more special abilities, limited growth)
              x Shard (Less available, can crash, ignore most special abilities, but plays harder!)
              x Baczek's KP AI (Less available, can crash, ignore most special abilities, but plays harder!)

        + Run a single player battleroom:
            - I heard those exists!
            - Last time I tried one, it was:
                very cumbersome,
                out of date,
                and unadapted to KP

        + Manual editing of a start script:
            - All the above methods* will create a file named either script.txt or Kernel_Panic_script.txt
            - Open it in Notepad
            - Edit it to your fancy, save as another name
            - Drag'n'drop it over Spring.exe
            - Or, save in /Missions/ and select it within the mission menu of Kernel Panic internal menu.
            (* Well, playing a mission doesn't save a startscript to disk. But merely restarting that mission will.)


      > To play multiplayer player:

        + Use the appropriate shorcut: / Start Menu / Kernel Panic / Kernel Panic - Online Multi Player

        + You must use a multiplayer lobby
          The recommended way is to use one of the "Kernel Panic - Multiplayer" shortcut created by installer.
          But you can also use whichever multiplayer lobby or client you have or prefer:
            - TASClient.exe
            - SpringLobby.exe
            - QTLobby
            - AFLobby
            - ....
          Note: The installer of Kernel Panic 3.1 to 3.6 used KPSClient which was a hacked up TASClient.
                From Kernel Panic 3.6 Installer 15 instead I use the regular TASClient,
                customised via the commandline option -inifile.


===========-----------------------------------------
Game, Mod, and Game modes:
--------------------------

Installing Kernel Panic will add one entry to the list of available mods: Kernel Panic 4.1, which is the complete version, with all the units and all the special abilities. If you wish to play the old "Kernel Panic Evilless": tick the two corresponding modoptions in the "Mod options" tab of the battleroom.

There is currently about seven "mod options":

The "Metal To Geo" option is meant to allow Kernel Panic to be played on maps without geovents:
- Auto: Count the geovents, and if there are not enough, also turns metal spots into geovents.
- Metal: Remove geovents, and then turn metal spots into geovents.
- Geo: Leave the map as it is.
- Both: Keep geovents and turn metal spots into additional geovents.

The "ONS" option is meant to make the game friendlier to newbies, especially in wide level gap differences teams, by surrounding all homebases and minifacs that are not on the territory limits by shields that render them invulnerable:
- ONS: Disabled : Normal game, without any of those spherical shields.
- ONS: Homebase only : Homebase shielded as long as one other building is up.
- ONS: Weak : Every extremities of the allied network is unshielded, non extremities are shielded.
- ONS: Strong : Only the furthest extremities of the allied network are unshielded, non extremities or closer extremities are shielded.
- ONS: Ultra : Only the buildings near enemies buildings are unshielded, everything else is shielded.

The "Save Our Mem" option is a special gamemode where:
- Each datavent covered give you a "sector" of memory
- Every lost unit leaves a "Memory leak", displayed as a team colored circle
- Memory leaks remain until free'ed by the touch of a friendly unit
- Everys second, every memory leak decrease the amount of memory you have
- When you are out of memory, all your mobiles units are destroyed, and your building heavily damaged.
The input number of the mod option the sector size (amount of memory per sector). Or 0 for disabled. Negative mean insta death when out of mem.

The "Color Wars" option is a special gamemode where:
- When a timer elapse, all units turn into blocks.
- Those blocks spread until the whole map is covered.
- The player with most blocks is declared winner.
The input number is the timer, in minutes. Or 0 for disabled.

The "Heroes of Mainframe / Defense of the ENIACs" group is a special gamemode where:
- Instead of a RTS, the game becomes a shoot'n'run
- You control one single unit, moving with the keyboard (arrow keys), and aiming with the mouse (left button to shoot)
- All other units are handled by an AI.
- The one hero unit you have has superior armor and firepower, you must use it to help tip the tide of war in your favor.
- Since only the homebase can rebuild your hero, I'd advise to use the homebase ONS mod option, or at least the "Kill homebase" end condition.
- Each team can only have as many simultaneous "heroes" as there are human players in that team. So AI-Bot teams do not have heroes, and when several human players are team sharing, each will get his own hero.

This group is made of several option. Most of them are here to allow you tweaking the strength of heroes:
- Stats such as health or damage are not absolute values, but the factor by which is multiplied the stat of the unit the hero derives from.
- The camera zoom is tied to max weapon range.
- Regeneration rate is constant, no matter what you do.
- Keep in mind that "Impulse Factor" (how strongly units which are not instakilled get blown away) gets multiplied by damage, so if you ramp up damage, lower the impulse accordingly.
- When "Hug Ground" is off, weapons explode on impact. Pro: You can hit the ground next to units, and still get them by splash damage. Cons: If you aim in the right direction, but too far or too short, you won't hit units in your line of fire.
- When "Hug Ground" is on, weapons keep on traveling until they meet an enemy. Pro: You can aim in a general direction, and still hit what's in your line of fire. Cons: Skimming shots do no damage.
(The Packet weapon is an instahit laser, and as such, ignore "Hug Ground")

Hero Right Click:
- This setting allows or disallow controlling the rest of the team units while in hero mode.
- The default widget can then use the rigth mouse button to issue contextual actions.
- Any of the custom player custom widget is also free to order units.
- The AI still keeps on issuing orders, which might conflict with yours, so don't be surprise units don't always obey you.

Pre-placed Minifacs:
This option is listed there because it's most useful in heroes game mode, however you can also use it independently.
Contrary to what name says, it also places specials (one per team, if datavent count per team is at least 4).

The "Remove special buildings and abilities" option, which:
- Removes SIGTERM, Obelisk, Firewall, ...
- Removes NX flag, MineLauncher, Exploit, Dispatch from Connection, ...

The "Force all factions to system", which:
- Turn any homebase (kernel, hole, carrier, ..) into system's homebase (kernel)


==========-----------------------------------------
Handicaps:
----------
When you become good enough that newbie online opponents aren't challenging anymore, consider setting yourself an handicap.

* Disabled ONS handicap:
  - Before the game start, set ONS to ultra in mod options
  - After the game has started, type /ons 0
  - Your ONS shield system will be disabled, while everybody else keep it

* Individual Save Our Mem handicap:
  - Don't set "Save Our Mem" in mod option
  - After the game has started, type something such as /sos 5000
  - You will be the only one having to contain "memory leaks"


================------------------------------------
Ingame commands:
----------------

For advanced users. Skip to Units Description if you're not. Use enter to bring down the chat console, type the command including slash prefix, enter again to send it. Generic Spring commands will not be covered here, only Kernel Panic specific ones. Normally, you'd need to prefix them by luarules, for exemple /luarules cw +10 however KP includes a command translating widget allowing you to simply type /cw +10 for instance.


/colorwars or /cw
  * Purpose:
    - Edit the ColorWars timer.
  * Conditions:
    - Works even if ColorWars was not set in battleroom.
    - Always requires cheat.
  * Arguments:
    - Argument are one, two, or three numbers, prefixed, or not, by + or -.
    - If one number, then it's a time in minute.
    - If two numbers, then it's a time in minute, seconds.
    - If three numbers, then it's a time in hours, minute, seconds.
    - Separators can be space, tab, colon, comma, apostrophe, double quote, slash or antislash.
    - If prefixed by +, the input time is added to current timer value.
    - If prefixed by -, the input time is substracted to current timer value.
    - If neither + nor -, the input time replace current timer value.
    - Setting time to 0, or substracting more than current value, is how to set ColorWars to disabled.
  * Exemples:
    - /luarules cw 2.5      Set to two minutes and a half
    - /colorwars -0'30      Substract thirty seconds
    - /colorwar + 3 45      Add three minutes forty five seconds
    - /cw 1:15:00           Set to one hour and a quarter
    - /cw -+- 5,3           Add five minutes and a half


/ons
  * Purpose:
    - Toggle (or refresh) ONS
    - Cannot change the ONS type, simply toggle it on and off for specific teams.
  * Conditions:
    - Only work if an ONS mode was already picked in battleroom, before game.
    - Does not require cheat if disabling and even re-enabling your own ONS in a game where your team had it set at start.
    - Requires cheat to toggle other teams ONS, or to enable it in missions where you start with ONS disabled.
  * Arguments:
    - If zero argument: force a refresh of ONS: recalculate the shield states and link network of everybody.
    - If one argument: 0 to disable your own ONS, 1 to re-enable your own ONS.
    - If two arguments: First argument is a TeamID, second argument is 0 to disable that team ONS, 1 to enable it.
  * Exemples:
    - /ons                  Refresh ONS
    - /ons 0                Disable your own ONS
    - /ons 1                Re-enable your own ONS
    - /ons 3 0              Disable ONS of team 3
    - /luarules ons 5 1     Re-enable ONS of team 5


/sos or /som
  * Purpose:
    - Edit "Save our Mem" sector size.
    - Lost memory remains lost.
    - Unless you set a sector size of 0 which is the special value to disable "Save Our Mem"
  * Conditions:
    - Work even if "Save our Mem" was not used when game started.
    - Does not require cheat if setting your own sector size to something lower than it was or if you had not SoS.
    - Require cheat to change other team sector size, or to increase your own sector size, or to set it to 0.
  * Arguments:
    - If one argument: Value to set your own sector size to.
    - If two numeric arguments: First a team ID, then a sector size: Change the sector of another team.
    - If * then a number: Change the sector size of every team.
    - If the number is negative, then team(s) SoS mode get set to instadeath
    - If the number is positive, then team(s) SoS mode stay instadeath if it was already
  * Exemples:
    - /luarules sos 4096        set your sector size to 4096
    - /sos -2048                set your sector size to 2048, with instadeath
    - /som * 8192               set everybody sector size to 8192
    - /sos 0 3072               set team 0 sector size to 3072
    - /som 3 0                  disable save our mem for team 3
    - But not /luarules som 0   as /som is redirected to /luarules sos but som is not a registered luarules command


/dump
  * Purpose:
    - Can be used to create missions, or as a pseudo-savegame.
    - Save the game state into a file.
    - That file is actually a startscript.
    - Passing that file as Spring.exe argument restore the game to more or less the state it was.
    - Placing that file into a "/Missions/" subfolder make it listed and launchable by KP integrated launcher.
   * Conditions:
    - Dump in "/Missions/" subfolder if and only if present.
    - Require cheat in multiplayer games.
    - Does save everything and is not 100% reliable: provided as an experimental work-in-progress proof of concept demonstration.
  * Arguments:
    - Zero argument: save state as "Kernel_Panic_Dump.txt"
    - One argument: Filename, with ".txt" getting appended to it unless already present.
    - Two arguments: First argument same, second one is abbreviation level, 0, 1 or 2. Untested, so please don't use yet.
    - Three arguments: First two same, third one is value of snapping grid, as a number. Untested, so please don't use yet.
  * Exemples:
    - /dump
    - /dump MyMission
    - But don't try /dump Mission 01.ota


/kpai
  * Purpose:
    - Getting spammed with KPAI debug messages.
  * Conditions:
    - Having one "Kernel Panic AI" or "Fair KPAI" in the game.
  * Arguments:
    - Zero argument: toggle.
    - One argument: 1 to enable, 0 to disable.
  * Exemples:
    - /kpai                  Toggle both "Kernel Panic AI" and "Fair KPAI" debug info
    - /kpai 0                Switch off both "Kernel Panic AI" and "Fair KPAI" debug info
    - /kpai 5                Switch on both "Kernel Panic AI" and "Fair KPAI" debug info
    - /luarules fairkpai 0   Switch off only "Fair KPAI" debug info, not "Kernel Panic AI"'s
    - /luarules kpai 1       Switch on only "Kernel Panic AI" debug info, not "Fair KPAI"'s
    - But not /fairkpai      It's not redirected to /luarules


==================----------------------------------
Units Description:
==========------------------------------------------
CPU units:
----------
Kernel: You start with one of these. It can build all mobile units in the game. Has rapid auto-heal and lots of health.

Socket: The socket is a factory which can only be built on a datavent. It can solely build bits, and slower than the kernel can. It autoheals, and has a decent amount of health.

Terminal: This is a new structure that gets placed on datavents. It can dispatch a nuclear bomber once every 120 seconds that will deal about 16000 damage to a large target area, i.e. it destroys everything except factories. It does much less damage to the kernel and hole. The bomber can strike any position on the map, there is no defense.

Assembler: The assembler is a construction unit. It can build sockets, but it cannot assist-build. Slow, little health. Equipped with a radar to detect mines and other cloacked units.

Bit: Your basic attacking unit. Cheap, fast, small, not very much health. Is armed with a SPARCling laser. Can be built by a kernel or a socket.

Byte: A large, strong, and slow attacking unit. Can holds it's own against many bits, as it has lots of health and a powerful gun. More armored when closed. Can plow through bad blocks. In division zero, the byte has an alternate firing mode, the mine launcher, that throw 5 mines at the cost of 6000hp.

Pointer: An artillery unit. Its normal shot is not so useful against moving units, but can kill kernels and sockets pretty quickly. Is slow and has little health, so it needs protection. In division zero, the pointer has an alternate firing mode, the NX Flag, which set a wide area ablaze for a minute.

=============---------------------------------------
Hacker units:
-------------
Security Hole: The Hacker kernel equivalent.

Window: The Hacker socket equivalent.

Obelisk: This building is a stationary artillery weapon, it can fire an infection shot every 40 seconds (the obelisk has a pink fire on top when it's ready to shoot) that will cover a large area in poison. The poison does a bit of damage (about 1000) and turns any enemy that dies inside the cloud into a Virus. The weapon's range is fairly limited. Best used against stationnary herds of Bits/Bugs.

Virus: A crappy little swarm unit. It cannot be built but is produced when killing enemy units with certain weapons. Namely, the Virus, the Worm, and the Obelisk.

Bug: The Hacker spam unit. The Bug is weaker than the Bit but can sense movement outside of its LOS. It has a stronger weapon and more range but cannot shoot at things behind it or through friendly units and won't take much damage before dying. The mine ability of the old bug has been removed. Instead it can now morph into the Exploit with the deploy button, or the bombard button.

Exploit: This is the new name for the bug cannon. It's a building the Bug morphs into with the deploy or bombard command. The Exploit is a stationary artillery emplacement that does more damage the further the target is away. Even more frail than the Bug, so don't let any foe come near.

Denial of Service: Not an artillery, but close: fire a beam that stun units. For bigger targets it'll take longer to stun them so perform a DDoS (use multiple) to stun them fast. Once the DoS stops firing the target will quickly unfreeze. It moves faster than the pointer but causes a particle trail that can be seen from far away.

Worm: The worm is a sneaky assassin, travelling cloacked, then surfacing only to kill many bits at once with its large area of effect weapon, which turn any slain units into virus. The worm large splash damage will damage your own units. However, it does practicaly no damage against other worms or virus. When cloacked, the worm does not automatically attack, you have to give attack orders manually. If you'd rather have your worms auto-attack even when cloacked, set autohold to off. The autohold setting of new worms is inherited from the Security Hole.

Trojan: This unit is your constructor as well as radar platform (needed for detecting mines and cloaked units), just like the assembler. It builds all the same stuff as the assembler, except it has the window instead of the socket and the obelisk instead of the terminal.

========--------------------------------------------
Network:
--------
The network faction is built around mobility, its small factories (Ports) don't produce units openly but instead move them into a cache (the Buffer). Packets in the Buffer can be materialized at any teleporter unit (currently that means the Port and the Connection), it's also possible to move the Packets back into the Buffer by making them enter a teleport.

Carrier: The base building, like a Kernel or Security Hole.

Port: The production building. It puts Packets into the Buffer, to materialize them select the Dispatch command. Dispatch will send 12 Packets if available, you can hold ALT when giving the order to make the Port dispatch until the Buffer is empty.

Packet: The basic light spam unit, it's weaker in combat than both competitors but much faster.

Connection: Mostly a mobile teleporter (i.e. can dispatch Packets and let them enter like a Port). The Connection has decent armor and an arc beam that can do a lot of damage to single targets and has good range. It can defeat most large units one on one but engaging Bytes will probably result in pointer fire which the Connection cannot withstand and the arc beam is not optimal for engaging swarms.

Flow: An air unit. The Flow moves fairly slowly but can of course cross any terrain. It's equipped to attack light targets (spam units and fire support) but it's highly vulnerable to return fire. If you want to use them in open combat give them a meatshield and hope the enemy doesn't field long range units, Pointers, DoSes and Connections make short work of Flows if they hit.

Gateway: The constructor. It is lightly armed to help against enemy raids.

Firewall: This building can cover units (affects friendly units in a certain radius around the target location) in a protective shield for 20 seconds. The shield halves all damage the unit receives and throws the other half back at the attacker.

=======---------------------------
Touhou:
-------
The touhou faction was added for lulz, the characters are copyrighted by ZUN.

Magic Circle: The base.

Small Circle: The small factory.

Fairy: The spam unit. Fires a three way shot, weak against single targets but good in mass combat.

Reimu Hakurei: Anti-swarm, fires a wide wave of projectiles.

Marisa Kirisame: Anti-armor, fires a single shot with high damage.

Alice Margatroid: Handles construction, unarmed.

===============-------------------------------------
All side units:
---------------
Bad Block: A tiny wall that block small units movement. Do not block any shot however. Easily removed by the Debug or simply crushing them with a Byte.

Logic Bomb: A mine that can be built by the Assembler/Trojan. It takes out Bits in a single blow, has a decent damage radius, and doesn't chain explode. Use with care, as the blast hurts your own units too. Limited to 64.

Debug: An easy way to clear an area of all mines and walls, this is a one shot weapon built by the Assembler/Trojan.


----------------------------------------------------

==========------------------------------------------
Changelog:
----------

KP 4.1
- Some tips are now voiced
- Missions now have briefings
- Compatible with 0.82.3

RPS 0.7
- Hands now take 60s to grow
- You now lose the unit that triggered the hand creation
- RPS damage modifier increased
- Shots aren't shoot-through friendlies anymore
- New shot graphics for rock, paper and scissors

RPS 0.6
- Initial release of Rock, Paper, Scissors

KP 4.0
- Less bugs with /luarules reload
- Changed DoS no chase category and increase Flow metal cost to increase DoS efficiency against Flow
- Fixed a bug in HOMF
- Upgraded Spring to 0.81.2.1

KP 3.9
- Attract mode: Automatically restart a new AI-only game whenever an AI-only game end.
- Lua AI now blast features.
- Map selection menu in the ingame skirmish generator now shows minimap
- Hero player names now clamped to screen edge when the unit out of sceen
- Heroes of Mainframe keys now configurable with bind <keyname> hero_<north|south|west|east>
- Fixed Heroes of Mainframe bug where player who left still had an assigned hero
- Fixed Heroes of Mainframe bug where heroes were controlled by a wrong player
- Fixed Color Wars bug with out of maps units
- Less error spam when gadgets attempt to create units with maxunits reached
- Fix for old bug getting stuck in factories
- Inverted Network build anim
- Added FireStorm maps
- Workaround to handle very large startscript
- Better save/load/mission system
- Upgraded Spring to 0.81.2

KP 3.8
- The preplacing gadget doesn't spawn specials when they are disabled
- Now respawning heroes in turn (oldest one first)
- Fixed bug where team would explode at start
- Fixed bug where spectators were given heroes
- Now show the player names under heroes
- Hero units renamed Mega
- Removed erroneous hole entry in trojan build menu

KP 3.7
- Upgraded Spring to 0.80.5.2
- External C++ launcher now considered deprecated, running Spring.exe with a dummy script to trigger ingame Lua menu now considered favored way.
- Autohold off by default for AI teams, should help NTai a bit.
- Tiny change in ONS beam drawing code, resulting in huge performance gain.
- "Regenerative AI" optimisation fixing the lag that was function of (dead units)x(live units)
- "Regenerative AI" now sort units to regenerate by health, so homebase do first heavies, then cons, then arty, and lastly spam
- "Regenerative AI" fix for when it tries to rebuild where there was no datavent or to dispatch with empty buffer, that would previously result in neverending "limbo" console spam
- KPAI_Fair.lua now considered more up-to-date than KPAI.lua (that means future Lua AI development should be based on KPAI_Fair.lua not that it plays better than KPAI.lua)
- Fixed the hack making homebase face center
- Fix to the fix to gl.Text y offset, previous one was breaking down noResBar.lua and sos.lua on test build version strings.
- New missions, "Bug Squashing" and "Charge of the Hero"
- New in skirmish generator, the purple Heroic button.
- Special mission-only AIs now done via custom team option "aioverride" instead of using LuaAI names not referenced in LuaAI.lua
- New option to start game with preplaced minifacs and specials
- New game mode: Defense of the ENIAC / Heroes of Mainframe (See elsewhere for details)
- New button in single player menu, Save, does the same as typing the command /dump SaveGame but should be more user friendly
- New button in single player menu, Restart, which recreate a startscript corresponding to what was the current game
- Single player menu is now displayed: when is game over and when pressing esc in addition to when running Spring.exe. Never shown in multiplayer though.
- /Missions/ folder now automatically created if not existing.
- Better syntax in Spring.Restart that should now work on more OS and computers

KP 3.6 Installer 15
- Upgraded Spring to 0.80.5.1.
- Still using 0.80.4.2 for Single Player
- Added back Baczek's KP AI 1.2
- Added back NTai XE10.1b
- Now using TASClient -inifile instead of a hacked up KPSClient.exe
- Note: 0.80.5.1 cannot use LuaAI: Desync in multiplayer, crash when a LuaAI dies.
- Note: 0.80.4.2 cannot use C++ AI: Errors due to incompatibility between versions.

KP 3.6
- Upgraded Spring to 0.80.2
- Reverted gl.Text y offset via override in \LuaUI\Widgets\noResBar.lua and \LuaRules\Gadgets\sos.lua
- Added MidKnight's tooltip background
- Added experimental support of missions through enhanced start scripts storing features, units and orders
- Added new command /dump to make such a start script out of current game state
- Added new command /sos to set SoS sector size ingame
- Added new command /ons to toggle ONS shields ingame
- Added new command /cw to edit Color Wars timer ingame
- Better skirmish generator, both internal and external
- The exploit is now considered as spam (this oversight mostly impacted Fair KPAI and SoS)
- Added new unexposed Lua AI called "Regenerative AI" which simply rebuild lost units (and reassign their queue)
- SoS can be set for specific teams via un-exposed team mod option sos or som
- ONS can be disabled for specific teams via un-exposed team mod option noons
- ONS now handle assymetrical alliance, and ONS beam fades between colors
- Added a cache to GetUnitONSInfo/GetONSInfo
- Added cyan automatic tip dispenser
- Added to the O.N.S. help widget a purple infobox showing Team ONS State
- Added a widget to remove the need to add "luarules" to some console command destined to gadgets. For ex, /cw 5 instead of /luarules cw 5.

KP 3.5 Installer 10
- Upgraded Spring to 0.79.1.2

KP 3.5
- Upgraded Spring to 0.79.1.1
- Rewrote the bos/cob set ALPHA_THRESHOLD as a gadget
- Color Wars now both prettier and faster
- Added tooltips for SoS and C.W.
- Fixed bug that set master volume to 1/100
- Now allies can save your soul/mem too!

KP 3.4
- Added "Fair KPAI", an easy opponent matching its strength to yours.
- Running out of mem doesn't instakill you, just kill every mobile unit and set building health to near death.
- Save our Soul renamed to Save our Mem
- SoS bar now divided into sectors, corresponding to the buildings you have.
- Color Wars now lags differently, and ends the game in a more proper way.
- ONS beam wide again. It's finally drawn how I wanted it to be.
- Fixed bug in firewall graphical code not reseting TexGen properly
- Bad Blocks disallowed in both single player launchers

KP 3.3 Installer 07
- Included Baczek's KP AI 1.2
- Updated Kernel Panic Launcher
- Updated KPSClient
- Updated Spring engine from 0.79.0.2 to 0.79.1.0

KP 3.3
- New game mode: Save Our Souls
- New game mode: Color Wars
- Better direct launch menu
- Answering "Yes" to the setting question doesn't exit multiplayer games anymore
- Logic Bombs limited to 64, mine launcher obeys this
- Buffer size now limited by unitlimit
- Rounder ONS beams
- Conforming to 0.79 scar transparency
- Conforming to 0.79 startscript syntax (AI sections)
- Conforming to 0.79 gl.GetTextWidth (as well as 0.78)
- Conforming to 0.78+ color leaking between gl.Text

KP 3.2 Installer 04
- Added map Data Cache L1
- Added map Palladium 0.5
- Tiny fix in launcher
- Fixed advplayerlist widget /take command
- Removed unit_immobile_buider.lua
- Added redo team colors widget
- Added springlobby.exe
- Changed KPSClient splashscreen

KP 3.2 Installer 03
- Changed default install folder
- If no settings, then default ScrollWheelSpeed to negative
- Launcher position set by O.S. instead of hard fixed

KP 3.2 Installer 02
- Removed some buttons in the lobby.
- Now write a springsettings.cfg if there is none.
- Added two sentences in the readme.

KP 3.2
- New tooltip!
- New icons!
- The terminal and firewall are now listed in the buildbar, with their charge.
- BuildBar widget more stable.
- Fixed the bug with NX firing at the wrong place
- All C.E.G. now works in water
- When Spring.exe is ran directly, shows a menu
- Added a remainder to enable LuaUI
- Added widget "ONS Help"
- Marisa given a charge-up incant anim, and her shot a trail, must be immobile to charge and fire
- The rare AI bug is now fixed, plus a failsafe has been added so the AI can recover from a bad order.
- Fixed logic_bomb not removing themselves when sole remaining units

KP 3.1
- Better LuaAI. Now handles all three factions, with all three specials, and ONS
- ONS mode overhaul
- Most of the sudden flood of lua errors in mid-game should be fixed
- Bugs can't turn into exploit too soon after spawn, to prevent them from blocking windows
- New Widget, Geos Highlight
- Pick-Up and Unload icons recolored
- Game Options and Mod Options streamlined
- Launcher-made start scripts easier to parse by lobbies
- The hole now has an "autohold" setting, and the LUA gadget has been edited so that it passes it down to the produced worms.
- Touhou re-added as Network secret faction
- Touhou nerfed by halving fairy health
- Minor Touhou graphical fixes
- Lots and lots of other tiny fixes everywhere

KP 3.0
- LuaAI now works with both System and Hacker
- Added a tiny frontend to easily start single player games

KP.net NRC10
- Removed Touhou
- Increased Worm (2500->3200) and Connection (2500->4500) damage per shot
- Made connection beam stay on target even if the unit is turning.
- Removed logic bomb unit limit.
- Enabled the arc effects for 77a1.
- Removed easteregg since it broke stuff in 77a1.

KP T WIP2
-Increased Reimu build time (960 -> 1500)
-Increased Marisa build time (960 -> 1600), damage per shot (2500 -> 4500), decreased HP (3000 -> 1800), AOE (48 -> 16) and rate of fire (1/3 -> 1/6)
-Increased Fairy damage per shot (30 -> 40)

KP T WIP1
-Added Touhou faction

KP.net NRC9
- Reduced Flow speed of movement (2.4 -> 1) but added a bonus for every geo its owner holds (+1). This should prevent early Flows from being that powerful on MM without making them too slow to use on larger maps.

KP.net NRC8
- Made the AI get listed as a LuaAI for easier use.

KP.net NRC7
- Changed connection to use a beamlaser weapon instead of melee. The results are that connections will no longer throw some units into the air and have proper inaccuracy vs cloaked targets
- Added a 6 second delay for packets after dispatching in which they cannot enter a teleport
- Removed pointer damage reduction vs Flow
- Changed connection and packet hitspheres so packets no longer block the line of fire from DoSes to connections.

KP.net NRC6
- Increased Packet damage per shot (90->130)
- Removed bug seismic detection (it was useful back when the hacker needed bugbombs to survive the early game but now it's unnecessary)
- Added 20% bonus to the Kernel (and equivalent) build speed for every geo their owner controls

KP.net NRC5
- Matched internal names of network units to the visible names (internal only)
- Changed connection weapon to not use burst, it will fire only one shot now. This prevents target switching and making stuff go airborne. Upped the connection's mass since it no longer needs to be the lightest unit around.
- Connection damage per attack reduced (3000->2500), rate of fire decreased (1/3 -> 1/4)
- Worm damage vs single targets increased (1000 -> 2500), area of effect for splash damage increased (160 -> 210)
- Increased Packet HP (400 -> 500)
- Increased dispatch epsilon by several orders of magnitude (from a fraction of an elmo to 1 elmo) because crashes were still occurring and I suspect it was because the position gets rounded
- Made Kernel open faster, it was way too slow at opening before

KP.net RC4
- Changed bug bombard command to Lua to prevent absurd maneuver ranges

KP.net RC3
- Fixed bug in mine script that made them think no allies were left and self-destruct
- Fixed exploit weapon gravity and gave it a small range increase (more range and better Bombard behaviour)
- Fixed behaviour of bug and exploit when on repeat and given a deploy/undeploy order
- Added small message below Network packet buffer instructing players on its use

KP.net RC2
- Fixed a bug with the firewall being used on dying units
- Gave Pointer a damage reduction vs Flow to make the latter more useful vs System, the Pointer is still useful vs Flows though, just needs to use more shots

KP.net RC1
- Changed DoS to fit with Division Zero hacker style
- Made pointer shot homing to hit Connections better
- More changes I don't remember

KP.net WIP8
- Fixed firewall not recharging

KP.net WIP6/7
- Made Firewall effect only show up when the affected unit is in LOS
- Reduced Packet rate of fire (1/.5 -> 1/.75) and range (280->250, was outranging the bit)
- Increased sigterm AOE (700->900, note that this is diameter)
- Increased Obelisk gas cloud damage per second (80->120) and radius (350->400)
- Made pointer shot homing to make hitting Connections easier

KP.net WIP5
- Fixed Flow not being invulnerable during construction
- Made dispatched Packets start rotated away from the dispatching teleporter
- Added epsilon to Dispatch spawn positions hoping to reduce the likelyhood of a crash

KP.net WIP4
- Added Network superweapon, the Firewall
- Added Pendrokar's sounds
- Network Carrier now turns like the other bases and is just as resistant to SIGTERMs
- Reduced Bug buildtime (448->240) but reduced Window workertime as well (128->64) so bugs build at roughly the same speed at Windows but faster at the Security Hole

KP.net WIP3
- Increased packet size (1x1->2x2), should reduce vulnerability towards AOE attacks
- Made Packet able to shoot through friendlies again, reduced damage (100->90) in turn (was disabled because 1x1 packets can fit a crapload of firepower in range)
- Reduced Connection rate of fire (1/2->1/3), increased damage (5x400->5x600) to maintain DPS while reducing the ability to kill spam units
- Prevented spawning of Packets on occupied spaces during dispatch order
- Disabled ONS for now since the Network faction does not support that yet

KP.net WIP2
- Decreased Packet Buffer fill rate (1/128->1/164)
- Decreased Gateway range (400->350), increased buildtime (1400->2000)
- Decreased Flow range (500->350), increased buildtime(1200->1400)
- Increased Packet rate of fire (1/.75->1/.5), made it unable to shoot through friendlies
- Increased Connection buildtime (3000->3300), decreased range (600->450)
- Restored old Worm splash damage (300->800), reduced AOE (210->180), reduced rate of fire (1/3->1/6)
- Fixed Worm retraction bug
- Reduced Virus health (400->300) and damage(120->100)
- Added Network sideicon
- Updated keybindings for Network (numpad will now select Port for building, Dispatch is D and Enter is E)
- Made Autospam widget deal with the Carrier, too
- Updated license information on defaultCommands and noRes to be Public Domain

KP.net PB1
- Added Network faction.

KP 2.2
- Gave the byte a "Mine Launcher", that eats 6000 hp to fire 5 mines
- Gave the bug a "Bombard" button, that make it move in range, morph into exploit, and fire
- About halved the worm damage, plus gave the worm back its small delay before firing.
- Merged pointernx pointer (but still only get nx flag in /0)
- Changed some building MaxSlope
- Replaced the on/off buttons for worm, old worm, and old bug
- Gave the new hacker the mine (since they don't have bugbomb anymore)

KP 2.1
- Now resiliant again to archive filename change. (Don't forget to delete the ArchiveCacheV6.txt though.)
- Made the new worm always able to fire, however, it set itself on hold fire when cloacking, and to fire at will when uncloacking.
- Changed "set CLOAKED" to "set WANT_CLOAK" in the new worm
- Added back the old hackers. Set the new hole to "hold pos" before building anything to get them.
- Seperated the hotkeys to deploy new bug, and undeploy the exploit. However, neither can be enqueued yet.
- Fixed the problem the old bug had when turning into mine when firing.
- Added "mine" and "bug" buttons to old bug. So you can enqueue its turning into a mine by shift clicking the button.
- Added widget to bind some KP hotkeys
- Added widget to remove ressources bars
- Added jK "buildbar" widget, edited to fit KP.
- Made decay much faster
- Changed Div0 trojan build effect
- Removed flanking bonus
- Made visible the area of effect of the attack of the Div0 worm

KP 2.0
- Made compliant with the new installer download scheme
- Hole & Kernel modified to allow ONS
- ONS made a "mod option"
- /0 pointer renamed to pointerNX
- Eviless based on /0, with the removal of terminal, hacker, and NX
- Terminal reload decreased to 90s
- NX reload increased to 30s
- Removed gadget handler which is now included in Spring

KP/0 Pre-Balancing v6
- Bugfixes (don't remember the details)
- Byte damage reduction when closed now only applies when the Byte is not stunned so a stunned Byte doesn't take forever to kill.
- Added a prototype faction.

KP/0 Pre-Balancing v5
- Bugfixes

KP/0 Pre-Balancing v4
- fixed Bug getting invulnerability period after morphing back from Exploit

KP/0 Pre-Balancing v3
- Byte now takes less damage when closed
- Bug cannon turned from COB mode into full-fledged building called Exploit, this allows ground attack orders
- Added particle trail to Exploit shot
- Added preference for distant targets to Exploit since the patch for that was added to SVN
- Obelisk and Terminal now use different icon for minimap and strategic view
- Hole remodeled (DZ is meant to be more serious so no more goatse!) and now allows exiting in all four directions, the building turns appropriately

KP/0 Pre-Balancing v2
- Removed debug message that might relay information to the enemy.
- Made Obelisk weapon smoke always visible, like the blast of the Sigterm.

KP/0 Pre-Balancing v1
- Initial release of Kernel Panic: Division Zero
- New unit: Virus, cannot be built, but is spawn by killing units with certain weapons.
- New unit: Obelisk and Terminal, static attack units placed on geovent.
- The Bug can morph into the Exploit, a stationnary artillery platform.
- Byte HP increased to 15000 (from 9000), but all special damage removed, so it evens out.
- Byte damage taken reduced to 30% while closed (unless paralyzed).
- Pointer has now an area of effect alternate mode of fire.
- Pointer limited firearc replaced with a set HEADING script, should reduce the situations in which the pointer will not fire.
- Bug mine functionality replaced with the ability to turn into an Exploit.
- Worm HP decreased to 12000
- Worm attack changed, now more AOE, and infectious, i.e. spawns viruses if enemies are killed.
- Worm moves at full speed when cloaked (toggle on/off) but takes time to uncloak.
- Worm cloaks after production is finished.
- Worm ability to crush bad blocks removed (to maintain stealth), use its main attack for that.
- Worm can now attack other worms, won't do area damage against them, but a direct hit is still fairly damaging.
- Worm seismic signature removed.
- Worm should therefore be back into the ambusher role it lost in the balancing process of KPC.
- Worm, Trojan, Bug, and Hole appearance changed.
- Hole now turns into four direction, and has four exit.
- Dos stuntime increased a bit, as it seemed the DOS couldn't maintain a stun in newer Spring versions.
- Introducing a new function, the experiment, to test the idea of a faction that has no direct firepower.

KP 1.5 (C&E&ONS)
- Less transparent alpha for the byte shot
- Saved the TGA without RLE
- Fixed a tiny bug in the autospam script

KP 1.4 (C&E&ONS)
- Better installer, than now include Spring as well.
- Changed method used to draw the link beam, so that ONS mode doesn't lag anymore.
- Factory now turns their heading and not just their model, fixing bug with autoexitwaypoint wrongly placed.
- Autospam widget made compatible with 75b2.
- sfx bitmaps sizes now power of 2, to fix issues with some graphical cards.
- trojan now correctly emits love beam when building badblocks and mineblasters.

KP 1.3 (C&E&ONS)
- Fixed bug with missing watertexture
- Misc installer fixes
- Hole and Kernel now invunerable even to mine and worm when shielded in ONS mutator

KP 1.2 (C&E&ONS)
- No longer considered alpha
- Split into:
  * Kernel Panic 1.2 Corruption (main data)
  * Kernel Panic 1.2 Evilless (only CPU race mutator)
  * Kernel Panic 1.2 ONS (shielded home mutator)
- Graphism of bit shot & byte shot changed
- Graphism of seismisc sensor changed
- Worm health changed again
- Bug weapon more powerful
- Gave firearc to byte
- Trojan now has LoveBeam!
- Some new buildpics
- Circuitry is no more default detailtex
- Made installer

KP:C alpha 7
- No longer destroy ability to play KP 1.0
- Hole now only autoturn 180°,
  because anyway yardmap doesn't turn
- Fixed socket and window yardmap
- Worms buildtime slightly lower
- Worm maxdamage between A6 and A5
- Fixed missing semicolon TradeMark's tool found
- CPU's mines trigger radius doubled
  and red circle when you place them fixed
- Changed default maps detailtex

KP:C alpha 6
- Kernel and Security hole now self orient to center
- Worm nerfed
- Water no longer prevent worm from firing
- Mines now cheap
- Mineblaster area of effect doubled, but now very little damage to units
- Misc file cleaning
- Remade some buildpics
- Icons for the evil

KP:C alpha 5
- Added effect to worm while uncloaked to increase visibility while attacking.
- Lowered Security Hole center to make shots less likely to pass through.
- Made worm model segmented and made script to hide the segments if they shouldn't be needed. Should reduce worm ends poking out of the ground.

KP:C alpha 4
- Worm speed, damage (only affects byte) and health reduced. Autoheal removed. Worms still kill bytes pretty well, though.
- Bug special damage against worms reintroduced to compensate for lower HP (bugs kill worms well enough)
- DoS special damage vs. worm removed, normal damage increased. Should be able to stun most targets if used in groups still, when they get too close use the DoS's superior mobility.
- Byte istargetingupgrade=1, means more bytes = better radar accuracy. If I could just set a fixed accuracy I'd do so but this is the only way to do it right now.

KP:C alpha 3
- Bug script fixed, previously took too long for its build animation.
- Assembler no longer crushes walls.
- Fixed logic_bomb.bmp file extension.
- Logic bomb capped at 32. Zwzsg wanted it.
- Socket and Window no longer count as commanders, Com Ends games end when the Kernel or Security Hole is destroyed.
- Worm texture made less reflective.
- Bug does normal damage against Worm now (100 instead of 40).
- DoS stuns Worm somewhat faster.
- DoS turn rate increased.
- Worm made 30% slower to build.
- Worm damage vs. buildings reduced, can now attack buildings normally.

KP:C alpha 2
- Factions renamed to User and Hacker, sidepics for lobby added.
- Bug damage vs. byte and worm reduced.
- Bug seismic signature fixed.
- Bug invulnerability after build shortened to 3 seconds (down from 5).
- Bug buildtime increased to 3.5 seconds. Now bugs are made about as fast as bits are made by sockets, giving the hacker no spam advantage when many geovents are in play. Use your wits to win, not your spam!
- Worm damage increased, HP increased, added sight. It's now a real beast but it's still slower than most of its adversaries.
- Worm script Activate now obeys burrow semaphore, might fix Boirunner's inability to make his worms work.
- Gave Byte a small radar to spot mines, bugbombs and worms.
- Denial of Service range halved, damage cut (takes longer to stun things now), special case damage against bits and bugs introduced to stun them slower.

KP:C alpha 1
- Initial release of the Corruption branch, adding the second side.

KP 1.0
- New smoke!
- New water texture!
- New pointer shot trail!
- New icons for all!
- All units amphibious.
- Halved arty pointer shell speed.
- Reduced its reload time by 33%.
- +28% hp for bytes.
- Second side identical to first so scripts hard coded into Spring.exe work.

KP KDR edit 8:
- ....

KP 0.7
- ....

========--------------------------------------------
License:
--------
- The content of the /mods/Kernel*.sd7 is Public Domain, save:
  /LuaUI/Widgets/kp_buildbar.lua
  /LuaRules/Gadgets/autohold.lua
  /LuaRules/Gadgets/Burrow.lua
  /LuaRules/Gadgets/game_spawn.lua
  which are GPL, taken from http://www.caspring.org or http://springrts.com
- The maps Marble Madness and Direct Memory Access are Public Domain
- The maps Major Madness and Speed Balls 16 Way status are unknown
- The maps Central Hub, Corrupted Core, Dual Core, Quad Core are CC BY-NC-SA
- The Spring engine is GPL, available from http://spring.clan-sy.com

========--------------------------------------------
Credits:
--------
- Original concept by Boirunner
- About all the work done by KDR_11k
- Maintenance and silly mod options by zwzsg
- Voices by Eva and Panda
- Sounds by Noruas and Pendrokar
- Maps by Boirunner, Runecrafter, zwzsg, TradeMark, KDR_11k and FireStorm
- Some LUA interface upgrade based of jK and trepan code
- The touhou faction characters were inspired by ZUN's works

======----------------------------------------------
Notes:

For an enhanced Kernel Panic experience,
we recommend you to listen to
demoscene or chiptune music.

Almost all BOS are meant for a linear constant of 65536, not the default.
Except the Kernel, Socket, Assembler, Bit, Byte, Logic Bomb, Bad Block, ExpScout, and Rock
which are made for linear constant of 163840.

===-------------------------------------------------
EOF
