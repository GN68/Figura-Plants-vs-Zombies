
local z="z.zombie"
local c="z.conehead"

---@type Level
local level={
	inventory = {"p.sunflower","p.peashooter","p.cherrybomb","p.wallnut"},
	prize="p.sunflower",
	next="bowling",
	waves={
		{c={[1]={z}}},
		{c={[1]={z}}},
		{c={[2]={z}}},
		{c={[2]={z},[1]={c}}},
		{c={[2]={z}}},
		{c={[2]={z},[1]={c}}},
		{c={[2]={z}}},
		{c={[3]={z},[1]={c}}},
		{c={[3]={z},[2]={c}}},
		{major=true,c={[5]={z}}},
	}
}

return level