-- 800/600
local conf = require("auto.config")
local params = require("lib.params")


---@class Window
---@field model ModelPart
local Window = {}

local model = models:newPart("Window",conf.WINDOW_MODE)
Window.model = model





model
:pos(conf.WINDOW_WIDTH * -8)
:newBlock("Backdrop")
:block("minecraft:white_concrete")
:scale(conf.WINDOW_WIDTH, conf.WINDOW_WIDTH*conf.RESOLUTION.y/conf.RESOLUTION.x,0)

if conf.WINDOW_MODE == "SKULL" then
	local first = true
	events.WORLD_RENDER:register(function (delta)
		first = true
	end)
	
	events.SKULL_RENDER:register(function (delta, block, item, entity, ctx)
		if first then
			first = false
			model:setVisible(true)
		else
			model:setVisible(false)
		end
	end)
else
	
end



--[────────────────────────-< API >-────────────────────────]--

---@overload fun(xy: Vector2): Vector2
---@param x number
---@param y number
function Window:UVtoPos(x,y)
	local vec2 = params.vec2(x,y)
	return vec2 / conf.RESOLUTION
end

---@overload fun(xy: Vector2): Vector2
---@param x number
---@param y number
function Window:PosToUV(x,y)
	local vec2 = params.vec2(x,y)
	return vec2 * conf.RESOLUTION
end