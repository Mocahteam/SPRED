function widget:GetInfo()
  return {
    name      = "PP Display Bubble",
    desc      = "Display message at a specific position or above a unit",
    author    = "zigaroula,martinb, mocahteam",
    date      = "Apr 29, 2016",
    license   = "GPL v2 or later",
    layer     = 230,
    enabled   = true --  loaded by default?
  }
end

local UnitMessages = {}
local PositionMessages = {}
local BubbleMessages = {}
local UIMessages = {}

function DisplayMessageAboveUnit(message, unit, timer, id)
	table.insert(UnitMessages, {message = message, unit = unit, timer = timer,infinite=(timer==0), prevX = nil, prevY = nil, id = id})
end

function DisplayMessageAtPosition(message, x, y, z, timer, id)
	table.insert(PositionMessages, {message = message, x = x, y = y, z = z, timer = timer,infinite=(timer==0), id = id})
end

function DisplayMessageInBubble(message, unit, timer, id)
	table.insert(BubbleMessages, {message = message, unit = unit, timer = timer,infinite=(timer==0), prevX = nil, prevY = nil, id = id})
end

function addImage(parent, imagePath)
	return WG.Chili.Image:New {
		parent = parent,
		x = '5%',
		y = '5%',
		width = '90%',
		height = '90%',
		minWidth = 0,
		minHeight = 0,
		file = imagePath,
		keepAspect = true,
		color = {1, 1, 1, 1}
	}
end

function addLabel(parent, message)
	return WG.Chili.Label:New{
		parent = parent,
		x = '5%',
		y = '5%',
		width = '90%',
		height = '90%',
		minWidth = 0,
		minHeight = 0,
		align = "left",
		valign = "linecenter",
		caption = message,
		fontsize = 20,
		padding = {1, 1, 1, 1},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
			shadow = false
		}
	}
end

function DisplayUIMessage(message, x, y, width, height, id)
	if (WG.Chili) then
		local messageUI = WG.Chili.Window:New{
			parent = WG.Chili.Screen0,
			x = x,
			y = y,
			width  = width,
			height = height,
			minWidth = 0,
			minHeight = 0,
			draggable = false,
			resizable = false
		}
		local childImg = nil
		local childLabel = nil
		if string.find(message, "img:") ~= nil then
			-- extract image path
			local imagePath = string.gsub(message, "(.*)(img:)(.*)", "%3")
			childImg = addImage (messageUI, imagePath)
		else
			childLabel = addLabel(messageUI, message)
		end
		messageUI.childImg = childImg
		messageUI.childLabel = childLabel
		
		if (id) then
			UIMessages[id] = messageUI
		end
	end
end

function UpdateUIMessage(id, message)
	if id and UIMessages[id] then
		local UIMessage = UIMessages[id]
		if string.find(message, "img:") ~= nil then
			if UIMessage.childImg then
				-- extract image path
				local imagePath = string.gsub(message, "(.*)(img:)(.*)", "%3")
				-- Update image
				UIMessage.childImg.file = imagePath
				UIMessage.childImg:InvalidateSelf()
			else
				-- remove label child
				if UIMessage.childLabel then
					UIMessage.childLabel:Dispose()
					UIMessage.childLabel = nil
				end
				UIMessage.childImg = addImage (UIMessage, imagePath)
			end
		else
			if UIMessage.childLabel then
				-- Update caption
				UIMessage.childLabel:SetCaption(message)
			else
				-- remove image child
				if UIMessage.childImg then
					UIMessage.childImg:Dispose()
					UIMessage.childImg = nil
				end
				UIMessage.childLabel = addLabel (UIMessage, message)
			end
		end
	end
end

function TurnTextIntoLines(texte)
  local maxWidth=10
  local tableLines={}
  for paragraph in string.gmatch(texte, "[^\n]+") do
	  local message=""
	  local wCurrentLine=0
	  local f=true--first insert
	  for token in string.gmatch(paragraph, "[^%s]+") do
		local tokSize=gl.GetTextWidth(token)
		if(((wCurrentLine+tokSize)<maxWidth) or (message=="")) then -- we continue to write on the same line
		  if (f) then message=token ; f=false -- to avoid a blank space at the beginning of the message
		  else message=message.." "..token end
		  wCurrentLine=wCurrentLine+tokSize
		else -- threshold reached => newline
		  table.insert(tableLines,message)
		  message=token
		  wCurrentLine=tokSize
		end
	  end
	  table.insert(tableLines,message) -- to include the tail of the string for which, by definition, the threshold is not reached
  end
  return tableLines
end

-- display text at position, if the text is too wide
-- it will be cut in smaller parts by the call of TurnTextIntoLines
function DisplayTextAtScreenPosition(x, y, texte)
    local s = 30
    local tableLine=TurnTextIntoLines(texte)
    local nLines=table.getn(tableLine)
    for i, m in ipairs(tableLine) do
      local w = gl.GetTextWidth(m)*s
      gl.Text(m, x-(w/2), y+(nLines-i)*s, s, "s")
    end
end

function DisplayBubbleAtScreenPosition(x, y, text, u)
	x = x - 80
	local s = 20
	local tableLine = TurnTextIntoLines(text)
	local nLines = table.getn(tableLine)
	local height = s * nLines
	for i, m in ipairs(tableLine) do
		gl.Text(m, x+10, y+(nLines-i)*s+80, s, "s")
	end
	local top_tex = "bitmaps/game/bubble_top.png"
	local mid_tex = "bitmaps/game/bubble_mid.png"
	local bot_tex = "bitmaps/game/bubble_bot.png"
	local team = Spring.GetUnitTeam(u)
	local r, g, b, a = Spring.GetTeamColor(team)
	gl.Color(r, g, b, a)
	gl.Texture(bot_tex)
	gl.TexRect(x, y, x+300, y+80, false, false)
	gl.Texture(top_tex)
	gl.TexRect(x, y+height+81, x+300, y+height+101, false, false)
	gl.Texture(mid_tex)
	gl.TexRect(x, y+80, x+300, y+height+81, false, false)
	gl.Texture(false)
end

function widget:DrawScreen()
	for i, mes in ipairs(UnitMessages) do
		local u, m = mes.unit, mes.message
		if(Spring.ValidUnitID(u))then
			local x, y, z = Spring.GetUnitPosition(u)
			x, y = Spring.WorldToScreenCoords(x, y+50, z)
			-- avoid quake
			x = math.floor(x)
			y = math.floor(y)
			if mes.prevX == nil then
				mes.prevX = x
			else
				if math.abs(x-mes.prevX) < 4 then
					x = mes.prevX
				else
					mes.prevX = x
				end
			end
			if mes.prevY == nil then
				mes.prevY = y
			else
				if math.abs(y-mes.prevY) < 4 then
					y = mes.prevY
				else
					mes.prevY = y
				end
			end
			DisplayTextAtScreenPosition(x, y, m)
		end
	end
	for i, mes in ipairs(PositionMessages) do
		local x, y, z, m = mes.x, mes.y, mes.z, mes.message
		x, y = Spring.WorldToScreenCoords(x, y, z)
		DisplayTextAtScreenPosition(x, y, m)
	end
	for i, mes in ipairs(BubbleMessages) do
		local u, m = mes.unit, mes.message
		if(Spring.ValidUnitID(u))then
			local x, y, z = Spring.GetUnitPosition(u)
			x, y = Spring.WorldToScreenCoords(x, y+50, z)
			-- avoid quake
			x = math.floor(x)
			y = math.floor(y)
			if mes.prevX == nil then
				mes.prevX = x
			else
				if math.abs(x-mes.prevX) < 4 then
					x = mes.prevX
				else
					mes.prevX = x
				end
			end
			if mes.prevY == nil then
				mes.prevY = y
			else
				if math.abs(y-mes.prevY) < 4 then
					y = mes.prevY
				else
					mes.prevY = y
				end
			end
			DisplayBubbleAtScreenPosition(x, y, m, u)
		end
	end
end

local function forceMessagesToClose (listOfMessages, id)
	local i = 1
	while i <= #listOfMessages do
	 local m = listOfMessages[i]
	 if (m.id ~= nil and id ~= nil and m.id == id)then
  		table.remove(listOfMessages, i)
		i = i - 1
     end
	 i = i + 1
	end
end

local function forceUIMessageToClose (id)
	if (WG.Chili and UIMessages[id]) then
		UIMessages[id]:Dispose()
		UIMessages[id] = nil
	end
end

function RemoveMessageById(id)
	forceMessagesToClose(UnitMessages, id)
	forceMessagesToClose(PositionMessages, id)
	forceMessagesToClose(BubbleMessages, id)
	forceUIMessageToClose(id)
end

function widget:Initialize()
	if (not WG.Chili) then -- If chili widget is not loaded, we try to enable it
		widgetHandler:EnableWidget("Chili Framework")
	end
	widgetHandler:RegisterGlobal("DisplayMessageAboveUnit", DisplayMessageAboveUnit)
	widgetHandler:RegisterGlobal("DisplayMessageAtPosition", DisplayMessageAtPosition)
	widgetHandler:RegisterGlobal("DisplayMessageInBubble", DisplayMessageInBubble)
	widgetHandler:RegisterGlobal("DisplayUIMessage", DisplayUIMessage)
	widgetHandler:RegisterGlobal("UpdateUIMessage", UpdateUIMessage)
	widgetHandler:RegisterGlobal("RemoveMessageById", RemoveMessageById)
end

local function removeMessagesIfTimeOver (listOfMessages, delta)
	local i = 1
	while i <= #listOfMessages do
	 local m = listOfMessages[i]
	 if (not m.infinite)then
  		m.timer = m.timer - delta
  		if m.timer < 0 then
  			table.remove(listOfMessages, i)
			i = i - 1
  		end
     end
	 i = i + 1
	end
end

function widget:Update(delta)
	removeMessagesIfTimeOver(UnitMessages, delta)
	removeMessagesIfTimeOver(PositionMessages, delta)
	removeMessagesIfTimeOver(BubbleMessages, delta)
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("DisplayMessageAboveUnit")
	widgetHandler:DeregisterGlobal("DisplayMessageAtPosition")
	widgetHandler:DeregisterGlobal("DisplayMessageInBubble")
	widgetHandler:DeregisterGlobal("DisplayUIMessage")
	widgetHandler:DeregisterGlobal("UpdateUIMessage")
	widgetHandler:DeregisterGlobal("RemoveMessageById")
end