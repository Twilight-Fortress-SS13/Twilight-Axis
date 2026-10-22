/obj/item/rogueweapon/sword/rapier/psyrapier
	name = "psydonian rapier"
	desc = "An ornate rapier, plated in a ceremonial veneer of silver. The barbs pierce your palm, and - for just a moment - you see red. Never forget that you are why Psydon wept."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "psyrapier"
	sheathe_icon = "silverrapier"
	resistance_flags = FIRE_PROOF
	force = 20
	force_wielded = 20
	is_silver = TRUE

/obj/item/rogueweapon/sword/rapier/psyrapier/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/foldsword
	name = "pathmaker"
	desc = "Дорогостоющий складной меч, сделанный специально по заказу для десницы. Можно носить как обычный меч в ножнах, так и в сумке или в поясе, если сложить."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "folding_sword_on"
	var/extended = FALSE

/obj/item/rogueweapon/sword/rapier/foldsword/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier, /datum/intent/sword/thrust/rapier/lunge)
		wlength = WLENGTH_NORMAL
		w_class = WEIGHT_CLASS_BULKY
		sharpness = IS_SHARP
		slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
		equip_delay_self = initial(equip_delay_self)
		unequip_delay_self = initial(unequip_delay_self)
		inv_storage_delay = initial(inv_storage_delay)
		icon_state = "foldingblade_on"
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
	else
		possible_item_intents = list(/datum/intent/sword/strike)
		wlength = WLENGTH_SHORT
		w_class = WEIGHT_CLASS_SMALL
		sharpness = IS_BLUNT
		slot_flags = ITEM_SLOT_HIP
		equip_delay_self = 0 SECONDS
		unequip_delay_self = 0 SECONDS
		inv_storage_delay = 0 SECONDS
		icon_state = "foldingblade_off"
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	user.update_a_intents()
	update_icon()

/obj/item/rogueweapon/sword/long/kriegmesser/donat_astrata
	name = "her verdict"
	desc = "Wielded by the Paladins of the Punishing Light, these swords are forged from the same alloy of steel and silver used in the Eclipsum blades. While effective on the field of battle, this weapon is primarily known for it's use public executions.</br>'In the light of your rays I stand before you..' </br>'..with my blade raised and my soul bare..' </br>'..let you judge my verdict, and find it true..' </br>'..and let you guide my hand, O Radiant One.'"
	icon = 'modular_twilight_axis/icons/obj/items/donor_weapons_64.dmi'
	icon_state = "ast_kriegmesser"
	sheathe_icon = "bs_swordregal"

/obj/item/rogueweapon/greatsword/grenz/flamberge/relevement
	name = "relevement"
	desc = "The grave wounds caused by flame-bladed swords make them a highly sought-after weapon among the Dark Elves - the charges of dishonorable warfare notwithstanding. Consequentially, these weapons are often wielded by both sides of the Underdark Feud Wars."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "drowflamberge"
	item_state = "drowflamberge"
	max_integrity = 240
	max_blade_int = 240
	smeltresult = /obj/item/ingot/drow

/obj/item/rogueweapon/sword/long/exe/silver
	is_silver = TRUE

/obj/item/rogueweapon/sword/long/exe/berserk
	special = /datum/special_intent/greatsword_swing
	parrysound = list(
		'sound/combat/parry/bladed/bladedlarge (1).ogg',
		'sound/combat/parry/bladed/bladedlarge (2).ogg',
		'sound/combat/parry/bladed/bladedlarge (3).ogg',)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	swingsound = BLADEWOOSH_HUGE
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY

/obj/item/rogueweapon/sword/long/exe/berserk/getonmobprop(tag)
	. = ..()
	if(tag == "altgrip" && .)
		return .
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = 4,"sy" = 0,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/sword/rapier/psy/folding
	name = "psydonian folding blade"
	desc = "A costly folding blade commissioned for the rune volves of the Psydonian Inquisition. Built for investigators and executioners alike, it folds into a compact package for discreet carry before locking into a deadly dueling weapon."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "psyfoldingblade_on"
	sheathe_icon = "silverrapier"
	var/extended = FALSE

/obj/item/rogueweapon/sword/rapier/psy/folding/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier, /datum/intent/sword/thrust/rapier/lunge)
		wlength = WLENGTH_NORMAL
		w_class = WEIGHT_CLASS_BULKY
		sharpness = IS_SHARP
		slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
		equip_delay_self = initial(equip_delay_self)
		unequip_delay_self = initial(unequip_delay_self)
		inv_storage_delay = initial(inv_storage_delay)
		icon_state = "psyfoldingblade_on"
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
	else
		possible_item_intents = list(/datum/intent/sword/strike)
		wlength = WLENGTH_SHORT
		w_class = WEIGHT_CLASS_SMALL
		sharpness = IS_BLUNT
		slot_flags = ITEM_SLOT_HIP
		equip_delay_self = 0 SECONDS
		unequip_delay_self = 0 SECONDS
		inv_storage_delay = 0 SECONDS
		icon_state = "psyfoldingblade_off"
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	user.update_a_intents()
	update_icon()
