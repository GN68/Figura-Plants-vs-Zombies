
local z="z.zombie"
local c="z.conehead"
---@type Level
local level={
	bowling=true,
	sunTimer=17,
	waveCooldown=0,
	inventory = {"p.wallnut","p.wallnut","p.wallnut","p.wallnut","p.cherrybomb"},
	prize="p.potatomine",
	next="lvl6",
	waves={
		{c={[1]={z,c}}},
		{c={[2]={z}}},
		{c={[3]={z}}},
		{c={[4]={z}}},
		{c={[4]={z},[1]={c}}},
		{c={[4]={z}}},
		{c={[5]={z}}},
		{c={[6]={z},[1]={c}}},
		{c={[6]={z}}},
		{c={[8]={z},[1]={c}}},
		{c={[8]={z},[2]={c}}},
		{c={[8]={z}}},
		{c={[18]={z},[3]={c}}},
	},
	fun=function (s,lvl)
		s.spawnTimer = 0
	end
}

return level