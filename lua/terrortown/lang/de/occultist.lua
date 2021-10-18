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
L["label_occultist_buff_intel"] = "Wenn sie auf 'ein' steht, erhält der Okkultist den NoFireDamage-Buff zu Beginn der Runde. Ansonsten erhält er ihn, nachdem er wiederbelebt wurde."
L["label_occultist_map_tp_intel"] = "Wenn sie auf 'ein' steht, wird der Okkultist kurz nach seiner Wiederbelebung zu einem zufälligen Spawnpunkt auf der Karte teleportiert."
L["label_occultist_rev_sound_intel"] = "Wenn sie auf 'ein' steht, wird ein Ton bei der Wiederbelebung abgespielt."
L["label_occultist_rev_epop_intel"] = "Wenn sie auf 'ein' steht, wird die Wiederbelebung des Okkultisten durch ein Popup in der Mitte des Bildschirms angekündigt."
L["label_occultist_hide_ident_intel"] = "Wenn sie auf 'ein' steht, sieht der Spieler des Okkultisten nicht, dass er der Okkultist ist. Die 'Unschuldiger'-Rolle wird stattdessen angezeigt."
L["label_occultist_fire_damage_intel"] = "Wie viel Schaden soll das Feuer anrichten? Hinweis: Die Skalierung erfolgt in Dezimal. Wenn du den Wert auf 1 setzt, tötet das Feuer sofort, wenn du ihm zu nahe kommst. In der Standardeinstellung verursacht es 10 Schaden pro Tick."
L["label_occultist_fire_radius_intel"] = "Wie groß soll der Radius des Infernos sein?"
L["label_occultist_hp_threshold_intel"] = "Wie viele HP muss der Okkultist verlieren, um wiederbelebt zu werden?"
L["label_occultist_rev_time_intel"] = "Wie lange dauert es, bis der Okkultist wiederbelebt wird?"