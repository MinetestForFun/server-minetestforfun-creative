minetest.register_node("advertising:minetest1", {
	description = "Minetest Advertising",
	tile_images = {"minetest1_side.bmp", "minetest1.bmp"},
	groups = {cracky=3, stone=2},
    paramtype2 = "facedir",
    paramtype = "light",
		sunlight_propagates = true,
		light_source = 15,
})

minetest.register_node("advertising:linux", {
	description = "Linux Advertising",
	tile_images = {"linux1_side.bmp", "linux1.bmp"},
	groups = {cracky=3, stone=2},
    paramtype2 = "facedir",
    paramtype = "light",
		sunlight_propagates = true,
		light_source = 15,
})

minetest.register_node("advertising:minetestforfun", {
	description = "MinetestForFun Advertising",
	tile_images = {"advertising_mff.png"},
	groups = {cracky=3, stone=2},
    	paramtype2 = "facedir",
    	paramtype = "light",
	sunlight_propagates = true,
	light_source = 15,
})

minetest.register_node("advertising:cyberpangolin", {
	description = "Cyberpangolin Advertising",
	tile_images = {"advertising_cyberpangolin.png"},
	groups = {cracky=3, stone=2},
    	paramtype2 = "facedir",
    	paramtype = "light",
	sunlight_propagates = true,
	light_source = 15,
})

minetest.register_node("advertising:prayforparis_text", {
	description = "Pray For Paris Text Advertising",
	tile_images = {"advertising_prayforparis_text.png.png"},
	groups = {cracky=3, stone=2},
    	paramtype2 = "facedir",
    	paramtype = "light",
	sunlight_propagates = true,
	light_source = 15,
})

minetest.register_node("advertising:prayforparis_logo", {
	description = "Pray For Paris Logo Advertising",
	tile_images = {"advertising_prayforparis_logo.png"},
	groups = {cracky=3, stone=2},
    	paramtype2 = "facedir",
    	paramtype = "light",
	sunlight_propagates = true,
	light_source = 15,
})
