
local u = {}

function u.plant(plant,screen)
	screen.plants[plant.pos:toString()]=plant
end

function u.unplant(plant,screen)
	screen.plants[plant.pos:toString()]=nil
end

return u