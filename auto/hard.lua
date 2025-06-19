local Screen = require("lib.ui.screen")
local Frame = require("lib.ui.frame")
local Sprite = require("lib.ui.sprite")
local DebugDisplay = require("lib.ui.debug")


local modelHardware = models.hardware
modelHardware:setParentType("SKULL")

local ASPECT_RATIO = 256/192
local SENSITIVITY = vec(0.01/ASPECT_RATIO,0.01)

local mpos = vec(0,0)
local lrot = vec(0,0)


local modelScreen = models.hardware.base.screen
modelScreen:setPrimaryRenderType("EMISSIVE_SOLID")


events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
	local rightHanded = client:getViewer():getActiveHand() == "MAIN_HAND"
	if ctx:find((rightHanded and "LEFT" or "RIGHT") .."_HAND$") then
		local rot = client:getCameraRot().xy
		local diff = (rot - (lrot or rot) + 180) % 360 - 180
		lrot = rot
		
		mpos = mpos + diff.yx * SENSITIVITY
		
		mpos.x = math.clamp(mpos.x,0,1)
		mpos.y = math.clamp(mpos.y,0,1)
		
		modelHardware:setPos(9 * (rightHanded and -1 or 1) + math.lerp(-8,8,mpos.x),4.4+math.lerp(0,12,mpos.y),0):rot(0,0,0)
	else
		modelHardware:setPos(0,4,1):scale():rot(90,0,0)
	end
end)




local display = Screen.new(modelScreen)

local debug = DebugDisplay.new(display.model)

debug:drawLine(0,0,-16,-16)
debug:drawBox(0,0,-12,-8)