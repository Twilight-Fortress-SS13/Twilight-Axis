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
	special = /datum/special_intent/wave_swing/greatsword
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

/obj/item/rogueweapon/sword/long/oathbreaker_matthios
	name = "\"Kingslayer\""
	desc = "The blade seems to be forged of pure gold, yet it cuts and blocks just as well as any steel blade would. </br>'Rise, now, stand and fight! Take your freedom, claim your right!' </br>'Rise, now, stand and sing! Storm the castle, kill the king!'"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "oathbreakersword"
	item_state = "oathbreakersword"
	//sheathe_icon = "oathbreakersword" //Когда замержат #1569, буду это делать
	force = 35
	force_wielded = 40
	max_blade_int = 400
	max_integrity = 500
	equip_delay_self = 0
	unequip_delay_self = 0
	wdefense_wbonus = 7
	smeltresult = null
	possible_item_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/chop/falx, /datum/intent/sword/strike, /datum/intent/rend/krieg)
	gripped_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/thrust/long/deep, /datum/intent/sword/strike, /datum/intent/rend/krieg)
	alt_grips = list(/datum/alt_grip/mordhau/sword/lesser, /datum/alt_grip/halfsword/lesser)
	special = /datum/special_intent/kingslayer_peoples_judgement

/obj/item/rogueweapon/sword/long/oathbreaker_matthios/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_OATHBREAKER, "SWORD")

/obj/item/rogueweapon/sword/long/oathbreaker_matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_WEAPON)

/datum/special_intent/kingslayer_peoples_judgement
	name = "People's Judgement"
	desc = "Удар с широким замахом, задевающий всех противников перед паладином и обжигающий их. Если цель принадлежит к благородной крови, то она будет подожжена священным огнем Маттиоса; если цель хранит при себе много богатств, она будет оглушена."
	tile_coordinates = list(
				list(-1,0), list(0,0), list(1,0),
	list(-2,1),	list(-1,1), list(0,1), list(1,1), list(2,1)
	)
	post_icon_state = "sweep_fx"
	sfx_pre_delay = 'sound/combat/parry/bladed/bladedsmall (3).ogg'
	sfx_post_delay = 'sound/magic/fireball.ogg'
	use_clickloc = FALSE
	respect_adjacency = TRUE
	respect_dir = TRUE
	delay = 0.6 SECONDS
	cooldown = 60 SECONDS
	stamcost = 25
	var/dam
	var/list/hit_targets

	var/list/matthios_cries = list(
		"Маттиос, узри виновных!",
		"Отец Свободы покарает тебя! Гори!",
		"Товарищи, низвергнем же наш приговор!",
		"Пусть воля народа рассудит вас!"
	)

/datum/special_intent/kingslayer_peoples_judgement/npc_use_chance(mob/living/user, atom/target)
	return npc_front_chance(user)

/datum/special_intent/kingslayer_peoples_judgement/process_attack()
	var/obj/item/rogueweapon/W = iparent
	dam = W.force_dynamic * 1.2 * 0.8 * max(((howner.STASTR + howner.STAWIL) / 20), 1)
	. = ..()

/datum/special_intent/kingslayer_peoples_judgement/post_delay(list/turfs)
	var/obj/item/rogueweapon/W = iparent
	if(QDELETED(howner) || QDELETED(W) || howner.get_active_held_item() != W)
		return
	var/list/visible_turfs = view(2, howner)
	hit_targets = list()
	. = ..(turfs & visible_turfs)
	hit_targets = null

/datum/special_intent/kingslayer_peoples_judgement/on_create()
	. = ..()
	howner.Immobilize(1 SECONDS)
	howner.apply_status_effect(/datum/status_effect/debuff/clickcd, 1 SECONDS)
	howner.say(pick(matthios_cries))

/datum/special_intent/kingslayer_peoples_judgement/apply_hit(turf/T)
	for(var/mob/living/L in T)
		if(L == howner || (L in hit_targets))
			continue
		hit_targets += L
		apply_generic_weapon_damage(L, dam, "fire", get_aimed_zone(L), bclass = BCLASS_CUT)
		if(QDELETED(L))
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/target = L
			if(HAS_TRAIT(target, TRAIT_NOBLE))
				target.visible_message(span_danger("[L] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
				target.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/divine)
				target.ignite_mob()
				playsound(target, 'sound/magic/churn.ogg', 100, TRUE)
			var/mammonsonperson = get_mammons_in_atom(target)
			var/mammonsinbank = SStreasury.get_balance(target)
			var/totalvalue = mammonsinbank + mammonsonperson
			if(totalvalue <=100)
				return TRUE
			if(totalvalue <=150)
				target.Immobilize(1 SECONDS)
				return TRUE
			if(totalvalue <=300)
				target.Immobilize(2 SECONDS)
				return TRUE
			else
				target.Immobilize(4 SECONDS)
				return TRUE
	..()

/obj/item/rogueweapon/sword/sabre/threaded
	name = "threaded sword"
	desc = "Изумительное творение неизвестного мастера. В тонком клинке проложена тонкая стальная нить, что при желании владельца способна вытянуть клинок вперёд, превращая оный в смертоносную плеть. Жаль, что он довольно хрупок.."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "cane_sword"
	sheathe_icon = "swordcande"
	smeltresult = /obj/item/ingot/bronze
	max_blade_int = 200
	bigboy = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	var/transformed = FALSE

/obj/item/rogueweapon/sword/sabre/threaded/attack_self(mob/user)
	transformed = !transformed
	playsound(src.loc, 'sound/combat/armor_degrade_chain3.ogg', 50, TRUE)
	if(transformed)
		possible_item_intents = list(/datum/intent/whip/lash/master, /datum/intent/whip/crack, /datum/intent/whip/punish)
		force = 20
		throwforce = 5
		wdefense = 3
		icon_state = "cane_whip"
		attack_verb = list("lashes", "cracks")
		sharpness = IS_BLUNT
		swingsound = WHIPWOOSH
		update_force_dynamic()
		update_wdefense_dynamic()
		associated_skill = /datum/skill/combat/whipsflails
		special = /datum/special_intent/whip_coil
	else
		possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/sword/strike)
		force = 22
		throwforce = 10
		wdefense = 7
		icon_state = "cane_sword"
		attack_verb = list("cuts", "slashes")
		sharpness = IS_SHARP
		swingsound = BLADEWOOSH_SMALL
		update_force_dynamic()
		update_wdefense_dynamic()
		associated_skill = /datum/skill/combat/swords
		special = /datum/special_intent/shin_swipe

	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	user.update_a_intents()

/obj/item/rogueweapon/sword/sabre/threaded/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -16,"sy" = -10,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 101,"wturn" = -60,"eturn" = -32,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)

/obj/item/rogueweapon/sword/sabre/threaded/silver
	name = "silver threaded sword"
	desc = "Изумительное творение неизвестного мастера. В тонком клинке проложена тонкая стальная нить, что при желании владельца способна вытянуть клинок вперёд, превращая оный в смертоносную плеть. Жаль, что он довольно хрупок.."
	icon_state = "cane_sword_s"
	smeltresult = /obj/item/ingot/silver
	transformed = FALSE
	is_silver = TRUE

/obj/item/rogueweapon/sword/sabre/threaded/silver/attack_self(mob/user)
	transformed = !transformed
	playsound(src.loc, 'sound/combat/armor_degrade_chain3.ogg', 50, TRUE)
	if(transformed)
		possible_item_intents = list(/datum/intent/whip/lash/master, /datum/intent/whip/crack, /datum/intent/whip/punish)
		force = 20
		throwforce = 5
		wdefense = 3
		icon_state = "cane_whip_s"
		attack_verb = list("lashes", "cracks")
		sharpness = IS_BLUNT
		swingsound = WHIPWOOSH
		update_force_dynamic()
		update_wdefense_dynamic()
		associated_skill = /datum/skill/combat/whipsflails
		special = /datum/special_intent/whip_coil
	else
		possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/sword/strike)
		force = 22
		throwforce = 10
		wdefense = 7
		icon_state = "cane_sword_s"
		attack_verb = list("cuts", "slashes")
		sharpness = IS_SHARP
		swingsound = BLADEWOOSH_MED
		update_force_dynamic()
		update_wdefense_dynamic()
		associated_skill = /datum/skill/combat/swords
		special = /datum/special_intent/shin_swipe

	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	user.update_a_intents()

/obj/item/rogueweapon/scabbard/sword/cane_bb
	name = "cane sheath"
	desc = "A piece of steel lined with wood. Great for batting away blows."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "cane_sheath"
	item_state = "cane_sheath"
	force = 10
	bigboy = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	valid_blade = /obj/item/rogueweapon/sword/sabre/threaded
	possible_item_intents = list(SHIELD_BASH, SHIELD_SMASH)
	can_parry = TRUE
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/carpentry
	wdefense = 5
	special = /datum/special_intent/limbguard
	slot_flags = NONE
	cant_strip = TRUE
	max_integrity = 100

/obj/item/rogueweapon/scabbard/sword/cane_bb/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -11,"sy" = -11,"nx" = 11,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 1,"ey" = -10,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = -110,"wturn" = 0,"eturn" = 109,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/sword/long/kriegmesser/donat_astrata
	name = "\"Her Verdict\""
	desc = "Wielded by the Paladins of the Punishing Light, these swords are forged from the same alloy of steel and silver used in the Eclipsum blades. While effective on the field of battle, this weapon is primarily known for it's use public executions.</br>'In the light of your rays I stand before you..' </br>'..with my blade raised and my soul bare..' </br>'..let you judge my verdict, and find it true..' </br>'..and let you guide my hand, O Radiant One.'"
	icon = 'modular_twilight_axis/icons/obj/items/donor_weapons_64.dmi'
	icon_state = "ast_kriegmesser"
	sheathe = 'modular_twilight_axis/icons/obj/items/scabbard.dmi'
	sheathe_icon = "ast_kriegmesser"

/obj/item/rogueweapon/sword/rapier/silver/psy/smallsword
	sheathe = 'modular_twilight_axis/icons/obj/items/scabbard.dmi'
	sheathe_icon = "psysmallsword"
