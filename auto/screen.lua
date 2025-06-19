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



---@class Sprite
---@field model SpriteTask
---@field screen Screen
---@field Frame Frame[]
---@field currentFrame integer
---@field color Vector3
---@field alpha number
local Sprite = {}
Sprite.__index = Sprite


local i = 0
---@param screen Screen
---@param frames Frame[]
---@return Sprite
function Sprite.new(screen,frames)
	local new = setmetatable({},Sprite)
	new.model = screen.model:newSprite("sprite"..i)
	new.Frame = frames
	new.currentFrame = 1
	new.color = vec(1,1,1)
	new.alpha = 1
	i = i + 1
	return new
end

---@overload fun(rgb: Vector3): Vector3
---@param r number
---@param g number
---@param b number
---@return Sprite
function Sprite:setColor(r,g,b)
	self.color = vec(r or 1,g or 1,b or 1)
	return self
end

function Sprite:setAlpha(alpha)
	self.alpha = alpha
	return self
end


---@class Frame
---@field texture Texture
---@field UV Vector4
---@field offset Vector2
local Frame = {}
Frame.__index = Frame


---@param texture Texture
---@param U1 number
---@param V1 number
---@param U2 number
---@param V2 number
---@param Ox number?
---@param Oy number?
---@return Frame
function Frame.new(texture,U1,V1,U2,V2,Ox,Oy)
	local new = setmetatable({},Frame)
	new.UV = vec(U1,V1,U2,V2)
	new.texture = texture
	new.offset = vec(Ox or 0,Oy or 0)
	return new
	
end


return Screen