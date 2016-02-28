
--plants to place in openfarming
local plants = { ["farming:blueberries"]=1, ["farming:carrot"]=1, ["farming:coffee_beans"]=1, ["farming:corn"]=1, ["farming:cucumber"]=1,
				 ["farming:melon_slice"]=1, ["farming:potato"]=1, ["farming:pumpkin_slice"]=1, ["farming:raspberries"]=1, ["farming:rhubarb"]=1,
				 ["farming:tomato"]=1, ["farming:seed_cotton"]=1, ["farming:seed_wheat"]=1,["default:papyrus"]=1, ["farming:trellis"]=1,
				 ["farming:grapes"]=1, ["farming:beanpole"]=1, ["farming:beans"]=1,
				}

-- Returns a list of areas that include the provided position
function areas:getAreasAtPos(pos)
	local a = {}
	local px, py, pz = pos.x, pos.y, pos.z
	if self.store then
		local areas = self.store:get_areas_for_pos(pos, false, true)
		for store_id, store_area in pairs(areas) do
			local id = tonumber(store_area.data)
			a[id] = self.areas[id]
		end
	else
		for id, area in pairs(self.areas) do
			local ap1, ap2 = area.pos1, area.pos2
			if px >= ap1.x and px <= ap2.x and
			py >= ap1.y and py <= ap2.y and
			pz >= ap1.z and pz <= ap2.z then
				a[id] = area
			end
		end
	end
	return a
end

function areas:getAreasForArea(pos1, pos2)
	local res = {}
	if self.store then
		local areas = self.store:get_areas_in_area(pos1,
			pos2, true, false, true)
		for store_id, store_area in pairs(areas) do
			local id = tonumber(store_area.data)
			res[id] = self.areas[id]
		end
	else
		for id, area in pairs(self.areas) do
			local p1, p2 = area.pos1, area.pos2
			if (p1.x <= pos2.x and p2.x >= pos1.x) and
					(p1.y <= pos2.y and p2.y >= pos1.y) and
					(p1.z <= pos2.z and p2.z >= pos1.z) then
				-- Found an intersecting area.
				res[id] = area
			end
		end
	end
	return res
end

-- Checks if the area is unprotected or owned by you
function areas:canInteract(pos, name)
	if minetest.check_player_privs(name, self.adminPrivs) then
		return true
	end
	local owned = false
		if pos == nil  then return not owned end -- pour éviter crash avec nénuphar
	for _, area in pairs(self:getAreasAtPos(pos)) do
		if area.owner == name or area.open then
			return true
		elseif area.openfarming then
			-- if area is openfarming
			local node = minetest.get_node(pos).name
			if not minetest.registered_nodes[node] then return false end
			local player = minetest.get_player_by_name(name)
			if not player then return false end
			local wstack = player:get_wielded_item():get_name()
			if wstack == "" then wstack = "hand" end

			--on_dig
			if minetest.get_item_group(node, "plant") == 1 and (wstack == "hand" or minetest.registered_tools[wstack]) then
				return true
			end

			--on_place
			if node == "air" and plants[wstack] ~= nil then
				return true
			end

			owned = true
		else
			owned = true
		end
	end
	return not owned
end

-- Returns a table (list) of all players that own an area
function areas:getNodeOwners(pos)
	local owners = {}
	for _, area in pairs(self:getAreasAtPos(pos)) do
		table.insert(owners, area.owner)
	end
	return owners
end

--- Checks if the area intersects with an area that the player can't interact in.
-- Note that this fails and returns false when the specified area is fully
-- owned by the player, but with multiple protection zones, none of which
-- cover the entire checked area.
-- @param name (optional) player name.  If not specified checks for any intersecting areas.
-- @param allow_open Whether open areas should be counted as is they didn't exist.
-- @return Boolean indicating whether the player can interact in that area.
-- @return Un-owned intersecting area id, if found.
function areas:canInteractInArea(pos1, pos2, name, allow_open)
	if name and minetest.check_player_privs(name, self.adminPrivs) then
		return true
	end
	areas:sortPos(pos1, pos2)

	local areas = self:getAreasForArea(pos1, pos2)
	for id, area in pairs(areas) do
		-- First check for a fully enclosing owned area.
		-- A little optimization: isAreaOwner isn't necessary
		-- here since we're iterating through all relevant areas.
		if area.owner == name and
				self:isSubarea(pos1, pos2, id) then
			return true
		end

		-- Then check for intersecting (non-owned) areas.
		-- Return if the area is closed or open areas aren't
		-- allowed, and the area isn't owned.
		if (not allow_open or not area.open) and
				(not name or not self:isAreaOwner(id, name)) then
			return false, id
		end
	end
	return true
end


function areas:canMakeArea(pos1, pos2, name) --MFF crabman(25/02/2016) fix areas in areas
	if name and minetest.check_player_privs(name, self.adminPrivs) then
		return true
	end
	areas:sortPos(pos1, pos2)

	local id_areas_intersect = {}
	local areas = self:getAreasForArea(pos1, pos2)

	if not areas then return true end

	for id, area in pairs(areas) do
		if area.owner == name and self:isSubarea(pos1, pos2, id) then
			return true
		end
		if not area.open and not self:isAreaOwner(id, name) then
			table.insert(id_areas_intersect, id)
		end
	end

	if #id_areas_intersect > 0 then
		return false, id_areas_intersect[1]
	end

	return true
end


--MFF DEBUT crabman(17/09/2015 ) respawn player in special area(event) if a spawn is set.
--1 party (2 party in beds mod)
local dead_players = {}
minetest.register_on_dieplayer(function(player)
	local player_name = player:get_player_name()
	if not player_name then return end
	local pos = player:getpos()
	if pos then
		dead_players[player_name] = pos
	end
end)


function areas:onRespawn(player)
	local player_name = player:get_player_name()
	if not player_name or not dead_players[player_name] then return false end
	local pos = dead_players[player_name]
	dead_players[player_name] = nil
	if pos then
		for _, area in pairs(areas:getAreasAtPos(pos)) do
			if area.spawn then
				player:setpos(area.spawn)
				return true
			end
		end
	end
	return false
end
--FIN
