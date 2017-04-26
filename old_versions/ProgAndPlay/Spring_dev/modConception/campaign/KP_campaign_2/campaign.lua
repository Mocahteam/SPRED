-- returns an array of missions which make up the campaign

local campaign = {}
campaign[1] = {VFS.Include("Mission1.lua"), VFS.LoadFile("Missions/RMC/Mission1Launcher.txt")} -- load mission 1 and its launcher
campaign[2] = {VFS.Include("Mission2.lua"), VFS.LoadFile("Missions/RMC/Mission2Launcher.txt")} -- load mission 2 and its launcher
campaign[3] = {VFS.Include("Mission3.lua"), VFS.LoadFile("Missions/RMC/Mission3Launcher.txt")} -- load mission 3 and its launcher
campaign[4] = {VFS.Include("Mission4.lua"), VFS.LoadFile("Missions/RMC/Mission4Launcher.txt")} -- load mission 4 and its launcher
campaign[5] = {VFS.Include("Mission5.lua"), VFS.LoadFile("Missions/RMC/Mission5Launcher.txt")} -- load mission 5 and its launcher
campaign[6] = {VFS.Include("Mission6.lua"), VFS.LoadFile("Missions/RMC/Mission6Launcher.txt")} -- load mission 6 and its launcher
campaign[7] = {VFS.Include("Mission7.lua"), VFS.LoadFile("Missions/RMC/Mission7Launcher.txt")} -- load mission 7 and its launcher

return campaign
