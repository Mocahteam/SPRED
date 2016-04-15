function DoTheRestart(startscriptfilename, tableOperation)
  -- Warning : tableOperation must not include keys which are a substring of another key in the txt file
  -- for exemple, as it happened, using a key such as mode when gamemode already exists.
  -- One idea would be to fix how regex are made in the function replace section.
	local n_infologcopy="infolog.bak.txt"
	Spring.Echo("test")
	Spring.Echo(widget:GetInfo().name..": Wanting to reload \""..startscriptfilename.."\"")
	if VFS.FileExists(startscriptfilename) then
		local complete=VFS.LoadFile(startscriptfilename)
    complete=updateValues(complete, tableOperation)
		Spring.Echo("\n\n<<BEGIN DUMPING FULL \""..startscriptfilename.."\">>\n\n")
		Spring.Echo(complete)
		Spring.Echo("\n\n<<END DUMPING FULL \""..startscriptfilename.."\">>\n\n")
		local trimmed=complete
		trimmed,_=string.gsub(trimmed,"//[^\r\n]-[\r\n]+","\n")-- Remove // comments
		trimmed,_=string.gsub(trimmed,"/%*.-%*/","")-- Remove /* comments */
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
	else
		Spring.Echo(widget:GetInfo().name..": that file is not valid... Restart aborted")
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
	Spring.Echo(fullFile)
  -- works as follow : will replace the entire sections. 
  -- For each section concerned a copy is made and replacements are done within this section
  -- If the attribute is not present then it is added at the end of the section
  for section,operations in pairs(tableOperation) do
    local regexSection="%["..section.."%]%s*%{([^%}]*)%}"
    local contentSection=string.match(fullFile,regexSection) -- contain the content of the section
    local oldSection=contentSection
    for attribute,value in pairs(operations) do
      if(string.match(contentSection,attribute.."=[^;]*;")) then
        contentSection,_=string.gsub(contentSection,attribute.."=[^;]*;",attribute.."="..value..";",1)
      else
        contentSection=contentSection.."\r\n\t\t"..attribute.."="..value..";"  -- If the attribute is not present then it is added at the end of the section
      end
    end
    contentSection="["..section.."]\r\n\t{"..contentSection.."\r\n\t}"
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

local function createFromScratch(editorTables)
  local file=""
  -- GLOBAL OPTIONS
  file=file.."[GAME]\r\n" -- This section is special as it includes other section, can't use writeAttributesAndSection, only writeAttributes
  local mapName=editorTables.description.map or "Marble_Madness_Map" 
  local name=editorTables.description.safename or "unamed"
  local lang=editorTables.description.lang or "en" 
  local table1 = {Mapname=mapName, Gametype="Prog & Play Level Editor 0.1", MyPlayerName="Player"}
  file=writeAttributes(file, 0, table1)
  local table2={jsonlocation="editor" ,gamemode="3",fixedallies="0",hidemenu="1",language=lang,missionname=name,scenario="default"}
  file=writeAttributesAndSection(file,"MODOPTIONS", 1, table2)
  for teamNumber,teamInformations in pairs(editorTables.teams) do
    local allyTeamInformation=pairs(editorTables.allyteams[teamNumber])
  end
end

