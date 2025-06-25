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
	sunTimer=5,
	grass=2,
	grid_range=vec(0,1,9,4),
	inventory = {"p.sunflower","p.peashooter"},
	prize="p.sunflower",
	next="sandbox",
	waves={
		{c={[1]={z}}},
		{c={[1]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[3]={z}}},
		{c={[2]={z}}},
		{c={[3]={z}}},
		{c={[3]={z}}},
		{major=true,c={[5]={z}}},
	}
}

return level