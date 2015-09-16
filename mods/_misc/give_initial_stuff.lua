minetest.register_on_newplayer(function(player)
	print("Un nouveau joueur vient de nous rejoindre !")
	if minetest.setting_getbool("give_initial_stuff") then
		minetest.log("action", "Giving initial stuff to player "..player:get_player_name())
		player:get_inventory():add_item('main', 'default:cobble 20')
		player:get_inventory():add_item('main', 'default:tree 20')
		player:get_inventory():add_item('main', 'default:torch 10')
		player:get_inventory():add_item('main', 'default:sapling 5')
	end
end)

