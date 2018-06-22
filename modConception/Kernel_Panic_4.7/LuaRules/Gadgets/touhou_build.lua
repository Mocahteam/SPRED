function gadget:GetInfo()
	return {
		name = "Touhou Build",
		desc = "TH build anim",
		author = "KDR_11k (David Becker)",
		date = "2008-05-21",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

local thUnits= {
	[UnitDefNames.fairy.id]=true,
	[UnitDefNames.reimu.id]=true,
	[UnitDefNames.alice.id]=true,
	[UnitDefNames.marisa.id]=true,
	[UnitDefNames.thminifac.id]=true,
}

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local constructions = {}

function gadget:UnitCreated(u, ud, team)
	if thUnits[ud] then
		constructions[u]={Spring.GetUnitAllyTeam(u)}
	end
end

function gadget:UnitFinished(u, ud, team)
	constructions[u]=nil
end

function gadget:UnitDestroyed(u, ud, team)
	constructions[u]=nil
end

function gadget:Initialize()
	_G.THconstructions=constructions
end

else

--UNSYNCED

local cylinder

local function cylinderFunc()
	for phi = 0,20 do
		local x = math.cos(phi * .314159)
		local z = math.sin(phi * .314159)
		gl.TexCoord(phi/20.0,.1)
		gl.Vertex(x,100,z)
		gl.TexCoord(phi/20.0,1)
		gl.Vertex(x,0,z)
	end
end

function gadget:Initialize()
	cylinder=gl.CreateList(gl.BeginEnd,GL.TRIANGLE_STRIP,cylinderFunc)
end

function gadget:Shutdown()
	gl.DeleteList(cylinder)
end

function gadget:DrawWorld()
	gl.DepthTest(GL.LEQUAL)
	gl.Blending(GL.ONE, GL.ONE_MINUS_SRC_ALPHA)
	gl.Texture("bitmaps/kpsfx/shine.tga")
	local _,_,_,_,_,ateam = Spring.GetTeamInfo(Spring.GetLocalTeamID())
	local _,specView = Spring.GetSpectatingState()
	for u,t in spairs(SYNCED.THconstructions) do
		local x,y,z=Spring.GetUnitBasePosition(u)
		local _,los,_,_ =  Spring.GetPositionLosState(x,y,z, ateam)
		if Spring.IsUnitVisible(u, t.radius) and (los or specView) then
			local _,_,_,_,b = Spring.GetUnitHealth(u)
			local r = Spring.GetUnitRadius(u) * b
			gl.PushMatrix()
			gl.Translate(x,y,z)
			gl.Scale(r,1 / (.1 + b),r)
			gl.CallList(cylinder)
			gl.PopMatrix()
		end
	end
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
	gl.DepthTest(false)
	gl.Texture(false)
end

end
