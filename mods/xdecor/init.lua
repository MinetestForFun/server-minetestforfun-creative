--local t = os.clock()
xdecor = {}
local modpath = minetest.get_modpath("xdecor")

dofile(modpath.."/handlers/nodeboxes.lua")
dofile(modpath.."/handlers/registration.lua")
dofile(modpath.."/chess.lua")
dofile(modpath.."/cooking.lua")
dofile(modpath.."/crafts.lua")
dofile(modpath.."/enchanting.lua")
dofile(modpath.."/hive.lua")
dofile(modpath.."/itemframe.lua")
dofile(modpath.."/mailbox.lua")
dofile(modpath.."/rope.lua")
dofile(modpath.."/nodes.lua")
dofile(modpath.."/sitting.lua")
dofile(modpath.."/worktable.lua")
dofile(modpath.."/xwall.lua")

--print(string.format("xdecor loaded in %.2f ms", (os.clock()-t)*1000))
--TODO: remove the legacy code in ~6 months.

