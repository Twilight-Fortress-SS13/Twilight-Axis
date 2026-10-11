/obj/item/rogueweapon/sword/rapier/folding
	name = "pathmaker"
	desc = "Дорогостоющий складной меч, сделанный специально по заказу для десницы. Можно носить как обычный меч в ножнах, так и в сумке или в поясе, если сложить."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/swords64.dmi'
	icon_state = "folding_sword_on"
	var/extended = FALSE

/obj/item/rogueweapon/sword/rapier/folding/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		force = 22
		wdefense = 7
		update_force_dynamic()
		update_wdefense_dynamic()
		wlength = WLENGTH_NORMAL
		w_class = WEIGHT_CLASS_BULKY
		throwforce = 10
		icon_state = "foldingblade_on"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		sharpness = IS_SHARP
		slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
		equip_delay_self = initial(equip_delay_self)
		unequip_delay_self = initial(unequip_delay_self)
		inv_storage_delay = initial(inv_storage_delay)
	else
		force = 5
		wlength = WLENGTH_SHORT
		w_class = WEIGHT_CLASS_SMALL
		throwforce = 5
		icon_state = "foldingblade_off"
		attack_verb = list("stubbed", "poked")
		sharpness = IS_BLUNT
		wdefense = 2
		slot_flags = ITEM_SLOT_HIP
		update_force_dynamic()
		update_wdefense_dynamic()
		equip_delay_self = 0 SECONDS
		unequip_delay_self = 0 SECONDS
		inv_storage_delay = 0 SECONDS

/obj/item/rogueweapon/sword/long/kriegmesser/donat_astrata
	name = "\"Her Verdict\""
	desc = "Wielded by the Paladins of the Punishing Light, these swords are forged from the same alloy of steel and silver used in the Eclipsum blades. While effective on the field of battle, this weapon is primarily known for it's use public executions.</br>'In the light of your rays I stand before you..' </br>'..with my blade raised and my soul bare..' </br>'..let you judge my verdict, and find it true..' </br>'..and let you guide my hand, O Radiant One.'"
	icon = 'modular_twilight_axis/icons/obj/items/donor_weapons_64.dmi'
	icon_state = "ast_kriegmesser"
	sheathe = 'modular_twilight_axis/icons/obj/items/scabbard.dmi'
	sheathe_icon = "ast_kriegmesser"

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
	name = "psydonic folding blade"
	desc = "A costly folding blade commissioned for the rune volves of the Psydonian Inquisition. Built for investigators and executioners alike, it folds into a compact package for discreet carry before locking into a deadly dueling weapon."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/swords64.dmi'
	icon_state = "psyfoldingblade_on"
	sheathe_icon = "silverrapier"
	var/extended = FALSE

/obj/item/rogueweapon/sword/rapier/psy/folding/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		force = 22
		wdefense = 7
		update_force_dynamic()
		update_wdefense_dynamic()
		wlength = WLENGTH_NORMAL
		w_class = WEIGHT_CLASS_BULKY
		throwforce = 10
		icon_state = "psyfoldingblade_on"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		sharpness = IS_SHARP
		slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
		equip_delay_self = initial(equip_delay_self)
		unequip_delay_self = initial(unequip_delay_self)
		inv_storage_delay = initial(inv_storage_delay)
	else
		force = 5
		wlength = WLENGTH_SHORT
		w_class = WEIGHT_CLASS_SMALL
		throwforce = 5
		icon_state = "psyfoldingblade_off"
		sharpness = IS_BLUNT
		wdefense = 2
		slot_flags = ITEM_SLOT_HIP
		update_force_dynamic()
		update_wdefense_dynamic()
		equip_delay_self = 0 SECONDS
		unequip_delay_self = 0 SECONDS
		inv_storage_delay = 0 SECONDS

/obj/item/rogueweapon/sword/rapier/psy/smallsword
	name = "psydonic smallsword"
	desc = "A slender silver smallsword crafted for swift and precise strikes. \
	Though elegant in form, it was forged with a singular purpose: to pierce both the hearts of men and the blasphemies that lurk beyond them."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/swords32.dmi'
	icon_state = "psysmallsword"
	sheathe = 'modular_twilight_axis/icons/obj/items/scabbard.dmi'
	sheathe_icon = "psysmallsword"
	max_blade_int = 200
	grid_width = 32
	grid_height = 64
	dropshrink = 0
	bigboy = FALSE

/obj/item/rogueweapon/sword/rapier/psy/smallsword/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
	)

/obj/item/rogueweapon/sword/rapier/psy/folding/relic
	name = "\"Testament\""
	desc = "Commissioned by the Inquisition and wrought by the blacksmiths of Arkenfeit, this peculiar blade was made for those \
	who could ill afford to announce their calling before the time came to draw steel. Its silvered edge folds neatly into \
	the hilt, concealing a weapon fit for the most delicate of investigations. Many a heretic has mistaken its bearer for \
	a harmless clerk, only to learn that the Inquisition keeps its sharpest judgements close at hand."
	max_integrity = 300
	max_blade_int = 300

/obj/item/rogueweapon/sword/rapier/psy/folding/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
	)
