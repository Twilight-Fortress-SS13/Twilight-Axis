/obj/item/rogueweapon/sword/rapier/folding
	name = "pathmaker"
	desc = "Дорогостоющий складной меч, сделанный специально по заказу для \
		десницы. Можно носить как обычный меч в ножнах, так и в сумке \
		или в поясе, если сложить."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/swords64.dmi'
	icon_state = "folding_sword_on"
	var/extended = TRUE

/obj/item/rogueweapon/sword/rapier/folding/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier, /datum/intent/sword/thrust/rapier/lunge)
		force = 22
		wdefense = 7
		update_force_dynamic()
		update_wdefense_dynamic()
		wlength = WLENGTH_NORMAL
		w_class = WEIGHT_CLASS_BULKY
		throwforce = 10
		icon_state = "folding_sword_on"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		sharpness = IS_SHARP
		slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
		equip_delay_self = initial(equip_delay_self)
		unequip_delay_self = initial(unequip_delay_self)
		inv_storage_delay = initial(inv_storage_delay)
	else
		possible_item_intents = list(/datum/intent/sword/strike)
		force = 5
		wlength = WLENGTH_SHORT
		w_class = WEIGHT_CLASS_SMALL
		throwforce = 5
		icon_state = "folding_sword_off"
		attack_verb = list("stubbed", "poked")
		sharpness = IS_BLUNT
		wdefense = 2
		slot_flags = ITEM_SLOT_HIP
		update_force_dynamic()
		update_wdefense_dynamic()
		equip_delay_self = 0 SECONDS
		unequip_delay_self = 0 SECONDS
		inv_storage_delay = 0 SECONDS
	if(user.a_intent)
		var/datum/intent/intent = user.a_intent
		intent.afterchange()
	user.update_a_intents()
	user.update_inv_hands()
