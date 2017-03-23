
-- Use:
-- luaui togglewidget
-- luaui disablewidget
-- luaui enablewidget
-- for exemple:  Spring.SendCommands({"LuaUI togglewidget Kernel Panic Build Bar"})
-- To force disable some widgets

local delay = 15 -- seconds

function gadget:GetInfo()
	return {
		name = "Force LUA UI",
		desc = "Turn on the LuaUI if it is not already",
		author = "zwzsg",
		date = "1st March, 2009",
		license = "Public Domain",
		layer = 0,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then
--SYNCED
else

--UNSYNCED

local LuaUI_isOff = false
local Force_LuaUI_timer = 0
local vsx,vsy = 0,0
local YesButtonxMin,YesButtonxMax,YesButtonyMin,YesButtonyMax = 0,0,0,0
local NoButtonxMin,NoButtonxMax,NoButtonyMin,NoButtonyMax = 0,0,0,0
local LastKeyPressed = nil
local KPRanOnceKey = "KPHasForceSettingRanOnce"
local HasRanOnce = nil
local RememberAnswerStage = nil

function gadget:Initialize()
	Force_LuaUI_timer = Spring.GetTimer()
	HasRanOnce = Spring.GetConfigInt(KPRanOnceKey)
	if HasRanOnce==3 then
		gadgetHandler:RemoveGadget()
	elseif Spring.GetConfigInt("LuaUI")==0 and not Script.LuaUI('WriteAndRunState') then
		LuaUI_isOff=true
	else
		LuaUI_isOff=false
		if HasRanOnce and HasRanOnce~=0 then
			gadgetHandler:RemoveGadget()
		end
	end
end

function gadget:Shutdown()

end



function isAboveYes(x,y)
	if type(x)~="number" or type(y)~="number" then
		x,y = Spring.GetMouseState()
	end
	if x>=YesButtonxMin and x<=YesButtonxMax and y>=YesButtonyMin and y<=YesButtonyMax and not Spring.IsGUIHidden() then
		return true
	else
		return false
	end
end

function isAboveNo(x,y)
	if type(x)~="number" or type(y)~="number" then
		x,y = Spring.GetMouseState()
	end
	if x>=NoButtonxMin and x<=NoButtonxMax and y>=NoButtonyMin and y<=NoButtonyMax and not Spring.IsGUIHidden() then
		return true
	else
		return false
	end
end

function gadget:IsAbove(x,y)
	if isAboveYes(x,y) or isAboveNo(x,y) then
		return true
	else
		return false
	end
end

function gadget:MousePress(x,y,button)
	if isAboveYes(x,y) then
		delay = 0 -- leave DrawScreenEffects do it, so it's done only in one place
		RememberAnswerStage = (RememberAnswerStage or 1)*2
	elseif isAboveNo(x,y) then
		RememberAnswerStage = (RememberAnswerStage or 1)*3
	end
end

function gadget:GetTooltip(x,y)
	if isAboveYes(x,y) then
		if HasRanOnce and HasRanOnce~=0 then
			if RememberAnswerStage then
				return "Yes"
			else
				return "Force enable LuaUI now!"
			end
		else
			return "Set Spring settings to better suit K.P."
		end
	elseif isAboveNo(x,y) then
		if HasRanOnce and HasRanOnce~=0 then
			if RememberAnswerStage then
				return "No"
			else
				return "Leave LuaUI off"
			end
		else
			return "Leave settings as they are"
		end
	end
	return ""
end






-- DrawFramedText
-- text: text to draw, use \n for multi-line
-- x,y: screen coordinate of the text window

-- FramePosition: Position of the corner which x,y refers to
--                first character for x, amongst "l","r","c" for left, right, center
--                second character for y, amongst "t","u","b","d","c" for top, up, bottom, down, center
-- TextPosition:

local function DrawFramedText(Text,x,y,FontSize,bg_red,bg_green,bg_blue,bg_alpha,FramePosition,TextPosition)

	if Spring.IsGUIHidden() then
		return 0,0,0,0
	end

	if type(Text)~="string" then
		Text=tostring(Text)
	end
	if type(x)~="number" then
		x=vsx/2
	end
	if type(y)~="number" then
		y=vsy/2
	end
	if type(FontSize)~="number" then
		FontSize=20
	end
	if type(bg_red)~="number" or type(bg_green)~="number" or type(bg_blue)~="number" then
		bg_red = 1
		bg_green = 1
		bg_blue = 1
	end
	if type(bg_alpha)~="number" then
		bg_alpha = 0.2
	end

	local txtLinesList = {}
	local maxTxtWidth = 0
	for line in string.gmatch(Text,"[^\r\n]+") do
		table.insert(txtLinesList,line)
		if gl.GetTextWidth(line)>maxTxtWidth then
			maxTxtWidth=gl.GetTextWidth(line)
		end
	end
	
	local TextWidthFixHack = 1
	if tonumber(string.sub(Game.version,1,4))<=0.785 and string.sub(Game.version,1,5)~="0.78+" then
		TextWidthFixHack = (vsx/vsy)*(4/3)
	end
	local xFramedTextSize=FontSize*(1+maxTxtWidth*TextWidthFixHack)
	local yFramedTextSize=FontSize*(1+#txtLinesList)
	local xPosMin = x-xFramedTextSize/2
	local xPosMax = x+xFramedTextSize/2
	local yPosMin = y-yFramedTextSize/2
	local yPosMax = y+yFramedTextSize/2

	if type(FramePosition)=="string" and string.len(FramePosition)==2 then
		if string.sub(FramePosition,1,1)=='c' then
			xPosMin = x - xFramedTextSize/2
			xPosMax = x + xFramedTextSize/2
		elseif string.sub(FramePosition,1,1)=='r' then
			xPosMin = x - xFramedTextSize
			xPosMax = x
		elseif string.sub(FramePosition,1,1)=='l' then
			xPosMin = x
			xPosMax = x + xFramedTextSize
		else
			Spring.Echo("Wrong FramePosition[1] in "..gadget:GetInfo().name.."'s DrawFramedText",string.sub(FramePosition,1,1))
		end
		if string.sub(FramePosition,2,2)=='c' then
			yPosMin = y - yFramedTextSize/2
			yPosMax = y + yFramedTextSize/2
		elseif string.sub(FramePosition,2,2)=='t' or string.sub(FramePosition,2,2)=='u' then
			yPosMin = y - yFramedTextSize
			yPosMax = y
		elseif string.sub(FramePosition,2,2)=='b' or string.sub(FramePosition,2,2)=='d' then
			yPosMin = y
			yPosMax = y + yFramedTextSize
		else
			Spring.Echo("Wrong FramePosition[2] in "..gadget:GetInfo().name.."'s DrawFramedText")
		end
	else
		Spring.Echo("Wrong FramePosition in "..gadget:GetInfo().name.."'s DrawFramedText",string.sub(FramePosition,2,2))
	end

	gl.Color(bg_red,bg_green,bg_blue,bg_alpha/2)
	gl.Rect(xPosMin,yPosMin,xPosMax,yPosMax)
	gl.Color(1,1,1,bg_alpha)
	for n,_ in ipairs(txtLinesList) do
		if TextPosition=="c" then
			gl.Text(txtLinesList[n], (xPosMin+xPosMax)/2, yPosMax+(-0.5-n)*FontSize, FontSize, "co")
		elseif TextPosition=="r" then
			gl.Text(txtLinesList[n], xPosMax-FontSize/2, yPosMax+(-0.5-n)*FontSize, FontSize, "ro")
		else
			gl.Text(txtLinesList[n], xPosMin+FontSize/2, yPosMax+(-0.5-n)*FontSize, FontSize, "o")
		end
	end
	gl.Color(bg_red,bg_green,bg_blue,bg_alpha/2)
	gl.Rect(xPosMin,yPosMin,xPosMax,yPosMax)
	gl.Color(bg_red,bg_green,bg_blue,bg_alpha)
	gl.LineWidth(FontSize/4)
	gl.Shape(GL.LINES,{
		{v={xPosMin+FontSize/4,yPosMax-FontSize/8}},
		{v={xPosMax-FontSize/4,yPosMax-FontSize/8}},
		{v={xPosMax-FontSize/8,yPosMax}},
		{v={xPosMax-FontSize/8,yPosMin}},
		{v={xPosMax-FontSize/4,yPosMin+FontSize/8}},
		{v={xPosMin+FontSize/4,yPosMin+FontSize/8}},
		{v={xPosMin+FontSize/8,yPosMin}},
		{v={xPosMin+FontSize/8,yPosMax}},})
	gl.Color(1,1,1,1)
	return xPosMin, xPosMax, yPosMin, yPosMax, xFramedTextSize, yFramedTextSize
end

function gadget:DrawScreenEffects(dse_vsx, dse_vsy)
	vsx, vsy = dse_vsx, dse_vsy
	if not HasRanOnce or HasRanOnce==0 then
		if 0 ~= delay then
			local txt=""
			txt=txt.."This is the first time you run Kernel Panic\n"
			txt=txt.."Would you like me to set Spring settings?"
			local x1,x2,y1,y2,x3,y3 = DrawFramedText(txt,vsx*0.5,vsy*0.5,30,0,0,1,0.5,"cb","c")
			YesButtonxMin,YesButtonxMax,YesButtonyMin,YesButtonyMax = DrawFramedText("Yes!",x1,y1,30,0,1,0,isAboveYes() and 0.8 or 0.4,"lu","c")
			NoButtonxMin,NoButtonxMax,NoButtonyMin,NoButtonyMax = DrawFramedText("No, don't touch them!",x2,y1,30,1,0,0,isAboveNo() and 0.8 or 0.4,"ru","c")
			if RememberAnswerStage then
				Spring.SetConfigInt(KPRanOnceKey,2)
				gadgetHandler:RemoveGadget()
			end
		else
			Spring.SetConfigInt(KPRanOnceKey,1)
			--Spring.SetConfigInt("AdvUnitShading",0)
			Spring.SetConfigInt("MoveWarnings",0)
			Spring.SetConfigInt("BuildWarnings",0)
			Spring.SetConfigInt("LuaAutoModWidgets",1)
			Spring.SetConfigInt("LuaModUICtrl",1)
			Spring.SetConfigInt("LuaUI",1)
			Spring.SetConfigInt("GroundDecals",1)
			Spring.SetConfigInt("CamMode",1)
			Spring.SetConfigInt("CrossSize",6)
			Spring.SetConfigInt("DynamicSky",0)
			Spring.SetConfigInt("AdvSky",0)
			Spring.SetConfigInt("UnitIconDist",500)
			Spring.SetConfigInt("UnitLodDist",500)
			Spring.SetConfigInt("SoundVolume",100)
			Spring.SetConfigInt("UnitReplyVolume",150)
			Spring.SetConfigInt("UnitReplySoundVolume",150)
			Spring.SetConfigInt("MaxSounds",96)
			Spring.SetConfigInt("snd_general",100)
			Spring.SetConfigInt("snd_volbattle",100)
			Spring.SetConfigInt("snd_volmaster",100)
			Spring.SetConfigInt("snd_volui",100)
			Spring.SetConfigInt("snd_volunitreply",100)
			Spring.SetConfigInt("MouseDragScrollThreshold",0)
			Spring.SendCommands({"movewarnings 0","buildwarnings 0"})
			Spring.SendCommands({"volume 100"})
			Spring.Echo("Spring settings changed to fit K.P. taking effect next game")
			if #Spring.GetPlayerList()<=1 then
				if Script.LuaUI('WriteAndRunState') then
					Spring.Echo("Attempting to restart Spring now, for changes to take effect")
					Spring.SendCommands("luarules dump restart")
				else
					Spring.Echo("Exiting Spring now, for changes to take effect")
					Spring.SendCommands("quit")
					Spring.SendCommands("quitforce")
				end
			end
			Spring.SetConfigInt(KPRanOnceKey,1)
			gadgetHandler:RemoveGadget()
		end
	elseif LuaUI_isOff then
		if RememberAnswerStage==3 then
			local x1,x2,y1,y2,x3,y3 = DrawFramedText("  Should I ask again ?  ",vsx*0.5,vsy*0.5,30,0,0,1,0.5,"cb","c")
			YesButtonxMin,YesButtonxMax,YesButtonyMin,YesButtonyMax = DrawFramedText("Yes",x1,y1,30,0,1,0,isAboveYes() and 0.8 or 0.4,"lu","c")
			NoButtonxMin,NoButtonxMax,NoButtonyMin,NoButtonyMax = DrawFramedText("No, stop asking",x2,y1,30,1,0,0,isAboveNo() and 0.8 or 0.4,"ru","c")
		elseif RememberAnswerStage==9 then
			Spring.SetConfigInt(KPRanOnceKey,3)
			gadgetHandler:RemoveGadget()
		elseif RememberAnswerStage==6 then
			gadgetHandler:RemoveGadget()
		elseif Spring.DiffTimers(Spring.GetTimer(),Force_LuaUI_timer) < delay then
			local txt=""
			txt=txt.."LuaUI is off\n"
			txt=txt.."  K.P. is better with LuaUI on  \n"
			txt=txt.."Force-Enabling LuaUI in "..delay - math.floor(Spring.DiffTimers(Spring.GetTimer(),Force_LuaUI_timer)).."s\n"
			local x1,x2,y1,y2,x3,y3 = DrawFramedText(txt,vsx*0.5,vsy*0.5,30,0,0,1,0.5,"cb","c")
			YesButtonxMin,YesButtonxMax,YesButtonyMin,YesButtonyMax = DrawFramedText("Yes!",x1,y1,30,0,1,0,isAboveYes() and 0.8 or 0.4,"lu","c")
			NoButtonxMin,NoButtonxMax,NoButtonyMin,NoButtonyMax = DrawFramedText("No, leave it off.",x2,y1,30,1,0,0,isAboveNo() and 0.8 or 0.4,"ru","c")
		else
			-- Spring.SetConfigInt("LuaUI",1) -- I'm not that bad!
			Spring.Echo("/luaui reload")
			Spring.SendCommands({"echo /luaui reload"})
			Spring.SendCommands({"echo luaui reload"})
			Spring.SendCommands({"LuaUI reload"}) -- Can not reload from within LuaUI, yet
			Spring.SendCommands({"fakemeta none"})
			Spring.SendCommands({"unbind enter"})
			Spring.SendCommands({"unbindall"})
			Spring.SendCommands({"unbindkeyset enter"})
			for keycode=1,511 do
				Spring.SendCommands({"bind 0x"..string.format("%x",keycode).." luaui reload"})
			end
			Spring.Echo(" ")
			Spring.Echo("Cannot force luaui on from a .lua script")
			Spring.Echo("Binding that to any key and waiting for a keypress instead")
			LuaUI_isOff=false
			LastKeyPressed=nil
			YesButtonxMin,YesButtonxMax,YesButtonyMin,YesButtonyMax = 0,0,0,0
			NoButtonxMin,NoButtonxMax,NoButtonyMin,NoButtonyMax = 0,0,0,0
		end
	elseif RememberAnswerStage==17 then
		local x1,x2,y1,y2,x3,y3 = DrawFramedText("Should LuaUI be always on?",vsx*0.5,vsy*0.5,30,0,0,1,0.5,"cb","c")
		YesButtonxMin,YesButtonxMax,YesButtonyMin,YesButtonyMax = DrawFramedText("Yes",(x1+x2)/2,y1,30,0,1,0,isAboveYes() and 0.8 or 0.4,"ru","c")
		NoButtonxMin,NoButtonxMax,NoButtonyMin,NoButtonyMax = DrawFramedText("No",(x1+x2)/2,y1,30,1,0,0,isAboveNo() and 0.8 or 0.4,"lu","c")
	elseif RememberAnswerStage==34 then
		Spring.SetConfigInt("LuaUI",1)
		gadgetHandler:RemoveGadget()
	elseif RememberAnswerStage==51 then
		gadgetHandler:RemoveGadget()
	elseif LastKeyPressed~=nil then
		LastKeyPressed = nil
		Spring.SendCommands({"unbindaction luaui reload"})
		Spring.SendCommands({"keyreload"})
		RememberAnswerStage=17
	else
		DrawFramedText("Press any key",vsx*0.5,vsy*0.5,30,0,0,1,0.5,"cb","c")
	end
end

function gadget:KeyPress(key)
	if LuaUI_isOff==false then
		LastKeyPressed = key
		return false
	end
end

end
