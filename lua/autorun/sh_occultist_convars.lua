-- replicated convars have to be created on both client and server
CreateConVar("ttt2_occul_health_threshold", 25, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_occul_respawn_time", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
--CreateConVar("ttt2_occul_ignite_attacker", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_occultist_convars", function(tbl)
	tbl[ROLE_OCCULTIST] = tbl[ROLE_OCCULTIST] or {}

	--table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_take_no_damage", checkbox = true, desc = "ttt_mark_take_no_damage (def. 1)"})
	table.insert(tbl[ROLE_OCCULTIST], {cvar = "ttt2_occul_health_threshold", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt2_occul_health_threshold (def. 25)"})
	table.insert(tbl[ROLE_OCCULTIST], {cvar = "ttt2_occul_respawn_time", slider = true, min = 0, max = 100, decimal = 0, desc = "ttt2_occul_respawn_time (def. 10)"})
	--table.insert(tbl.[ROLE_OCCULTIST], {cvar = "ttt2_occul_ignite_attacker", checkbox = true, desc = "tt2_occul_ignite_attacker (def. true)"})
end)
