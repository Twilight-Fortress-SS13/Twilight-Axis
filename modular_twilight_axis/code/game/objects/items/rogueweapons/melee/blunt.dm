/datum/intent/mace/strike/tetsubo
	reach = 2

/datum/intent/mace/smash/tetsubo
	reach = 2

/obj/item/rogueweapon/mace/goden/steel/tetsubo
	name = "tetsubo"
	desc = "A heavier variant of the kanabo, fitted with a steel sleeve bearing menacing spikes and favored by Ogre Warlords. Requires immense strength to use, but hits like a raging bull."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/blunt64.dmi'
	icon_state = "tetsubo"
	force = 20
	possible_item_intents = list(/datum/intent/mace/strike/tetsubo)
	gripped_intents = list(/datum/intent/mace/strike/tetsubo, /datum/intent/mace/smash/tetsubo, /datum/intent/effect/daze)
	sharpness = IS_SHARP
	minstr = 11
	slot_flags = ITEM_SLOT_BACK

/obj/item/rogueweapon/knuckledusters/psy/relic
	name = "\"Penance\""
	desc = "Forged in the workshops of Otava from silver-blessed steel, these brutal knuckles were carried by an inquisitor \
	who made a practice of delivering judgement without drawing a blade. The three crowned studs bear the mark of Psydon, \
	and each blow is said to serve as a reminder that faith need not wield a sword to break the bones of the wicked."
	force = 30
	icon = 'modular_twilight_axis/icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "psyknuckle"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	possible_item_intents = list(/datum/intent/mace/smash, /datum/intent/mace/strike/dislocate)

/obj/item/rogueweapon/knuckledusters/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/knuckledusters/psy/relic/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] starts adjusting their grip on [src]."))
	if(do_after(user, 3 SECONDS))
		var/obj/item/rogueweapon/knuckledusters/psy/relic/P = new /obj/item/clothing/gloves/roguetown/knuckles/psydon/relic(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)

		P.obj_integrity = P.max_integrity * (src.obj_integrity / src.max_integrity)
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops adjusting their grip on [src]."))
		return
