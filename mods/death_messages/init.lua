-----------------------------------------------------------------------------------------------
local title	= "Death Messages"
local version = "0.1.2"
local mname	= "death_messages"
-----------------------------------------------------------------------------------------------
dofile(minetest.get_modpath("death_messages").."/settings.txt")
-----------------------------------------------------------------------------------------------

-- A table of quips for death messages

local messages = {}

-- Fill this table with sounds
local sounds   = {
	[1] = "death_messages_player_1",
	[2] = "death_messages_player_2",
}

-- Lava death messages
messages.lava = {
	" pensait que la lave etait cool.",
	" s'est sentit oblige de toucher la lave.",
	" est tombe dans la lave.",
	" est mort(e) dans de la lave.",
	" ne savait pas que la lave etait vraiment chaude.",
	" a detruit l'anneau de Sauron."
}

-- Drowning death messages
messages.water = {
	" a manque d'air.",
	" a essaye d'usurper l'identite d'une ancre.",
	" a oublie qu'il n'etait pas un poisson.",
	" a oublier qu'il lui fallait respirer sous l'eau.",
	" n'est pas bon en natation.",
	" a cherche le secret de la licorne.",
	" a oublie son scaphandre."
}

-- Burning death messages
messages.fire = {
	" a eut un peu trop chaud.",
	" a ete trop pres du feu.",
	" vient de se faire rotir.",
	" a ete carbonise.",
	" s'est prit pour la torche.",
	" a allume le feu."
}

-- Acid death messages
messages.acid = {
	" a desormais des parties en moins.",
	" a decouvert que l'acide c'est fun.",
	" a mis sa tete la ou elle a fondu.",
	" a decouvert que son corps dans l'acide, c'est comme du sucre dans de l'eau.",
	" a cru qu'il se baignait dans du jus de pomme.",
	" a donne son corps pour faire une infusion.",
	" a bu la mauvaise tasse.",
	" a voulu tester la solubilite de son corps dans l'acide."
}

-- Quicksands death messages
messages.sand = {
	" a appris que le sable etait moins fluide que l'eau.",
	" a rejoint les momies.",
	" s'est fait(e) ensevelir.",
	" a choisi la voie de la fossilisation."
}

-- Other death messages
messages.other = {
	" a fait quelque chose qui lui a ete fatale.",
	" est mort(e).",
	" n'est plus de ce monde.",
	" a rejoint le paradis des mineurs.",
	" a perdu la vie.",
	" a vu la lumière."
}


local function sound_play_all(dead)
	for _, p in ipairs(minetest.get_connected_players()) do
		local player_name = p:get_player_name()
		if player_name and player_name ~= dead then
			minetest.sound_play("death_messages_people_1",{to_player=player_name, gain=soundset.get_gain(player_name,"other")})
		end
	end
end

if RANDOM_MESSAGES == true then
	minetest.register_on_dieplayer(function(player)
		local player_name = player:get_player_name()
		local node = minetest.registered_nodes[minetest.get_node(player:getpos()).name]
		if minetest.is_singleplayer() then
			player_name = "You"
		end

		local death_message = ""

		-- Death by lava
		if node.groups.lava ~= nil then
			death_message = player_name ..  messages.lava[math.random(1,#messages.lava)]
		-- Death by acid
		elseif node.groups.acid ~= nil then
			death_message = player_name ..  messages.acid[math.random(1,#messages.acid)]
		-- Death by drowning
		elseif player:get_breath() == 0 and node.groups.water then
			death_message = player_name ..  messages.water[math.random(1,#messages.water)]
		-- Death by fire
		elseif node.name == "fire:basic_flame" then
			death_message = player_name ..  messages.fire[math.random(1,#messages.fire)]
		-- Death in quicksand
		elseif player:get_breath() == 0 and node.name == "default:sand_source" or node.name == "default:sand_flowing" then
			death_message = player_name .. messages.sand[math.random(1,#messages.sand)]
		-- Death by something else
		else
			death_message = player_name ..  messages.other[math.random(1,#messages.other)]
		end

		-- Actually tell something
		minetest.chat_send_all(death_message)
		if minetest.get_modpath("irc") ~= nil then
			irc:say(death_message)
		end
		minetest.sound_play(sounds[math.random(1,#sounds)],{to_player=player:get_player_name(),gain=soundset.get_gain(player:get_player_name(),"other")})
		sound_play_all(player:get_player_name())
	end)

else
	minetest.register_on_dieplayer(function(player)
		local player_name = player:get_player_name()
		local node = minetest.registered_nodes[minetest.get_node(player:getpos()).name]
		if minetest.is_singleplayer() then
			player_name = "You"
		end
		-- Death by lava
		if node.groups.lava ~= nil then
			minetest.chat_send_all(player_name .. " melted into a ball of fire")
		-- Death by drowning
		elseif player:get_breath() == 0 then
			minetest.chat_send_all(player_name .. " ran out of air.")
		-- Death by fire
		elseif node.name == "fire:basic_flame" then
			minetest.chat_send_all(player_name .. " burned to a crisp.")
		-- Death by something else
		else
			minetest.chat_send_all(player_name .. " died.")
		end
		minetest.sound_play(sounds[math.random(1,#sounds)],{to_player=player:get_player_name(),gain=soundset.get_gain(player:get_player_name(),"other")})
		sound_play_all(player:get_player_name())
	end)
end

-----------------------------------------------------------------------------------------------
minetest.log("action", "[Mod] "..title.." ["..version.."] ["..mname.."] Loaded...")
-----------------------------------------------------------------------------------------------
