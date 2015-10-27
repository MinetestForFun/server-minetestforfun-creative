-- Mega_builder privilege
minetest.register_privilege("megabuilder","Can protect an infinite amount of areas.")

function areas:player_exists(name)
	return minetest.auth_table[name] ~= nil
end

-- Save the areas table to a file
function areas:save()
	local datastr = minetest.serialize(self.areas)
	if not datastr then
		minetest.log("error", "[areas] Failed to serialize area data!")
		return
	end
	local file, err = io.open(self.config.filename, "w")
	if err then
		return err
	end
	file:write(datastr)
	file:close()
end

local function populateStore(self)
	if not rawget(_G, "AreaStore") then
		return
	end
	local store = AreaStore()
	local store_ids = {}
	store:reserve(#self.areas)
	for id, area in pairs(areas.areas) do
		local sid = store:insert_area(area.pos1,
			area.pos2, tostring(id))
		assert(sid ~= nil) -- if its nil, no id could be found
		store_ids[id] = sid
	end
	self.store = store
	self.store_ids = store_ids
end

-- Load the areas table from the save file
function areas:load()
	local file, err = io.open(self.config.filename, "r")
	if err then
		self.areas = self.areas or {}
		return err
	end
	self.areas = minetest.deserialize(file:read("*a"))
	if type(self.areas) ~= "table" then
		self.areas = {}
	end
	populateStore(self)
	file:close()
end

-- Finds the first usable index in a table
-- Eg: {[1]=false,[4]=true} -> 2
local function findFirstUnusedIndex(t)
	local i = 0
	repeat i = i + 1
	until t[i] == nil
	return i
end

-- Add a area, returning the new area's id.
function areas:add(owner, name, pos1, pos2, parent)
	local id = findFirstUnusedIndex(self.areas)
	self.areas[id] = {name=name, pos1=pos1, pos2=pos2, owner=owner,
			parent=parent}
	-- add to AreaStore
	if self.store then
		local sid = self.store:insert_area(pos1, pos2, dump(id))
		assert(sid ~= nil) -- if its nil, no id could be found
		self.store_ids[id] = sid
	end
	return id
end

-- Remove a area, and optionally it's children recursively.
-- If a area is deleted non-recursively the children will
-- have the removed area's parent as their new parent.
function areas:remove(id, recurse)
	if recurse then
		-- Recursively find child entries and remove them
		local cids = self:getChildren(id)
		for _, cid in pairs(cids) do
			self:remove(cid, true)
		end
	else
		-- Update parents
		local parent = self.areas[id].parent
		local children = self:getChildren(id)
		for _, cid in pairs(children) do
			-- The subarea parent will be niled out if the
			-- removed area does not have a parent
			self.areas[cid].parent = parent

		end
	end

	-- Remove main entry
	self.areas[id] = nil

	-- remove from AreaStore
	if self.store then
		local sid = self.store_ids[id]
		self.store_ids[id] = nil
		self.store:remove_area(sid)
	end
end

-- Checks if a area between two points is entirely contained by another area
function areas:isSubarea(pos1, pos2, id)
	local area = self.areas[id]
	if not area then
		return false
	end
	local p1, p2 = area.pos1, area.pos2
	if (pos1.x >= p1.x and pos1.x <= p2.x) and
	   (pos2.x >= p1.x and pos2.x <= p2.x) and
	   (pos1.y >= p1.y and pos1.y <= p2.y) and
	   (pos2.y >= p1.y and pos2.y <= p2.y) and
	   (pos1.z >= p1.z and pos1.z <= p2.z) and
	   (pos2.z >= p1.z and pos2.z <= p2.z) then
		return true
	end
end

-- Returns a table (list) of children of an area given it's identifier
function areas:getChildren(id)
	local children = {}
	for cid, area in pairs(self.areas) do
		if area.parent and area.parent == id then
			table.insert(children, cid)
		end
	end
	return children
end

-- Checks if the user has sufficient privileges.
-- If the player is not a administrator it also checks
-- if the area intersects other areas that they do not own.
-- Also checks the size of the area and if the user already
-- has more than max_areas.
function areas:canPlayerAddArea(pos1, pos2, name)
	local privs = minetest.get_player_privs(name)
	if privs.areas then
		return true
	end

	-- Check self protection privilege, if it is enabled,
	if not self.config.self_protection or
			not privs[areas.config.self_protection_privilege] then
		return false, "Self protection is disabled or you do not have"
				.." the necessary privilege."
	end

	-- MFF: megabuilders skip checks on size and number of areas.
	if not privs["megabuilder"] then
		-- Check size
		local max_size = privs.areas_high_limit and
				self.config.self_protection_max_size_high or
				self.config.self_protection_max_size
		if
				(pos2.x - pos1.x) > max_size.x or
				(pos2.y - pos1.y) > max_size.y or
				(pos2.z - pos1.z) > max_size.z then
			return false, "Area is too big."
		end

		-- Check number of areas the user has and make sure it not above the max
		local count = 0
		for _, area in pairs(self.areas) do
			if area.owner == name then
				count = count + 1
			end
		end
		local max_areas = privs.areas_high_limit and
				self.config.self_protection_max_areas_high or
				self.config.self_protection_max_areas
		if count >= max_areas then
			return false, "You have reached the maximum amount of"
					.." areas that you are allowed to  protect."
		end
	end

	-- Check intersecting areas
	local can, id = self:canInteractInArea(pos1, pos2, name)
	if not can then
		local area = self.areas[id]
		return false, ("The area intersects with %s [%u] (%s).")
				:format(area.name, id, area.owner)
	end

	return true
end

-- Given a id returns a string in the format:
-- "name [id]: owner (x1, y1, z1) (x2, y2, z2) -> children"
function areas:toString(id)
	local area = self.areas[id]
	local message = ("%s [%d]: %s %s %s"):format(
		area.name, id, area.owner,
		minetest.pos_to_string(area.pos1),
		minetest.pos_to_string(area.pos2))

	local children = areas:getChildren(id)
	if #children > 0 then
		message = message.." -> "..table.concat(children, ", ")
	end
	return message
end

-- Re-order areas in table by their identifiers
function areas:sort()
	local sa = {}
	for k, area in pairs(self.areas) do
		if not area.parent then
			table.insert(sa, area)
			local newid = #sa
			for _, subarea in pairs(self.areas) do
				if subarea.parent == k then
					subarea.parent = newid
					table.insert(sa, subarea)
				end
			end
		end
	end
	self.areas = sa
end

-- Checks if a player owns an area or a parent of it
function areas:isAreaOwner(id, name)
	local cur = self.areas[id]
	if cur and minetest.check_player_privs(name, self.adminPrivs) then
		return true
	end
	while cur do
		if cur.owner == name then
			return true
		elseif cur.parent then
			cur = self.areas[cur.parent]
		else
			return false
		end
	end
	return false
end

