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
  for section,operations in pairs(tableOperation) do
    local regexSection="%["..section.."%]%s*%{([^%}]*)%}"
    local contentSection=string.match(fullFile,regexSection) -- contain the content of the section
    local oldSection=contentSection
    for attribute,value in pairs(operations) do
      if(string.match(contentSection,attribute.."=[^;]*;")) then
        contentSection,_=string.gsub(contentSection,attribute.."=[^;]*;",attribute.."="..value..";",1)
      else
        contentSection=contentSection.."\r\n\t\t"..attribute.."="..value..";"
      end
    end
    contentSection="["..section.."]\r\n\t{"..contentSection.."\r\n\t}"
    fullFile=replaceSection(fullFile,section,contentSection)
  end
    --local fullFile=string.gsub(fullFile,"%["..section.."%]%s*%{([^%}]*)%}",contentSection) -- replace the content of the action
  return fullFile 
end