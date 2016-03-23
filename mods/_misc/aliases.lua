local alias = minetest.register_alias
-- Remove duplicated items from the carbone subgame because of Moreores mod
-- Stone
alias("default:stone_with_tin", "default:stone")
alias("default:stone_with_silver", "default:stone")
-- Lump
alias("default:tin_lump", "default:stone")
alias("default:silver_lump", "default:stone")
-- Ingot
alias("default:tin_ingot", "default:stone")
alias("default:silver_ingot", "default:stone")
-- Block
alias("default:tinblock", "default:stone")
alias("default:silverblock", "default:stone")
-- Tools
alias("default:pick_silver", "default:stone")
alias("default:shovel_silver", "default:stone")
alias("default:axe_silver", "default:stone")
alias("default:sword_silver", "default:stone")
alias("default:knife_silver", "default:stone")

-- Remove torch from torches => remise des torches par défaut
alias("torches:floor", "default:torch")
alias("torches:wand", "default:torch")

-- Remove copper_rail from moreores => utilisation des rail_copper du mod carts
alias("moreores:copper_rail", "carts:rail_copper")

-- Old fishing mod to the new fishing mod
alias("fishing:fish_cooked", "fishing:fish")
alias("fishing:worm", "fishing:bait_worm")

-- Old itemframes mod to the new itemframes(v2) mod
alias("itemframes:pedestal", "itemframes:pedestal_cobble")

-- Remove "moreores:copper_rail" for "carts:copper_rail"
alias("moreores:copper_rail", "carts:rail_copper")

-- Remove "multitest:hayblock" because farming redo include it now
alias("multitest:hayblock", "farming:straw")

-- Remove "darkage:stair_straw", "darkage:straw", "darkage:straw_bale" and "darkage:adobe"
alias("darkage:stair_straw", "farming:straw")
alias("darkage:straw", "farming:straw")
alias("darkage:straw_bale", "farming:straw")
alias("darkage:adobe", "farming:straw")

-- Remove "wiki:wiki"
alias("wiki:wiki", "default:bookshelf")

-- Remove "building_blocks:knife"
alias("building_blocks:knife", "default:sword_steel")

-- Remove "jumping" mod
alias("jumping:cushion", "wool:dark_green")
for i = 1, 6 do
	alias("jumping:trampoline_" .. i, "default:wood")
end

-- Remove ugly default advertising nodes
alias("advertising:cokecola", "default:stone")
alias("advertising:noentiendo", "default:stone")
alias("advertising:pepso", "default:stone")
alias("advertising:mineyoshi", "default:stone")
alias("advertising:michel", "default:stone")
alias("advertising:avivas", "default:stone")

-- Remove "xmas_tree" from snow mod
alias("snow:xmas_tree", "default:dirt")
