-----------------------------------------------------------------------------------------------
-- local title		= "Cave Stuff"
-- local version 	= "0.0.3"
-- local mname		= "cavestuff"
-----------------------------------------------------------------------------------------------

-- dofile(minetest.get_modpath("cavestuff").."/nodes.lua")
-- dofile(minetest.get_modpath("cavestuff").."/mapgen.lua")

-----------------------------------------------------------------------------------------------

-- minetest.log("action", "[Mod] "..title.." ["..version.."] ["..mname.."] Loaded...")

minetest.register_abm({
	nodes = {"cavestuff:pebble_1", "cavestuff:pebble_2", "cavestuff:desert_pebble_1", "cavestuff:desert_pebble_2", "cavestuff:stalactite_1", "cavestuff:stalactite_2", "cavestuff:stalactite_3"},
	interval = 1,
	chance = 1,
	action = function(pos)
		minetest.set_node(pos, {name = "default:grass_2"})
	end,
})
