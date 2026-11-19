/obj/item/rogueweapon/sword/rapier/silver/psy/folding
	name = "psydonic folding blade"
	desc = "A costly folding blade commissioned for the rune volves of the \
		Psydonian Inquisition. Built for investigators and executioners \
		alike, it folds into a compact package for discreet carry before \
		locking into a deadly dueling weapon."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "psyfoldingblade_on"
	sheathe_icon = "silverrapier"
	var/extended = TRUE

/obj/item/rogueweapon/sword/rapier/silver/psy/folding/attack_self(mob/user)
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
		icon_state = "psyfoldingblade_on"
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
		icon_state = "psyfoldingblade_off"
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

/obj/item/rogueweapon/sword/rapier/silver/psy/smallsword
	name = "psydonic smallsword"
	desc = "A slender silver smallsword crafted for swift and precise strikes. \
	Though elegant in form, it was forged with a singular purpose: to pierce both the hearts of men and the blasphemies that lurk beyond them."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "psyrapier"
	sheathe_icon = "silverrapier"
	max_blade_int = 200
	grid_width = 32
	grid_height = 64
	dropshrink = 0
	bigboy = FALSE

/obj/item/rogueweapon/sword/rapier/silver/psy/smallsword/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
	)

/obj/item/rogueweapon/sword/rapier/silver/psy/folding/relic
	name = "\"Testament\""
	desc = "Commissioned by the Inquisition and wrought by the blacksmiths of Arkenfeit, this peculiar blade was made for those \
	who could ill afford to announce their calling before the time came to draw steel. Its silvered edge folds neatly into \
	the hilt, concealing a weapon fit for the most delicate of investigations. Many a heretic has mistaken its bearer for \
	a harmless clerk, only to learn that the Inquisition keeps its sharpest judgements close at hand."
	max_integrity = 300
	max_blade_int = 300

/obj/item/rogueweapon/sword/rapier/silver/psy/folding/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
	)

/obj/item/rogueweapon/huntingknife/idagger/steel/silver/psy/parrying
	name = "psydonic parrying dagger"
	desc = "A finely balanced silver parrying dagger, carried by loyal servants of the Inquisition. \
	Its crossguard turns aside wicked steel while its blessed edge delivers Psydon's judgement."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "psypdagger"
	force = 15
	throwforce = 15
	wdefense = 9
	max_integrity = 150

/obj/item/rogueweapon/huntingknife/idagger/steel/silver/psy/parrying/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
	)
	sellprice += 200

/obj/item/clothing/gloves/roguetown/knuckles/silver/psy/relic
	name = "\"Penance\""
	desc = "Forged in the workshops of Otava from silver-blessed steel, these brutal knuckles were carried by an inquisitor \
	who made a practice of delivering judgement without drawing a blade. The three crowned studs bear the mark of Psydon, \
	and each blow is said to serve as a reminder that faith need not wield a sword to break the bones of the wicked."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "psyknuckle"
	unarmed_bonus = 10

/obj/item/clothing/gloves/roguetown/knuckles/silver/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
	)
