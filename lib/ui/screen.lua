--[[
256/192

8 x 6
]]

local params = require("lib.params")

local SIZE = vec(256,192)

---@class Screen
---@field model ModelPart
---@field size Vector2
---@field camPos Vector2
local Screen = {}
Screen.__index = Screen


local nextID = 0

---@param parent ModelPart
---@return Screen
function Screen.new(parent)
	local new = setmetatable({},Screen)
	new.model = parent:newPart("Screen"..nextID)
	new.size = SIZE
	new.camPos = vec(0,0)
	nextID = nextID + 1
	return new
end


---@overload fun(xy: Vector2): Vector2
---@param x number
---@param y number
---@return Vector2
function Screen:setCamPos(x,y)
	local vec2 = params.vec2(x,y)
	self.camPos = vec2
	return self
end



return Screen