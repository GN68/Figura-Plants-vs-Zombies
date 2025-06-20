local params = require("lib.params")

local OUTLINE_COLOR = vec(1,1,1) * 0.1
local CIRCLE_DETAIL = 10


local white = textures:newTexture("1x3OUTLINE",1,3):setPixel(0,0,OUTLINE_COLOR):setPixel(0,1,vec(1,1,1)):setPixel(0,2,OUTLINE_COLOR)


---@class DebugDraw
---@field model ModelPart
---@field nextID integer
local Debug = {}
Debug.__index = Debug


local WIDTH = 0.1
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


function Debug:free()
	self.model:removeTask()
	self.model:remove()
	return self
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
	local vec4 = params.vec4(x1,y1,x2,y2)
	
	self:drawLine(vec4.x,vec4.y,vec4.z,vec4.y)
	self:drawLine(vec4.z,vec4.y,vec4.z,vec4.w)
	self:drawLine(vec4.z,vec4.w,vec4.x,vec4.w)
	self:drawLine(vec4.x,vec4.w,vec4.x,vec4.y)
	
	return self
end


---@overload fun(xyr: Vector3): Vector3
---@param x number
---@param y number
---@param r number
---@return DebugDraw
function Debug:drawCircle(x,y,r)
	local vec3 = params.vec3(x,y,r)
	local pos = vec3.xy
	local r = vec3.z
	
	local detail = math.ceil(math.max(r,4) * CIRCLE_DETAIL)
	
	local points = {}
	for i = 1, detail, 1 do
		local w = i / detail
		points[i] = vec(
			math.cos(w * math.pi * 2) * r + pos.x,
			math.sin(w * math.pi * 2) * r + pos.y
		)
	end
	points[detail+1] = points[1]
	self:drawPolygon(points)
	return self
end


---@param points Vector2[]
---@return DebugDraw
function Debug:drawPolygon(points)
	for i = 1, #points-1, 1 do
		local p1,p2 = points[i],points[i+1]
		self:drawLine(p1.x,p1.y,p2.x,p2.y)
	end
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