local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[OCCULTIST.name] = "Occultist"
L["info_popup_" .. OCCULTIST.name] = [[You are the Occultist!
You've done a ritual successfully. Now you can get back to life when your HP fall under 25.
If you get one shotted, you're ritual won't take effect.]]
L["body_found_" .. OCCULTIST.abbr] = "They were an Occultist."
L["search_role_" .. OCCULTIST.abbr] = "This person was an Occultist!"
L["target_" .. OCCULTIST.name] = "Occultist"
L["ttt2_desc_" .. OCCULTIST.name] = [[The Occultist needs to win with the innocents!]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_role_occultist_popuptitle"] = "Like a Phoenix, the Occultist rises from their flaming Inferno!"

-- F1 MENU: CONVAR EXPLANATIONS
L["label_occultist_receive_buff_to_beginning"] = "Receive Buff in the round's beginning"
L["label_occultist_teleport_to_mapspawn"] = "Teleport to random map spawn after revival"
L["label_occultist_play_respawn_sound"] = "Play sound during the revival"
L["label_occultist_announce_revival_by_popup"] = "Announce revival through a pop-up"
L["label_occultist_hide_identity"] = "Show 'Innocent' to player instead"
L["label_occultist_health_threshold"] = "HP-Threshold to be revived"
L["label_occultist_respawn_time"] = "length of the respawn time (in secs)"
L["label_occultist_fire_radius"] = "radius of the flaming inferno"
L["label_occultist_fire_damagescale"] = "Damage the fire deals. (1 = instant-kill)"
L["label_occultist_buff_intel"] = "If it's set to true, the occultist will receive the NoFireDamage-Buff in the round´s beginning. Otherwise he will receive it after he was revived."
L["label_occultist_map_tp_intel"] = "If it's set to true, the occultist will be teleported to a random spawnpoint on the map, shortly after his revival."
L["label_occultist_rev_sound_intel"] = "If it's set to true, the revival sound will be played."
L["label_occultist_rev_epop_intel"] = "If it's set to true, the occultist's revival will be announced by a popup in the center of the screen."
L["label_occultist_hide_ident_intel"] = "If it's set to true the occultist's player won't see that he is the occultist. The Innocent-Role will be shown."
L["label_occultist_fire_damage_intel"] = "How much damage shall deal the fire? Note: It scales in decimal. If you set it to 1, the fire will kill instant, when you come too close. Under default settings, it deals 10 damage per tick."
L["label_occultist_fire_radius_intel"] = "How wide shall be the radius of the inferno?"
L["label_occultist_hp_threshold_intel"] = "How many HP must the Occultist lose to get revived?"
L["label_occultist_rev_time_intel"] = "How much time does it take until the Occultist gets revived?"