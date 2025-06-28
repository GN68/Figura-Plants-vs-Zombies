
local z="z.zombie"

---@type Level
local level={
	grass=2,
	grid_range=vec(0,1,9,4),
	inventory = {"p.sunflower","p.peashooter"},
	prize="p.cherrybomb",
	next="lvl3",
	noShovel=true,
	waves={
		{c={[1]={z}}},
		{c={[1]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[3]={z}}},
		{c={[3]={z}}},
		{c={[3]={z}}},
		{major=true,c={[5]={z}}},
	}
}

return level