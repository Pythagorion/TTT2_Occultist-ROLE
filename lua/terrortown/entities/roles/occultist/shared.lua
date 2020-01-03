if ( SERVER ) then
	AddCSLuaFile()
	util.PrecacheSound("Phoenix-Roar.mp3")
end

function ROLE:PreInitialize()
	self.color                      = Color(15, 67, 54, 255)

	self.abbr                       = "occul"
	self.surviveBonus               = 0
	self.scoreKillsMultiplier       = 1
	self.scoreTeamKillsMultiplier   = -16
	self.preventFindCredits         = true
	self.preventKillCredits         = true
	self.preventTraitorAloneCredits = true
	self.preventWin                 = false
	self.unknownTeam                = true

	self.defaultTeam                = TEAM_INNOCENT

	self.conVarData = {
		pct          = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum      = 1, -- maximum amount of roles in a round
		minPlayers   = 7, -- minimum amount of players until this role is able to get selected
		credits      = 0, -- the starting credits of a specific role
		shopFallback = SHOP_DISABLED,
		togglable    = true, -- option to toggle a role for a client if possible (F1 menu)
		random       = 33
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_INNOCENT)

	if CLIENT then
		-- Role specific language elements
		LANG.AddToLanguage("English", OCCULTIST.name, "Occultist")
		LANG.AddToLanguage("English", "info_popup_" .. OCCULTIST.name,
			[[You are the Occultist!
			You´ve done a ritual successfully. Now you can get back to life when your HP fall under 25. If you get one-shotted, you're ritual won't take effect.]])
		LANG.AddToLanguage("English", "body_found_" .. OCCULTIST.abbr, "They were an Occultist.")
		LANG.AddToLanguage("English", "search_role_" .. OCCULTIST.abbr, "This person was an Occultist!")
		LANG.AddToLanguage("English", "target_" .. OCCULTIST.name, "Occultist")
		LANG.AddToLanguage("English", "ttt2_desc_" .. OCCULTIST.name, [[The Occultist needs to win with the innocents!]])
		LANG.AddToLanguage("English", "credit_" .. OCCULTIST.abbr .. "_all", "Occultists, you have been awarded {num} equipment credit(s) for your performance.")

		LANG.AddToLanguage("Deutsch", OCCULTIST.name, "Okkultist")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. OCCULTIST.name,
			[[Du bist ein Okkultist!
			Du hast ein Ritual erfolgreich vollendet. Jetzt kannst du aus dem Totenreich zurückkehren, falls deine HP unter 25 fallen. Wirst jedoch ge-oneshotted, wird das Ritual dich nicht zurückholen können.]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. OCCULTIST.abbr, "Er war ein Okkultist!")
		LANG.AddToLanguage("Deutsch", "search_role_" .. OCCULTIST.abbr, "Diese Person war ein Okkultist!")
		LANG.AddToLanguage("Deutsch", "target_" .. OCCULTIST.name, "Okkultist")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. OCCULTIST.name, [[Der Okkultist gewinnt zusammen mit den Unschuldigen!]])
		LANG.AddToLanguage("Deutsch", "credit_" .. OCCULTIST.abbr .. "_all", "Okkultist(en), dir wurde(n) {num} Ausrüstungs-Credit(s) für deine Leistung gegeben.")
	end
end

if SERVER then
	-- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentItem("item_ttt_nofiredmg")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:RemoveEquipmentItem("item_ttt_nofiredmg")
	end

	function OcculRevival(victim, inflictor, attacker)
		if victim:GetSubRole() == ROLE_OCCULTIST then
			victim:Ignite( 15 )
			victim:Revive(10, function(p)
				p:EmitSound("Phoenix-Roar.mp3")
			end)
			if attacker:Health() > 85 then
				attacker:Ignite( 5 )
			end
			hook.Remove("PlayerDeath", "OcculDies")
		end
	end

	hook.Add("EntityTakeDamage", "OcculIsDamaged", function(target)
		if target:IsPlayer() and target:GetSubRole() == ROLE_OCCULTIST then
			if target:Health() < 25 then
				hook.Add("PlayerDeath", "OcculDies", OcculRevival)
				hook.Remove("EntityTakeDamage", "OcculIsDamaged")
			end
		end
	end)

	hook.Add("TTTEndRound","CleanUpOccul", function()
		hook.Remove("PlayerDeath", "OcculDies")
	end)
end