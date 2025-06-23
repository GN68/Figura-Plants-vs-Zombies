---@class Object.Processor
---@field ENTER fun(self: Object,screen: Screen)?
---@field TICK fun(self: Object,screen: Screen)?
---@field CLICK fun(self: Object,screen: Screen)?
---@field DEATH fun(self: Object,screen: Screen)?
---@field DAMAGED fun(self: Object,screen: Screen)?
---@field EXIT fun(self: Object,screen: Screen)?


---@class Object.Identity
---@field icon Frame
---@field cost integer
---@field name string
---@field maxHealth integer
---@field processor Object.Processor


local placeholder = function ()end


local Identity = {}
Identity.__index = Identity

local IDENTITIES = {}

---@param icon Frame
---@param name string
---@param heath integer
---@param processor Object.Processor
function Identity.new(icon,name,heath,processor)
	local identity = {
		icon = icon,
		name = name,
		maxHealth = heath,
		processor = processor
	}
	processor.ENTER = processor.ENTER or placeholder
	processor.TICK = processor.TICK or placeholder
	processor.CLICK = processor.CLICK or placeholder
	processor.EXIT = processor.EXIT or placeholder
	processor.DEATH = processor.DEATH or placeholder
	processor.DAMAGED = processor.DAMAGED or placeholder
	
	local proxy = setmetatable({},{
		__index = identity,
		__newindex = function (_,key) error("Attempted to change a read-only property: " .. key) end
	})
	
	IDENTITIES[name] = proxy
end

Identity.IDENTITIES = IDENTITIES

return Identity