/datum/reagent/sleep_powder
	name = "sleep powder"
	description = ""
	color = "#ddd3df" // rgb: 96, 165, 132
	metabolization_rate = 1

// TO DO: eventually rewrite drowsyness code to do this instead then it can be expanded
// The reason why I haven't is because vampire lords have some special code for drowsyness I'll ave to get to...
/datum/reagent/sleep_powder/on_mob_metabolize(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/debuff/knockout)
	..()


/obj/item/reagent_containers/powder/sleep_powder
	name = "powder"
	desc = ""
	gender = PLURAL
	icon_state = "flour"
	list_reagents = list(/datum/reagent/sleep_powder = 5)
	grind_results = null
	volume = 10
