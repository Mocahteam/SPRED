
-- Does not return anything, create:
-- ModSpecific, a global table that contains information about the game/mod
-- FillModSpecific, which must be called once before the table ModSpecific can be used

ModSpecific = nil

function CutOrAddMapSuffix(name)
	local version=tonumber(string.match(Game.version,"^(%d+%.%d+)") or string.match(Game.version,"^(%d+)") or 100)
		+(string.match(Game.version,"^[%d%.]+(%+)") and 0.009 or 0)
	local hasSuffix=string.lower(string.sub(name,-4))==".smf"
	if version<0.815 then
		if hasSuffix then
			return name
		else
			return name..".smf"
		end
	else
		if hasSuffix then
			return string.sub(name,1,-5)
		else
			return name
		end
	end
end

local function AddMap(Weight,ClearName,ShortName,ExternalFileName,InternalFileName,MaxPlayers,TimeFactor,MiniMapPic,DefaultMapOptions)
	table.insert(ModSpecific.MapsList,{ClearName=ClearName,ShortName=ShortName,ExternalFileName=ExternalFileName,InternalFileName=CutOrAddMapSuffix(InternalFileName),MaxPlayers=MaxPlayers,Weight=Weight,TimeFactor=TimeFactor,MiniMapPic=MiniMapPic,DefaultMapOptions=DefaultMapOptions})
end

function FillModSpecific()
	ModSpecific = {}
	ModSpecific.Fill=FillModSpecific
	-- ModSpecific.ModFileName="Kernel_Panic_4.7.sd7"
	ModSpecific.ModFileName=Game.modName -- Not a filename, but handles mod renaming
	ModSpecific.ReadmeFileName="Kernel_Panic_readme.txt"
	ModSpecific.ScriptFileName="Kernel_Panic_script.txt"
	ModSpecific.ReloadScriptFileName="script.sav"
	ModSpecific.ExecutableFileName="spring.exe"
	ModSpecific.ClientExecutableFileName="TASClient.exe"
	ModSpecific.SettingsExecutableFileName="springsettings.exe"
	ModSpecific.FrontEndExecutableFileName="Kernel_Panic_4.7_Launcher.exe"

	ModSpecific.FactionsList={}
	table.insert(ModSpecific.FactionsList,{
		ClearName="System",InternalName="System",Description="Easiest faction to handle"})
	table.insert(ModSpecific.FactionsList,{
		ClearName="Hacker",InternalName="Hacker",Description="Trickiest faction"})
	table.insert(ModSpecific.FactionsList,{
		ClearName="Network",InternalName="Network",Description="Most mobile faction"})

	ModSpecific.BotsList={}
	table.insert(ModSpecific.BotsList,{
		ShortName="Kernel Panic AI",
		LongName="Kernel Panic AI (Lua)",
		PathAndFileName=""})
	table.insert(ModSpecific.BotsList,{
		ShortName="Fair KPAI";
		LongName="Easy KP AI (Lua)";
		PathAndFileName=""})
	table.insert(ModSpecific.BotsList,{
		ShortName="BaczekKPAI",
		LongName="Baczek's KP AI (C++)",
		PathAndFileName="\\AI\\Skirmish\\BaczekKPAI\\1.2\\SkirmishAI.dll"})

	ModSpecific.MapsList = {}
	AddMap(7,	"Marble Madness",				"MM",		"Marble_Madness_Map.sd7",				"Marble_Madness_Map.smf",				4,	2,	":nc:bitmaps/minimaps/Marble_Madness.png")
	AddMap(5,	"Major Madness",				"MjM",		"Major_Madness3.0.sd7",					"Major_Madness3.0.smf",					8,	8,	":nc:bitmaps/minimaps/Major_Madness.png")
	AddMap(3,	"Direct Memory Access 0.5c",	"DMC05c",	"Direct_Memory_Access_0.5c_beta.sd7",	"Direct Memory Access 0.5c (beta).smf",	6,	10,	":nc:bitmaps/minimaps/DMA_C.png")
	AddMap(3,	"Direct Memory Access 0.5e",	"DMC05e",	"Direct_Memory_Access_0.5e_beta.sd7",	"Direct Memory Access 0.5e (beta).smf",	6,	10,	":nc:bitmaps/minimaps/DMA_E.png")
	AddMap(4,	"Spooler Buffer",				"SB",		"Spooler_Buffer_0.5_beta.sd7",			"Spooler Buffer 0.5 (beta).smf",		4,	1,	":nc:bitmaps/minimaps/Spooler_Buffer.png")
	AddMap(4,	"Digital Divide",				"DD",		"DigitalDivide_PT2.sd7",				"DigitalDivide_PT2.smf",				4,	3,	":nc:bitmaps/minimaps/Digital_Divide.png")
	AddMap(6,	"Data Cache",					"DC",		"Data_Cache_L1.sd7",					"Data Cache L1.smf",					6,	4,	":nc:bitmaps/minimaps/Data_Cache.png")
	AddMap(3,	"Speed Balls 16 Way",			"SS16W",	"Speed_Balls_16_Way.sdz",				"Speed_Balls_16_Way.smf",				6,	5,	":nc:bitmaps/minimaps/Speed_Balls_16_Way.png")
	AddMap(3,	"Palladium",					"P",		"Palladium_0.5_(beta).sd7",				"Palladium 0.5 (beta).smf",				8,	6,	":nc:bitmaps/minimaps/Palladium.png")

	AddMap(7,	"Central Hub",					"CH",		"Central_Hub.sd7",						"Central Hub.smf",						8,	4,	":nc:bitmaps/minimaps/Central_Hub.png")
	AddMap(5,	"Corrupted Core",				"CC",		"Corrupted_Core.sd7",					"Corrupted Core.smf",					6,	3,	":nc:bitmaps/minimaps/Corrupted_Core.png")
	AddMap(3,	"Dual Core",					"2C",		"Dual_Core.sd7",						"Dual Core.smf",						4,	4,	":nc:bitmaps/minimaps/Dual_Core.png")
	AddMap(2,	"Quad Core",					"4C",		"Quad_Core.sd7",						"Quad Core.smf",						8,	6,	":nc:bitmaps/minimaps/Quad_Core.png")

	AddMap(4,	"Memory Bank",					"MB",		"Memory_Bank_v3.sdz",					"Memory Bank 0.3.smf",					4,	12,	":nc:bitmaps/minimaps/Memory_Bank.png")
	AddMap(3,	"Pacman",						"PM",		"pacman.sd7",							"pacman.smf",							4,	8,	":nc:bitmaps/minimaps/Pacman.png")
	AddMap(11,	"Hex Farm",						"HF",		"Hex_Farm_8.sd7",						"Hex Farm 8.smf",						16,	10,	":nc:bitmaps/minimaps/Hex_Farm.png",		{hexfarm_exploration=0,hexfarm_destruction=0,hexfarm_construction=0;})

end
