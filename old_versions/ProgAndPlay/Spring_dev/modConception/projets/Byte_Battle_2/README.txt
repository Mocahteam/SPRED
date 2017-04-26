Description of this archive structure:

"ModInfo.lua" indicates some informations used by Spring. Update it if necessary.

"LuaAI.lua" file defines available AIs available for this game.

"LevelXXX.txt" are configuration files to launch a specific level for this game. These files are stored on Missions/[modShortName]/ directory ([modShortName] is specified into "ModInfo.lua" file). Inspire yourselves by exemples "Level1.txt", "Level2.txt", ... or "1vs1.txt" for multiplayer sessions.

AIs defined into "LuaAI.lua" have to be stored into LuaRules/Gadgets/ directory. This directory contains also "project_runner.lua" that contains game initialisation (units creation...). Inspire yourselves by these files to program yours.

Consult this address: http://springrts.com/wiki/Lua_Scripting to find lot of information about Lua scripting in Spring.