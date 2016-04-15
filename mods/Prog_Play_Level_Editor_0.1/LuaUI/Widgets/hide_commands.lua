function widget:GetInfo()
   return {
   version   = "1",
   name      = "Hide commands",
   desc      = "Hides all commands",
   author    = "Regret",
   date      = "February 19, 2010",
   license   = "Public Domain",
   layer     = 0,
   enabled   = true, --enabled by default
   handler   = true, --access to handler
   }
end

function widget:CommandsChanged()
    local cmds = widgetHandler.commands
    local n = widgetHandler.commands.n
    for i=1,n do
		cmds[i].hidden = true
    end
end
