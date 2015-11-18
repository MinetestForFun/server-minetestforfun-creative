

local function diplazer_getAmount(player, mode,admin)
	local Name=player:get_inventory():get_stack("main", player:get_wield_index()-1):get_name()
	local is_node=(minetest.registered_nodes[Name] or Name == "air")
	local stack_count=player:get_inventory():get_stack("main", player:get_wield_index()-1):get_count()
	local Node= {name=Name}
	if stack_count>diplazer_amount and admin==0 then stack_count=diplazer_amount
	elseif stack_count>diplazer_amount*2 and admin==1 then stack_count=diplazer_amount*2
	elseif stack_count>diplazer_com_amount and admin==-1 then stack_count=diplazer_com_amount
	end
	if (mode==11 or mode==12) then
		return stack_count
	end
	if (mode==2 or mode==4) then
		return stack_count
	end
	if is_node and (mode==1 or mode==3 or mode==9 ) then
		return stack_count
	else
		return 0
	end
end


function diplazer_T(name,msg,user,admin,box)
	if msg==-1 then
		minetest.chat_send_player(name, "/dihelp ... Use while sneaking / hold shift and left-click / use the switcherbox")
		minetest.chat_send_player(name, "Set a [stack] of blocks [left of the tool], the [amount of stack] sets how many to place/dig")
	elseif msg==-2 then
		minetest.chat_send_player(name, "Use while point a player or mob or item/stack to select, then point a block to teleport it.")
		return 0
	elseif msg==-3 then
		minetest.chat_send_player(name, "This node is protected")
		return 0
	elseif msg==-4 then
		minetest.chat_send_player(name, "Error: stack to right must be big as or bigger than stack to left (L<=R)")
		return 0
	else

		local Mode={}
		Mode[1]="Place front"
		Mode[2]="Dig front"
		Mode[3]="Place up"
		Mode[4]="Dig down"
		Mode[5]="Dig 3x3 nodes"
		Mode[6]="Teleport"
		Mode[7]="Teleport objects"
		Mode[8]="Gravity gun (click to pickup, click it again to drop, right+click to throw it away jump+click to drop single block/stack)"
		Mode[9]="Replace front: stack to left replace with stack to right"
		Mode[10]="AutoSwitch using from all stacks in hotbar from left to right [place dipalzer to right for max use]"
		Mode[11]="Place platform NxN amo"
		Mode[12]="Dig platform NxN amo"
		minetest.chat_send_player(name,"Diplazer Mode" .. msg .. ": ".. Mode[msg])
	end
end

local function diplazer_getLength(a)
	if a==nil then return 0 end
	local count = 0
	for _ in pairs(a) do count = count + 1 end
	return count
end


minetest.register_chatcommand("dihelp", {
	params = "",
	description = "Diplazer Help",
	func = function(name, param)
		minetest.chat_send_player(name, "/dihelp (V" ..diplazer_vesrion ..") ... Use while sneaking / hold shift and left-click / use the switcherbox")
		minetest.chat_send_player(name, "Set a [stack] of blocks [left of the tool], the [amount of stack] sets how many to place/dig")
		minetest.chat_send_player(name, "If someone keep teleporting or wear you, type /di_dropme (for admins /di_dropall)")
		if diplazer_pipeworks==1 then minetest.chat_send_player(name, "dipalzer also works with pipeworks:nodebreaker") end
		return true
	end})




minetest.register_chatcommand("di_1112", {
	params = "",
	description = "Tempoary gives access to diplazer modes 11 & 12 (massive use)",
	func = function(name, param)

	if diplazer_Enable_warning_mode11_12==false then
	minetest.chat_send_player(name, "The access is now always enabled")
	return false
	end

		for i=1,diplazer_getLength(diplazer_1112access),1 do
			if name==diplazer_1112access[i] then
				return true
			end
		end
		minetest.chat_send_player(name, "Temporary access added until you changing mode")
		table.insert(diplazer_1112access,name)
		return true
	end})

minetest.register_chatcommand("di_dropall", {
	params = "",
	description = "Diplazer drop all",
	func = function(name, param)
	if GGunInUse<0 then GGunInUse=0 end

if minetest.check_player_privs(name, {diplazer_admin=true})==false then
minetest.chat_send_player(name, "You need diplazer_admin priv to run this command")
return 0
end
	local player_name=name
	local len=diplazer_getLength(diplazer_Tele)
	local is_using=0
	local rname="?"
	for i=1,len,1 do
		if diplazer_Tele[i] and diplazer_Tele[i]~=false and diplazer_UserTele[i]~=false then
			if diplazer_Tele[i]:is_player()==true then
			minetest.chat_send_player(diplazer_Tele[i]:get_player_name(), "Diplazer: You are droped")
			end
			diplazer_Tele[i]:set_physics_override({gravity=1})
			minetest.chat_send_player(string.sub(diplazer_UserTele[i], 3),"Diplazer: the target are droped!")
			diplazer_UserTele[i]=false
			diplazer_Tele[i]=false
			GGunInUse=GGunInUse-1
		end
	end
minetest.chat_send_player(name, "Diplazer: all targets are cleared")
diplazer_UserTele={}
diplazer_Tele={}
GGunInUse=0
end})

minetest.register_chatcommand("di_dropme", {
	params = "",
	description = "Diplazer drop me",
	func = function(name, param)
	if GGunInUse<0 then GGunInUse=0 end
	local player_name=name
	local len=diplazer_getLength(diplazer_Tele)
	local is_using=0
	local rname="?"
	for i=1,len,1 do
		if diplazer_Tele[i] and diplazer_Tele[i]:is_player()==true and diplazer_UserTele[i]~=false then
			rname=diplazer_Tele[i]:get_player_name()
		end
		if player_name==rname then
			diplazer_Tele[i]:set_physics_override({gravity=1})
			minetest.chat_send_player(rname, "Diplazer: You are droped")
			minetest.chat_send_player(string.sub(diplazer_UserTele[i], 3), "Diplazer: " .. rname .. " are droped!")
			diplazer_UserTele[i]=false
			diplazer_Tele[i]=false
			GGunInUse=GGunInUse-1
		end
	end
end})





function have_1112access(name,remove)

	if diplazer_Enable_warning_mode11_12==false then
	return true
	end


	if remove==1 then
		for i=1,diplazer_getLength(diplazer_1112access),1 do
			if name==diplazer_1112access[i] then
				diplazer_1112access[i]=nil
				return true
			end
		end
		return false
	end

	for i=1,diplazer_getLength(diplazer_1112access),1 do
		if name==diplazer_1112access[i] then
			return true
		end
	end

	minetest.chat_send_player(name, "Type /di_1112 to use this amount of nodes")
	return false
end



--diplazer_1112acess



local function diplazer_USEGgunStackToNodeByNode(pointed_thing,user)
	if pointed_thing==nil then return end
	if not pointed_thing:get_luaentity() then return end
	if not pointed_thing:get_luaentity().itemstring then return 0 end
	local itm=pointed_thing:get_luaentity()
	local i_pos=pointed_thing:getpos()
	if minetest.registered_nodes[itm.itemstring]==nil then return end
	if itm.itemstring:find(" ",1)==nil and minetest.registered_nodes[itm.itemstring] then
		if minetest.get_node(i_pos).name~="air" then return 0 end
		minetest.add_node(i_pos, {name=itm.itemstring})
		pointed_thing:remove()
		minetest.sound_play("diplazer_grabnodedrop", {pos =user:getpos(), gain = 1.0, max_hear_distance = 3,})
		return 1
	end
end

local function diplazer_USEGgunStackToNode(pointed_thing)
	local itm=pointed_thing.ref:get_luaentity()
	local i_pos=minetest.get_pointed_thing_position(pointed_thing)--, above
	if minetest.registered_nodes[itm.itemstring]==nil then return end
	if itm.itemstring:find(" ",1)==nil then
		if minetest.get_node(i_pos).name~="air" then return 0 end
		minetest.add_node(i_pos, {name=itm.itemstring})
		pointed_thing.ref:remove()
		return 1
	end
end


local function diplazer_USEGgunIfObHitClear()
diplazer_USEGgunIfObHit_obj.on=0
diplazer_USEGgunIfObHit_obj.object=0
diplazer_USEGgunIfObHit_obj.count=0
diplazer_USEGgunIfObHit_obj.user=0
diplazer_USEGgunIfObHit_obj.userdir=0
diplazer_USEGgunIfObHit_obj.admin=0
end


local function dpzrnd(a) -- round
return math.floor(a+ 0.5)
end


local function diplazer_USEGgunIfObHit()

	if diplazer_USEGgunIfObHit_obj.userdir==nil then return false end
	if diplazer_USEGgunIfObHit_obj.user==nil then return false end
	local dir=diplazer_USEGgunIfObHit_obj.userdir
	local pos = minetest.get_pointed_thing_position(diplazer_USEGgunIfObHit_obj.object,nil)

	if pos==nil then
	diplazer_USEGgunIfObHitClear()
	return
	end

	local us=diplazer_USEGgunIfObHit_obj.user:getpos()
	local cor=diplazer_USEGgunIfObHit_obj.count
	local obposs=diplazer_USEGgunIfObHit_obj.objectposs -- using with player
	local ggpos=pos.x ..".".. pos.y ..".".. pos.z
	local uspos=us.x .."."..us.y ..".".. us.z
	local obpos=0
	local obposplus=2
	local veloc=40
	local tp2node=minetest.registered_nodes[minetest.get_node({x=pos.x+(dir.x*obposplus), y=pos.y+(dir.y*obposplus), z=pos.z+(dir.z*obposplus)}).name].walkable
	local damage_on_hit=20

	if diplazer_USEGgunIfObHit_obj.admin==-1 then
		diplazer_USEGgunIfObHit_obj.count=diplazer_USEGgunIfObHit_obj.count+3
	end

	if tp2node==false then
		local is_water_or_lava=minetest.get_node({x=pos.x+(dir.x*obposplus), y=pos.y+(dir.y*obposplus), z=pos.z+(dir.z*obposplus)}).name
		if is_water_or_lava=="default:water_source" then
			diplazer_USEGgunIfObHit_obj.count=diplazer_USEGgunIfObHit_obj.count+1
			veloc=veloc-diplazer_USEGgunIfObHit_obj.count
		elseif is_water_or_lava=="default:lava_source" then
			diplazer_USEGgunIfObHit_obj.count=diplazer_USEGgunIfObHit_obj.count+5
			veloc=veloc-diplazer_USEGgunIfObHit_obj.count
		end
	end

	diplazer_USEGgunIfObHit_obj.object.ref:setvelocity({x=dir.x*veloc, y=dir.y*veloc, z=dir.z*veloc})


-- other + player


	if tp2node==true then

		if diplazer_USEGgunIfObHit_obj.object.ref:get_luaentity() and diplazer_USEGgunIfObHit_obj.object.ref:get_luaentity().itemstring then return end
		diplazer_USEGgunIfObHit_obj.object.ref:set_hp(diplazer_USEGgunIfObHit_obj.object.ref:get_hp()-damage_on_hit)
		diplazer_USEGgunIfObHit_obj.object.ref:punch(diplazer_USEGgunIfObHit_obj.user,0,"diplazer:gun",0)
		diplazer_USEGgunIfObHitClear()
		return
	end


	for _,object in ipairs(minetest.get_objects_inside_radius({x=dir.x+pos.x,  y=dir.y+pos.y,  z=dir.z+pos.z}, 1.5)) do
	obpos=object:getpos().x ..".".. object:getpos().y ..".".. object:getpos().z
		if obpos~=ggpos and obpos~=uspos and object.type~="node" then
		local issame=0
		if object:is_player()==true and diplazer_USEGgunIfObHit_obj.object.ref:is_player()==true then
			if object:get_player_name()==diplazer_USEGgunIfObHit_obj.object.ref:get_player_name() then
				issame=1
			end
		end
			if issame==0 then
				object:set_hp(object:get_hp()-20)
				object:punch(diplazer_USEGgunIfObHit_obj.user,0,"diplazer:gun",0)
						if diplazer_USEGgunIfObHit_obj.object.ref:get_luaentity() and diplazer_USEGgunIfObHit_obj.object.ref:get_luaentity().itemstring then return end
				diplazer_USEGgunIfObHit_obj.object.ref:set_hp(diplazer_USEGgunIfObHit_obj.object.ref:get_hp()-damage_on_hit)
				diplazer_USEGgunIfObHit_obj.object.ref:punch(diplazer_USEGgunIfObHit_obj.user,0,"diplazer:gun",0)
				diplazer_USEGgunIfObHitClear()
				return
			end
		end
	end

-- If throw a player (glitch fix)

	if diplazer_USEGgunIfObHit_obj.object.ref:is_player()==true then
	obposplus=1

	if tp2node==true then
		diplazer_USEGgunIfObHit_obj.object.ref:set_hp(diplazer_USEGgunIfObHit_obj.object.ref:get_hp()-damage_on_hit)
		diplazer_USEGgunIfObHit_obj.object.ref:punch(diplazer_USEGgunIfObHit_obj.user,0,"diplazer:gun",0)
		diplazer_USEGgunIfObHitClear()
		return
	end
	diplazer_USEGgunIfObHit_obj.object.ref:moveto({x=obposs.x+(dir.x*cor)*2, y=obposs.y+(dir.y*cor)*2, z=obposs.z+(dir.z*cor)*2},false)
	end

end



local function diplazer_USEGgun(meta,user,pointed_thing,admin)

if pointed_thing==0 or pointed_thing==nil then
for i=1,diplazer_getLength(diplazer_UserTele),1 do
if diplazer_UserTele[i]==meta.mode .."?".. user:get_player_name() then diplazer_Tele[i]=false return false end
end
return false


end





		if meta.mode==8 and pointed_thing.type=="object" and pointed_thing.ref then		-- remove Terget
					local keys = user:get_player_control()
					local player_name=user:get_player_name()
					local len=diplazer_getLength(diplazer_UserTele)
					local is_removed=0
					if len==0 then len=1 end

					for i=1,len,1 do
						if meta.mode .."?".. player_name==diplazer_UserTele[i] and (not diplazer_Tele[i]==false) then
							if pointed_thing.ref==diplazer_Tele[i] then
								if diplazer_Tele[i]:is_player()==true then diplazer_Tele[i]:set_physics_override({gravity=diplazer_restore_gravity_to,}) end
								if pointed_thing.ref:get_luaentity() and pointed_thing.ref:get_luaentity().name == "__builtin:item" and (not keys.RMB) and (not keys.jump) then
									if diplazer_USEGgunStackToNode(pointed_thing)==0 then return false end
								end
								diplazer_Tele[i]=false
								is_removed=1
								minetest.sound_play("diplazer_grabnodedrop", {pos =user:getpos(), gain = 1.0, max_hear_distance = 3,})
								GGunInUse=GGunInUse-1
							end
						end
					end

					if keys.RMB then
						local pos = minetest.get_pointed_thing_position(pointed_thing)
						local udir = user:get_look_dir()
						pointed_thing.ref:setvelocity({x=udir.x*50, y=udir.y*50, z=udir.z*50})
						minetest.sound_play("diplazer_grabnodesend", {pos =user:getpos(), gain = 1.0, max_hear_distance = 3,})
						diplazer_USEGgunIfObHit_obj.object=pointed_thing
						diplazer_USEGgunIfObHit_obj.userdir=udir
						diplazer_USEGgunIfObHit_obj.user=user
						diplazer_USEGgunIfObHit_obj.objectposs=pos
						diplazer_USEGgunIfObHit_obj.admin=admin
						diplazer_USEGgunIfObHit_obj.on=1
-- end of keys.RMB
					return 0
					end
					if is_removed==1 then return 0 end
		end
end


minetest.register_on_leaveplayer(function(player)

	if diplazer_Enable_warning_mode11_12==true then
		have_1112access(player:get_player_name(),1)
		local a1112c=diplazer_getLength(diplazer_1112access)
		local a1112a=0
		for i=1,a1112c,1 do
			if diplazer_1112access[i]~=nil then
				a1112a=a1112a+1
			end
		end
		if a1112a==a1112c then diplazer_1112access={} end
	end

	if GGunInUse<0 then GGunInUse=0 end
	local player_name=player:get_player_name()
	local len=diplazer_getLength(diplazer_UserTele)
	local is_using=0				--Removing from using tp/Ggun
	for i=1,len,1 do
		if ("8?".. player_name==diplazer_UserTele[i]) or ("7?".. player_name==diplazer_UserTele[i]) then
			if not diplazer_Tele[i]==false then
				if diplazer_Tele[i]:is_player()==true then
					diplazer_Tele[i]:set_physics_override({gravity=1})
				end
			end
			diplazer_UserTele[i]=false
			diplazer_Tele[i]=false
			GGunInUse=GGunInUse-1
		end
	end
	for i=1,len,1 do				--If not someone is using tp or GGun
		if diplazer_UserTele[i]==false then
			is_using=is_using+1
		end
	end
	if is_using>=len then			--IF not, clear the array to save CPU
		diplazer_UserTele={}
		diplazer_Tele={}
		diplazer_com_mode8_users={}
		print("diplazer GGun&Tp is cleaned (" ..  is_using .. " " .. len ..")")
		GGunInUse=0
	else
		print("diplazer GGun&Tp is using (" ..  is_using .. " " .. len ..")")

	end
end)



local function diplazer_haveGGun(player)
	if player == nil then
		return false
	end
	local inv = player:get_inventory()
	local hotbar = inv:get_list("main")
	for i = 1, 8 do
		if hotbar[i]:get_name() == "diplazer:com8" or hotbar[i]:get_name() == "diplazer:gun8" or hotbar[i]:get_name() == "diplazer:admin8" or hotbar[i]:get_name() == "diplazer:adminno8" then
			local meta = minetest.deserialize(hotbar[i]:get_metadata())

		if hotbar[i]:get_name() == "diplazer:com8" then
		local name=player:get_player_name()
			for i=1,diplazer_getLength(diplazer_com_mode8_users),1 do
				if name==diplazer_com_mode8_users[i].name then
					if diplazer_com_mode8_users[i].time>0 then
					diplazer_com_mode8_users[i].time=diplazer_com_mode8_users[i].time-0.1
					else
					GGunInUse=GGunInUse-1
					return false
					end
				end
			end
		end



				return true
		end
	end
	return false
end

local function diplazer_haveOrb(orb)
for i, player in pairs(minetest.get_connected_players()) do
	local inv = player:get_inventory()
	local hotbar = inv:get_list("main")
	for i = 1, 8 do

		if hotbar[i]:get_name() == "diplazer:".. orb then
			local meta = minetest.deserialize(hotbar[i]:get_metadata())
				if orb=="orbc" then
					local hp= player:get_hp()+1
					player:set_hp(hp)
				end
				if orb=="orbg" then
					local hp= player:get_hp()+2
					player:set_hp(hp)
				end
				if orb=="orba" then
					local hp= player:get_hp()+20
					player:set_hp(hp)
				end
		end
	end
	return false
end
end



minetest.register_globalstep(function(dtime)

	if diplazer_Enable_orbs==true then
		diplazer_orb.atime=diplazer_orb.atime+1
		diplazer_orb.gtime=diplazer_orb.gtime+1
		diplazer_orb.ctime=diplazer_orb.ctime+1
		if diplazer_orb.atime>=diplazer_orb.admin then	diplazer_orb.atime=0	diplazer_haveOrb("orba") end
		if diplazer_orb.gtime>=diplazer_orb.gun then	diplazer_orb.gtime=0	diplazer_haveOrb("orbg") end
		if diplazer_orb.ctime>=diplazer_orb.com then	diplazer_orb.ctime=0	diplazer_haveOrb("orbc") end
	end

	if diplazer_Enable_mode8==false then return true end

	if diplazer_USEGgunIfObHit_obj.on==1 then
		if diplazer_USEGgunIfObHit_obj.count>=diplazer_USEGgunIfObHit_obj.limedto then
			diplazer_USEGgunIfObHitClear()
		else
			diplazer_USEGgunIfObHit_obj.count=diplazer_USEGgunIfObHit_obj.count+1
			diplazer_USEGgunIfObHit()
		end
	end

	if GGunInUse <= 0 then
		return
	end
	GGunTime = GGunTime + dtime
	if GGunTime < diplazer_UpdateGGun then
		return
	end
	GGunTime = 0
	for i, player in pairs(minetest.get_connected_players()) do
		if diplazer_haveGGun(player)==true then
			local player_name = player:get_player_name()
			local pos = player:getpos()
			local len=diplazer_getLength(diplazer_UserTele)
			for i=1,len,1 do
				if "8?".. player_name==diplazer_UserTele[i] and (not diplazer_Tele[i]==false) then
					if diplazer_Tele[i]:is_player()==true then diplazer_Tele[i]:set_physics_override({gravity=0}) end
					local udir = player:get_look_dir()

					local xzpos=4
					--[[local node=""

					local tp2node1=minetest.registered_nodes[minetest.get_node({x=pos.x+(udir.x*4), y=pos.y+1.5+(udir.y*4), z=pos.z+(udir.z*4)}).name].walkable
					local tp2node2=minetest.registered_nodes[minetest.get_node({x=pos.x+(udir.x*3), y=pos.y+1.5+(udir.y*4), z=pos.z+(udir.z*3)}).name].walkable
					local tp2node3=minetest.registered_nodes[minetest.get_node({x=pos.x+(udir.x*2), y=pos.y+1.5+(udir.y*4), z=pos.z+(udir.z*2)}).name].walkable
					local tp2node4=minetest.registered_nodes[minetest.get_node({x=pos.x+(udir.x*1), y=pos.y+1.5+(udir.y*4), z=pos.z+(udir.z*1)}).name].walkable

					if tp2node==true then xzpos=3 end
					if tp2node==true then xzpos=2 end
					if tp2node==true then xzpos=1 end
					if tp2node==true then xzpos=-1 end--]]
					if not diplazer_Tele[i]:getpos() then
						diplazer_Tele[i]=false
						return false
					end

					--[[
					local wantedpos = {x=pos.x+(udir.x*xzpos), y=pos.y+1.5+(udir.y*4), z=pos.z+(udir.z*xzpos)}
					diplazer_Tele[i]:moveto(wantedpos,false)
					diplazer_Tele[i]:setvelocity({x=0,y=1,z=0})
					diplazer_Tele[i]:setyaw(player:get_look_yaw()+(math.pi*1.5))--]]

					--[[
					x(t) = at²+bt+c
					x'(t) = 2at+b
					x''(t) = 2a

					x(0) = c = pos.x
					x'(0) = b = vel.x

					x(t) = wantedpos.x = at²+vel.xt+pos.x
					a = (wantedpos.x-pos.x-vel.xt)/t²
					]]

					local p = diplazer_Tele[i]:getpos()
					local wantedpos = vector.divide(vector.add({x=pos.x+(udir.x*xzpos), y=pos.y+1.5+(udir.y*4), z=pos.z+(udir.z*xzpos)}, p), 2)

					local t = diplazer_UpdateGGun+0.1
					local acc = {}
					local vel = diplazer_Tele[i]:getvelocity()
					for c,v in pairs(wantedpos) do
						acc[c] =(v-p[c]-vel[c]*t)/(t*t)
					end

					diplazer_Tele[i]:setacceleration(acc)
					diplazer_Tele[i]:setyaw(player:get_look_yaw()+math.pi*1.5)

				end
			end
		else
			local len=diplazer_getLength(diplazer_UserTele)
			local player_name = player:get_player_name()
			for i=1,len,1 do
				if "8?".. player_name==diplazer_UserTele[i] and (not diplazer_Tele[i]==false) then
					if diplazer_Tele[i]:is_player()==true then diplazer_Tele[i]:set_physics_override({gravity=diplazer_restore_gravity_to}) end
					diplazer_Tele[i]=false
					GGunInUse=GGunInUse-1
				end
			end
		end
	end
end)

local function diplazer_is_unbreakable(pos)
	local nodedef

	nodedef = minetest.registered_nodes[minetest.get_node(pos).name]
	if nodedef==nil then return true end

	return nodedef.drop==""
end



local function diplazer_dig(pos,player,drops,admin)
	if minetest.is_protected(pos, player:get_player_name())==true then
	diplazer_T(player:get_player_name(),-3,player,admin)
		return false
	end

	local node=minetest.get_node(pos)
	if node.name == "air" or node.name == "ignore" then return end
	--if minetest.registered_nodes[minetest.get_node(pos).name].walkable ==false then minetest.remove_node(pos) end
	if diplazer_is_unbreakable(pos)==true and admin<0 then return false end

	if drops==1 then
		minetest.node_dig(pos,node,player)
	else
		minetest.set_node(pos, {name="air"})
	end
	end

function diplazer_getdir (player)
	local dir=player:get_look_dir()
	if math.abs(dir.x)>math.abs(dir.z) then
		if dir.x>0 then return 0 end
		return 1
	end
	if dir.z>0 then return 2 end
	return 3
end

local function diplazer_dig2 (pos,player,drops,admin)
	diplazer_dig (pos,player,drops,admin)
	pos.z=pos.z+1
	diplazer_dig (pos,player,drops,admin)
	pos.z=pos.z-2
	diplazer_dig (pos,player,drops,admin)
	pos.z=pos.z+1
	pos.y=pos.y+1
	diplazer_dig (pos,player,drops,admin)
	pos.z=pos.z+1
	diplazer_dig (pos,player,drops,admin)
	pos.z=pos.z-2
	diplazer_dig (pos,player,drops,admin)
	pos.z=pos.z+1
	pos.y=pos.y-2
	diplazer_dig (pos,player,drops,admin)
	pos.z=pos.z+1
	diplazer_dig (pos,player,drops,admin)
	pos.z=pos.z-2
	diplazer_dig (pos,player,drops,admin)
end

local function diplazer_dig3 (pos,player,drops,admin)
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x-2
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	pos.y=pos.y+1
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x-2
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	pos.y=pos.y-2
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x-2
	diplazer_dig (pos,player,drops,admin)
end

local function diplazer_dig4 (pos,player,drops,admin)
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x-2
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	pos.z=pos.z+1
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x-2
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	pos.z=pos.z-2
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x+1
	diplazer_dig (pos,player,drops,admin)
	pos.x=pos.x-2
	diplazer_dig (pos,player,drops,admin)
end


local function diplazer_place(pos, player, stack_count,Name,Node,creative,admin)
	if minetest.is_protected(pos, player:get_player_name())==true then
	diplazer_T(player:get_player_name(),-3,player,admin)
		return false
	end

	if Node.name=="diplazer:box" and admin<1 then return false end

	local fn = minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y, z=pos.z}).name]

	if admin<0 and fn.drop=="" and fn.name:find("maptools:",1)~=nil then return false end

	if fn.walkable==false then

		if stack_count>0 then
			minetest.add_node({x=pos.x, y=pos.y, z=pos.z}, Node)

			if not creative and admin==0 and diplazer_Enable_gun_limitation==true then
				player:get_inventory():remove_item("main", Name)
				return true
			end

			if not creative and admin<0 then
				player:get_inventory():remove_item("main", Name)
			end
			return true
		else
			return false
		end

	else
		return false
	end

end


local function diplazer_replace(pos, player, stack_count,Name,Node,creative,admin,replace,drops)
	if minetest.is_protected(pos, player:get_player_name())==true then
	diplazer_T(player:get_player_name(),-3,player,admin)
		return false
	end
	local fn = minetest.get_node({x=pos.x, y=pos.y, z=pos.z})

	if diplazer_is_unbreakable(pos)==true and admin<0 then stack_count=0 return false end
	if fn.name==Name then
		if stack_count>0 then
		if drops==1 then diplazer_dig(pos,player,drops,admin) end
			if minetest.get_node({x=pos.x, y=pos.y, z=pos.z})
.name=="air" then
				minetest.add_node({x=pos.x, y=pos.y, z=pos.z}, {name=replace})
			elseif admin==1 then
				minetest.add_node({x=pos.x, y=pos.y, z=pos.z}, {name=replace})
			end
			if not creative and admin<1 then player:get_inventory():remove_item("main", replace) end
			return true
		else
			return false
		end

	else
		return true
	end

end

local function diplazer_use(pos, player, meta,admin,drops,keys,com)

	local mode=meta.mode
	local Name=player:get_inventory():get_stack("main", player:get_wield_index()-1):get_name()
	local player_name=player:get_player_name()
	local is_node= not (minetest.registered_nodes[Name] or Name == "air")
	local stack_count=player:get_inventory():get_stack("main", player:get_wield_index()-1):get_count()
	local creative=minetest.setting_getbool("creative_mode")
	local Node= {name=Name}
	local diplazer_amountT=diplazer_amount
	local autousereplace=""
	local autouse=0

	if admin==1 then
		diplazer_amountT=diplazer_amount*2
	elseif admin==-1 then
		diplazer_amountT=diplazer_com_amount
	end

	if com then
		if com==2 then diplazer_amountT=diplazer_amountT+1 end
		if com==3 then diplazer_amountT=diplazer_amountT+3 end
	end


	if keys.RMB then
		if mode==1 or mode==3 or mode==11 then
		mode=mode+1
		end
	end


	if admin==0 then
		if minetest.check_player_privs(player_name, {give=true})==true then
			creative=1
		end
	end

	if diplazer_pipeworks==1 then
		if player.is_fake_player and player.is_fake_player==true then
		if (meta.inv1==nil or meta.invc1==nil or meta.inv2==nil) and mode~=1 then return 0 end
		if mode==2 or mode==4 or mode==5 or mode==9 or mode==12 then pos.y=pos.y+1 end
		if not creative and admin<1 and mode==1 then meta.inv1="default:stick" end
		if not creative and admin<1 and ((mode==1 and meta.inv1~="default:stick") or mode==3 or mode==6 or mode==7 or mode==9 or mode==10 or mode==11) then return 0 end

		Name=meta.inv1
		Node= {name=Name}
		is_node= not (minetest.registered_nodes[Name] or Name == "air")
		stack_count=meta.invc1

		autousereplace=meta.inv2
		local dir = diplazer_getdir(player)
		if dir==0 then pos.x=pos.x+1 end
		if dir==1 then pos.x=pos.x-1 end
		if dir==2 then pos.z=pos.z+1 end
		if dir==3 then pos.z=pos.z+-1 end
		autouse=1
		end
	end

	if mode==2 or mode==4 or mode==5 or mode==12 and drops==1 then
		local Items=0
		for i=1,32,1 do
			if player:get_inventory():get_stack("main", i):get_name()=="" then
				Items=1
				break
			end
		end
		if Items==0 then
			minetest.chat_send_player(player:get_player_name(), "You need at least 1 slot free while digging")
			return false
		end
	end

	if mode == 11 or mode == 12 then
			if is_node and mode==11 then
				return false
			end

			local plus=1
			local minus=-1
			local stack_counts
			local stack_counts_start=stack_count
			local stack_counts_tmp
			local start_pos={x=pos.x,y=pos.y+1,z=pos.z}
			local x=pos.x
			local y=pos.y
			local z=pos.z
			local dir = diplazer_getdir(player)
			local tp2node1=minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y, z=pos.z}).name].walkable
			local tp2node2=minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name].walkable

			pos.y=pos.y+1

if mode==12 then pos.y=pos.y-1 end

if mode==11 and diplazer_amountT>diplazer_mode11_max then diplazer_amountT=diplazer_mode11_max end
if mode==12 and diplazer_amountT>diplazer_mode12_max then diplazer_amountT=diplazer_mode12_max end


if stack_count>=diplazer_warning_mode11_12 and admin~=-1 then
	if have_1112access(player_name,0)==false then
		minetest.sound_play("diplazer_error", {pos = player:getpos(), gain = 1.0, max_hear_distance = 10,})
		return false
	end
end

if mode==11 then
minetest.sound_play("diplazer_massiveplace", {pos = player:getpos(), gain = 1.0, max_hear_distance = 10,})
else
minetest.sound_play("diplazer_massivedig", {pos = player:getpos(), gain = 1.0, max_hear_distance = 10,})
end


				for i=1,diplazer_amountT,1 do
					if mode==11 then

						if diplazer_place(pos, player, stack_count,Name,Node,creative,admin)==true then
							stack_count=stack_count-1
							if dir==0 then pos.x=pos.x+plus end
							if dir==1 then pos.x=pos.x+minus end
							if dir==2 then pos.z=pos.z+plus end
							if dir==3 then pos.z=pos.z+minus end
						else
							break
						end

					else -- if mode 12

						diplazer_dig (pos,player,drops,admin)
						stack_count=stack_count-1
						if dir==0 then pos.x=pos.x+plus end
						if dir==1 then pos.x=pos.x+minus end
						if dir==2 then pos.z=pos.z+plus end
						if dir==3 then pos.z=pos.z+minus end
						if stack_count<=0 then break end
					end
				end

			stack_counts=stack_counts_start-stack_count

			if stack_counts_start>diplazer_amountT then
				stack_counts_start=diplazer_amountT
			end

			if mode==12 then stack_counts=stack_counts_start end

					pos=start_pos
						if dir==0 then pos.x=pos.x-1 end
						if dir==1 then pos.x=pos.x+1 end
						if dir==2 then pos.z=pos.z-1 end
						if dir==3 then pos.z=pos.z+1 end
			if mode==12 then
				pos.y=pos.y-1
				stack_counts=stack_counts_start
			end

				for i=1,stack_counts,1 do

					if dir==0 then pos.x=pos.x+plus	pos.z=z+1 end
					if dir==1 then pos.x=pos.x+minus	pos.z=z-1 end
					if dir==2 then pos.z=pos.z+plus 	pos.x=x-1 end
					if dir==3 then pos.z=pos.z+minus 	pos.x=x+1 end
					stack_counts_tmp=stack_counts_start

					if player:get_inventory():get_stack("main", player:get_wield_index()-1):get_count()<stack_counts_tmp and autouse==0 then return false end

					for ii=1,stack_counts_start-1,1 do
							if mode==11 then
							if diplazer_place(pos, player, stack_counts_tmp,Name,Node,creative,admin)==true then
								stack_counts_tmp=stack_counts_tmp-1
								if dir==0 then pos.z=pos.z+plus  end
								if dir==1 then pos.z=pos.z+minus end
								if dir==2 then pos.x=pos.x+minus end
								if dir==3 then pos.x=pos.x+plus end
							else

								stack_counts_tmp=stack_counts_tmp-1
								if player:get_inventory():get_stack("main", player:get_wield_index()-1):get_count()<stack_counts_tmp and autouse==0 then return false end
								break
							end
							else  -- if mode 12
								diplazer_dig (pos,player,drops,admin)
								stack_counts_tmp=stack_counts_tmp-1
								if dir==0 then pos.z=pos.z+plus  end
								if dir==1 then pos.z=pos.z+minus end
								if dir==2 then pos.x=pos.x+minus end
								if dir==3 then pos.x=pos.x+plus end
							end
					end
				end
				return true
	end

--AutoSwitch
	if mode == 10 then
			local plus=1
			local minus=-1
			local dir = diplazer_getdir(player)
			local tp2node1=minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y, z=pos.z}).name].walkable
			local tp2node2=minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name].walkable
			if tp2node1==false and tp2node2==false then
				pos.y=pos.y-1
				plus=-1
				minus=1
				if dir==0 then pos.x=pos.x+plus end
				if dir==1 then pos.x=pos.x+minus end
				if dir==2 then pos.z=pos.z+plus end
				if dir==3 then pos.z=pos.z+minus end
			end
			minetest.sound_play("diplazer_place", {pos = player:getpos(), gain = 1.0, max_hear_distance = 5,})
			pos.y=pos.y+1
			local Fullcount=0


				for s=1,8,1 do

	local nstack=player:get_inventory():get_stack("main", s):get_name()
	stack_count=player:get_inventory():get_stack("main", s):get_count()
	if not (minetest.registered_nodes[nstack] or nstack == "air") then return false end

					for i=1,diplazer_amountT,1 do
						if diplazer_place(pos, player, stack_count,nstack,{name=nstack},creative,admin)==true then
							stack_count=stack_count-1
							Fullcount=Fullcount+1
							if Fullcount>=diplazer_amountT then return false end

							if dir==0 then pos.x=pos.x+plus end
							if dir==1 then pos.x=pos.x+minus end
							if dir==2 then pos.z=pos.z+plus end
							if dir==3 then pos.z=pos.z+minus end
						else
							if Fullcount<=diplazer_amountT then
							stack_count=0
							else
							return false
							end
							break
						end
					end

				end
				return true
	end



--Replace
	if mode == 9 then
			minetest.sound_play("diplazer_place", {pos = player:getpos(), gain = 1.0, max_hear_distance =5,})
			local replace=player:get_inventory():get_stack("main", player:get_wield_index()+1):get_name()

			if autousereplace~="" then
			replace=autousereplace
			end


			if replace=="" then return false end
			local dir = diplazer_getdir(player)
			local replacestack_count=player:get_inventory():get_stack("main", player:get_wield_index()+1):get_count()
			local is_renode= not (minetest.registered_nodes[replace] or replace== "air")
			if ((replacestack_count<stack_count and replacestack_count<diplazer_amountT) or is_renode or is_node) and admin<1 then

				diplazer_T(player_name,-4)
				return false
			end
				for i=1,diplazer_amountT,1 do
					if diplazer_replace(pos, player, stack_count,Name,Node,creative,admin,replace,drops)==true then
						stack_count=stack_count-1
					if dir==0 then pos.x=pos.x+1 end
					if dir==1 then pos.x=pos.x-1 end
					if dir==2 then pos.z=pos.z+1 end
					if dir==3 then pos.z=pos.z-1 end
					else
						return false
					end
				end
				return true
	end

-- Place front

	if mode == 1 then
	local lazer=0

			if is_node then
				if drops==0 then Name="diplazer:lazer_adminno"
				elseif admin==0 then Name="diplazer:lazer_gun"
				elseif admin==1 then Name="diplazer:lazer_admin"
				elseif admin==-1 and com==1 then Name="diplazer:lazer_com"
				elseif admin==-1 and com==2 then Name="diplazer:lazer_comg"
				elseif admin==-1 and com==3 then Name="diplazer:lazer_comc"
				else
				return false
				end
				Node= {name=Name}
				stack_count=diplazer_amount*2
				lazer=1
			end

			local plus=1
			local minus=-1
			local dir = diplazer_getdir(player)
			local tp2node1=minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y, z=pos.z}).name].walkable
			local tp2node2=minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name].walkable

			if tp2node1==true and tp2node2==true then
				pos.y=pos.y-1
				plus=-1
				minus=1
				if dir==0 then pos.x=pos.x+plus end
				if dir==1 then pos.x=pos.x+minus end
				if dir==2 then pos.z=pos.z+plus end
				if dir==3 then pos.z=pos.z+minus end
			end

			minetest.sound_play("diplazer_place", {pos = player:getpos(), gain = 1.0, max_hear_distance = 5,})

			pos.y=pos.y+1
				for i=1,diplazer_amountT,1 do

				if lazer==1 then
				local dmg=1
				for i, ob in pairs(minetest.get_objects_inside_radius(pos, 1)) do
				dmg=1
						if ob:is_player()==true and minetest.setting_getbool("enable_pvp")==false and admin==-1 then dmg=0 end
						if ob:is_player()==true and ob:get_player_name()==player:get_player_name() then dmg=0 end
						if dmg==1 then
							if admin<1 then ob:set_hp(ob:get_hp()-10) end
							if admin==1 then ob:set_hp(0) end
							if drops==0 then ob:remove() end

							if player.is_fake_player and player.is_fake_player==true then
								if ob:get_hp()<=0 then ob:remove() end
							elseif drops~=0 then
								ob:punch(player,0,"diplazer:com",diplazer_getdir(player))

							end
						end
				end
				end


					if diplazer_place(pos, player, stack_count,Name,Node,creative,admin)==true then
						stack_count=stack_count-1
						if dir==0 then pos.x=pos.x+plus end
						if dir==1 then pos.x=pos.x+minus end
						if dir==2 then pos.z=pos.z+plus end
						if dir==3 then pos.z=pos.z+minus end
					else
						return false
					end
				end
				return true
	end
-- dig Front
	if mode == 2 then
		local dir = diplazer_getdir(player)

		minetest.sound_play("diplazer_dig", {pos = player:getpos(), gain = 1.0, max_hear_distance = 5,})
			for i=1,diplazer_amountT,1 do
				if stack_count>0 then
					diplazer_dig (pos,player,drops,admin)
					stack_count=stack_count-1
				end
					if dir==0 then pos.x=pos.x+1 end
					if dir==1 then pos.x=pos.x-1 end
					if dir==2 then pos.z=pos.z+1 end
					if dir==3 then pos.z=pos.z-1 end
			end
			return true
	end
 -- Place up
	if mode==3 then
		if Name=="" or Name==nil or Name=="ignore" or is_node or Name=="default:chest_locked" then
		else
			minetest.sound_play("diplazer_place", {pos = player:getpos(), gain = 1.0, max_hear_distance = 7,})
			pos.y=pos.y+1
 -- x+
				for i=1,diplazer_amountT,1 do
					if diplazer_place(pos, player, stack_count,Name,Node,creative,admin)==true then
						stack_count=stack_count-1

						pos.y=pos.y+1
					else
						return false
					end
				end

			end
			return true
-- x-
	end
--dig down
	if mode==4 then
		minetest.sound_play("diplazer_dig", {pos = player:getpos(), gain = 1.0, max_hear_distance = 5,})
		for i=1,diplazer_amountT,1 do

			if stack_count>0 then
				diplazer_dig (pos,player,drops,admin)
				stack_count=stack_count-1
			end
			pos.y=pos.y-1
		end
		return true
	end
--dig 3 x 3

	if mode==5 then
		local dir=player:get_look_dir()
		minetest.sound_play("diplazer_dig", {pos = player:getpos(), gain = 1.0, max_hear_distance = 5,})
		if math.abs(dir.y)<0.5 then
			dir=diplazer_getdir(player)
				if dir==0 or dir==1 then -- x
					diplazer_dig2(pos,player,drops,admin)
				end
				if dir==2 or dir==3 then  -- z
					diplazer_dig3(pos,player,drops,admin)
				end
		else
		diplazer_dig4(pos,player,drops,admin)
		end
		return true
	end

--teleport

	if mode==6 then
		local tp2node1=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y+1, z=pos.z}).name]
		local tp2node2=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y+2, z=pos.z}).name]

		if (tp2node1.walkable==false and tp2node2.walkable==false and admin<0) or admin>=0 then
		if (tp2node1.name=="diplazer:vacuum" or tp2node1.name=="diplazer:vacuum") and admin<0 then return end

			if admin<0 and player:getpos().y<=pos.y then
				local walkable=0
				local tp2node1=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y, z=pos.z}).name].walkable==false
				local tp2node2=minetest.registered_nodes[minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z}).name].walkable==false
				local tp2node3=minetest.registered_nodes[minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z}).name].walkable==false
				local tp2node4=minetest.registered_nodes[minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z+1}).name].walkable==false
				local tp2node5=minetest.registered_nodes[minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z-1}).name].walkable==false
				local tp2node6=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y, z=pos.z+1}).name].walkable==false
				local tp2node7=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y, z=pos.z-1}).name].walkable==false
				local tp2node8=minetest.registered_nodes[minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z-1}).name].walkable==false
				local tp2node9=minetest.registered_nodes[minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z+1} ).name].walkable==false
				if tp2node1 then walkable=1 end
				if tp2node2 then walkable=1 end
				if tp2node3 then walkable=1 end
				if tp2node4 then walkable=1 end
				if tp2node5 then walkable=1 end
				if tp2node6 then walkable=1 end
				if tp2node7 then walkable=1 end
				if tp2node8 then walkable=1 end
				if tp2node9 then walkable=1 end
				if walkable==0 then return false end
			end
			player:moveto({ x=pos.x, y=pos.y+1, z=pos.z },false)
			minetest.sound_play("diplazer_teleport", {pos = player:getpos(), gain = 1.1, max_hear_distance = 5,})
		end
		return true
	end

--teleport object

	if mode==7 then

		local tp2node1=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y+1, z=pos.z}).name]
		local tp2node2=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y+2, z=pos.z}).name]
		if (tp2node1.walkable==false and tp2node2.walkable==false and admin<0) or admin>=0 then
		if (tp2node1.name=="diplazer:vacuum" or tp2node2.name=="diplazer:vacuum") and admin<0 then return end
			if admin<0 and player:getpos().y<=pos.y then

				local walkable=0
				local tp2node1=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y, z=pos.z}).name].walkable==false
				local tp2node2=minetest.registered_nodes[minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z}).name].walkable==false
				local tp2node3=minetest.registered_nodes[minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z}).name].walkable==false
				local tp2node4=minetest.registered_nodes[minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z+1}).name].walkable==false
				local tp2node5=minetest.registered_nodes[minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z-1}).name].walkable==false
				local tp2node6=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y, z=pos.z+1}).name].walkable==false
				local tp2node7=minetest.registered_nodes[minetest.get_node({ x=pos.x, y=pos.y, z=pos.z-1}).name].walkable==false
				local tp2node8=minetest.registered_nodes[minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z-1}).name].walkable==false
				local tp2node9=minetest.registered_nodes[minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z+1} ).name].walkable==false
				if tp2node1 then walkable=1 end
				if tp2node2 then walkable=1 end
				if tp2node3 then walkable=1 end
				if tp2node4 then walkable=1 end
				if tp2node5 then walkable=1 end
				if tp2node6 then walkable=1 end
				if tp2node7 then walkable=1 end
				if tp2node8 then walkable=1 end
				if tp2node9 then walkable=1 end
				if walkable==0 then return false end
			end


			local len=diplazer_getLength(diplazer_UserTele)
			local player_name = player:get_player_name()
			for i=1,len,1 do
				if mode .."?".. player_name==diplazer_UserTele[i] then
					diplazer_Tele[i]:moveto({ x=pos.x, y=pos.y+1, z=pos.z },false)
					minetest.sound_play("diplazer_teleport", {pos = player:getpos(), gain = 1.1, max_hear_distance = 5,})
					return 0
				end
			end
			diplazer_T(player_name,-2)
		end
		return true
	end
end



local function diplazer_pos_is_pointable(pos)
	local node = minetest.get_node(pos)
	local nodedef = minetest.registered_nodes[node.name]
	return nodedef and nodedef.pointable
end

local function diplazer_setmode(user,itemstack,admin,keys,drops,com)
	minetest.sound_play("diplazer_mode" , {pos = user:getpos(), gain = 2.0, max_hear_distance = 5,})
	local player_name=user:get_player_name()
	local item=itemstack:to_table()
	local meta=minetest.deserialize(item["metadata"])
	local mode=0

	if meta==nil then
		meta={}
		mode=0
	end
	if meta["mode"]==nil then
		diplazer_T(player_name,-1)
		meta["mode"]=0
		mode=0
	end
	mode=(meta["mode"])


	if diplazer_haveGGun(user)==true then
		diplazer_USEGgun(meta,user,0,admin)
		GGunInUse=GGunInUse-1
	end




	if keys.sneak and keys.jump then mode=mode-1
	else mode=mode+1
	end


	have_1112access(player_name,1)

-- Settings mode for :com

	if mode==11 and diplazer_Enable_com_mode12==true and diplazer_Enable_com_mode11==false and admin==-1 and keys.jump then mode=10 end
	if mode<=0 and diplazer_Enable_com_mode12==false and diplazer_Enable_com_mode11==true and admin==-1 and	keys.jump	then mode=11 end
	if mode<=0 and diplazer_Enable_com_mode12==false and diplazer_Enable_com_mode11==false and admin==-1 and	keys.jump	then mode=10 end
	if mode==11 and diplazer_Enable_com_mode11==false and admin==-1 then mode=12 end
	if mode==12 and diplazer_Enable_com_mode12==false and admin==-1 then mode=1 end

	if diplazer_Enable_com_mode8==false then
	if mode==8 and keys.sneak and keys.jump and admin==-1 then mode=7 end
	if mode==8 and admin==-1 then mode=9 end
	end

-- Settings mode for :gun or better

	if mode==11 and diplazer_Enable_mode12==true and diplazer_Enable_mode11==false and admin>=0 and keys.jump then mode=10 end
	if mode<=0 and diplazer_Enable_mode12==false and diplazer_Enable_mode11==true and admin>=0 and	keys.jump	then mode=11 end
	if mode<=0 and diplazer_Enable_mode12==false and diplazer_Enable_mode11==false and admin>=0 and	keys.jump	then mode=10 end
	if mode==11 and diplazer_Enable_mode11==false and admin>=0 then mode=12 end
	if mode==12 and diplazer_Enable_mode12==false and admin>=0 then mode=1 end

	if mode>=13 and admin>=0 then mode=1 end
	if mode<=0 and admin>=0 then mode=12 end

--

	if mode>=13 then mode=1 end
	if mode<=0 then mode=12 end

--
	if mode==8 and diplazer_Enable_mode8==false and keys.jump then mode=7 end
	if mode==8 and diplazer_Enable_mode8==false and not keys.jump then mode=9 end

	diplazer_T(player_name,mode,user,admin)

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
	itemstack:replace(item)
	return itemstack
end



function diplazer_add_item_string(itemstack, user,admin, drops,com)

	local inv1=user:get_inventory():get_stack("main", user:get_wield_index()-1):get_name()
	local invc1=user:get_inventory():get_stack("main", user:get_wield_index()-1):get_count()
	local inv2=user:get_inventory():get_stack("main", user:get_wield_index()+1):get_name()

	if inv1=="" or inv2=="" then return 0 end

	local player_name=user:get_player_name()
	local item=itemstack:to_table()
	local meta = minetest.deserialize(itemstack:get_metadata())
	local item=itemstack:to_table()

	meta["inv1"]=inv1
	meta["invc1"]=invc1
	meta["inv2"]=inv2

	item["metadata"]=minetest.serialize(meta)
	itemstack:replace(item)
	return itemstack
end



local function diplazer_onuse(itemstack, user, pointed_thing, admin, drops,com)

if minetest.check_player_privs(user:get_player_name(), {diplazer_gun=true})==false and admin==0 then
minetest.chat_send_player(user:get_player_name(), "You need diplazer_gun priv to use this tool")
print(user:get_player_name() .. " tried to use diplazer:gun - missing priv: diplazer_gun")
return 0
end

if minetest.check_player_privs(user:get_player_name(), {diplazer_admin=true})==false and admin==1 then
minetest.chat_send_player(user:get_player_name(), "You need diplazer_admin priv to use this tool")
print(user:get_player_name() .. " tried to use diplazer:admin - missing priv: diplazer_admin")
return 0
end

	if admin==1
		then user:set_hp(20)--			sets full health on use
	end

	local keys = user:get_player_control()
	local player_name = user:get_player_name()
	local meta = minetest.deserialize(itemstack:get_metadata())

	if not meta or not meta.mode or keys.sneak or (keys.sneak and keys.jump) then
		return diplazer_setmode(user, itemstack, admin,keys,drops,com)
	end

	if admin>-1 then
	itemstack:set_wear(0)
	end

	if admin==-1 and diplazer_Enable_com_limeted==true then -- set com wear
	local wer=itemstack:get_wear()
	local u3
	if com==1 then u3=65535/(diplazer_Enable_com_limeted_uses) end
	if com==2 then u3=65535/(diplazer_Enable_com_limeted_uses*2) end
	if com==3 then u3=65535/(diplazer_Enable_com_limeted_uses*8) end

--	if wer+u3>=65535 then
--		minetest.chat_send_player(player_name, "You have to load your diplazer, craft the diplazer with a Meseblock")
--	itemstack:set_wear(65534)
--	return false
--	else

--	itemstack:set_wear(wer+u3)
--	end

	end


-- ========== Grab nodes ==========

	if meta.mode==8 and pointed_thing.type=="node" then
		if GGunInUse<0 then GGunInUse=0 end
		local len=diplazer_getLength(diplazer_UserTele)



		for i=1,len,1 do
			if meta.mode .."?".. player_name==diplazer_UserTele[i] and (not diplazer_Tele[i]==false ) then

			if diplazer_Tele[i]==nil or diplazer_Tele[i]==0 then return false end
			if minetest.get_node(diplazer_Tele[i]:getpos())
.name ~="air" then return end
			if diplazer_USEGgunStackToNodeByNode(diplazer_Tele[i],user)==0 then return end
			diplazer_Tele[i]=false
			return false
			end
		end

		if admin<0 and diplazer_Enable_com_limeted==true then
			local alexist=0
			for i=1,diplazer_getLength(diplazer_com_mode8_users),1 do
				if player_name==diplazer_com_mode8_users[i].name then
					diplazer_com_mode8_users[i].time=diplazer_com_mode8_time --refull time
					alexist=1
				end
			end
			if alexist==0 then
				minetest.chat_send_player(user:get_player_name(), "You can use this for " .. diplazer_com_mode8_time .. " secunds")
				table.insert(diplazer_com_mode8_users,{name=player_name, time=diplazer_com_mode8_time})
			end
		end


		local node_pos = minetest.get_pointed_thing_position(pointed_thing)
		if node_pos==nil then return false end
		local node=minetest.get_node({x=node_pos.x, y=node_pos.y, z=node_pos.z})

		if minetest.registered_nodes[node.name] and minetest.is_protected(node_pos ,user:get_player_name())==false and diplazer_is_unbreakable(node_pos)==false then
		if node.name:find("bed",1)~=nil or node.name:find("commandblock",1)~=nil or node.name:find("chest",1)~=nil or node.name:find("diplazer:",1)~=nil  then return false end



			minetest.remove_node(node_pos)
			local udir = user:get_look_dir()
			minetest.spawn_item({x=node_pos.x, y=node_pos.y+0.5, z=node_pos.z}, node.name)
			diplazer_onuse(itemstack, user, pointed_thing, admin, drops)
			for _,object in ipairs(minetest.get_objects_inside_radius(node_pos, 2)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					local len=diplazer_getLength(diplazer_UserTele)
					for i=1,len,1 do
						if meta.mode  .."?".. player_name==diplazer_UserTele[i] then
							GGunInUse=GGunInUse+1
							diplazer_Tele[i]=object
							diplazer_UserTele[i]=meta.mode .."?".. user:get_player_name()
							minetest.sound_play("diplazer_grabnode", {pos =user:getpos(), gain = 1.0, max_hear_distance = 3,})
							return 0
						end
					end
					GGunInUse=GGunInUse+1
					table.insert(diplazer_Tele, object)
					table.insert(diplazer_UserTele,meta.mode .."?"..  user:get_player_name())
					minetest.sound_play("diplazer_grabnode", {pos =user:getpos(), gain = 1.0, max_hear_distance = 3,})
				end
			end
			return false
		end
return false
	end


-- ========== Add object ==========

	if pointed_thing.type ~= "node" or not diplazer_pos_is_pointable(pointed_thing.under) then
	if diplazer_pipeworks==1 then --		set meta stack
		local abl=0
		if admin==0 and minetest.check_player_privs(player_name, {give=true})==true then abl=1 end

		if admin<1 then
			local m=meta.mode
			if m==2 or m==4 or m==5 or m==12 then abl=1 end
		else
		abl=1
		end

		if (not user.is_fake_player) and abl==1 then
		diplazer_add_item_string(itemstack,user, admin, drops)
		end
	end
	if diplazer_USEGgun(meta,user,pointed_thing,admin)==0 then return end
		if (meta.mode==7 or meta.mode==8) and pointed_thing.type=="object" and pointed_thing.ref then  -- Set Terget


			local len=diplazer_getLength(diplazer_UserTele)
			if GGunInUse<0 then GGunInUse=0 end
			if len==0 then len=1 end

		if meta.mode==8 and admin<0 and diplazer_Enable_com_limeted==true then
			local alexist=0
			for i=1,diplazer_getLength(diplazer_com_mode8_users),1 do
				if player_name==diplazer_com_mode8_users[i].name then
					diplazer_com_mode8_users[i].time=diplazer_com_mode8_time
					alexist=1
				end
			end
			if alexist==0 then
				minetest.chat_send_player(player_name, "You can use this for " .. diplazer_com_mode8_time .. " seconds")
				table.insert(diplazer_com_mode8_users,{name=player_name, time=diplazer_com_mode8_time})
			end
		end


			for i=1,len,1 do
				if meta.mode  .."?".. player_name==diplazer_UserTele[i] then
					GGunInUse=GGunInUse+1
					if diplazer_Tele[i] and diplazer_Tele[i]:is_player()==true then diplazer_Tele[i]:set_physics_override({gravity=diplazer_restore_gravity_to,}) end
					diplazer_Tele[i]=pointed_thing.ref
					diplazer_UserTele[i]=meta.mode .."?".. player_name
					if meta.mode==8 then minetest.sound_play("diplazer_grabnode", {pos =user:getpos(), gain = 1.0, max_hear_distance = 3,}) end
					return 0
				end
			end
			GGunInUse=GGunInUse+1

			table.insert(diplazer_Tele, pointed_thing.ref)
			table.insert(diplazer_UserTele,meta.mode .."?"..  player_name)
			if meta.mode==8 then minetest.sound_play("diplazer_grabnode", {pos =user:getpos(), gain = 1.0, max_hear_distance = 3,}) end
			return 0
		end
		if pointed_thing.type=="object" and pointed_thing.ref then -- 		Shoot
			local ob=pointed_thing.ref
			local hp=ob:get_hp()
			local tru=0

			if  admin==1 then
				hp=0
			elseif admin<1 then

				if minetest.setting_getbool("enable_pvp")==false and admin==-1 and ob:is_player()==true then
					return false
				else
					hp=ob:get_hp()-10
				end
			end
			minetest.sound_play("diplazer_dig", {pos = user:getpos(), gain = 1.0, max_hear_distance = 5,})
			ob:set_hp(hp)
			ob:punch(user,0,"diplazer:gun",diplazer_getdir(user))
		end
		if pointed_thing.type=="object" and pointed_thing.ref and meta.mode==6 then -- Teleport to object, then shoot
		else
			return
		end
	end
		local pos = minetest.get_pointed_thing_position(pointed_thing)
		diplazer_use(pos, user, meta,admin,drops,keys,com)
	return itemstack
end


--  =====The diplazers

if diplazer_Enable_com==true then

minetest.register_tool("diplazer:com", {
	description = "Diplazer",
	range = diplazer_com_amount,
	inventory_image = "diplazer_com.png",
	on_use = function(itemstack, user, pointed_thing)
	diplazer_onuse(itemstack,user,pointed_thing,-1,1,1)
	return itemstack
	end,
})

minetest.register_tool("diplazer:comg", {
	description = "Diplazer green",
	range = diplazer_com_amount,
	inventory_image = "diplazer_comg.png",
	on_use = function(itemstack, user, pointed_thing)
	diplazer_onuse(itemstack,user,pointed_thing,-1,1,2)
	return itemstack
	end,
})

minetest.register_tool("diplazer:comc", {
	description = "Diplazer cyan",
	range = diplazer_com_amount,
	inventory_image = "diplazer_comc.png",
	on_use = function(itemstack, user, pointed_thing)
	diplazer_onuse(itemstack,user,pointed_thing,-1,1,3)
	return itemstack
	end,
})

end

minetest.register_tool("diplazer:gun", {
	description = "Diplazer gun",
	range = diplazer_amount,
	inventory_image = "diplazer.png",
	groups = {not_in_creative_inventory=1},
	on_use = function(itemstack, user, pointed_thing)
	diplazer_onuse(itemstack,user,pointed_thing,0,1)
	return itemstack
	end,
})

minetest.register_tool("diplazer:admin", {
	description = "Diplazer Admin",
	range = diplazer_amount,
	inventory_image = "diplazeradmin.png",
	groups = {not_in_creative_inventory=1},
	on_use = function(itemstack, user, pointed_thing)
	diplazer_onuse(itemstack,user,pointed_thing,1,1)
	return itemstack
	end,
})

minetest.register_tool("diplazer:adminno", {
	description = "Diplazer Admin no drops",
	range = diplazer_amount,
	inventory_image = "diplazeradminno.png",
	groups = {not_in_creative_inventory=1},
	on_use = function(itemstack, user, pointed_thing)
	diplazer_onuse(itemstack,user,pointed_thing,1,0)
	return itemstack
	end,
})

if diplazer_Enable_com==true then
for i=1,12,1 do

if i==11 and diplazer_Enable_com_mode11==false then i=i+1 end
if i==12 and diplazer_Enable_com_mode12==false then return end

	minetest.register_tool("diplazer:com" .. i, {
		description = "Diplazer mode ".. i,
		inventory_image = "diplazer_com.png^diplazer_mode"..i..".png",
		range = diplazer_com_amount,
		wield_image = "diplazer_com.png^diplazer_Colmode"..i..".png",
		groups = {not_in_creative_inventory=1},
		on_use = function(itemstack, user, pointed_thing)
		diplazer_onuse(itemstack,user,pointed_thing,-1,1,1)
		return itemstack
		end,
	})

	minetest.register_tool("diplazer:comg" .. i, {
		description = "Diplazer mode ".. i,
		inventory_image = "diplazer_comg.png^diplazer_mode"..i..".png",
		range = diplazer_com_amount+1,
		wield_image = "diplazer_comg.png^diplazer_Colmode"..i..".png",
		groups = {not_in_creative_inventory=1},
		on_use = function(itemstack, user, pointed_thing)
		diplazer_onuse(itemstack,user,pointed_thing,-1,1,2)
		return itemstack
		end,
	})

	minetest.register_tool("diplazer:comc" .. i, {
		description = "Diplazer mode ".. i,
		inventory_image = "diplazer_comc.png^diplazer_mode"..i..".png",
		range = diplazer_com_amount+3,
		wield_image = "diplazer_comc.png^diplazer_Colmode"..i..".png",
		groups = {not_in_creative_inventory=1},
		on_use = function(itemstack, user, pointed_thing)
		diplazer_onuse(itemstack,user,pointed_thing,-1,1,3)
		return itemstack
		end,
	})




if diplazer_Enable_com_limeted==true then
minetest.register_craft({output = "diplazer:com",recipe = {{"diplazer:com".. i, "default:mese_crystal"},},})
minetest.register_craft({output = "diplazer:comg",recipe = {{"diplazer:comg".. i, "default:mese_crystal"},},})
minetest.register_craft({output = "diplazer:comc",recipe = {{"diplazer:comc".. i, "default:mese_crystal"},},})
end
end
end

for i=1,12,1 do

if i==11 and diplazer_Enable_mode11==false then i=i+1 end
if i==12 and diplazer_Enable_mode12==false then return end


	minetest.register_tool("diplazer:gun" .. i, {
		description = "Diplazer mode ".. i,
		inventory_image = "diplazer.png^diplazer_mode"..i..".png",
		range = diplazer_amount,
		wield_image = "diplazer.png^diplazer_Colmode"..i..".png",
		groups = {not_in_creative_inventory=1},
		on_use = function(itemstack, user, pointed_thing)
		diplazer_onuse(itemstack,user,pointed_thing,0,1)
		return itemstack
		end,
	})
	minetest.register_tool("diplazer:admin" .. i, {
		description = "Diplazer Admin mode ".. i,
		inventory_image = "diplazeradmin.png^diplazer_mode"..i..".png",
		range = diplazer_amount,
		wield_image = "diplazeradmin.png^diplazer_Colmode"..i..".png",
		groups = {not_in_creative_inventory=1},
		on_use = function(itemstack, user, pointed_thing)
		diplazer_onuse(itemstack,user,pointed_thing,1,1)
		return itemstack
		end,
	})

	minetest.register_tool("diplazer:adminno" .. i, {
		description = "Diplazer Admin no drops mode ".. i,
		inventory_image = "diplazeradminno.png^diplazer_mode"..i..".png",
		range = diplazer_amount,
		wield_image = "diplazeradminno.png^diplazer_Colmode"..i..".png",
		groups = {not_in_creative_inventory=1},
		on_use = function(itemstack, user, pointed_thing)
		diplazer_onuse(itemstack,user,pointed_thing,1,0)
		return itemstack
		end,
	})



minetest.register_craft({
	output = "diplazer:com",
	recipe = {
		{"", "default:diamond", ""},
		{"default:mese_crystal", "default:mese", "default:mese"},
		{"", "default:steel_ingot", "default:steel_ingot"},
	},
})

minetest.register_craft({
	output = "diplazer:comg",
	recipe = {
		{"", "default:diamond", ""},
		{"default:mese_crystal", "diplazer:com", "default:mese"},
		{"", "default:steel_ingot", "default:steel_ingot"},
	},
})

minetest.register_craft({
	output = "diplazer:comc",
	recipe = {
		{"", "default:diamond", ""},
		{"default:diamondblock", "diplazer:comg", "default:diamondblock"},
		{"", "default:diamond", "default:diamond"},
	},
})

end

--  =====The Healing orbs

if diplazer_Enable_orbs==true then

minetest.register_tool("diplazer:orba", {
	description = "Healing Admin Orb",
	range = 0,
	inventory_image = "diplazer_orba.png",
	groups = {not_in_creative_inventory=1},
})
minetest.register_tool("diplazer:orbg", {
	description = "Healing Moderator Orb",
	range = 0,
	inventory_image = "diplazer_orbg.png",
	groups = {not_in_creative_inventory=1},
})
minetest.register_tool("diplazer:orbc", {
	description = "Healing Orb",
	range = 0,
	inventory_image = "diplazer_orbc.png",
})

minetest.register_craft({
	output = "diplazer:orbc",
	recipe = {
		{"", "default:mese_crystal", ""},
		{"default:mese_crystal", "default:mese", "default:mese_crystal"},
		{"", "default:mese_crystal", ""},
	},
})


end


minetest.register_privilege("diplazer_gun", {
	description = "Player can use Diplazer for moderator.",
	give_to_singleplayer= true,
})
minetest.register_privilege("diplazer_admin", {
	description = "Player can use Diplazer for admins",
	give_to_singleplayer= true,
})



local diplazer_lazer={"com","comg","comc","gun","admin","adminno"}
for i=1,6,1 do

minetest.register_node("diplazer:lazer_" .. diplazer_lazer[i], {
	description = "Diplazer Lazer (temporary)",
	tiles = {"diplazer_lazer_" .. diplazer_lazer[i] .. ".png",},
	drop="",
	light_source = 50,
	paramtype = "light",
	alpha = 50,
	walkable=false,
	use_texture_alpha = true,
	drawtype = "glasslike",
	sunlight_propagates = true,
	groups = {not_in_creative_inventory=1},
can_dig = function(pos, player)
		return false
end,
})

minetest.register_node("diplazer:lazerblock_" .. diplazer_lazer[i], {
	description = "Diplazer Lazer",
	tiles = {"diplazer_lazer_" .. diplazer_lazer[i] .. ".png",},
	light_source = 50,
	paramtype = "light",
	alpha = 50,
	use_texture_alpha = true,
	drawtype = "glasslike",
	sunlight_propagates = true,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds=default.node_sound_stone_defaults(),
})

end

diplazer_lazer=nil

minetest.register_abm({
	nodenames = {"diplazer:lazer_com","diplazer:lazer_comg","diplazer:lazer_comc","diplazer:lazer_gun","diplazer:lazer_admin","diplazer:lazer_adminno" },
	interval = 2,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
	minetest.set_node(pos, {name="air"})
	end,
})


minetest.register_craft({
	output = "diplazer:lazerblock_com",
	recipe = {
		{"default:cobble","default:cobble", "default:cobble"},
		{"default:cobble","default:mese_crystal", "default:cobble"},
		{"default:cobble","default:cobble", "default:cobble"},
	}
})

minetest.register_craft({
	output = "diplazer:lazerblock_comg",
	recipe = {
		{"default:cobble","default:cobble", "default:cobble"},
		{"default:cobble","diplazer:lazerblock_com", "default:cobble"},
		{"default:cobble","default:cobble", "default:cobble"},
	}
})

minetest.register_craft({
	output = "diplazer:lazerblock_comc",
	recipe = {
		{"default:cobble","default:cobble", "default:cobble"},
		{"default:cobble","diplazer:lazerblock_comg", "default:cobble"},
		{"default:cobble","default:cobble", "default:cobble"},
	}
})

minetest.register_craft({
	output = "diplazer:lazerblock_gun",
	recipe = {
		{"default:cobble","default:cobble", "default:cobble"},
		{"default:cobble","diplazer:lazerblock_comc", "default:cobble"},
		{"default:cobble","default:cobble", "default:cobble"},
	}
})

minetest.register_craft({
	output = "diplazer:lazerblock_admin",
	recipe = {
		{"default:cobble","default:cobble", "default:cobble"},
		{"default:cobble","diplazer:lazerblock_gun", "default:cobble"},
		{"default:cobble","default:cobble", "default:cobble"},
	}
})
minetest.register_craft({
	output = "diplazer:lazerblock_adminno",
	recipe = {
		{"default:cobble","default:cobble", "default:cobble"},
		{"default:cobble","diplazer:lazerblock_admin", "default:cobble"},
		{"default:cobble","default:cobble", "default:cobble"},
	}
})

minetest.register_craft({
	output = "diplazer:vacuum 9",
	recipe = {
		{"default:cobble","default:cobble", "default:cobble"},
		{"default:cobble","group:wood", "default:cobble"},
		{"default:cobble","default:cobble", "default:cobble"},
	}
})

minetest.register_node("diplazer:vacuum", {
	description = "Vaccum (anti teleport)",
	inventory_image = "diplazer_lock_com.png",
	tiles = {"diplazer_vaccum.png"},
	walkable = false,
	pointable = false,
	diggable = false,
	drowning = 1,
	buildable_to = true,
	drawtype = "plantlike",
	liquidtype = "airlike",
	groups = {not_in_creative_inventory=0},
	post_effect_color = {a = 50, r =50, g = 50, b = 50},
	paramtype = "light",
	sunlight_propagates = true,
})
