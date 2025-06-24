---@class Level
---@field waves Level.Wave[]
---@field prize Object.Identity?
---@field init function?
---@field grid_range Vector4?

---@class Level.Wave
---@field major boolean?
---@field c table<integer,Object.Identity[]> # the integer represents how many of that identity to spawn

local z="zombie"

---@type Level
local level={
	suns=150,
	sunTimer=5,
	grass=1,
	grid_range=vec(0,2,9,3),
	prize="sunflower",
	waves={
		{c={[1]={z}}},
		{c={[1]={z}}},
		{c={[3]={z}}},
		{c={[4]={z}}},
		{major=true,c={[10]={z}}},
		{c={[4]={z}}},
		{c={[3]={z}}},
		{c={[4]={z}}},
	}
}

return level