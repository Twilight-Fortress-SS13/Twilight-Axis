/*
 * Vitae Acid stamina pressure adapted from Scarlet-Reach/Scarlet-Reach#1616.
 */

/*
 * Deliberately does NOT call ..() here. This is a same-type redefinition of
 * /datum/reagent/bloodacid/on_mob_life, which upstream (code/.../reagents.dm,
 * never touched by TA) already defines with its own damage application and
 * its own English poison message. Chaining into it via ..() would double
 * both the damage and the message every tick. Instead this replicates only
 * the piece of the true generic /datum/reagent/proc/on_mob_life that
 * bloodacid actually needs: metabolizing the reagent away over time.
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

	current_cycle++
	if(holder)
		if(M.client)
			record_featured_object_stat(FEATURED_STATS_DRINKS, name, metabolization_rate)
		holder.remove_reagent(type, metabolization_rate)
	return TRUE

/datum/reagent/bloodacid/on_mob_add(mob/living/L)
	. = ..()
	to_chat(L, span_userdanger("МОЁ СЕРДЦЕ! МЕНЯ ОТРАВИЛИ!"))
	L.playsound_local('sound/magic/heartbeat.ogg', 50)
