-- returns an array of missions which make up the campaign

local campaign = {}
campaign[1] = VFS.Include("Mission1.lua") -- load mission 1
campaign[2] = VFS.Include("Mission2.lua") -- load mission 2
campaign[3] = VFS.Include("Mission3.lua") -- load mission 3
campaign[4] = VFS.Include("Mission4.lua") -- load mission 4
campaign[5] = VFS.Include("Mission5.lua") -- load mission 5
campaign[6] = VFS.Include("Mission6.lua") -- load mission 6
campaign[7] = VFS.Include("Mission7.lua") -- load mission 7

return campaign
