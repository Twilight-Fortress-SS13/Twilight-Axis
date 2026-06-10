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

/area/rogue/Entered(mob/living/carbon/human/guy)

	.=..()
	if((src.holy_area == TRUE) && HAS_TRAIT(guy, TRAIT_CLERGY_TA) && !guy.has_status_effect(/datum/status_effect/buff/clergybuff) && !HAS_TRAIT(guy, TRAIT_EXCOMMUNICATED) && !HAS_TRAIT(guy, TRAIT_HERESIARCH))
		guy.apply_status_effect(/datum/status_effect/buff/clergybuff)

/datum/status_effect/buff/mist_form 
	id = "mist_form"
	duration = 6666
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

/atom/movable/screen/alert/status_effect/buff/smartium
	name = "Smartium"
	desc = "My mind expanded!"
	icon = 'modular_twilight_axis/icons/mob/screen_alert.dmi'
	icon_state = "smartium"

/datum/status_effect/buff/smartium
	id = "smartium"
	alert_type = /atom/movable/screen/alert/status_effect/buff/smartium
	effectedstats = list(STATKEY_INT = 5,STATKEY_CON = -2,STATKEY_WIL = -2)
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/corps_dust
	name = "Corps Dust"
	desc = "!"
	icon = 'modular_twilight_axis/icons/mob/screen_alert.dmi'
	icon_state = "body_dust"

/datum/status_effect/buff/corps_dust
	id = "body_dust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/corps_dust
	effectedstats = list(STATKEY_INT = -3,STATKEY_PER = -3,STATKEY_CON = -1,STATKEY_WIL = 2,STATKEY_STR = 1)
	duration = 30 SECONDS
	var/ignor_damage_slowdown = 0
	var/ignor_grab = 0
	var/ignore_slowdown = 0

/datum/status_effect/buff/corps_dust/on_apply()
	. = ..()
	if(owner)
		to_chat(owner, span_warning("AHAHAHA!! AHAHAHAHAHAHAHAH!!!!"))
		if(!HAS_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN))
			ignor_damage_slowdown = 1
			ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
		if(!HAS_TRAIT(owner, TRAIT_GRABIMMUNE))
			ignor_grab = 1
			ADD_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_GENERIC)
		if(!HAS_TRAIT(owner, TRAIT_IGNORESLOWDOWN))
			ignore_slowdown = 1
			ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, TRAIT_GENERIC)
		addtimer(CALLBACK(src, PROC_REF(remove_traits)), 30 SECONDS)
		owner.hallucination = min(owner.hallucination + 10, 50)

/datum/status_effect/buff/corps_dust/proc/remove_traits() //do not remove any owner standart traits. Only drug buffs.
	if(ignor_damage_slowdown == 1)
		REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	if(ignor_grab == 1)
		REMOVE_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_GENERIC)
	if(ignore_slowdown == 1)
		REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, TRAIT_GENERIC)

/datum/status_effect/buff/corps_dust/tick()
	if(owner) //removes all mobility control effects
		if(owner.has_status_effect(/datum/status_effect/incapacitating/stun))
			owner.remove_status_effect(/datum/status_effect/incapacitating/stun)
		if(owner.has_status_effect(/datum/status_effect/incapacitating/knockdown))
			owner.remove_status_effect(/datum/status_effect/incapacitating/knockdown)
		if(owner.has_status_effect(/datum/status_effect/incapacitating/immobilized))
			owner.remove_status_effect(/datum/status_effect/incapacitating/immobilized)
		if(owner.has_status_effect(/datum/status_effect/incapacitating/unconscious))
			owner.remove_status_effect(/datum/status_effect/incapacitating/unconscious)
		if(owner.has_status_effect(/datum/status_effect/incapacitating/sleeping))
			owner.remove_status_effect(/datum/status_effect/incapacitating/sleeping)


/datum/status_effect/buff/corps_dust/on_remove()
	if(owner)
		to_chat(owner, span_notice("Ugh... Whats happen?.."))
	. = ..()

/atom/movable/screen/alert/status_effect/buff/grave_powder
	name = "Grave dust"
	desc = "!"
	icon = 'modular_twilight_axis/icons/mob/screen_alert.dmi'
	icon_state = "grave_dust"

/datum/status_effect/buff/grave_powder
	id = "grave_dust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/grave_powder
	effectedstats = list(STATKEY_INT = -5,STATKEY_CON = -5)
	duration = 10 SECONDS
	var/ignor_damage_slowdown = 0
	var/ignor_grab = 0
	var/ignore_slowdown = 0

/datum/status_effect/buff/grave_powder/on_apply()
	. = ..()
	if(owner)
		to_chat(owner, span_warning("AHAHAHA!! AHAHAHAHAHAHAHAH!!!!"))
		if(owner.cmode)
			return
		if(HAS_TRAIT(owner, TRAIT_IRONMAN))
			return
		owner.hallucination = min(owner.hallucination + 10, 50)

/datum/status_effect/buff/grave_powder/tick()
	if(owner) //heal and immobilize owner
		if(owner.cmode)
			return
		if(HAS_TRAIT(owner, TRAIT_IRONMAN))
			return
		var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_blood(get_turf(owner))
		H.color = "#fbbebe"
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume+5, BLOOD_VOLUME_NORMAL)
		var/list/wCount = owner.get_wounds()
		if(length(wCount))
			owner.heal_wounds(1)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-5, 0)
		owner.adjustFireLoss(-5, 0)
		owner.adjustOxyLoss(-5, 0)
		owner.adjustToxLoss(-5, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5)
		owner.adjustCloneLoss(-5, 0)

/datum/status_effect/buff/grave_powder/on_remove()
	if(owner)
		to_chat(owner, span_notice("Ugh... Whats happen?.."))
	. = ..()

/datum/status_effect/buff/druqks/baotha
	id = "baotha_blessing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/baothablessing

/atom/movable/screen/alert/status_effect/buff/baothablessing
	name = "Baothan Blessing"
	desc = "Baotha has blessed you with immunity to overdose. Rejoice!"
	icon_state = "acid"

/datum/status_effect/buff/druqks/baotha/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_MIRACLE)

/datum/status_effect/buff/druqks/baotha/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_MIRACLE)
	owner.visible_message("[owner]'s eyes appear to return to normal.")

/datum/status_effect/buff/druqks/on_apply()
	. = ..()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			owner.add_stress(/datum/stressevent/high)

/datum/status_effect/buff/druqks/on_remove()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			owner.remove_stress(/datum/stressevent/high)

	. = ..()

//Re-add drug stuff who Lagomorphica remove... Fckret.//
/datum/status_effect/buff/moondust/nextmove_modifier()
	return 0.8

/datum/status_effect/buff/moondust_purest/nextmove_modifier()
	return 0.8

/datum/status_effect/buff/herozium/nextmove_modifier()
	return 1.2

/datum/status_effect/buff/herozium/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/ozium)
	ADD_TRAIT(owner, TRAIT_NOPAIN, id)
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)
	originalcmode = owner.cmode_music
	owner.cmode_music = 'sound/music/combat_ozium.ogg'

/datum/status_effect/buff/herozium/on_remove()
	owner.remove_stress(/datum/stressevent/ozium)
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, id)
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)
	owner.cmode_music = originalcmode
	. = ..()

/datum/status_effect/buff/starsugar/nextmove_modifier()
	return 0.7
//***************************************************//
