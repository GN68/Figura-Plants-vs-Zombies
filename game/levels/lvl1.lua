---@class Level
---@field waves Level.Wave[]
---@field prize Object.Identity?
---@field init function?

---@class Level.Wave
---@field major boolean?
---@field classes table<integer,Object.Identity[]> # the integer represents how many of that identity to spawn

local z = "zombie"

---@type Level
local level = {
	prize = "sunflower",
	waves = {
		{classes = {[1] = {z}}
		},
		{classes = {[1] = {z}}
		},
		{classes = {[3] = {z}}
		},
		{classes = {[4] = {z}}
		},
		{major = true,classes = {[10] = {z}}
		},
		{classes = {[4] = {z}}
		},
		{classes = {[3] = {z}}
		},
		{classes = {[4] = {z}}
		},	
	}
}

return level