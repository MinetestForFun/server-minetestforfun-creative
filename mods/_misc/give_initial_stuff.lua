minetest.register_on_newplayer(function(player)
	print("Un nouveau joueur vient de nous rejoindre !")
	if minetest.setting_getbool("give_initial_stuff") then
		minetest.log("action", "Giving initial stuff to player "..player:get_player_name())
		player:get_inventory():add_item('main', 'default:cobble 99')
		player:get_inventory():add_item('main', 'colored_steel:block_blue 99')
		player:get_inventory():add_item('main', 'default:torch 99')
		player:get_inventory():add_item('main', 'default:cherry_plank 99')
		player:get_inventory():add_item('main', 'bakedclay:magenta 99')
		player:get_inventory():add_item('main', 'moreblocks:all_faces_tree 99')
	end
end)
