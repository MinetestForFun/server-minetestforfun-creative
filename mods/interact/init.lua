dofile(minetest.get_modpath("interact") .. "/config.lua")
dofile(minetest.get_modpath("interact") .. "/rules.lua") --I put the rules in their own file so that they don't get lost/overlooked!

local rule1 = 0
local rule2 = 0
local rule3 = 0
local rule4 = 0
local multi = 0

function table.length(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

interact.player_languages = {}
function interact.get_player_language(plr)
	if type(plr) == "string" then
		return interact.player_languages[plr]
	end
	return interact.player_languages[plr:get_player_name()]
end

interact.forms = {
	languageselect = function(player)
		local fs_width = 10
		local fs_button_margin = 1
		local fs = { "size["..tostring(fs_width)..",4]" }
		table.insert(fs, "background[0,0;10,4;background.jpg]")
		local i = 0
		local fs_button_width = (fs_width-fs_button_margin*2)/table.length(interact.languages)
		for lang, lname in pairs(interact.languages) do
			table.insert(fs, "button["..tostring(fs_button_margin+i*fs_button_width)..",2;"..tostring(fs_button_width)..",0.5;"..lang..";"..lname.."]")
			i = i+1
		end
		return table.concat(fs)
	end,

	welcome = function(player)
		local lang = interact.get_player_language(player)
		local size = { "size[10,4]" }
		table.insert(size, "background[0,0;10,4;background.jpg]")
		table.insert(size, "label[0.5,0.5;" ..interact.s1_header[lang].. "]")
		table.insert(size, "label[0.5,1.5;" ..interact.s1_l2[lang].. "]")
		table.insert(size, "label[0.5,2;" ..interact.s1_l3[lang].. "]")
		table.insert(size, "button_exit[5.5,3.4;2,0.5;no;" ..interact.s1_b1[lang].. "]")
		table.insert(size, "button[7.5,3.4;2,0.5;yes;" ..interact.s1_b2[lang].. "]")
		return table.concat(size)
	end,

	visit = function(player)
		local lang = interact.get_player_language(player)
		local size = { "size[10,4]" }
		table.insert(size, "background[0,0;10,4;background.jpg]")
		table.insert(size, "label[0.5,0.5;" ..interact.s2_l1[lang].. "]")
		table.insert(size, "label[0.5,1;" ..interact.s2_l2[lang].. "]")
		table.insert(size, "button_exit[2.5,3.4;3.5,0.5;interact;" ..interact.s2_b1[lang].. "]")
		table.insert(size, "button_exit[6.4,3.4;3.6,0.5;visit;" ..interact.s2_b2[lang].. "]")
		return table.concat(size)
	end,

	rules = function(player)
		local lang = interact.get_player_language(player)
		local size = { "size[10,8]" }
		table.insert(size, "background[0,0;10,8;background.jpg]")
		table.insert(size, "textarea[0.5,0.5;9.5,7.5;TOS;" ..interact.s3_header[lang].. ";" ..interact.rules[lang].. "]")
		table.insert(size, "button[5.5,7.4;2,0.5;decline;" ..interact.s3_b2[lang].. "]")
		table.insert(size, "button_exit[7.5,7.4;2,0.5;accept;" ..interact.s3_b1[lang].. "]")
		return table.concat(size)
	end,

	quiz = function(player)
		local lang = interact.get_player_language(player)
		local size = { "size[10,9]" }
		if interact.s4_to_rules_button == true then
			table.insert(size, "button_exit[7.75,0.25;2.1,0.1;rules;" ..interact.s4_to_rules[lang].. "]")
		end
		table.insert(size, "label[0.25,0;" ..interact.s4_header[lang].."]")
		table.insert(size, "label[0.5,0.5;" ..interact.s4_question1[lang].."]")
		table.insert(size, "checkbox[0.25,1;rule1_true;" ..interact.s4_question1_true[lang].."]")
		table.insert(size, "checkbox[4,1;rule1_false;" ..interact.s4_question1_false[lang].. "]")
		table.insert(size, "label[0.5,2;" ..interact.s4_question2[lang].. "]")
		table.insert(size, "checkbox[0.25,2.5;rule2_true;" ..interact.s4_question2_true[lang].. "]")
		table.insert(size, "checkbox[4,2.5;rule2_false;" ..interact.s4_question2_false[lang].. "]")
		table.insert(size, "label[0.5,3.5;" ..interact.s4_question3[lang].. "]")
		table.insert(size, "checkbox[0.25,4;rule3_true;" ..interact.s4_question3_true[lang].. "]")
		table.insert(size, "checkbox[4,4;rule3_false;" ..interact.s4_question3_false[lang].. "]")
		table.insert(size, "label[0.5,5;" ..interact.s4_question4[lang].. "]")
		table.insert(size, "checkbox[0.25,5.5;rule4_true;" ..interact.s4_question4_true[lang].. "]")
		table.insert(size, "checkbox[4,5.5;rule4_false;" ..interact.s4_question4_false[lang].."]")
		table.insert(size, "label[0.5,6.5;" ..interact.s4_multi_question[lang].. "]")
		table.insert(size, "checkbox[4.75,6.25;multi_choice1;" ..interact.s4_multi1[lang].. "]")
		table.insert(size, "checkbox[0.25,7;multi_choice2;" ..interact.s4_multi2[lang].. "]")
		table.insert(size, "checkbox[4.75,7;multi_choice3;" ..interact.s4_multi3[lang].."]")
		table.insert(size, "background[0,0;10,9;background.jpg]")
		table.insert(size, "button_exit[3,8.4;3.5,0.5;submit;" ..interact.s4_submit[lang].."]")
		return table.concat(size)
	end
}

function interact.show_form(player, form, delay)
	if delay == nil then delay = 1 end
	minetest.after(delay, function()
		minetest.show_formspec(player:get_player_name(), form, interact.forms[form](player))
	end)
end

function interact.show_next_form(player, current)
	local is_next = false
	for i, formspec in ipairs(interact.form_order) do
		if is_next then
			return interact.show_form(player, formspec, 0)
		end
		if formspec == current then
			is_next = true
		end
	end
	-- At the end? Everyting passed correctly, give permissions
	interact.grant_interact(player)
end

function interact.grant_interact(player)
	local lang = interact.get_player_language(player)
	local name = player:get_player_name()
	if minetest.check_player_privs(name, interact.priv) then
		minetest.chat_send_player(name, interact.interact_msg1[lang])
		minetest.chat_send_player(name, interact.interact_msg2[lang])
		local privs = minetest.get_player_privs(name)
		privs.interact = true
		minetest.set_player_privs(name, privs)
		minetest.log("action", "Granted " ..name.. " interact.")
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "languageselect" then return end
	local plrlang = "en"
	for lang, _ in pairs(interact.languages) do
		if fields[lang] then
			plrlang = lang
		end
	end
	interact.player_languages[player:get_player_name()] = plrlang

	interact.show_next_form(player, formname)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "welcome" then return end
	local name = player:get_player_name()
	if fields.no then
		interact.show_next_form(player, formname)
		return
	elseif fields.yes then
		if interact.grief_ban ~= true then
			local lang = interact.get_player_language(player)
			minetest.kick_player(name, interact.msg_grief[lang])
		else
			minetest.ban_player(name)
		end
	return
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "visit" then return end
	local name = player:get_player_name()
	if fields.interact then
		interact.show_next_form(player, formname)
		return
	elseif fields.visit then
		local lang = interact.get_player_language(player)
		minetest.chat_send_player(name, interact.visit_msg[lang])
		minetest.log("action", name.. " is just visiting.")
	return
	end
end)


minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "rules" then return end
	local name = player:get_player_name()
	if fields.accept then
		interact.show_next_form(player, formname)
		return
	elseif fields.decline then
		if interact.disagree_ban ~= true then
			local lang = interact.get_player_language(player)
			minetest.kick_player(name, interact.disagree_msg[lang])
		else
			minetest.ban_player(name)
		end
	return
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "quiz" then return end
	local name = player:get_player_name()
	if fields.rules then
		interact.show_form(player, "rules", 0)
		return
	end
	if fields.rule1_true then rule1 = true
	elseif fields.rule1_false then rule1 = false
	elseif fields.rule2_true then rule2 = true
	elseif fields.rule2_false then rule2 = false
	elseif fields.rule3_true then rule3 = true
	elseif fields.rule3_false then rule3 = false
	elseif fields.rule4_true then rule4 = true
	elseif fields.rule4_false then rule4 = false
	elseif fields.multi_choice1 then multi = 1
	elseif fields.multi_choice2 then multi = 2
	elseif fields.multi_choice3 then multi = 3 end
	if fields.submit and rule1 == interact.quiz1 and rule2 == interact.quiz2 and
	rule3 == interact.quiz3 and rule4 == interact.quiz4 and multi == interact.quiz_multi then
		rule1 = 0
		rule2 = 0
		rule3 = 0
		rule4 = 0
		multi = 0
		interact.show_next_form(player, formname)
	elseif fields.submit then
		rule1 = 0
		rule2 = 0
		rule3 = 0
		rule4 = 0
		multi = 0
		local lang = interact.get_player_language(player)
		if interact.on_wrong_quiz == "kick" then
			minetest.kick_player(name, interact.wrong_quiz_kick_msg[lang])
		elseif interact.on_wrong_quiz == "ban" then
			minetest.ban_player(name)
		elseif interact.on_wrong_quiz == "" then
			minetest.chat_send_player(name, interact.quiz_fail_msg[lang])
		else
			if interact.on_wrong_quiz == formname then
				minetest.chat_send_player(name, interact.quiz_try_again_msg[lang])
			end
			if interact.on_wrong_quiz == "rules" then
				minetest.chat_send_player(name, interact.quiz_rules_msg[lang])
			end
			interact.show_form(interact.on_wrong_quiz)
		end
	end
end)

minetest.register_chatcommand("rules",{
	params = "",
	description = "Shows the server rules",
	privs = interact.priv,
	func = function (name,params)
	local player = minetest.get_player_by_name(name)
		if not interact.blacklist[name] then
			interact.show_form(player, interact.form_order[1])
		else
			minetest.log("action", "[interact] Blacklisted player " .. name .. " tried to get back " ..
				"his revoked privilege")
			return false, "Sorry, you've been blacklisted by " ..
				(interact.blacklist[name].emitter or "<unknown>") .. " on " ..
				(interact.blacklist[name].date or "<unknown>") .. " . Thus, you can't use " ..
				" this command to get interact back. Sorry."
		end
	end
})

function start_formspecs(player)
	local name = player:get_player_name()
	if not minetest.get_player_privs(name).interact then
		if not interact.blacklist[name] then
			interact.show_form(player, interact.form_order[1])
		end
	end
end

minetest.register_on_joinplayer(start_formspecs)


-- Blacklist

interact.blacklist = {}

minetest.register_chatcommand("unblacklist", {
	params = "<playername>",
	description = "Remove a player from the interact blacklist",
	privs = {basic_privs = true, interact = true},
	func = function(name, param)
		if param == "" then
			return false, "Give a player's name to remove from the blacklist."
		end

		if not interact.blacklist[param] then
			return true, "Player " .. param " is not actually blacklisted."
		end

		if name == param then
			return true, "Ahahaha. Well tried looser."
		end

		minetest.log("action", "[interact] " .. name .. " removed " .. param .. " from " ..
			"blacklist (added on " .. (interact.blacklist[param].date or "<unknown>") ..
			" by " .. (interact.blacklist[param].emitter or "<unknown>") .. ")")
		interact.blacklist[param] = nil
		return true, "Done."
	end
})

minetest.register_chatcommand("blacklist", {
	params = "<playername>",
	description = "Blacklist a player. [S]He won't be able to use /rules.",
	privs = {basic_privs = true, interact = true},
	func = function(name, param)
		if param == "" then
			return false, "Give a player's name to blacklist."
		end

		local blackfile = io.open(minetest.get_worldpath() .. "/players/" .. param, "r")
		if not blackfile then
			return false, "Player doesn't exist."
		end
		io.close(blackfile)

		if name == param then
			return true, "You know this wouldn't work, right?"
		end

		if interact.blacklist[param] then
			return true, "Player already blacklisted."
		end

		if minetest.get_player_privs(param).interact == true then
			return true, "Warning: This player has interact! Use revoke before blacklisting."
		end

		interact.blacklist[param] = {
			emitter = name,
			date = os.date("%m/%d/%Y")
		}
		minetest.log("action", "[interact] " .. name .. " added " .. param .. " on /rules blacklist.")
		return true, "Player " .. param .. " blacklisted."
	end
})

function load_blacklist()
	local file = io.open(minetest.get_worldpath().."/interact_blacklist.txt", "r")
	if not file then
		file = io.open(minetest.get_worldpath().."/interact_blacklist.txt", "w")
		if not file then
			minetest.log("error", "[interact] Error opening blacklist file")
			return
		end
		minetest.log("action", "[interact] Blacklist created")
	end
	local line = file:read()
	if not line then
		interact.blacklist = {}
	else
		interact.blacklist = minetest.deserialize(line)
	end
	minetest.log("action", "[interact] Blacklist loaded")
	file:close()
end

function save_blacklist()
	local file = io.open(minetest.get_worldpath().."/interact_blacklist.txt", "w")
	if not file then
		minetest.log("error", "[interact] Error opening blacklist file")
		return
	end
	file:write(minetest.serialize(interact.blacklist))
	minetest.log("action", "[interact] Blacklist saved")
	file:close()
end

minetest.register_on_shutdown(save_blacklist)
load_blacklist()
