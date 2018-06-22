function gadget:GetInfo()
	return {
		name = "Network Buffer",
		desc = "The Network's 'resource' system",
		author = "KDR_11k (David Becker)",
		date = "February 2008",
		license = "Public domain",
		layer = 21,
		enabled = true
	}
end

local port = UnitDefNames.port.id
local delayFrames=164
local MaxUnits=Game.maxUnits -- 10000 not matter what the unitlimit
if Spring.GetModOptions and Spring.GetModOptions()["maxunits"] then
	MaxUnits=tonumber(Spring.GetModOptions()["maxunits"])
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local destroyQueue = {}
local createQueue={}

local portList={}

local bufferSize={}

function gadget:GameFrame(t)
	for i,u in pairs(destroyQueue) do
		Spring.DestroyUnit(u, false, true, u)
		destroyQueue[i]=nil
	end
	for i,u in pairs(createQueue) do
		Spring.CreateUnit(u.target,u.x,u.y,u.z,0,u.team)
		createQueue[i] = nil
	end
	if (t + 1) % 8 < .1 then
		for u,f in pairs(portList) do
			if f <= t then
				local team = Spring.GetUnitTeam(u)
				bufferSize[team] = bufferSize[team] + 1
				portList[u] = t + delayFrames
			end
		end
		for _,team in ipairs(Spring.GetTeamList()) do
			bufferSize[team] = math.min(bufferSize[team],MaxUnits-Spring.GetTeamUnitCount(team))
			Spring.SetTeamRulesParam(team,"bufferSize",bufferSize[team])
		end
	end
end

function gadget:UnitFinished(u,ud,team)
	if ud == port then
		portList[u] = 0
	end
end

function gadget:UnitDestroyed(u,ud,team)
	portList[u]=nil
end

function gadget:Initialize()
	for _,t in ipairs(Spring.GetTeamList()) do
		local _,_,_,_,_,_,CustomTeamOptions=Spring.GetTeamInfo(t)
		if CustomTeamOptions and CustomTeamOptions["startbuffer"] and tonumber(CustomTeamOptions["startbuffer"]) then
			bufferSize[t]=math.floor(tonumber(CustomTeamOptions["startbuffer"]))
		else
			bufferSize[t]=0
		end
		Spring.SetTeamRulesParam(t,"bufferSize",bufferSize[t])
	end
	GG.bufferSize=bufferSize
	_G.bufferSize=bufferSize
end

else

function gadget:DrawScreen(vsx, vsy)
	local team = Spring.GetLocalTeamID()
	if (SYNCED.bufferSize[team] > 0 or #Spring.GetTeamUnitsByDefs(team,port)>0) and not Spring.IsGUIHidden() and not Spring.GetSpectatingState() then
		gl.Text("Buffer "..((SYNCED.bufferSize[team]+Spring.GetTeamUnitCount(team)>=MaxUnits) and "\255\255\196\196MAXED\255\255\255\255" or "fill state")..": "..SYNCED.bufferSize[team], vsx *.75, vsy - 50, 22, "c")
		gl.Text("Select a Port or Connection and use the Dispatch command to use these packets.", vsx *.75, vsy - 80, 14, "c")
	end
end

end
