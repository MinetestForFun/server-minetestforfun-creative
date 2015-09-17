carpet3d
========

Carpet mod for Minetest

More than 720 carpet and decoration combinations!

Crafting
--------
To craft carpet: (shapeless)
+------------+------------+------------+
|wool:<color>|wool:<color>|            |
+------------+------------+------------+
|            |            |            | --> carpet3d:<color>
+------------+------------+------------+
|            |            |            |
+------------+------------+------------+

To craft decorated carpet: (shapeless)
+----------------+------------+------------+
|carpet3d:<color>|<decoration>|            |
+----------------+------------+------------+
|                |            |            | --> carpet3d:<color>_with_<decoration>
+----------------+------------+------------+
|                |            |            |
+----------------+------------+------------+

To craft decorated 2-layer carpet: (shapeless)
+----------------------------------+------+------+
|carpet3d:<color>_with_<decoration>|      |      |
+----------------------------------+------+------+     carpet3d:<color>
|<front_decoration>                |      |      | --> _with_<decoration>
+----------------------------------+------+------+     _and_<front_decoration>
|                                  |      |      |
+----------------------------------+------+------+

Carpet API
----------
Registering a carpet [carpet3d.register()]

carpet3d.register(def)

def is a table that contains:
- name			: itemstring "carpet3d:name"
- description	: node description (optional)
- images		: node tiles
- recipeitem	: node crafting recipeitem {recipeitem,recipeitem}
- groups		: node groups
- sounds		: node sounds (optional)

Example:
carpet3d.register({
	name = name,
	description = 'Black Carpet',
	images = {'wool_black.png'},
	recipeitem = 'wool:black',
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,falling_node=1,carpet=1},
	sounds = default.node_sound_defaults()
})