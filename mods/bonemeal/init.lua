local plant_tab = {
	"air",
	"default:grass_1",
	"default:grass_2",
	"default:grass_3",
	"default:grass_4",
	"default:grass_5",
	"flowers:dandelion_white",
	"flowers:dandelion_yellow",
	"flowers:geranium",
	"flowers:rose",
	"flowers:tulip",
	"flowers:viola"
}

local function can_grow(pos)
	pos.y = pos.y-1
	local node_under = minetest.get_node_or_nil(pos)
	pos.y = pos.y+1
	if not node_under then
		return false
	end
	if minetest.get_item_group(node_under.name, "soil") > 0 then
		return true
	else
		return false
	end
end

local function tree_grow(pos, node)
	local sapling = node.name
	local mapgen = minetest.get_mapgen_params().mgname
	if sapling == "default:sapling" then
		if mapgen == "v6" then
			default.grow_tree(pos, math.random(1, 4) == 1)
		else
			default.grow_new_apple_tree(pos)
		end
	elseif sapling == "default:junglesapling" then
		if mapgen == "v6" then
			default.grow_jungle_tree(pos)
		else
			default.grow_new_jungle_tree(pos)
		end
	elseif sapling == "default:pine_sapling" then
		if mapgen == "v6" then
			default.grow_pine_tree(pos)
		else
			default.grow_new_pine_tree(pos)
		end
	elseif sapling == "default:acacia_sapling" then
		default.grow_new_acacia_tree(pos)
	elseif sapling == "farming_plus:banana_sapling" then
		farming.generate_tree(pos, "default:tree", "farming_plus:banana_leaves", {"default:dirt", "default:dirt_with_grass"}, {["farming_plus:banana"]=20})
	elseif sapling == "farming_plus:cocoa_sapling" then
		farming.generate_tree(pos, "default:tree", "farming_plus:cocoa_leaves", {"default:sand", "default:desert_sand"}, {["farming_plus:cocoa"]=20})
	elseif sapling == "default:cherry_sapling" then
		default.grow_cherry_tree(pos, math.random(1, 4) == 1, "default:cherry_tree", "default:cherry_blossom_leaves")
	elseif sapling == "moretrees:apple_tree_sapling" then
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, moretrees["apple_tree_model"])
	elseif sapling == "moretrees:beech_sapling" then
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, moretrees["beech_model"])
	elseif sapling == "moretrees:birch_sapling" then
		moretrees.grow_birch(pos)
	elseif sapling == "moretrees:fir_sapling" then
		if minetest.find_node_near(pos, 2, {"default:snow", "default:dirt_with_snow"}) and math.random(1,3) ~= 1 then
			moretrees.grow_fir_snow(pos)
		else
			moretrees.grow_fir(pos)
		end
	elseif sapling == "moretrees:oak_sapling" then
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, moretrees["oak_model"])
	elseif sapling == "moretrees:palm_sapling" then
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, moretrees["palm_model"])
	elseif sapling == "moretrees:rubber_tree_sapling" then
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, moretrees["rubber_tree_model"])
	elseif sapling == "moretrees:sequoia_sapling" then
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, moretrees["sequoia_model"])
	elseif sapling == "moretrees:spruce_sapling" then
		moretrees.grow_spruce(pos)
	elseif sapling == "moretrees:willow_sapling" then
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, moretrees["willow_model"])
	elseif sapling == "nether:tree_sapling" then
		nether.grow_tree(pos, math.random(1, 4) == 1)
	end
end

local function grow(itemstack, user, pointed_thing)
	local pos = pointed_thing.under

	if pointed_thing.type ~= "node"
	or not pos.x then
		return
	end

	local node = minetest.get_node(pos)
	local random = math.random

	-- Tree
	if minetest.get_item_group(node.name, "sapling") >= 1
	or node.name:find("farming_plus:") and node.name:find("sapling")
	or node.name:find("nether:tree") then
		print(can_grow(pos))
		if can_grow(pos) then
			tree_grow(pos, node)
			itemstack:take_item()
		end

	-- Seed
	elseif node.name:find(":seed") then
		local node = node.name:split(":")
		local seed = node[2]:split("_")
		local after_glow_node1 = node[1]..":"..seed[1].."_1"
		local after_glow_node2 = node[1]..":"..seed[2].."_1"
		if minetest.registered_nodes[after_glow_node1] then
			minetest.set_node(pos, {name=after_glow_node1})
			itemstack:take_item()
		elseif minetest.registered_nodes[after_glow_node2] then
			minetest.set_node(pos, {name=after_glow_node2})
			itemstack:take_item()
		end

	-- Dirt
	elseif node.name == "default:dirt_with_grass" then
		for i = -2, 2 do
		for j = -2, 2 do
			pos = pointed_thing.above
			pos = {x=pos.x+i, y=pos.y, z=pos.z+j}
			local node = minetest.get_node(pos)
			local node2 = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
			if node.name == "air"
			and node2.name == "default:dirt_with_grass" then
				minetest.set_node(pos, {name=plant_tab[random(1, 12)]})
			end
		end
		end
		itemstack:take_item()

	-- Grass and others
	elseif node.name:find("_")
	and node.name:find("%d") then
		local node = node.name:split(":")
		local name = node[2]:split("_")
		local next_node = node[1]..":"..name[1].."_"..name[2]+1
		local last_node = node[1]..":"..name[1]
		if minetest.registered_nodes[next_node] then
			minetest.set_node(pos,{name=next_node})
			itemstack:take_item()
		elseif not minetest.registered_nodes[next_node]
		and minetest.registered_nodes[last_node] then
			minetest.set_node(pos, {name=last_node})
			itemstack:take_item()
		end

	-- Farming Redo
	elseif farming.mod == "redo" then
		if node.name == "farming:beanpole" then
			minetest.set_node(pos, {name="farming:beanpole_1"})
			itemstack:take_item()
		end
	end

	return itemstack
end

minetest.register_craftitem("bonemeal:bonemeal", {
	description = "Bone Meal",
	inventory_image = "bonemeal.png",
	on_use = grow
})

minetest.register_craft({
	output = "bonemeal:bonemeal",
	recipe = {{"dye:white"}}
})

minetest.register_craft({
	output = "dye:white",
	recipe = {{"bonemeal:bonemeal"}}
})

if minetest.get_modpath("charcoal") then
	minetest.register_craftitem("bonemeal:ash", {
		description = "Ash",
		inventory_image = "bonemeal_ash.png",
		on_use = grow
	})

	minetest.register_craft({
		output = "bonemeal:ash",
		recipe = {{"charcoal:charcoal"}}
	})
end
