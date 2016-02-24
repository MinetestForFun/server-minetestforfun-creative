minetest.register_craft({
	output = "diplazer:lightfixer",
	recipe = {
		{"default:steel_ingot","default:torch", "default:steel_ingot"},
		{"","default:steel_ingot",""},
	}
})


minetest.register_tool("diplazer:lightfixer", {
	description = "Light fixer (put on or into unnatural darkness)",
	range = 10,
	inventory_image = "default_lava.png^[colorize:#00dd99aa",
on_place=function(itemstack, user, pointed_thing)
	if pointed_thing.type=="node" and minetest.is_protected(pointed_thing.above, user:get_player_name())==false and minetest.get_node(pointed_thing.above).name=="air"  then
		minetest.set_node(pointed_thing.above,{name="diplazer:lightfix"})
	end
	return itemstack
end,
})

minetest.register_node("diplazer:lightfix", {
	description = "Lightfixt",
	drawtype = "liquid",
	tiles = {"default_lava.png^[colorize:#00dd99aa"},
	alpha = 160,
	light_source = default.LIGHT_MAX - 1,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	drop = "",
	liquid_viscosity = 2,
	liquidtype = "source",
	liquid_alternative_flowing="diplazer:lightfix2",
	liquid_alternative_source="diplazer:lightfix",
	liquid_renewable = false,
	liquid_range = 0,
	sunlight_propagates = true,
	groups = {liquid = 3,not_in_creative_inventory = 1},
	on_construct=function(pos)
		minetest.env:get_node_timer(pos):start(5)
	end,
	on_timer = function (pos, elapsed)
		for i=0,50,1 do
    			local np=minetest.find_node_near(pos, 20,{"diplazer:lightfix2"})
			if np~=nil then
				minetest.set_node(np, {name="air"})
			else
				minetest.set_node(pos, {name="air"})
				return false
			end
		end
	end,
})


minetest.register_node("diplazer:lightfix2", {
	description = "Lightfixt",
	drawtype = "flowingliquid",
	tiles = {"default_lava.png^[colorize:#00dd99aa"},
	special_tiles = {
		{
			name = "default_lava.png^[colorize:#00dd99aa",

		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = default.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	sunlight_propagates = true,
	is_ground_content = false,
	drop = "",
	liquid_range = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "diplazer:lightfix2",
	liquid_alternative_source = "diplazer:lightfix",
	liquid_viscosity = 2,
	liquid_renewable = false,
	groups = {liquid = 3,not_in_creative_inventory = 1},
})