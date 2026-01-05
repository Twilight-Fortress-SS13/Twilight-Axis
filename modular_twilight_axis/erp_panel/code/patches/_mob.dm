
/mob/living
	var/sex_procs_active = FALSE
	
/mob/living/carbon/human
	var/datum/weakref/sex_surrender_ref
	var/datum/sex_organ/body/body_organ

/mob/living/carbon/human/proc/ensure_body_organ()
	if(!body_organ)
		body_organ = new /datum/sex_organ/body(src)
	return body_organ

/mob/living/carbon/human/proc/set_sex_surrender_to(mob/living/carbon/human/mob_object)
	if(mob_object)
		sex_surrender_ref = WEAKREF(mob_object)
	else
		sex_surrender_ref = null

/mob/living/carbon/human/proc/is_surrendering_to(mob/living/carbon/human/mob_object)
	if(!mob_object || !sex_surrender_ref)
		return FALSE

	var/mob/living/carbon/human/target = sex_surrender_ref.resolve()
	if(!target || QDELETED(target))
		sex_surrender_ref = null
		return FALSE

	return target == mob_object

/mob/living/carbon/human/examine(mob/user)
	. = ..()
	var/t = get_sex_examine_text()
	if(t)
		. += "<span class='love_mid'>[t]</span>"

/mob/living/carbon/human/proc/get_sex_examine_text()
	var/list/sessions = return_sessions_with_user_tgui(src)
	if(!length(sessions))
		return null

	var/list/parts = list()
	var/list/active_names = list()

	for(var/datum/sex_session_tgui/session_element in sessions)
		if(!length(session_element.current_actions))
			continue

		var/list/participants = list()

		if(session_element.user && session_element.user != src)
			participants |= session_element.user
		if(session_element.target && session_element.target != src)
			participants |= session_element.target

		for(var/mob/living/carbon/human/mob_object in session_element.partners)
			if(mob_object != src)
				participants |= mob_object

		for(var/mob/living/carbon/human/mob_object in participants)
			if(!(mob_object.name in active_names))
				active_names += mob_object.name

	if(active_names.len)
		parts += "[src] тесно сплетается с [english_list(active_names)]."

	if(has_status_effect(/datum/status_effect/mouth_full))
		parts += "[src] выглядит так, будто рот у [src.p_them()] до краёв чем-то наполнен."

	if(!parts.len)
		return null

	return parts.Join(" ")

/mob/living/carbon/human/proc/get_sex_organs()
	var/list/result = list()
	var/list/seen = list()

	for(var/obj/item/organ/organ_candidate in internal_organs)
		if(organ_candidate.sex_organ && !(organ_candidate.sex_organ in seen))
			seen += organ_candidate.sex_organ
			result += organ_candidate.sex_organ

	for(var/obj/item/bodypart/bodypart_candidate in bodyparts)
		if(!bodypart_candidate.sex_organ)
			continue
		if(bodypart_candidate.sex_organ in seen)
			continue

		if(istype(src, /mob/living/carbon/human/erp_proxy))
			if(!istype(bodypart_candidate, /obj/item/bodypart/head) && !istype(bodypart_candidate, /obj/item/bodypart/head/dullahan))
				continue

			seen += bodypart_candidate.sex_organ
			result += bodypart_candidate.sex_organ
			continue

		seen += bodypart_candidate.sex_organ
		result += bodypart_candidate.sex_organ

	result += legs_organ
	return result


/mob/living/carbon/human/proc/get_sex_organ_by_type(organ_type, only_free = FALSE)
	for(var/datum/sex_organ/organ_candidate in get_sex_organs())
		if(organ_candidate.organ_type != organ_type)
			continue
		if(only_free && (organ_candidate.is_active()))
			continue
		return organ_candidate
	return null

/mob/living/carbon/human/proc/reset_sex_organs_after_sleep()
	for(var/datum/sex_organ/organ_candidate in get_sex_organs())
		if(!organ_candidate)
			continue
		organ_candidate.reset_after_sleep()

/mob/living/carbon/human/handle_sleep()
	. = ..()
	if(IsSleeping())
		reset_sex_organs_after_sleep()

/mob/living/carbon/human/proc/is_sex_node_restrained(node_id)
	if(!node_id)
		return FALSE

	var/id = node_id
	if(istext(id))
		switch(id)
			if(SEX_ORGAN_FILTER_LHAND)  id = SEX_ORGAN_FILTER_LHAND
			if(SEX_ORGAN_FILTER_RHAND)  id = SEX_ORGAN_FILTER_RHAND
			if(SEX_ORGAN_FILTER_LEGS)        id = SEX_ORGAN_FILTER_LEGS
			if(SEX_ORGAN_FILTER_MOUTH)       id = SEX_ORGAN_FILTER_MOUTH

	switch(id)
		if(SEX_ORGAN_FILTER_LHAND)
			if(handcuffed)
				return TRUE

			if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
				return TRUE

			var/obj/item/item_object = get_item_for_held_index(LEFT_HANDS)
			if(item_object && !is_sex_toy(item_object))
				return TRUE

			return FALSE

		if(SEX_ORGAN_FILTER_RHAND)
			if(handcuffed)
				return TRUE

			if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
				return TRUE

			var/obj/item/item_object = get_item_for_held_index(RIGHT_HANDS)
			if(item_object && !is_sex_toy(item_object))
				return TRUE

			return FALSE

		if(SEX_ORGAN_FILTER_LEGS)
			if(legcuffed)
				return TRUE

			return FALSE

		if(SEX_ORGAN_FILTER_MOUTH)
			if(is_mouth_covered())
				return TRUE

			return FALSE

	return FALSE

/mob/living/carbon/human/grippedby(mob/living/carbon/user, instant = FALSE)
	if(is_surrendering_to(user))
		instant = TRUE
		var/old_surrendering = surrendering
		surrendering = TRUE

		. = ..()

		surrendering = old_surrendering
		return .

	. = ..()
	return .

/mob/living/carbon/human/proc/sexpanel_flip(dir_step = 0)
	if(lying)
		if(lying == 270)
			lying = 90
		else
			lying = 270
		update_transform()
		lying_prev = lying

/mob/living/carbon/human/proc/get_mouth_sex_organ()
	var/obj/item/bodypart/head/head_object = get_bodypart(BODY_ZONE_HEAD)
	return head_object?.sex_organ

/mob/living/carbon/human/proc/swallow_from_mouth(amount = 5)
	var/datum/sex_organ/mouth/M = get_sex_organ_by_type(SEX_ORGAN_MOUTH)
	if(!M || !M.has_liquid())
		return FALSE

	var/to_swallow = min(amount, M.total_volume())
	if(to_swallow <= 0)
		return FALSE

	var/list/L = M.stored_liquid.reagent_list.Copy()
	M.drain_uniform(to_swallow)
	for(var/datum/reagent/R in L)
		reagents.add_reagent(R.type, to_swallow)

	visible_message(span_notice("[src] сглатывает."), span_notice("Я проглатываю семя во рту."))
	return TRUE

/mob/living/carbon/human/erp_proxy
	var/obj/item/bodypart/source_part
	
/mob/living/carbon/human/erp_proxy/Initialize(mapload)
	..()
	invisibility = 101
	density = FALSE
	anchored = TRUE
	return INITIALIZE_HINT_NORMAL

/mob/living/carbon/human/erp_proxy/Life(seconds_per_tick)
	return

/obj/item/bodypart/head/dullahan/Destroy()
	. = ..()
	for(var/mob/living/carbon/human/erp_proxy/proxy_object in world)
		if(proxy_object.source_part == src)
			qdel(proxy_object)

/mob/living/proc/start_sex_session_with_dullahan_head(obj/item/bodypart/head/dullahan/head_dullahan)
	var/mob/living/carbon/human/erp_proxy/proxy_object = create_dullahan_head_partner(head_dullahan)

	var/datum/sex_session_tgui/session_object = get_or_create_sex_session_tgui_with_bodypart(src, head_dullahan.original_owner, head_dullahan)
	session_object.add_partner(proxy_object)
	session_object.current_partner_ref = REF(proxy_object)
	session_object.target = proxy_object
	session_object.set_partner_bodypart_override(head_dullahan)

	session_object.ui_interact(src)
	return session_object


/mob/living/carbon/human/proc/apply_soft_arousal(delta = 0.25)
	if(delta <= 0)
		return
	if(cmode)
		return

	SEND_SIGNAL(src, COMSIG_SEX_RECEIVE_ACTION, delta, 0, FALSE, SEX_FORCE_LOW, SEX_SPEED_LOW)

/mob/living/carbon/human/proc/wash_sex_organs_for_clean(clean)
	var/zone = zone_selected
	if(!zone)
		return 0

	var/list/org_types = erp_body_zone_to_organs(zone)
	if(!length(org_types))
		return 0

	var/total_removed = 0

	for(var/candidate in org_types)
		if(candidate == SEX_ORGAN_PENIS || candidate == SEX_ORGAN_BREASTS)
			continue

		var/zone_for_type = sex_organ_to_zone(candidate)
		if(zone_for_type && !can_access_erp_zone(src, src, zone_for_type, FALSE, GRAB_PASSIVE))
			continue

		var/datum/sex_organ/organ_object = get_sex_organ_by_type(candidate, FALSE)
		if(!organ_object || !organ_object.has_storage() || organ_object.total_volume() <= 0)
			continue

		var/removed = organ_object.wash_out()
		if(removed > 0)
			total_removed += removed

	if(total_removed > 0)
		to_chat(src, span_notice("Вода смывает с твоего тела посторонние жидкости."))

	return total_removed

/mob/living/carbon/human/proc/process_sex_organs()
	for(var/datum/sex_organ/O in get_sex_organs())
		if(O)
			O.process_org()

/mob/living/carbon/human/proc/is_lamia_taur()
	if(!islist(bodyparts) || !bodyparts.len)
		return FALSE

	for(var/obj/item/bodypart/taur/lamia/L in bodyparts)
		if(!QDELETED(L))
			return TRUE

	return FALSE

/mob/living/carbon/human/proc/is_dullahan_head_partner()
	if(!istype(src, /mob/living/carbon/human/erp_proxy))
		return FALSE

	var/mob/living/carbon/human/erp_proxy/P = src

	if(!P.source_part || QDELETED(P.source_part))
		return FALSE

	return istype(P.source_part, /obj/item/bodypart/head/dullahan)

/mob/living/carbon/human/proc/is_erp_defiant_in_combat()
	if(cmode && defiant)
		return TRUE

	return FALSE

/mob/living/carbon/human/proc/has_erp_leprosy()
	if(HAS_TRAIT(src, TRAIT_LEPROSY))
		return TRUE

	return FALSE

/mob/living/carbon/human/proc/is_erp_blocked_as_target()
	if(is_erp_defiant_in_combat())
		return TRUE

	if(has_erp_leprosy())
		return TRUE

	return FALSE

/obj/effect/decal/cleanable/coom/milk

/turf/open/floor/onbite(mob/user)	
	if(isliving(user))		
		var/mob/living/L = user		
		if(L.stat != CONSCIOUS)
			return		
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(!C.lying)
				return	
			if(C.is_mouth_covered())
				return
		for(var/obj/effect/decal/cleanable/coom/C in src)
			playsound(user, pick('sound/misc/mat/guymouth (1).ogg','sound/misc/mat/guymouth (2).ogg','sound/misc/mat/guymouth (3).ogg','sound/misc/mat/guymouth (4).ogg','sound/misc/mat/guymouth (5).ogg'), 100, FALSE, ignore_walls = FALSE)
			user.visible_message("<span class='love'>[user] starts cleaning [src].</span>")
			if(do_after(L, 25, target = src))
				playsound(user, pick('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg'), 100, FALSE, ignore_walls = FALSE)
				user.visible_message("<span class='love'>[user] cleaned [src] dilligently.</span>")
				qdel(C)
				user.reagents.add_reagent(/datum/reagent/erpjuice/cum, 5)
			return
		for(var/obj/effect/decal/cleanable/coom/milk/C in src)
			playsound(user, pick('sound/misc/mat/guymouth (1).ogg','sound/misc/mat/guymouth (2).ogg','sound/misc/mat/guymouth (3).ogg','sound/misc/mat/guymouth (4).ogg','sound/misc/mat/guymouth (5).ogg'), 100, FALSE, ignore_walls = FALSE)
			user.visible_message("<span class='love'>[user] starts cleaning [src].</span>")
			if(do_after(L, 25, target = src))
				playsound(user, pick('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg'), 100, FALSE, ignore_walls = FALSE)
				user.visible_message("<span class='love'>[user] cleaned [src] dilligently.</span>")
				qdel(C)
				user.reagents.add_reagent(/datum/reagent/consumable/milk/erp, 5)
			return
		return
	..()

/mob/living/carbon/human/proc/spit_from_mouth(amount = 5)
	var/datum/sex_organ/mouth/M = get_sex_organ_by_type(SEX_ORGAN_MOUTH)
	if(!M || !M.has_liquid())
		return FALSE

	var/to_spit = min(amount, M.total_volume())
	if(to_spit <= 0)
		return FALSE

	M.drain_uniform(to_spit)
	var/turf/T = get_turf(src)
	if(T)
		new /obj/effect/decal/cleanable/coom(T)

	visible_message(span_notice("[src] сплёвывает что-то на пол."),	span_notice("Я сплёвываю содержимое рта."))

	return TRUE

/mob/living/carbon/human/proc/mirror_set_nudeshot_url()
	var/url = input(src, "Paste a direct image URL (http/https).", "Nude Shot URL") as null|text
	if(!url)
		return FALSE

	url = trimtext(url)
	if(length(url) > 512)
		to_chat(src, span_warning("That link is too long."))
		return FALSE

	var/lower = lowertext(url)
	if(!(findtext(lower, "http://") == 1 || findtext(lower, "https://") == 1))
		to_chat(src, span_warning("Only http/https links are allowed."))
		return FALSE

	nsfw_headshot_link = url
	update_body()
	update_body_parts()

	to_chat(src, span_notice("Your reflection settles into a new… compromising portrait."))
	return TRUE
