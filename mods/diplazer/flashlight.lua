minetest.register_craft({
	output = "diplazer:flashlight",
	recipe = {
		{"default:mese_crystal","",""},
		{"","default:steel_ingot", ""},
		{"","","default:steel_ingot"},
	}
})

local diplazer_flashlight={users={},timer=0}

function flashlight(player,slot)
		local name=player:get_player_name()
		for i in pairs(diplazer_flashlight.users) do
			if diplazer_flashlight.users[i].player==nil then
				table.remove(diplazer_flashlight.users,i)
			end
			if diplazer_flashlight.users[i].player:get_player_name()==name then
				table.remove(diplazer_flashlight.users,i)
				return
			end
		end
		table.insert(diplazer_flashlight.users,{player=player,slot=slot,inside=0})
end


minetest.register_globalstep(function(dtime)
	diplazer_flashlight.timer=diplazer_flashlight.timer+dtime
	if diplazer_flashlight.timer>1 then
		diplazer_flashlight.timer=0
		for i in pairs(diplazer_flashlight.users) do
			if diplazer_flashlight.users[i].player==nil or diplazer_flashlight.users[i].player:get_inventory()==nil then
				table.remove(diplazer_flashlight.users,i)
				return
			end
			local name=diplazer_flashlight.users[i].player:get_inventory():get_stack("main", diplazer_flashlight.users[i].slot):get_name()
			local pos=diplazer_flashlight.users[i].player:getpos()
			pos.y=pos.y+1.5
			local n=minetest.get_node(pos).name
			local light=minetest.get_node_light(pos)
			if light==nil then
				table.remove(diplazer_flashlight.users,i)
				return false
			end
			if diplazer_flashlight.users[i].inside>10 or name==nil or name~="diplazer:flashlight" or minetest.get_node_light(pos)>12 then
				table.remove(diplazer_flashlight.users,i)
			elseif n=="air" or n=="diplazer:flht" then
				minetest.set_node(pos, {name="diplazer:flht"})
			elseif n=="default:water_source" or n=="diplazer:flhtw" then
				minetest.set_node(pos, {name="diplazer:flhtw"})
			else
				diplazer_flashlight.users[i].inside=diplazer_flashlight.users[i].inside+1
			end
		end
	end
end)

minetest.register_tool("diplazer:flashlight", {
	description = "Flashlight",
	--range = 4,
	inventory_image = "diplazer_flashlight.png",
	on_use = function(itemstack, user, pointed_thing)
	flashlight(user,user:get_wield_index())
	return itemstack
	end,
})

minetest.register_node("diplazer:flht", {
	description = "Flashlight source",
	tiles = {"default_wood.png",},
	light_source = 12,
	paramtype = "light",
	walkable=false,
	drawtype = "airlike",
	pointable=false,
	buildable_to=true,
	sunlight_propagates = true,
	groups = {not_in_creative_inventory=1},
	on_construct=function(pos)
		minetest.env:get_node_timer(pos):start(1.5)
	end,
	on_timer = function (pos, elapsed)
		minetest.set_node(pos, {name="air"})
	end,
})


minetest.register_node("diplazer:flhtw", {
	description = "Water light",
	drawtype = "liquid",
	tiles = {"default_water.png"},
	alpha = 160,
	light_source = 12,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	drop = "",
	liquid_viscosity = 1,
	liquidtype = "source",
	liquid_alternative_flowing="diplazer:flhtw",
	liquid_alternative_source="diplazer:flhtw",
	liquid_renewable = false,
	liquid_range = 0,
	drowning = 1,
	sunlight_propagates = true,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1},
	on_construct=function(pos)
		minetest.env:get_node_timer(pos):start(1.5)
	end,
	on_timer = function (pos, elapsed)
		minetest.set_node(pos, {name="air"})
	end,
})