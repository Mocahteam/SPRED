
-- In-game, type /luarules bb0 in the console to toggle the ai debug messages

function gadget:GetInfo()
	return {
		name = "Byte Battle: level 0",
		desc = "An AI that does nothing, just waits and returns fire.",
		author = "Mathieu Muratet",
		date = "2010-10-17",
		license = "Public Domain",
		layer = 83,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local BBAI_Debug_Mode=0 -- Must be 0 or 1

local function ChangeAIDebugVerbosity(cmd,line,words,player)
	local lvl=tonumber(words[1])
	if lvl then
		BBAI_Debug_Mode=lvl
		Spring.Echo("BB level 0 AI debug verbosity set to "..BBAI_Debug_Mode)
	else
		if BBAI_Debug_Mode>0 then
			BBAI_Debug_Mode=0
		else
			BBAI_Debug_Mode=1
		end
		Spring.Echo("BB level 0 AI debug verbosity toggled to "..BBAI_Debug_Mode)
	end
	return true
end

local function SetupCmdChangeAIDebugVerbosity()
	local cmd,func,help
	cmd  = "bb0"
	func = ChangeAIDebugVerbosity
	help = " [0|1]: make the BB LUA AI shut up or fill your infolog"
	gadgetHandler:AddChatAction(cmd,func,help)
	Script.AddActionFallback(cmd..' ',help)
end

local function BBAIDebugMessage(t,message)
	if(BBAI_Debug_Mode>0) then
		Spring.Echo("Team["..t.."] "..message)
	end
end

function gadget:Initialize()
	SetupCmdChangeAIDebugVerbosity()
end

function gadget:GameStart()
	-- Initialise AI for all team that are set to use it
	for _,t in ipairs(Spring.GetTeamList()) do
		local _,_,_,ai,side = Spring.GetTeamInfo(t)
		if Spring.GetTeamLuaAI(t)==gadget:GetInfo().name then
			BBAIDebugMessage(t, " assigned to "..gadget:GetInfo().name);
		end
	end
end

function gadget:GameFrame(f)
	-- nothing
end

end
