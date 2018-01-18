function widget:GetInfo()
  return {
    name      = "Show PP Video",
    desc      = "Show the Prog&Play video at the beginning of the mission",
    author    = "muratet",
    date      = "Feb 21, 2017",
    license   = "GPL v2 or later",
    layer     = 200,
    enabled   = false
  }
end

-- You must import the KEYSYM table if you want to access keys by name
include('keysym.h.lua')
local json = VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local fontHandler = loadstring(VFS.LoadFile(LUAUI_DIRNAME.."modfonts.lua", VFS.ZIP_FIRST))()

local lang = Spring.GetModOptions()["language"] -- get the language

local winSizeX, winSizeY = widgetHandler:GetViewSizes()
local winCenterX = winSizeX/2
local winCenterY = winSizeY/2

local subtitles = {}
local currentSubtitleId = 1

local numFrame

local nbFiles = #VFS.DirList("Video")-1 -- -1 is for subtitle file

local halfVideoWidth = 250
local halfVideoHeight = 150
local VideoTextHeight = 50

function WordWrap(str, maxLineWidth) -- Width in pixels.
                                     -- TODO: Make it respect newlines.
  local insert = table.insert
  local concat = table.concat
  
  local wordArray = {}
  for word in string.gmatch(str, "[^%s]+") do
    insert(wordArray, word)
  end
  
  local firstWordInPiece = 1
  local lastWordInPiece = 1
  local lineArray = {}
  
  repeat
  
    local linePiece = concat(wordArray, " ", firstWordInPiece, lastWordInPiece)
    local strippedLinePiece = fontHandler.StripColors(linePiece)
    local pieceWidth = fontHandler.GetTextWidth(strippedLinePiece)
    
    if (pieceWidth >= maxLineWidth) then                    
      local line = concat(wordArray, " ", firstWordInPiece, lastWordInPiece-1)
      insert(lineArray, line)                     
      firstWordInPiece = lastWordInPiece
    end
    
    lastWordInPiece = lastWordInPiece + 1
    
  until (lastWordInPiece == #wordArray)
  
  -- Insert the last words in the lineArray
  local line
  if (#wordArray > 1) then
    line = concat(wordArray, " ", firstWordInPiece, lastWordInPiece)
    local strippedLine = fontHandler.StripColors(line)
    local lineWidth = fontHandler.GetTextWidth(strippedLine)
    if (lineWidth < maxLineWidth and line ~= "") then
      insert(lineArray, line)
    else
      -- There can be only one extra word, see the repeat/until loop.
      line = (concat(wordArray, " ", firstWordInPiece, lastWordInPiece-1))
      insert(lineArray, line)
      insert(lineArray, wordArray[#wordArray])
    end
  else
    lineArray = wordArray
  end
  
  return lineArray
end

function widget:Initialize()
	numFrame = 1
	subtitles = nil
	currentSubtitleId = 1
	if VFS.FileExists("Video/subtitles.json") then
		subtitles = json.decode(VFS.LoadFile("Video/subtitles.json"))
	end
	if Script.LuaUI.ToggleHelpButton then
		-- we want to hide help button during video playing
		Script.LuaUI.ToggleHelpButton() -- registered by pp_show_feedback.lua
	end
end

function widget:Update(dt)
	numFrame = numFrame + 25*dt
end

-- startingPos has to be smaller than targetPos
-- Warning !!! currentPos has to be included between startingPos and targetPos
-- if invertFade is false then compute color from black to white
-- if invertFade is true then compute color from white to black
local function computeTextColor (startingPos, currentPos, targetPos, invertFade)
	local shades ={"\000","\000","\000","\020","\040","\060","\080","\100","\120","\140","\160","\180","\200","\220","\240"}
	local shading
	-- compute percentage progression
	local ratio = (currentPos-startingPos)/(targetPos-startingPos)
	if (invertFade) then
		-- compute complement ratio
		ratio = 1-ratio
	end
	-- compute accurate shading depending on shades resolution
	shading = math.floor(ratio*(#shades-1))
	return "\255"..shades[shading+1]..shades[shading+1]..shades[shading+1]
end

function widget:DrawScreen()
	gl.Color(0, 0, 0, 1)
	gl.TexRect(0, 0, winSizeX, winSizeY)
	-- play video
	local numPicture = math.floor(numFrame)
	if numPicture > nbFiles then
		numPicture = nbFiles
	end
	gl.Color(1, 1, 1, 1)
	gl.Texture(":n:Video/"..numPicture..".jpg")
	gl.TexRect(winCenterX-halfVideoWidth, winCenterY-halfVideoHeight, winCenterX+halfVideoWidth, winCenterY+halfVideoHeight)
	gl.Texture(false)
	-- show subtitle
	if subtitles then
		local fadeDuration = 25
		local textColor = "\255\255\255\255" -- white color default
		if currentSubtitleId < #subtitles then
			-- check if current picture exceed next subtitle
			if numPicture >= subtitles[currentSubtitleId+1].startAt then
				currentSubtitleId = currentSubtitleId + 1
			end
			if numPicture < subtitles[currentSubtitleId].startAt+fadeDuration then
				textColor = computeTextColor (subtitles[currentSubtitleId].startAt, numPicture, subtitles[currentSubtitleId].startAt+fadeDuration, false)
			elseif numPicture > subtitles[currentSubtitleId+1].startAt - fadeDuration then
				textColor = computeTextColor (subtitles[currentSubtitleId+1].startAt-fadeDuration, numPicture, subtitles[currentSubtitleId+1].startAt, true)
			end
		end
		
		local lineArray = WordWrap(subtitles[currentSubtitleId][lang], halfVideoWidth*2)
		fontHandler.UseFont(LUAUI_DIRNAME.."Fonts/FreeSansBold_16")
		fontHandler.BindTexture()
		for line, text in ipairs(lineArray) do
			fontHandler.DrawStatic(textColor..text, winCenterX-halfVideoWidth, winCenterY-halfVideoHeight - ((fontHandler:GetFontSize()+3) * line))
		end
		gl.Texture(false)
	end
end

function widget:ViewResize(vsx, vsy)
	winSizeX, winSizeY = vsx, vsy
	winCenterX = winSizeX/2
	winCenterY = winSizeY/2
end

function widget:KeyPress(key, mods, isRepeat, label, unicode)
	-- intercept ESCAPE pressure
	if key == KEYSYMS.ESCAPE then
		widgetHandler:RemoveWidget() -- remove self
		return true
	end
end

function widget:Shutdown()
	if Script.LuaUI.ToggleHelpButton then
		-- If exists, we toggle show Help Button
		Script.LuaUI.ToggleHelpButton() -- registered by pp_show_feedback.lua
	end
end