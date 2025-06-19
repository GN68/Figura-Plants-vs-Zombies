local params = require("lib.params")

---@class Sprite
---@field model SpriteTask
---@field screen Screen
---@field Frame Frame[]
---@field currentFrame integer
---@field color Vector3
---@field alpha number
local Sprite = {}
Sprite.__index = Sprite


local nextID = 0
---@param screen Screen
---@param frames Frame[]
---@return Sprite
function Sprite.new(screen,frames)
	local new = setmetatable({},Sprite)
	new.model = screen.model:newSprite("sprite"..nextID)
	new.Frame = frames
	new.currentFrame = 1
	new.color = vec(1,1,1)
	new.alpha = 1
	nextID = nextID + 1
	return new
end

---@overload fun(rgb: Vector3): Vector3
---@param r number
---@param g number
---@param b number
---@return Sprite
function Sprite:setColor(r,g,b)
	self.color = params.vec3(r,g,b)
	return self
end

function Sprite:setAlpha(alpha)
	self.alpha = alpha
	return self
end

return Sprite