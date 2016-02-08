-- returns an array of missions which make up the campaign

local campaign = {}
campaign[0] = {VFS.Include("Tuto.lua"), "Tutorial.txt"} -- load tutorial and its launcher
campaign[1] = {VFS.Include("Mission1.lua"), "Mission1.txt"} -- load mission 1 and its launcher
campaign[2] = {VFS.Include("Mission2.lua"), "Mission2.txt"} -- load mission 2 and its launcher
campaign[3] = {VFS.Include("Mission3.lua"), "Mission3.txt"} -- load mission 3 and its launcher
campaign[4] = {VFS.Include("Mission4.lua"), "Mission4.txt"} -- load mission 4 and its launcher
campaign[5] = {VFS.Include("Mission5.lua"), "Mission5.txt"} -- load mission 5 and its launcher
campaign[6] = {VFS.Include("Mission6.lua"), "Mission6.txt"} -- load mission 6 and its launcher
campaign[7] = {VFS.Include("Mission7.lua"), "Mission7.txt"} -- load mission 7 and its launcher
campaign[8] = {VFS.Include("Mission8.lua"), "Mission8.txt"} -- load mission 8 and its launcher

return campaign
