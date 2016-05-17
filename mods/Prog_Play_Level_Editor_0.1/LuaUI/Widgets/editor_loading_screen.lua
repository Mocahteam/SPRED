function widget:GetInfo()
	return {
		name = "Editor Loading Screen",
		desc = "Loading screen to prevent user from interacting with the interface.",
		author = "zigaroula",
		version = "0.1",
		date = "May 17, 2016",
		license = "Public Domain",
		layer = -1250,
		enabled = true
	}
end

local vsx, vsy -- Screen size
local loading = true

function finishedLoading()
	loading = false
end

function widget:DrawScreenEffects(dse_vsx, dse_vsy)
	vsx, vsy = dse_vsx, dse_vsy
end

function widget:DrawScreen()
	if loading then
		local bgText = "bitmaps/editor/loading.png"
		gl.Blending(false)
		gl.Color(1, 1, 1, 1)
		gl.Texture(bgText)
		gl.TexRect(vsx, vsy, 0, 0, true, true)
		gl.Texture(false)
		gl.Blending(true)
	end
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("finishedLoading", finishedLoading)
end