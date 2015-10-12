diplazer_vesrion=16

diplazer_Tele={}
diplazer_UserTele={}
diplazer_1112access={}
diplazer_com_mode8_users={}
diplazer_pipeworks=0

diplazer_USEGgunIfObHit_obj={}
diplazer_USEGgunIfObHit_obj.count=0
diplazer_USEGgunIfObHit_obj.limedto=25
diplazer_USEGgunIfObHit_obj.on=0
diplazer_USEGgunIfObHit_obj.object=0
diplazer_USEGgunIfObHit_obj.userdir=0
diplazer_USEGgunIfObHit_obj.user=0
diplazer_USEGgunIfObHit_obj.objectposs=0
diplazer_USEGgunIfObHit_obj.admin=-1

GGunTime=0
GGunInUse=0

if minetest.get_modpath("pipeworks") then diplazer_pipeworks=1 end




dofile(minetest.get_modpath("diplazer") .. "/settings.lua")
dofile(minetest.get_modpath("diplazer") .. "/base.lua")
dofile(minetest.get_modpath("diplazer") .. "/dipbox.lua")
dofile(minetest.get_modpath("diplazer") .. "/di3dt.lua")

if diplazer_Enable_gravity==true then
dofile(minetest.get_modpath("diplazer") .. "/digrav.lua")
end

minetest.register_alias("di_3dt", "diplazer:di3dt")
minetest.register_alias("di_vac", "diplazer:vacuum")
minetest.register_alias("di_grav", "diplazer:grav")
minetest.register_alias("di_com", "diplazer:com")
minetest.register_alias("di_comg", "diplazer:comg")
minetest.register_alias("di_comc", "diplazer:comc")
minetest.register_alias("di_gun", "diplazer:gun")
minetest.register_alias("di_ad", "diplazer:admin")
minetest.register_alias("di_adno", "diplazer:adminno")
minetest.register_alias("di_box", "diplazer:box")
minetest.register_alias("di_orba", "diplazer:orba")
minetest.register_alias("di_orbg", "diplazer:orbg")
minetest.register_alias("di_orbc", "diplazer:orbc")
minetest.register_alias("di_lcom", "diplazer:lazerblock_com")
minetest.register_alias("di_lcomg", "diplazer:lazerblock_com")
minetest.register_alias("di_lcomc", "diplazer:lazerblock_com")
minetest.register_alias("di_lgun", "diplazer:lazerblock_gun")
minetest.register_alias("di_lad", "diplazer:lazerblock_admin")
minetest.register_alias("di_ladno", "diplazer:lazerblock_adminno")




