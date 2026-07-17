/*
 * Blood starvation rebalance adapted from Scarlet-Reach/Scarlet-Reach#1840.
 *
 * Uses TA-specific thresholds and statuses so vampire vitae hunger does not
 * collide with the generic hydration debuffs.
 */

#define TA_VITAE_LEVEL_STARVING 300
#define TA_VITAE_LEVEL_HUNGRY 750
#define TA_VITAE_LEVEL_FED 1000

/datum/status_effect/debuff/ta_bloodstarved
	id = "ta_bloodstarved"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_bloodstarved
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -1)
	duration = -1
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/ta_bloodstarved
	name = "Кровавый голод"
	desc = "Голод пульсирует внутри меня."
	icon_state = "bleed1"

/datum/status_effect/debuff/ta_bloodstarved/worse
	id = "ta_bloodstarved_worse"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_bloodstarved/worse
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -2, STATKEY_CON = -1)

/atom/movable/screen/alert/status_effect/debuff/ta_bloodstarved/worse
	name = "Кровавый голод"
	desc = "Голод внутри меня неистово кричит."
	icon_state = "bleed2"

/datum/status_effect/debuff/ta_bloodstarved/worst
	id = "ta_bloodstarved_worst"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_bloodstarved/worst
	effectedstats = list(STATKEY_STR = -3, STATKEY_SPD = -3, STATKEY_CON = -2)

/atom/movable/screen/alert/status_effect/debuff/ta_bloodstarved/worst
	name = "Кровавый голод"
	desc = "Я едва могу двигаться. Этот голод бесконечен."
	icon_state = "bleed3"

/mob/living/carbon/human/handle_bloodpool_effects()
	// Clear the old hydration statuses in case this mob was processed by the
	// upstream implementation before the modular override became active.
	remove_status_effect(/datum/status_effect/debuff/thirstyt1)
	remove_status_effect(/datum/status_effect/debuff/thirstyt2)
	remove_status_effect(/datum/status_effect/debuff/thirstyt3)

	switch(bloodpool)
		if(TA_VITAE_LEVEL_FED to INFINITY)
			remove_status_effect(/datum/status_effect/debuff/ta_bloodstarved)
			remove_status_effect(/datum/status_effect/debuff/ta_bloodstarved/worse)
			remove_status_effect(/datum/status_effect/debuff/ta_bloodstarved/worst)
		if(TA_VITAE_LEVEL_HUNGRY to TA_VITAE_LEVEL_FED)
			apply_status_effect(/datum/status_effect/debuff/ta_bloodstarved)
			remove_status_effect(/datum/status_effect/debuff/ta_bloodstarved/worse)
			remove_status_effect(/datum/status_effect/debuff/ta_bloodstarved/worst)
		if(TA_VITAE_LEVEL_STARVING to TA_VITAE_LEVEL_HUNGRY)
			apply_status_effect(/datum/status_effect/debuff/ta_bloodstarved/worse)
			remove_status_effect(/datum/status_effect/debuff/ta_bloodstarved)
			remove_status_effect(/datum/status_effect/debuff/ta_bloodstarved/worst)
		if(-INFINITY to TA_VITAE_LEVEL_STARVING)
			apply_status_effect(/datum/status_effect/debuff/ta_bloodstarved/worst)
			remove_status_effect(/datum/status_effect/debuff/ta_bloodstarved)
			remove_status_effect(/datum/status_effect/debuff/ta_bloodstarved/worse)
			if(prob(3))
				playsound(get_turf(src), pick('sound/vo/hungry1.ogg', 'sound/vo/hungry2.ogg', 'sound/vo/hungry3.ogg'), 100, TRUE, -1)

	if(bloodpool < 100 && prob(9))
		if(last_frenzy_check + 5 MINUTES < world.time)
			rollfrenzy()

#undef TA_VITAE_LEVEL_STARVING
#undef TA_VITAE_LEVEL_HUNGRY
#undef TA_VITAE_LEVEL_FED
