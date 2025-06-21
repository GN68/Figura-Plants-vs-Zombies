local params = require("lib.params")
local Event = require("lib.event")

local OUTLINE_COLOR = vec(1,1,1) * 0.1
local CIRCLE_DETAIL = 10
local COLOR = vec(1,1,1)

local WIDTH = 1
local WIDTH_HALF = WIDTH / 2

local TEX_WHITE = textures:newTexture("1x3OUTLINE",1,3):setPixel(0,0,OUTLINE_COLOR):setPixel(0,1,vec(1,1,1)):setPixel(0,2,OUTLINE_COLOR)


---@class DebugDraw
---@field model ModelPart
---@field nextID integer
local Debug = {}
Debug.__index = Debug
Debug.ON_CLEAR = Event.new()



local PARENT
local PART = models:newPart("debugDraw")

function Debug:setParent(parent)
	PARENT = parent
	PART:moveTo(PARENT)
	PART:setPivot(PARENT:getPivot())
	PART:setPos(0,0,-0.05)
end

function Debug:getParent()
	return PARENT
end

function Debug:free()
	PART:removeTask()
	PART:remove()
	return self
end


function Debug:clear()
	self.nextID = 0
	PART:removeTask()
	Debug.ON_CLEAR:invoke()
	return self
end


---@overload fun(rgb: Vector3)
---@param r number
---@param g number
---@param b number
---@return DebugDraw
function Debug:setColor(r,g,b)
	local clr = params.vec3(r,g,b)
	COLOR = clr
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

	PART:newSprite("sprite"..self.nextID)
	:texture(TEX_WHITE,1,1)
	:setRenderType("CUTOUT_EMISSIVE_SOLID")
	:pos(-math.sin(angle)*WIDTH_HALF+x1,math.cos(angle)*WIDTH_HALF+y1,0)
	:rot(0,0,math.deg(angle))
	:scale(length,WIDTH,0)
	:setColor(COLOR)
	
	return self
end

return Debug