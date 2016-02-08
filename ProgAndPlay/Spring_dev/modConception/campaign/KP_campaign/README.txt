Description of this archive structure:

"MissionXXX.lua" files contain missions' code.
	For each mission, you must implement four functions as it is indicated in	"MissionSquelette.lua" file
	Inspire yourselves by exemples "Mission1.lua", "Mission2.lua", ...

"campaign.lua" ordinates missions in campaign. You must edit it and indicate which mission is the first, which mission is the second, ...

"ModInfo.tdf" indicates some informations used by Spring. Update it if necessary.

"campaignLauncher.txt" is a configuration file to launch the campaign. You have to extract it from this archive and use it as follow:
	command line mode, write "./spring campaignLauncher.txt".
	windowed mode, drag and drop "campaignLauncher.txt" on the executable spring.

You haven't to modify other files than those previously presented ...

Consult this address: http://springrts.com/wiki/Lua_Scripting to find lot of information about Lua scripting in Spring.