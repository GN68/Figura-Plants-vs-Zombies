local z="z.zombie"

---@type Level
local level={
	suns=99999,
	sunTimer=10000000,
	inventory = {"p.sunflower","p.peashooter","p.cherrybomb","p.chomper","p.potatomine","p.wallnut","z.zombie"},
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
	},
	fun=function (s,lvl)
		s.spawnTimer = 0
	end
}

return level