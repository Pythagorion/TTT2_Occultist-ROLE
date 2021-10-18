local L = LANG.GetLanguageTableReference("de")

-- GENERAL ROLE LANGUAGE STRINGS
L[OCCULTIST.name] = "Okkultist"
L["info_popup_" .. OCCULTIST.name] = [[Du bist ein Okkultist!
Du hast ein Ritual erfolgreich vollendet. Jetzt kannst du aus dem Totenreich zurückkehren, falls deine HP unter 25 fallen.
Wirst du jedoch geoneshotted, wird das Ritual dich nicht zurückholen können.]]
L["body_found_" .. OCCULTIST.abbr] = "Er war ein Okkultist!"
L["search_role_" .. OCCULTIST.abbr] = "Diese Person war ein Okkultist!"
L["target_" .. OCCULTIST.name] = "Okkultist"
L["ttt2_desc_" .. OCCULTIST.name] = [[Der Okkultist gewinnt zusammen mit den Unschuldigen!]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_role_occultist_popuptitle"] = "Wie ein Phönix, steigt der Okkultist aus seinem flammenden Inferno empor!"

-- F1 MENU: CONVAR EXPLANATIONS
L["label_occultist_receive_buff_to_beginning"] = "Erhalte Buff zu Rundenbeginn"
L["label_occultist_teleport_to_mapspawn"] = "Teleportiere zu zufälligem Spawnpunkt"
L["label_occultist_play_respawn_sound"] = "Spiele Ton während Wiederbelebung"
L["label_occultist_announce_revival_by_popup"] = "Teile Wiederbelebung per Nachricht mit"
L["label_occultist_hide_identity"] = "Zeige 'Unschuldig' statt 'Okkultist'"
L["label_occultist_health_threshold"] = "Schwellenwert um wiederbelebt zu werden"
L["label_occultist_respawn_time"] = "Länge der Respawnzeit (in Sek.)"
L["label_occultist_fire_radius"] = "Radius des Flammen-infernos"
L["label_occultist_fire_damagescale"] = "Schadenswert des Feuers (1 = direkter Tod)"
