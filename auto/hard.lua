local Screen = require("lib.ui.screen")
local Frame = require("lib.ui.frame")
local Sprite = require("lib.ui.sprite")
local Debug = require("lib.ui.debug")
local Macros = require("lib.macros")

local Identity = require("game.identity")
local Object = require("game.object")
local Hitbox = require("game.hitbox")

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


local screen = Screen.new(modelScreen)

Debug:setParent(screen.model)
--client.getViewer():getNbt().SelectedSlot




--[────────────────────────────────────────-< GAME LOGIC >-────────────────────────────────────────]--

-- load identities
for index, value in ipairs(listFiles("game.identities")) do
	require(value)
end



local fBackground = Frame.new(textures["textures.yard"])
local sBackground = Sprite.new(screen,fBackground)
local size = fBackground.texture:getDimensions()
sBackground:setPos(-size.x,-size.y):setLayer(-1)

for i = 1, 100, 1 do
	local zambie = Object.new("zombie",screen)
	zambie:setPos(math.random(-256,-64),math.random(-256,-64))
	zambie.isWalking = math.random() > 0.5
end


local game = Macros.new(function (events, ...)
	
	events.WORLD_TICK:register(function ()
		Object.tick(screen)
	end)
	
	-- SCREEN BOUNDARIES
	events.WORLD_RENDER:register(function (delta)
		screen:setCamPos(0,0)
		--screen:setCamPos(mpos.x*512-256,mpos.y*512-256)
		
		screen:setDir(client:getCameraDir())
		local t = client:getSystemTime() / 1000
		Debug:clear()
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
		
		host:setActionbar(tostring(mpos))
		
		---@cast mpos Vector2
		mpos.x = math.clamp(mpos.x,0,1)
		mpos.y = math.clamp(mpos.y,0,1)
		
		
		--modelHardware:setPos(9 * (rightHanded and -1 or 1) + math.lerp(-8,8,mpos.x),4.4+math.lerp(0,12,mpos.y),0):rot(0,0,0)
		modelHardware:setPos(9 * (rightHanded and -1 or 1),10.5,0):rot(0,0,0)
	else
		modelHardware:setPos(0,0,-6):scale():rot(90,0,0)
	end
end)