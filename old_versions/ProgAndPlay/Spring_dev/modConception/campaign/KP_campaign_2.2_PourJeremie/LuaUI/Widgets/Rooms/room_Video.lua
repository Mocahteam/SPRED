--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Room Info
--
--
-- Video Window.
-- Licensed under the terms of the GNU GPL, v2 or later.
-- See LuaUI/Widgets/Rooms/documentation.txt for documentation.
--
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local lang = Spring.GetModOptions()["language"] -- get the language

local openState = tonumber(Spring.GetModOptions()["startingmission"])~=1 -- compute openState depending on startingMission

local winSizeX, winSizeY = Spring.GetWindowGeometry()

local loading = true
local play = false
local currentScene = 1
local numFrame = 0
local oldPicture = 0

local nbFiles = {
	#VFS.DirList("LuaUI/Widgets/Rooms/Video/part1"),
	#VFS.DirList("LuaUI/Widgets/Rooms/Video/part2"),
	#VFS.DirList("LuaUI/Widgets/Rooms/Video/part3")
}
local arrayDisplayList = {}
local videoWidth = 500
local videoHeight = 300
local VideoTextHeight = 50
local x1 = (winSizeX-videoWidth)/2
local y1 = (winSizeY-videoHeight)/2
local x2 = x1 + videoWidth
local y2 = y1 + videoHeight

local gray = "\255\75\75\75"
local white = "\255\200\200\200"
local shades ={"\020","\040","\060","\080","\100","\120","\140","\160","\180","\200"}
local function displayLoadingState()
	if lang == "fr" then
		return {white.."Chargement "..currentScene.."/3 "..math.floor(((numFrame/nbFiles[currentScene])*100)).."%"}
	else
		return {white.."Loading "..currentScene.."/3 "..math.floor(((numFrame/nbFiles[currentScene])*100)).."%"}
	end
end

local function displayStory(numPicture)
	local text = ""
	local textColor
	local timeFondue = 25
	if numPicture >= timeFondue then
		if numPicture <= #arrayDisplayList-timeFondue then
			textColor = white
		else
			local num = math.floor((#arrayDisplayList-numPicture)*9/timeFondue)
			if num < 0 then num = 0 end
			textColor = "\255"..shades[num+1]..shades[num+1]..shades[num+1]
		end
	else
		local num = math.floor(numPicture*9/timeFondue)
		textColor = "\255"..shades[num+1]..shades[num+1]..shades[num+1]
	end
	if lang == "fr" then
		if currentScene == 1 then
			text = textColor.."Depuis l'invention de l'informatique, une \"guerre numérique\" fait rage au sein même des ordinateurs"
		elseif currentScene == 2 then
			text = textColor.."Deux alliances s'affrontent pour le contrôle de l'ensemble des systèmes informatiques"
		elseif currentScene == 3 then
			text = textColor.."Les combats s'enlisent depuis des cycles et des cycles dans un bataille ouverte où aucun des deux camps ne prend l'avantage"
		elseif currentScene == 4 then
			local fondue
			if numPicture < timeFondue then
				fondue = math.floor(numPicture*9/timeFondue)
				text = "\255"..shades[fondue+1]..shades[fondue+1]..shades[fondue+1].."Une initiative doit être tentée..."
			elseif numPicture < timeFondue*2 then
				text = white.."Une initiative doit être tentée..."
			elseif numPicture < timeFondue*3 then
				fondue = math.floor((numPicture-timeFondue*2)*9/timeFondue)
				text = white.."Une initiative doit être tentée...\255"..shades[fondue+1]..shades[fondue+1]..shades[fondue+1].." VOUS en êtes le protagoniste."
			elseif numPicture < timeFondue*4 then
				text = white.."Une initiative doit être tentée... VOUS en êtes le protagoniste."
			else
				text = white.."Une initiative doit être tentée... VOUS en êtes le protagoniste. "..gray.."Appuyez sur Echap pour continuer"
			end
		end
	else
		if currentScene == 1 then
			text = textColor.."From the beginning of computer science, a \"digital war\" has been rife inside computers"
		elseif currentScene == 2 then
			text = textColor.."Two alliances fight to control all systems"
		elseif currentScene == 3 then
			text = textColor.."For cycles and cycles, fighting are embroiled in an open battle where no alliance get advantage"
		elseif currentScene == 4 then
			local fondue
			if numPicture < timeFondue then
				fondue = math.floor(numPicture*9/timeFondue)
				text = "\255"..shades[fondue+1]..shades[fondue+1]..shades[fondue+1].."An initiative must be attempt..."
			elseif numPicture < timeFondue*2 then
				text = white.."An initiative must be attempt..."
			elseif numPicture < timeFondue*3 then
				fondue = math.floor((numPicture-timeFondue*2)*9/timeFondue)
				text = white.."An initiative must be attempt...\255"..shades[fondue+1]..shades[fondue+1]..shades[fondue+1].." This is YOUR responsability."
			elseif numPicture < timeFondue*4 then
				text = white.."An initiative must be attempt... This is YOUR responsability."
			else
				text = white.."An initiative must be attempt... This is YOUR responsability."..gray.." Press Escape to continue"
			end
		end
	
	end
	return WordWrap(text, Video.son.textWidth)
end

local function getTextName (numScene, num)
	local baseName = ":n:LuaUI/Widgets/Rooms/Video/part"..numScene.."/scene"..numScene
	if numScene == 2 then
		num = num + 170
	end
	if num >= 0 and num < 10 then
		return baseName.."0000"..num..".jpg"
	elseif num < 100 then
		return baseName.."000"..num..".jpg"
	elseif num < 1000 then
		return baseName.."00"..num..".jpg"
	elseif num < 10000 then
		return baseName.."0"..num..".jpg"
	elseif num < 100000 then
		return baseName..num..".jpg"
	end
end


local template_Text = {
    closed = openState,
    noMove = true,
	noBorder = true,
	x = 0,
	y = 0,
	x2 = videoWidth,
	y2 = VideoTextHeight,
}

local template_VideoBackground = {
  closed = openState,
  noMove = true,
  bottomLeftColor = {0, 0, 0, 1},
  topLeftColor = {0, 0, 0, 1},
  topRightColor = {0, 0, 0, 1},
  bottomRightColor = {0, 0, 0, 1},
  x = 0,
  y = 0,
  x2 = winSizeX,
  y2 = winSizeY,
  OnUpdate = 	function (dt, realSeconds)
					if not loading then
						numFrame = numFrame + 25*dt
					end
				end,
  OnDraw = 	function()
				if loading then
					-- load video
					local i = numFrame
					-- set limit to load for this frame
					local limit
					local step = 5
					if i + step < nbFiles[currentScene] then
						limit = i + step
					else
						limit = nbFiles[currentScene]
					end
					-- load pictures
					while i <= limit do
						arrayDisplayList[i] = gl.CreateList( function()
							gl.Color(1, 1, 1, 1)
							gl.Texture(getTextName(currentScene, i))
							gl.TexRect(x1, y1, x2, y2)
							gl.Texture(false)
						end)
						i = i + 1
					end
					numFrame = i
					Video.son.dy = 0
					Video.son.lineArray = displayLoadingState()
					if numFrame > nbFiles[currentScene] then
						-- set to play video
						loading = false
						play = true
						numFrame = 0
					end
				elseif play then
					-- play video
					local numPicture = math.floor(numFrame)
					if numPicture > oldPicture + 2 then
						numFrame = numFrame - (numPicture - (oldPicture + 2))
						numPicture = oldPicture + 2
					end
					oldPicture = numPicture
					Video.son.lineArray = displayStory(numPicture)
					Video.son.dy = math.floor(-(videoHeight/2+VideoTextHeight/2))
					if numPicture < #arrayDisplayList then
						gl.CallList(arrayDisplayList[numPicture])
					else
						-- delete displayed texture
						local i = 0
						for i = 1,nbFiles[currentScene] do
							gl.DeleteList(arrayDisplayList[i])
							gl.DeleteTexture(getTextName(currentScene, i))
						end
						if currentScene < 3 then
							-- set to loading the next scene
							loading = true
						end
						play = false
						currentScene = currentScene + 1
						numFrame = 0
					end
				else
					local numPicture = math.floor(numFrame)
					Video.son.lineArray = displayStory(numPicture)
					Video.son.dy = 0
					-- check if we need to emulate 'esc'
					-- if Script.LuaUI.EmulateEscapeKey and numFrame > 250 then
						-- Script.LuaUI.EmulateEscapeKey()
						-- escEmulated = true
						-- Spring.SendCommands("nosound")
						-- play = false
						-- loading = false
						-- numFrame = 0
					-- end
				end
				Video.son:BringToFront()
			end,
}

local function CreateFullScreenVideo ()
	template_VideoBackground.son = Window:CreateCentered(template_Text)
	-- disable sound
	if not openState then
		Spring.SendCommands("nosound")
	end
	return Window:CreateCentered(template_VideoBackground)
end

Video = CreateFullScreenVideo ()
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------