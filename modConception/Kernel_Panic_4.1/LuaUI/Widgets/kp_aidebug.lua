
function widget:GetInfo()
  return {
    name      = "Kernel Panic A.I. Debug",
    desc      = "Display the debug information of K.P.A.I.",
    author    = "zwzsg",
    date      = "January 11, 2009",
    license   = "Free",
    layer     = 0,
    enabled   = false  -- NOT loaded by default
  }
end

function widget:Initialize()
  Spring.SendCommands({"luarules kpai 1"})
  Spring.SendCommands({"luarules fairkpai 1"})
end

function widget:GameStart()
  Spring.SendCommands({"luarules kpai 1"})
  Spring.SendCommands({"luarules fairkpai 1"})
end

function widget:Shutdown()
  Spring.SendCommands({"luarules kpai 0"})
  Spring.SendCommands({"luarules fairkpai 0"})
end
