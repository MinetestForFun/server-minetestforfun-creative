local load_time_start = os.clock()

local function add_stair(name, data)
	data.groups.stone = nil
	stairs.register_stair_and_slab("morecobblenodes_"..name, "morecobblenodes:"..name,
		data.groups,
		data.tiles,
		data.description.." stair",
		data.description.." slab",
		data.sounds
	)
end

local moss_found = rawget(_G, "moss")
local function register_node(name, data)
	minetest.register_node("morecobblenodes:"..name, table.copy(data))
	local stair = not data.no_stair
	if stair then
		add_stair(name, table.copy(data))
	end
	if not moss_found then
		return
	end
	data.tiles = data.moss
	if not data.tiles then
		return
	end
	data.description = "mossy "..data.description
	local mossname = name.."_mossy"
	if stair then
		add_stair(mossname, table.copy(data))
	end
	minetest.register_node("morecobblenodes:"..mossname, data)
	moss.register_moss({
		node = "morecobblenodes:"..name,
		result = "morecobblenodes:"..mossname
	})
end

register_node("stones_big", {
	description = "big stones",
	tiles = {"morecobblenodes_stones_big.png"},
	moss = {"morecobblenodes_stones_big_mossy.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

register_node("stones_middle", {
	description = "stones",
	tiles = {"morecobblenodes_stones_middle.png"},
	moss = {"morecobblenodes_stones_middle_mossy.png"},
	groups = {cracky=3, stone=2},
	sounds = default.node_sound_stone_defaults(),
})

register_node("stonebrick_middle", {
	description = "stone brick",
	tiles = {"morecobblenodes_stone_brick_middle.png"},
	moss = {"morecobblenodes_stone_brick_middle_mossy.png"},
	groups = {cracky=3, stone=2},
	sounds = default.node_sound_stone_defaults(),
})

register_node("sand_and_dirt", {
	description = "sand dirt mixed",
	tiles = {"morecobblenodes_sand_and_dirt.png"},
	groups = {crumbly=3, soil=1, falling_node=1, sand=1},
	sounds = default.node_sound_dirt_defaults(),
	no_stair = true
})

register_node("sand_and_dirt_grass", {
	description = "sand dirt mixed with grass",
	tiles = {
		"morecobblenodes_grass.png",
		"morecobblenodes_sand_and_dirt.png",
		"morecobblenodes_sand_and_dirt.png^morecobblenodes_grass_side.png"
	},
	groups = {crumbly=3, soil=1, sand=1},
	drop = "morecobblenodes:sand_and_dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.25},
	}),
	no_stair = true
})

local function grass_allowed(pos)
	local light = minetest.get_node_light(pos, 0.5)
	if not light then
		return 0
	end
	if light < 7 then
		return false
	end
	local nd = minetest.get_node(pos).name
	if nd == "air" then
		return true
	end
	if nd == "ignore" then
		return 0
	end
	local data = minetest.registered_nodes[nd]
	local drawtype = data.drawtype
	if drawtype
	and drawtype ~= "normal"
	and drawtype ~= "liquid"
	and drawtype ~= "flowingliquid" then
		return true
	end
	local light = data.light_source
	if light
	and light > 0 then
		return true
	end
	return false
end

minetest.register_abm({
	nodenames = {"morecobblenodes:sand_and_dirt"},
	interval = 20,
	chance = 9,
	action = function(pos)
		local allowed = grass_allowed({x=pos.x, y=pos.y+1, z=pos.z})
		if allowed == 0 then
			minetest.log("info", "[morecobblenodes] error replacing sand_and_dirt")
			return
		end
		if allowed then
			minetest.set_node(pos, {name="morecobblenodes:sand_and_dirt_grass"})
			minetest.log("info", "[morecobblenodes] grass grew on sand_and_dirt")
		end
	end
})

minetest.register_abm({
	nodenames = {"morecobblenodes:sand_and_dirt_grass"},
	interval = 30,
	chance = 9,
	action = function(pos)
		local allowed = grass_allowed({x=pos.x, y=pos.y+1, z=pos.z})
		if allowed == 0 then
			minetest.log("info", "[morecobblenodes] error replacing sand_and_dirt_grass")
			return
		end
		if not allowed then
			minetest.set_node(pos, {name="morecobblenodes:sand_and_dirt"})
			minetest.log("info", "[morecobblenodes] grass disappeared on sand_and_dirt")
		end
	end
})

--recipes
if rawget(_G, "technic")
and technic.register_separating_recipe then
	for _,i in pairs({
		{"default:cobble 2", "morecobblenodes:stones_big", "default:gravel"},
		{"default:gravel 2", "morecobblenodes:stones_middle", "morecobblenodes:sand_and_dirt"},
		{"morecobblenodes:sand_and_dirt 2", "default:sand", "default:dirt"},
	}) do
		technic.register_separating_recipe({input={i[1]}, output={i[2], i[3]}})
	end
end

minetest.register_craft({
	output = "morecobblenodes:stonebrick_middle 4",
	recipe = {
		{"morecobblenodes:stones_middle", "morecobblenodes:stones_middle"},
		{"morecobblenodes:stones_middle", "morecobblenodes:stones_middle"},
	}
})

local time = math.floor(tonumber(os.clock()-load_time_start)*100+0.5)/100
local msg = "[morecobblenodes] loaded after ca. "..time
if time > 0.05 then
	print(msg)
else
	minetest.log("info", msg)
end
