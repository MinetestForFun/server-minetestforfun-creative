--------------------
-- Liquid security
--

local timers = {}

file = io.open(minetest.get_worldpath() .. "/liquid_security.dat", "r")
if file then
	timers = minetest.deserialize(file:read()) or {}
end

minetest.register_on_newplayer(function(player)
	timers[player:get_player_name()] = 0
end)

local function override_liquid_use(name)
	local old_place = minetest.registered_items[name].on_place

	minetest.after(1, function()
		minetest.override_item(name, {
			on_place = function(itemstack, user, pointed_thing)
				if not timers[user:get_player_name()] then
					return old_place(itemstack, user, pointed_thing)
				else
					return
				end
			end
		})
	end)
end

override_liquid_use("bucket:bucket_water")
override_liquid_use("bucket:bucket_lava")
override_liquid_use("default:river_water_source")
override_liquid_use("default:water_source")
override_liquid_use("default:lava_source")
override_liquid_use("default:acid_source")
override_liquid_use("default:sand_source")
override_liquid_use("noairblocks:water_sourcex")

function liquid_tick()
	for name, player in pairs(minetest.get_connected_players()) do
		local pname = player:get_player_name()
		if timers[pname] then
			timers[pname] = timers[pname] + 1
			if timers[pname] == 3600 then
				timers[pname] = nil
			end
		end
	end
	minetest.after(1, liquid_tick)
end

liquid_tick()


local function save_liquid(loop)
	file = io.open(minetest.get_worldpath() .. "/liquid_security.dat", "w")
	if file then
		file:write(minetest.serialize(timers))
		file:close()
	end
	if loop then
		minetest.log("action", "[LiquidSecurity] Data saved")
		minetest.after(1200, save_liquid, true)
	end
end

save_liquid(true)
		
minetest.register_on_shutdown(save_liquid)
