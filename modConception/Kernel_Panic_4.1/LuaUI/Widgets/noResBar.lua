function widget:GetInfo()
	return {
		name = "noResBar NoMoveWarnings",
		desc = "Removes the res bar and the \"Can't reach destintation!\" spam",
		author = "KDR_11k (David Becker)",
		date = "2007-11-18",
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

function widget:Initialize()
	Spring.SendCommands({"resbar 0"})
	Spring.SendCommands({"movewarnings 0","buildwarnings 0"})
	widgetHandler:RemoveWidget()
end

-- Fix gl.Text y offset that changed between 0.80.0 and 0.80.1
--if (tonumber(string.sub(Game.version,1,3) or 0) or 0)>=0.80 and (tonumber(string.sub(Game.version,6,6) or 0) or 0)>=1 then
	if not WG.glTextOffsetRevert then
		WG.glTextOffsetRevert=true
		local glText = gl.Text
		gl.Text = function(text,x,y,size,options)
			if (not size) or string.match(options,"[atvdb]") then
				glText(text,x,y,size,options)
			else
				glText(text,x,y,size,"d"..(options or ""))
			end
		end
	end
--end
