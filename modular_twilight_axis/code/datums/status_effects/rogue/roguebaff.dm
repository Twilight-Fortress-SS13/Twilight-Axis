/datum/status_effect/buff/goodloving
	id = "Good Loving"
	alert_type = /atom/movable/screen/alert/status_effect/buff/goodloving
	effectedstats = list("fortune" = 2)
	duration = 60 MINUTES //Note, you can only benefit from this buff ONCE

/atom/movable/screen/alert/status_effect/buff/goodloving
	name = "Good Loving"
	desc = "Some good loving has left me feeling very fortunate."
	icon_state = "stressg"

/atom/movable/screen/alert/status_effect/buff/clergybuff
	name = "Decem Dii Vult"
	desc = "I am a member of this temple, sworn to defend the House of the Ten until my very dying breath."
	icon = 'modular_twilight_axis/icons/mob/screen_alert.dmi'
	icon_state = "tenbless"

/datum/status_effect/buff/clergybuff
	id = "clergybuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/clergybuff
	effectedstats = list(STATKEY_STR = 1,STATKEY_WIL = 2,STATKEY_INT = 1,STATKEY_SPD = 1,STATKEY_CON = 2,STATKEY_LCK = 1)
	var/lastcheck = 0

/datum/status_effect/buff/clergybuff/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.holy_area) && !(world.time < lastcheck + 10 SECONDS))
		lastcheck = world.time
		var/preserve = FALSE
		for(var/turf/T in view(5, owner))
			var/area/rogue/mercyarea = get_area(T)
			if(mercyarea.holy_area)
				preserve = TRUE
		for(var/mob/living/carbon/human/H in view(7, owner))
			if(H.mind?.assigned_role == "Bishop")
				preserve = TRUE
		if(!preserve)
			owner.remove_status_effect(/datum/status_effect/buff/clergybuff)
	
/mob/living/carbon/human
	var/priest_timer_check = 0
	var/matthios_banner_timer_check = 0

/mob/living/carbon/human/Life()
	. = ..()
	if((src.mind?.assigned_role == "Bishop") && !(world.time < priest_timer_check + 10 SECONDS))
		priest_timer_check = world.time
		for(var/mob/living/carbon/human/H in view(7, src))
			if(HAS_TRAIT(H, TRAIT_CLERGY_TA) && !H.has_status_effect(/datum/status_effect/buff/clergybuff))
				H.apply_status_effect(/datum/status_effect/buff/clergybuff)
	if((istype(src.get_inactive_held_item(), /obj/item/rogueweapon/spear/matthios_standard) || istype(src.get_active_held_item(), /obj/item/rogueweapon/spear/matthios_standard)) && !(world.time < matthios_banner_timer_check + 5 SECONDS))
		matthios_banner_timer_check = world.time
		for(var/mob/living/carbon/human/H in view(7, src))
			if(istype(H.patron, /datum/patron/inhumen/matthios))
				H.apply_status_effect(/datum/status_effect/buff/twilight_peoplesbanner)
			else if(HAS_TRAIT(H, TRAIT_NOBLE) || HAS_TRAIT(H, TRAIT_CLERGY_TA))
				H.apply_status_effect(/datum/status_effect/debuff/twilight_peoplesbanner)

/area/rogue/Entered(mob/living/carbon/human/guy)

	.=..()
	if((src.holy_area == TRUE) && HAS_TRAIT(guy, TRAIT_CLERGY_TA) && !guy.has_status_effect(/datum/status_effect/buff/clergybuff) && !HAS_TRAIT(guy, TRAIT_EXCOMMUNICATED) && !HAS_TRAIT(guy, TRAIT_HERESIARCH))
		guy.apply_status_effect(/datum/status_effect/buff/clergybuff)

/datum/status_effect/buff/mist_form 
	id = "mist_form"
	duration = 120
	alert_type = /atom/movable/screen/alert/status_effect/buff/dagger_dash

/datum/status_effect/buff/mist_form/on_apply()
	if(!isliving(owner)) return FALSE
	var/mob/living/L = owner
	
	L.alpha = 100 

	ADD_TRAIT(L, "ethereal", MAGIC_TRAIT)
	ADD_TRAIT(L, TRAIT_PACIFISM, MAGIC_TRAIT)
	ADD_TRAIT(L, TRAIT_GRABIMMUNE, MAGIC_TRAIT)
	ADD_TRAIT(L, TRAIT_PUSHIMMUNE, MAGIC_TRAIT)
	ADD_TRAIT(L, TRAIT_NOSLIPALL, MAGIC_TRAIT)
	ADD_TRAIT(L, TRAIT_SPELLCOCKBLOCK, MAGIC_TRAIT)


	L.status_flags |= GODMODE


	L.density = FALSE 
	

	L.pass_flags |= LETPASSTHROW

	L.pass_flags |= PASSMOB
	
	return ..()

/datum/status_effect/buff/mist_form/on_remove()
	var/mob/living/L = owner
	if(!L) return
	
	L.alpha = 255
	

	L.density = TRUE
	

	REMOVE_TRAIT(L, "ethereal", MAGIC_TRAIT)
	REMOVE_TRAIT(L, TRAIT_PACIFISM, MAGIC_TRAIT)
	REMOVE_TRAIT(L, TRAIT_GRABIMMUNE, MAGIC_TRAIT)
	REMOVE_TRAIT(L, TRAIT_PUSHIMMUNE, MAGIC_TRAIT)
	REMOVE_TRAIT(L, TRAIT_NOSLIPALL, MAGIC_TRAIT)
	REMOVE_TRAIT(L, TRAIT_SPELLCOCKBLOCK, MAGIC_TRAIT)

	L.status_flags &= ~GODMODE
	L.pass_flags &= ~LETPASSTHROW
	L.pass_flags &= ~PASSMOB
	
	..()

/datum/status_effect/buff/magic/strength
	id = "strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/strength
	effectedstats = list("strength" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/strength/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/strength_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/strength_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/strength
	name = "arcane reinforced strength"
	desc = "I am magically strengthened."
	icon_state = "buff"

/datum/status_effect/buff/magic/strength_lesser
	id = "lesser strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/strength/lesser
	effectedstats = list("strength" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/strength_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/strength))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/strength/lesser
	name = "lesser arcane strength"
	desc = "I am magically strengthened."
	icon_state = "buff"


/datum/status_effect/buff/magic/speed
	id = "speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/speed
	effectedstats = list("speed" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/speed/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/speed_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/speed_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/speed
	name = "arcane swiftness"
	desc = "I am magically swift."
	icon_state = "buff"

/datum/status_effect/buff/magic/speed_lesser
	id = "lesser speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/speed/lesser
	effectedstats = list("speed" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/speed_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/speed))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/speed/lesser
	name = "arcane swiftness"
	desc = "I am magically swift."
	icon_state = "buff"

/datum/status_effect/buff/magic/willpower
	id = "willpower"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/willpower
	effectedstats = list("willpower" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/willpower/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/willpower_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/willpower_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/willpower
	name = "arcane willpower"
	desc = "I am magically resilient."
	icon_state = "buff"

/datum/status_effect/buff/magic/willpower_lesser
	id = "lesser willpower"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/willpower/lesser
	effectedstats = list("willpower" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/willpower_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/willpower))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/willpower/lesser
	name = "lesser arcane willpower"
	desc = "I am magically resilient."
	icon_state = "buff"

/datum/status_effect/buff/magic/constitution
	id = "constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/constitution
	effectedstats = list("constitution" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/constitution/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/constitution_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/constitution_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/constitution
	name = "arcane constitution"
	desc = "I feel reinforced by magick."
	icon_state = "buff"

/datum/status_effect/buff/magic/constitution_lesser
	id = "lesser constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/constitution/lesser
	effectedstats = list("constitution" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/constitution_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/constitution))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/constitution/lesser
	name = "lesser arcane constitution"
	desc = "I feel reinforced by magick."
	icon_state = "buff"

/datum/status_effect/buff/magic/perception
	id = "perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/perception
	effectedstats = list("perception" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/perception/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/perception_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/perception_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/perception
	name = "arcane perception"
	desc = "I can see everything."
	icon_state = "buff"

/datum/status_effect/buff/magic/perception_lesser
	id = "lesser perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/perception/lesser
	effectedstats = list("perception" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/perception_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/perception))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/perception/lesser
	name = "lesser arcane perception"
	desc = "I can see somethings."
	icon_state = "buff"
