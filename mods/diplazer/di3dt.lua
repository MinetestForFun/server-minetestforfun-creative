local function diplazer_getLength(a)
if a==nil then return 0 end
	local count = 0
	for _ in pairs(a) do count = count + 1 end
	return count
end

local function diplazer_nvpa(a,p,dipiv)
	local meta=minetest.get_meta({x=p.x,y=p.y,z=p.z})
	if meta and (meta:get_string("owner")~="" or meta:get_string("infotext")~="") then return "air" end
	if a:find("door",1) then return "air" end
	if dipiv==0 and minetest.registered_nodes[a].drop=="" then return "air" end
	return a
end

local function diplazer_Transferuse_count(to_do,pos,user,diplazer_amountT,nodes2place)

	if  diplazer_amountT==nil then
	minetest.chat_send_player(user:get_player_name(), "Error")
	return false
	end




	print(diplazer_amountT)
	if to_do=="check" then
		pos.y=pos.y+1
	end

	local info={}
	local pos3={x=pos.x,y=pos.y,z=pos.z}
	local pos2={x=pos.x,y=pos.y,z=pos.z}
	local pos1={x=pos.x,y=pos.y,z=pos.z}
	local plus=1
	local minus=-1
	local num=1
	local dir=diplazer_getdir(user)
	local name=user:get_player_name()
	local creative=0
	local tnode=""
	local dipriv=0
	if (to_do=="copy" or to_do=="check") and (minetest.check_player_privs(name, {diplazer_admin=true})==true or minetest.check_player_privs(name, {diplazer_gun=true}))==true then
		dipriv=1
	end
	if to_do=="check" and (minetest.check_player_privs(name, {diplazer_admin=true})==true or minetest.check_player_privs(name, {give=true})==true or minetest.check_player_privs(name, {creative=true})==true) then
		creative=1
	end

	for i1=1,diplazer_amountT,1 do					 --level
		for i2=1,diplazer_amountT,1 do				 --front
			for i3=1,diplazer_amountT,1 do			 --side
					if to_do=="copy" then
						tnode=minetest.get_node({x=pos3.x, y=pos3.y, z=pos3.z})
.name
						if tnode~="air" then info[num]=diplazer_nvpa(tnode,pos3,dipriv)
						else
						info[num]="air"
						end
					end
					if to_do=="place" then
						minetest.set_node(pos3, {name=nodes2place[num]})
					end
					if to_do=="checkcopy" or to_do=="check" then
						if minetest.is_protected(pos3, user:get_player_name())==true then
							minetest.chat_send_player(user:get_player_name(), "this place are protected (".. pos3.x ..",".. pos3.y ..",".. pos3.z ..")")
							return false
						end
					info[num]=minetest.get_node({x=pos3.x, y=pos3.y, z=pos3.z})
.name

					end

					if to_do=="check" then-- before check if can place
						if minetest.is_protected(pos3, user:get_player_name())==true then
							minetest.chat_send_player(user:get_player_name(), "this place are protected (".. pos3.x ..",".. pos3.y ..",".. pos3.z ..")")
							return false
						end

						local fn=minetest.registered_nodes[minetest.get_node(pos3).name]
						if (dipriv==0 and fn.name~="air") or (dipriv==1 and fn.walkable==true) then 
							minetest.chat_send_player(user:get_player_name(), "You have to clear the area before you can place here (".. diplazer_amountT .."x".. diplazer_amountT .. "x" .. diplazer_amountT .. ")  Found: " .. fn.name)
							return false
						end
					end

					num=num+1
					if dir==0 then pos3.z=pos3.z+plus  end
					if dir==1 then pos3.z=pos3.z+minus end
					if dir==2 then pos3.x=pos3.x+minus end
					if dir==3 then pos3.x=pos3.x+plus end
			end
				if dir==0 then pos3.z=pos2.z		pos3.x=pos3.x+1		pos2.x=pos2.x+1 end
				if dir==1 then pos3.z=pos2.z		pos3.x=pos3.x-1		pos2.x=pos2.x-1 end
				if dir==2 then pos3.x=pos2.x		pos3.z=pos3.z+1		pos2.z=pos2.z+1 end
				if dir==3 then pos3.x=pos2.x		pos3.z=pos3.z-1		pos2.z=pos2.z-1 end
		end
	pos1.y=pos1.y+1
	pos2={x=pos1.x,y=pos1.y,z=pos1.z}
	pos3={x=pos2.x,y=pos2.y,z=pos2.z}
	end

	if to_do=="place" then
	return true
	end
	if to_do=="copy" then
	return {info=info,num=num}
	end
	if to_do=="checkcopy" then
	return true
	end


	if to_do=="check"  then
	if creative==1 then return true end
	local infoT={}
	local infoT2={}
	local infoT3={}
	local tmp=""
	local itm=""
	local cnt=0

	for i=1,num-1,1 do
		if nodes2place[i]~="air" and nodes2place[i]~="ignore" then
			tmp=nodes2place[i]
			infoT3[tmp]=tmp
			if infoT[tmp] then
				infoT[tmp]=infoT[tmp]+1
			else
				infoT[tmp]=1
			end
		end
	end

	infoT2=infoT
	local rmv3={}
	local rmv2={}

	for i,itm in pairs(infoT3) do
	rmv3[itm]=infoT3[itm]
	rmv2[itm]=infoT2[itm]
	end

	for i=1,32,1 do
		itm=user:get_inventory():get_stack("main", i):get_name()
		cnt=user:get_inventory():get_stack("main", i):get_count()
		if infoT2[itm] then -- and cnt>0 cnt>=infoT2[itm]
			infoT2[itm]=infoT2[itm]-cnt
			if infoT2[itm]<=0 then
				infoT2[itm]=nil
				infoT3[itm]=nil
			end
		end
	end
	if diplazer_getLength(infoT2)>0  then
		local missing=""
		for i,itm in pairs(infoT3) do
			if infoT3[itm]:find(":",1) then
				infoT3[itm]=infoT3[itm].split(infoT3[itm],":")[2]
			end
			missing=missing .. infoT3[itm] .." ".. infoT2[itm] .." " 
		end
		minetest.chat_send_player(user:get_player_name(), "Needed stuff to place: " ..missing )
			return false

	else
		if diplazer_getLength(rmv3)>0 then
			for i,itm in pairs(rmv3) do
				for i=1, rmv2[itm],1 do
					user:get_inventory():remove_item("main", rmv3[itm])
				end
			end
		end
	end



	end

return true
end





local function diplazer_Transferuse(itemstack,user,pointed_thing,button)
	if user.is_fake_player and user.is_fake_player==true then return itemstack end
	if pointed_thing.type~="node" then return 0 end
	local name=user:get_player_name()
	local pos=pointed_thing.under
	local diplazer_amountT=10
	local node=minetest.get_node({x=pos.x, y=pos.y, z=pos.z})

	local admin=-1
	if node.name=="air" then return false end

	if minetest.check_player_privs(name, {diplazer_gun=true})==true then
		diplazer_amountT=diplazer_amount
		admin=0
	end

	if minetest.check_player_privs(name, {diplazer_admin=true})==true then
		diplazer_amountT=diplazer_amount*2
		admin=1
	end

	local stack_count=user:get_inventory():get_stack("main", user:get_wield_index()-1):get_count()
	if stack_count<diplazer_amountT then diplazer_amountT=stack_count end
	local nodes2place={}
	local info={}
	local tmp
	local num=0


	if button=="right" then
	if diplazer_Transferuse_count("checkcopy",pos,user,diplazer_amountT,nodes2place)==false then return end
		tmp=diplazer_Transferuse_count("copy",pos,user,diplazer_amountT,nodes2place)
		if tmp==false then return false end
		info=tmp.info
		num=tmp.num
		local item=itemstack:to_table()
		local meta = minetest.deserialize(item["metadata"])
		if meta==nil then meta={} end
		meta.info=info
		meta.amount=diplazer_amountT
		item.metadata=minetest.serialize(meta)
		itemstack:replace(item)
		minetest.chat_send_player(user:get_player_name(), (num-1) .. " blocks successfully saved in the tool")
		return itemstack
	end

	if button=="left" then
		local item=itemstack:to_table()
		local meta = minetest.deserialize(item["metadata"])
		if meta==nil then return 0 end
		nodes2place=meta.info
		diplazer_amountT=tonumber(meta.amount)
		if diplazer_Transferuse_count("check",pos,user,diplazer_amountT,nodes2place)==false then return false end
		diplazer_Transferuse_count("place",pos,user,diplazer_amountT,nodes2place)
	end
	if button=="left" then
		minetest.sound_play("diplazer_massiveplace", {pos = user:getpos(), gain = 1.0, max_hear_distance = 10,})
	else
		minetest.sound_play("diplazer_massivedig", {pos = user:getpos(), gain = 1.0, max_hear_distance = 10,})
	end

end

minetest.register_tool("diplazer:di3dt", {
	description = "Diplazer 3D Transfer",
	inventory_image = "diplazer_tran.png",
	range = diplazer_amount,
	wield_image = "diplazer_tran.png",
	groups = {not_in_creative_inventory=0},
on_use = function(itemstack, user, pointed_thing)
	local overwrite=1
	local admin=1
	diplazer_Transferuse(itemstack,user,pointed_thing,"left")
	return itemstack
end,
on_place = function(itemstack, user, pointed_thing)
	local overwrite=1
	local admin=1
	diplazer_Transferuse(itemstack,user,pointed_thing,"right")
	return itemstack
end,
	})

if diplazer_Enable_di3Dt_for_all==true then
minetest.register_craft({
	output = "diplazer:di3dt",
	recipe = {
		{"", "default:diamond", ""},
		{"default:diamond", "default:mese", "default:mese"},
		{"", "default:steel_ingot", "default:steel_ingot"},
	},
})
end