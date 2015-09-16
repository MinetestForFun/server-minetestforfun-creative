-- Baked Clay (0.4) by TenPlus1

local clay = {
	{"white",      "White",      "basecolor_white"},
	{"grey",       "Grey",       "basecolor_grey"},
	{"black",      "Black",      "basecolor_black"},
	{"red",        "Red",        "basecolor_red"},
	{"yellow",     "Yellow",     "basecolor_yellow"},
	{"green",      "Green",      "basecolor_green"},
	{"cyan",       "Cyan",       "basecolor_cyan"},
	{"blue",       "Blue",       "basecolor_blue"},
	{"magenta",    "Magenta",    "basecolor_magenta"},
	{"orange",     "Orange",     "excolor_orange"},
	{"violet",     "Violet",     "excolor_violet"},
	{"brown",      "Brown",      "unicolor_dark_orange"},
	{"pink",       "Pink",       "unicolor_light_red"},
	{"dark_grey",  "Dark Grey",  "unicolor_darkgrey"},
	{"dark_green", "Dark Green", "unicolor_dark_green"},
}

minetest.register_craft({
	type = "cooking",
	output = "bakedclay:white",
	recipe = "default:clay",
})

for _, row in ipairs(clay) do

	-- node definition
	minetest.register_node("bakedclay:" .. row[1], {
		description = row[2] .. " Baked Clay",
		tiles = {"baked_clay_" .. row[1] ..".png"},
		groups = {cracky=3, bakedclay=1},
		sounds = default.node_sound_stone_defaults(),
	})

	-- craft from dye and white clay
	minetest.register_craft({
		type = "shapeless",
		output = "bakedclay:" .. row[1],
		recipe = {"group:dye," .. row[3], "group:bakedclay"},
	})

	-- register stair and slab
	if stairs and not stairs.mod then
	stairs.register_stair_and_slab("bakedclay_".. row[1], "bakedclay:".. row[1],
		{cracky=3},
		{"baked_clay_" .. row[1] .. ".png"},
		"Baked Clay " .. row[2] .. " Stair",
		"Baked Clay " .. row[2] .. " Slab",
		default.node_sound_stone_defaults())
	end
end

-- register a few extra dye colour options

minetest.register_craft( {
	type = "shapeless",
	output = "dye:dark_grey 3",
	recipe = {
		"dye:black", "dye:black", "dye:white",
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:grey 3",
	recipe = {
		"dye:black", "dye:white", "dye:white",
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:green 4",
	recipe = {
		"default:cactus",
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "dye:black 4",
	recipe = {
		"default:coal_lump",
	},
})
