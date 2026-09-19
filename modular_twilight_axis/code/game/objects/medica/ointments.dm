/obj/item/ointment
	name = "debug ointment"
	icon = 'modular_twilight_axis/icons/roguetown/items/ointments.dmi'
	icon_state = "ointment_empty"
	desc = "WTF man?"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	obj_flags = null
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_HIP
	body_parts_covered = null
	experimental_onhip = FALSE //rip
	max_integrity = 20
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = TRUE
	var/treatment_speed = 7 SECONDS
	var/brute = 0
	var/burn = 0
	var/wound = 0

/obj/item/ointment/attack(mob/living/M, mob/user)

	ointment(M, user)

/obj/item/ointment/proc/ointment(mob/living/M, mob/user)
	var/used_time = treatment_speed
	var/medskill = 0

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		medskill = human_user.get_skill_level(/datum/skill/misc/medicine)
		used_time -= ((medskill * 10) + (human_user.STASPD / 2)) //With 20 SPD you can insta bandage at max medicine.

	if(istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal_patient = M
		if(!animal_patient.bruteloss)
			to_chat(user, span_warning("[animal_patient] doesn't need bandaging right now."))
			return
		playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
		if(!move_after(user, used_time, target = animal_patient))
			return
		playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
		animal_patient.adjustHealth(-((animal_patient.maxHealth / 5) * (medskill + 1)), TRUE)
		user.visible_message(span_notice("[user] bandages [M]'s wounds."), span_notice("I bandage [M]'s wounds."))
		// clear all the wounds
		for(var/datum/wound/wound as anything in animal_patient.get_wounds())
			qdel(wound)
		qdel(src)
		return

	if(!M.can_inject(user, TRUE))
		return

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M
	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(!affecting)
		return

	if(!get_location_accessible(H,  check_zone(affecting)))
		to_chat(user, span_warning("I need to see their [affecting] to heal it!"))
		return

	playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
	if(!move_after(user, used_time, target = M))
		return
	playsound(loc, 'modular/Neu_Food/sound/kneading_alt.ogg', 100, FALSE)

	user.dropItemToGround(src)
	var/obj/item/bowl = new /obj/item/reagent_containers/glass/bowl (get_turf(user))
	user.put_in_hands(bowl)
	if(affecting && (affecting.heal_damage(burn, brute, required_status = BODYPART_ORGANIC)))
		H.update_damage_overlays()
	if(affecting && (affecting.heal_wounds(wound)))
		H.update_damage_overlays()

	if(M == user)
		user.visible_message(span_notice("[user] bandages [user.p_their()] [affecting]."), span_notice("I bandage my [affecting.name]."))
	else
		user.visible_message(span_notice("[user] bandages [M]'s [affecting]."), span_notice("I bandage [M]'s [affecting.name]."))
	qdel(src)

/obj/item/ointment/brute
	name = "calendula ointment"
	icon_state = "ointment_brute"
	desc = "Gelatinous mass of distilled viscera, ashes and calendula extract. Heals bruises, relieves swelling and other brute injuries."
	brute = 50
	wound = 5

/obj/item/ointment/brute/t2
	name = "caleleaf ointment"
	icon_state = "ointment_brute_2"
	desc = "A mixture of viscera, calendula, and marsh leaf extract elements with additives of pure ground salt. It has truly magical healing properties, expelling hematomas and relieving internal injuries. As a side effect, it also heals minor burns."
	brute = 100
	burn = 20
	wound = 10

/obj/item/ointment/burn
	name = "taraxacum ointment"
	icon_state = "ointment_burn"
	desc = "An oily thick liquid made from distilled viscera and taraxium extract. It has healing properties, relieving burns on the extremity."
	burn = 50

/obj/item/ointment/burn/t2
	name = "taraxaleaf ointment"
	icon_state = "ointment_burn_2"
	desc = "A mass of a mixture of viscera, taraxium extract, to which dried westeleaf and pure salt were added. Cleanses dead flesh from fresh burns, completely miraculously sealing them. As a side effect, it will get rid of calluses and other minor rough damages."
	burn = 100
	brute = 20

/obj/item/ointment/wound
	name = "leech ointment"
	icon_state = "ointment_wound"
	desc = "A modified ointment formula based on calendula extract, with a squeeze of marsh leech. It seals bleeding wounds, fuses minor fractures and ruptured arteries. It is believed that her formula is a gift from Pestra to gifted alchemists and doctors."
	wound = 50

/obj/item/ointment/wound/t2
	name = "caleechtar ointment"
	icon_state = "ointment_wound_2"
	desc = "A blessed ointment based on leech extract, with the addition of taraxium. The perfect apotheosis of field medicine, sent down by the martyr goddess. Heals any wound on a limb in a miraculous way, healing abrasions and burns as a side effect."
	wound = 100
	burn = 50
	brute = 50

/obj/item/storage/belt/rogue/pouch/t1_oint
	populate_contents = list(
	/obj/item/ointment/brute,
	/obj/item/ointment/burn,
	/obj/item/ointment/wound,
	/obj/item/ointment/wound
	)

/obj/item/storage/belt/rogue/pouch/t2_oint
	populate_contents = list(
	/obj/item/ointment/brute/t2,
	/obj/item/ointment/burn/t2,
	/obj/item/ointment/wound/t2,
	/obj/item/ointment/wound/t2
	)
