---@class Object.Processor
---@field ENTER fun(self: Object,screen: Screen)?
---@field TICK fun(self: Object,screen: Screen)?
---@field CLICK fun(self: Object,screen: Screen)?
---@field EXIT fun(self: Object,screen: Screen)?


---@class Object.Identity
---@field icon Sprite
---@field cost integer
---@field name string
---@field processor Object.Processor


local placeholder = function ()end


local Identity = {}
Identity.__index = Identity

local IDENTITIES = {}

---@param icon Frame
---@param name string
---@param processor Object.Processor
function Identity.new(icon,name,processor)
	local identity = {
		icon = icon,
		name = name,
		processor = processor
	}
	processor.ENTER = processor.ENTER or placeholder
	processor.TICK = processor.TICK or placeholder
	processor.CLICK = processor.CLICK or placeholder
	processor.EXIT = processor.EXIT or placeholder
	
	local proxy = setmetatable({},{
		__index = identity,
		__newindex = function (_,key) error("Attempted to change a read-only property: " .. key) end
	})
	
	IDENTITIES[name] = proxy
end

Identity.IDENTITIES = IDENTITIES

return Identity