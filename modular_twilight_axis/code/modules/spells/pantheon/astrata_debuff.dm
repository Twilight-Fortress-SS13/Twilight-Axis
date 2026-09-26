#define SCORCH_ASTRATA_ADAPTATION_DURATION (12 SECONDS)
#define SCORCH_ASTRATA_ADAPTATION_KEY "focus_adaptation"
#define SCORCH_ASTRATA_OVERLAY_COLOR rgb(255, 235, 106)
#define SCORCH_ASTRATA_BURN_DAMAGE 30

/obj/effect/temp_visual/focus_flash
	icon = 'icons/mob/OnFire.dmi'
	icon_state = "Generic_mob_burning"
	layer = ABOVE_MOB_LAYER
	duration = 18

/proc/apply_focus_stack(mob/living/target, stacks = 1, zone_override = null,)
	if(!isliving(target))
		return
	new /obj/effect/temp_visual/focus_flash(get_turf(target))
	var/final_tier = 0
	for(var/i in 1 to stacks)
		if(target.has_status_effect(/datum/status_effect/debuff/focused3))
			target.remove_status_effect(/datum/status_effect/debuff/focused3)
			apply_focus_burn(target, zone_override)
			final_tier = 4
			break
		if(target.has_status_effect(/datum/status_effect/debuff/focused2))
			target.remove_status_effect(/datum/status_effect/debuff/focused2)
			target.apply_status_effect(/datum/status_effect/debuff/focused3)
			final_tier = 3
			break
		if(target.has_status_effect(/datum/status_effect/debuff/focused1))
			target.remove_status_effect(/datum/status_effect/debuff/focused1)
			target.apply_status_effect(/datum/status_effect/debuff/focused2)
			final_tier = 2
			continue
		target.apply_status_effect(/datum/status_effect/debuff/focused1)
		final_tier = max(final_tier, 1)
	switch(final_tier)
		if(1)
			target.balloon_alert_to_viewers("<font color='#fff06a'>focused I</font>")
		if(2)
			target.balloon_alert_to_viewers("<font color='#ffb937'>focused II (-1 con)</font>")
		if(3)
			target.balloon_alert_to_viewers("<font color='#ff6117'>focused III (-2 con)</font>")

/proc/apply_focus_burn(mob/living/target, zone_override = null)
	if(!isliving(target))
		return FALSE
	if(target.mob_timers[SCORCH_ASTRATA_ADAPTATION_KEY] && world.time < target.mob_timers[SCORCH_ASTRATA_ADAPTATION_KEY])
		var/remaining = round((target.mob_timers[SCORCH_ASTRATA_ADAPTATION_KEY] - world.time) / 10)
		target.balloon_alert_to_viewers("<font color='#ff8a3d'>fire adapted ([remaining]s)</font>")
		return FALSE
	var/target_zone = prob(50) ? BODY_ZONE_HEAD : BODY_ZONE_CHEST
	var/aimed_zone = zone_override ? check_zone(zone_override) : null
	if(aimed_zone == BODY_ZONE_HEAD || aimed_zone == BODY_ZONE_CHEST)
		target_zone = aimed_zone
	var/mob/living/carbon/carbon_target
	if(iscarbon(target))
		carbon_target = target
		if(target_zone == BODY_ZONE_HEAD && !carbon_target.get_bodypart(BODY_ZONE_HEAD))
			target_zone = BODY_ZONE_CHEST
	target.apply_damage(SCORCH_ASTRATA_BURN_DAMAGE, BURN, target_zone, 0)
	if(carbon_target)
		var/obj/item/bodypart/affecting = carbon_target.get_bodypart(check_zone(target_zone))
		if(affecting)
			var/datum/wound/dynamic/burn/burn_wound = affecting.has_wound(/datum/wound/dynamic/burn)
			if(!burn_wound)
				burn_wound = affecting.add_wound(/datum/wound/dynamic/burn)
			burn_wound?.upgrade(SCORCH_ASTRATA_BURN_DAMAGE, 0, FALSE)
	target.mob_timers[SCORCH_ASTRATA_ADAPTATION_KEY] = world.time + SCORCH_ASTRATA_ADAPTATION_DURATION
	var/hit_zone_name = parse_zone(target_zone)
	target.balloon_alert_to_viewers("<font color='#ff4a2a'>CHARRED!</font>")
	target.visible_message(
		span_boldwarning("Flames burn straight through [target]'s armor, searing a wound deep into the [hit_zone_name]!"),
		span_userdanger("Flames burn straight through my armor, searing a wound deep into my [hit_zone_name]!"))
	playsound(get_turf(target), pick('sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg', 'sound/misc/explode/explosionclose (3).ogg'), 100, TRUE)
	new /obj/effect/temp_visual/fire(get_turf(target))
	new /obj/effect/temp_visual/explosion(get_turf(target))
	return TRUE

/proc/remove_focus_stack(mob/living/target)
	if(!isliving(target))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/focused4))
		target.remove_status_effect(/datum/status_effect/debuff/focused4)
		target.apply_status_effect(/datum/status_effect/debuff/focused3)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/focused3))
		target.remove_status_effect(/datum/status_effect/debuff/focused3)
		target.apply_status_effect(/datum/status_effect/debuff/focused2)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/focused2))
		target.remove_status_effect(/datum/status_effect/debuff/focused2)
		target.apply_status_effect(/datum/status_effect/debuff/focused1)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/focused1))
		target.remove_status_effect(/datum/status_effect/debuff/focused1)
		return TRUE
	return FALSE

/proc/has_focus_stacks(mob/living/target)
	if(!isliving(target))
		return FALSE
	return get_focus_stacks(target) > 0

/proc/get_focus_stacks(mob/living/target)
	if(!isliving(target))
		return 0
	if(target.has_status_effect(/datum/status_effect/debuff/focused4))
		return 4
	if(target.has_status_effect(/datum/status_effect/debuff/focused3))
		return 3
	if(target.has_status_effect(/datum/status_effect/debuff/focused2))
		return 2
	if(target.has_status_effect(/datum/status_effect/debuff/focused1))
		return 1
	return 0

/proc/remove_all_focus_stacks(mob/living/target)
	if(!isliving(target))
		return
	target.remove_status_effect(/datum/status_effect/debuff/focused4)
	target.remove_status_effect(/datum/status_effect/debuff/focused3)
	target.remove_status_effect(/datum/status_effect/debuff/focused2)
	target.remove_status_effect(/datum/status_effect/debuff/focused1)

/datum/status_effect/debuff/focused1
	id = "focused1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/focused1
	duration = 25 SECONDS

/atom/movable/screen/alert/status_effect/debuff/focused1
	name = "Focused"
	desc = "Flames lick at me, but I can shake this off."
	icon_state = "debuff"

/datum/status_effect/debuff/focused1/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_ASTRATA_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/focused1/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_ASTRATA_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/focused2
	id = "focused2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/focused2
	duration = 25 SECONDS
	effectedstats = list(STATKEY_CON = -1)

/atom/movable/screen/alert/status_effect/debuff/focused2
	name = "Focused II"
	desc = "The heat saps the vigor from my flesh."
	icon_state = "debuff"

/datum/status_effect/debuff/focused2/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_ASTRATA_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/focused2/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_ASTRATA_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/focused3
	id = "focused3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/focused3
	duration = 25 SECONDS
	effectedstats = list(STATKEY_CON = -2)

/atom/movable/screen/alert/status_effect/debuff/focused3
	name = "Focused III"
	desc = "The searing burns wrack my body, leaving it frail."
	icon_state = "debuff"

/datum/status_effect/debuff/focused3/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_ASTRATA_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/focused3/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_ASTRATA_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/focused4
	id = "focused4"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/focused4
	duration = 25 SECONDS
	effectedstats = list(STATKEY_CON = -2)

/atom/movable/screen/alert/status_effect/debuff/focused4
	name = "Focused IV"
	desc = "I am utterly consumed by flame - my flesh is searing apart."
	icon_state = "debuff"

/datum/status_effect/debuff/focused4/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_ASTRATA_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/focused4/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_ASTRATA_OVERLAY_COLOR)
	. = ..()

#undef SCORCH_ASTRATA_ADAPTATION_DURATION
#undef SCORCH_ASTRATA_ADAPTATION_KEY
#undef SCORCH_ASTRATA_OVERLAY_COLOR
#undef SCORCH_ASTRATA_BURN_DAMAGE
