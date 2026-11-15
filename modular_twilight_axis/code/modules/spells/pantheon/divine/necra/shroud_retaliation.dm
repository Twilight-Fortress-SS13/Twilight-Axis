#define TRANQUILITY_SHROUD_RETALIATION_FIRE_STACKS 6
#define TRANQUILITY_SHROUD_RETALIATION_DURATION 5 SECONDS

/datum/status_effect/tranquility_shroud/proc/trigger_shroud_retaliation(mob/living/undead_source)
	if(!protection_active)
		return FALSE
	protection_active = FALSE
	update_shroud_visuals()
	if(retaliation_used)
		return FALSE
	if(shroud_mode != TRANQUILITY_SHROUD_MODE_RESTLESS || shroud_tier < CLERIC_T1)
		return FALSE
	if(owner && !QDELETED(owner) && HAS_TRAIT(owner, TRAIT_GRAVEROBBER))
		return FALSE
	if(QDELETED(undead_source) || undead_source.stat == DEAD)
		return FALSE
	if(!isliving(undead_source))
		return FALSE
	retaliation_used = TRUE
	var/turf/undead_turf = get_turf(undead_source)
	playsound(undead_turf, 'sound/magic/whiteflame.ogg', 60, TRUE)
	new /obj/effect/temp_visual/explosion(undead_turf)
	undead_source.Stun(TRANQUILITY_SHROUD_RETALIATION_DURATION)
	undead_source.adjust_fire_stacks(TRANQUILITY_SHROUD_RETALIATION_FIRE_STACKS, /datum/status_effect/fire_handler/fire_stacks/divine)
	undead_source.ignite_mob()
	if(owner && !QDELETED(owner))
		to_chat(owner, span_notice("Оберег Некры вспыхивает белым светом, оглушая и поджигая напавшую нежить."))
		owner.visible_message(span_warning("Бледный оберег вокруг [owner] взрывается белым пламенем, охватывая [undead_source]!"))
	return TRUE

#undef TRANQUILITY_SHROUD_DURATION
#undef TRANQUILITY_SHROUD_APPLY_TIME
#undef TRANQUILITY_SHROUD_FORGET_RANGE
#undef TRANQUILITY_SHROUD_TRAIT_SOURCE
#undef TRANQUILITY_SHROUD_MODE_RESTLESS
#undef TRANQUILITY_SHROUD_MODE_DEADITE
#undef TRANQUILITY_SHROUD_MODE_VAMPIRE
#undef TRANQUILITY_SHROUD_SUN_BURN_DAMAGE
#undef TRANQUILITY_SHROUD_RETALIATION_FIRE_STACKS
#undef TRANQUILITY_SHROUD_RETALIATION_DURATION
