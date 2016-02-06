context = {} -- the table representing the class, which will double as the metatable for the instances
--Context.__index = Context -- failed table lookups on the instances should fallback to the class table, to get methods
-- syntax equivalent to "Context.new = function..."


function context:new(springPath,thispath,springBridgePath) 
-- thispath is the equivalent of springBridge path for another environnement than Spring
-- For example, in Lua Dev Tools, source files are supposed to be found at the root of the project
-- This is weird but I did not find any workaround (other than building relative path starting from the root of the project)
-- Spring seems to work like that as well
  local c = {}
  c.springBridgePath=springBridgePath or ""
  c.springPath = springPath
  c.springIsAvailable=(VFS~=nil)
  c.thispath=thispath
  setmetatable(c, self)
  self.__index = self
  return c
end

function context:set_springPath(springPath)
  self.springPath = springPath
end

function context:set_thispath(thispath)
  self.thispath = thispath
end

function context:get_springPath()
  return self.springPath
end

function context:Include(filepath)
  if self.springIsAvailable then
    return (VFS.Include(self.springBridgePath..filepath)) -- TODO: Test
  else
    return dofile(self.thispath..filepath)  
  end
end

function context:LoadFile(dir,filepath)
--Load file as string
  Spring.Echo(self.springIsAvailable)
  if self.springIsAvailable then
    local fname=self.springBridgePath..filepath
    Spring.Echo("Spring is available. Try to load :  "..self.springBridgePath..filepath)
    return(VFS.LoadFile(fname))
  else
    Spring.Echo("Spring not available. Try to load :  "..dir..filepath)
    return self:readAll(dir..filepath)
  end
end

function context:LoadFileFromSpringRoot(filepath)
--Load file as string
  return self:readAll(filepath)
end

function context:readAll(file)
    Spring.Echo("Try to load From Spring root :  "..file)
    local f = io.open(file, "rb")
    if f==nil then
      return nil
    end
    local content = f:read("*all")
    f:close()
    return content
end


function context:Echo(stuffToEcho)
  if self.springIsAvailable then
    Spring.Echo(stuffToEcho)
  else 
    print(stuffToEcho)
  end
end