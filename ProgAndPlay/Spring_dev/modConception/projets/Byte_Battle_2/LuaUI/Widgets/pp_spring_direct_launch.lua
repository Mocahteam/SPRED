
function widget:GetInfo()
	return {
		name = "Spring Direct Launch 2 for Prog&Play",
		desc = "Show some P&P menu when Spring.exe is run directly",
		author = "zwzsg, muratet",
		version = "2.9",
		date = "Jul 15, 2012",
		license = "Public Domain",
		layer = 209,
		enabled = true,
		handler = true, -- To see the real widgetHandler
	}
end


VFS.Include("LuaRules/Gadgets/libs/FillModSpecific.lua",nil)
VFS.Include("LuaRules/Gadgets/libs/ColorConversion.lua",nil)
VFS.Include("LuaRules/Gadgets/libs/GenerateGame.lua",nil)
VFS.Include("LuaRules/Gadgets/libs/WriteScript.lua",nil)

local IsActive = false
local HideView = false
local vsx,vsy = 0,0
local FramesList = {}
local FunctionsList = {}
local ActiveFrameIndex = nil
local MouseOveredFrameIndex = nil
local KeyboardFrameIndex = nil
local RemovedWidgetList = {}
local InitializeTimer = nil
local SDLG=nil
local ViewPoint=nil
local ScrollUp=nil
local ScrollDown=nil
local PreloadedMiniMapPics=nil

local function GetFromQuote(str)
	if type(str)~="string" then
		return str
	end
	local len=string.len(str)
	local last=string.sub(str,len,len)
	local first=string.sub(str,1,1)
	if last=="'" or last=='"' then
		str=string.sub(str,1,len-1)
		len=len-1
	end
	if first=="'" or first=='"' then
		str=string.sub(str,2,len)
		len=len-1
	end
	return loadstring("return"..str)()
end

local function Capitalize(str)
	return string.gsub (str, "(%w)(%w*)", function(a,b) return string.upper(a) .. b end)
end

local function JoinArrays(a1,a2)
	local a3={}
	local n=#a1
	for k=1,n do
		a3[k]=a1[k]
	end
	for k=1,#a2 do
		a3[n+k]=a2[k]
	end
	return a3
end

local function AddFrame(Text,Pos,FontSize,Color,FramePosition,TextPosition,Function,Param1,Param2,Param3)
	table.insert(FramesList,{Text=Text,Pos=Pos,FontSize=FontSize,Color=Color,FramePosition=FramePosition,TextPosition=TextPosition,Function=Function,Param1=Param1,Param2=Param2,Param3=Param3})
end

local function RemoveAllFrames()
	FramesList = {}
	ActiveFrameIndex = nil
	MouseOveredFrameIndex = nil
	KeyboardFrameIndex = nil
	ScrollUp=nil
	ScrollDown=nil
end

local function isAboveFrame(x,y,Frame)
	if type(x)~="number" or type(y)~="number" then
		x,y = Spring.GetMouseState()
	end
	if x>=Frame.Pos.xPosMin and x<=Frame.Pos.xPosMax and y>=Frame.Pos.yPosMin and y<=Frame.Pos.yPosMax then
		return true
	else
		return false
	end
end

function widget:IsAbove(x,y)
	if IsActive then
		return true
	else
		return false
	end
end

function widget:GetTooltip(x,y)
	return ""
end

local function Quit()
	Spring.SendCommands("quit")
	Spring.SendCommands("quitforce")
end

local function DoTheRestart(startscriptfilename)
	local n_fullscript=ModSpecific.ReloadScriptFileName
	local n_infologcopy="infolog.bak.txt"
	local complete=VFS.LoadFile(startscriptfilename)
	Spring.Echo(widget:GetInfo().name..": Wanting to reload \""..startscriptfilename.."\"")
	--Spring.Echo(widget:GetInfo().name..": that file contains:")
	--Spring.Echo("\n\n<<BEGIN DUMPING FULL \""..startscriptfilename.."\">>\n\n")
	--Spring.Echo(complete)
	--Spring.Echo("\n\n<<END DUMPING FULL \""..startscriptfilename.."\">>\n\n")
	complete,_=string.gsub(complete,"HostPort=[^;]*;","HostPort="..(0)..";",1)
	complete,_=string.gsub(complete,"GameType=[^;]*;","GameType="..ModSpecific.ModFileName..";",1)
	complete,_=string.gsub(complete,"Mapname=[^;]*;","Mapname="..CutOrAddMapSuffix(string.match(complete,"Mapname=([^;]*);"))..";",1)
	local file=io.open(n_fullscript,"wb")
	file:write(complete)
	file:flush()
	file:close()
	local trimmed=complete
	trimmed,_=string.gsub(trimmed,"//[^\r\n]-[\r\n]+","\n")-- Remove // comments
	trimmed,_=string.gsub(trimmed,"/%*.-%*/","")-- Remove /* comments */
	trimmed,_=string.gsub(trimmed,"%s-u%d+%s-%=[^;]*;","")-- Remove u123=...;
	trimmed,_=string.gsub(trimmed,"%s-f%d+%s-%=[^;]*;","")-- Remove f123=...;
	trimmed,_=string.gsub(trimmed,"%s-RemoveUnits+%s-%=[^;]*;","")-- Remove RemoveUnits=...;
	trimmed,_=string.gsub(trimmed,"%s-RemoveFeatures+%s-%=[^;]*;","")-- Remove RemoveFeatures=...;
	trimmed,_=string.gsub(trimmed,"%s-HeightMapV%d+%s-%=[^;]*;","")-- Remove HeightMapV2=...;
	if string.match(string.lower(startscriptfilename),"mission") then
		-- Insert name of mission script
		trimmed,_=string.gsub(trimmed,"([^%{]-%{[^%{]-{)(.*)","%1\n\t\tMissionScript="..startscriptfilename..";\n%2")
	end
	-- Insert name of full script
	trimmed,_=string.gsub(trimmed,"([^%{]-%{[^%{]-{)(.*)","%1\n\tFullScript="..n_fullscript..";\n%2")
	Spring.Echo("\n\n<<BEGIN DUMPING TRIMMED>>\n\n")
	Spring.Echo(trimmed)
	Spring.Echo("\n\n<<END DUMPING TRIMMED>>\n\n")
	params = "-s"
	if tonumber(Spring.GetConfigInt("safemode"))==1 then
		params = "--safemode "..params
	end
	Spring.Echo(widget:GetInfo().name..": Ok, calling Spring.Restart(\""..params.."\",\"[GAME]{..}\") now!")
	Spring.Echo("Making infolog.txt copy into "..n_infologcopy)
	local file=io.open(n_infologcopy,"wb")
	file:write(VFS.LoadFile("infolog.txt"))
	file:flush()
	file:close()
	Spring.Restart(params,trimmed)
	Spring.Echo(widget:GetInfo().name..": Just called Spring.Restart(\""..params.."\",\"[GAME]{..}\")")
	Spring.Echo(widget:GetInfo().name..": Wait, we shouldn't be here, should have restarted or crashed or quitted by now.")
end

local function RunScript(ScriptFileName)
	if Spring.Restart then
		DoTheRestart(ScriptFileName)
	else
		RemoveAllFrames()
		AddFrame("Kernel Panic!\nIntegrated Launcher",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
		AddFrame("Sorry! \"Spring.Restart\" Not available!",
			{x=vsx*0.5,y=vsy*0.6},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
		AddFrame("You have to manually pass the file\n"..ScriptFileName.."\n as an argument to "..ModSpecific.ExecutableFileName,
			{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.8,0.8,0,0.5},"cc","c",nil)
		AddFrame("Quit",{x=vsx*0.4,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Quit)
		AddFrame("Back",{x=vsx*0.6,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenu)
	end
end

local function MissionsMenu()
	RemoveAllFrames()
	AddFrame("Prog&Play!",{x=vsx*0.5,y=vsy*0.98},vsy/14,{0,1,1,0.5},"ct","c")
	local MissionsList=JoinArrays(VFS.DirList("Missions/"..Game.modShortName),VFS.DirList("Missions"))
	local ItemSize=math.min((vsy*(1-1/6))/(2*(#MissionsList+1))-2,vsy/24)
	for MissionIndex,MissionFileName in ipairs(MissionsList) do
		local EndIndex=(string.find(MissionFileName,".",string.len(MissionFileName)-4,true) or 1+string.len(MissionFileName))-1
		local BeginIndex=1
		repeat
			local NewBeginIndex=string.find(MissionFileName,"/",BeginIndex,true) or string.find(MissionFileName,"\\",BeginIndex,true)
			BeginIndex=NewBeginIndex and NewBeginIndex+1 or BeginIndex
		until not NewBeginIndex
		AddFrame(Capitalize(string.sub(MissionFileName,BeginIndex,EndIndex)),{x=vsx*0.5,y=vsy*(1-1/6)-2*MissionIndex*(2+ItemSize)},ItemSize,{0,1,0,0.5},"cb","c",RunScript,MissionFileName)
	end
	AddFrame("Quit",{x=vsx*0.5,y=0},ItemSize*0.8,{0,0,1,0.5},"cb","c",FunctionsList.Quit)
end

local function MainMenu()
	RemoveAllFrames()
	MissionsMenu()
end

local function DrawFrame(Frame)

	local Text = Frame.Text
	local Texture = nil
	local x = Frame.Pos.x
	local y = Frame.Pos.y
	local FontSize = Frame.FontSize
	local bg_red = Frame.Color[1] or (Frame.Function and 0.7 or 0.2)
	local bg_green = Frame.Color[2] or (Frame.Function and 0.7 or 0.2)
	local bg_blue = Frame.Color[3] or (Frame.Function and 0.7 or 0.2)
	local bg_alpha = Frame.Color[4] or 0.5
	local FramePosition = Frame.FramePosition
	local TextPosition = Frame.TextPosition

	if type(Text)=="function" then
		Text=Text()
	end
	if type(Text)=="table" then
		Texture,Text=Text.texture,Text.text
	end
	if type(Text)~="string" then
		Text=tostring(Text)
	end
	if type(x)~="number" then
		x=vsx/2
	end
	if type(y)~="number" then
		y=vsy/2
	end
	if type(FontSize)~="number" then
		FontSize=20
	end
	if type(bg_red)~="number" or type(bg_green)~="number" or type(bg_blue)~="number" then
		bg_red = 1
		bg_green = 1
		bg_blue = 1
	end
	if type(bg_alpha)~="number" then
		bg_alpha = 0.2
	end

	local txtLinesList = {}
	local maxTxtWidth = 0
	for line in string.gmatch(Text,"[^\r\n]+") do
		table.insert(txtLinesList,line)
		if gl.GetTextWidth(line)>maxTxtWidth then
			maxTxtWidth=gl.GetTextWidth(line)
		end
	end

	local TextWidthFixHack = 1
	if tonumber(string.sub(Game.version,1,4))<=0.785 and string.sub(Game.version,1,5)~="0.78+" then
		TextWidthFixHack = (vsx/vsy)*(4/3)
	end
	local xFramedTextSize=FontSize*(1+maxTxtWidth*TextWidthFixHack)
	local yFramedTextSize=FontSize*(1+#txtLinesList)
	if Texture then
		gl.Texture(Texture)
		local TextureInfo=gl.TextureInfo(Texture)
		xFramedTextSize,yFramedTextSize=TextureInfo.xsize,TextureInfo.ysize
		xFramedTextSize,yFramedTextSize=0.3*vsx,0.3*vsx*yFramedTextSize/xFramedTextSize
	end
	local xPosMin = x-xFramedTextSize/2
	local xPosMax = x+xFramedTextSize/2
	local yPosMin = y-yFramedTextSize/2
	local yPosMax = y+yFramedTextSize/2

	if type(FramePosition)=="string" and string.len(FramePosition)==2 then
		if string.sub(FramePosition,1,1)=='c' then
			xPosMin = x - xFramedTextSize/2
			xPosMax = x + xFramedTextSize/2
		elseif string.sub(FramePosition,1,1)=='r' then
			xPosMin = x - xFramedTextSize
			xPosMax = x
		elseif string.sub(FramePosition,1,1)=='l' then
			xPosMin = x
			xPosMax = x + xFramedTextSize
		else
			Spring.Echo("Wrong FramePosition[1] in "..widget:GetInfo().name.."'s DrawFramedText",string.sub(FramePosition,1,1))
		end
		if string.sub(FramePosition,2,2)=='c' then
			yPosMin = y - yFramedTextSize/2
			yPosMax = y + yFramedTextSize/2
		elseif string.sub(FramePosition,2,2)=='t' or string.sub(FramePosition,2,2)=='u' then
			yPosMin = y - yFramedTextSize
			yPosMax = y
		elseif string.sub(FramePosition,2,2)=='b' or string.sub(FramePosition,2,2)=='d' then
			yPosMin = y
			yPosMax = y + yFramedTextSize
		else
			Spring.Echo("Wrong FramePosition[2] in "..widget:GetInfo().name.."'s DrawFramedText")
		end
	else
		Spring.Echo("Wrong FramePosition in "..widget:GetInfo().name.."'s DrawFramedText",string.sub(FramePosition,2,2))
	end

	Frame.Pos={x=Frame.Pos.x, y=Frame.Pos.y, xPosMin=xPosMin, xPosMax=xPosMax, yPosMin=yPosMin, yPosMax=yPosMax, xFramedTextSize=xFramedTextSize, yFramedTextSize=yFramedTextSize}

	if Frame.Function and isAboveFrame(nil,nil,Frame) then
		MouseOveredFrameIndex  = Frame.Index
		ActiveFrameIndex = Frame.Index
	end

	if ActiveFrameIndex ~= MouseOveredFrameIndex and not KeyboardFrameIndex then
		ActiveFrameIndex = nil
	end

	if Frame.Index==ActiveFrameIndex then
		bg_red = 1 - (1 - bg_red)/2
		bg_green = 1 - (1 - bg_green)/2
		bg_blue = 1 - (1 - bg_blue)/2
		bg_alpha = 1 - (1 - bg_alpha)/2
	end

	if Texture then
		gl.Color(1,1,1,bg_alpha)
		gl.TexRect(xPosMin,yPosMin,xPosMax,yPosMax)
		gl.Texture(false)
	else
		gl.Color(bg_red,bg_green,bg_blue,bg_alpha/2)
		gl.Rect(xPosMin,yPosMin,xPosMax,yPosMax)
	end
	gl.Color(1,1,1,bg_alpha)
	for n,_ in ipairs(txtLinesList) do
		if TextPosition=="c" then
			gl.Text(txtLinesList[n], (xPosMin+xPosMax)/2, yPosMax+(-0.5-n)*FontSize, FontSize, "cod")
		elseif TextPosition=="r" then
			gl.Text(txtLinesList[n], xPosMax-FontSize/2, yPosMax+(-0.5-n)*FontSize, FontSize, "rod")
		else
			gl.Text(txtLinesList[n], xPosMin+FontSize/2, yPosMax+(-0.5-n)*FontSize, FontSize, "od")
		end
	end
	if not Texture then
		gl.Color(bg_red,bg_green,bg_blue,bg_alpha/2)
		gl.Rect(xPosMin,yPosMin,xPosMax,yPosMax)
		gl.Color(bg_red,bg_green,bg_blue,bg_alpha)
		gl.LineWidth(FontSize/4)
		gl.Shape(GL.LINES,{
			{v={xPosMin+FontSize/4,yPosMax-FontSize/8}},
			{v={xPosMax-FontSize/4,yPosMax-FontSize/8}},
			{v={xPosMax-FontSize/8,yPosMax}},
			{v={xPosMax-FontSize/8,yPosMin}},
			{v={xPosMax-FontSize/4,yPosMin+FontSize/8}},
			{v={xPosMin+FontSize/4,yPosMin+FontSize/8}},
			{v={xPosMin+FontSize/8,yPosMin}},
			{v={xPosMin+FontSize/8,yPosMax}},})
	end
	gl.Color(1,1,1,1)
end


local function EitherDrawScreen(self)

	if not PreloadedMiniMapPics then
		PreloadedMiniMapPics=true
	end

	-- Nothing until screen size is known
	if vsx==nil or vsy==nil or vsx==0 or vsy==0 or not IsActive then
		return
	end

	-- Remove (make yellow) all other widgets after 0.7s
	if InitializeTimer and Spring.DiffTimers(Spring.GetTimer(),InitializeTimer)>0.7 then
		InitializeTimer = false
		RemovedWidgetList = {}
		local RemovedWidgetListName = {}
		for name,kw in pairs(widgetHandler.knownWidgets) do
			if kw.active and name ~= self:GetInfo().name then
				table.insert(RemovedWidgetListName,name)
			end
		end
		for _,w in pairs(widgetHandler.widgets) do
			for _,name in pairs(RemovedWidgetListName) do
				if w.GetInfo().name == name then
					table.insert(RemovedWidgetList,w)
				end
			end
		end
		for _,w in pairs(RemovedWidgetList) do
			Spring.Echo("Removing",w.GetInfo().name)
			widgetHandler:RemoveWidget(w)
		end
		Spring.Echo("The line below may complain about 'w' being nil, that is normal, and a result of my closing all widgets.")
		Spring.SendCommands({"hideinterface 1","showhealthbars 0"}) -- In case action finder and HealthBars had unhidden them
	end

	-- If no menu shown, then show the first menu
	if #FramesList==0 then
		FunctionsList.MainMenu()
	end

	if HideView then
		-- Draw background texture
		local BackgroundTexture = "bitmaps/frame.tga"
		gl.Blending(false)
		gl.Color(0.2,0.2,0,1)
		gl.Texture(BackgroundTexture)
		gl.TexRect(0,0,vsx,vsy,0,0,vsx/128,vsy/96)
		gl.Texture(false)
	end

	if ViewPoint then
		Spring.SetCameraState(ViewPoint,0)
	end

	-- Draw the elements
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
	gl.Color(1,1,1,1)
	gl.Text("Spring\n"..Game.version,4,4,12,"ob")
	gl.Text(Game.modShortName.."\n"..Game.modVersion,vsx-4,4,12,"rob")
	MouseOveredFrameIndex=nil
	for Index,Frame in ipairs(FramesList) do
		Frame.Index=Index
		DrawFrame(Frame)
	end
end


function widget:DrawScreenEffects(dse_vsx, dse_vsy)
	vsx, vsy = dse_vsx, dse_vsy
	if Spring.IsGUIHidden() then
		EitherDrawScreen(self)
	end
end


function widget:DrawScreen()
	if not Spring.IsGUIHidden() then
		EitherDrawScreen(self)
	end
end


function widget:MousePress(x,y,button)
	if IsActive then
		for _,Frame in ipairs(FramesList) do
			if isAboveFrame(x,y,Frame) then
				if Frame.Function then
					Frame.Function(Frame.Param1,Frame.Param2,Frame.Param3)
					return true
				end
			end
		end
	end
end

local function SwitchOn(menu)
	if not IsActive then
		IsActive = true
		RemoveAllFrames()
		if type(menu)=="function" then
			menu()
		end
		Spring.SendCommands("endgraph 0")
		Spring.SendCommands("hideinterface 1")
	end
end


local function SwitchOff()
	if IsActive then
		IsActive = false
		RemoveAllFrames()
		Spring.SendCommands("endgraph 1")
		Spring.SendCommands("hideinterface 0")
	end
end

local function SwitchOffNoEndGraph()
	if IsActive then
		IsActive = false
		RemoveAllFrames()
		Spring.SendCommands("endgraph 0")
		Spring.SendCommands("hideinterface 0")
	end
end

local function BetterizeRandom()
	local x,y=Spring.GetMouseState()
	local BetterRand=math.floor(99*(os.clock()%99999)+(99*(os.time())%99999))+Spring.GetDrawFrame()+math.random(0,999)
	for k=-5,BetterRand%100 do
		math.random(0,999)
	end
end

function widget:KeyPress(key)
	local up_arrow,down_arrow,right_arrow,left_arrow,enter,space,esc,del,tab = 273,274,275,276,13,32,27,127,9
	if key==esc then
		local _,cmd=Spring.GetActiveCommand()
		local alt,ctrl,meta,shift=Spring.GetModKeyState()
		if not alt and not ctrl and not meta and not shift and not cmd then
			if IsActive and not HideView then
				if ViewPoint then
					Spring.SendCommands({'NoSound 0'}) -- Re-enable sounds when pressing esc after direct running Spring.exe
					ViewPoint=nil
				end
				FunctionsList.SwitchOff()
				return true
			elseif IsActive and HideView then
				HideView=false
				Spring.SendCommands("endgraph 0")
				Spring.SendCommands("hideinterface 1")
				Spring.SendCommands({'NoSound 0'}) -- Re-enable sounds when pressing esc after direct running Spring.exe
				return true
			else
				FunctionsList.SwitchOn()
				return true
			end
		end
	end

	for _,hotkey in ipairs(Spring.GetActionHotKeys("savegame")) do
		local keysym=hotkey:gsub('^.*[^+]%+', '')
		if key==Spring.GetKeyCode(keysym) then
			local alt,ctrl,meta,shift=Spring.GetModKeyState()
			hotkey=string.lower(hotkey)
			local function BothOrNeither(a,b) return (a and b) or ((not a) and (not b)) end
			if hotkey:match("any")
			or (BothOrNeither(alt,hotkey:match("alt"))
			and BothOrNeither(ctrl,hotkey:match("ctrl"))
			and BothOrNeither(meta,hotkey:match("meta"))
			and BothOrNeither(shift,hotkey:match("shift"))) then
				if not ShutterAnim then
					if IsActive then
						FunctionsList.SwitchOff()
					else
						FunctionsList.SwitchOn(FunctionsList.SaveLoadMenu)
					end
				end
				return true
			end
		end
	end

	if IsActive then
		if key==up_arrow or key==left_arrow then
			if not ActiveFrameIndex then
				for Index,Frame in ipairs(FramesList) do
					if Frame.Function then
						ActiveFrameIndex = Index
					end
				end
			else
				local NewFrameIndex = ActiveFrameIndex
				for Index,Frame in ipairs(FramesList) do
					if Frame.Function and Index<ActiveFrameIndex then
						NewFrameIndex = Index
					end
				end
				ActiveFrameIndex = NewFrameIndex
			end
		KeyboardFrameIndex = ActiveFrameIndex
		elseif key==down_arrow or key==right_arrow or key==tab then
			if key==tab and ActiveFrameIndex==#FramesList then
				ActiveFrameIndex=nil
			end
			if not ActiveFrameIndex then
				for Index,Frame in ipairs(FramesList) do
					if Frame.Function then
						ActiveFrameIndex = Index
						break
					end
				end
			else
				for Index,Frame in ipairs(FramesList) do
					if Frame.Function and Index>ActiveFrameIndex then
						ActiveFrameIndex = Index
						break
					end
				end
			end
		KeyboardFrameIndex = ActiveFrameIndex
		elseif key==enter or key==space then
			if ActiveFrameIndex and FramesList[ActiveFrameIndex] and FramesList[ActiveFrameIndex].Function then
				FramesList[ActiveFrameIndex].Function(FramesList[ActiveFrameIndex].Param1,FramesList[ActiveFrameIndex].Param2,FramesList[ActiveFrameIndex].Param3)
				return true
			end
		elseif key==del then
			local FrameIndex=ActiveFrameIndex or MouseOveredFrameIndex or KeyboardFrameIndex
			if FrameIndex and FramesList[FrameIndex] and FramesList[FrameIndex].Param2 then
				local ActiveSave=FramesList[FrameIndex].Param2
				if ActiveSave.FileName then
					Spring.Echo("Deleting "..ActiveSave.FileName)
					os.remove(ActiveSave.FileName)
					FunctionsList.PseudoLoad(20*math.floor(ActiveSave.Index/20))
					return true
				end
			end
		end
		if key==up_arrow or key==left_arrow or key==down_arrow or key==right_arrow or key==enter or key==space or key==tab then
			return true
		end
	end
end

function widget:GameOver()
	-- Turn on menu
	FunctionsList.SwitchOn(GameOverMenu)
end

function widget:Initialize()
	BetterizeRandom()
	IsActive = false
	FunctionsList={MainMenu=MainMenu,Quit=Quit,
		MissionsMenu=MissionsMenu,SwitchOn=SwitchOn,SwitchOff=SwitchOff,SwitchOffNoEndGraph=SwitchOffNoEndGraph}
	FramesList={}
	FillModSpecific()
	SDLG=GenerateSkirmish()
	if tonumber(Spring.GetConfigInt("snd_volmaster"))==1 then
		Spring.SetConfigInt("snd_volmaster",100)
	end
	if Spring.GetModOptions()["hidemenu"]==nil then
		Spring.Echo("affichage du menu")
		Spring.SendCommands({'NoSound 1'}) -- Disable sound when menu pops up straight after running Spring.exe
		ViewPoint=Spring.GetModOptions()["viewpoint"] or Spring.GetModOptions()["viewpoint0"] or Spring.GetModOptions()["viewpoint1"]
		ViewPoint=GetFromQuote(ViewPoint)
		InitializeTimer = Spring.GetTimer()
		HideView = (ViewPoint==nil)
		FunctionsList.SwitchOn()
	elseif #Spring.GetPlayerList()>1 then
		widgetHandler:RemoveWidget(self) -- Disable the menu in multiplayer games
	end
	-- disable a set of widgets
	-- widget named : Kernel Panic Mission Briefing
	widgetHandler:DisableWidget("Kernel Panic Mission Briefing")
	-- widget named : Kernel Panic Automatic Tip Dispenser
	widgetHandler:DisableWidget("Kernel Panic Automatic Tip Dispenser")
	-- widget named : Spring Direct Launch 2
	widgetHandler:DisableWidget("Spring Direct Launch 2")
	
	-- disable console
	Spring.SendCommands("console 0")
	-- minimize minimap
	Spring.SendCommands("minimap min")
end


function widget:Shutdown()
	FunctionsList.SwitchOff()
end

