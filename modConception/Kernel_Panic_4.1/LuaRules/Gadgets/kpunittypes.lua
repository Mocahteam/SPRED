

----------------------------------------
-- Define individual unit types

-- Homebases
kernel = UnitDefNames.kernel.id
hole = UnitDefNames.hole.id
holeold = UnitDefNames.holeold.id
carrier = UnitDefNames.carrier.id
thbase = UnitDefNames.thbase.id

-- MiniFacs
socket = UnitDefNames.socket.id
window = UnitDefNames.window.id
windowold = UnitDefNames.windowold.id
port = UnitDefNames.port.id
thminifac = UnitDefNames.thminifac.id

-- Special Buildings
terminal = UnitDefNames.terminal.id
obelisk = UnitDefNames.obelisk .id
firewall = UnitDefNames.firewall.id

-- Constructors
assembler = UnitDefNames.assembler.id
trojan = UnitDefNames.trojan.id
trojanold = UnitDefNames.trojanold.id
gateway = UnitDefNames.gateway.id
alice = UnitDefNames.alice.id

-- Spam
bit = UnitDefNames.bit.id
bug = UnitDefNames.bug.id
bugold = UnitDefNames.bugold.id
packet = UnitDefNames.packet.id
virus = UnitDefNames.virus.id
exploit = UnitDefNames.exploit.id
fairy = UnitDefNames.fairy.id

-- Heavy
byte = UnitDefNames.byte.id
worm = UnitDefNames.worm.id
wormold = UnitDefNames.wormold.id
connection = UnitDefNames.connection.id
reimu = UnitDefNames.reimu.id

-- Arty
pointer = UnitDefNames.pointer.id
dos = UnitDefNames.dos.id
flow = UnitDefNames.flow.id
marisa = UnitDefNames.marisa.id

-- Other
exploit= UnitDefNames.exploit.id
logic_bomb = UnitDefNames.logic_bomb.id
mineblaster = UnitDefNames.mineblaster.id
badblock = UnitDefNames.badblock.id

hand = UnitDefNames.hand.id
rock = UnitDefNames.rock.id
paper = UnitDefNames.paper.id
scissors = UnitDefNames.scissors.id

----------------------------------------
-- Define unit type groups

HomeBase = {
	kernel,hole,holeold,carrier,thbase,
}

MiniFac = {
	socket,window,windowold,port,thminifac,hand,
}

SpecialBuilding = {
	terminal,obelisk,firewall,
}

BigBuilding = {
	kernel,hole,holeold,carrier,thbase,
}

SmallBuilding = {
	socket,window,windowold,port,thminifac,
	terminal,obelisk,firewall,hand,
}

AnyBuilding = {
	kernel,hole,holeold,carrier,thbase,
	socket,window,windowold,port,thminifac,
	terminal,obelisk,firewall,hand,
}

cons = {
	assembler,trojan,trojanold,gateway,alice,
}

spam = {
	bit,bug,bugold,packet,fairy,
	virus,exploit,rock,paper,scissors,
}

heavy = {
	byte,worm,wormold,connection,reimu,
}

arty = {
	pointer,dos,flow,marisa,
}

teleporter = {
	port,connection,
}

----------------------------------------
-- Define isX unit type group tests

isHomeBase = {
	[kernel]=true,
	[hole]=true,
	[holeold]=true,
	[carrier]=true,
	[thbase]=true,
}

isMiniFac = {
	[socket]=true,
	[window]=true,
	[windowold]=true,
	[port]=true,
	[thminifac]=true,
	[hand]=true,
}

isSpecialBuilding = {
	[terminal]=true,
	[obelisk]=true,
	[firewall]=true,
}

isBigBuilding = {
	[kernel]=true,
	[hole]=true,
	[holeold]=true,
	[carrier]=true,
	[thbase]=true,
}

isSmallBuilding = {
	[socket]=true,
	[window]=true,
	[windowold]=true,
	[port]=true,
	[thminifac]=true,
	[terminal]=true,
	[obelisk]=true,
	[firewall]=true,
	[hand]=true,
}

isAnyBuilding = {
	[kernel]=true,
	[hole]=true,
	[holeold]=true,
	[carrier]=true,
	[thbase]=true,
	[socket]=true,
	[window]=true,
	[windowold]=true,
	[port]=true,
	[thminifac]=true,
	[terminal]=true,
	[obelisk]=true,
	[firewall]=true,
	[hand]=true,
}

isCons = {
	[assembler]=true,
	[trojan]=true,
	[trojanold]=true,
	[gateway]=true,
	[alice]=true,
}

isSpam = {
	[bit]=true,
	[bug]=true,
	[bugold]=true,
	[packet]=true,
	[virus]=true,
	[exploit]=true,
	[fairy]=true,
	[rock]=true,
	[paper]=true,
	[scissors]=true,
}

isHeavy = {
	[byte]=true,
	[worm]=true,
	[wormold]=true,
	[connection]=true,
	[reimu]=true,
}

isArty = {
	[pointer]=true,
	[dos]=true,
	[flow]=true,
	[marisa]=true,
}

isTeleporter = {
	[port]=true,
	[connection]=true,
}

----------------------------------------

