
local z="z.zombie"
local c="z.conehead"
local p="z.pole"

---@type Level
local level={
	inventory = {"p.sunflower","p.peashooter","p.cherrybomb","p.wallnut","p.potatomine"},
	prize="p.snowpea",
	next="lvl7",
	waves={
		{c={[1]={z}}},
		{c={[2]={z}}},
		{c={[3]={z}}},
		{c={[3]={z},[1]={c}}},
		{c={[4]={z}}},
		{c={[4]={z}}},
		{major=true,c={[4]={z},[1]={p,c}}},
		{c={[3]={z}}},
		{c={[3]={z}}},
		{c={[4]={z},[1]={c}}},
		{c={[5]={z}}},
		{major=true,c={[7]={z},[2]={p,c}}},
	}
}

return level