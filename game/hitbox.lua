local Debug = require("lib.ui.debug")
local params = require("lib.params")

local SHOW_HITBOXES = false

local layers = {}

---@class Hitbox
---@field layer string
---@field enabled boolean
---@field pos Vector2
---@field dim Vector4
---@field object Object
local Hitbox = {}
Hitbox.__index = Hitbox


---@overload fun(xyzw: Vector4?)
---@param x number
---@param y number
---@param z number
---@param w number
---@param layer string?
---@return Hitbox
function Hitbox.new(x,y,z,w,layer)
	local box = (x and y and z and w) and params.vec4(x,y,z,w) or vec(0,0,0,0)
	local new = {
		pos = box.xy,
		dim = box,
		enabled = true
	}
	if SHOW_HITBOXES then
		Debug:setColor(1,0,1)
		Debug.ON_CLEAR:register(function ()
			local box = new.pos.xyxy + new.dim
			Debug:drawBox(box)
		end)
	end
	setmetatable(new,Hitbox)
	new:setLayer(layer or "default")
	return new
end

---@overload fun(xy: Vector2)
---@param x number
---@param y number
function Hitbox:setPos(x,y)
	local pos = params.vec2(x,y)
	self.pos = pos
	return self
end

---@overload fun(xyzw: Vector4)
---@param x number
---@param y number
---@param z number
---@param w number
function Hitbox:setDim(x,y,z,w)
	local dim = params.vec4(x,y,z,w)
	self.dim = dim
	return self
end

function Hitbox:setLayer(layer)
	if layers[self.layer] then
		layers[self.layer][self] = nil
	end
	self.layer = layer
	layers[self.layer] = layers[self.layer] or {}
	layers[self.layer][self] = true
	return self
end


--- Toggles if the hitbox has collision or not.
---@param enabled boolean
function Hitbox:setEnabled(enabled)
	self.enabled = enabled
	layers[self.layer][self] = enabled
	return self
end

---@param hitbox Hitbox
function Hitbox:isCollidingWithBox(hitbox)
	local dim1 = self.pos.xyxy + self.dim
	local dim2 = hitbox.pos.xyxy + hitbox.dim
	return (
   	dim1[3] < dim2[1] or
   	dim1[1] > dim2[3] or
   	dim1[4] < dim2[2] or
   	dim1[2] > dim2[4]
	)
end


---@param layer string
---@return Hitbox[]
function Hitbox:getCollidingBoxes(layer)
	assert(layers[layer], 'Layer "'..layer..'" does not exist')
	local collisions = {}
	---@param boxes Hitbox
	---@param enabled boolean
	for boxes, enabled in pairs(layers[layer]) do
		if enabled and boxes ~= self then
			if boxes:isCollidingWithBox(self) then
				collisions[#collisions+1] = boxes
			end
		end
	end
	return collisions
end

return Hitbox