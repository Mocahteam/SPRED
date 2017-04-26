-- $Id: mission_messenger.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Ce widget permet d'effectuer un diaporama au sein même du jeu
-- Cliquer sur les slides pour passer à la suivante ou utiliser les touches Q et D

function widget:GetInfo()
  return {
    name      = "Presentation",
    desc      = "Displays Messages. Click on them to make them go away.",
    author    = "muratet",
    date      = "26 mai 2013",
    license   = "GPL v2 or later",
    layer     = 210,
    enabled   = true,  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- You must import the KEYSYM table if you want to access keys by name
include('keysym.h.lua')

local slideWidth = 800
local slideHeight = 600
local chipLevel1 = 0.1
local chipLevel2 = 0.15
local chipLevel3 = 0.2
local slideYstate = "down"
local currentSlide
local previousSlide
local viewSizeX, viewSizeY
local gl, GL = gl, GL
local fontHandler = loadstring(VFS.LoadFile(LUAUI_DIRNAME.."modfonts.lua", VFS.ZIP_FIRST))()
local slides = {}
slides[1] = {
	{text = "", autosize = false, showBox = true, align = "center"},
	{texture = ":n:LuaUI/Widgets/images/Prog&Play_low.png", relY = 0.75, width = 348, height = 148, align = "center"},
    {text = "Mathieu Muratet, Elisabeth Delozanne", relY = 0.5, font = "LuaUI/Fonts/FreeSansBold_30", align = "center"},
	{text = "EIAH 2013 - Toulouse - 30 mai 2013", relY = 0.25, align = "center"}
}
slides[2] = {
	{text = "", autosize = false, showBox = true, align = "center"},
    {text = "Qu'est-ce que Prog&Play ?", relY = 0.8, font = "LuaUI/Fonts/FreeSansBold_30", align = "center"},
	{text = "o Une bibliothèque de fonction", relY = 0.6, relX = chipLevel1},
	{text = "o Objectif : Programmer de manière dynamique les unités d'un jeu de STR", relY = 0.525, relX = chipLevel1, width = slideWidth-chipLevel1*slideWidth},
	{text = "o Constitution", relY = 0.45, relX = chipLevel1},
	{text = "- Interface \"Fournisseur\" à intégrer dans un moteur de jeu", relY = 0.4, relX = chipLevel2},
	{text = "- Interfaces \"Client\" utilisées par les joueurs pour interagir avec le moteur du jeu", relY = 0.325, relX = chipLevel2, width = slideWidth-chipLevel2*slideWidth}
}
slides[3] = {
	{text = "", autosize = false, showBox = true, align = "center"},
    {text = "Pourquoi Prog&Play ?", relY = 0.8, font = "LuaUI/Fonts/FreeSansBold_30", align = "center"},
	{text = "o Concevoir des jeux sérieux de programmation", relY = 0.6, relX = chipLevel1},
	{text = "- Basés sur le STR \"Kernel Panic\" (Spring)", relY = 0.55, relX = chipLevel2},
	{text = "- Pourquoi ce choix ?", relY = 0.5, relX = chipLevel2},
	{text = "* Adéquation entre le fond et la forme", relY = 0.45, relX = chipLevel3},
	{text = "* Bits, Octets... VS Tanks, Chevaliers...", relY = 0.4, relX = chipLevel3},
	{text = "o Faire que pour un même jeu sérieux plusieus langages de programmation puissent être utilisés", relY = 0.325, relX = chipLevel1, width = slideWidth-chipLevel1*slideWidth},
	{text = "- Ada", relY = 0.25, relX = chipLevel2},
	{text = "- C/C++", relY = 0.2, relX = chipLevel2},
	{text = "- Compalgo", relY = 0.15, relX = chipLevel2},
	{text = "- Java", relY = 0.25, relX = chipLevel2+0.5},
	{text = "- OCaml", relY = 0.2, relX = chipLevel2+0.5},
	{text = "- Scratch", relY = 0.15, relX = chipLevel2+0.5}
}
slides[4] = {
	{text = "", autosize = false, showBox = true, align = "center"},
    {text = "Démonstrations", relY = 0.8, font = "LuaUI/Fonts/FreeSansBold_30", align = "center"},
	{text = "o Kernel Panic Campaign", relY = 0.6, relX = chipLevel1},
	{text = "- Scénario décomposé en 8 missions", relY = 0.55, relX = chipLevel2},
	{text = "* Chaque mission propose un objectif ludique", relY = 0.5, relX = chipLevel3},
	{text = "* Complexification des programmes à produire", relY = 0.45, relX = chipLevel3},
	{text = "- Centré sur les fondamentaux de la programmation", relY = 0.4, relX = chipLevel2}
}
slides[5] = {
	{text = "", autosize = false, showBox = true, align = "center"},
    {text = "Démonstrations", relY = 0.8, font = "LuaUI/Fonts/FreeSansBold_30", align = "center"},
	{text = "o Byte Battle", relY = 0.6, relX = chipLevel1},
	{text = "- 5 niveaux de difficultés", relY = 0.55, relX = chipLevel2},
	{text = "* Proposent des situations compétitives", relY = 0.5, relX = chipLevel3},
	{text = "* Amènent les étudiants à améliorer leur programme", relY = 0.45, relX = chipLevel3},
	{text = "- Centré sur la décomposition fonctionnelle", relY = 0.4, relX = chipLevel2}
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function Split(s, separator)
  local results = {}
  for part in s:gmatch("[^"..separator.."]+") do
    results[#results + 1] = part
  end
  return results
end

-- remove first n elemets from t, return them
local function Take(t, n)
  local removed = {}
  for i=1, n do
    removed[#removed+1] = table.remove(t, 1)
  end
  return removed
end

-- appends t1 to t2 in-place
local function Append(t1, t2)
  local l = #t1
  for i = 1, #t2 do
    t1[i + l] = t2[i]
  end
end

local function WordWrap(text, font, maxWidth, size)
  fontHandler.UseFont(font)
  text = text:gsub("\r\n", "\n")
  local spaceWidth = fontHandler.GetTextWidth(" ", size)
  local allLines = {}
  local paragraphs = Split(text, "\n")
  for _, paragraph in ipairs(paragraphs) do
    lines = {}
    local words = Split(paragraph, "%s")
    local widths = {}
    for i, word in ipairs(words) do
      widths[i] = fontHandler.GetTextWidth(fontHandler.StripColors(word), size)
    end
    repeat
      local width = 0
      local i = 1
      for j=1, #words do
        newWidth = width + widths[j]
        if (newWidth > maxWidth) then
          break
        else
          width = newWidth + spaceWidth
        end
        i = j
      end
      Take(widths, i)
      lines[#lines+1] = table.concat(Take(words, i), " ")
    until (i > #words)
    if (#words > 0) then
	  words[1] = "   " .. words[1]
	  Spring.Echo (table.concat(words, " "))
      lines[#lines+1] = table.concat(words, " ")
    end
    Append(allLines, lines)
  end
  return allLines
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function DrawBox(width, height)
	gl.Color(0, 0, 0, 0.9)
	gl.Vertex(0.5, 0.5)
  gl.Color(0, 0, 0, 0.9)
	gl.Vertex(0.5, height + 0.5)
  gl.Color(0, 0, 0, 0.9)
	gl.Vertex(width + 0.5, height + 0.5)
  gl.Color(0.4, 0.4, 0.4, 0.9)
	gl.Vertex(width+ 0.5, 0.5)
end

local function DrawBorders(width, height)
	gl.Color(1, 1, 1, 1)
	gl.Vertex(0.5, 0.5)
	gl.Vertex(0.5, height + 0.5)
	gl.Vertex(width + 0.5, height + 0.5)
	gl.Vertex(width + 0.5, 0.5)
end

local function List(width, height, texture)
  if (texture) then
    gl.Color(1, 1, 1, 1)
    gl.Texture(texture)
    gl.TexRect(0, 0, width, height)
	gl.Texture(false)
  else
    gl.BeginEnd(GL.QUADS, DrawBox, width, height)
    gl.BeginEnd(GL.LINE_LOOP, DrawBorders, width, height)
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Message  = {
  font      = "LuaUI/Fonts/FreeSansBold_20",
  anim      = "right2middle",
  align     = "",
  velocity  = 100,
  marginX   = 20,
  marginY   = 20,
  spacing   = 10,
  width     = slideWidth,
  height    = slideHeight,
  x1        = 200,
  x1Origin  = 200,
  y1        = 200,
  y1Origin  = 200,
  autoSize  = true,
  relX      = 0.5,
  relY      = 0.5,
  showBox   = false,
  pause     = false,
}
Message.__index = Message
WG.Message = Message

function Message:Show(m)
  setmetatable(m, self)
  fontHandler.UseFont(m.font)
  m.fontSize = fontHandler.GetFontSize()
  
  if (type(m.text) == 'string') then
    m.text = WordWrap(m.text, m.font, m.width - m.marginX * 2)
  end
  if (m.text and m.autoSize and #m.text > 0 and not m.texture) then
    local maxWidth = 0
    for _, line in ipairs(m.text) do
      maxWidth = math.max(maxWidth, fontHandler.GetTextWidth(fontHandler.StripColors(line), m.fontSize))
    end
    m.width = maxWidth + m.marginX * 2
    m.height = #m.text * m.fontSize + (#m.text - 1) * m.spacing + m.marginY * 2
  end
  m.displayList = gl.CreateList(List, m.width, m.height, m.texture)
  local _, _, paused = Spring.GetGameSpeed()
  if m.pause and not paused then
    Spring.SendCommands"pause"
  end
  return m
end


function Message:Draw(viewSizeX, viewSizeY)
  if (self.anim == "destroy") then
    self:Delete()
  else
	local target = ((viewSizeX-slideWidth)/2) + self.relX*slideWidth
	if self.align == "center" then
		target = target - self.width/2
	end
    if (self.anim == "right2middle") then
	    self.x1 = self.x1 - (self.velocity * (self.x1 - target) / (self.x1Origin - target)) - 1
        if (self.x1 < target) then
	      self.anim = ""
	    end
    elseif (self.anim == "middle2right") then
	    self.x1 = self.x1 + self.velocity
        if (self.x1 > viewSizeX+self.width) then
	      self.anim = "destroy"
	    end
    elseif (self.anim == "middle2left") then
	    self.x1 = self.x1 - self.velocity
        if (self.x1 < -self.width) then
	      self.anim = "destroy"
	    end
    elseif (self.anim == "left2middle") then
	    self.x1 = self.x1 + (self.velocity * (target - self.x1) / (target - self.x1Origin)) + 1
        if (self.x1 > target) then
	      self.anim = ""
	    end
    else
	    self.x1 = target
    end
	
	local targetY = ((viewSizeY-slideHeight)/2) + self.relY*slideHeight-self.height/2
    if (slideYstate == "goDown") then
	    self.y1 = self.y1 - (self.velocity * (targetY - self.y1) / (targetY - self.y1Origin)) - 1
        if (self.y1 < targetY) then
	      slideYstate = "down"
	    end
	elseif (slideYstate == "goUp") then
	    self.y1 = self.y1 + self.velocity
        if (self.y1 > viewSizeY+slideHeight) then
	      slideYstate = "up"
	    end
    elseif (slideYstate == "down") then
	  self.y1 = targetY
    elseif (slideYstate == "up") then
	  if self.y1 < viewSizeY then
		self.y1 = self.y1 + viewSizeY
	  end
    end
    self.x1 = math.floor(self.x1)
    self.y1 = math.floor(self.y1) 
    gl.PushMatrix()
    gl.Translate(self.x1, self.y1, 0)
    if (self.text) then
  	  if (self.showBox) then
	    gl.CallList(self.displayList)
	  end
		
      -- gl.Translate(-0.5, -0.5, 0)
      fontHandler.UseFont(self.font)
      gl.Color(1, 1, 1, 1)
      for i, line in ipairs(self.text) do
        local x = self.marginX
        local y = self.height - self.marginY - 
                  self.fontSize * i -
                  self.spacing * (i - 1)
        fontHandler.Draw(line, x, y)
      end
    else
      gl.CallList(self.displayList)
    end
    gl.PopMatrix()
  end
end


function Message:Delete()
  local _, _, paused = Spring.GetGameSpeed()
  if self.pause and paused then
    Spring.SendCommands"pause"
  end
  gl.DeleteList(self.displayList)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function hideSlides()
	if slideYstate == "up" or slideYstate == "goUp" then
		slideYstate = "goDown"
		for _, slide in pairs(slides) do
			for _, elem in pairs(slide) do
				elem.y1Origin = elem.y1
			end
		end
	else
		slideYstate = "goUp"
	end
end

function addFooter()
	for i, slide in pairs(slides) do
		if i > 1 then
			table.insert(slide, {texture = ":n:LuaUI/Widgets/images/Prog&Play_low.png", relY = 0.05, relX = 0.08, width = 87, height = 37, align = "center"})
			table.insert(slide, {text = "EIAH 2013 - Toulouse - 30 mai 2013", relY = 0.05, showBox = false, font = "LuaUI/Fonts/FreeSansBold_16", align = "center"})
			table.insert(slide, {text = tostring(i), relY = 0.05, relX = 0.95, showBox = false, font = "LuaUI/Fonts/FreeSansBold_16", align = "center"})
		end
	end
end


function loadNextSlide()
    if currentSlide < #slides then
		if (currentSlide > 0) then
			for _, slide in pairs(slides[currentSlide]) do
				slide.anim = "middle2left"
				slide.x1Origin = slide.x1
			end
		end
		previousSlide = currentSlide
		currentSlide = currentSlide + 1
		for _, elem in pairs(slides[currentSlide]) do
            local viewSizeX = gl.GetViewSizes()
			elem = Message:Show(elem) -- prebuild slide
			-- set this slide outside the screen
			elem.x1 = ((viewSizeX-slideWidth)/2) + elem.relX*slideWidth + viewSizeX
			if elem.align == "center" then
				elem.x1 = elem.x1 - elem.width/2
			end
			elem.x1Origin = elem.x1
			elem.anim = "right2middle"
			elem = Message:Show(elem)
		end
	end
end

function loadPrevSlide()
    if currentSlide > 1 then
		for _, slide in pairs(slides[currentSlide]) do
			slide.anim = "middle2right"
			slide.x1Origin = slide.x1
		end
		previousSlide = currentSlide
		currentSlide = currentSlide - 1
		for _, elem in pairs(slides[currentSlide]) do
            local viewSizeX = gl.GetViewSizes()
			elem = Message:Show(elem) -- prebuild slide
			-- set this slide outside the screen
			elem.x1 = ((viewSizeX-slideWidth)/2) + elem.relX*slideWidth - viewSizeX
			if elem.align == "center" then
				elem.x1 = elem.x1 - elem.width/2
			end
			elem.x1Origin = elem.x1
			elem.anim = "left2middle"
			elem = Message:Show(elem)
		end
	end
end

function widget:DrawScreen()
  local viewSizeX, viewSizeY = gl.GetViewSizes()
  for _, slide in pairs(slides[currentSlide]) do
	slide:Draw(viewSizeX, viewSizeY)
  end
  if (previousSlide ~= 0) then
    for _, slide in pairs(slides[previousSlide]) do
	  slide:Draw(viewSizeX, viewSizeY)
    end
  end
end

function widget:MousePress(x, y, button)
	local capture
	for _, slide in pairs(slides[currentSlide]) do
		if ( x > slide.x1 and x < slide.x1 + slide.width   and
			y > slide.y1 and y < slide.y1 + slide.height) then
			capture = true
		end
	end
	if capture then
		loadNextSlide()
	end
	return capture
end

function widget:KeyPress(key, mods, isRepeat, label, unicode)
  local capture
	
	if key == KEYSYMS.D then -- intercept D pressure
		loadNextSlide()
		capture = true
	elseif key == KEYSYMS.Q then -- intercept Q pressure
		loadPrevSlide()
		capture = true
	elseif key == KEYSYMS.ESCAPE then -- intercept ESCAPE pressure
		hideSlides()
		capture = true
	end
	return capture
end

function widget:Initialize()
  currentSlide = 0
  previousSlide = 0
  addFooter()
  loadNextSlide()
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------