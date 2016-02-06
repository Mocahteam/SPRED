-- returns an array of missions which make up the campaign

local campaign = {}
campaign["Tutorial"] = {previousMission = nil, nextMission = "Mission1"}
campaign["Mission1"] = {previousMission = "Tutorial", nextMission = "Mission2"}
campaign["Mission2"] = {previousMission = "Mission1", nextMission = "Mission3"}
campaign["Mission3"] = {previousMission = "Mission2", nextMission = "Mission4"}
campaign["Mission4"] = {previousMission = "Mission3", nextMission = "Mission5"}
campaign["Mission5"] = {previousMission = "Mission4", nextMission = "Mission6"}
campaign["Mission6"] = {previousMission = "Mission5", nextMission = "Mission7"}
campaign["Mission7"] = {previousMission = "Mission6", nextMission = "Mission8"}
campaign["Mission8"] = {previousMission = "Mission7", nextMission = nil}

return campaign
