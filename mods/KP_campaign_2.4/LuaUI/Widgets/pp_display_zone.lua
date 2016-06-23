function widget:GetInfo()
  return {
    name      = "Display Zones",
    desc      = "Display zone at a specific position",
    author    = "zigaroula,martinb",
    date      = "Apr 29, 2016",
    license   = "GPL v2 or later",
    layer     = 0,
    enabled   = true --  loaded by default?
  }
end

local Zones = {}

function AddZoneToDisplayList(zone)
	table.insert(Zones, zone)
end

function RemoveZoneFromDisplayList(zone)
	for i, z in ipairs(Zones) do
		if z.id == zone.id then
			table.remove(Zones, i)
			break
		end
	end
end

function DrawGroundFilledEllipsis(centerX, centerZ, a, b, r, g, b)
	local divs = 25
	gl.Color(r, g, b, 0.5)
	gl.BeginEnd(GL.TRIANGLE_STRIP, function()
		for angle = 0, 2*math.pi+2*math.pi/25, 2*math.pi/25 do
			local x, z = centerX + a * math.cos(angle), centerZ + b * math.sin(angle)
			gl.Vertex(x, Spring.GetGroundHeight(x, z), z)
			gl.Vertex(centerX, Spring.GetGroundHeight(centerX, centerZ), centerZ)
		end
	end)
end

function DrawGroundRectangle(x1, x2, z1, z2, r, g, b)
	gl.Color(r, g, b, 0.5)
	gl.DrawGroundQuad(x1, z1, x2, z2)
end

function widget:DrawWorld()
	for i, z in ipairs(Zones) do
		if z.type == "Rectangle" then
			DrawGroundRectangle(z.x1, z.x2, z.z1, z.z2, z.red, z.green, z.blue)
		elseif z.type == "Disk" then
			DrawGroundFilledEllipsis(z.x, z.z, z.a, z.b, z.red, z.green, z.blue)
		end
	end
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("AddZoneToDisplayList", AddZoneToDisplayList)
	widgetHandler:RegisterGlobal("RemoveZoneFromDisplayList", RemoveZoneFromDisplayList)
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("AddZoneToDisplayList")
	widgetHandler:DeregisterGlobal("RemoveZoneFromDisplayList")
end