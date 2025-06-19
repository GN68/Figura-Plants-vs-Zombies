local params = require("lib.params")

local OUTLINE = vec(1,1,1) * 0.1
local white = textures:newTexture("1x3OUTLINE",1,3):setPixel(0,0,OUTLINE):setPixel(0,1,vec(1,1,1)):setPixel(0,2,OUTLINE)

---@class DebugDraw
---@field model ModelPart
---@field nextID integer
local Debug = {}
Debug.__index = Debug


local WIDTH = 0.05
local WIDTH_HALF = WIDTH / 2
local UP = vec(0,1)

local nextID = 0

---@param parent ModelPart
---@return DebugDraw
function Debug.new(parent)
	local new = setmetatable({},Debug)
	new.model = parent:newPart("debugDraw"..nextID):setPos(0,0,-0.05)
	new.nextID = 0
	nextID = nextID + 1
	return new
end


function Debug:clear()
	self.nextID = 0
	self.model:removeTask()
	return self
end


---@overload fun(x1y1x2y2: Vector4): Vector4
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return DebugDraw
function Debug:drawBox(x1,y1,x2,y2)
	
	self:drawLine(x1,y1,x2,y1)
	self:drawLine(x2,y1,x2,y2)
	self:drawLine(x2,y2,x1,y2)
	self:drawLine(x1,y2,x1,y1)
	
	return self
end

---@overload fun(x1y1x2y2: Vector4): Vector4
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return DebugDraw
function Debug:drawLine(x1,y1,x2,y2)
	local vec4 = params.vec4(x1,y1,x2,y2)
	
	---@type Vector2
	local dir = vec4.xy - vec4.zw
	local length = dir:length()
	local angle = math.atan2(dir.y,dir.x)
	self.nextID = self.nextID + 1
	self.model:newSprite("sprite"..self.nextID)
	:texture(white,1,1)
	:setRenderType("CUTOUT_EMISSIVE_SOLID")
	:pos(-math.sin(angle)*WIDTH_HALF+x1,math.cos(angle)*WIDTH_HALF+y1,0)
	:rot(0,0,math.deg(angle))
	:scale(length,WIDTH,0)
	
	return self
end

return Debug