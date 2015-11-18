minetest.register_tool("diplazer:grav", {
	description = "Gravity manipuler",
	range = 0,
	inventory_image = "diplazer_grav.png",
	on_use = function(itemstack, user, pointed_thing)
		local grav=user:get_physics_override().gravity

		if grav==diplazer_restore_gravity_to then
			user:set_physics_override({gravity=diplazer_gravity_to_use,})
			minetest.sound_play("diplazer_gravon" , {pos = user:getpos(), gain = 2.0, max_hear_distance = 5,})
		else
			user:set_physics_override({gravity=diplazer_restore_gravity_to,})
			minetest.sound_play("diplazer_gravoff" , {pos = user:getpos(), gain = 2.0, max_hear_distance = 5,})
		end

		return itemstack
	end,
})

minetest.register_craft({
	output = "diplazer:grav",
	recipe = {
		{"default:sand", "default:sand", "default:sand"},
		{"default:mese_crystal", "default:mese", "default:mese_crystal"},
		{"default:sand", "default:sand", "default:sand"},
	},
})
