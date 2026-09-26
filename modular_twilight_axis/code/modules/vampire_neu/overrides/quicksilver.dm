/obj/item/quicksilver/Initialize()
	. = ..()
	if(type == /obj/item/quicksilver)
		var/obj/item/quicksilver/TA/replacement = new /obj/item/quicksilver/TA(loc)
		replacement.miracle_use = miracle_use
		replacement.success = success
		return INITIALIZE_HINT_QDEL

/obj/item/quicksilver/luxinfused/Initialize()
	. = ..()
	if(type == /obj/item/quicksilver/luxinfused)
		var/obj/item/quicksilver/TA/luxinfused/replacement = new /obj/item/quicksilver/TA/luxinfused(loc)
		replacement.miracle_use = miracle_use
		replacement.success = success
		return INITIALIZE_HINT_QDEL

/obj/item/quicksilver/TA/luxinfused
	name = "absolving silver"
	icon_state = "quicksilverlux"
	desc = "A daring blend of trace amounts of purifying lux, aberrant blood, and divine silver. This panacea fortifies the anointed's body with blessed silverdust, protecting them from the curses of vampyrism and lycanthropy."

/obj/item/quicksilver/TA/anoint(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(ta_find_active_demonic_lord())
		to_chat(user, span_warning("Серебро мертвеет в моих руках - кровавая тьма не даёт ему исцелять."))
		return

	. = ..()
	if(HAS_TRAIT(M, TRAIT_SILVER_BLESSED))
		cleanse_pallid(M, user)

/obj/item/quicksilver/TA/proc/cleanse_pallid(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(!HAS_TRAIT(M, TRAIT_PALLID))
		return

	var/has_generic = HAS_TRAIT_FROM(M, TRAIT_PALLID, TRAIT_GENERIC)

	var/list/sources_to_remove = list()
	if(M.status_traits && M.status_traits[TRAIT_PALLID])
		for(var/source in M.status_traits[TRAIT_PALLID])
			if(source != TRAIT_GENERIC)
				sources_to_remove += source
	for(var/source in sources_to_remove)
		REMOVE_TRAIT(M, TRAIT_PALLID, source)

	var/datum/component/pallid_addiction/addiction = M.GetComponent(/datum/component/pallid_addiction)
	if(addiction)
		qdel(addiction)

	M.remove_status_effect(/datum/status_effect/buff/pallid_blood)
	M.remove_status_effect(/datum/status_effect/buff/pallid_blood/str)
	M.remove_status_effect(/datum/status_effect/buff/pallid_blood/spd)
	M.remove_status_effect(/datum/status_effect/buff/pallid_blood/int)
	M.remove_status_effect(/datum/status_effect/debuff/pallid_withdrawal)

	if(M.mind)
		for(var/obj/effect/proc_holder/spell/self/pallid_sense/S in M.mind.spell_list)
			M.mind.RemoveSpell(S)

	if(has_generic)
		to_chat(M, span_warning("A portion of my curse has been purged, yet the rest runs too deep within my soul and body."))
	else
		to_chat(M, span_notice("The silver sears the curse from my veins! I feel free."))
	to_chat(user, span_notice("The corruption leaves [M]'s body."))
