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

VFS.Include("LuaUI/Widgets/libs/RestartScript.lua",nil) -- contain DoTheRestart function
VFS.Include("LuaUI/Widgets/libs/Pickle.lua",nil) 

-- load Appliq XML
VFS.Include("LuaUI/Widgets/libs/context.lua")
contx=context:new("C:/Users/Bruno/Documents/ProgPlayLIP6/spring-0.82.5.1/",rootDirectory,"LuaUI/Widgets/libs/") -- Not sure that spring is working
Spring.Echo(contx.springIsAvailable)
VFS.Include("LuaUI/Widgets/libs/AppliqManager.lua")
local AppliqManager=appliqManager:new("Appliq/exempleKP23.xml")
AppliqManager:parse()
--AppliqManager:fullTest()

local IsActive = false
local HideView = false
-- Screen width in pixels
local vsx = 0
-- Screen height in pixels
local vsy = 0
local FunctionsList = {}
local RemovedWidgetList = {}
local InitializeTimer = nil
local SDLG=nil
local ViewPoint=nil
local PreloadedMiniMapPics=nil
-- Current language selection
local lang = "en"
-- Define text menu depending on language selection
local TextLocale = {
	fr = {back="Retour", continue="Continuer la dernière partie", SelectScenario="Nouvelle partie", quit="Quitter", specificMission="Jouer une mission précise", whichScenario="Choisissez un scenario", whichMission="Choisissez une mission"},
	en = {back="Back", continue="Continue previous game", SelectScenario="New game", quit="Quit", specificMission="Play a specific mission", whichScenario="Choose a scenario", whichMission="Choose a mission"}
}
local FramesList = {}
local ActiveFrameIndex = nil
local MouseOveredFrameIndex = nil
local KeyboardFrameIndex = nil
local ScrollUp=nil
local ScrollDown=nil

function RemoveAllFrames()
	FramesList = {}
	ActiveFrameIndex = nil
	MouseOveredFrameIndex = nil
	KeyboardFrameIndex = nil
	ScrollUp=nil
	ScrollDown=nil
end

function AddFrame(Text,Pos,FontSize,Color,FramePosition,TextPosition,Function,Param1,Param2,Param3)
	table.insert(FramesList,{Text=Text,Pos=Pos,FontSize=FontSize,Color=Color,FramePosition=FramePosition,TextPosition=TextPosition,Function=Function,Param1=Param1,Param2=Param2,Param3=Param3})
end


local function NoRestart()
  RemoveAllFrames()
  AddFrame("Kernel Panic!\nIntegrated Launcher",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
  AddFrame("Sorry! \"Spring.Restart\" Not available!",
    {x=vsx*0.5,y=vsy*0.6},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
  AddFrame("Quit",{x=vsx*0.4,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Quit)
  AddFrame("Back",{x=vsx*0.6,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenu)
end

local function RunScenario(i)
  if Spring.Restart then
    AppliqManager:selectScenario(i)
    AppliqManager:startRoute()
    AppliqManager:setProgression({"1630","1638"})
    --AppliqManager:next("1630")
    local mission=AppliqManager:getActivityNameFromId(AppliqManager.currentActivityID)
    local currentInput=AppliqManager:getCurrentInputName()
    Spring.Echo(currentInput)
    local options={
    ["MODOPTIONS"]=
      {
      ["scenariomode"]="appliq",
      ["language"]=lang,
      ["scenario"]=i, --Todo: Should be an id instead
      ["missionname"]=mission,
      ["currentinput"]=currentInput,
      ["progression"]=pickle(AppliqManager.progressionOutputs)
      }
    }
    DoTheRestart("Missions/"..Game.modShortName.."/"..mission..".txt", options)
  else
    NoRestart()
  end
end

local function MainMenu()
	RemoveAllFrames()
	AddFrame("Prog&Play!",{x=vsx*0.5,y=vsy*0.98},vsy/14,{0,1,1,0.5},"ct","c")
	AddFrame("Français",{x=vsx*0.46,y=vsy*0.5},vsy/18,{0,1,0,0.5},"rc","c",FunctionsList.French)
	AddFrame("English",{x=vsx*0.54,y=vsy*0.5},vsy/18,{0,1,0,0.5},"lc","c",FunctionsList.English)
	
	AddFrame(TextLocale[lang].quit,{x=vsx*0.5,y=vsy*0.0},vsy/18,{0,0,1,0.5},"cb","c",FunctionsList.Quit)
end

local function French()
	lang = "fr"
	FunctionsList.NewGameOrContinue()
end

local function English()
	lang = "en"
	FunctionsList.NewGameOrContinue()
end

local function Quit()
	Spring.SendCommands("quit")
	Spring.SendCommands("quitforce")
end

local function Capitalize(str)
	return string.gsub (str, "(%w)(%w*)", function(a,b) return string.upper(a) .. b end)
end

local function RunScript(ScriptFileName, scenario)
	if Spring.Restart then
	local operations={
  ["MODOPTIONS"]=
    {
    ["language"]=lang,
    ["scenario"]=scenario
    }
  }
		DoTheRestart(ScriptFileName, operations)
	else
    NoRestart()
	end
end

local function MissionsMenu()
	RemoveAllFrames()
	AddFrame("Prog&Play! "..TextLocale[lang].whichMission,{x=vsx*0.5,y=vsy*0.98},vsy/14,{0,1,1,0.5},"ct","c")
	local MissionsList=VFS.DirList("Missions/"..Game.modShortName)
	local ItemSize=math.min((vsy*(1-1/6))/(2*(#MissionsList+1))-2,vsy/24)
	for MissionIndex,MissionFileName in ipairs(MissionsList) do
		local EndIndex=(string.find(MissionFileName,".",string.len(MissionFileName)-4,true) or 1+string.len(MissionFileName))-1
		local BeginIndex=1
		repeat
			local NewBeginIndex=string.find(MissionFileName,"/",BeginIndex,true) or string.find(MissionFileName,"\\",BeginIndex,true)
			BeginIndex=NewBeginIndex and NewBeginIndex+1 or BeginIndex
		until not NewBeginIndex
		AddFrame(Capitalize(string.sub(MissionFileName,BeginIndex,EndIndex)),{x=vsx*0.5,y=vsy*(1-1/6)-2*MissionIndex*(2+ItemSize)},ItemSize,{0,1,0,0.5},"cb","c",RunScript,MissionFileName, "noScenario")
	end
	AddFrame(TextLocale[lang].back,{x=vsx*0.5,y=0},ItemSize*0.8,{0,0,1,0.5},"cb","c",FunctionsList.NewGameOrContinue)
end

local function NewGameOrContinue()
		RemoveAllFrames()
		AddFrame("Prog&Play!",{x=vsx*0.5,y=vsy*0.98},vsy/14,{0,1,1,0.5},"ct","c")
		-- Adding new game and continue button
		AddFrame(TextLocale[lang].SelectScenario,{x=vsx*0.5,y=vsy*0.65},vsy/18,{0,1,0,0.5},"cc","c",FunctionsList.SelectScenario)
		AddFrame(TextLocale[lang].specificMission,{x=vsx*0.5,y=vsy*0.5},vsy/18,{0,1,0,0.5},"cc","c",FunctionsList.MissionsMenu)
		-- Look for save game for this Mod
		if VFS.FileExists("Savegames/"..Game.modShortName..".sav") then
			AddFrame(TextLocale[lang].continue,{x=vsx*0.5,y=vsy*0.35},vsy/18,{0,1,0,0.5},"cc","c",FunctionsList.LoadPreviousGame)
		end
		-- Adding back button
		AddFrame(TextLocale[lang].back,{x=vsx*0.5,y=vsy*0.0},vsy/18,{0,0,1,0.5},"cb","c",FunctionsList.MainMenu)
end

local function SelectScenario()
    local numScenario
    if(AppliqManager~=nil) then
      numScenario = AppliqManager:scenarioGetN()
    else
      numScenario=0
    end  
    
    -- NORMAL PART
     
    RemoveAllFrames()
    AddFrame("Prog&Play! "..TextLocale[lang].whichScenario,{x=vsx*0.5,y=vsy*0.98},vsy/14,{0,1,1,0.5},"ct","c")
    -- compute maximum size of button (depending on scenario number + 1)
    
    -- create button for the default scenario
    local ItemSize=math.min((vsy*(1-1/6))/(2*(numScenario+2))-2,vsy/24)
    AddFrame("Digital War",{x=vsx*0.5,y=vsy*(1-1/6)-2*(2+ItemSize)},ItemSize,{0,1,0,0.5},"cb","c",RunScript,"Missions/"..Game.modShortName.."/Tutorial.txt")
    
-- APPLIQ PART 
  if(AppliqManager~=nil)then   
  	-- Look for scenario for this Mod
  	contx:Echo("we pick a scenario")
  	if AppliqManager:scenarioGetN() <= 0 then
    		-- Load default Game
    		RunScript("Missions/"..Game.modShortName.."/Tutorial.txt")
  	else
  		-- store number of scenario
  		-- Display available scenario
  
  		-- create all buttons (one for each scenario)
  		for i = 1,numScenario do
  			AddFrame(AppliqManager:scenarioGetName(i),{x=vsx*0.5,y=vsy*(1-1/6)-2*(i+1)*(2+ItemSize)},ItemSize,{0,1,0,0.5},"cb","c",RunScenario,i)
  			--function AddFrame(Text,Pos,FontSize,Color,FramePosition,TextPosition,Function,Param1,Param2,Param3)
  			--AddFrame(AppliqManager.scenarioGetTitle(i),{x=vsx*0.5,y=vsy*(1-1/6)-2*(i+1)*(2+ItemSize)},ItemSize,{0,1,0,0.5},"cb","c",RunScript,"Missions/"..Game.modShortName.."/"..AppliqManager.
		  end
  	end
	end

-- NORMAL PART 
  AddFrame(TextLocale[lang].back,{x=vsx*0.5,y=vsy*0.0},vsy/18,{0,0,1,0.5},"cb","c",FunctionsList.NewGameOrContinue)
end

local function LoadPreviousGame()
	RemoveAllFrames()
	AddFrame("LoadPreviousGame: TODO...",{x=vsx*0.5,y=vsy*0.98},vsy/14,{0,1,1,0.5},"ct","c")
	
	AddFrame(TextLocale[lang].back,{x=vsx*0.5,y=vsy*0.0},vsy/18,{0,0,1,0.5},"cb","c",FunctionsList.NewGameOrContinue)
end

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
		HideView = true
		RemoveAllFrames()
		if type(menu)=="function" then
			menu()
		end
		Spring.SendCommands("endgraph 0")
		Spring.SendCommands("hideinterface 1")
	end
end

-- store SwitchOn function on widget context. Then it will be possible to call
-- this function from an other widget with: WG.switchOnMenu()
WG.switchOnMenu = SwitchOn

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

function widget:Initialize()
	IsActive = false
	FunctionsList={
		MainMenu=MainMenu,
		Quit=Quit,
		MissionsMenu=MissionsMenu,
		French=French,
		English=English,
		SwitchOn=SwitchOn,
		SwitchOff=SwitchOff,
		SwitchOffNoEndGraph=SwitchOffNoEndGraph,
		LoadPreviousGame=LoadPreviousGame,
		SelectScenario=SelectScenario,
		NewGameOrContinue=NewGameOrContinue
	}
	FramesList={}
	FillModSpecific()
	SDLG=GenerateSkirmish()
	if tonumber(Spring.GetConfigInt("snd_volmaster"))==1 then
		Spring.SetConfigInt("snd_volmaster",100)
	end
	if Spring.GetModOptions()["hidemenu"]==nil then
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
	
	-- enable editor widgets only in editor, too hardcoded
	if (Spring.GetModOptions()["editor"] ~= "yes" or Spring.GetModOptions()["editor"]  == nil) then
		widgetHandler:DisableWidget("Editor User Interface")
		widgetHandler:DisableWidget("Kernel Panic Build Bar")
		widgetHandler:DisableWidget("Kernel Panic Tooltip")
	else
		widgetHandler:EnableWidget("Editor User Interface")
		widgetHandler:DisableWidget("Kernel Panic Build Bar")
		widgetHandler:DisableWidget("Kernel Panic Tooltip")
	end
end

function widget:Shutdown()
	FunctionsList.SwitchOff()
end

