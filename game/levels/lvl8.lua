
local z="z.zombie"
local c="z.conehead"
local b="z.bucket"
local p="z.pole"

---@type Level
local level={
	inventory = {"p.sunflower","p.peashooter","p.cherrybomb","p.wallnut","p.potatomine","p.snowpea","p.chomper"},
	prize="p.repeater",
	next="lvl9",
	waves={
		{c={[1]={z}}},
		{c={[1]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[3]={z}}},
		{c={[3]={z},[1]={b}}},
		{c={[3]={z},[1]={c,p}}},
		{major=true,c={[6]={z},[2]={c,b},[1]={c,p}}},
		{c={[4]={z}}},
		{c={[5]={z},[1]={b,p}}},
		{c={[4]={z},[1]={c}}},
		{c={[4]={z}}},
		{major=true,c={[7]={z},[2]={b,c,p}}},
	}
}

return level