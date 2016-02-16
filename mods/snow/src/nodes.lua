-- NODES

-- Pine Needles
local nodedef = {
	description = "Pine Needles",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"snow_needles.png"},
	waving = 1,
	paramtype = "light",
	groups = {snappy=3, leafdecay=5},
	furnace_burntime = 1,
	drop = {
		max_items = 1,
		items = {
			{
				items = {'snow:needles'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
}

--[[
If christmas_content is enabled, then this next part will override the pine needles' drop code
(in the code section above) and adds Xmas tree saplings to the items that are dropped.
The Xmas tree needles are registred and defined a farther down in this nodes.lua file.

~ LazyJ

if snow.christmas_content then
	table.insert(nodedef.drop.items, 1, {
		-- player will get xmas tree with 1/120 chance
		items = {'snow:xmas_tree'},
		rarity = 120,
	})
end
]]
minetest.register_node("snow:needles", table.copy(nodedef))





	--Christmas easter egg
	minetest.register_on_mapgen_init( function()
		if rawget(_G, "skins") then
			skins.add("character_snow_man")
		end
	end
	)


-- Decorated Pine Leaves

nodedef.description ="Decorated "..nodedef.description
nodedef.light_source = 5
nodedef.waving = nil
if snow.disable_deco_needle_ani then
	nodedef.tiles = {"snow_needles_decorated.png"}
else
	-- Animated, "blinking lights" version. ~ LazyJ
	nodedef.inventory_image = minetest.inventorycube("snow_needles_decorated.png")
	nodedef.tiles = {
		{name="snow_needles_decorated_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=20.0}}
	}
end
nodedef.drop.items[#nodedef.drop.items] = {items = {'snow:needles_decorated'}}

minetest.register_node("snow:needles_decorated", nodedef)


--[[ Saplings

nodedef = {
	description = "Pine Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"snow_sapling_pine.png"},
	inventory_image = "snow_sapling_pine.png",
	wield_image = "snow_sapling_pine.png",
	paramtype = "light",
	walkable = false,
	groups = {snappy=2,dig_immediate=3},
	furnace_burntime = 10,
	sounds = default.node_sound_defaults(),
}

-- Pine Sapling
minetest.register_node("snow:sapling_pine", table.copy(nodedef))

-- Xmas Tree Sapling
nodedef.description = "Christmas Tree"
nodedef.tiles = {"snow_xmas_tree.png"}
nodedef.inventory_image = "snow_xmas_tree.png"
nodedef.wield_image = "snow_xmas_tree.png"

minetest.register_node("snow:xmas_tree", nodedef)
]]

nodedef = {
	description = "Star",
	drawtype = "plantlike",
	tiles = {"snow_star.png"},
	inventory_image = "snow_star.png",
	wield_image = "snow_star.png",
	paramtype = "light",
	walkable = false,
	-- Don't want the ornament breaking too easily because you have to punch it to turn it on and off. ~ LazyJ
	groups = {cracky=1, crumbly=1, choppy=1, oddly_breakable_by_hand=1},
	-- Breaking "glass" sound makes it sound like a real, broken, Xmas tree ornament (Sorry, Mom!).  ;)-  ~ LazyJ
	sounds = default.node_sound_glass_defaults({dig = {name="default_glass_footstep", gain=0.2}}),
	on_punch = function(pos, node) -- Added a "lit" star that can be punched on or off depending on your preference. ~ LazyJ
		node.name = "snow:star_lit"
		minetest.set_node(pos, node)
		nodeupdate(pos)
	end,
}

-- Star on Xmas Trees
minetest.register_node("snow:star", table.copy(nodedef))

-- Star (Lit Version) on Xmas Trees
nodedef.description = nodedef.description.." Lighted"
nodedef.light_source = LIGHT_MAX
nodedef.tiles = {"snow_star_lit.png"}
nodedef.drop = "snow:star"
nodedef.groups.not_in_creative_inventory = 1
nodedef.on_punch = function(pos, node)
	node.name = "snow:star"
	minetest.set_node(pos, node)
	nodeupdate(pos)
end

minetest.register_node("snow:star_lit", nodedef)



-- Plants

-- Moss
minetest.register_node("snow:moss", {
	description = "Moss",
	inventory_image = "snow_moss.png",
	tiles = {"snow_moss.png"},
	drawtype = "signlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	is_ground_content = true,
	groups = {crumbly=3, attached_node=1},
	furnace_burntime = 3,
})

-- Shrub(s)
nodedef = {
	description = "Snow Shrub",
	tiles = {"snow_shrub.png"},
	inventory_image = "snow_shrub.png",
	wield_image = "snow_shrub.png",
	drawtype = "plantlike",
	paramtype = "light",
	waving = 1,
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = true,
	buildable_to = true,
	groups = {snappy=3,flammable=3,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -5/16, 0.3},
	},
	furnace_burntime = 5,
}
minetest.register_node("snow:shrub", table.copy(nodedef))

nodedef.tiles = {"snow_shrub.png^snow_shrub_covering.png"}
nodedef.inventory_image = "snow_shrub.png^snow_shrub_covering.png"
nodedef.wield_image = "snow_shrub.png^snow_shrub_covering.png"
nodedef.drop = "snow:shrub"
nodedef.furnace_burntime = 3
minetest.register_node("snow:shrub_covered", nodedef)

-- Flowers
if rawget(_G, "flowers") then
	-- broken flowers
	snow.known_plants = {}
	for _,name in pairs({"dandelion_yellow", "geranium", "rose", "tulip", "dandelion_white", "viola"}) do
		local flowername = "flowers:"..name
		local newname = "snow:flower_"..name
		local flower = minetest.registered_nodes[flowername]
		minetest.register_node(newname, {
			drawtype = "plantlike",
			tiles = { "snow_" .. name .. ".png" },
			sunlight_propagates = true,
			paramtype = "light",
			walkable = false,
			drop = "",
			groups = {snappy=3, attached_node = 1},
			sounds = default.node_sound_leaves_defaults(),
			selection_box = flower.selection_box
		})
		snow.known_plants[minetest.get_content_id(flowername)] = minetest.get_content_id(newname)
	end
end

-- Leaves
local leaves = minetest.registered_nodes["default:leaves"]
nodedef = {
	description = "Snow Leaves",
	tiles = {"snow_leaves.png"},
	waving = 1,
	visual_scale = leaves.visual_scale,
	drawtype = leaves.drawtype,
	paramtype = leaves.paramtype,
	groups = leaves.groups,
	drop = leaves.drop,
	sounds = leaves.sounds,
}
nodedef.groups.flammable = 1

minetest.register_node("snow:leaves", nodedef)
snow.known_plants[minetest.get_content_id("default:leaves")] = minetest.get_content_id("snow:leaves")

local apple = minetest.registered_nodes["default:apple"]
nodedef = {
	description = "Snow Apple",
	drawtype = "plantlike",
	tiles = {"snow_apple.png"},
	paramtype = "light",
	walkable = false,
	sunlight_propagates = apple.sunlight_propagates,
	selection_box = apple.selection_box,
	groups = apple.groups,
	sounds = apple.sounds,
	drop = apple.drop,
}
nodedef.groups.flammable = 1

minetest.register_node("snow:apple", nodedef)
snow.known_plants[minetest.get_content_id("default:apple")] = minetest.get_content_id("snow:apple")

-- TODO
snow.known_plants[minetest.get_content_id("default:jungleleaves")] = minetest.get_content_id("default:jungleleaves")



local function snow_onto_dirt(pos)
	pos.y = pos.y - 1
	local node = minetest.get_node(pos)
	if node.name == "default:dirt_with_grass"
	or node.name == "default:dirt" then
		node.name = "default:dirt_with_snow"
		minetest.set_node(pos, node)
	end
end



-- Bricks

nodedef = {
	description = "Snow Brick",
	tiles = {"snow_snow_brick.png"},
	is_ground_content = true,
	--freezemelt = "default:water_source", -- deprecated
	liquidtype = "none",
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir", -- Allow blocks to be rotated with the screwdriver or
	-- by player position. ~ LazyJ
	 -- I made this a little harder to dig than snow blocks because
	 -- I imagine snow brick as being much more dense and solid than fluffy snow. ~ LazyJ
	groups = {cracky=2, crumbly=2, choppy=2, oddly_breakable_by_hand=2, melts=1, icemaker=1, cooks_into_ice=1},
	 --Let's use the new snow sounds instead of the old grass sounds. ~ LazyJ
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_snow_footstep", gain=0.25},
		dig = {name="default_dig_crumbly", gain=0.4},
		dug = {name="default_snow_footstep", gain=0.75},
		place = {name="default_place_node", gain=1.0}
	}),
 	-- The "on_construct" part below, thinking in terms of layers, dirt_with_snow could also
 	-- double as dirt_with_frost which adds subtlety to the winterscape. ~ LazyJ
	on_construct = snow_onto_dirt
}

-- Snow Brick
minetest.register_node("snow:snow_brick", table.copy(nodedef))


-- hard Ice Brick, original texture from LazyJ
local ibdef = table.copy(nodedef)
ibdef.description = "Ice Brick"
ibdef.tiles = {"snow_ice_brick.png"}
ibdef.use_texture_alpha = true
ibdef.drawtype = "glasslike"
ibdef.groups = {cracky=1, crumbly=1, choppy=1, melts=1}
ibdef.sounds = default.node_sound_glass_defaults({
	dug = {name="default_hard_footstep", gain=1}
})

minetest.register_node("snow:ice_brick", ibdef)


-- Snow Cobble  ~ LazyJ
-- Described as Icy Snow
nodedef.description = "Icy Snow"
nodedef.tiles = {"snow_snow_cobble.png"}

minetest.register_node("snow:snow_cobble", nodedef)



-- Override Default Nodes to Add Extra Functions

-- This adds code to the existing default ice. ~ LazyJ
minetest.override_item("default:ice", {
	-- The Lines: 1. Alpah to make semi-transparent ice, 2 to work with
	-- the dirt_with_grass/snow/just dirt ABMs. ~ LazyJ, 2014_03_09
	use_texture_alpha = true, -- 1
	param2 = 0,
	--param2 is reserved for how much ice will freezeover.
	sunlight_propagates = true, -- 2
	drawtype = "glasslike",
	inventory_image  = minetest.inventorycube("default_ice.png").."^[brighten",
	liquidtype = "none",
	 -- I made this a lot harder to dig than snow blocks because ice is much more dense
	 -- and solid than fluffy snow. ~ LazyJ
	groups = {cracky=2, crumbly=1, choppy=1, --[[oddly_breakable_by_hand=1,]] melts=1},
	on_construct = snow_onto_dirt,
	liquids_pointable = true,
	--Make ice freeze over when placed by a maximum of 10 blocks.
	after_place_node = function(pos)
		minetest.set_node(pos, {name="default:ice", param2=math.random(0,10)})
	end
})



-- This adds code to the existing, default snowblock. ~ LazyJ
minetest.override_item("default:snowblock", {
	liquidtype = "none", -- LazyJ to make dirt below change to dirt_with_snow (see default, nodes.lua, dirt ABM)
	paramtype = "light",  -- LazyJ to make dirt below change to dirt_with_snow (see default, nodes.lua, dirt ABM)
	sunlight_propagates = true, -- LazyJ to make dirt below change to dirt_with_snow (see default, nodes.lua, dirt ABM)
	 -- Snow blocks should be easy to dig because they are just fluffy snow. ~ LazyJ
	groups = {cracky=3, crumbly=3, choppy=3, oddly_breakable_by_hand=3, melts=1, icemaker=1, cooks_into_ice=1, falling_node=1},
	--drop = "snow:snow_cobble",
	on_construct = snow_onto_dirt
		-- Thinking in terms of layers, dirt_with_snow could also double as
		-- dirt_with_frost which adds subtlety to the winterscape. ~ LazyJ, 2014_04_04
})
