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


---@overload fun(xy: Vector2): Vector2
---@param x number
---@param y number
---@return Sprite
function Sprite:setPos(x,y)
	local vec2 = params.vec2(x,y)
	self.pos = vec2
	self.task:pos(vec2.x,vec2.y,vec2.y*0.005-0.015)
	self:updateBounds()
	return self
end


---@overload fun(rgb: Vector3): Vector3
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


---@return Sprite
function Sprite:updateTexture()
	local frame = self.Frame[self.currentFrame]
	if frame then
		local tex = frame.texture
		local dim = tex:getDimensions()
		local sRes = self.screen.resolution
		local sSize = self.screen.size
		local size = vec(dim.x/sRes.x*sSize.x,dim.y/sRes.y*sSize.y)
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
		local size = self.size
		local sSize = self.screen.size
		local spriteBounds = self.pos.xyxy - self.size.__xy -- I love swizzling lmao
		local uv = frame.UVn
		
		local extents = vec(
			math.min(0,-spriteBounds.x),
			math.min(0,-spriteBounds.y),
			math.min(0,spriteBounds.z+sSize.x),
			math.min(0,spriteBounds.w+sSize.y)
		)
		
		local UVExtents = extents / size.xyxy
		
		local dir = (self.screen.dir.__y-vec(0,self.screen.dir.xz:length(),0))
		
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