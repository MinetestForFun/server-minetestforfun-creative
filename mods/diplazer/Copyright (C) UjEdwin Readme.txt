

Copyright (C) UjEdwin 2015

Mod by UjEdwin
See the version in the init.lua or type /dihelp in game

Rename this folder to diplazer

More info: https://forum.minetest.net/viewtopic.php?f=9&t=12395

Other info: type /dihelp in game

type /di_dropme to drop you self from mode7 and mode8 (or with diplazer_admin priv /di_dropall)


Diplazer is a kind of lasergun / fast placing / diging tool, and it can even teleport, object teleporter and gravitygun, and more!!

To change modes: Use while sneaking / hold shift and left click
To change modes backward: Use while sneaking and jump / hold shift+jump and left click
Dipalzer works with pipeworks:nodebreaker

Diplazer works with pipeworks:nodebreaker (make smooth doors / traps and other)
modes that are supported with nodebreakers
:com & :gun womodes:1 2,4,5,12
:admin & :adminno: 1 2 4 5 8 9 11 12
place a block front of the breaker before it can use the tool

Change the amount in the init.lua file (diplazer_amount=15) admin have double

In place mode (1 & 3): In invetory: place stack with blocks / nodes to  left side of the tool , the tool will use all of same type of nodes from the inventory, then the stack to left.
In dig mode (2 & 4): In invetory: place stack-amout to dig.

The common version: diplazer:com (di_com)
Toogleable
Limeted (toogleable) [craft with meseblock to reload]
can place / dig 7 blocks
hit takes 10hp

The common version green: diplazer:comg (di_comg)
Toogleable
Limeted (toogleable) [craft with meseblock to reload]
can place / dig 8 blocks
have 2x uses
hit takes 11hp

The common version cyan: diplazer:comg (di_comc)
Toogleable
Limeted (toogleable) [craft with meseblock to reload]
can place / dig 10 blocks
have 4x uses
hit takes 12hp

The moderator version: diplazer:gun (di_gun)
can place / dig 15 blocks
can break unbreakable nodes
teleport modes dont care about walls
takes 10hp even if pvp is off
require diplazer_gun priv to use

The admin version: diplazer:admin (di_ad)
can place/dig 30 blocks
can break unbreakable nodes
teleport modes dont care about walls
sets hp to 0 even if pvp is off
dont empty your invetory
require diplazer_admin priv to use

The admin version: diplazer:adminno  (di_adno)
same as diplazer:admin
don't keep stuff on dig, can destroy locked stuff / special nodes
require diplazer_admin priv to use

in mode: 1,3,11 you can use next mode if you hold right+left click instead of change

Mode1: Place front (can shoot lazer if no stack set)
Mode2: Dig nodes front
Mode3: Place up
Mode4: Dig nodes down
Mode5: Dig nodes 3x3 
Mode6: Teleport
Mode7: Teleport Objects
Mode8: Gravity gun (click to pickup, click it again to drop, click+right to throw it away [dont work on players])
Mode9: Replace: stack to left replace with stack to right
Mode10: AutoSwitch: using from all stacks in hotbar from left to right [place dipalzer to right for max use]
Mode11: Place platform nXn
Mode12: Dig platform nXn

Use mode8
Use / left click		-		pick up something or a node
Use / left click again	-		drop it (pick up somthing else make you automacly drop the corrent) (if you hold a 1 stack item it will be placed as node)
Use & jump / left-click & jump		if you hold a 1 stack item it will be droped, not placed)
Place & use / hold right-click then right-left	throw it faraway (can't throw away players)

Healing orbs:
diplazer:orbc (di_orbc) slow / craftable
diplazer:orbg (di_orbg) faster
diplazer:orba (di_orba) sets full health

Switcherbox:
diplazer:box (di_box)
Change modes & reload using mese crystal / fragemnts


Gravity manipuler:
diplazer:grav (di_grav)
change your gravity on use or restore (1 / 0.5 as default)


Lazer blocks:
decoration with light
di_lcom
di_lcomg
di_lcomc
di_lgun
di_lad
di_ladno

Vaccum block / anti teleportblock:
diplazer:vaccum / di_vac
Just vaccum, at same time it prevents players to teleport to inside.
The blocks are invisible, and have to place somethine on it, or dig with any diplazer to remove.

Diplazer 3D Transfer
diplazer:di3dt / di_3dt
left click top copy, right to place your place.
see Help-Controls.txt for more info

You can easy toogle / functions in the init.lua

Changes log:

V16
Added:	diplazer:3dt
V15.2
Added:	in /dihelp info
V15.1
Fixed:	crash in mode7
V15
Added:	vaccumblock / anti teleportblock (diplazer:vaccum / di_vac)
V14
Added:	/di_dropme
Added:	/di_dropall
V13
Added:	diplazer:grav
Added:	dipalzer:comg
Added:	dipalzer:comc
Fixed:	more bugs
V12.5
Fixed:	swiths modes in switcherbox
V12.4
Fixed:	bug: switch to mode7
V12.3
Added:	Help-Controls file
Added:	players with dipalzer:gun and have give: will not take stuff from inventory on use
Fixed:	lot of bugs
Fixed:	:com mode8 are disabled as default (glitch fix)
V12.2
Added:	support for pipeworks:nodebreaker
V12.1
Fixed:	crash when dig unknown blocks
Fixed:	:com cant place in water
V12
Added:	lazerblocks
Added:	Limeted mode8 (:com)
Added:	change mode messages
Added:	/dihelp
Added:	left right+left to use next mode
Fixed:	error: mode9 repalce with empty
Fixed:	full inventory cant dig wirh no free slot
Fixed:	mode8: crash when pick up stuff
Fixed:	mode8: performance bug, shift mode while hold something
V11.4
Fixed:  :com placing over unbreakabel blocks without colision
V11.3
Fixed: warning for :com
Fixed: com: craft recipe for mode 11 & 12
Added: better support in dig modes
Added: setting: diplazer_Enable_gun_limitation
V11.2
Fixed:	nil crasch
Fixed:	low but powerfull sound (mode12)
V11.1:
Added:	security for mode 11 & 12
Added:	sounds for mode 11 & 12
V11:
Added:	alias di_ad di_adno ... try /giveme di_box
Added:	placing modes can place in none-walkable blocks / water
Added:	mode11 & mode12: place & dig platform
Fixed:	inactived :gun instand of :com (diplazer_Enable_com=false)
V10:
Added:	mode8: players can now throw stuff / mobs / items inside none-walkable blocks / water
Added:	mode8: water and lava will slowdown velocity of throwed stuff / mobs players
Added:	players using com:mode6 / 7 can now teleport into unwalkable blocks (like water)
Added:	players using com:mode7 cant cheat teleport stuff / players over other floors (bigger then 3x2) (like the problem with mode6)
Added:	diplazer:box can now reload using mese fragents (giving 10%)
Fixed:	performance (exit after use)
Fixed:	bug wont show amount of stack on chnage modes by hand
V9:
Added:	admin/gun autorepair on use
Added:	diplazer:box (repair / set modes tool)
Changed:	craft with meecrystal to load instand of meseblock
Changed:	craft tool recipe will be front of the other
Fixed: 	missing craft recipe for diplazer:com10
Fixed: 	global teleport sound
Fixed: 	limeted bug
V8:
Added:	limted use for diplazer:com (toggleable), craft with meseblock for full use
Added:	mode10: autoswitch
Fixed:	teleport sound
V7:
Fixed:	global variable errors
Fixed:	crash when throw someting & leave game
Added:	in mode 6 for diplazer:com -  cant teleport through 3x3 floor.
Added:	diplazer_admin and  diplazer_gun priv
Added:	configation toogle mode8, com, orbs
V6:
Added:	mode 1 placing backward, if a node over the pointed
Fixed:	leaving player with 0 gravity when point a node
Fixed:	crash when pick up some objects
V5:
Added:	mode 8 throwed and hitted object will be hurted (20hp) or throwed object hurts on hit a node (20hp)
Fixed:	error when trying to place none-node-stacks
V4:
Added:	healing orbs
Added:	mode 8 can drop grabed nodes (hold jump & use)
Added:	mode 8 can place graped node / item stuck (if its 1 item in the stack)
Added:	mode 8 can grap nodes
Added:	mode 8 move selected object from nodes or to your backside
Added:	mode 8 sound effects
Fixed:	long distance sounds
Fixed:	directions for mode 8
Fixed:	error message when using mode 7
Fixed:	mode 7 positions
Fixed:	mode 8 inactive by power-saving-gate
V3:
Added:	diplazer:com
Added:	Mode9 / replace
Fixed:	get error text when try to place none-nodes.
V2:
Added:	support for protect areas
Added:	diplazer:adminno (don't giving drops on dig and able to delete locked stuff)
Added:	sets full health on use.
V1:
Mod is created