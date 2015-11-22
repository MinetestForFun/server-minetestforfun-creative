
minetest.register_tool("diplazer:pick", {
	description ="Diplazer pick",
	range = 10,
	inventory_image = "diplazer_pick.png",
	groups = {not_in_creative_inventory = 0},
	tool_capabilities = {
		full_punch_interval = 0.35,
		max_drop_level = 3,
		groupcaps = {
			fleshy={times={[1]=0,[2]=0,[3]=0},uses=40,maxlevel=3},
			choppy={times={[1]=0,[2]=0,[3]=0},uses=100,maxlevel=3},
			bendy={times={[1]=0,[2]=0,[3]=0},uses=100,maxlevel=3},
			cracky={times={[1]=0,[2]=0,[3]=0},uses=100,maxlevel=3},
			crumbly={times={[1]=0,[2]=0,[3]=0},uses=100,maxlevel=3},
			snappy={times={[1]=0,[2]=0,[3]=0},uses=0,maxlevel=3},
		},
		damage_groups={fleshy=8},
	},
})

minetest.register_tool("diplazer:adpick", {
	description ="Diplazer ad pick",
	range = 15,
	inventory_image = "diplazer_adpick.png",
	groups = {not_in_creative_inventory = 1},
	tool_capabilities = {
		full_punch_interval = 0.20,
		max_drop_level = 3,
		groupcaps = {
			unbreakable={times={[1]=0,[2]=0,[3]=0},uses=0,maxlevel=3},
			fleshy={times={[1]=0,[2]=0,[3]=0},uses=0,maxlevel=3},
			choppy={times={[1]=0,[2]=0,[3]=0},uses=0,maxlevel=3},
			bendy={times={[1]=0,[2]=0,[3]=0},uses=0,maxlevel=3},
			cracky={times={[1]=0,[2]=0,[3]=0},uses=0,maxlevel=3},
			crumbly={times={[1]=0,[2]=0,[3]=0},uses=0,maxlevel=3},
			snappy={times={[1]=0,[2]=0,[3]=0},uses=0,maxlevel=3},
		},
		damage_groups={fleshy=9000},
	},
})


minetest.register_node("diplazer:chip", {
	description = "Chip block",
	tiles = {"diplazer_shield.png",},
	light_source = 50,
	paramtype = "light",
	use_texture_alpha = true,
	sunlight_propagates = false,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds=default.node_sound_stone_defaults(),
})


minetest.register_tool("diplazer:armholder", {
	description = "Plazmashield",
	range = 4,
	inventory_image = "diplazer_shield_armholder.png",
		on_use = function(itemstack, user, pointed_thing)
		plazmashield_tmp={user=user:get_player_name()}
		local p=user:getpos()
		local dir = user:get_look_dir()
		p={x=p.x, y=p.y+1, z=p.z}
		local m=minetest.env:add_entity(p, "diplazer:shield")
		return itemstack
		end,
})

minetest.register_entity("diplazer:shield", 
{
	hp_max = 40,
	physical =true,
	weight = 0,
	collisionbox = {-0.5,-1.0,-0.5,0.5,1,0.5,},
	visual = "cube",
	visual_size = {x=1, y=2},
	textures = {"diplazer_shield.png","diplazer_shield.png","diplazer_shield2.png","diplazer_shield2.png","diplazer_shield2.png","diplazer_shield2.png"},
	colors = {},
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},
	is_visible = true,
	makes_footstep_sound = false,
	automatic_rotate = true,
	alpha=10,
	timer=5,
on_step = function(self, dtime)
	self.timer=self.timer-dtime
	if self.timer<0 then self.object:remove() return false end
	return self
	end,
})


minetest.register_craft({
	output = "diplazer:chip",
	recipe = {
		{"default:diamond", "diplazer:box", ""},
	}
})

minetest.register_craft({
	output = "diplazer:adpick",
	recipe = {
		{"diplazer:adpick", "", ""},
	}
})


minetest.register_craft({
	output = "diplazer:pick",
	recipe = {
		{"diplazer:chip", "diplazer:chip", "diplazer:chip"},
		{"", "default:steel_ingot", ""},
		{"", "default:steel_ingot", ""},
	}
})
minetest.register_craft({
	output = "diplazer:armholder",
	recipe = {
		{"", "default:steel_ingot", ""},
		{"default:mese_crystal", "diplazer:box", "default:steel_ingot"},
		{"", "default:steel_ingot", ""},
	}
})