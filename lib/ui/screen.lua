--[[
256/192

8 x 6
]]

local Event = require("lib.event")

local params = require("lib.params")

local RESOLUTION = vec(256,192)
local SIZE = vec(16,12)

---@class Screen
---@field model ModelPart
---@field dir Vector3 # the direction of the screen
---@field resolution Vector2
---@field size Vector2
---@field sprites Sprite[]
---@field camPos Vector2
---@field CAMERA_MOVED Event
---@field ON_FREE Event
local Screen = {}
Screen.__index = Screen


local nextID = 0

---@param parent ModelPart
---@return Screen
function Screen.new(parent)
	local new = setmetatable({},Screen)
	new.model = parent:newPart("Screen"..nextID)
	new.resolution = RESOLUTION
	new.size = SIZE
	new.sprites = {}
	new.dir = vec(0,1,0)
	new.camPos = vec(0,0)
	new.CAMERA_MOVED = Event.new()
	new.ON_FREE = Event.new()
	nextID = nextID + 1
	return new
end


function Screen:free()
	self.ON_FREE:invoke()
	for key, sprite in pairs(self.sprites) do
		sprite:free()
	end
	self.model:remove()
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

---@overload fun(xyz: Vector3): Vector3
---@param x number
---@param y number
---@param z number
function Screen:setDir(x,y,z)
	local vec3 = params.vec3(x,y,z)
	self.dir = vec3
end


return Screen