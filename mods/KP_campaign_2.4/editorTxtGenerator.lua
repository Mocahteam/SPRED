local json=dofile("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")

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

local function createFromScratch(editorTables)
  local file=""
  -- GLOBAL OPTIONS
  file=file.."[GAME]\r\n{" -- This section is special as it includes other section, can't use writeAttributesAndSection, only writeAttributes
  local mapName=editorTables.description.map or "Marble_Madness_Map" 
  local name=editorTables.description.safename or "Mission3"
  local lang=editorTables.description.lang or "en" 
  local table1 = {Mapname=mapName, Gametype="Kernel Panic Campaign 2.4", MyPlayerName="Player", HostIP="localhost", HostPort="0", IsHost="1" }
  file=writeAttributes(file, 0, table1)
  local table2={jsonlocation="editor" ,gamemode="3",fixedallies="0",hidemenu="1",language=lang,missionname=name,scenario="default"}
  file=writeAttributesAndSection(file,"MODOPTIONS", 1, table2)
  local indexPlayer=0
  local indexIA=0
  local indexTeam=-1 --each team is controlled by an IA or by a Player (as much as number of players + IA combined)
  for teamNumber,teamInformations in pairs(editorTables.teams) do
    indexTeam=indexTeam+1
    local allyTeamInformation=editorTables.allyteams[teamNumber]
    -- Write first section : who controls the team (player/IA)
    if(teamInformations.enabled)then
      if(teamInformations.control=="computer") then
        local sectionName="AI"..tostring(indexIA)
        indexIA=indexIA+1
        local name=teamInformations.name or string.lower(sectionName)
        local shortName=teamInformations.shortname or "NullAI"
        
        local tableController={Name=name ,ShortName=shortName,fixedallies="0",Team=tostring(indexTeam),Host="0"} 
        file=writeAttributesAndSection(file,sectionName, 1, tableController)    
      elseif (teamInformations.control=="player") then
        local sectionName="PLAYER"..tostring(indexPlayer)
        local name=teamInformations.name or string.lower(sectionName)
        indexPlayer=indexPlayer+1
        local tableController={Name="Player" ,Spectator="0",Team=tostring(indexTeam)} 
        file=writeAttributesAndSection(file,sectionName, 1, tableController)   
      end
      -- Write Second section : information about the team (player/IA)
      local teamSectionName="TEAM"..tostring(indexTeam)
      local rGBColor=tostring(teamInformations.color.red).." "..tostring(teamInformations.color.green).." "..tostring(teamInformations.color.blue)
      local tableController={TeamLeader="0" ,AllyTeam=tostring(indexTeam),RGBColor=rGBColor,Side="System",StartPosX="1792",StartPosZ="1792"} 
      file=writeAttributesAndSection(file,teamSectionName, 1, tableController)
      
      -- Write Third section : information about the allyteam (1 allyteam by team)
      local allyTeamSectionName="ALLYTEAM"..tostring(indexTeam)
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

local f = io.open("./temp.editor", "rb")
local content = f:read "*a"
f:close()
local jsonContent=json.decode(content)
print(json.encode(jsonContent))
local file=createFromScratch(jsonContent)
print(file)