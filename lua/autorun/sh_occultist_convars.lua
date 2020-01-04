-- replicated convars have to be created on both client and server
CreateConVar("ttt_occultist_health_threshold", 25, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt_occultist_respawn_time", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt_occultist_fire_radius", 500, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt_occultist_fire_damagescale", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
--CreateConVar("ttt2_occul_ignite_attacker", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_occultist_convars", function(tbl)
	tbl[ROLE_OCCULTIST] = tbl[ROLE_OCCULTIST] or {}

	table.insert(tbl[ROLE_OCCULTIST], {cvar = "ttt_occultist_health_threshold", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt_occultist_health_threshold (def. 25)"})
	table.insert(tbl[ROLE_OCCULTIST], {cvar = "ttt_occultist_respawn_time", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt_occultist_respawn_time (def. 10)"})
	table.insert(tbl[ROLE_OCCULTIST], {cvar = "ttt_occultist_fire_radius", slider = true, min = 1, max = 500, decimal = 0, desc = "ttt_occultist_fire_radius (def. 500)"})
	table.insert(tbl[ROLE_OCCULTIST], {cvar = "ttt_occultist_fire_damagescale", slider = true, min = 0, max = 1, decimal = 2, desc = "ttt_occultist_fire_damagescale (def. 0)"})
end)
