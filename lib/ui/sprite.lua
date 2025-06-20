local params = require("lib.params")

---@class Sprite
---@field id integer
---@field pos Vector2
---@field size Vector2
---@field Frame Frame[]
---@field screen Screen
---@field currentFrame integer
---@field color Vector3
---@field task SpriteTask
local Sprite = {}
Sprite.__index = Sprite


local nextID = 0
---@param screen Screen
---@param frames Frame[]
---@return Sprite
function Sprite.new(screen,frames)
	local new = setmetatable({},Sprite)
	new.id = nextID
	new.pos = vec(0,0)
	new.Frame = frames
	new.size = vec(1,1)
	new.screen = screen
	new.currentFrame = 1
	screen.sprites[nextID] = new
	new.color = vec(1,1,1)
	new.task = screen.model:newSprite("sprite"..nextID):renderType("TRANSLUCENT_CULL")
	
	
	screen.CAMERA_MOVED:register(function ()
		new:updateBounds()
	end)
	
	new:updateTexture()
	new:setPos(0,0)
	nextID = nextID + 1
	return new
end


function Sprite:free()
	self.task:remove()
	self.screen.sprites[self.id] = nil
end


---@return Sprite
function Sprite:copy()
	local new = Sprite.new(self.screen,self.Frame)
	new.color = self.color
	new.currentFrame = self.currentFrame
	return new
end


---@overload fun(xy: Vector2): Sprite
---@param x number
---@param y number
---@return Sprite
function Sprite:setPos(x,y)
	local vec2 = params.vec2(x,y)
	self.pos = vec2
	self:updateBounds()
	return self
end


---@overload fun(rgb: Vector3): Sprite
---@param r number
---@param g number
---@param b number
---@return Sprite
function Sprite:setColor(r,g,b)
	local clr = params.vec3(r,g,b)
	self.color = clr
	self.task:setColor(clr)
	return self
end


---@overload fun(xy: Vector2): boolean
---@param x number
---@param y number
---@return boolean
function Sprite:isPointInside(x,y)
	local vec2 = params.vec2(x,y)
	local gpos = self.pos + self.screen.camPos
	return vec2.x >= gpos.x 
	and vec2.y >= gpos.y 
	and vec2.x < gpos.x + self.size.x
	and vec2.y < gpos.y + self.size.y
end


---@param Sprite Sprite
function Sprite:isTouching(Sprite)
	local pos = Sprite.pos
	local size2 = Sprite.size
	
	-- expand the box by the size of the other box, so the other box can be computed as a point.
	local from = self.pos - size2
	local to = self.pos + self.size

	return pos.x > from.x
	and pos.y > from.y
	and pos.x < to.x
	and pos.y < to.y
end


---@return Sprite
function Sprite:updateTexture()
	local frame = self.Frame[self.currentFrame]
	if frame then
		local tex = frame.texture
		local size = frame.dim
		self.task
		:texture(tex,size.x,size.y)
		self:updateBounds()
		self.size = size
	end
	return self
end

---@return Sprite
function Sprite:updateBounds()
	local frame = self.Frame[self.currentFrame]
	if frame  then
		local gpos = self.pos + self.screen.camPos
		local size = self.size
		local sSize = self.screen.resolution
		local spriteBounds = gpos.xyxy - self.size.__xy -- I love swizzling lmao
		local uv = frame.UVn
		
		local extents = vec(
			math.min(0,-spriteBounds.x),
			math.min(0,-spriteBounds.y),
			math.min(0,spriteBounds.z+sSize.x),
			math.min(0,spriteBounds.w+sSize.y)
		)
		
		local UVExtents = extents / frame.texDim.xyxy
		
		local sDir = self.screen.dir
		local dir = vec(0,-sDir.xz:length(),sDir.y)
		self.task:pos(gpos.x,gpos.y,gpos.y*0.005-0.015)
		
		local verts = self.task:getVertices()
		-- flipped Z layout
		-- Bottom Left
		verts[1]
		:pos(-extents.x,size.y+extents.w,0)
		:uv(uv.x-UVExtents.x,uv.w+UVExtents.w)
		:normal(dir)
		-- Bottom Right
		verts[2]
		:pos(size.x+extents.z,size.y+extents.w,0)
		:uv(uv.z+UVExtents.z,uv.w+UVExtents.w)
		:normal(dir)
		-- Top Left
		verts[3]
		:pos(size.x+extents.z,-extents.y,0)
		:uv(uv.z+UVExtents.z,uv.y-UVExtents.y)
		:normal(dir)
		-- Top Right
		verts[4]
		:pos(-extents.x,-extents.y,0)
		:uv(uv.x-UVExtents.x,uv.y-UVExtents.y)
		:normal(dir)
	end
	return self
end

return Sprite