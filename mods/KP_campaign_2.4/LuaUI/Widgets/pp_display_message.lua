function widget:GetInfo()
  return {
    name      = "Display Message",
    desc      = "Display message at a specific position or above a unit",
    author    = "zigaroula,martinb",
    date      = "Apr 29, 2016",
    license   = "GPL v2 or later",
    layer     = 0,
    enabled   = true --  loaded by default?
  }
end

local UnitMessages = {}
local PositionMessages = {}


function DisplayMessageAboveUnit(message, unit, timer)
	table.insert(UnitMessages, {message = message, unit = unit, timer = timer,infinite=(timer==0)})
end

function DisplayMessageAtPosition(message, x, y, z, timer)
	table.insert(PositionMessages, {message = message, x = x, y = y, z = z, timer = timer,infinite=(timer==0)})
end

function TurnToIntoLines(texte)
  local maxWidth=10
  local tableLines={}
  local message=""
  local wCurrentLine=0
  local f=true--first insert
  for token in string.gmatch(texte, "[^%s]+") do
    if(((wCurrentLine+gl.GetTextWidth(token))<maxWidth) or (message=="")) then -- we continue to write on the same line
      if (f) then message=token ; f=false -- to avoid a blank space at the beginning of the message
      else message=message.." "..token end
      wCurrentLine=wCurrentLine+gl.GetTextWidth(token)
    else -- threshold reached => newline
      table.insert(tableLines,message)
      message=token
      wCurrentLine=0
    end
  end
  table.insert(tableLines,message) -- to include the tail of the string for which, by definition, the threshold is not reached
  return tableLines
end

-- display text at position, if the text is too wide
-- it will be cut in smaller parts by the call of TurnToIntoLines
function DisplayTextAtScreenPosition(x, y, texte)
    local s = 30
    local tableLine=TurnToIntoLines(texte)
    local nLines=table.getn(tableLine)
    for i, m in ipairs(tableLine) do
      local w = gl.GetTextWidth(texte)*s
      gl.Text(m, x-50, y+(nLines-i)*s, s, "s")
    end
end

function widget:DrawScreen()
	for i, mes in ipairs(UnitMessages) do
		local u, m = mes.unit, mes.message
		local x, y, z = Spring.GetUnitPosition(u)
		x, y = Spring.WorldToScreenCoords(x, y+50, z)
		DisplayTextAtScreenPosition(x, y, m)
	end
	for i, mes in ipairs(PositionMessages) do
		local x, y, z, m = mes.x, mes.y, mes.z, mes.message
		x, y = Spring.WorldToScreenCoords(x, y, z)
    DisplayTextAtScreenPosition(x, y, m)
	end
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("DisplayMessageAboveUnit", DisplayMessageAboveUnit)
	widgetHandler:RegisterGlobal("DisplayMessageAtPosition", DisplayMessageAtPosition)
end

function widget:Update(delta)
	local toBeRemoved = {}
	for i, m in ipairs(UnitMessages) do
	 if (not m.infinite)then
  		m.timer = m.timer - delta
  		if m.timer < 0 then
  			table.insert(toBeRemoved, i)
  		end
    end
	end
	for _, i in ipairs(toBeRemoved) do
		table.remove(UnitMessages, i)
	end
	
	toBeRemoved = {}
	for i, m in ipairs(PositionMessages) do
   if (not m.infinite)then
      m.timer = m.timer - delta
      if m.timer < 0 then
        table.insert(toBeRemoved, i)
      end
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