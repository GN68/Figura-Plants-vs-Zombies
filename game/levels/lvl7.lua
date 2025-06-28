
local z="z.zombie"
local c="z.conehead"
local p="z.pole"

---@type Level
local level={
	inventory={"p.sunflower","p.peashooter","p.cherrybomb","p.wallnut","p.potatomine","p.snowpea"},
	prize="p.chomper",
	next="lvl8",
	waves={
		{c={[1]={z}}},
		{c={[2]={z}}},
		{c={[2]={z}}},
		{c={[1]={z,c}}},
		{c={[4]={z}}},
		{c={[5]={z},[2]={c}}},
		{major=true,c={[5]={z},[1]={p,c}}},
		{c={[3]={z}}},
		{c={[3]={z},[1]={p}}},
		{c={[4]={z},[1]={c}}},
		{c={[5]={z}}},
		{major=true,c={[8]={z},[2]={p,c}}},
	}
}

return level