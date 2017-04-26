Description of this archive structure:

"ModInfo.lua" indicates some informations used by Spring. Update it if necessary.

"MissionXXX.lua" files contain missions' code.
	For each mission, you must implement four functions as it is indicated in	"MissionSqueleton.lua" file
	Inspire yourselves by exemples "Mission1.lua", "Mission2.lua", ...

"MissionXXX.txt" are configuration files to launch a specific mission of the campaign. These files are stored on Missions/[modShortName]/ directory ([modShortName] is specified into "ModInfo.lua" file). Inspire yourselves by exemples "Mission1.txt", "Mission2.txt", ...

"campaign.lua" ordinates missions in campaign. You must edit it and indicate which mission is the first (MissionXXX.lua and associated launcher MissionXXX.txt), which mission is the second (MissionYYY.lua and associated launcher MissionYYY.txt), ...

You haven't to modify other files than those previously presented ...

Consult this address: http://springrts.com/wiki/Lua_Scripting to find lot of information about Lua scripting in Spring.