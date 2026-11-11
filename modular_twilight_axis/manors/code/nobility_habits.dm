GLOBAL_LIST_INIT(ta_noble_domestic_stressors, list( \
	/datum/stressevent/peckish, \
	/datum/stressevent/hungry, \
	/datum/stressevent/starving, \
	/datum/stressevent/drym, \
	/datum/stressevent/thirst, \
	/datum/stressevent/parched, \
	/datum/stressevent/sleepytime, \
	/datum/stressevent/sewertouched, \
))

GLOBAL_LIST_INIT(ta_noble_tableware, typecacheof(list( \
	/obj/item/reagent_containers/glass/bowl/bronze, \
	/obj/item/reagent_containers/glass/bowl/gold, \
	/obj/item/reagent_containers/glass/bowl/silver, \
	/obj/item/reagent_containers/glass/bowl/carved, \
	/obj/item/reagent_containers/glass/cup/bronzegob, \
	/obj/item/reagent_containers/glass/cup/steel, \
	/obj/item/reagent_containers/glass/cup/glass, \
	/obj/item/reagent_containers/glass/cup/silver, \
	/obj/item/reagent_containers/glass/cup/golden, \
	/obj/item/reagent_containers/glass/cup/ceramic, \
	/obj/item/reagent_containers/glass/cup/carved, \
	/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/silver, \
	/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/blacksteel, \
)))

/datum/stressevent/ta_noble_wet
	timer = 5 SECONDS
	stressadd = 1
	desc = span_red("I ought to get dry. This is most uncomfortable.")

/proc/taNobleExpectsComfort(mob/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/noble = user
	return noble.taAppliedNobilityTier() >= 2

/mob/living/carbon/proc/taCheckNobleSleep(sleep_quality)
	if(!ishuman(src))
		return
	var/poor_bed = sleep_quality < 3
	var/outdoors = !istype(get_area(src), /area/rogue/indoors)
	if(taNobleExpectsComfort(src) && (poor_bed || outdoors))
		add_stress(/datum/stressevent/unlanded_noble_poor_sleep)
	else
		remove_stress(/datum/stressevent/unlanded_noble_poor_sleep)

/obj/item/reagent_containers/glass/proc/taCheckNobleConsumption(
	mob/user,
	served_with_spoon = FALSE,
)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/diner = user
	diner.taCheckNobleDining(src, served_with_spoon)

/datum/stressevent/ta_noble_plain_tableware
	timer = 2 MINUTES
	stressadd = 1
	desc = span_red("Such plain tableware is hardly fitting for my station.")

/mob/living/carbon/human/proc/taUpdateNobleWetness()
	if(
		taAppliedNobilityTier() >= 2 \
		&& has_status_effect(/datum/status_effect/fire_handler/wet_stacks)
	)
		add_stress(/datum/stressevent/ta_noble_wet)
	else
		remove_stress(/datum/stressevent/ta_noble_wet)

/mob/living/carbon/human/proc/taCheckNobleTable()
	if(taAppliedNobilityTier() < 2)
		return
	if(has_table_surface(range(1, src)))
		remove_stress(/datum/stressevent/noble_ate_without_table)
		return
	add_stress(/datum/stressevent/noble_ate_without_table)

/// Only check vessels used at meals, based on what the character is actually
// consuming.
/mob/living/carbon/human/proc/taCheckNobleDining(
	obj/item/reagent_containers/glass/vessel,
	served_with_spoon = FALSE
)
	if(taAppliedNobilityTier() < 2)
		return
	var/is_bowl = istype(vessel, /obj/item/reagent_containers/glass/bowl)
	if(
		!is_bowl \
		&& !istype(vessel, /obj/item/reagent_containers/glass/cup) \
		&& !istype(
			vessel,
			/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard
		)
	)
		return

	var/datum/reagent/main_reagent = vessel.reagents?.get_master_reagent()
	if(istype(main_reagent, /datum/reagent/consumable/soup))
		taCheckNobleTable()
		if(served_with_spoon)
			remove_stress(/datum/stressevent/noble_bad_manners)
		else if(is_bowl)
			add_stress(/datum/stressevent/noble_bad_manners)
	else if(
		served_with_spoon \
		|| (
			!istype(main_reagent, /datum/reagent/water) \
			&& !istype(main_reagent, /datum/reagent/consumable)
		)
	)
		return

	if(!is_type_in_typecache(vessel, GLOB.ta_noble_tableware))
		add_stress(/datum/stressevent/ta_noble_plain_tableware)
