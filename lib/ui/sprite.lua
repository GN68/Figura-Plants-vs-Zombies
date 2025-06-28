local params=require("lib.params")

local CLIP=true
local MARGIN=0.00001

---@class Sprite
---@field id integer
---@field pos Vector2
---@field size Vector2
---@field frame Frame
---@field screen Screen
---@field layer integer
---@field color Vector3
---@field alpha number
---@field task SpriteTask
---@field isVisible boolean
local Sprite={}
Sprite.__index=Sprite


local nextID=0
---@param screen Screen
---@param frame Frame?
---@return Sprite
function Sprite.new(screen,frame)
	local new=setmetatable({},Sprite)
	new.id=nextID
	new.pos=vec(0,0)
	new.size=vec(1,1)
	new.frame=frame
	new.screen=screen
	new.layer=0
	new.isVisible=true
	screen.sprites[nextID]=new
	new.color=vec(1,1,1)
	new.alpha=1
	new.task=screen.model:newSprite("sprite"..nextID):renderType("CUTOUT_CULL"):light(15,15)
	
	screen.CAMERA_MOVED:register(function ()
		new:updateBounds()
	end,"sprite"..new.id)
	
	new:setFrame(frame)
	new:setPos(0,0)
	nextID=nextID+1
	return new
end


function Sprite:free()
	self.task:remove()
	self.screen.sprites[self.id]=nil
	self.screen.CAMERA_MOVED:remove("sprite"..self.id)
end


function Sprite:setFrame(frame)
	self.frame=frame
	self:updateTexture()
end


function Sprite:setLayer(layer)
	self.layer=layer
	self:updateBounds()
	return self
end


---@param visible boolean
---@return Sprite
function Sprite:setVisible(visible)
	if self.isVisible ~= visible then
		self.task:setVisible(visible)
		self.isVisible=visible
		if visible then
			self:updateTexture()
		end
	end
	return self
end


---@return Sprite
function Sprite:copy()
	local new=Sprite.new(self.screen,self.frame)
	new.color=self.color
	return new
end


---@overload fun(xy: Vector2): Sprite
---@param x number
---@param y number
---@return Sprite
function Sprite:setPos(x,y)
	local vec2=params.vec2(x,y)
	self.pos=vec2
	self:updateBounds()
	return self
end


---@overload fun(rgb: Vector3): Sprite
---@param r number
---@param g number
---@param b number
---@return Sprite
function Sprite:setColor(r,g,b)
	local clr=params.vec3(r,g,b)
	self.color=clr
	self.task:setColor(clr.x,clr.y,clr.z,self.alpha)
	return self
end

---@param a number
---@return Sprite
function Sprite:setAlpha(a)
	self.task:setRenderType("EMISSIVE")
	self.alpha=a
	local clr=self.color
	self.task:setColor(clr.x,clr.y,clr.z,a)
	return self
end


---@overload fun(xy: Vector2): boolean
---@param x number
---@param y number
---@return boolean
function Sprite:isPointInside(x,y)
	local vec2=params.vec2(x,y)
	local gpos=self.pos+self.screen.camPos
	return vec2.x >= gpos.x 
	and vec2.y >= gpos.y 
	and vec2.x < gpos.x+self.size.x
	and vec2.y < gpos.y+self.size.y
end


---@param Sprite Sprite
function Sprite:isTouching(Sprite)
	local pos=Sprite.pos
	local size2=Sprite.size
	
	-- expand the box by the size of the other box, so the other box can be computed as a point.
	local from=self.pos-size2
	local to=self.pos+self.size

	return pos.x > from.x
	and pos.y > from.y
	and pos.x < to.x
	and pos.y < to.y
end


---@return Sprite
function Sprite:updateTexture()
	if not self.isVisible then 
		return self
	end
	local frame=self.frame
	if frame then
		local tex=frame.texture
		local size=frame.dim
		self.task
		:texture(tex,size.x,size.y)
		self.size=size
		self:updateBounds()
	end
	return self
end

---@return Sprite
function Sprite:updateBounds()
	if not self.isVisible and not self.frame then 
		return self
	end
	local frame=self.frame
	if frame  then
		local size=self.size
		local shake=self.screen.shake or 0
		local gpos=(self.pos+self.screen.camPos+vec(math.random(-5,5)*shake,math.random(-5,5)*shake)+size+frame.offset):floor()
		local sSize=self.screen.resolution
		local spriteBounds=gpos.xyxy-size.__xy -- I love swizzling lmao
		local uv=frame.UVn
		
		local extents=vec(
			math.min(0,-spriteBounds.x),
			math.min(0,-spriteBounds.y),
			math.min(0,spriteBounds.z+sSize.x),
			math.min(0,spriteBounds.w+sSize.y)
		)
		
		local UVExtents=extents / frame.texDim.xyxy
		
		local sDir=self.screen.dir
		local dir=vec(0,-sDir.xz:length(),sDir.y)
		self.task:pos(gpos.x,gpos.y,(gpos.y/sSize.y)*0.02+(gpos.x/sSize.x)*0.01-0.04*self.layer-0.015)
		
		if not CLIP then
			extents=vec(0,0,0,0)
			UVExtents=vec(0,0,0,0)
		end
		local verts=self.task:getVertices()
		-- flipped Z layout
		-- Bottom Left
		verts[1]
		:pos(-extents.x,size.y+extents.w,0)
		:uv(uv.x-UVExtents.x+MARGIN,uv.w+UVExtents.w-MARGIN)
		:normal(dir)
		-- Bottom Right
		verts[2]
		:pos(size.x+extents.z,size.y+extents.w,0)
		:uv(uv.z+UVExtents.z-MARGIN,uv.w+UVExtents.w-MARGIN)
		:normal(dir)
		-- Top Left
		verts[3]
		:pos(size.x+extents.z,-extents.y,0)
		:uv(uv.z+UVExtents.z-MARGIN,uv.y-UVExtents.y+MARGIN)
		:normal(dir)
		-- Top Right
		verts[4]
		:pos(-extents.x,-extents.y,0)
		:uv(uv.x-UVExtents.x+MARGIN,uv.y-UVExtents.y+MARGIN)
		:normal(dir)
	end
	return self
end

return Sprite