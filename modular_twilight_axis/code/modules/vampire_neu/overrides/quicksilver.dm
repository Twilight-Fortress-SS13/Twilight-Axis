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

	var/was_blessed = HAS_TRAIT(M, TRAIT_SILVER_BLESSED)
	. = ..()
	if(!was_blessed && !QDELETED(M) && HAS_TRAIT_FROM(M, TRAIT_SILVER_BLESSED, POULTICE_TRAIT))
		cleanse_pallid(M, user)

/obj/item/quicksilver/TA/proc/cleanse_pallid(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(!HAS_TRAIT(M, TRAIT_PALLID))
		return

	M.ta_clear_pallid_curse()

	if(HAS_TRAIT(M, TRAIT_PALLID))
		to_chat(M, span_warning("A portion of my curse has been purged, yet the rest runs too deep within my soul and body."))
	else
		to_chat(M, span_notice("The silver sears the curse from my veins! I feel free."))
	to_chat(user, span_notice("The corruption leaves [M]'s body."))
