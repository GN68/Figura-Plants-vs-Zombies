
local z="z.zombie"
local c="z.conehead"
local b="z.bucket"

---@type Level
local level={
	inventory={"p.sunflower","p.peashooter","p.cherrybomb","p.wallnut","p.potatomine","p.snowpea","p.chomper","p.repeater"},
	prize="p.sunflower",
	next="endless",
	waves={
		{c={[1]={z}}},
		{c={[1]={z}}},
		{c={[2]={z}}},
		{c={[3]={z}}},
		{c={[4]={z},[1]={c}}},
		{c={[5]={z},[1]={c,b}}},
		{major=true,c={[7]={z},[1]={b,c}}},
		{c={[4]={z}}},
		{c={[4]={z},[1]={c}}},
		{c={[4]={z}}},
		{c={[5]={z},[2]={b}}},
		{c={[4]={z},[2]={c}}},
		{c={[5]={z},[2]={c,b}}},
		{major=true,c={[8]={z},[4]={b,c}}},
	}
}

return level