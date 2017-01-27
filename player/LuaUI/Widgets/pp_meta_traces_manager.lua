function widget:GetInfo()
  return {
    name      = "PP Meta Traces Manager",
    desc      = "Used to deal with traces",
    author    = "meresse, mocahteam",
    date      = "Feb 25, 2016",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true --  loaded by default?
  }
end

local missionName = Spring.GetModOptions()["missionname"]
local tracesDirname = "traces"
local ppTraces = nil -- File handler to store traces

function TraceAction(msg)
	if ppTraces ~= nil then
		ppTraces:write(msg)
		ppTraces:flush()
	end
end

function MissionEnded(victoryState)
	TraceAction("end "..victoryState.." "..missionName.."\n")
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("MissionEnded", MissionEnded)
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
	widgetHandler:DeregisterGlobal("MissionEnded", MissionEnded)
	widgetHandler:DeregisterGlobal("TraceAction", TraceAction)
	
	if ppTraces ~= nil then
		ppTraces:close()
	end
end
