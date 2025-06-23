

---@class Sequence
---@field keyframes {time:integer,func:function}[]
---@field trackingKeyframe integer
---@field time integer
---@field isActive boolean
local Sequence={}
Sequence.__index=Sequence

local active={}

---Creates a new sequence
---@return Sequence
function Sequence.new()
	local new={}
	setmetatable(new,Sequence)
	new.keyframes={}
	new.time=0
	new.trackingKeyframe=1
	new.isActive=false
	return new
end


---Appens a keyframe into the sequence.
---@param time integer
---@param func function
---@return Sequence
function Sequence:add(time,func)
	local found=false
	for i=1, #self.keyframes, 1 do
		if self.keyframes[i].time > time then
			table.insert(self.keyframes,i,{time=time,func=func})
			found=true
			break
		end
	end
	if not found then
		table.insert(self.keyframes,{time=time,func=func})
	end
	return self
end

function Sequence:start()
	self.time=0
	self.trackingKeyframe=1
	self.isActive=true
	active[self]=true
end


function Sequence:process()
	if self.isActive then
		local tracking=self.keyframes[self.trackingKeyframe]
		if tracking.time <= self.time then
			if tracking.func() then
				self.time=self.time-1
			else
				self.trackingKeyframe=self.trackingKeyframe+1
			end
		end
	
		if self.trackingKeyframe > #self.keyframes then
			self.time=0
			self.trackingKeyframe=1
			self.isActive=false
			active[self]=nil
			return
		end
		self.time=self.time+1
	end
end

function Sequence.tick()
	for key in pairs(active) do
		key:process()
	end
end


return Sequence