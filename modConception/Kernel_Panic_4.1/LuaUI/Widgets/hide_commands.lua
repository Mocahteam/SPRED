function widget:GetInfo()
   return {
   version   = "1",
   name      = "Hide commands",
   desc      = "Hides some commands",
   author    = "Regret",
   date      = "February 19, 2010",
   license   = "Public Domain",
   layer     = 0,
   enabled   = true, --enabled by default
   handler   = true, --access to handler
   }
end

local HiddenCommands = {
   [CMD.MOVE_STATE] = true,
   [CMD.FIRE_STATE] = true,
   [CMD.CLOAK] = true,
   [CMD.AUTOREPAIRLEVEL] = true,
   [CMD.IDLEMODE] = true,
}

function widget:CommandsChanged()
    local cmds = widgetHandler.commands
    local n = widgetHandler.commands.n
    for i=1,n do
      if (HiddenCommands[cmds[i].id]) then
         cmds[i].hidden = true
      end
    end
end
