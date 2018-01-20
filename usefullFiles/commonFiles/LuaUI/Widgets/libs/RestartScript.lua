local json=VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local reloadAvailable=(tonumber(Game.version)~=nil and tonumber(Game.version)>=99) -- nil test is made because prior to v92 Game.Version is an ugly string (e.g 0.82)
local gameName=Game.gameShortName or Game.modShortName

local function saveTxt(txt)
  if(not VFS.FileExists("Savegames/"..gameName.."/"))then
    Spring.CreateDir("Savegames/"..gameName.."/")
  end
  local file=io.open("Savegames/"..gameName.."/currentSave.sav","wb")
  file:write(txt)
  file:flush()
  file:close()
end

-- if "notAFile" is set to true, "startscript" is not considering as a file path but contains
-- directly the data as a string, usefull on genericRestart function when a .editor is used
function DoTheRestart(startscript, tableOperation, notAFile, isClient)
  -- Warning : tableOperation must not include keys which are a substring of another key in the txt file
  -- for exemple, as it happened, using a key such as mode when gamemode already exists.
  -- One idea would be to fix how regex are made in the function replace section.
	local n_infologcopy="infolog.bak.txt"
	local trimmed = ""
	if notAFile ~= nil and notAFile == true then
		-- startscript contains directly the data as a string
		trimmed = startscript
	else
		-- startscript is the path to a txt file
		Spring.Echo(widget:GetInfo().name..": Wanting to load \""..startscript.."\"")
		if VFS.FileExists(startscript) then
			trimmed=VFS.LoadFile(startscript)
			Spring.Echo("\n\n<<BEGIN DUMPING FULL \""..startscript.."\">>\n\n")
			Spring.Echo(trimmed)
			Spring.Echo("\n\n<<END DUMPING FULL \""..startscript.."\">>\n\n")
		else
			Spring.Echo(widget:GetInfo().name..": that file is not valid... Restart aborted")
			return
		end
	end
	-- update end lines
	trimmed,_=string.gsub(trimmed,"\r","") -- Remove \r
	-- remove comments
	trimmed,_=string.gsub(trimmed,"//[^\n]-[\n]+","\n") -- Remove // comments
	trimmed,_=string.gsub(trimmed,"/%*.-%*/","") -- Remove /* comments */
	-- Remove empty lines
	trimmed,_=string.gsub(trimmed,"\n%s*\n","\n")
	-- Dump result
	Spring.Echo("\n\n<<BEGIN DUMPING TRIMMED>>\n\n")
	Spring.Echo(trimmed)
	Spring.Echo("\n\n<<END DUMPING TRIMMED>>\n\n")
	-- update values
	trimmed=updateValues(trimmed, tableOperation)
	Spring.Echo("\n\n<<BEGIN DUMPING UPDATED>>\n\n")
	Spring.Echo(trimmed)
	Spring.Echo("\n\n<<END DUMPING UPDATED>>\n\n")
	-- def options
	local params = "-s"
	if isClient then
		params = "-c"
	end
	if tonumber(Spring.GetConfigInt("safemode"))==1 then
		params = "--safemode "..params
	end
	-- do the restart
	Spring.Echo(widget:GetInfo().name..": Ok, calling Spring.Restart(\""..params.."\",\"[GAME]{..}\") or Spring.Reload(\"[GAME]{..}\") if available now!")
	Spring.Echo("Making infolog.txt copy into "..n_infologcopy)
	local file=io.open(n_infologcopy,"wb")
	file:write(VFS.LoadFile("infolog.txt"))
	file:flush()
	file:close()
	saveTxt(trimmed)
	if reloadAvailable then
		Spring.Reload(trimmed)
	else
		Spring.Restart(params,trimmed)
		Spring.Echo(widget:GetInfo().name..": Just called Spring.Restart(\""..params.."\",\"[GAME]{..}\")")
		Spring.Echo(widget:GetInfo().name..": Wait, we shouldn't be here, should have restarted or crashed or quitted by now.")
	end
end

function replaceSection(fullfile,sectionName,replacement)
    local regexSection="%["..sectionName.."%]%s*%{([^%}]*)%}"
    local regexBracket="%}"
    local indexSection=string.find(fullfile,regexSection)
    local indexOfNextClosingBracked=string.find(fullfile,regexBracket,indexSection)
    local firstPart=string.sub(fullfile, 1,indexSection-1)
    local lastPart=string.sub(fullfile, indexOfNextClosingBracked+1)
    local fullstring=firstPart..replacement..lastPart
    return(fullstring)
end

function updateValues(fullFile,tableOperation)
  -- works as follow : will replace the entire sections. 
  -- For each section concerned a copy is made and replacements are done within this section
  -- If the attribute is not present then it is added at the end of the section
  for section,operations in pairs(tableOperation) do
    local regexSection="%["..section.."%]%s*%{([^%}]*)%}"
    local contentSection=string.match(fullFile,regexSection) -- contain the content of the section
    for attribute,value in pairs(operations) do
      if(string.match(contentSection,attribute.."=[^;]*;")) then
        contentSection,_=string.gsub(contentSection,attribute.."=[^;]*;",attribute.."="..value..";",1)
      else
        contentSection=contentSection.."\n\t\t"..attribute.."="..value..";"  -- If the attribute is not present then it is added at the end of the section
      end
    end
    contentSection="["..section.."]\n\t{"..contentSection.."\n\t}"
    fullFile=replaceSection(fullFile,section,contentSection) -- will replace the old section by the newly created section
  end
    --local fullFile=string.gsub(fullFile,"%["..section.."%]%s*%{([^%}]*)%}",contentSection) -- replace the content of the action
  return fullFile 
end

local function writeAttributes(file, levelOfIndentation, tableValues)
  for k,v in pairs(tableValues) do
    file=file.."\n"..string.rep("\t", levelOfIndentation+1)..k.."="..v..";"
  end
  return file
end

local function writeAttributesAndSection(file,sectionName, levelOfIndentation, tableValues)
  file=file.."\n"..string.rep("\t", levelOfIndentation).."["..sectionName.."]"
  file=file.."\n"..string.rep("\t", levelOfIndentation).."{"
  file=writeAttributes(file, levelOfIndentation, tableValues)
  file=file.."\n"..string.rep("\t", levelOfIndentation).."}"
  return file
end

local function createTxtFileContentFromScratch(editorTables, toEditor, playerName)
  local file=""
  -- GLOBAL OPTIONS
  file=file.."[GAME]\r\n{" -- This section is special as it includes other section, can't use writeAttributesAndSection, only writeAttributes
  local mapName=editorTables.description.map or "Marble_Madness_Map" 
  local name=editorTables.description.saveName 
  local lang=editorTables.description.lang or "en" 
  local table1 = {Mapname=mapName, Gametype=Game.modName, MyPlayerName=playerName, HostIP="localhost", HostPort="8451", IsHost="1",StartPosType="3"}
  file=writeAttributes(file, 0, table1)
  local table2={gamemode="3",fixedallies="0",hidemenu="1",language=lang,missionname=name,scenario="default"}
  -- activate traces if required (if true game engine will process traces: compression, alignment and produce feedbacks)
  if editorTables.description.trace == "enabled" then
	table2["activetraces"] = 1
  end
  -- activate feedbacks if required (needs traces enabled, this mod option is used in Lua side to display or not feedbacks to the player - for experiment purpose we want in some missions to process traces and compute feedback but not showing them to the player)
  if editorTables.description.feedback == "enabled" then
	table2["activefeedbacks"] = 1
  end
  file=writeAttributesAndSection(file,"MODOPTIONS", 1, table2)
  local indexPlayer=0
  local indexIA=0
  local nteam=0
  
  -- find max 
  local max=0
  if not toEditor then
	  for teamNumber,teamInformations in pairs(editorTables.teams) do
		if teamInformations.enabled and (tonumber(teamNumber)>max)then max=tonumber(teamNumber) end
	  end
  else
	  max = 9 -- The max team number in editor between team0 and team9
  end
  
  
  for teamNumber,teamInformations in pairs(editorTables.teams) do
    local allyTeamInformation=editorTables.allyteams[teamNumber]
    -- Write first section : who controls the team (player/IA)
    if(tonumber(teamNumber)<=max)then 
      nteam=nteam+1
      if (not toEditor and teamInformations.control=="player" and teamInformations.enabled==true) or
			(toEditor and tonumber(teamNumber) == 0) then 
-- if a team is player controled but disabled it should not be stored as a player  
-- controled team to avoid bug "PlayerX has name player which is already taken" 
        local sectionName="PLAYER"..tostring(indexPlayer)
        local tableController={Name=toEditor and playerName or teamInformations.name ,Spectator=toEditor and "1" or "0",Team=tostring(teamNumber)}
        indexPlayer=indexPlayer+1
        file=writeAttributesAndSection(file,sectionName, 1, tableController)   
      else -- control==computer or disabled team. Disabled team MUST be described in the txt to avoid Spring index collapsing and mismatch with editor informations
      -- when max is attained, it's not necessary to add disabled teams anymore
        local sectionName="AI"..tostring(indexIA)
        indexIA=indexIA+1
        local name=teamInformations.name or string.lower(sectionName)
        local shortName="NullAI"
        if(teamInformations.ai~=nil and teamInformations.ai~="")then
          shortName=teamInformations.ai
        end
        
        local tableController={Name=name ,ShortName=shortName,fixedallies="0",Team=tostring(teamNumber),Host="0"} 
        file=writeAttributesAndSection(file,sectionName, 1, tableController) 
      end  
      -- Write Second section : information about the team (player/IA)
      local teamSectionName="TEAM"..tostring(teamNumber)
      local arbitraryPosition=tostring(teamNumber*200+100)
      local rGBColor=tostring(teamInformations.color.red).." "..tostring(teamInformations.color.green).." "..tostring(teamInformations.color.blue)
      --local rGBColor=tostring(teamInformations.color.red).." "..tostring(teamInformations.color.blue).." "..tostring(teamInformations.color.green)
      local tableController={TeamLeader="0" ,AllyTeam=tostring(teamNumber),RGBColor=rGBColor,Side="System",StartPosX=arbitraryPosition,StartPosZ=arbitraryPosition} 
      file=writeAttributesAndSection(file,teamSectionName, 1, tableController)
      
      -- Write Third section : information about the allyteam (1 allyteam by team)
      local allyTeamSectionName="ALLYTEAM"..tostring(teamNumber)
      local NumAllies=table.getn(allyTeamInformation)
      local tableAllyTeam={NumAllies=NumAllies}    
      for i,u in pairs(allyTeamInformation) do
        local allyKey="Ally"..tostring(i-1)
        tableAllyTeam[allyKey]=u
      end
      file=writeAttributesAndSection(file,allyTeamSectionName, 1, tableAllyTeam)  
    end   
  end
  file=file.."\n}"
  return file
end

-- restart can be used for .editor files or .txt files giving some (or none) updating operation
-- toEditor is used to know if the restart is performed to go in editor, in this case we have to
-- prepare all teams
function genericRestart(missionName, options, toEditor, playerName)
	playerName = playerName or "Player0"
	if toEditor == nil then
		toEditor = false
	end
	if (string.sub(missionName, -3, -1)=="txt")then      
		DoTheRestart(missionName, options)  
	elseif (string.sub(missionName, -6, -1)=="editor")then
		Spring.Echo(widget:GetInfo().name..": Wanting to load \""..missionName.."\"")
		if VFS.FileExists(missionName) then
			local sf=VFS.LoadFile(missionName)
			Spring.Echo(widget:GetInfo().name..": try to decode \""..missionName.."\"")
			local tableEditor=json.decode(sf)
			Spring.Echo(widget:GetInfo().name..": decoded with success => build restart script")
			local txtFileContent=createTxtFileContentFromScratch(tableEditor, toEditor, playerName)
			Spring.Echo(widget:GetInfo().name..": Restart file built from \""..missionName.."\": "..txtFileContent)
			DoTheRestart(txtFileContent, options, true)
		else
			Spring.Echo(widget:GetInfo().name..": that file is not valid... Restart aborted")
		end
	else
		Spring.Echo(widget:GetInfo().name..": file extension not supported... Restart aborted")
	end   
end   


function restartAndJoinTheGame(playerName,IP)
  local table2={HostIP=IP, Hostport="8451", IsHost="0", MyPlayerName=playerName}
  local file=writeAttributesAndSection("","GAME", 0, table2)
  Spring.Echo(widget:GetInfo().name..": Join the game with: "..file)
  DoTheRestart(file, {}, true, true)--Spring.Restart("-s",file)--(this line, yes)
--[[
[GAME]
{
  HostIP=132.227.207.137;
  Hostport=8451;      // Use Hostport and not HostPort otherwaise it is overwritten by KP directLaunch
  IsHost=0;           // 0: no server will be started in this instance
                      // 1: start a server
  
  MyPlayerName=Player2; // our ingame-name (needs to match one players Name= field)
}
--]]
end 
      
