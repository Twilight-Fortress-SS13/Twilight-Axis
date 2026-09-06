/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock
	name = "runelock pistol"
	desc = "Крайне смертоностное оружие. Использует руническую магию вместо пороха."
	icon = 'modular_twilight_axis/firearms/icons/32.dmi'
	icon_state = "pistol2"
	var/icon_state_ready = "pistol2-1"
	var/default_icon_state = "pistol2"
	item_state = "pistol2"
	possible_item_intents = list(/datum/intent/shoot/twilight_runelock, /datum/intent/arc/twilight_runelock, INTENT_GENERIC)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/twilight_runelock
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY
	spread = 10
	recoil = 3
	force = 10
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME | CLAMP_BREAK
	var/cocked = FALSE
	cartridge_wording = "runed sphere"
	load_sound = 'modular_twilight_axis/firearms/sound/musketload.ogg'
	fire_sound = 'modular_twilight_axis/firearms/sound/musketfire2.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 200
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel
	/// Chance for the weapon to misfire
	var/misfire_chance = 0
	/// Reload time, in SECONDS
	var/reload_time = 8
	var/reload_stamina_cost = 30
	damfactor = 1
	var/critfactor = 0.7
	var/npcdamfactor = 4
	equip_delay_self = 1 SECONDS
	unequip_delay_self = 1 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 30,"sturn" = -30,"wturn" = -30,"eturn" = 30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/shoot_with_empty_chamber()
	if(cocked)
		playsound(src.loc, 'modular_twilight_axis/firearms/sound/musketcock.ogg', 100, FALSE)
		cocked = FALSE
		icon_state = initial(icon_state)
		update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/attack_self(mob/living/user)
	if(twohands_required)
		return
	if(altgripped || wielded) //Trying to unwield it
		ungrip(user)
		return
	if(!cocked)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(HAS_TRAIT(H, TRAIT_INQUISITION) || (H.STAINT >= 15) || (H.merctype == 10))
				to_chat(H, span_info("I ready the runelock to be fired..."))
				var/adj_reload_time = reload_time
				if(H.mind)
					var/skill = H.get_skill_level(/datum/skill/combat/twilight_firearms)
					if(skill)
						adj_reload_time = reload_time / skill
				if(move_after(H, adj_reload_time SECONDS, target = H))
					H.stamina_add(reload_stamina_cost)
					playsound(H, 'modular_twilight_axis/firearms/sound/musketcock.ogg', 100, FALSE)
					cocked = TRUE
			else
				to_chat(H, span_warning("Я совершенно не понимаю, как этим пользоваться!"))
		else
			to_chat(user, span_warning("Я совершенно не понимаю, как этим пользоваться!"))
	else
		if(alt_grips)
			altgrip(user)
		if(gripped_intents)
			wield(user)
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/update_icon()
	..()
	if(cocked && icon_state_ready)
		icon_state = icon_state_ready
		item_state = icon_state_ready
	else
		icon_state = default_icon_state
		item_state = default_icon_state
	if(!ismob(loc))
		return
	var/mob/M = loc
	M.update_inv_hands()

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		if(cocked)
			if((loc == user) && (user.get_inactive_held_item() != src) && (user.get_active_held_item() != src))
				return
			..()
		else
			to_chat(user, span_warning("I need to cock the runelock first!"))

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/u = user
		if(HAS_TRAIT(u, TRAIT_INQUISITION) || (u.STAINT >= 15) || (u.merctype == 10))
			if(cocked)
				if(chambered)
					. += span_notice("Взведено и готово к стрельбе.")
				else
					. += span_notice("Руны напитаны энергией, но пуля не установлена.")
			else
				. += span_notice("Не заряжено.")
		else
			. += span_notice("Конструкция замка, установленного на этом оружии, вам незнакома.")

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Рунные замки требуют специальную рунную пулю, после чего замок необходимо взвести перед стрельбой.")

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/process_fire/(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	var/skill = user.get_skill_level(/datum/skill/combat/twilight_firearms)
	if(skill)
		misfire_chance = max(0, misfire_chance - (skill * 2))
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	if(prob(misfire_chance))
		to_chat(user, span_warning("The [name] misfires!"))
		explosion(src, light_impact_range = 2, heavy_impact_range = 1, smoke = FALSE, soundin = 'sound/misc/explode/bomb.ogg')
		qdel(src)
		return
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/bullet/BB = CB.BB
		BB.gunpowder_npc_critfactor *= npcdamfactor
		BB.critfactor *= critfactor
		var/per_scaling = 1 + ((min(user.STAPER, RANGED_STAT_SOFTCAP) - 10) * RANGED_STAT_MULT) + (max(0, user.STAPER - RANGED_STAT_SOFTCAP) * RANGED_STAT_CAPPEDMULT)
		BB.damage *= damfactor * per_scaling
	cocked = FALSE
	update_icon()
	var/shoot_dir = get_dir(src, target)
	new /obj/effect/temp_visual/small_smoke/gunsmoke(get_step(user, shoot_dir), shoot_dir)
	..()

/obj/item/ammo_box/magazine/internal/shot/twilight_runelock
	ammo_type = /obj/item/ammo_casing/caseless/rogue/twilight_lead/runelock
	caliber = "runed_sphere"
	max_ammo = 1
	start_empty = TRUE

/datum/intent/shoot/twilight_runelock
	ready_sound = "modular_twilight_axis/firearms/sound/musketcock.ogg"
	chargedrain = 0

/datum/intent/shoot/twilight_runelock/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 75
		newtime = newtime / max(1, mastermob.get_skill_level(/datum/skill/combat/twilight_firearms))
		//per block
		newtime = newtime + 20
		newtime = newtime - ((mastermob.STAPER)*1.5)
		if(newtime > 10)
			return newtime
		else
			return 10
	return chargetime

/datum/intent/arc/twilight_runelock
	ready_sound = "modular_twilight_axis/firearms/sound/musketcock.ogg"
	chargetime = 1
	chargedrain = 0

/datum/intent/arc/twilight_runelock/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 70
		newtime = newtime / max(1, mastermob.get_skill_level(/datum/skill/combat/twilight_firearms))
		//per block
		newtime = newtime + 20
		newtime = newtime - ((mastermob.STAPER)*1.5)
		if(newtime > 10)
			return newtime
		else
			return 10
	return chargetime

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/rifle
	name = "\"Doomsdae\""
	desc = "Реликвия новой эпохи, созданная для войны, что положит конец истории мироздания, какой мы её знаем. Изготовленная отаванскими мастерами артефакторики, и зачарованная рунными магами Отавы, эта руническая винтовка - оружие, что сокрушит легионы тьмы в Конце Времен. Руны нанесены на ствол оружия кровью еретиков, поплатившихся за свое предательство истинной веры своими жизнями."
	icon = 'modular_twilight_axis/firearms/icons/runelock_rifle.dmi'
	icon_state = "runelock"
	icon_state_ready = "runelock_loaded"
	default_icon_state = "runelock"
	item_state = "runelock"
	force = 10
	force_wielded = 15
	associated_skill = /datum/skill/combat/staves
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/twilight_runelock, /datum/intent/arc/twilight_runelock, INTENT_GENERIC)
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	experimental_onback = TRUE
	bigboy = TRUE
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	wdefense = 3
	damfactor = 1.2
	critfactor = 1
	reload_time = 15
	reload_stamina_cost = 50
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/rifle/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 6,"nx" = 7,"ny" = 6,"wx" = -2,"wy" = 3,"ex" = 1,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -43,"sturn" = 43,"wturn" = 30,"eturn" = -30, "nflip" = 0, "sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -8,"wy" = 2,"ex" = 8,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
