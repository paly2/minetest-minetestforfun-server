--[[

shutdown par turbogus, code sous licence gpl2 ou sup
déclaration du "timer" par Jat ( du mod annonce )

Affiche l'heure dans le chat toute les minutes et
arrête votre serveur "proprement" à une heure précise afin de créer
une sauvegarde

]]--

local timer = 0

minetest.register_globalstep(function(dtime)
	timer = timer+dtime
	-- if timer < X then  = X seconde temps que s'affiche les message 
	-- Default 300 seconde = 5 minute
	if timer < 60 then
		return
	end
	timer = 0
	local heure = os.date("%H")
	local minute = os.date("%M")
	local jour = os.date("%u")
	-- Warn only on monday, thursday, and saturday
	if jour ~= 1 and jour~= 4 and jour ~= 6 then return end
	
	if heure == "2" and minute == "25" then        --modifier ici à  vos besoin
		minetest.chat_send_all("Arret du serveur pour sauvegarde dans 30min --- Veuillez vous deconnecter.")
	elseif heure == "2" and minute == "40" then         --modifier ici à  vos besoin
		minetest.chat_send_all("Arret du serveur pour sauvegarde dans 15min --- Veuillez vous deconnecter.")
	elseif heure == "2" and minute == "50" then         --modifier ici à  vos besoin
		minetest.chat_send_all("Arret du serveur pour sauvegarde dans 5min --- Veuillez vous deconnecter.")
	elseif heure == "2" and minute == "54" then           --modifier ici à  vos besoin
		minetest.chat_send_all("=== ARRET DU SERVEUR ===")
	end

end)
