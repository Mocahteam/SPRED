--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Give Constants list",
    desc      = "Display for each unit its code, its name and its list of commands. Store all these data on the cstlist.txt file.",
    author    = "muratet",
    date      = "Jul 12, 2009",
    license   = "GPL v2 or later",
    layer     = 91,
    enabled   = true --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local tmpFileName = "cstlist.txt"

function WriteToFile (list)
	local f = io.open(tmpFileName, "w")
	if f ~= nil then
		f:write(list)
		f:flush()
		f:close()
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
	Spring.SendLuaRulesMsg("CstList_Gadget")
	widgetHandler:RegisterGlobal("WriteToFile", WriteToFile)
end


function widget:Shutdown()
	widgetHandler:DeregisterGlobal("WriteToFile")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------