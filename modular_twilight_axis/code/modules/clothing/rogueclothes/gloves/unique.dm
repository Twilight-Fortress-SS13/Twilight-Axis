/obj/item/clothing/gloves/roguetown/knuckles/silver/psy/relic
	name = "\"Penance\""
	desc = "Forged in the workshops of Otava from silver-blessed steel, these brutal knuckles were carried by an inquisitor \
	who made a practice of delivering judgement without drawing a blade. The three crowned studs bear the mark of Psydon, \
	and each blow is said to serve as a reminder that faith need not wield a sword to break the bones of the wicked."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "psyknuckle"
	unarmed_bonus = 10

/obj/item/clothing/gloves/roguetown/knuckles/silver/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
	)

/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic
	name = "\"Penance\""
	desc = "Forged in the workshops of Otava from silver-blessed steel, these brutal knuckles were carried by an inquisitor \
	who made a practice of delivering judgement without drawing a blade. The three crowned studs bear the mark of Psydon, \
	and each blow is said to serve as a reminder that faith need not wield a sword to break the bones of the wicked."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "psyknuckledusters"
	unarmed_bonus = 10

/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] starts adjusting their grip on [src]."))
	if(do_after(user, 3 SECONDS))
		var/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic/P = new /obj/item/rogueweapon/knuckledusters/psy/relic(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		P.obj_integrity = P.max_integrity * (src.obj_integrity / src.max_integrity)
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops adjusting their grip on [src]."))
		return
