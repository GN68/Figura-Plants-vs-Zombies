--[[
256/192

8 x 6
]]

local Event=require("lib.event")

local params=require("lib.params")

local RESOLUTION=vec(256,192)
local SIZE=vec(16,12)

---@class Screen
---@field model ModelPart
---@field dir Vector3 # the direction of the screen
---@field resolution Vector2
---@field size Vector2
---@field sprites Sprite[]
---@field mPos Vector2 # Mouse Pops, I AM RUNNING OUT OF SPACE HERE
---@field gmPos Vector2 # Global Mouse pos
---@field camPos Vector2
---@field CAMERA_MOVED Event
---@field MOUSE_MOVED Event
---@field ON_FREE Event
local Screen={}
Screen.__index=Screen


local nextID=0

---@param parent ModelPart
---@return Screen
function Screen.new(parent)
	local new=setmetatable({},Screen)
	new.model=parent:newPart("Screen"..nextID):setPivot(parent:getPivot()):scale((SIZE/RESOLUTION).xyy)
	new.resolution=RESOLUTION
	new.size=SIZE
	new.sprites={}
	new.dir=vec(0,1,0)
	new.mPos=vec(0,0)
	new.gmPos=vec(0,0)
	new.camPos=vec(0,0)
	new.CAMERA_MOVED=Event.new()
	new.MOUSE_MOVED=Event.new()
	new.ON_FREE=Event.new()
	
	nextID=nextID+1
	return new
end


function Screen:free()
	self.ON_FREE:invoke()
	for key, sprite in pairs(self.sprites) do
		sprite:free()
	end
	self.model:remove()
end


---@overload fun(xy: Vector2): Vector2
---@param x number
---@param y number
---@return Screen
function Screen:setCamPos(x,y)
	local vec2=params.vec2(x,y)
	self.camPos=vec2
	self.CAMERA_MOVED:invoke()
	return self
end


---@overload fun(xy: Vector2): Vector2
---@param x number
---@param y number
---@return Screen
function Screen:setMousePos(x,y)
	local vec2=params.vec2(x,y)
	self.mPos=vec2
	
	local camDim=-self.camPos.xyxy-self.resolution.__xy
	
	self.gmPos=vec(
		math.map(self.mPos.x,0,1,camDim.x,camDim.z),
		math.map(self.mPos.y,0,1,camDim.y,camDim.w)
	)
	self.MOUSE_MOVED:invoke()
	return self
end


---@overload fun(xyz: Vector3): Vector3
---@param x number
---@param y number
---@param z number
function Screen:setDir(x,y,z)
	local vec3=params.vec3(x,y,z)
	self.dir=vec3
end

---@param id Minecraft.soundID
---@param pitch number?
---@param volume number?
---@return Screen
function Screen:sound(id,pitch,volume)
	sounds:playSound(id,client:getCameraDir()+client:getCameraPos(),volume or 1,pitch or 1)
	return self
end


return Screen