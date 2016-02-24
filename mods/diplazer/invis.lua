minetest.register_tool("diplazer:in", {
	description = "In",
	groups = {not_in_creative_inventory=diplazer_hide_stuff},
	inventory_image = "diplazer_in.png",
		on_use = function(itemstack, user, pointed_thing)
		local pos=user:getpos()
		if minetest.check_player_privs(user:get_player_name(), {kick=true})==false then
			minetest.chat_send_player(user:get_player_name(), "You need kick to use this")
			return itemstack
		end
		local en=minetest.add_entity(pos, "diplazer:invis")
		user:set_attach(en, "",pos, pos)
		minetest.after(1,function(en)
			en:set_hp(0)
			en:punch(en, 1, "default:diamond_pick")
		end,en)
		return itemstack
		end,
})
minetest.register_entity("diplazer:invis",{
	hp_max = 1000,
	physical =false,
	weight = 0,
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
	visual = "sprite",
	visual_size = {x=0.01, y=0.01},
	textures = {"diplazer_in.png"}, 
	colors = {}, 
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},
	is_visible = true,
	makes_footstep_sound = false,
	automatic_rotate = false,
})