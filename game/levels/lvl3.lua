
local z="z.zombie"
local c="z.conehead"

---@type Level
local level={
	grass=3,
	inventory={"p.sunflower","p.peashooter","p.cherrybomb"},
	prize="p.wallnut",
	next="lvl4",
	noShovel=true,
	waves={
		{c={[1]={z}}},
		{c={[1]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[2]={z},[1]={c}}},
		{c={[2]={z}}},
		{c={[3]={z}}},
		{c={[2]={z}}},
		{c={[3]={z},[1]={c}}},
		{c={[3]={z},[1]={c}}},
		{major=true,c={[5]={z}}},
	}
}

return level