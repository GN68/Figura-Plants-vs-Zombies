local Screen = require("lib.ui.screen")
local Frame = require("lib.ui.frame")
local Sprite = require("lib.ui.sprite")
local DebugDisplay = require("lib.ui.debug")
local Macros = require("lib.macros")

if avatar:getPermissionLevel() ~= "MAX" then
	error("Plants VS Zombies requires MAX permission level to work")
end

local modelHardware = models.hardware
modelHardware:setParentType("SKULL")

local ASPECT_RATIO = 256/192
local SENSITIVITY = 0.007

SENSITIVITY = vec(SENSITIVITY,SENSITIVITY*ASPECT_RATIO)
---@cast SENSITIVITY Vector2

local mpos = vec(0,0)
local lrot = vec(0,0)

local modelScreen = models.hardware.base.screen

--[────────────────────────────────────────-< GAME LOGIC >-────────────────────────────────────────]--
local game = Macros.new(function (events, ...)
	local screen = Screen.new(modelScreen)
	local debug = DebugDisplay.new(screen.model)
	
	local frameBackgroubd = Frame.new(textures["textures.yard"])
	local spriteBackground = Sprite.new(screen,{frameBackgroubd})
	
	-- SCREEN BOUNDARIES
	events.WORLD_RENDER:register(function (delta)
		screen:setDir(client:getCameraDir())
		local t = client:getSystemTime() / 1000
		spriteBackground:setPos(math.sin(t)*14,math.cos(t)*6)
		debug:clear()
		debug:drawBox(0,0,-screen.size.x,-screen.size.y)
		debug:drawBox(spriteBackground.pos.xyxy - spriteBackground.size.__xy)
	end)
	
	
	
	events.ON_EXIT:register(function ()
		screen:free()
		debug:free()
	end)
end)

--[────────────────────────────────────────-< HANDHELD HANDLER >-────────────────────────────────────────]--
local isActive = false
local wasActive = false
events.WORLD_RENDER:register(function (delta)
	if isActive ~= wasActive then
		wasActive = isActive
		game:setActive(isActive)
	end
	isActive = false
end)


events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
	local rightHanded = client:getViewer():getActiveHand() == "MAIN_HAND"
	if ctx:find((rightHanded and "LEFT" or "RIGHT") .."_HAND$") then
		isActive = true
		local rot = client:getCameraRot().xy
		local diff = (rot - (lrot or rot) + 180) % 360 - 180
		
		lrot = rot
		if rot.x < 89 and rot.x > -89 then -- stops the cursor from freaking out
			mpos = mpos + diff.yx * SENSITIVITY
		end
		
		---@cast mpos Vector2
		mpos.x = math.clamp(mpos.x,0,1)
		mpos.y = math.clamp(mpos.y,0,1)
		
		modelHardware:setPos(9 * (rightHanded and -1 or 1) + math.lerp(-8,8,mpos.x),4.4+math.lerp(0,12,mpos.y),10):rot(0,0,0)
	else
		modelHardware:setPos(0,0,-6):scale():rot(90,0,0)
	end
end)