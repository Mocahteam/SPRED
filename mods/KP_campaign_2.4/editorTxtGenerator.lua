

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
  file=file.."[GAME]\r\n" -- This section is special as it includes other section, can't use writeAttributesAndSection, only writeAttributes
  local mapName=editorTables.description.map or "Marble_Madness_Map" 
  local name=editorTables.description.safename or "unamed"
  local lang=editorTables.description.lang or "en" 
  local table1 = {Mapname=mapName, Gametype="Kernel Panic Campaign 2.4", MyPlayerName="Player"}
  file=writeAttributes(file, 0, table1)
  local table2={jsonlocation="editor" ,gamemode="3",fixedallies="0",hidemenu="1",language=lang,missionname=name,scenario="default"}
  file=writeAttributesAndSection(file,"MODOPTIONS", 1, table2)
  for teamNumber,teamInformations in pairs(editorTables.teams) do
    local allyTeamInformation=editorTables.allyteams[teamNumber]
    print(json.encode(allyTeamInformation))
    print(json.encode(teamInformations))
  end
end

local json=dofile("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local f = io.open("./temp.editor", "rb")
local content = f:read "*a"
f:close()
local jsonContent=json.decode(content)
print(json.encode(jsonContent))
createFromScratch(jsonContent)