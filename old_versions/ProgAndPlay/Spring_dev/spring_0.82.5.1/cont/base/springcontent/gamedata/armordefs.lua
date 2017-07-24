--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    armordefs.lua
--  brief:   armor.txt lua parser
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local tdfFile = 'armor.txt'
if (not VFS.FileExists(tdfFile)) then
  return {}
end


local TDF = VFS.Include('gamedata/parse_tdf.lua')
local armor, err = TDF.Parse(tdfFile)
if (armor == nil) then
  error('Error parsing armor.txt: ' .. err)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return armor

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------