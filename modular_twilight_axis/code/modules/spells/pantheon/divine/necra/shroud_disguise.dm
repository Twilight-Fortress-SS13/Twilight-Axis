/datum/status_effect/tranquility_shroud/proc/uses_deadite_mask()
	return mask_active && shroud_mode == TRANQUILITY_SHROUD_MODE_DEADITE

/datum/status_effect/tranquility_shroud/proc/uses_vampire_mask()
	return mask_active && shroud_mode == TRANQUILITY_SHROUD_MODE_VAMPIRE

/datum/status_effect/tranquility_shroud/proc/apply_shroud_disguise()
	if(QDELETED(owner) || !mask_active)
		return
	grant_undead_faction()
	if(uses_deadite_mask())
		grant_deadite_traits()
	if(ishuman(owner) && (uses_deadite_mask() || uses_vampire_mask()))
		apply_skin_disguise()

/datum/status_effect/tranquility_shroud/proc/remove_shroud_disguise()
	if(granted_undead_faction)
		release_undead_faction()
	release_deadite_traits()
	if(ishuman(owner))
		restore_skin_appearance()

/datum/status_effect/tranquility_shroud/proc/grant_undead_faction()
	if(QDELETED(owner) || granted_undead_faction)
		return
	if(!owner.faction)
		owner.faction = list()
	if(FACTION_UNDEAD in owner.faction)
		return
	owner.faction += FACTION_UNDEAD
	granted_undead_faction = TRUE
	owner.notify_faction_change()

/datum/status_effect/tranquility_shroud/proc/release_undead_faction()
	if(!granted_undead_faction)
		return
	if(owner && !QDELETED(owner))
		owner.faction -= FACTION_UNDEAD
		owner.notify_faction_change()
	granted_undead_faction = FALSE

/datum/status_effect/tranquility_shroud/proc/grant_deadite_traits()
	for(var/trait as anything in list(TRAIT_NORUN, TRAIT_ZOMBIE_IMMUNE, TRAIT_ROTMAN, TRAIT_ZOMBIE_SPEECH))
		grant_shroud_trait(trait)

/datum/status_effect/tranquility_shroud/proc/release_deadite_traits()
	if(!granted_shroud_traits)
		return
	for(var/trait as anything in granted_shroud_traits.Copy())
		release_shroud_trait(trait)

/datum/status_effect/tranquility_shroud/proc/grant_shroud_trait(trait)
	if(QDELETED(owner))
		return
	if(!granted_shroud_traits)
		granted_shroud_traits = list()
	if(trait in granted_shroud_traits)
		return
	if(!HAS_TRAIT_FROM(owner, trait, TRANQUILITY_SHROUD_TRAIT_SOURCE))
		ADD_TRAIT(owner, trait, TRANQUILITY_SHROUD_TRAIT_SOURCE)
	granted_shroud_traits += trait

/datum/status_effect/tranquility_shroud/proc/release_shroud_trait(trait)
	if(!granted_shroud_traits || !(trait in granted_shroud_traits))
		return
	if(owner && !QDELETED(owner))
		REMOVE_TRAIT(owner, trait, TRANQUILITY_SHROUD_TRAIT_SOURCE)
	granted_shroud_traits -= trait
	if(!length(granted_shroud_traits))
		granted_shroud_traits = null

/datum/status_effect/tranquility_shroud/proc/apply_skin_disguise()
	var/mob/living/carbon/human/H = owner
	if(!H || cached_appearance)
		return
	cached_appearance = list(
		"skin_tone" = H.skin_tone,
		"original_skin_tone" = H.original_skin_tone,
	)
	if(uses_vampire_mask())
		H.original_skin_tone = H.skin_tone
		H.skin_tone = "c9d3de"
		to_chat(H, span_notice("Моя кожа бледнеет, и чужая холодная тишина прячется под ней."))
		H.update_body()
		return
	if(uses_deadite_mask())
		H.original_skin_tone = H.skin_tone
		H.skin_tone = "78a060"
		to_chat(H, span_notice("Моя кожа принимает зеленоватый мертвенный оттенок."))
		H.update_body()

/datum/status_effect/tranquility_shroud/proc/restore_skin_appearance()
	var/mob/living/carbon/human/H = owner
	if(!H || !cached_appearance)
		cached_appearance = null
		return
	H.skin_tone = cached_appearance["skin_tone"]
	H.original_skin_tone = cached_appearance["original_skin_tone"]
	cached_appearance = null
	if(!QDELETED(H))
		H.update_body()

/datum/status_effect/tranquility_shroud/proc/process_sun_burn()
	if(!uses_vampire_mask())
		vampire_sunlit = FALSE
		return
	if(QDELETED(owner) || owner.stat == DEAD)
		vampire_sunlit = FALSE
		return
	if(GLOB.tod != "day")
		if(vampire_sunlit)
			to_chat(owner, span_notice("Жгучий взор Солнечного Владыки больше не терзает меня."))
		vampire_sunlit = FALSE
		return
	if(!ishuman(owner))
		vampire_sunlit = FALSE
		return
	var/mob/living/carbon/human/H = owner
	if(H.advsetup || !isturf(H.loc))
		vampire_sunlit = FALSE
		return
	var/turf/loc_turf = H.loc
	if(!loc_turf.can_see_sky())
		if(vampire_sunlit)
			to_chat(H, span_notice("Жгучий взор Солнечного Владыки больше не терзает меня."))
		vampire_sunlit = FALSE
		return
	if(HAS_TRAIT(H, TRAIT_WEATHER_PROTECTED))
		if(!vampire_sunlit)
			to_chat(H, span_danger("Я укрыт от гнева Солнечного Владыки."))
		vampire_sunlit = TRUE
		return
	if(!vampire_sunlit)
		to_chat(H, span_danger("Солнечный свет жжёт мою плоть!"))
	vampire_sunlit = TRUE
	H.fire_act(1, TRANQUILITY_SHROUD_SUN_BURN_DAMAGE)
	if(H.on_fire)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon, freak_out)), 0, TIMER_UNIQUE | TIMER_OVERRIDE)

/mob/living/carbon/human/proc/is_face_concealed_for_shroud()
	if(wear_mask && (wear_mask.flags_inv & HIDEFACE))
		return TRUE
	if(head && (head.flags_inv & HIDEFACE))
		return TRUE
	if(wear_neck && (wear_neck.flags_inv & HIDEFACE))
		return TRUE
	return FALSE
