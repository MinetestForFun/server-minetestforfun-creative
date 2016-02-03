
-- Npc by TenPlus1

mobs.npc_drops = { 	"farming:meat", "farming:donut", "farming:bread", "default:apple", "default:sapling", "default:junglesapling",
					"shields:shield_enhanced_wood", "3d_armor:chestplate_cactus", "3d_armor:boots_bronze",
					"default:sword_steel", "default:pick_steel", "default:shovel_steel", "default:bronze_ingot",
					"bucket:bucket_water", "default:stick", "cavestuff:pebble_1", "building_blocks:stick",
					"default:cobble", "default:gravel", "default:clay_lump", "default:sand", "default:dirt_with_grass",
					"default:dirt", "default:chest", "default:torch"}

mobs.npc_max_hp = 20

mobs:register_mob("mobs:npc_female", {
	-- animal, monster, npc
	type = "npc",
	-- aggressive, deals 6 damage to player/monster when hit
	passive = false,
	group_attack = true,
	damage = 5,					-- 3 damages if tamed
	attack_type = "dogfight",
	attacks_monsters = true,
	-- health & armor
	hp_min = 20, hp_max = 20, armor = 100,
	-- textures and model
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "character.b3d",
	drawtype = "front",
	textures = {
		{"mobs_npc_female.png"}, -- female by nuttmeg20
	},
	child_texture = {
		{"mobs_npc_baby.png"}, -- derpy baby by AmirDerAssassine
	},
	-- sounds
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_fnpc", 				-- 2 sounds
		damage = "mobs_fnpc_hit", 		-- 2 sounds
		attack = "mobs_fnpc_attack",	-- 1 sound
		death = "mobs_fnpc_death",		-- 1 sound
	},
	-- speed and jump
	walk_velocity = 3,
	run_velocity = 3,
	jump = true,
	-- drops wood and chance of apples when dead
	drops = {
		{name = "default:wood",
		chance = 1, min = 1, max = 3},
		{name = "default:apple",
		chance = 2, min = 1, max = 2},
		{name = "flowers:tulip",
		chance = 4, min = 1, max = 2},
		{name = "flowers:rose",
		chance = 4, min = 1, max = 2},
		{name = "default:axe_stone",
		chance = 6, min = 1, max = 1},
--		{name = "maptools:silver_coin",
--		chance = 10, min = 1, max = 1,},
	},
	-- damaged by
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
	-- follow diamond
	follow = {"farming:bread", "mobs:meat", "default:diamond"},
	view_range = 16,
	-- set owner and order
	owner = "",
	order = "follow",
	fear_height = 3,
	-- model animation
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219,
	},
	-- right clicking with "cooked meat" or "bread" will give npc more health
	on_rightclick = function(self, clicker)

		local item = clicker:get_wielded_item()
		local name = clicker:get_player_name()
		if item:get_name() == "default:diamond" then --/MFF (Crabman|07/14/2015) tamed with diamond
			if (self.diamond_count or 0) < 4 then
				self.diamond_count = (self.diamond_count or 0) + 1
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				if self.diamond_count >= 4 then
					self.damages = 3
					self.tamed = true
					self.owner = clicker:get_player_name()
				end
			end
			return
		-- feed to heal npc
		elseif not mobs:feed_tame(self, clicker, 8, true, true) then
			-- right clicking with gold lump drops random item from mobs.npc_drops
			if item:get_name() == "default:gold_lump" then
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				local pos = self.object:getpos()
				pos.y = pos.y + 0.5
				minetest.add_item(pos, {
					name = mobs.npc_drops[math.random(1, #mobs.npc_drops)]
				})
				return
			-- if owner switch between follow and stand
			elseif self.owner and self.owner == clicker:get_player_name() then
				if self.order == "follow" then
					self.order = "stand"
				else
					self.order = "follow"
				end
			end
			mobs:capture_mob(self, clicker, 0, 5, 80, false, nil)
		end
	end,
})

-- spawning enable for now
mobs:spawn_specific("mobs:npc_female", {"default:dirt_with_grass", "default:dirt", "default:junglegrass", "default:sand"}, {"air"}, -1, 20, 30, 300000, 1, -31000, 31000, true)
-- register spawn egg
mobs:register_egg("mobs:npc_female", "Npc", "mobs_npc_female_inv.png", 1)
