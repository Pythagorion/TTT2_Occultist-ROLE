if SERVER then
	AddCSLuaFile()

	util.PrecacheSound("occultist_revived.wav")

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_occul")
	resource.AddFile("materials/vgui/ttt/hud_icon_occultist_revive.png")

	resource.AddFile("sound/occultist_revived.wav")

	util.AddNetworkString("ttt2_occul_role_epop")
end

sound.Add({
	name = "occultist_respawn",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 160,
	sound = "occultist_revived.wav"
})

function ROLE:PreInitialize()
	self.color                      = Color(15, 67, 54, 255)

	self.abbr                       = "occul"
	self.surviveBonus               = 0
	self.score.killsMultiplier      = 2
	self.score.teamKillsMultiplier  = -8
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
end

if SERVER then
	local function ClearOccultist()
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			ply.occ_data = {}
			ply.occ_data.was_revived = false
			ply.occ_data.allow_revival = false
		end
	end

	-- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		if not GetConVar("ttt_occultist_hide_identity"):GetBool() then
			ply:GiveEquipmentItem("item_ttt_nofiredmg")
		elseif GetConVar("ttt_occultist_receive_buff_to_beginning"):GetBool() then
			ply:GiveEquipmentItem("item_ttt_nofiredmg")
		end
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		if not GetConVar("ttt_occultist_hide_identity"):GetBool() then
			ply:RemoveEquipmentItem("item_ttt_nofiredmg")
		elseif GetConVar("ttt_occultist_receive_buff_to_beginning"):GetBool() then
			ply:RemoveEquipmentItem("item_ttt_nofiredmg")
		end
	end

	hook.Add("TTT2PostPlayerDeath", "ttt2_role_occultist_post_player_death", function(ply)
		if ply:GetSubRole() ~= ROLE_OCCULTIST then return end
		if SpecDM and (ply.IsGhost and ply:IsGhost()) then return end

		-- only respawn when occ respawn was not triggered this round and player crossed revival threashold
		if ply.occ_data.was_revived or not ply.occ_data.allow_revival then return end

		-- store the death posistion
		ply.occ_data.death_pos = ply:GetPos()

		-- cache ConVar values
		local revive_time = GetConVar("ttt_occultist_respawn_time"):GetInt()
		local dmgscale_fire = GetConVar("ttt_occultist_fire_damagescale"):GetInt()
		local fire_radius = GetConVar("ttt_occultist_fire_radius"):GetInt()
		local respawn_sound = GetConVar("ttt_occultist_play_respawn_sound"):GetBool()
		local cv_mapspawn_teleportation = GetConVar("ttt_occultist_teleport_to_mapspawn"):GetBool()
		local cv_sending_epop = GetConVar("ttt_occultist_announce_revival_by_popup"):GetBool()

		-- Gathering all available map-spawnpoints
		local spawnpoints = {}

		spawnpoints = table.Add(spawnpoints, ents.FindByClass("info_player_start"))
		spawnpoints = table.Add(spawnpoints, ents.FindByClass("info_player_deathmatch"))
		spawnpoints = table.Add(spawnpoints, ents.FindByClass("info_player_combine"))
		spawnpoints = table.Add(spawnpoints, ents.FindByClass("info_player_rebel"))

		-- CS Maps
		spawnpoints = table.Add(spawnpoints, ents.FindByClass("info_player_counterterrorist"))
		spawnpoints = table.Add(spawnpoints, ents.FindByClass("info_player_terrorist"))

		-- DOD Maps
		spawnpoints = table.Add(spawnpoints, ents.FindByClass("info_player_axis"))
		spawnpoints = table.Add(spawnpoints, ents.FindByClass("info_player_allies"))

		-- (Old) GMod Maps
		spawnpoints = table.Add(spawnpoints, ents.FindByClass("gmod_player_start"))

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
			-- if convar is set, the occul receives here his no fire damage buff
			if not cv_buff_beginning then
				p:GiveEquipmentItem("item_ttt_nofiredmg")
			end

			-- if convar is set, send a popup to all players
			if cv_sending_epop then
				net.Start("ttt2_occul_role_epop")
				net.Broadcast()
			end

			if cv_mapspawn_teleportation then
				--porting occultist to mapspawn if cvar-boolean is true
				p:SetPos(spawnpoints[math.random(1, #spawnpoints)]:GetPos())
			else
				-- porting the player to his death position
				p:SetPos(p.occ_data.death_pos)
			end

			-- set player HP to 100
			p:SetHealth(p:GetMaxHealth())

			-- set was revived flag
			p.occ_data.was_revived = true

			-- make sound if boolean is true
			if respawn_sound then
				p:EmitSound("occultist_respawn")
			end
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

			-- player HP must hit below a threshold if boolean is false
			if ply:Health() > cv_occul_health_threshold:GetInt() or ply:Health() <= 0 then continue end

			-- set flag to allow revival
			ply.occ_data.allow_revival = true

			-- set status icon
			STATUS:AddStatus(ply, "ttt2_occultist_revival")
		end
	end)

	hook.Add("TTT2SpecialRoleSyncing", "ttt2_occultists_identity_handler", function(ply, tbl)
		if not GetConVar("ttt_occultist_hide_identity"):GetBool() then return end

		for occul in pairs(tbl) do
			if occul:IsTerror() and occul:Alive() and occul:GetSubRole() == ROLE_OCCULTIST then
				if ply == occul then
					tbl[occul] = {ROLE_INNOCENT, TEAM_INNOCENT}
				else
					tbl[occul] = {ROLE_NONE, TEAM_NONE}
				end
			end
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
	net.Receive("ttt2_occul_role_epop", function()
		EPOP:AddMessage({text = LANG.GetTranslation("ttt2_role_occultist_popuptitle"), color = OCCULTIST.ltcolor}, "", 10)
	end)

	hook.Add("Initialize", "ttt2_role_collultist_init", function()
		STATUS:RegisterStatus("ttt2_occultist_revival", {
			hud = Material("vgui/ttt/hud_icon_occultist_revive.png"),
			type = "good"
		})
	end)
end
