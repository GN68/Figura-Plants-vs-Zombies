---@class Object.Processor
---@field ENTER fun(self: Object,screen: Screen,...:any)?
---@field TICK fun(self: Object,screen: Screen)?
---@field CLICK fun(self: Object,screen: Screen)?
---@field DEATH fun(self: Object,screen: Screen)?
---@field DAMAGED fun(self: Object,screen: Screen)?
---@field EXIT fun(self: Object,screen: Screen)?


---@class Object.Identity
---@field icon Frame
---@field seed Frame
---@field cost integer
---@field name string
---@field maxHealth integer
---@field processor Object.Processor


local placeholder=function ()end


local Identity={}
Identity.__index=Identity

local IDENTITIES={}

---@param seed Frame
---@param icon Frame
---@param name string
---@param heath integer
---@param processor Object.Processor
function Identity.new(seed,icon,name,cost,heath,processor)
	local new={
		seed=seed,
		icon=icon,
		name=name,
		cost=cost,
		maxHealth=heath,
		processor=processor
	}
	processor.ENTER=processor.ENTER or placeholder
	processor.TICK=processor.TICK or placeholder
	processor.CLICK=processor.CLICK or placeholder
	processor.EXIT=processor.EXIT or placeholder
	processor.DEATH=processor.DEATH or placeholder
	processor.DAMAGED=processor.DAMAGED or placeholder
	IDENTITIES[name]=new
end

Identity.IDENTITIES=IDENTITIES

return Identity