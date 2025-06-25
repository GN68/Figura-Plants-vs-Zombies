local params=require("lib.params")

local Debug=require("lib.ui.debug")
local Sprite=require("lib.ui.sprite")

local Event=require("lib.event")
local Hitbox=require("game.hitbox")

local Identity=require("game.identity")

local objects={} ---@type table<Object,true>

---@class Object
---@field identity Object.Identity
---@field sprite Sprite
---@field health integer
---@field pos Vector3
---@field hitbox Hitbox
---@field screen Screen
---@field MOVED Event
local Object={}
Object.__index=Object

---@param identityName Object.Identity
---@param screen Screen
---@return Object
function Object.new(identityName,screen,...)
	local identity=Identity.IDENTITIES[identityName]
	local new={
		identity=identity,
		pos=vec(0,0),
		health=identity.maxHealth,
		sprite=Sprite.new(screen),
		screen=screen,
		MOVED=Event.new(),
	}
	new.hitbox=Hitbox.new(new)
	new.class=identity or{}
	new=setmetatable(new,{__index=function (t,k)
		return rawget(t,k) or t.class[k] or Object[k]
	end})
	identity.processor.ENTER(new,screen,...)
	objects[new]=true
	return new
end


function Object:free()
	self.identity.processor.EXIT(self,self.screen)
	self.sprite:free()
	self.hitbox:free()
	objects[self]=nil
end


function Object:damage(amount)
	if self.health-amount <= 0 then
		self.identity.processor.DEATH(self,self.screen)
	else
		self.identity.processor.DAMAGED(self,self.screen,amount)
	end
	self.health=self.health-amount
	return self
end


---@overload fun(xy: Vector2)
---@param x number
---@param y number
---@return Object
function Object:setPos(x,y)
	local pos=params.vec2(x,y)
	self.pos=pos
	self.sprite:setPos(pos)
	self.MOVED:invoke()
	return self
end

---@overload fun(xy: Vector2)
---@param x number
---@param y number
---@return Object
function Object:move(x,y)
	local pos=params.vec2(x,y)+self.pos
	self.pos=pos
	self.sprite:setPos(pos)
	self.hitbox:setPos(pos)
	self.MOVED:invoke()
	return self
end


---@overload fun(xyzw: Vector4)
---@param x number
---@param y number
---@param z number
---@param w number
---@return Object
function Object:setDim(x,y,z,w)
	self.hitbox=params.vec4(x,y,z,w)
	return self
end


function Object.tick(...)
	for object in pairs(objects) do
		if object.identity then
			object.identity.processor.TICK(object,...)
		end
	end
end


function Object.purgeAll()
	for value in pairs(objects) do
		value:free()
	end
	objects={}
end


return Object