-- carpet3d by srifqi
-- License: CC0 1.0 Universal
print("[carpet3d] Carpet")
-- Carpet API
carpet3d = {}
carpet3d.count = 0

-- Registering carpet ( carpet3d.register() )
--[[
	def is a table that contains:
	name		: itemstring "carpet:name"
	description	: node description (optional)
	images		: node tiles
	recipeitem	: node crafting recipeitem {recipeitem,recipeitem}
	groups		: node groups
	sounds		: node sounds (optional)
--]]
-- Carpet will be named carpet3d:name
function carpet3d.register(def)
	local name = def.name
	local desc = def.description or ""
	local recipeitem = def.recipeitem
	local sounds = def.sounds or default.node_sound_defaults()
	-- Node Definition
	minetest.register_node("carpet3d:"..name, {
		description = desc,
		tiles = def.images,
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -7/16, 0.5},
		},
		drawtype = "nodebox",
		groups = def.groups,
		sounds = sounds,
	})
	-- Crafting Definition
	minetest.register_craft({
		output = 'carpet3d:'..name..' 4',
		recipe = {
			{recipeitem, recipeitem},
		}
	})
	carpet3d.count = carpet3d.count +1
end

-- For internal purpose
minetest.register_node("carpet3d:nil", {
	description = "nil Carpet (ERR)",
	tiles = "default_dirt.png",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -7/16, 0.5},
	},
	drawtype = "nodebox",
	groups = {carpet=1,not_in_creative_inventory=1},
	sounds = default.node_sound_defaults(),
})

-- Add carpet from wool mod + default mod + moretrees mod (if available)
local wool_list = {
	{"white",		"White"},
	{"grey",		"Grey"},
	{"black",		"Black"},
	{"red",			"Red"},
	{"yellow",		"Yellow"},
	{"green",		"Green"},
	{"cyan",		"Cyan"},
	{"blue",		"Blue"},
	{"magenta",		"Magenta"},
	{"orange",		"Orange"},
	{"violet",		"Violet"},
	{"brown",		"Brown"},
	{"pink",		"Pink"},
	{"dark_grey",	"Dark Grey"},
	{"dark_green",	"Dark Green"},
}

local decor_list = {
	{"default:leaves","default_leaves","Leaves"},
	{"default:jungleleaves","default_jungleleaves","Jungle Leaves"},
	{"default:papyrus","default_papyrus","Papyrus"},
	{"default:sapling","default_sapling","Sapling"},
	{"default:junglesapling","default_junglesapling","Jungle Sapling"},
}

local front_list = {
	{"default:apple","default_apple","Apple"},
	{"flowers:dandelion_white","flowers_dandelion_white","White Dandelion"},
	{"flowers:dandelion_yellow","flowers_dandelion_yellow","Yellow Dandelion"},
	{"flowers:geranium","flowers_geranium","Geranium"},
	{"flowers:rose","flowers_rose","Rose"},
	{"flowers:tulip","flowers_tulip","Tulip"},
	{"flowers:viola","flowers_viola","Viola"},
}

print("[carpet3d]:"..carpet3d.count.." carpets registered")