/*
 * Vitae Acid stamina pressure adapted from Scarlet-Reach/Scarlet-Reach#1616.
 */

/datum/reagent/bloodacid/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(5.5)
			M.adjustToxLoss(7.5)
			M.stamina_add(5)
		else
			M.add_nausea(6.5)
			M.adjustToxLoss(8.5)
			M.stamina_add(7.5)

		to_chat(M, span_userdanger("МОЁ СЕРДЦЕ! МЕНЯ ОТРАВИЛИ!"))
		M.playsound_local('sound/magic/heartbeat.ogg', 50)

	return ..()
