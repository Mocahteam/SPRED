
function widget:GetInfo()
	return {
		name = "Spring Direct Launch 2",
		desc = "Show some KP menu when Spring.exe is run directly",
		author = "zwzsg, muratet",
		version = "2.7",
		date = "1st March, 2009",
		license = "Public Domain",
		layer = 100,
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

local function CountMissingMaps()
	local missing = 0
	for m,_ in ipairs(ModSpecific.MapsList) do
		if not VFS.FileExists("maps/"..ModSpecific.MapsList[m].ExternalFileName) then
			missing = missing+1
		end
	end
	return missing
end

local function WidgetsExplorer()
	Spring.Echo("_______")
	Spring.Echo("widgetHandler=",widgetHandler)
	Spring.Echo("_______")
	Spring.Echo("Other Types:")
	for index,value in pairs(widgetHandler) do
		if type(value)~="function" and type(value)~="table" then
			Spring.Echo(index,value)
		end
	end
	Spring.Echo("_______")
	Spring.Echo("Tables:")
	for index,value in pairs(widgetHandler) do
		if type(value)=="table" then
			Spring.Echo(index,value)
		end
	end
	Spring.Echo("_______")
	Spring.Echo("Functions:")
	for index,value in pairs(widgetHandler) do
		if type(value)=="function" then
			Spring.Echo(index,value)
		end
	end
	Spring.Echo("_______")
	Spring.Echo("widgetHandler.widgets=",widgetHandler.widgets)
	for index,value in pairs(widgetHandler.widgets) do
		Spring.Echo("Widget n°",index,value)
		for i,v in pairs(value) do
			Spring.Echo(i,v)
		end
	end
	Spring.Echo("_______")
end


local function GetSavegames()
	local Savegames={}
	local FileList=VFS.DirList("Savegames/"..Game.modShortName)
	for Index,FileName in ipairs(FileList) do
		local ext=string.lower(string.sub(FileName,-4))
		if ext==".txt" or ext==".sav" then

			local RawFileContent=string.sub(VFS.LoadFile(FileName),1,8000)
			local DisplayName,_=string.gsub(FileName,"[_]"," ")
			local EndIndex=(string.find(DisplayName,".",string.len(DisplayName)-4,true) or 1+string.len(DisplayName))-1
			local BeginIndex=1
			repeat
				local NewBeginIndex=string.find(DisplayName,"/",BeginIndex,true) or string.find(DisplayName,"\\",BeginIndex,true)
				BeginIndex=NewBeginIndex and NewBeginIndex+1 or BeginIndex
			until not NewBeginIndex
			DisplayName=string.sub(DisplayName,BeginIndex,EndIndex)

			local descr=""
			local ModName=string.match(RawFileContent,"GameType=([^;]*);")
			local MapName=string.match(RawFileContent,"Mapname=([^;]*).smf;") or string.match(RawFileContent,"Mapname=([^;]*);")
			local DateTime=string.match(RawFileContent,"DateTime=([^;]*);")
			local NumPlayers=tonumber(string.match(RawFileContent,"NumPlayers=([^;]*);"))
			local NumTeams=tonumber(string.match(RawFileContent,"NumTeams=([^;]*);"))
			local MyPlayerNum=tonumber(string.match(RawFileContent,"MyPlayerNum=([^;]*);"))
			local ons=tonumber(string.match(RawFileContent,"ons=([^;]*);"))
			local cw=tonumber(string.match(RawFileContent,"colorwars=([^;]*);"))
			local sos=tonumber(string.match(RawFileContent,"sos=([^;]*);"))
			local homf=tonumber(string.match(RawFileContent,"homf=([^;]*);"))
			ons=ons~=0 and ons
			cw=cw~=0 and cw
			sos=sos~=0 and sos
			homf=homf~=0 and homf
			DateTime=tonumber(DateTime) or DateTime
			MapName,_=string.gsub(MapName or "?","_"," ")


			descr=descr.."Mod: "..(ModName or "?").."      Map: "..(MapName or "?").."\n"

			if homf then
				descr=descr.."Heroic"
			end

			if ons then
				descr=descr.."      ONS: "
				if ons==0 then
					descr=descr.."Disabled"
				elseif ons==1 then
					descr=descr.."Homebase-only"
				elseif ons==2 then
					descr=descr.."Weak"
				elseif ons==3 then
					descr=descr.."Strong"
				elseif ons==4 then
					descr=descr.."Ultra"
				end
			end

			if sos then
				descr=descr.."      SOS: "..sos
			end

			if cw then
				local cw_min=math.floor(cw)
				local cw_sec=math.floor(60*(cw-cw_min))
				descr=descr.."      ColorWars: "..cw_min..(cw_sec~=0 and (":"..cw_sec) or "")
			end

			if NumPlayers then
				descr=descr.."\n"
				if NumPlayers>2 then
					descr=descr.."Multiplayer: "..NumPlayers.." human players"
					descr=descr..", "..NumTeams.." teams"
				else
					descr=descr.."Single Player"
					local spectator=tonumber(string.match(RawFileContent,"pectator=([^;]*);"))
					if spectator then
						if spectator==1 then
							descr=descr.." - Spectating "..NumTeams.." AIs"
						elseif spectator==0 then
							descr=descr.." with "..(NumTeams-1).." AI"..((NumTeams-1)>1 and "s" or "")
						end
					end
				end
			end

			if DateTime then
				descr=descr.."\n"..(type(DateTime)=="number" and os.date("%A %d %B %Y at %X",DateTime) or DateTime)
			end

			table.insert(Savegames,{Index=Index,FileName=FileName,DisplayName=DisplayName,Description=descr,
				ModName=ModName,MapName=MapName,NumPlayers=NumPlayers,NumTeams=NumTeams,DateTime=DateTime})

		end
	end
	return Savegames
end

local function ListAvailableLuaStuff()
	Spring.Echo("io stuff:")
	for index,value in pairs(io) do
		Spring.Echo(index,value)
	end
	Spring.Echo("os stuff:")
	for index,value in pairs(os) do
		Spring.Echo(index,value)
	end
	Spring.Echo("package stuff:")
	for index,value in pairs(package) do
		Spring.Echo(index,value)
	end
end

local function PrintReadMe(ReadmeLines,StartAt)
	RemoveAllFrames()
	local FontSize = 16
	local LinesPerScreen = math.floor(vsy*0.8/FontSize)
	local ReadmeLines=ReadmeLines
	AddFrame(ModSpecific.ReadmeFileName,{x=vsx*0.5,y=vsy},vsy/32,{1,1,0.5,0.5},"ct","c",nil)
	if not VFS.FileExists(ModSpecific.ReadmeFileName) then
		AddFrame("File "..ModSpecific.ReadmeFileName.." not found!",{x=vsx*0.5,y=vsy*0.5},vsy/32,{1,0.5,0.5,0.5},"cc","c",nil)
	else
		if not ReadmeLines then
			--Spring.Echo("Parsing "..ModSpecific.ReadmeFileName)
			local readmedata=VFS.LoadFile(ModSpecific.ReadmeFileName,VFS.RAW_FIRST)
			readmedata=readmedata:gsub("\r\n?", "\n"):gsub("\n\n+", function(c) return ("\n "):rep(#c - 1) .. "\n" end)
			ReadmeLines = {}
			for line in string.gmatch(readmedata,"[^\r\n]+") do
				local b=1
				local e=nil
				local len=string.len(line)
				while b<=len do
					for k=b,len do
						if gl.GetTextWidth("X"..string.sub(line,b,k).."X")*FontSize>=vsx then
							break
						end
						if string.sub(line,k,k)==" " or string.sub(line,k,k)=="\t" or k==len then
							e=k
						end
					end
					e=e or len
					table.insert(ReadmeLines,string.sub(line,b,e))
					b=e+1
					e=nil
				end
			end
		end
		local StartAt=math.max(1,math.min(#ReadmeLines-(LinesPerScreen-3),StartAt or 1))
		local txt=""
		for k=StartAt,math.min(#ReadmeLines,StartAt+LinesPerScreen-1) do
			txt=txt..ReadmeLines[k].."\n"
		end
		AddFrame(txt,{x=0,y=vsy*0.9},FontSize,{0,0.1,0.2,HideView and 0 or 1},"lt","l",nil)
		if StartAt>1 then
			AddFrame("Up",{x=vsx*0.0,y=vsy},vsy/24,{0.9,0.6,0,0.5},"lt","c",FunctionsList.PrintReadMe,ReadmeLines,StartAt-LinesPerScreen+1)
			AddFrame("Up",{x=vsx*1.0,y=vsy},vsy/24,{0.9,0.6,0,0.5},"rt","c",FunctionsList.PrintReadMe,ReadmeLines,StartAt-LinesPerScreen+1)
			ScrollUp={FunctionsList.PrintReadMe,ReadmeLines,StartAt-1}
		end
		if StartAt+LinesPerScreen-1<#ReadmeLines then
			AddFrame("Down",{x=vsx*0.3,y=0},vsy/24,{0.9,0.6,0,0.5},"cb","c",FunctionsList.PrintReadMe,ReadmeLines,StartAt+LinesPerScreen-1)
			AddFrame("Down",{x=vsx*0.7,y=0},vsy/24,{0.9,0.6,0,0.5},"cb","c",FunctionsList.PrintReadMe,ReadmeLines,StartAt+LinesPerScreen-1)
			ScrollDown={FunctionsList.PrintReadMe,ReadmeLines,StartAt+1}
		end
	end
	AddFrame("Back",{x=vsx*0.5,y=0},vsy/24,{0,0,1,0.5},"cb","c",FunctionsList.MainMenuFull)
end

local function Credits()
	RemoveAllFrames()
	AddFrame("Kernel Panic!\nCredits:",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0.45,1,0.3,0.5},"cb","c",nil)
	local txt=""
	txt=txt.."- Original concept by Boirunner\n"
	txt=txt.."- About all the work done by KDR_11k\n"
	txt=txt.."- Maintenance and silly mod options by zwzsg\n"
	txt=txt.."- Sounds by Noruas and Pendrokar\n"
	txt=txt.."- Voices by Eva and Panda\n"
	txt=txt.."- Maps by Boirunner, Runecrafter, zwzsg, TradeMark, KDR_11k and FireStorm\n"
	txt=txt.."- Some LUA interface upgrade based of jK and trepan code\n"
	txt=txt.."- The Touhou faction characters were inspired by ZUN's works\n"
	txt=txt.."- Many thanks to lurker, Quantum, and the rest of #lua crew\n"
	AddFrame(txt,{x=vsx*0.5,y=vsy*0.8},vsy/30,{0.3,1,0.5,0.5},"ct","l",nil)
	AddFrame("Spring Engine by: ",{x=vsx*0.5,y=vsy*0.3},vsy/24,{0.9,0.3,0,0.5},"cb","l",nil)
	AddFrame("Swedish Yankspankers",{x=vsx*0.5,y=vsy*0.3},vsy/30,{0.9,0.6,0,0.5},"ct","l",nil)
	AddFrame("Back",{x=vsx*0.5,y=vsy*0.1},vsy/30,{0,0,1,0.5},"cc","l",FunctionsList.MainMenuFull)
end

local function RecopyDll()
	local filedata = VFS.LoadFile("bitmaps/icons/kpldll.raw",VFS.ZIP_FIRST)
	if not filedata then
		Spring.Echo("LoadFile failed!")
	else
		local file = io.open ("KPL.dll","wb")
		file:write(filedata)
		file:flush()
		file:close()
	end
end

local function RunDll(procedure)
	RecopyDll()
	local LLa,LLb,LLc=package.loadlib("KPL.dll",procedure)
	if(LLa) then
		LLa()
		Spring.SendCommands("quit")
		Spring.SendCommands("quitforce")
	else
		Spring.Echo("LLa",LLa)
		Spring.Echo("LLb",LLb)
		Spring.Echo("LLc",LLc)
		RemoveAllFrames()
		AddFrame("Kernel Panic!\nIntegrated Launcher",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
		AddFrame("Error!\nFailed to load "..procedure.."\n"..LLb,
			{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
		AddFrame("Back",{x=vsx*0.5,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Foreword)
	end
end

local function RecopySo()
	local filedata = VFS.LoadFile("bitmaps/icons/kplso.raw",VFS.ZIP_FIRST)
	if not filedata then
		Spring.Echo("LoadFile failed!")
	else
		local file = io.open ("kpl.so","wb")
		file:write(filedata)
		file:flush()
		file:close()
	end
end

local function RunSo(procedure)
	RecopySo()
	local LLa,LLb,LLc=package.loadlib("kpl.so",procedure)
	if(LLa) then
		LLa()
		Spring.SendCommands("quit")
		Spring.SendCommands("quitforce")
	else
		Spring.Echo("LLa",LLa)
		Spring.Echo("LLb",LLb)
		Spring.Echo("LLc",LLc)
		RemoveAllFrames()
		AddFrame("Kernel Panic!\nIntegrated Launcher",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
		AddFrame("Error!\nFailed to load "..procedure.."\n"..LLb,
			{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
		AddFrame("Back",{x=vsx*0.5,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Foreword)
	end
end

local function ForceModNameAndPort(input)
	output,_=string.gsub(input,"GameType=[^;]*;","GameType="..ModSpecific.ModFileName..";",1)
	output,_=string.gsub(output,"HostPort=[^;]*;","HostPort="..(0)..";",1)
	return output
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
	Spring.Echo("Making infolog.txt copy into "..n_infologcopy)
	local file=io.open(n_infologcopy,"wb")
	file:write(VFS.LoadFile("infolog.txt"))
	file:flush()
	file:close()
	Spring.Echo(widget:GetInfo().name..": Ok, calling Spring.Restart(\"-s\",\"[GAME]{..}\") now!")
	Spring.Restart("-s",trimmed)
	Spring.Echo(widget:GetInfo().name..": Just called Spring.Restart(\"-s\",\"[GAME]{..}\")")
	Spring.Echo(widget:GetInfo().name..": Wait, we shouldn't be here, should have restarted or crashed or quitted by now.")
end

local function RunGame()
	Spring.Echo(widget:GetInfo().name..": I am about to write \""..ModSpecific.ScriptFileName.."\"")
	WriteScript(SDLG)
	Spring.Echo(widget:GetInfo().name..": I have now written \""..ModSpecific.ScriptFileName.."\"")
	if Spring.Restart then
		DoTheRestart(ModSpecific.ScriptFileName)
	elseif package and package.loadlib then
		RunDll("_LaunchLuaStartScript")
		--RunSo("_LaunchLuaStartScript")
	else
		RemoveAllFrames()
		AddFrame("Kernel Panic!\nIntegrated Launcher",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
		AddFrame("Error!\n\"package\" library disabled\nSpring.Restart not implemented\nin this build of Spring!",
			{x=vsx*0.5,y=vsy*0.6},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
		AddFrame("Quit, then drag'n'drop\n"..ModSpecific.ScriptFileName.."\nover "..ModSpecific.ExecutableFileName.." manually.",
			{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.8,0.8,0,0.5},"cc","c",nil)
		AddFrame("Quit",{x=vsx*0.4,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Quit)
		AddFrame("Back",{x=vsx*0.6,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenuFull)
	end
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
		AddFrame("Back",{x=vsx*0.6,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenuFull)
	end
end

local function RestartSameGame()
	local ms=Spring.GetModOptions()["missionscript"]
	if ms then
		if VFS.FileExists(ms) then
			DoTheRestart(ms)
		else
			Spring.Echo("Mission script does not exist anymore: \""..ms.."\"")
		end
	else
		Spring.SendCommands("luarules dump restart")
	end
	RemoveAllFrames()
	AddFrame("Kernel Panic!\nIntegrated Launcher",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
	AddFrame("Sorry! Restart failed!",
		{x=vsx*0.5,y=vsy*0.6},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
	AddFrame("Try to quit and drag and drop \n"..ModSpecific.ScriptFileName.."\n over "..ModSpecific.ExecutableFileName,
		{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.8,0.8,0,0.5},"cc","c",nil)
	AddFrame("Quit",{x=vsx*0.4,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Quit)
	AddFrame("Back",{x=vsx*0.6,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenuFull)
end

local function PseudoSave()
	local savegamefilename=os.date("%y-%m-%d %H-%M-%S  ")..Game.modName.."  "..Game.mapName
	savegamefilename,_=string.gsub(savegamefilename,"[^%w-._]","_") -- replace special characters with an underscore
	savegamefilename,_=string.gsub(savegamefilename,"%.smf","")
	Spring.SendCommands("luarules dump "..savegamefilename)
	RemoveAllFrames()
	AddFrame("Kernel Panic!\nIntegrated Launcher",{x=vsx*0.5,y=vsy*0.9},vsy/32,{0,0,1,0.5},"cc","c",nil)
	AddFrame("Game saved!\n \n"
		.."You can use the \'Load\' menu any time to reload!",
		{x=vsx*0.5,y=vsy*0.7},vsy/24,{0.7,0.7,1,0.5},"cc","c",nil)
	AddFrame("This is a custom pseudo-savegame system,\n"
		.."based on complex Lua and heavy startscripts,\n"
		.."independant from Spring hard coded savegame system.",
		{x=vsx*0.5,y=vsy*0.5},vsy/32,{0.7,0.7,1,0.5},"cc","l",nil)
	AddFrame(" Warning: Under construction units not saved properly! \n"
		.." Warning: Some orders and states improperly saved! \n"
		.." Warning: May crash during reload! ",
		{x=vsx*0.5,y=vsy*0.38},vsy/32,{0.8,0.8,0;0.5},"cc","l",nil)
	AddFrame("Quit",{x=vsx*0.3,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Quit)
	AddFrame("Resume",{x=vsx*0.5,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.SwitchOff)
	AddFrame("Back",{x=vsx*0.7,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenuFull)
	-- Bah, skip showing that, let's go directly back to game
	FunctionsList.SwitchOff()
end

local function MultiPlayer()
	if VFS.FileExists(ModSpecific.ClientExecutableFileName) then
		if package and package.loadlib then
			RunDll("_StartMultiPlayer")
			--RunSo("_StartMultiPlayer")
		else
			RemoveAllFrames()
			AddFrame("Kernel Panic!\nMultiplayer",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
			AddFrame("Error!\n\"package\" library disabled\nin this build of Spring!",
				{x=vsx*0.5,y=vsy*0.6},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
			AddFrame("Quit, then manually launch "..ModSpecific.ClientExecutableFileName,
				{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.8,0.8,0,0.5},"cc","c",nil)
			AddFrame("Quit",{x=vsx*0.4,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Quit)
			AddFrame("Back",{x=vsx*0.6,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenuFull)
		end
	else
		RemoveAllFrames()
		AddFrame("Kernel Panic!\nMultiplayer",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
		AddFrame("Error!\n"..ModSpecific.ClientExecutableFileName.." not found!\nReinstall KP from complete installer!",
			{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
		AddFrame("Back",{x=vsx*0.5,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Foreword)
	end
end

local function Settings()
	if VFS.FileExists(ModSpecific.SettingsExecutableFileName) then
		if package and package.loadlib then
			RunDll("_StartSettings")
			--RunSo("_StartSettings")
		else
			RemoveAllFrames()
			AddFrame("Kernel Panic!\nIntegrated Launcher",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
			AddFrame("Error!\n\"package\" library disabled\nin this build of Spring!",
				{x=vsx*0.5,y=vsy*0.6},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
			AddFrame("Quit, then run "..ModSpecific.SettingsExecutableFileName.." manually.",
				{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.8,0.8,0,0.5},"cc","c",nil)
			AddFrame("Quit",{x=vsx*0.4,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Quit)
			AddFrame("Back",{x=vsx*0.6,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenuFull)
		end
	else
		RemoveAllFrames()
		AddFrame("Kernel Panic!\nSettings",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",nil)
		AddFrame("Error!\n"..ModSpecific.SettingsExecutableFileName.." not found!",
			{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.88,0.40,0,0.5},"cc","c",nil)
		AddFrame("Back",{x=vsx*0.5,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.Foreword)
	end
end

local function ChangeGrouping(grouping)
	SDLG=GenerateSkirmish(SDLG.map,grouping,SDLG.difficulty,SDLG.AlliesFaction,SDLG.EnemiesFaction)
	FunctionsList.SinglePlayer()
end

local function ChangeDifficulty(difficulty)
	SDLG=GenerateSkirmish(SDLG.map,SDLG.grouping,difficulty,SDLG.AlliesFaction,SDLG.EnemiesFaction)
	FunctionsList.SinglePlayer()
end

local function ChangeYourFaction()
	local AFI=nil
	for fi,f in ipairs(ModSpecific.FactionsList) do
		if f==SDLG.AlliesFaction then
			AFI=fi
			break
		end
	end
	AFI=1+(AFI%#ModSpecific.FactionsList)
	SDLG.AlliesFaction=ModSpecific.FactionsList[AFI]
	SDLG=GenerateSkirmish(SDLG.map,SDLG.grouping,SDLG.difficulty,SDLG.AlliesFaction,SDLG.EnemiesFaction)
	FunctionsList.SinglePlayer()
end

local function ChangeTheirFaction()
	local EFI=nil
	for fi,f in ipairs(ModSpecific.FactionsList) do
		if f==SDLG.EnemiesFaction then
			EFI=fi
			break
		end
	end
	EFI=1+(EFI%#ModSpecific.FactionsList)
	SDLG.EnemiesFaction=ModSpecific.FactionsList[EFI]
	SDLG=GenerateSkirmish(SDLG.map,SDLG.grouping,SDLG.difficulty,SDLG.AlliesFaction,SDLG.EnemiesFaction)
	FunctionsList.SinglePlayer()
end

local function RunRandomGame(difficulty)
	SDLG=GenerateSkirmish(nil,nil,difficulty)
	RunGame()
end

local function RandomSinglePlayer()
	SDLG=GenerateSkirmish(SDLG.map)
	FunctionsList.SinglePlayer()
end

local function ChangeMap(m,ReturnTo)
	SDLG=GenerateSkirmish(ModSpecific.MapsList[m],SDLG.grouping,SDLG.difficulty,SDLG.AlliesFaction,SDLG.EnemiesFaction)
	FunctionsList.GoToPage(ReturnTo)
end

local function PreloadMiniMapPics()
	for _,map in ipairs(ModSpecific.MapsList) do
		if map and map.MiniMapPic then
			gl.Texture(map.MiniMapPic)
		end
	end
	gl.Texture(false)
end

local function ListMap(ReturnTo)
	RemoveAllFrames()
	local function GetMinimapFromActiveMap()
		local FrameIndex=ActiveFrameIndex or MouseOveredFrameIndex or KeyboardFrameIndex
		if FrameIndex and FramesList[FrameIndex] and FramesList[FrameIndex].Param2 then
			local m=FramesList[FrameIndex].Param1
			if m~=ReturnTo then
				local MiniMapPic=ModSpecific.MapsList[m].MiniMapPic
				if MiniMapPic then
					return {texture=MiniMapPic,text=""}
				else
					return "Minimap Unavailable"
				end
			else
				return "Not a map selected"
			end
		else
			return "No map selected"
		end
	end
	AddFrame(GetMinimapFromActiveMap,{x=0,y=vsy},vsy/48,{1,0.6,0,1},"lt","l",ReturnTo)
	AddFrame("Choose a map:",{x=vsx*0.5,y=vsy*0.95},vsy/24,{0,0,1,0.5},"cc","c",nil)
	for m,_ in ipairs(ModSpecific.MapsList) do
		local missing=true
		if VFS.FileExists("maps/"..ModSpecific.MapsList[m].ExternalFileName) then
			missing = false
		end
		AddFrame(ModSpecific.MapsList[m].ClearName..(missing and " - Missing!" or ""),{x=vsx*0.5,y=vsy*(0.92-0.06*m)},vsy/36,{0,1,0,0.5},"cc","c",missing and ListMap or ChangeMap,missing and ReturnTo or m,ReturnTo)
	end
	AddFrame("Back",{x=vsx*0.5,y=vsy*0.05},vsy/24,{0,0,1,0.5},"cc","c",ReturnTo)
end

local function SinglePlayer()
	RemoveAllFrames()
	AddFrame("Kernel Panic!\nSingle Player",{x=vsx*0.5,y=vsy*0.9},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.SimplerSinglePlayer)

	AddFrame("Map: "..SDLG.map.ClearName,{x=vsx*0.5,y=vsy*0.75},vsy/24,{0.1,1,0,0.5},"cc","c",ListMap,FunctionsList.SinglePlayer)

	local nbr_map_missing = CountMissingMaps()
	if nbr_map_missing>0 then
		AddFrame("Warning! "..nbr_map_missing.." map"..(nbr_map_missing==1 and "" or "s").." missing!",
			{x=vsx*0.53,y=vsy*0.65},vsy/24,{0.88,0.40,0,0.5},"cc","c",ListMap,FunctionsList.SinglePlayer)
	end

	AddFrame("You:\n\255\128\255\128"..SDLG.AlliesFaction.ClearName,
		{x=vsx*0.5,y=vsy*(0.5+(nbr_map_missing==0 and 0.1 or 0))},vsy/24,{0.33,0.88,1,0.5},"cc","l",ChangeYourFaction)
	AddFrame("Enemy:\n\255\255\128\128"..SDLG.EnemiesFaction.ClearName,
		{x=vsx*0.5,y=vsy*(0.35+(nbr_map_missing==0 and 0.1 or 0))},vsy/24,{0.33,0.88,1,0.5},"cc","l",ChangeTheirFaction)

	AddFrame("Spectate",{x=vsx*0.15,y=vsy*0.65},vsy/24,{0.33,0.88,1,0.5},"lc","c",ChangeGrouping,0)
	AddFrame("Duel",{x=vsx*0.15,y=vsy*0.55},vsy/24,{0.33,0.88,0,0.5},"lc","c",ChangeGrouping,1)
	AddFrame("Team Game",{x=vsx*0.15,y=vsy*0.45},vsy/24,{0.88,0.79,0,0.5},"lc","c",ChangeGrouping,2)
	AddFrame("Outgunned",{x=vsx*0.15,y=vsy*0.35},vsy/24,{0.88,0.40,0,0.5},"lc","c",ChangeGrouping,3)
	AddFrame("Heroic",{x=vsx*0.15,y=vsy*0.25},vsy/24,{0.88,0,0.88,0.5},"lc","c",ChangeGrouping,4)

	AddFrame("Easy",{x=vsx*0.85,y=vsy*0.60},vsy/24,{0.33,0.88,1,0.5},"rc","c",ChangeDifficulty,1)
	AddFrame("Medium",{x=vsx*0.85,y=vsy*0.50},vsy/24,{0.33,0.88,0,0.5},"rc","c",ChangeDifficulty,2)
	AddFrame("Hard",{x=vsx*0.85,y=vsy*0.40},vsy/24,{0.88,0.79,0,0.5},"rc","c",ChangeDifficulty,3)
	AddFrame("Extreme",{x=vsx*0.85,y=vsy*0.30},vsy/24,{0.88,0.40,0,0.5},"rc","c",ChangeDifficulty,4)

	AddFrame("Run!",{x=vsx*0.4,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",RunGame)
	AddFrame("Back",{x=vsx*0.6,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenuFull)

	AddFrame(SDLG.description,{x=vsx*0.5,y=vsy*0.05},vsy/24,{0.2,0.5,0.9,0.5},"cc","c")

end

local function SimplerSinglePlayer()
	RemoveAllFrames()
	AddFrame("Kernel Panic!\nSingle Player",{x=vsx*0.5,y=vsy*0.8},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.SinglePlayer)
	AddFrame("Easy",{x=vsx*0.5,y=vsy*0.6},vsy/24,{0.33,0.88,0,0.5},"cc","c",RunRandomGame,1)
	AddFrame("Medium",{x=vsx*0.5,y=vsy*0.5},vsy/24,{0.88,0.79,0,0.5},"cc","c",RunRandomGame,2)
	AddFrame("Hard",{x=vsx*0.5,y=vsy*0.4},vsy/24,{0.88,0.40,0,0.5},"cc","c",RunRandomGame,3)
	AddFrame("Very Hard",{x=vsx*0.5,y=vsy*0.3},vsy/24,{0.88,0.02,0,0.5},"cc","c",RunRandomGame,4)
	AddFrame("Back",{x=vsx*0.5,y=vsy*0.2},vsy/24,{0,0,1,0.5},"cc","c",FunctionsList.MainMenuFull)
	local nbr_map_missing = CountMissingMaps()
	if nbr_map_missing>0 then
	AddFrame("Warning! "..nbr_map_missing.." map"..(nbr_map_missing==1 and "" or "s").." missing!",
			{x=vsx*0.5,y=vsy*0.1},vsy/24,{0.88,0.40,0,0.5},"cc","c",ListMap,FunctionsList.SimplerSinglePlayer)
	end
end

local function PseudoLoad(StartAt)

	local function GetSaveDescriptionFromActiveFrame()
		local FrameIndex=ActiveFrameIndex or MouseOveredFrameIndex or KeyboardFrameIndex
		if FrameIndex and FramesList[FrameIndex] and FramesList[FrameIndex].Param2 then
			local ActiveSave=FramesList[FrameIndex].Param2
			if ActiveSave.Description then
				return ActiveSave.Description
			else
				return "Description Unavailable"
			end
		else
			return "No save selected"
		end
	end

	local StartAt=math.max(1,StartAt or 1)
	local SavePerPage=10
	Savegames=GetSavegames()
	RemoveAllFrames()
	AddFrame(GetSaveDescriptionFromActiveFrame,{x=0,y=vsy},vsy/32,{1,1,0,0.5},"lt","l")

	for SaveIndex=StartAt,StartAt+SavePerPage-1 do
		local Savegame=Savegames[SaveIndex]
		if Savegame then
			AddFrame(Savegame.DisplayName,{x=vsx*0.5,y=vsy-(vsy/16)*(4+SaveIndex-StartAt)},vsy/32,{0,1,0.5,0.5},"ct","c",RunScript,Savegame.FileName,Savegame)
		end
	end

	if StartAt>1 then
		AddFrame("<-",{x=vsx*0.4,y=0},vsy/24,{0,0,1,0.5},"cb","c",FunctionsList.PseudoLoad,math.max(1,StartAt-SavePerPage))
	end
	AddFrame("Back",{x=vsx*0.5,y=0},vsy/24,{0,0,1,0.5},"cb","c",FunctionsList.MainMenuFull)
	if StartAt+SavePerPage-1<#Savegames then
		AddFrame("->",{x=vsx*0.6,y=0},vsy/24,{0,0,1,0.5},"cb","c",FunctionsList.PseudoLoad,StartAt+SavePerPage)
	end
end

local function MissionsMenu()
	RemoveAllFrames()
	local MissionsList=JoinArrays(VFS.DirList("Missions/"..Game.modShortName),VFS.DirList("Missions"))
	local ItemSize=math.min(vsy/(2*(#MissionsList+2)),vsy/24)
	for MissionIndex,MissionFileName in ipairs(MissionsList) do
		local EndIndex=(string.find(MissionFileName,".",string.len(MissionFileName)-4,true) or 1+string.len(MissionFileName))-1
		local BeginIndex=1
		repeat
			local NewBeginIndex=string.find(MissionFileName,"/",BeginIndex,true) or string.find(MissionFileName,"\\",BeginIndex,true)
			BeginIndex=NewBeginIndex and NewBeginIndex+1 or BeginIndex
		until not NewBeginIndex
		AddFrame(Capitalize(string.sub(MissionFileName,BeginIndex,EndIndex)),{x=vsx*0.1,y=vsy-2*MissionIndex*ItemSize},ItemSize,{0,1,0.5,0.5},"lt","c",RunScript,MissionFileName)
	end
	AddFrame("Back",{x=vsx*0.5,y=0},ItemSize*0.8,{0,0,1,0.5},"cb","c",FunctionsList.MainMenuFull)
end

local function GameOverMenu()
	RemoveAllFrames()
	-- Counting units doesn't work because the player has been autoswitched to speccing an alive team when GameOver gets called
	if Spring.GetSpectatingState() then
		AddFrame("You lost!",{x=vsx*0.5,y=vsy*0.7},vsy/14,{1,0.2,0.2},"cc","c")
		AddFrame("Keep on watching",{x=vsx*0.48,y=vsy*0.25},vsy/28,{0,1,0,0.5},"rc","c",FunctionsList.SwitchOffNoEndGraph)
		AddFrame("Restart",{x=vsx*0.5,y=vsy*0.35},vsy/28,{0,1,0,0.5},"cc","c",FunctionsList.RestartSameGame)
	else
		AddFrame("You won!",{x=vsx*0.5,y=vsy*0.7},vsy/14,{0.2,1,0.3},"cc","c")
		AddFrame("Keep on playing",{x=vsx*0.48,y=vsy*0.25},vsy/28,{0,1,0,0.5},"rc","c",FunctionsList.SwitchOffNoEndGraph)
	end
	AddFrame("Go to Menu",{x=vsx*0.52,y=vsy*0.25},vsy/28,{0,1,0,0.5},"lc","c",FunctionsList.MainMenu)
end

local function SaveLoadMenu()
	RemoveAllFrames()
	AddFrame("Save",{x=vsx*0.45,y=vsy*0.505},vsy/14,{0,1,0,0.5},"rb","c",FunctionsList.PseudoSave)
	AddFrame("Load",{x=vsx*0.55,y=vsy*0.505},vsy/14,{0,1,0,0.5},"lb","c",FunctionsList.PseudoLoad)
	AddFrame("Menu",{x=vsx*0.45,y=vsy*0.5},vsy/14,{0,1,0,0.5},"rt","c",FunctionsList.MainMenu)
	AddFrame("Restart",{x=vsx*0.55,y=vsy*0.5},vsy/14,{0,1,0,0.5},"lt","c",FunctionsList.RestartSameGame)
end

local function LaunchSimpleGame()
	local marbleMadnessMap = {
		ClearName="Marble Madness",
		ShortName="MM",
		ExternalFileName="Marble_Madness_Map.sd7",
		InternalFileName="Marble_Madness_Map.smf",
		MaxPlayers=4,
		Weight=7,
		TimeFactor=2,
		MiniMapPic=":nc:bitmaps/minimaps/Marble_Madness.png"
	}
	local systemFaction = {
		ClearName="System",
		InternalName="System",
		Description="Easiest faction to handle"
	}
	SDLG=GenerateSkirmish(marbleMadnessMap,1,1,systemFaction,systemFaction)
	RunGame()
end

local function MainMenu()
	RemoveAllFrames()
	AddFrame("Kernel Panic!",{x=vsx*0.5,y=vsy*0.98},vsy/14,{0,1,1,0.5},"ct","c")
	AddFrame("Play a simple game!",{x=vsx*0.5,y=vsy*0.6},vsy/18,{0,1,0,0.5},"ct","c",LaunchSimpleGame)
	AddFrame("More choices...",{x=vsx*0.5,y=vsy*0.4},vsy/18,{0,1,0,0.5},"ct","c",FunctionsList.MainMenuFull)

	AddFrame("Quit",{x=vsx*0.5,y=vsy*0.0},vsy/18,{1,0,0,0.5},"cb","c",FunctionsList.Quit)
end

local function MainMenuFull()
	RemoveAllFrames()
	AddFrame("Kernel Panic!",{x=vsx*0.5,y=vsy*0.98},vsy/14,{0,1,1,0.5},"ct","c")
	--AddFrame("MultiPlayer",{x=vsx*0.46,y=vsy*0.83},vsy/18,{0,1,0,0.5},"rb","c",FunctionsList.MultiPlayer)
	--AddFrame("Options",{x=vsx*0.54,y=vsy*0.82},vsy/18,{0,1,0,0.5},"lb","c",FunctionsList.Settings)
	AddFrame("Missions",{x=vsx*0.46,y=vsy*0.7},vsy/18,{0,1,0,0.5},"rb","c",FunctionsList.MissionsMenu)
	AddFrame("Skirmish",{x=vsx*0.54,y=vsy*0.6},vsy/18,{0,1,0,0.5},"lb","c",FunctionsList.RandomSinglePlayer)
	AddFrame("Load",{x=vsx*0.46,y=vsy*0.5},vsy/18,{0,1,0,0.5},"rb","c",FunctionsList.PseudoLoad)
	if not (Spring.GetModOptions()["ons"] == nil) then
		local _,_,isDead = Spring.GetTeamInfo(Spring.GetMyTeamID())
		if not isDead and not Spring.GetSpectatingState() then
			AddFrame("Save",{x=vsx*0.54,y=vsy*0.4},vsy/18,{0,1,0,0.5},"lb","c",FunctionsList.PseudoSave)
		end
		AddFrame("Restart",{x=vsx*0.46,y=vsy*0.3},vsy/18,{0,1,0,0.5},"rb","c",FunctionsList.RestartSameGame)
	end
	AddFrame("Credits",{x=vsx*0.54,y=vsy*0.2},vsy/18,{0,1,0,0.5},"lb","c",FunctionsList.Credits)
	AddFrame("Readme",{x=vsx*0.46,y=vsy*0.1},vsy/18,{0,1,0,0.5},"rb","c",FunctionsList.PrintReadMe)
	AddFrame("Back",{x=vsx*0.54,y=vsy*0.0},vsy/18,{0,0,1,0.5},"lb","c",FunctionsList.MainMenu)
end

local function MainMenuOld()
	RemoveAllFrames()
	local JustMenuNoGame = (Spring.GetModOptions()["ons"] == nil)
	if JustMenuNoGame then
		AddFrame("Kernel Panic!",{x=vsx*0.5,y=vsy*0.9},vsy/12,{0,1,1,0.5},"cc","c")
	else
		AddFrame("Restart",{x=vsx*0.5,y=vsy*0.9},vsy/12,{0,1,0,0.5},"cc","c",FunctionsList.RestartSameGame)
	end
	AddFrame("Skirmish",{x=vsx*0.5,y=vsy*0.8},vsy/12,{0,1,0,0.5},"cc","c",FunctionsList.RandomSinglePlayer)
	AddFrame("Missions",{x=vsx*0.5,y=vsy*0.6},vsy/12,{0,1,0,0.5},"cc","c",FunctionsList.MissionsMenu)
	if package then
		AddFrame("MultiPlayer",{x=vsx*0.5,y=vsy*0.53},vsy/12,{0,1,0,0.5},"cc","c",FunctionsList.MultiPlayer)
		AddFrame("Options",{x=vsx*0.5,y=vsy*0.47},vsy/12,{0,1,0,0.5},"cc","c",FunctionsList.Settings)
	end
	AddFrame("Load",{x=vsx*0.5,y=vsy*0.45},vsy/12,{0,1,0,0.5},"cc","c",FunctionsList.PseudoLoad)
	local LoadButtonIndex=#FramesList
	if ModSpecific.ReadmeFileName then
		AddFrame("Readme",{x=vsx*0.5,y=vsy*0.4},vsy/12,{},"cc","c",FunctionsList.PrintReadMe)
	end
	AddFrame("Credits",{x=vsx*0.5,y=vsy*0.4},vsy/12,{0,1,0,0.5},"cc","c",FunctionsList.Credits)
	AddFrame("Quit",{x=vsx*0.5,y=vsy*0.2},vsy/12,{0,1,0,0.5},"cc","c",FunctionsList.Quit)
	if #FramesList>0 then
		local factor=4/#FramesList
		for Index,Frame in ipairs(FramesList) do
			Frame.FontSize=Frame.FontSize*factor
			Frame.Pos.y=vsy*(1-(Index)/(1+#FramesList))
		end
	end
	local _,_,isDead = Spring.GetTeamInfo(Spring.GetMyTeamID())
	if not isDead and not Spring.GetSpectatingState() and not JustMenuNoGame then
		FramesList[LoadButtonIndex].Pos.x=vsx*0.6
		AddFrame("Save",{x=vsx*0.4,y=FramesList[LoadButtonIndex].Pos.y},FramesList[LoadButtonIndex].FontSize,{0,1,0,0.5},"cc","c",FunctionsList.PseudoSave)
		for f=#FramesList,LoadButtonIndex,-1 do
			FramesList[f+1]=FramesList[f]
		end
		FramesList[LoadButtonIndex]=FramesList[#FramesList]
		FramesList[#FramesList]=nil
	end
end

local function Foreword()
	RemoveAllFrames()
	AddFrame("Kernel Panic!",
		{x=vsx*0.5,y=vsy*0.8},vsy/16,{0,0,1,0.5},"cc","c",nil)
	AddFrame("   This menu is provided as a failsafe only  ",
		{x=vsx*0.5,y=vsy*0.6},vsy/28,{1,1,0,0.5},"cb","c",nil)
	AddFrame("For Single Player, you are supposed to run\n"..ModSpecific.FrontEndExecutableFileName,
		{x=vsx*0.5,y=vsy*0.5},vsy/28,{0,1,0,0.5},"cb","r",FunctionsList.SinglePlayer)
	AddFrame("  For Multi Player, you are supposed to run\n"..ModSpecific.ClientExecutableFileName,
		{x=vsx*0.5,y=vsy*0.4},vsy/28,{0,1,0,0.5},"cb","r",FunctionsList.MultiPlayer)
	AddFrame("        For Settings, you are supposed to run\n"..ModSpecific.SettingsExecutableFileName,
		{x=vsx*0.5,y=vsy*0.3},vsy/28,{0,1,0,0.5},"cb","r",FunctionsList.Settings)
	AddFrame("             For Info, you are supposed to read\n"..ModSpecific.ReadmeFileName,
		{x=vsx*0.5,y=vsy*0.2},vsy/28,{0,1,0,0.5},"cb","r",FunctionsList.Credits)
	AddFrame("     You are actually never supposed to run\n"..ModSpecific.ExecutableFileName,
		{x=vsx*0.5,y=vsy*0.1},vsy/28,{1,1,0,0.5},"cb","r",nil)
	AddFrame("OK",
		{x=vsx*0.5,y=vsy*0.1},vsy/28,{0,1,0.7,0.5},"ct","c",FunctionsList.MainMenu)
end

local function GoToPage(PageToGoTo)
	PageToGoTo()
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
		PreloadMiniMapPics()
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

function widget:MouseWheel(up,value)
	if up then
		if ScrollUp then
			ScrollUp[1](ScrollUp[2],ScrollUp[3],ScrollUp[4],ScrollUp[5])
			return true
		end
	else
		if ScrollDown then
			ScrollDown[1](ScrollDown[2],ScrollDown[3],ScrollDown[4],ScrollDown[5])
			return true
		end
	end
	return false
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

local function FindMap()
	--Spring.Echo("Game.mapName:"..Game.mapName)
	--Spring.Echo("Game.mapHumanName:"..Game.mapHumanName)
	for _,map in ipairs(ModSpecific.MapsList) do
		if map.InternalFileName == Game.mapName then
			return map
		end
	end
	return nil
end

function widget:GameOver()
	-- Turn on menu
	FunctionsList.SwitchOn(GameOverMenu)
	-- Check if it was a speccing game
	if #Spring.GetPlayerList()==1 then
		local AICount=0
		for _,team in ipairs(Spring.GetTeamList()) do
			if team~=Spring.GetGaiaTeamID() then
				_,_,_,isAiTeam=Spring.GetTeamInfo(team)
				if isAiTeam then
					AICount=AICount+1
				else
					AICount=false
					break
				end
			end
		end
		if AICount and AICount>=2 then
			-- Restart a new speccing game
			SDLG=GenerateSkirmish(nil,0,nil)
			RunGame()
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

function widget:Initialize()
	BetterizeRandom()
	IsActive = false
	FunctionsList={Credits=Credits,MainMenu=MainMenu,MainMenuFull=MainMenuFull,Foreword=Foreword,Quit=Quit,GameOverMenu=GameOverMenu,
		SimplerSinglePlayer=SimplerSinglePlayer,MultiPlayer=MultiPlayer,Settings=Settings,PrintReadMe=PrintReadMe,
		SinglePlayer=SinglePlayer,RandomSinglePlayer=RandomSinglePlayer,GoToPage=GoToPage,SaveLoadMenu=SaveLoadMenu,
		MissionsMenu=MissionsMenu,SwitchOn=SwitchOn,SwitchOff=SwitchOff,PreloadMiniMapPics=PreloadMiniMapPics,
		RestartSameGame=RestartSameGame,PseudoSave=PseudoSave,PseudoLoad=PseudoLoad,SwitchOffNoEndGraph=SwitchOffNoEndGraph}
	FramesList={}
	FillModSpecific()
	SDLG=GenerateSkirmish()
	--SDLG=GenerateSkirmish(FindMap())
	if tonumber(Spring.GetConfigInt("snd_volmaster"))==1 then
		Spring.SetConfigInt("snd_volmaster",100)
	end
	if Spring.GetModOptions()["ons"]==nil then
		Spring.SendCommands({'NoSound 1'}) -- Disable sound when menu pops up straight after running Spring.exe
		ViewPoint=Spring.GetModOptions()["viewpoint"] or Spring.GetModOptions()["viewpoint0"] or Spring.GetModOptions()["viewpoint1"]
		ViewPoint=GetFromQuote(ViewPoint)
		InitializeTimer = Spring.GetTimer()
		HideView = (ViewPoint==nil)
		FunctionsList.SwitchOn()
	elseif #Spring.GetPlayerList()>1 then
		widgetHandler:RemoveWidget(self) -- Disable the menu in multiplayer games
	end
end


function widget:Shutdown()
	FunctionsList.SwitchOff()
end

