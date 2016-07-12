function register_ghost(name)
	minetest.register_alias("mobs:" .. name, "default:apple")
end

function register_dummy(name)
	minetest.register_entity("mobs:" .. name, {
		on_activate = function(self)
			minetest.log("info", "Mob " .. name .. " removed at " .. minetest.pos_to_string(self.object:getpos()))
			self.object:remove()
		end,
	})

	register_ghost(name)
end


local all_colours = {
	"grey", "black", "red", "yellow", "green", "cyan", "blue", "magenta",
	"white", "orange", "violet", "brown", "pink", "dark_grey", "dark_green"
}

for _, col in pairs(all_colours) do
	register_dummy("sheep_" .. col, {mob=1, egg=1})
end

register_dummy("bee")
register_ghost("beehive")
register_ghost("honey")
register_ghost("honey_block")



register_dummy("chicken")
register_ghost("egg")
register_ghost("chicken_egg_fried")
register_ghost("chicken_raw")
register_ghost("chicken_cooked")

register_dummy("bunny")

register_dummy("cow")
register_ghost("leather")
register_ghost("bucket_milk")
register_ghost("cheese")
register_ghost("cheeseblock")
register_ghost("dung")

register_ghost("meat_raw")
register_ghost("meat")
register_ghost("magic_lasso")
register_ghost("net")
register_ghost("shears")

register_dummy("rat")
register_ghost("rat_cooked")

register_dummy("pig")
register_ghost("pork_raw")
register_ghost("pork_cooked")

register_dummy("kitten")

register_dummy("goat")

register_dummy("dog")

register_dummy("pumpking")
register_dummy("pumpboom")
register_ghost("pumpking_spawner")
register_ghost("pumpboom_spawner")

register_dummy("ent")
register_ghost("ent_spawner")
register_ghost("tree_monster_spawner")

register_dummy("npc")

register_dummy("npc_female")

minetest.log("action", "[MOD] Mobs Legacy loaded")
