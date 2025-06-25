local Debug=require("lib.ui.debug")
local params=require("lib.params")

local SHOW_HITBOXES=false

local layers={}

---@class Hitbox
---@field layer string
---@field enabled boolean
---@field pos Vector2
---@field dim Vector4
---@field object Object
local Hitbox={}
Hitbox.__index=Hitbox


local function minmax(vec4)
	return vec(
	math.max(vec4.x,vec4.z),
	math.max(vec4.y,vec4.w),
	math.min(vec4.x,vec4.z),
	math.min(vec4.y,vec4.w))
end

local hitboxes={} ---@type table<any,Hitbox>

---@overload fun(xyzw: Vector4?)
---@param object Object
---@param x number
---@param y number
---@param z number
---@param w number
---@param layer string?
---@return Hitbox
function Hitbox.new(object,x,y,z,w,layer)
	local box=(x and y and z and w) and minmax(params.vec4(x,y,z,w)) or vec(0,0,0,0)
	local new={
		object=object,
		pos=box.xy,
		dim=box,
		enabled=true
	}
	
	if SHOW_HITBOXES then
		Debug.ON_CLEAR:register(function ()
			local box=new.pos.xyxy+new.dim
			if new.enabled then
				Debug:setColor(1,0,1)
			else
				Debug:setColor(0.5,0,0.5)
			end
			Debug:drawBox(box)
		end,new)
	end
	setmetatable(new,Hitbox)
	new:setLayer(layer or "default")
	hitboxes[new]=true
	
	local function align()
		new:setPos(object.pos)
	end
	if object then 
		object.MOVED:register(align)
		align()
	end
	
	return new
end

function Hitbox:free()
	if layers[self.layer] then
		layers[self.layer][self]=nil
		Debug.ON_CLEAR:remove(self)
		hitboxes[self]=nil
	end
end


---@param screen Screen
function Hitbox:tick(screen)
	local player=client:getViewer()
	
	--print(gpos)
	if player:isLoaded() and player:getSwingTime() == 1 then
		---@param hitbox Hitbox
		for hitbox in pairs(hitboxes) do
			if hitbox.enabled and hitbox:isCollidingWitPoint(screen.gmPos) then
				if hitbox.object then
					hitbox.object.identity.processor.CLICK(hitbox.object,screen)
				end
			end
		end
	end
end


---@overload fun(xy: Vector2)
---@param x number
---@param y number
function Hitbox:setPos(x,y)
	local pos=params.vec2(x,y)
	self.pos=pos
	return self
end

---@overload fun(xyzw: Vector4)
---@param x number
---@param y number
---@param z number
---@param w number
function Hitbox:setDim(x,y,z,w)
	local dim=minmax(params.vec4(x,y,z,w))
	self.dim=dim
	return self
end

---@param layer string
---@return Hitbox
function Hitbox:setLayer(layer)
	if layers[self.layer] then
		layers[self.layer][self]=nil
	end
	self.layer=layer
	layers[self.layer]=layers[self.layer] or {}
	layers[self.layer][self]=true
	return self
end


--- Toggles if the hitbox has collision or not.
---@param enabled boolean
function Hitbox:setEnabled(enabled)
	self.enabled=enabled
	layers[self.layer][self]=enabled
	return self
end

---@param hitbox Hitbox
function Hitbox:isCollidingWithBox(hitbox)
	local dim1=self.pos.xyxy+self.dim
	local dim2=hitbox.pos.xyxy+hitbox.dim
	return (
   	dim1.z < dim2.x and
   	dim1.x > dim2.z and
   	dim1.w < dim2.y and
   	dim1.y > dim2.w
	)
end


function Hitbox:isCollidingWitPoint(x,y)
	local dim1=self.pos.xyxy+self.dim
	local pos=params.vec2(x,y)
	return (
   	dim1.z < pos.x and
   	dim1.x > pos.x and
   	dim1.w < pos.y and
   	dim1.y > pos.y
	)
end



---@param layer string
---@return Hitbox[]
function Hitbox:getCollidingBoxes(layer)
	local collisions={}
	---@param box Hitbox
	---@param enabled boolean
	for box, enabled in pairs(layers[layer]or{}) do
		if enabled and box ~= self then
			if box:isCollidingWithBox(self) then
				collisions[#collisions+1]=box
			end
		end
	end
	return collisions
end

---@param layer string
---@return Hitbox?
function Hitbox:getCollidingBox(layer)
	if layers[layer] then
		---@param box Hitbox
		---@param enabled boolean
		for box, enabled in pairs(layers[layer]or{}) do
			if enabled and box ~= self then
				if box:isCollidingWithBox(self) then
					return box
				end
			end
		end
	end
end

return Hitbox