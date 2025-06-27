---@class Level
---@field waves Level.Wave[]
---@field prize Object.Identity?
---@field init function?
---@field grid_range Vector4?
---@field fun fun(s:Screen,lvl:Level)?

---@class Level.Wave
---@field major boolean?
---@field c table<integer,Object.Identity[]> # the integer represents how many of that identity to spawn

local z="z.zombie"

---@type Level
local level={
	suns=150,
	grass=1,
	skip=false,
	inventory = {"p.peashooter","lawnmower"},
	grid_range=vec(0,2,9,3),
	prize="p.sunflower",
	next="lvl2",
	waves={
		{c={[1]={z}}},
		{c={[1]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{major=true,c={[3]={z}}},
	}
}

return level