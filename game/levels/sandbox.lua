local z="zombie"

---@type Level
local level={
	suns=100000,
	sunTimer=10000000,
	inventory = {"p.sunflower","p.peashooter","p.cherrybomb","z.zombie"},
	skip = true,
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