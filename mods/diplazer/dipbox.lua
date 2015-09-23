local diaplzer_loadbox=0

local function diplazer_box(user,item,name,mode,pos)

	local drops=1
	local admin=-1
	local meta={}
	local com
	mode=tonumber(mode)
	item=item:to_table()
	local tellmode=mode

	if name:find(":comc",1)~=nil then
	drops=1
	admin=-1
	com=3
	elseif name:find(":comg",1)~=nil then
	drops=1
	admin=-1
	com=2
	elseif name:find(":com",1)~=nil then
	drops=1
	admin=-1
	com=1
	elseif name:find(":gun",1)~=nil then
	drops=1
	admin=0
	elseif name:find(":adminno",1)~=nil then
	drops=0
	admin=1
	elseif name:find(":admin",1)~=nil then
	drops=1
	admin=1
	end


if minetest.check_player_privs(user, {diplazer_gun=true})==false and admin==0 then
minetest.chat_send_player(user, "You need diplazer_gun priv to use this tool")
print(user .. " tried to use diplazer:gun - missing priv: diplazer_gun")
return {access=false}
end

if minetest.check_player_privs(user, {diplazer_admin=true})==false and admin==1 then
minetest.chat_send_player(user, "You need diplazer_admin priv to use this tool")
print(user .. " tried to use diplazer:admin - missing priv: diplazer_admin")
return {access=false}
end


	if diplazer_Enable_com_mode8==false and admin==-1 then
	if mode==8 and admin==-1 then mode=9 end
	end


	have_1112access(user,1)

	if mode>=13 and admin==-1 then mode=12 end
	if mode<=0 and admin==-1 then mode=1 end
	if mode==8 and admin==-1 and diplazer_Enable_mode8==false then mode=9 end
	if mode>=13 then mode=12 end
	if mode<=0 then mode=1 end


	if mode==11 and admin==-1 and diplazer_Enable_com_mode11==false then mode=1 minetest.chat_send_player(user,"Mode 11 is inactived for this tool") end
	if mode==12 and admin==-1 and diplazer_Enable_com_mode12==false then mode=2 minetest.chat_send_player(user,"Mode 12 is inactived for this tool") end
	if mode==11 and admin>=0 and diplazer_Enable_mode11==false then mode=1 minetest.chat_send_player(user,"Mode 11 is inactived for this tool") end
	if mode==12 and admin>=0 and diplazer_Enable_mode12==false then mode=2 minetest.chat_send_player(user,"Mode 12 is inactived for this tool") end


	meta["mode"]=mode
	mode=(meta["mode"])

	if admin>-1 then

	if admin==0 then
		item["name"]="diplazer:gun"..mode
	elseif drops==1 then
		item["name"]="diplazer:admin"..mode
	elseif drops==0 then
		item["name"]="diplazer:adminno"..mode
	end
	else
	if com==1 then item["name"]="diplazer:com"..mode end
	if com==2 then item["name"]="diplazer:comg"..mode end
	if com==3 then item["name"]="diplazer:comc"..mode end
	end

	meta["mode"]=mode
	item["metadata"]=minetest.serialize(meta)

	diplazer_T(user,tellmode,user,admin)
	minetest.sound_play("diplazer_mode" , {pos = pos, gain = 2.0, max_hear_distance = 5,})

	return {access=true,item=item}


	end






minetest.register_abm({
	nodenames = {"diplazer:box"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)

		if diaplzer_loadbox==0 then return 0 end
		diaplzer_loadbox=0
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		local item=inv:get_stack("dipinv", 1)
		local name=item:get_name()
		local mode=meta:get_string("setmode")
		local repair=meta:get_string("rep")

		if repair=="1" and inv:get_stack("diprep", 1):is_empty()==false and inv:get_stack("dipinv", 1):is_empty()==false then
		if item:get_wear()>0 then


		if inv:get_stack("diprep", 1):get_name()=="default:mese_crystal" then
			item:set_wear(0)
			inv:remove_item("diprep","default:mese_crystal 1")
		end
		if inv:get_stack("diprep", 1):get_name()=="default:mese_crystal_fragment" then
			local wer=item:get_wear()-(65535/9)
			if wer<0 then wer=0 end
			item:set_wear(wer)
			inv:remove_item("diprep","default:mese_crystal_fragment 1")
		end

		inv:remove_item("diprep","default:mese_crystal 1")
		inv:set_stack("dipinv", 1,item)

		end
		return 0
		end

		if repair=="1" then
		meta:set_string("rep","0")
		return 0
		end 

		

		if (item:is_empty()) or mode==0 then return false end

		local user=meta:get_string("owner")
		local tool=diplazer_box(user,item,name,mode,pos)
		if tool.access==true then
		inv:set_stack("dipinv", 1,tool.item)
		return true
		else
		return false
		end
	end
})







local function diplazer_inv(meta,placer,pos,tt)
local fmeta = minetest.get_meta(pos)
fmeta:set_string("formspec",
	"size[8,9]" ..
	"list[context;dipinv;2,1;1,1;]" ..
	"list[context;diprep;2,2.5;1,1;]" ..
	"button[1.8,3.5; 1.5,1;dip_rep;Load]" ..
	"button[0,0; 1.5,1;dip_hlp;Help]" ..
	"list[context;main;0,0;8,4;]" ..
	"list[current_player;main;0,5;8,4;]" ..
	"button[5,0; 1.5,1;dip_cm1;Mode 1]" ..
	"button[6.5,0; 1.5,1;dip_cm2;Mode 2]" ..
	"button[5,1; 1.5,1;dip_cm3;Mode 3]" ..
	"button[6.5,1; 1.5,1;dip_cm4;Mode 4]" ..
	"button[5,2; 1.5,1;dip_cm5;Mode 5]" ..
	"button[6.5,2; 1.5,1;dip_cm6;Mode 6]" ..
	"button[5,3; 1.5,1;dip_cm7;Mode 7]" ..
	"button[6.5,3; 1.5,1;dip_cm8;Mode 8]" ..
	"button[5,4; 1.5,1;dip_cm9;Mode 9]" ..
	"button[6.5,4; 1.5,1;dip_cm10;Mode 10]" ..
	"button[3.5,0; 1.5,1;dip_cm11;Mode 11]" ..
	"button[3.5,1; 1.5,1;dip_cm12;Mode 12]")
	fmeta:set_string("infotext", "Diplazer switcher (owned by: " .. placer:get_player_name() .. ")")
if tt==1 then
fmeta:set_string("infotext", "Diplazer switcher")
end

end


minetest.register_node("diplazer:box", {
	description = "Diplazer box",
	tiles = {
	"default_steel_block.png^diplazer_boxtop.png",
	"default_steel_block.png",
	"default_steel_block.png^diplazer_boxside.png",
	"default_steel_block.png^diplazer_boxside.png",
	"default_steel_block.png^diplazer_boxside.png",
	"default_steel_block.png^diplazer_boxpanel.png",},
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds=default.node_sound_stone_defaults(),
after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("rep", "0")
		meta:set_int("state", 0)
		diplazer_inv(meta,placer,pos,0)
		end,
on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("dipinv", 1)
		inv:set_size("diprep", 1)
		meta:set_string("setmode", "0")
		end,
allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta=minetest.get_meta(pos)
		local name=stack:get_name()
		if player:get_player_name()~=meta:get_string("owner") then
		return 0
		end
		if listname=="dipinv" and name:find("diplazer:orb")==nil and name:find("diplazer:box")==nil and name:find("diplazer:")~=nil then
		return 1
		end
		if listname=="diprep" and  (name=="default:mese_crystal" or name=="default:mese_crystal_fragment") then
		return stack:get_count()
		end
		return 0
		end,
allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
		return 0
		end
		return stack:get_count()
		end,
can_dig = function(pos, player)
		local meta=minetest.get_meta(pos)
		local inv=meta:get_inventory()
		if player:get_player_name() ~= meta:get_string("owner") then
		return false
		end
		return inv:get_stack("dipinv", 1):is_empty() and inv:get_stack("diprep", 1):is_empty()
		end,
allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return 0
		end,
on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		if sender:get_player_name() ~= meta:get_string("owner") then
		return false
		end
		if fields.dip_rep then meta:set_string("rep", "1") diaplzer_loadbox=1 end
		if fields.dip_cm1 then meta:set_string("setmode", "1") diaplzer_loadbox=1 end
		if fields.dip_cm2 then meta:set_string("setmode", "2") diaplzer_loadbox=1 end
		if fields.dip_cm3 then meta:set_string("setmode", "3") diaplzer_loadbox=1 end
		if fields.dip_cm4 then meta:set_string("setmode", "4") diaplzer_loadbox=1 end
		if fields.dip_cm5 then meta:set_string("setmode", "5") diaplzer_loadbox=1 end
		if fields.dip_cm6 then meta:set_string("setmode", "6") diaplzer_loadbox=1 end
		if fields.dip_cm7 then meta:set_string("setmode", "7") diaplzer_loadbox=1 end
		if fields.dip_cm8 then meta:set_string("setmode", "8") diaplzer_loadbox=1 end
		if fields.dip_cm9 then meta:set_string("setmode", "9") diaplzer_loadbox=1 end
		if fields.dip_cm10 then meta:set_string("setmode", "10") diaplzer_loadbox=1 end
		if fields.dip_cm11 then meta:set_string("setmode", "11") diaplzer_loadbox=1 end
		if fields.dip_cm12 then meta:set_string("setmode", "12") diaplzer_loadbox=1 end


		if fields.dip_hlp then
		minetest.chat_send_player(sender:get_player_name(), "Place a blockstack left of the tool to place or dig with . (The amount of stack sets how many to place / dig [itmes works too if you will dig]) (insert mese crystal or framgents to load the tool)")
		end
end,
})

minetest.register_craft({
	output = "diplazer:box",
	recipe = {
		{"default:mese_crystal", "default:cobble", "default:steel_ingot"},
	}
})