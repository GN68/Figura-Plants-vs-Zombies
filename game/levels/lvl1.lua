---@class Level
---@field waves Level.Wave[]
---@field prize Object.Identity?
---@field init function?
---@field grid_range Vector4?

---@class Level.Wave
---@field major boolean?
---@field classes table<integer,Object.Identity[]> # the integer represents how many of that identity to spawn

local z="zombie"

---@type Level
local level={
	suns=150,
	sunTimer=5,
	grid_range=vec(0,2,9,3),
	prize="sunflower",
	waves={
		{classes={[1]={z}}
		},
		{classes={[1]={z}}
		},
		{classes={[3]={z}}
		},
		{classes={[4]={z}}
		},
		{major=true,classes={[10]={z}}
		},
		{classes={[4]={z}}
		},
		{classes={[3]={z}}
		},
		{classes={[4]={z}}
		},	
	}
}

return level