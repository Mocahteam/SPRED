
function widget:GetInfo()
	return {
		name = "Kernel Panic Console Commands",
		desc = "Remove the need to add /luarules in front of some gadgets command",
		author = "zwzsg",
		date = "15th July, 2009",
		license = "Public Domain",
		layer = 0,
		enabled = true,
		handler = false,
	}
end

function widget:AddConsoleLine(argument_line,argument_priority)
	local line="\n"..argument_line
	-- I add a \n before because I don't think a console line would start by a new line,
	-- and that way I can detect that my trigger words are at the beginning of the line and not in the middle.
	local cw=string.match(line,"\n/cw(.+)") or string.match(line,"\n/colorwar(.+)") or string.match(line,"\n/colorwars(.+)")
	if cw then
		Spring.SendCommands({"luarules cw"..cw})
	end
	local kpai=string.match(line,"\n/kpai(.+)") or (line=="\n/kpai" and "" or nil)
	if kpai then
		Spring.SendCommands("luarules kpai"..kpai)
		Spring.SendCommands("luarules fairkpai"..kpai)
	end
	local ons=string.match(line,"\n/ons (.+)") or string.match(line,"\n/ons\t(.+)") or (line=="\n/ons" and "" or nil)
	if ons then
		Spring.SendCommands("luarules ons "..ons)
	end
	local sos=string.match(line,"\n/sos (.+)") or string.match(line,"\n/sos\t(.+)") or (line=="\n/sos" and "" or nil)
	if sos then
		Spring.SendCommands("luarules sos "..sos)
	end
	local som=string.match(line,"\n/som (.+)") or string.match(line,"\n/som\t(.+)") or (line=="\n/som" and "" or nil)
	if som then
		Spring.SendCommands("luarules sos "..som)
	end
	local dump=string.match(line,"\n/dump (.+)") or string.match(line,"\n/dump\t(.+)") or (line=="\n/dump" and "" or nil)
	if dump then
		Spring.SendCommands("luarules dump "..dump)
	end
end
