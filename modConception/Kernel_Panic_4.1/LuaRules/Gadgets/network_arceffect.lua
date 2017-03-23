function gadget:GetInfo()
	return {
		name = "Network Arc Effect",
		desc = "A graphical effect",
		author = "KDR_11k (David Becker)",
		date = "2008-02-12",
		license = "Public Domain",
		layer = 21,
		enabled = true
	}
end

if not Spring.ValidUnitID then --Disable if run under 76b1
	return false
end

local TYPE_BIGARC = 1
local TYPE_BUILDARC = 2

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local arcList={}
local arcGun=WeaponDefNames.gausscannon.id

function gadget:Initialize()
	gadgetHandler:RegisterGlobal("BigArc", BigArc)
	gadgetHandler:RegisterGlobal("BuildArc", BuildArc)
	_G.arcList = arcList
	Script.SetWatchWeapon(arcGun, true)
end

function BigArc(u, ud, team, piece, tx,ty,tz)
	--if target ~= 0 then
		local x,y,z = Spring.GetUnitPiecePosition(u, piece)
		local ux, uy, uz = Spring.GetUnitBasePosition(u)
		--local tx,ty,tz = Spring.GetUnitPosition(target)
		table.insert(arcList, {
			x1=x+ux, y1=y+uy, z1=z+uz,
			x2=tx, y2=ty, z2=tz,
			type=TYPE_BIGARC,
			liveUntil=Spring.GetGameFrame()+1,
		})
	--end
end

function BuildArc(u, ud, team, piece)
	local b = Spring.GetUnitIsBuilding(u)
	local tx,ty,tz
	if b then
		tx,ty,tz = Spring.GetUnitPosition(b)
	else
		local c = Spring.GetUnitCommands(u)
		if c[1].id == CMD.RECLAIM then
			if c[1].params[1] > Game.maxUnits then
				tx,ty,tz = Spring.GetFeaturePosition(c[1].params[1] - Game.maxUnits)
			else
				tx,ty,tz = Spring.GetUnitPosition(c[1].params[1])
			end
		end
	end
	if tx then
		local x,y,z = Spring.GetUnitPiecePosition(u, piece)
		local ux, uy, uz = Spring.GetUnitBasePosition(u)
		table.insert(arcList, {
			x1=x+ux, y1=y+uy, z1=z+uz,
			x2=tx, y2=ty, z2=tz,
			type=TYPE_BUILDARC,
			liveUntil=Spring.GetGameFrame()+16,
		})
	end
end

--function gadget:UnitDamaged(u,ud,def,damage,para,weapon,au,aud,ateam)
--	if weapon == arcGun and au then
--		BigArc(au, aud, ateam, 3, u)
--	end
--end

function gadget:Explosion(weaponID, x,y,z, owner)
	if weaponID == arcGun and owner then
		BigArc(owner, nil, nil, 3, x,y,z)
	end
	return false
end

function gadget:GameFrame(f)
	for i,a in pairs(arcList) do
		if a.liveUntil <= f then
			arcList[i]=nil
		end
	end
end

else

--UNSYNCED

function drawArc(x1,y1,z1,x2,y2,z2, width, spray)
	local dx=x2-x1
	local dy=y2-y1
	local dz=z2-z1
	for i=0,1.1,.1 do
		local offx = math.random(-spray, spray)*(1-(i * 2 - 1)*(i * 2 - 1))
		local offy = math.random(-spray, spray)*(1-(i * 2 - 1)*(i * 2 - 1))
		local offz = math.random(-spray, spray)*(1-(i * 2 - 1)*(i * 2 - 1))
		local phi = math.random(0,2000*math.pi)/1000.0
		local sx = math.cos(phi)*width
		local sz = math.sin(phi)*width
		gl.Vertex(x1 + i * dx + offx + sx,y1 + i * dy + offy + 160*(1-(i * 2 - 1)*(i * 2 - 1)),z1 + i * dz + offz + sz)
		gl.Vertex(x1 + i * dx + offx - sx,y1 + i * dy + offy + 160*(1-(i * 2 - 1)*(i * 2 - 1)),z1 + i * dz + offz - sz)
	end
end

function BigArc(x1, y1, z1, x2, y2, z2)
	gl.Blending(GL.ONE, GL.ONE)
	gl.Color(math.random(2,3)/10.0, .9, math.random(2,3)/10.0,1)
	gl.DepthTest(GL.LEQUAL)
	gl.BeginEnd(GL.TRIANGLE_STRIP,drawArc,x1,y1,z1,x2,y2,z2, 4, 15)
	gl.DepthTest(false)
	gl.Color(1,1,1,1)
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
end

function BuildArc(x1, y1, z1, x2, y2, z2)
	gl.Blending(GL.ONE, GL.ONE)
	gl.Color(1, 1, 1,1)
	gl.DepthTest(GL.LEQUAL)
	gl.BeginEnd(GL.TRIANGLE_STRIP,drawArc,x1,y1,z1,x2,y2,z2, 2, 5)
	gl.DepthTest(false)
	gl.Color(1,1,1,1)
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
end

arcDrawFunc = {
	[TYPE_BIGARC] = BigArc,
	[TYPE_BUILDARC] = BuildArc,
}

function gadget:DrawWorld()
	local _,_,_,_,_,ateam = Spring.GetTeamInfo(Spring.GetLocalTeamID())
	local _,specView = Spring.GetSpectatingState()
	for _,a in spairs(SYNCED.arcList) do
		local _,_,alos = Spring.GetPositionLosState(a.x1,a.y1,a.z1, ateam)
		local _,_,alos1 = Spring.GetPositionLosState(a.x2,a.y2,a.z2, ateam)
		if specView or alos or alos1 then
			arcDrawFunc[a.type](a.x1, a.y1, a.z1, a.x2, a.y2, a.z2)
		end
	end
end

end
