function widget:GetInfo()
  return {
    name      = "Traces Widget",
    desc      = "Used to deal with traces",
    author    = "meresse",
    date      = "Feb 25, 2016",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true --  loaded by default?
  }
end

local missionName = Spring.GetModOptions()["missionname"]
local tracesDirname = "traces"
local ppTraces = nil -- File handler to store traces

-- create the "mission_ended.conf" file in order to inform game engine that a mission is ended
function CreateMissionEndedFile(victoryState)
	if not VFS.FileExists("mission_ended.conf") then
		TraceAction("end "..victoryState.." "..missionName.."\n")
		local f = io.open("mission_ended.conf", "w")
		if f ~= nil then
			f:write(victoryState.."\n")
			f:write("This file has been created by Mission GUI Widget in order to inform game engine that a mission is ended. This file will be deleted the next time the game restarts.")
			f:flush()
			f:close()
		end
	end
end

function TraceAction(msg)
	if ppTraces ~= nil then
		ppTraces:write(msg)
		ppTraces:flush()
	end
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("CreateMissionEndedFile", CreateMissionEndedFile)
	widgetHandler:RegisterGlobal("TraceAction", TraceAction)
	
	if missionName ~= nil then
		if not VFS.FileExists(tracesDirname) then
			Spring.CreateDir(tracesDirname)
		end
		ppTraces = io.open(tracesDirname..'\\'.."meta.log", "a+")
		TraceAction("start "..missionName.."\n")
	end
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("CreateMissionEndedFile", CreateMissionEndedFile)
	widgetHandler:DeregisterGlobal("TraceAction", TraceAction)
	
	if ppTraces ~= nil then
		ppTraces:close()
	end
end
