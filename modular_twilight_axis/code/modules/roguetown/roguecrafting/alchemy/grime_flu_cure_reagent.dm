// THE GRIME-FLU CURE REAGENT

/datum/reagent/medicine/grime_flu_cure
	name = "The Grime-Flu cure"
	description = "A herbal tonic that helps the body purge the illness."
	reagent_state = LIQUID
	color = "#7cbf6f"
	taste_description = "bitter herbs"
	scent_description = "crushed leaves"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM

/datum/reagent/medicine/grime_flu_cure/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		for(var/thing in M.diseases)
			var/datum/disease/grime_flu/D = thing
			if(istype(D) && prob(10))
				if(D.stage > 1)
					var/target_stage = max(D.stage - 1, 1)
					D.update_stage(target_stage)
					D.apply_stage_effects(M, D.stage)
					to_chat(M, span_notice("My fever eases, but I still feel ill."))
				else
					D.cure()
					to_chat(M, span_notice("I feel my fever begin to break."))
				break
	..()
	. = 1
