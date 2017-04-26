function DoTheRestart(startscriptfilename, lang, scenario)
	local n_infologcopy="infolog.bak.txt"
	Spring.Echo(widget:GetInfo().name..": Wanting to reload \""..startscriptfilename.."\"")
	if VFS.FileExists(startscriptfilename) then
		local complete=VFS.LoadFile(startscriptfilename)
		Spring.Echo(widget:GetInfo().name..": that file contains:")
		complete,_=string.gsub(complete,"language=[^;]*;","language="..lang..";",1)
		if scenario ~= nil then
			complete,_=string.gsub(complete,"scenario=[^;]*;","scenario="..scenario..";",1)
		end
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