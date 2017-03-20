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

local winSizeX, winSizeY = widgetHandler:GetViewSizes()
local winCenterX = winSizeX/2
local winCenterY = winSizeY/2

local play = true
local currentScene = 1
local numFrame = 0
local oldPicture = 0

local nbFiles = {
	#VFS.DirList("LuaUI/Widgets/Rooms/Video/part1"),
	#VFS.DirList("LuaUI/Widgets/Rooms/Video/part2"),
	#VFS.DirList("LuaUI/Widgets/Rooms/Video/part3")
}
-- this list containing pictures to display video
local halfVideoWidth = 250
local halfVideoHeight = 150
local VideoTextHeight = 50

local gray = "\255\75\75\75"
local white = "\255\200\200\200"
	
-- set text depending on language and video scene number
-- exemple:
-- 	text = {
-- 		language = {
--			{"first part text scene 1", ...},
--			{"first part text scene 2", ...},
--			...
-- 		},
-- 		...
-- 	}
-- This is a default exemple
local text = {
	fr = {
		{"Depuis l'invention de l'informatique, une \"guerre numérique\" fait rage au sein même des ordinateurs"},
		{"Deux alliances s'affrontent pour le contrôle de l'ensemble des systèmes informatiques"},
		{"Les combats s'enlisent depuis des cycles et des cycles dans un bataille ouverte où aucun des deux camps ne prend l'avantage"},
		{"Une initiative doit être tentée... ", "VOUS en êtes le protagoniste. ", "Appuyez sur Echap pour continuer"}
	},
	en = {
		{"From the beginning of computer science, a \"digital war\" has been rife inside computers"},
		{"Two alliances fight to control all systems"},
		{"For cycles and cycles, fighting are embroiled in an open battle where no alliance get advantage"},
		{"An initiative must be attempt... ", "This is YOUR responsability. ", "Press Escape to continue"}
	}
}

local function displayLoadingState()
	if lang == "fr" then
		return {white.."Chargement "..currentScene.."/3 "..math.floor(((numFrame/nbFiles[currentScene])*100)).."%"}
	else
		return {white.."Loading "..currentScene.."/3 "..math.floor(((numFrame/nbFiles[currentScene])*100)).."%"}
	end
end

-- startingPos has to be smaller than targetPos
-- Warning !!! currentPos has to be included between startingPos and targetPos
-- if invertFade is false then compute color from black to white
-- if invertFade is true then compute color from white to black
local function computeTextColor (startingPos, currentPos, targetPos, invertFade)
	local shades ={"\020","\040","\060","\080","\100","\120","\140","\160","\180","\200"}
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

local function displayStory(numPicture)
	-- set fade duration
	local fadeDuration = 25
	-- set text formated
	local textFormated = ""
	if currentScene == 1 or currentScene == 2 or currentScene == 3 then
		-- set text color (visibility) depending on current picture and fadeDuration
		local textColor
		if numPicture < fadeDuration then
			-- Make the text progressively visible (white)
			textColor = computeTextColor(0, numPicture, fadeDuration, false)
		elseif numPicture <= nbFiles[currentScene]-fadeDuration then
			-- Make the text visible
			textColor = white
		else
			-- Make the text progressively invisible (black)
			textColor = computeTextColor(nbFiles[currentScene]-fadeDuration, numPicture, nbFiles[currentScene], true)
		end
		-- Format text with computed color
		textFormated = textColor..text[lang][currentScene][1]
	elseif currentScene == 4 then
		-- Scene 4 is composed by three texts to fade separetely
		local fade
		-- Manage first part of the text
		if numPicture < fadeDuration then
			-- Make the first part of the text progressively visible (white)
			textFormated = computeTextColor(0, numPicture, fadeDuration, false)..text[lang][currentScene][1]
		else
			 -- fadeDuration is over => Display first part of the text in white
			textFormated = white..text[lang][currentScene][1]
		end
		-- Concatenate second part of the text if required
		if fadeDuration*2 <= numPicture and numPicture < fadeDuration*3 then
			-- Make the second part of the text progressively visible (white)
			textFormated = textFormated..computeTextColor(fadeDuration*2, numPicture, fadeDuration*3, false)..text[lang][currentScene][2]
		elseif fadeDuration*3 <= numPicture then
			 -- fadeDuration is over => Display second part of the text in white
			textFormated = textFormated..text[lang][currentScene][2]
		end
		-- Concatenete third part of the text if required
		if fadeDuration*4 <= numPicture then
			textFormated = textFormated..gray..text[lang][currentScene][3]
		end
	end
	return WordWrap(textFormated, Video.son.textWidth)
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
    closed = true,
    noMove = true,
	noBorder = true,
	x = 0,
	y = 0,
	x2 = halfVideoWidth*2,
	y2 = VideoTextHeight,
}

local template_VideoBackground = {
  closed = true,
  noMove = true,
  OnUpdate = 	function (dt, realSeconds)
					numFrame = numFrame + 25*dt
				end,
  OnDraw = 	function()
				gl.Color(0, 0, 0, 1)
				gl.TexRect(0, 0, winSizeX, winSizeY)
				if play then
					-- play video
					local numPicture = math.floor(numFrame)
					if numPicture > oldPicture + 2 then
						numFrame = numFrame - (numPicture - (oldPicture + 2))
						numPicture = oldPicture + 2
					end
					oldPicture = numPicture
					Video.son.lineArray = displayStory(numPicture)
					Video.son.dx = winCenterX-halfVideoWidth
					Video.son.dy = winCenterY-halfVideoHeight-VideoTextHeight
					if numPicture < nbFiles[currentScene] then
						gl.Color(1, 1, 1, 1)
						gl.Texture(getTextName(currentScene, numPicture))
						gl.TexRect(winCenterX-halfVideoWidth, winCenterY-halfVideoHeight, winCenterX+halfVideoWidth, winCenterY+halfVideoHeight)
						gl.Texture(false)
					else
						-- Swicth to next scene
						if currentScene == 3 then
							play = false
						end
						currentScene = currentScene + 1
						numFrame = 0
					end
				else
					local numPicture = math.floor(numFrame)
					Video.son.lineArray = displayStory(numPicture)
					Video.son.dy = winCenterY-VideoTextHeight/2
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
	template_VideoBackground.OnViewResized = function ()
		winSizeX, winSizeY = widgetHandler:GetViewSizes()
		winCenterX = winSizeX/2
		winCenterY = winSizeY/2
		Spring.Echo (winSizeX, winSizeY)
	end
	template_VideoBackground.son = Window:Create(template_Text)
	return Window:Create(template_VideoBackground)
end

Video = CreateFullScreenVideo ()
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------