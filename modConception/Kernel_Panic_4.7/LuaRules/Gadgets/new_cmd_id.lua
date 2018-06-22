

CMD_SPECIAL      = 33389
CMD_NX           = CMD_SPECIAL
CMD_DEPLOY       = CMD_SPECIAL+1
CMD_UNDEPLOY     = CMD_SPECIAL+2
CMD_BUG2MINE     = CMD_SPECIAL+3
CMD_MINE2BUG     = CMD_SPECIAL+4
-- CMD_BOMBARD   = CMD_SPECIAL+5
CMD_MINELAUNCHER = CMD_SPECIAL+6
CMD_DISPATCH     = 31581
CMD_ENTER        = 31574
CMD_BOMBARD      = 31647
CMD_AUTOHOLD     = 32103
CMD_BURROW       = 32104
CMD_FIREWALL     = 34881
CMD_AIRSTRIKE    = 35126
CMD_TIMEWAIT     = 33201 -- Because CMD.TIMEWAIT is implemented only on the unsynced side
CMD_DEATHWAIT    = 33202 -- Because CMD.DEATHWAIT is implemented only on the unsynced side
CMD_SQUADWAIT    = 33203 -- Because CMD.SQUADWAIT is implemented only on the unsynced side
CMD_GATHERWAIT   = 33204 -- Because CMD.GATHERWAIT is implemented only on the unsynced side
CMD_REPEAT       = 33207 -- Because CMD.REPEAT is not queuable
CMD_TRANSFER     = 33208
CMD_IF_UNIT_IN_AREA   = 33209
CMD_TRIGGERWAIT       = 33210
CMD_SELFEXPLODE       = 33211 -- Instantly explode the unit
CMD_SELFREMOVE        = 33212 -- Instantly remove the unit
CMD_SELECTABLE        = 33213 -- Make unit selectable/unselectable
