
-- Todo: Take into account abilities removed by Evilless
-- Todo: Test CountTheirs(flow)
-- Todo: Test specials on/off and connection

function widget:GetInfo()
	return {
		name = "Kernel Panic Automatic Tip Dispenser",
		desc = "Teach you to play the game, one tip at a time",
		author = "zwzsg",
		date = "July 30th, 2009",
		license = "Public Domain",
		layer = 8,
		enabled = true
	}
end

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

local TipsList = {}
local CurrentTipText = ""
local TipTimer
local TipPeriod = 10 -- How long each tip is displayed, in seconds
local FontSize = nil
local SoundTable = {}
local SoundToggle = true
local MouseButton = nil

local function SortCompareTables(t1,t2)
	table.sort(t1)
	table.sort(t2)
	if #t1~=#t2 then
		return false
	else
		for k=1,#t1 do
			if t1[k]~=t2[k] then
				return false
			end
		end
		return true
	end
end

-- The round2 function from http://lua-users.org/wiki/SimpleRound fails on 0.11
local function FormatNbr(x,digits)
	local _,fractional = math.modf(x)
	if fractional==0 then
		return x
	elseif fractional<0.01 then
		return math.floor(x)
	elseif fractional>0.99 then
		return math.ceil(x)
	else
		local ret=string.format("%."..(digits or 0).."f",x)
		if digits and digits>0 then
			while true do
				local last = string.sub(ret,string.len(ret))
				if last=="0" or last=="." then
					ret = string.sub(ret,1,string.len(ret)-1)
				end
				if last~="0" then
					break
				end
			end
		end
		return ret
	end
end

local function MakePlural(str)
	local ending=string.sub(str,string.len(str),string.len(str))
	if ending=="y" and string.lower(str)~="gateway" then
		return string.sub(str,1,string.len(str)-1).."ies"
	elseif ending==">" or ending=="s" then
		return str
	else
		return str.."s"
	end
end

local function GetFixedSide(team_optional)
	local t=team_optional or Spring.GetMyTeamID()
	local _,_,_,_,side=Spring.GetTeamInfo(t)
	local function TeamHas(team,unitdefid)
		return Spring.GetTeamUnitDefCount(team,unitdefid) and Spring.GetTeamUnitDefCount(team,unitdefid)>=1
	end
	if TeamHas(t,kernel) then
		side="System"
	elseif TeamHas(t,hole) then
		side="Hacker"
	elseif TeamHas(t,holeold) then
		side="OldHacker"
	elseif TeamHas(t,carrier) then
		side="Network"
	elseif TeamHas(t,thbase) then
		side="Touhou"
	elseif TeamHas(t,socket) then
		side="System"
	elseif TeamHas(t,window) then
		side="Hacker"
	elseif TeamHas(t,windowold) then
		side="Hacker"
	elseif TeamHas(t,port) then
		side="Network"
	elseif TeamHas(t,thminifac) then
		side="Touhou"
	elseif TeamHas(t,assembler) then
		side="System"
	elseif TeamHas(t,trojan) then
		side="Hacker"
	elseif TeamHas(t,trojanold) then
		side="OldHacker"
	elseif TeamHas(t,gateway) then
		side="Network"
	elseif TeamHas(t,alice) then
		side="Touhou"
	elseif TeamHas(t,terminal) then
		side="System"
	elseif TeamHas(t,obelisk) then
		side="Hacker"
	elseif TeamHas(t,firewall) then
		side="Network"
	elseif TeamHas(t,hand) or TeamHas(t,rock) or TeamHas(t,paper) or TeamHas(t,scissors) then
		side="RPS"
	end
	return side
end

local function GetFixedUnitNames(team_optional)
	local un={}
	local team=team_optional or Spring.GetMyTeamID()
	local side=string.lower(GetFixedSide(team))
	if side=="system" then
		un.homebase="Kernel"
		un.minifac="Socket"
		un.special="Terminal"
		un.cons="Assembler"
		un.spam="Bit"
		un.heavy="Byte"
		un.arty="Pointer"
	elseif side=="hacker" or side=="oldhacker" then
		un.homebase="Security Hole"
		un.minifac="Window"
		un.special="Obelisk"
		un.cons="Trojan"
		un.spam="Bug"
		un.heavy="Worm"
		un.arty="DoS"
	elseif side=="network" then
		un.homebase="Carrier"
		un.minifac="Port"
		un.special="Firewall"
		un.cons="Gateway"
		un.spam="Packet"
		un.heavy="Connection"
		un.arty="Flow"
	elseif side=="touhou" then
		un.homebase="Large Magical Circle"
		un.minifac="Small Magical Circle"
		un.special="<Not Disponible>"
		un.cons="Alice"
		un.spam="Fairy"
		un.heavy="Reimu"
		un.arty="Marisa"
	elseif side=="rps" then
		un.homebase="Hand"
		un.minifac="Hand"
		un.special="Hand"
		un.cons="Rock, Paper, or Scissors"
		un.spam="Rock, Paper, or Scissors"
		un.heavy="Rock, Paper, or Scissors"
		un.arty="Rock, Paper, or Scissors"
	else
		un.homebase="HomeBase"
		un.minifac="MiniFac"
		un.special="Special"
		un.cons="Constructor"
		un.spam="Spaem"
		un.heavy="Heavy"
		un.arty="Arty"
	end
	un.homebases=MakePlural(un.homebase)
	un.minifacs=MakePlural(un.minifac)
	un.specials=MakePlural(un.special)
	un.conss=MakePlural(un.cons)
	un.spams=MakePlural(un.spam)
	un.heavies=MakePlural(un.heavy)
	un.arties=MakePlural(un.arty)
	return un
end

local function AddTip(arg1,arg2,arg3)
	local Weight,Text,Sound=1,"",nil
	if type(arg2)=="nil" then
		Text=arg1
	elseif arg3 then
		Weight,Text,Sound=arg1,arg2,arg3
	elseif type(arg1)=="number" and type(arg2)=="string" then
		Weight,Text=arg1,arg2
	elseif type(arg1)=="string" and type(arg2)=="number" then
		Text,Sound=arg1,arg2
	end
	table.insert(TipsList,{Weight=Weight,Text=Text,Sound=Sound})
end

local function CountMy(UnitKind)
	local Got=Spring.GetTeamUnitsByDefs(Spring.GetMyTeamID(),UnitKind)
	if Got==nil then
		return 0
	else
		return #Got
	end
end

local function CountTheirs(UnitKind)
	local nGot=0
	for _,team in ipairs(Spring.GetTeamList()) do
		if not Spring.AreTeamsAllied(team,Spring.GetMyTeamID()) then
			nGot=nGot+#(Spring.GetTeamUnitsByDefs(team,UnitKind) or {})
		end
	end
	return nGot
end

local function Prevalence(UnitKind)
	local team=Spring.GetMyTeamID()
	local Total=Spring.GetTeamUnitCount(team)
	if Total==0 then
		return 0
	else
		return CountMy(UnitKind)/Total
	end
end

local function isSelected(UnitKind)
	local isSelected=false
	for _,u in ipairs(Spring.GetTeamUnitsByDefs(Spring.GetMyTeamID(),UnitKind)) do
		if Spring.IsUnitSelected(u) then
			isSelected=true
		end
	end
	return isSelected
end

local function PSC(UnitKind,PrevalenceWeight,isSelectedWeight)
	PrevalenceWeight=PrevalenceWeight or 1
	isSelectedWeight=isSelectedWeight or 1
	return PrevalenceWeight*Prevalence(UnitKind)+isSelectedWeight*(isSelected(UnitKind) and 1 or 0)
end

local function GetDamage(predator,prey)
	return WeaponDefs[UnitDefs[UnitDefNames[predator].id].weapons[1].weaponDef].damages[UnitDefs[UnitDefNames[prey].id].armorType]
end

local function GetDamageBonus(predator,prey)
	return FormatNbr(GetDamage(predator,prey)/GetDamage(predator,"hand"),1)
end

local function GetTipsList()
	local un=GetFixedUnitNames()
	local t=Spring.GetMyTeamID()
	local BufferSize=Spring.GetTeamRulesParam(t,"bufferSize") or 0
	local specials = tonumber(Spring.GetModOptions()["nospecials"] or "0")==0
	TipsList={}

	-- Always shown tips
	AddTip("Use F11 to toggle \"widgets\",\nsuch as this automatic tip dispenser.",87)
	AddTip("Click that blue box to disable tips voice over",88)
	-- ("Tips voice-over is on",91)
	-- ("Tips voice-over is off",92)

	-- Special case: Heroes of Mainframe
	if Spring.GetModOptions()["homf"] and Spring.GetModOptions()["homf"]~="0" then
		AddTip(12,"Move with arrow keys",711)
		AddTip(5,"Aim with mouse",712)
		AddTip(6,"Fire with left mouse button",713)
		if WG.HeroRightClick==1 then
			if CountMy(cons)>0 then
				AddTip(1,"Right click on Datavent:\nBUILD a "..un.minifac.." with a random "..un.cons,721)
			end
			if CountMy(spam)+CountMy(heavy)+CountMy(cons) then
				AddTip(1,"Right click on Ally:\nGUARD with every "..un.spams..", "..un.heavies.." and idle "..un.conss,722)
				AddTip(3,"Issue order to rest of army\nwith right mouse mouse button",723)
			end
			if CountMy(spam)+CountMy(heavy)+CountMy(arty) then
				AddTip(1,"Right click on Ground:\nMOVE every "..un.spams..", "..un.heavies..", "..un.arties,724)
				AddTip(1,"Right click on Enemy:\nATTACK with every "..un.spams..", "..un.heavies..", "..un.arties,725)
			end
		end
		return
	end

	-- General interface tips
	AddTip("Ctrl + F1 to F5 to change camera mode.\nCtrl F2 is the default (TA Overhead).",11)
	AddTip("Use Mouse Wheel to zoom in and out",12)

	-- Beginning: Getting the homebase to build the first constructor
	if CountMy(MiniFac)+CountMy(cons)==0 then
		if Spring.GetTeamUnitCount(t)==0 then
			if Spring.GetGameFrame()>90 then -- 3 seconds
				AddTip("Oops! Looks like you're dead.",21)
			elseif Game.startPosType==2 and Spring.GetGameFrame()==0 then
				AddTip("Pick a starting position\nThen click ready.",22)
				AddTip("Do not spawn in a cliff!",23)
				AddTip("Choose a flat area!",24)
				AddTip("The light yellow squares are usually datavents\nStarting over one mean one less datavent for your team.",25)
			else
				AddTip("Game is loading.",26)
				AddTip("If it takes forever\nYou may want to consider Alt+F.",27)
			end
		elseif CountMy(HomeBase)>=1 then
			if Spring.GetSelectedUnitsCount()==0 then
				AddTip("Select your "..un.homebase.." and build some "..un.conss,31)
				AddTip("Select your "..un.homebase.." by left clicking it.",32)
			else
				AddTip("On the left is a \"BuildMenu.\"\nLeft-Click the "..un.cons.." icon in it.",33)
			end
			AddTip("Build some "..un.conss.."!",34)
			AddTip("Use your "..un.homebase.." to make one "..un.cons,35)
			AddTip("Alternatively, you can command your "..un.homebase.."\nwith the build bar on the top right corner.",36)
		end

	-- Beginning: Getting constructor(s) to build the first minifac
	elseif CountMy(cons)>=1 and CountMy(MiniFac)==0 then
		local isConsSelected=false
		for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,cons)) do
			if Spring.IsUnitSelected(u) then
				isConsSelected=true
			end
		end
		if not isConsSelected then
			AddTip("Select "..un.cons.." to make a "..un.minifac,37)
		end
		AddTip("Build some "..un.minifacs.."!",38)
		AddTip("Use your "..un.cons.." to make a "..un.minifac,39)
		if CountMy(SpecialBuilding)>=1 then
			local function aan(str)
				local c=string.lower(string.sub(str,1,1))
				if c=="a" or c=="e" or c=="i" or c=="o" or c=="u" then
					return "an "..str
				else
					return "a "..str
				end
			end
			AddTip("These are no "..un.minifacs.."!\nThese are "..un.specials.."!",40)
			AddTip("Nooooooo! Don't make "..aan(un.special).." now!",41)
			AddTip("It is really not the time to make "..un.specials..".",42)
			AddTip("Make "..un.minifacs.." not "..un.specials,43)
			AddTip("The "..un.special.." is a late game unit.\nWhat you need now is "..aan(un.minifac)..".",44)
		end

	-- Once the player has started getting stuff done
	else

		if CountMy(cons)>=1 then
			AddTip("Expand! You never have enough "..un.minifacs.."!",51)
		end
		if CountMy(HomeBase)+CountMy(MiniFac)-CountMy(hand)>=1 then
			AddTip(CountMy(cons)==0 and 20 or 1+5*(1-5*math.min(0.2,Prevalence(cons))),"You need "..un.conss.." to expand!",52)
		end
		if Prevalence(spam)<0.9 and CountMy(cons)+CountMy(MiniFac)>=0 then
			AddTip("Spaem more "..un.spams.."!",53)
		end

		if CountMy(HomeBase)+CountMy(hand)>=1 then
			AddTip("The build bar on the top right corner\nlet you control your "..un.homebase.." production\nanywhere, anytime, without having to select it",54)
		end

		if CountMy(HomeBase)+CountMy(MiniFac)+CountMy(spam)-CountMy(virus)>=1 then
			AddTip(2+PSC(spam),un.spams.." are your spam units:\nLight, fast, cheap, expandable.",55)
			AddTip(2+PSC(spam),un.spams.." must be used in numbers to be effective.",56)
		end
		if CountMy(HomeBase)+CountMy(heavy)>=1 then
			AddTip(1+4*PSC(heavy),un.heavies.." are your heavy units:\nSlow, heavily armored, short ranged, expensive.",57)
			AddTip(1+4*PSC(heavy),un.heavies.." are best used against smaller enemies.",58)
		end
		if CountMy(HomeBase)+CountMy(arty)>=1 then
			AddTip(1+4*PSC(arty),un.arties.." are your arty:\nFrail and expensive.",59)
			if string.lower(un.arty)~="flow" then
				AddTip(1+4*PSC(arty),"Never send "..un.arties.." to the frontline alone.",60)
			end
		end
		if CountMy(HomeBase)+CountMy(cons)>=1 then
			AddTip(1+2*PSC(cons),un.conss.." are your constructors:\nUse them to raise new "..un.minifacs..", not to fight.",61)
			AddTip(1+2*PSC(cons),un.conss.." raison d'etre is to build, not to attack.",62)
			AddTip(1+4*PSC(cons),un.conss.." are equipped with a radar\nto see cloacked units.",63)
		end
		if CountMy(cons)+CountMy(MiniFac)>=1 and CountMy(HomeBase)>=1 then
			AddTip(0.3+8*PSC(MiniFac),"Every "..un.minifac.." gives a 20% boost to your "..un.homebase.." buildspeed.\n(In addition to spawning "..un.spams..")",64)
		end
		if CountMy(SpecialBuilding)>=1 then
			AddTip(1+PSC(SpecialBuilding,20,1),"You need in priority "..un.minifacs..", not "..un.specials,65)
			AddTip(1+PSC(SpecialBuilding,3,9),un.specials.." must be fired manually",66)
		end

		if CountMy({rock,paper,scissors})>=1 then
			AddTip(10,"Hands spawn automatically when you have a rock, paper, or scissors near a datavent.",5511)
			AddTip(10,"Send a rock, paper or scissors next to a datavent: A hand will appear!",5512)
			AddTip(10,"Minifacs are autobuilt by sending units in proximity to a datavent.",5513)
			for _,ud1 in ipairs({rock,paper,scissors}) do
				for _,ud2 in ipairs({rock,paper,scissors}) do
					if ud1~=ud2 then
						if CountMy(ud1)>=1 then
							local v=nil
							if SortCompareTables({ud1,ud2},{rock,scissors}) then
								v=5514
							elseif SortCompareTables({ud1,ud2},{scissors,paper}) then
								v=5515
							elseif SortCompareTables({ud1,ud2},{paper,rock}) then
								v=5516
							end
							AddTip(4+3*PSC(ud1),MakePlural(UnitDefs[ud1].humanName).." do x"
								..GetDamageBonus(UnitDefs[ud1].name,UnitDefs[ud2].name)
								.." damage to "..MakePlural(UnitDefs[ud2].humanName),v)
						end
					end
				end
			end
		end

		if CountMy(bug)>=4 and specials then
			AddTip(1+PSC(bug,2,4),"Bugs can flip into \"exploit\", a static cannon,\nwith Bombard or Deploy button!",2101)
		end
		if CountMy(exploit)>=1 then
			AddTip(1+PSC(exploit,2,8),"Exploits deal more damage at longer range.",2102)
			AddTip(1+PSC(exploit,2,8),"Exploits are more fragile than bugs.",2103)
		end
		if CountMy(bugold)>=1 and specials then
			AddTip(1+PSC(bugold,2,4),"Bugs can burrow into the ground,\nbecoming hidden proximity mines.")
		end
		if CountMy(port)>=1 then
			AddTip(1+PSC(port,2,14),"Ports don't directly spawn unit\nInstead they increase the \"Buffer\"",3104)
		end
		if BufferSize>=8 then
			local w=1+5*BufferSize/(1+(Spring.GetTeamUnitCount(t) or 0))
			AddTip(w,"Use the Dispatch button to create packets from buffer.",3105)
			AddTip(w,"The \"Buffer\" represent virtual units\nthat can be materialised at every Port or Connection.",3106)
		end
		if CountMy(packet)>=1 then
			AddTip(1+PSC(packet,2,4),"Packets can re-enter the buffer\nby right clicking any Port"..(specials and " or Connection" or ""),3107)
		end

		if CountMy(byte)>=1 then
			AddTip(1+4*PSC(byte),"Bytes are more armored when closed.",1108)
			if specials then
				AddTip(1+4*PSC(byte),"Bytes' special ability is the mine-launcher:\nCost quite a chunk of health,\nBut mighty against swarms.",1109)
			end
		end
		if CountMy(worm)>=1 then
			AddTip(1+2*PSC(worm),"Worms do not attack when cloacked,\nunless you switch AutoHold off.",2110)
			AddTip(1+2*PSC(worm),"Press Ctrl+A then set AutoHold off\nfor current and future worms\nto autoattack when cloacked.",2111)
			AddTip(1+2*PSC(worm),"Worms' bite is infectious:\nCasualties turn into virus.",2112)
			AddTip(1+2*PSC(worm),"Worms have a seismic detector\nto sense moving units.",2113)
		end
		if CountMy(wormold)>=1 and specials then
			AddTip(1+PSC(wormold,2,4),"Worms can burrow into the ground,\nTrading speed for cloacking.")
		end
		if CountMy(connection)>=1 and specials then
			AddTip(1+4*PSC(connection),"Connection act as teleport beacons:\nUse the dispatch button!",3114)
			AddTip(1+4*PSC(connection),"Connection can\ndraw packets from / refill buffer with\npackets, but do not generate any.",3115)
		end

		if CountMy(kernel)+CountMy(pointer)>=1 then
			AddTip(1+2*PSC(pointer),"Pointers are artillery:\nLightly armored and expensive,\nbut with a powerful long ranged weapon.",1116)
			AddTip(1+2*PSC(pointer),"Use Pointers to destroy buildings\nand heavy units from afar.",1117)
			AddTip(1+2*PSC(pointer),"Pointers's weapon is guided:\nIt will lock and home on moving target.",1118)
			if CountMy(pointer)>=1 then
				AddTip(1+PSC(pointer,2,4),"Do NOT let the enemy come close to your Pointers.",1119)
				if specials then
					AddTip(1+PSC(pointer,2,4),"Pointer's secondary weapon is the NX flag,\nwhich deals damage over time over area.")
				end
			end
			if CountTheirs(flow) then
				AddTip(9,"Pointers' tracking shot\nmakes them great against flow!")
			end
		end
		if CountMy(marisa)>=1 then
			AddTip(1+PSC(marisa,2,5),"Marisa must keep her distance from the enemy.",4120)
			AddTip(1+PSC(marisa,3,10),"Marisa cannot fire while moving.",4121)
		end
		if CountMy(hole)+CountMy(dos)>=1 then
			AddTip(1+6*PSC(dos),"DoS are paralyzers:\nThey cannot kill.",2122)
		end
		if CountMy(carrier)+CountMy(flow)>=1 then
			AddTip(1+4*PSC(flow),"Flows are the only flying units in this game.",3123)
			if CountMy(flow)>=1 then
				AddTip(1+4*PSC(flow),"Flows get a speed increase with every "..un.minifac,3124)
			end
		end

		if CountMy(terminal)>=1 then
			AddTip(1+PSC(terminal,3,9),"Terminal does reduced damage toward buildings.\nBest use it against large groups of light units.",1125)
		end
		if CountMy(obelisk)>=1 then
			AddTip(1+PSC(obelisk,3,9),"Obelisk gas cloud casualties are turned into virus",2126)
		end
		if CountMy(firewall)>=1 then
			AddTip(1+PSC(firewall,3,9),"The firewall casts a protection on your unit:\n- Halve the damage taken\n- Send that half back to attacker",3127)
		end

		if CountMy(badblock)>=1 then
			AddTip(12,"You cannot win by walling yourself in!",71)
		end
		AddTip(1+12*CountMy(badblock),"The best defense is offense.",72)
		if CountMy(mineblaster)>=1 then
			AddTip(30,"The Debugger sole purpose\nis to remove Bad Blocks and Logic Bombs.",73)
		end

		AddTip("Left click to select a unit\nKeep button down to drag a selection box",81)
		AddTip("Left click in empty area to deselect units.",82)
		AddTip("Right click to issue default order\nKeep button down to move in formation",83)
		AddTip("Left click an action on the menu in the right\nThen left click in the terrain\nTo give specific orders.",84)
		AddTip("Many commands can be issued over a whole area\nBy keeping button down and dragging a box or disc.",85)
		AddTip("Use the SHIFT key to enqueue orders",86)

	end
end

-- Regenerate TipsList then pick one
local function GetRandomTip()
	GetTipsList()-- Create TipsList according to what's going on
	if #TipsList>=2 then
		local w=0
		for t,_ in ipairs(TipsList) do
			if CurrentTipText==TipsList[t].Text then
				TipsList[t].Weight=0
			end
			w=w+TipsList[t].Weight
		end
		local d = w*math.random()
		w=0
		for t,_ in ipairs(TipsList) do
			w=w+TipsList[t].Weight
			if w>=d then
				return TipsList[t].Text,TipsList[t].Sound
			end
		end
		return "Could not fetch tip",nil
	elseif #TipsList==1 then
		return TipsList[1].Text,TipsList[1].Sound
	else
		return "",nil
	end
end

function widget:Initialize()
	if Spring.GetModOptions()["missionscript"] then
		widgetHandler:RemoveWidget()
		return
	end
	local TipSoundFileList=VFS.DirList("sounds/tips")
	for _,FileName in ipairs(TipSoundFileList) do
		local ext=string.lower(string.sub(FileName,-4))
		if ext==".ogg" or ext==".wav" then
			local pref=string.match(FileName,".*%/(%d+)%.%a+")
			if pref and (ext==".ogg" or SoundTable[tonumber(pref) or pref]==nil) then
				SoundTable[tonumber(pref) or pref]=FileName
			end
		end
	end
	-- List the tips that do not contain side specific words:
	for _,t in ipairs({87,88,711,712,713,11,12,21,22,23,24,25,26,27,71,72,73,81,82,83,84,85,86}) do
		for s=1000,5000,1000 do
			if not SoundTable[s+t] then-- If they have no side specific voice file
				if not SoundTable[3000+t] then
					Spring.Echo("No sound for tip #"..s+t..", default #"..(3000+t).." not available either!")
				else
					SoundTable[s+t]=SoundTable[3000+t]-- Make them use the Network voice
					--Spring.Echo("No sound for tip #"..s+t..", defaulting to "..(3000+t))
				end
			end
		end
	end
	local function QS(a)
		if type(a)=="number" then
			return tostring(a)
		elseif type(a)=="string" then
			return "\""..a.."\""
		else
			return "("..tostring(type(a))..")"..a
		end
	end
	if Spring.IsDevLuaEnabled() then
		Spring.Echo("<SoundTable>")
		for key,value in pairs(SoundTable) do
			Spring.Echo("Soundtable["..QS(key).."]="..QS(value))
		end
		Spring.Echo("</SoundTable>")
	end
end

function widget:GameFrame(f)

end

function widget:Shutdown()
	WG.KP_AutomaticTipDispenser=nil
end

function widget:MouseWheel(up,value)
	if WG.KP_AutomaticTipDispenser then
		local x1=WG.KP_AutomaticTipDispenser.x1
		local x2=WG.KP_AutomaticTipDispenser.x2
		local y1=WG.KP_AutomaticTipDispenser.y1
		local y2=WG.KP_AutomaticTipDispenser.y2
		if x1 and x2 and y1 and y2 then
			local xMouse,yMouse = Spring.GetMouseState()
			if xMouse>math.min(x1,x2) and xMouse<math.max(x1,x2) and yMouse>math.min(y1,y2) and yMouse<math.max(y1,y2) then
				if up then
					FontSize = math.max(FontSize - 1,2)
				else
					FontSize = FontSize + 1
				end
				return true
			end
		end
	end
	return false
end

function widget:MousePress(xm, ym, button)
	if WG.KP_AutomaticTipDispenser then
		local x1=WG.KP_AutomaticTipDispenser.x1
		local x2=WG.KP_AutomaticTipDispenser.x2
		local y1=WG.KP_AutomaticTipDispenser.y1
		local y2=WG.KP_AutomaticTipDispenser.y2
		if x1 and x2 and y1 and y2 then
			if xm>math.min(x1,x2) and xm<math.max(x1,x2) and ym>math.min(y1,y2) and ym<math.max(y1,y2) then
				MouseButton=button
				return true
			end
		end
	end
	return false
end

function widget:DrawScreenEffects(vsx, vsy)

	WG.KP_AutomaticTipDispenser=nil

	if Spring.IsGUIHidden() or Spring.GetSpectatingState() then
		return
	end

	if MouseButton then
		MouseButton=nil
		SoundToggle=not SoundToggle
		CurrentTipText="Voice: "..(SoundToggle and "ON" or "OFF")
		local Sound=3000+(SoundToggle and 91 or 92)
		-- Doesn't handle different voices per factions, but anyway I only got one voice for these
		if SoundTable[Sound] then
			Spring.PlaySoundFile(SoundTable[Sound])
		end
	end

	if (not Timer) or Spring.DiffTimers(Spring.GetTimer(),Timer) > TipPeriod then
		local Sound=nil
		Timer=Spring.GetTimer()
		CurrentTipText,Sound=GetRandomTip()
		if SoundToggle and Sound then
			if type(Sound)=="number" and math.abs(Sound)<1000 then
				local side=string.lower(GetFixedSide())
				if side=="system" then
					Sound=1000+Sound
				elseif side=="hacker" or side=="oldhacker" then
					Sound=2000+Sound
				elseif side=="network" then
					Sound=3000+Sound
				elseif side=="touhou" then
					Sound=4000+Sound
				elseif side=="rps" then
					Sound=5000+Sound
				end
			end
			if SoundTable[Sound] then
				Spring.PlaySoundFile(SoundTable[Sound])
				--Spring.Echo("SoundTable["..Sound.."]="..SoundTable[Sound])
			else
				--Spring.Echo("No sound for tip #"..tostring(Sound)..": \""..CurrentTipText.."\"")
			end
		end
		--Spring.Echo("Tip: "..CurrentTipText)
	end

	-- Calculating where to display, then display it
	-- FontSize=WG.KP_ToolTip and WG.KP_ToolTip.FontSize or nil -- Slaving font size to tooltip font size
	local xSize = 0
	local ySize = 0
	local nttString = CurrentTipText
	local nttList = {}
	local maxWidth = 0
	if not FontSize then
		FontSize = math.max(8,4+vsy/80)
	end
	local TextWidthFixHack = 1
	if tonumber(string.sub(Game.version,1,4))<=0.785 and string.sub(Game.version,1,5)~="0.78+" then
		TextWidthFixHack = (vsx/vsy)*(4/3)
	end
	for line in string.gmatch(nttString,"[^\r\n]+") do
		table.insert(nttList,"\255\255\255\255"..line)
		if gl.GetTextWidth(line)>maxWidth then
			maxWidth=gl.GetTextWidth(line)
		end
	end
	xSize = FontSize*(1+maxWidth*TextWidthFixHack)
	ySize = FontSize*(1+#nttList)

	-- Bottom left position by default
	local x1,y1,x2,y2=0,0,xSize,ySize

	-- If KP_ToolTip, then place it above
	if WG.KP_ToolTip then
		x1=math.min(WG.KP_ToolTip.x1,WG.KP_ToolTip.x2)
		x2=x1+xSize
		y1=math.max(WG.KP_ToolTip.y1,WG.KP_ToolTip.y2)
		-- Above both if both KP_ToolTip and KP_OnsHelpTip exist
		if WG.KP_OnsHelpTip and WG.KP_OnsHelpTip.y1 and WG.KP_OnsHelpTip.y2 then
			y1=math.max(y1,math.max(WG.KP_OnsHelpTip.y1,WG.KP_OnsHelpTip.y2))
		end
		y2=y1+ySize
	-- If no KP_ToolTip but a KP_OnsHelpTip, then above it
	elseif WG.KP_OnsHelpTip and WG.KP_OnsHelpTip.y1 and WG.KP_OnsHelpTip.y2 then
		x1=math.min(WG.KP_OnsHelpTip.x1,WG.KP_OnsHelpTip.x2)
		x2=x1+xSize
		y1=math.max(WG.KP_OnsHelpTip.y1,WG.KP_OnsHelpTip.y2)
		y2=y1+ySize
	end

	-- Much better
	x1,y1,x2,y2=vsx/2-xSize/2,FontSize/2,vsx/2+xSize/2,ySize+FontSize/2

	-- Saving the of KP_AutomaticTipDispenser pos for no particular reason
	WG.KP_AutomaticTipDispenser={x1=math.min(x1,x2),y1=math.min(y1,y2),x2=math.max(x1,x2),y2=math.max(y1,y2),xSize=math.abs(x2-x1),ySize=math.abs(y2-y1)}

	gl.ResetState()
	gl.Blending(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA) -- default
	gl.Color(0.5,1,1,0.5)
	gl.Rect(x1,y1,x2,y2)
	gl.Color(0.5,1,1,1)
	gl.LineWidth(1)
	gl.Shape(GL.LINE_LOOP,{
		{v={x1,y2}},{v={x2,y2}},
		{v={x2,y1}},{v={x1,y1}},})
	gl.Color(1,1,1,1)
	for k=1,#nttList do
		gl.Text(nttList[k],x1+FontSize/2,y2-FontSize*(0.5+k),FontSize,'o')
	end
	gl.Text("\255\255\255\255 ",0,0,FontSize,'o') -- Reset color to white for other widgets using gl.Text
	gl.Color(0.5,1,1,0.15)
	gl.Rect(x1,y1,x2,y2)
	gl.Color(1,1,1,1)
	gl.ResetState()

end



