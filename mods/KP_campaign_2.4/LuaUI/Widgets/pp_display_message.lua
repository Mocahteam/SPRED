function widget:GetInfo()
  return {
    name      = "Display Message",
    desc      = "Display message at a specific position or above a unit",
    author    = "zigaroula",
    date      = "Apr 29, 2016",
    license   = "GPL v2 or later",
    layer     = 0,
    enabled   = true --  loaded by default?
  }
end

local UnitMessages = {}
local PositionMessages = {}

function DisplayMessageAboveUnit(message, unit, timer)
	table.insert(UnitMessages, {message = message, unit = unit, timer = timer})
end

function DisplayMessageAtPosition(message, x, y, z, timer)
	table.insert(PositionMessages, {message = message, x = x, y = y, z = z, timer = timer})
end

function widget:DrawScreen()
	for i, mes in ipairs(UnitMessages) do
		local u, m = mes.unit, mes.message
		local x, y, z = Spring.GetUnitPosition(u)
		x, y = Spring.WorldToScreenCoords(x, y+50, z)
		local s = 15
		local w = gl.GetTextWidth(m)*s
		gl.Text(m, x - (w/2), y, s, "s")
	end
	for i, mes in ipairs(PositionMessages) do
		local x, y, z, m = mes.x, mes.y, mes.z, mes.message
		local s = 15
		local w = gl.GetTextWidth(m)*s
		gl.Text(m, x - (w/2), y, s, "s")
	end
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("DisplayMessageAboveUnit", DisplayMessageAboveUnit)
	widgetHandler:RegisterGlobal("DisplayMessageAtPosition", DisplayMessageAtPosition)
end

function widget:Update(delta)
	local toBeRemoved = {}
	for i, m in ipairs(UnitMessages) do
		m.timer = m.timer - delta
		if m.timer < 0 then
			table.insert(toBeRemoved, i)
		end
	end
	for _, i in ipairs(toBeRemoved) do
		table.remove(UnitMessages, i)
	end
	
	toBeRemoved = {}
	for i, m in ipairs(PositionMessages) do
		m.timer = m.timer - delta
		if m.timer < 0 then
			table.insert(toBeRemoved, i)
		end
	end
	for _, i in ipairs(toBeRemoved) do
		table.remove(PositionMessages, i)
	end
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("DisplayMessageAboveUnit")
	widgetHandler:DeregisterGlobal("DisplayMessageAtPosition")
end