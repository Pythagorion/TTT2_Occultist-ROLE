if SERVER then
	AddCSLuaFile()

	util.PrecacheSound("Phoenix-Roar.wav")

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_occul")
	resource.AddFile("materials/vgui/ttt/hud_icon_occultist_revive.png")
end

sound.Add({
	name = "occultist_respawn",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	sound = "Phoenix-Roar.wav"
})

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
			You´ve done a ritual successfully. Now you can get back to life when your HP fall under 25. If you get one-shotted, you"re ritual won"t take effect.]])
		LANG.AddToLanguage("English", "body_found_" .. OCCULTIST.abbr, "They were an Occultist.")
		LANG.AddToLanguage("English", "search_role_" .. OCCULTIST.abbr, "This person was an Occultist!")
		LANG.AddToLanguage("English", "target_" .. OCCULTIST.name, "Occultist")
		LANG.AddToLanguage("English", "ttt2_desc_" .. OCCULTIST.name, [[The Occultist needs to win with the innocents!]])
		LANG.AddToLanguage("English", "credit_" .. OCCULTIST.abbr .. "_all", "Occultists, you have been awarded {num} equipment credit(s) for your performance.")

		LANG.AddToLanguage("Deutsch", OCCULTIST.name, "Okkultist")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. OCCULTIST.name,
			[[Du bist ein Okkultist!
			Du hast ein Ritual erfolgreich vollendet. Jetzt kannst du aus dem Totenreich zurückkehren, falls deine HP unter 25 fallen. Wirst du jedoch ge-oneshotted, wird das Ritual dich nicht zurückholen können.]])
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

	local function ClearOccultist()
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			ply.occ_data = {}
			ply.occ_data.was_revived = false
			ply.occ_data.allow_revival = false
		end
	end

	hook.Add("TTT2PostPlayerDeath", "ttt2_role_occultist_post_player_death", function(ply)
		if ply:GetSubRole() ~= ROLE_OCCULTIST then return end

		-- only respawn when occ respawn was not triggered this round and player crossed revival threashold
		if ply.occ_data.was_revived or not ply.occ_data.allow_revival then return end

		-- store the death posistion
		ply.occ_data.death_pos = ply:GetPos()

		-- cache time
		local revive_time = GetConVar("ttt_occultist_respawn_time"):GetInt()
		local dmgscale_fire = GetConVar("ttt_occultist_fire_damagescale"):GetInt()
		local fire_radius = GetConVar("ttt_occultist_fire_radius"):GetInt()

		for i = 1, 10 do
			local jitter = VectorRand() * 65
			jitter.z = 0

			-- spawn fire at death position
			local fire = ents.Create("env_fire")

			fire:SetPos(ply:GetPos() + jitter)
			fire:SetKeyValue("targetname", "fire")
			fire:SetKeyValue("health", tostring(revive_time * 2))
			fire:SetKeyValue("fireattack", "0")
			fire:SetKeyValue("ignitionpoint", "0")
			fire:SetKeyValue("firesize", tostring(fire_radius))
			fire:SetKeyValue("StartDisabled", "0")
			fire:SetKeyValue("spawnflags", 128 + 2)
			fire:SetKeyValue("damagescale", tostring(dmgscale_fire))
			fire:Spawn()
			fire:SetOwner(ply)

			fire:Fire("StartFire","","0")

			-- only play sound for first fire ent
			if i == 1 then
				fire:EmitSound("ambient/fire/ignite.wav", 100, 100)
			end
		end

		ply:Revive(revive_time, function(p)
			-- porting the player to his death position
			p:SetPos(p.occ_data.death_pos)

			-- set player HP to 100
			p:SetHealth(p:GetMaxHealth())

			-- set was revived flag
			p.occ_data.was_revived = true

			-- make sound
			p:EmitSound("occultist_respawn")
		end,
		function(p)
			-- make sure the revival is still valid
			return GetRoundState() == ROUND_ACTIVE and IsValid(p) and not p:Alive() and not p.occ_data.was_revived and ply.occ_data.allow_revival
		end,
		false, -- no corpse needed for respawn
		true, -- force revival
		function(p)
			-- on fail todo
		end)
	end)

	local next_think = 0
	local cv_occul_health_threshold

	hook.Add("Think", "ttt2_role_occultist_think", function()
		cv_occul_health_threshold = cv_occul_health_threshold or GetConVar("ttt_occultist_health_threshold")

		if CurTime() < next_think then return end

		-- only check for health 4 times a second
		next_think = CurTime() + 0.25

		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			-- player must be occultist
			if ply:GetSubRole() ~= ROLE_OCCULTIST then continue end

			-- player is not allowed to be revived twice
			if ply.occ_data.was_revived then continue end

			-- player HP must hit below a threshold
			if ply:Health() > cv_occul_health_threshold:GetInt() or ply:Health() <= 0 then continue end

			-- set flag to allow revival
			ply.occ_data.allow_revival = true

			-- set status icon
			STATUS:AddStatus(ply, "ttt2_occultist_revival")
		end
	end)

	hook.Add("TTTEndRound","ttt2_role_occultist_roundend", function()
		ClearOccultist()
	end)

	hook.Add("TTTBeginRound","ttt2_role_occultist_roundbegin", function()
		ClearOccultist()
	end)

	hook.Add("TTTPrepareRound","ttt2_role_occultist_roundprep", function()
		ClearOccultist()
	end)
end

if CLIENT then
	hook.Add("Initialize", "ttt2_role_collultist_init", function()
		STATUS:RegisterStatus("ttt2_occultist_revival", {
			hud = Material("vgui/ttt/hud_icon_occultist_revive.png"),
			type = "good"
		})
	end)
end
