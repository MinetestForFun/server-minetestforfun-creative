local SPAWN_INTERVAL = 5*60


minetest.register_chatcommand("spawn", {
	description = "Teleport a player to the defined spawnpoint",
	func = function(name)
	   local player = minetest.get_player_by_name(name)
	   if minetest.get_modpath("nether") and table.icontains(nether.players_in_nether, name) then
	      if nether.spawn_point then
		 player:setpos(nether.spawn_point)
	      else
		 player:setpos(nether.get_player_died_target)
	      end
	   elseif minetest.setting_get_pos("static_spawnpoint") then
	      minetest.chat_send_player(player:get_player_name(), "Teleporting to spawn...")
	      player:setpos(minetest.setting_get_pos("static_spawnpoint"))
	      return true
	   else
	      minetest.chat_send_player(player:get_player_name(), "ERROR: No spawn point is set on this server!")
	      return false
	   end
	end
})
