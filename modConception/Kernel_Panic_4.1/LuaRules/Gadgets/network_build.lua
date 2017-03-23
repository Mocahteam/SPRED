function gadget:GetInfo()
	return {
		name = "Network Build",
		desc = "displays the network build effect",
		author = "KDR_11k (David Becker)",
		date = "2008-02-12",
		license = "Public Domain",
		layer = 21,
		enabled = true
	}
end

local networkbuilders= {
	[UnitDefNames.gateway.id] = true,
	[UnitDefNames.carrier.id] = true,
}

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

	local constructions = {}

	function gadget:Initialize()
		_G.constructions=constructions
	end

	function gadget:UnitCreated(u,ud,team,builder)
		if builder and networkbuilders[Spring.GetUnitDefID(builder)] then
			constructions[u]={
				heading = Spring.GetUnitBuildFacing(u),
				radius = Spring.GetUnitRadius(u),
			}
		end
	end

	function gadget:UnitFinished(u,ud,team)
		constructions[u]=nil
	end

	function gadget:UnitDestroyed(u,ud,team)
		constructions[u]=nil
	end

else

--UNSYNCED

	function gadget:DrawWorld()
		local _,_,_,_,_,ateam = Spring.GetTeamInfo(Spring.GetLocalTeamID())
		local _,specView = Spring.GetSpectatingState()
		gl.DepthTest(true)
		gl.DepthTest(GL.LEQUAL)
		gl.Culling(GL.BACK)
		gl.PolygonOffset(-2,-2)
		gl.Texture(":na:unittextures/network_buildeffect.tga")
		for u,d in spairs(SYNCED.constructions) do
			Spring.UnitRendering.SetUnitLuaDraw(u,true)
			local x,y,z = Spring.GetUnitPosition(u)
			local _,los,_,_ =  Spring.GetPositionLosState(x,y,z, ateam)
			if Spring.IsUnitVisible(u, d.radius) and (los or specView) then
				local r,g,b,a = Spring.GetTeamColor(Spring.GetUnitTeam(u))
				local _,_,_,_,p=Spring.GetUnitHealth(u)
				local f = p*.5 + .5
				local o = math.random(0,500) / 1000.0
				--gl.Color(r*f +o*o, g*f +o*o, b*f +o*o, a)
				gl.Color(1-(1-r)*o*o,1-(1-g)*o*o,1-(1-b)*o*o,1)
				gl.TexCoord(0,0)
				gl.TexGen(GL.S, GL.TEXTURE_GEN_MODE, GL.OBJECT_LINEAR)
				gl.TexGen(GL.S, GL.OBJECT_PLANE, 0, 0, .25/d.radius, .25 - p*.5)
				gl.TexGen(GL.T, GL.TEXTURE_GEN_MODE, GL.OBJECT_LINEAR)
				gl.TexGen(GL.T, GL.OBJECT_PLANE, 1, 1, 0, 0)
				gl.Unit(u,true)
			end
		end
		gl.Texture(false)
		gl.Color(1,1,1,1)
		gl.TexGen(GL.S,false)
		gl.TexGen(GL.T,false)
		gl.PolygonOffset(false)
		gl.Culling(false)
		gl.DepthTest(false)
		gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
	end

end
