/obj/item/rogueweapon/handclaw/gronn/silver/psy
	name = "psydonic claws"
	desc = "A trinity of silver razor sharp claws, long anough to catch your prey in this silent war."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "psyclaws"
	item_state = "psyclaws"

/obj/item/rogueweapon/handclaw/gronn/silver/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 5,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 3,\
	)

/obj/item/inqarticles/garrote // Do not give this item out freely to other classes. Do not subtype this item for other classes. This is intended purely as the Confessor's identifying sidegrade, and as a bonus for the Inspector INQ. I will be very sad if you disregard this comment. Thank you. - Yische.
	name = "\proper seizing garrote" // It's nonlethal. It's so silly and fun.
	desc = "A macabre instrument favored by the more clandestine of the Psydonian Silver Order; A length of thick leather inquiry cordage that has been dipped in both holy water and dye before being consecrated and spell-laced, held and threaded between two iron links. Perfect for apprehension."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "garrote"
	item_state = "garrote"
	gripsprite = TRUE
	throw_speed = 3
	throw_range = 7
	grid_height = 32
	grid_width = 32
	throwforce = 15
	force_wielded = 0
	force = 0
	obj_flags = CAN_BE_HIT
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	experimental_inhand = TRUE
	wieldsound = TRUE
	max_integrity = 200
	w_class = WEIGHT_CLASS_SMALL
	can_parry = FALSE
	break_sound = 'sound/items/garrotebreak.ogg'
	gripped_intents = list(/datum/intent/garrote/grab, /datum/intent/garrote/choke)
	var/mob/living/victim
	var/obj/item/grabbing/currentgrab
	var/mob/living/lastcarrier
	var/active = FALSE
	intdamage_factor = 0
	var/choke_damage = 10
	integrity_failure = 0.01
	embedding = null
	sellprice = 0

/obj/item/inqarticles/garrote/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left click with the 'GRAB' intent, while targeting the neck, to lock someone else into a chokehold.")
	. += span_info("Once locked into a chokehold, the 'CHOKE' intent can be used to rapidly choke the recipient into unconsciousness. Mindless recipients take far more damage when being choked.")
	. += span_info("Integrity damage is primarily taken whenever the recipient attempts to resist out of a chokehold. Each attempt to resist removes a twelveth of the garrote's total integrity.")
	. += span_info("Upon taking enough integrity damage, the garrote's cordage is snapped. Left-clicking a spool of inquisitorial cordage on the snapped garrote will fully repair it.")
	. += span_info("Using this item takes longer than usual, if the handler lacks the necessary trait or training.")

/obj/item/inqarticles/garrote/obj_break(damage_flag)
	obj_broken = TRUE
	if(!ismob(loc))
		return
	var/mob/M = loc
	active = FALSE
	if(altgripped || wielded)
		ungrip(M, FALSE)
		wipeslate(lastcarrier)
		if(lastcarrier.pulling)
			lastcarrier.stop_pulling()
	if(break_sound)
		playsound(get_turf(src), break_sound, 80, TRUE)
	update_icon()
	to_chat(M, "The [src] SNAPS...!")
	name = "\proper snapped seizing garrote"

/obj/item/inqarticles/garrote/update_damaged_state()
	icon_angle = initial(icon_angle)	
	icon_state = "garrote_snap"

/obj/item/inqarticles/garrote/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("wielded")	
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/garrote/choke
	name = "choke"
	icon_state = "inchoke"
	desc = "Used to begin choking the target out."
	no_attack = TRUE

/datum/intent/garrote/grab
	name = "grab"
	icon_state = "ingrab"
	desc = "Used to wrap around the target."
	no_attack = TRUE

/obj/item/inqarticles/garrote/proc/wipeslate(mob/user)
	if(victim)
		REMOVE_TRAIT(victim, TRAIT_MUTE, "garroteCordage")
		REMOVE_TRAIT(victim, TRAIT_GARROTED, TRAIT_GENERIC)
		victim = null
		currentgrab = null
	if(wielded)
		ungrip(user, FALSE)
		active = FALSE
		playsound(loc, 'sound/items/garroteshut.ogg', 65, TRUE)

/obj/item/inqarticles/garrote/attack_self(mob/user)
	if(obj_broken)
		to_chat(user, span_warning("It's useless now, although.."))
		to_chat(user, span_notice("I could rethread it with more cordage."))
		return
	if(wielded)
		ungrip(user, FALSE)
		active = FALSE
		if(user.pulling)
			user.stop_pulling()
		playsound(loc, 'sound/items/garroteshut.ogg', 65, TRUE)
		wipeslate(user)
		return
	if(gripped_intents)
		wield(user, FALSE)
		active = TRUE
		if(wielded)
			playsound(loc, pick('sound/items/garrote.ogg', 'sound/items/garrote2.ogg'), 65, TRUE)
			return

/obj/item/inqarticles/garrote/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	lastcarrier = user
	wipeslate(lastcarrier)
	if(active)	
		if(lastcarrier.pulling)
			lastcarrier.stop_pulling()
		playsound(user, 'sound/items/garroteshut.ogg', 65, TRUE)
		active = FALSE
	if(!obj_broken)
		if(icon_state != initial(icon_state))
			icon_state = initial(icon_state)
			icon_angle = initial(icon_angle)

/obj/item/inqarticles/garrote/dropped(mob/user, silent)
	. = ..()
	wipeslate(lastcarrier)
	if(active)	
		if(lastcarrier.pulling)
			lastcarrier.stop_pulling()
		playsound(user, 'sound/items/garroteshut.ogg', 65, TRUE)
		active = FALSE
	if(!obj_broken)
		if(icon_state != initial(icon_state))
			icon_state = initial(icon_state)
			icon_angle = initial(icon_angle)

/obj/item/inqarticles/garrote/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/rope/inqarticles/inquirycord))
		user.visible_message(span_warning("[user] starts to rethread the [src] using the [I]."))
		if(do_after(user, 8 SECONDS))
			qdel(I)
			obj_broken = FALSE
			obj_integrity = max_integrity
			icon_state = initial(icon_state)
			icon_angle = initial(icon_angle)
			name = initial(name)
		else
			user.visible_message(span_warning("[user] stops rethreading the [src]."))
		return

/obj/item/inqarticles/garrote/afterattack(mob/living/target, mob/living/user, proximity_flag, click_parameters)
	if(istype(user.used_intent, /datum/intent/garrote/grab))	// Grab your target first.
		if(!iscarbon(target))
			return
		if(!proximity_flag)
			return
		if(victim == target)
			return
		if(user.pulling)
			user.stop_pulling(FALSE)
		if(HAS_TRAIT(target, TRAIT_GRABIMMUNE))
			playsound(loc, pick('sound/items/garrote.ogg', 'sound/items/garrote2.ogg'), 65, TRUE)
			user.visible_message(span_danger("[target] slips past [user]'s attempt to [src] them!"))
			return
		// THROAT TARGET RESTRICTION. HEAVILY REQUESTED.	
		if(user.zone_selected != "neck")
			to_chat(user, span_warning("I need to wrap it around their throat."))
			return
		if(target.can_see_cone(user) && target.stat == CONSCIOUS)
			to_chat(user, span_warning("[target] is looking right at me. This isn't going to work."))
			return
		if(HAS_TRAIT(target, TRAIT_GARROTED))
			to_chat(user, span_warning("They already have one wrapped around their throat."))
			return	
		victim = target	
		playsound(loc, 'sound/items/garrotegrab.ogg', 100, TRUE)
		ADD_TRAIT(user, TRAIT_NOTIGHTGRABMESSAGE, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_NOSTRUGGLE, TRAIT_GENERIC)
		ADD_TRAIT(target, TRAIT_GARROTED, TRAIT_GENERIC)
		ADD_TRAIT(target, TRAIT_MUTE, "garroteCordage")
		if(target != user)
			user.start_pulling(target, state = 1, supress_message = TRUE, item_override = src)
		user.visible_message(span_danger("[user] wraps the [src] around [target]'s throat!"))
		user.stamina_add(25)
		user.changeNext_move(CLICK_CD_RAPID)
		REMOVE_TRAIT(user, TRAIT_NOSTRUGGLE, TRAIT_GENERIC)	
		REMOVE_TRAIT(user, TRAIT_NOTIGHTGRABMESSAGE, TRAIT_GENERIC)
		var/obj/item/grabbing/I = user.get_inactive_held_item()
		if(istype(I, /obj/item/grabbing/))
			I.icon_state = null
			currentgrab = I

	if(istype(user.used_intent, /datum/intent/garrote/choke))	// Get started.
		if(!victim)
			to_chat(user, span_warning("Who am I choking? What?"))
			return
		if(!proximity_flag)
			return
		if(user.zone_selected != "neck")
			to_chat(user, span_warning("I need to constrict the throat."))
			return	
		user.stamina_add(rand(4, 8))
		var/mob/living/carbon/C = victim
		// if(get_location_accessible(C, BODY_ZONE_PRECISE_NECK))
		playsound(loc, pick('sound/items/garrotechoke1.ogg', 'sound/items/garrotechoke2.ogg', 'sound/items/garrotechoke3.ogg', 'sound/items/garrotechoke4.ogg', 'sound/items/garrotechoke5.ogg'), 100, TRUE)
		if(prob(40))
			C.emote("choke")
		C.adjustOxyLoss(30)
		if(!C.mind) // NPCs can be choked out twice as fast
			C.adjustOxyLoss(30)
		C.visible_message(span_danger("[user] [pick("garrotes", "asphyxiates")] [C]!"), \
		span_userdanger("[user] [pick("garrotes", "asphyxiates")] me!"), span_hear("I hear the sickening sound of cordage!"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("I [pick("garrote", "asphyxiate")] [C]!"))	
		user.changeNext_move(CLICK_CD_RESIST)	//Stops spam for choking.	

/datum/advclass/blackpowder_legionnaire
	name = "Blackpowder Legionnaire"
	tutorial = "In the Blackpowder Order, every fourth soldier is a sharpshooter, armed with advanced Otavan firearms. These Legionnaires are the very essence of the everchanging face of warfare, and when the Final War begins, it is with their power that the evil will be driven back."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/blackpowder_legionnaire
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_blackpowder.ogg'
	category_tags = list(CTAG_ORTHODOXIST)
	traits_applied = list(TRAIT_PSYDONITE, TRAIT_ARTILLERY_EXPERT)
	classes = list("Legionnaire" = "Soldier of the Last War. Bring your deadly weapon of blackpowder to the battlefield", 
	"Otavan Volf" = "No matter who you were before. Now you are a bloodhound of Inquisition enchanted with rune magyck. \
	No doors can stop you and no heretic can escape your silent bullet.")
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose between two archetypes: Legionnaire and Otavan Volf. Legionnaire wield powerful blackpowder weapons and may select between light or medium armor, gaining Dodge Expert or Maille Training respectively. Otavan Volf specialize in stealth, rune magyck and silent firearms."

/datum/outfit/job/roguetown/blackpowder_legionnaire
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/blackpowder_legionnaire/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	cloak = /obj/item/clothing/cloak/bandolier
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	neck = /obj/item/clothing/neck/roguetown/leather/blackpowder
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor
	id = /obj/item/clothing/ring/signet/psy
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
	var/classes = list("Legionnaire", "Otavan Volf")
	var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes
	
	if(H.mind)
		switch(classchoice)
			if("Legionnaire")
				var/weapons = list("Purgatory (Handcannon)", "Runelock Pistol")
				var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
				switch(weapon_choice)
					if("Purgatory (Handcannon)")
						belt = /obj/item/storage/belt/rogue/leather/black
						l_hand = /obj/item/gun/ballistic/twilight_firearm/handgonne/purgatory
						backpack_contents = list(/obj/item/roguekey/inquisitionmanor = 1,
						/obj/item/paper/inqslip/arrival/ortho = 1,
						/obj/item/twilight_powderflask/holyfyre = 1,
						/obj/item/natural/bundle/fibers/full = 1,
						/obj/item/storage/belt/rogue/pouch/coins/mid = 1)
						var/quivers = list("Grapeshot", "Cannonballs")
						var/ammochoice = input(H,"Choose your MUNITIONS.", "TAKE UP PSYDON'S MISSILES.") as anything in quivers
						switch(ammochoice)
							if("Grapeshot")
								beltr = /obj/item/quiver/twilight_bullet/cannonball/grapeshot
							if("Cannonballs")
								beltr = /obj/item/quiver/twilight_bullet/cannonball/lead
					if("Runelock Pistol")
						belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt/blackpowder
						beltr = /obj/item/quiver/twilight_bullet/runicbag/runed
						l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock
						backpack_contents = list(/obj/item/roguekey/inquisitionmanor = 1,
						/obj/item/paper/inqslip/arrival/ortho = 1,
						/obj/item/storage/belt/rogue/pouch/coins/mid = 1)
				var/armors = list("Medium Armor", "Light Armor")
				var/armor_choice = input(H, "Choose your ARMOR.", "TAKE UP PSYDON'S MANTLE.") as anything in armors
				switch(armor_choice)
					if("Medium Armor")
						armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate
						pants = /obj/item/clothing/under/roguetown/chainlegs
						ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
					if("Light Armor")
						armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon
						pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
						ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				wrists = /obj/item/clothing/neck/roguetown/psicross/silver
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/short/psy
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			if ("Otavan Volf")
				ADD_TRAIT(H, TRAIT_BLACKBAGGER, TRAIT_GENERIC)
				var/weapons = list("Dagger", "Claws")
				var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
				switch(weapon_choice)
					if("Dagger")
						r_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
						beltl = /obj/item/rogueweapon/scabbard/sheath
						H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
					if("Claws")
						r_hand = /obj/item/rogueweapon/handclaw/gronn/silver/psy
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				wrists = /obj/item/clothing/neck/roguetown/psicross/silver
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor
				l_hand = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol/umbra
				head = /obj/item/clothing/head/roguetown/roguehood/psydon/confessor
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt/blackpowder
				beltr = /obj/item/quiver/twilight_bullet/lead
				backpack_contents = list(/obj/item/roguekey/inquisitionmanor = 1,
					/obj/item/paper/inqslip/arrival/ortho = 1,
					/obj/item/twilight_powderflask/volf = 1,
					/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
					/obj/item/inqarticles/garrote = 1,
					/obj/item/clothing/head/inqarticles/blackbag = 1)
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadowstep)
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/invisibility/runed)
				H.mind?.RemoveSpell(H.mind.get_spell(/datum/action/cooldown/spell/touch/prestidigitation))
				var/arcane = list("Fetch", "Repulse", "Leap")
				var/arcane_choice = input("TAKE YOUR RUNE.", "PSYDON'S RUNE.") as anything in arcane
				switch(arcane_choice)
					if("Fetch")
						H.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/fetch)
					if("Repulse")
						H.mind?.AddSpell(new /datum/action/cooldown/spell/repulse)
					if("Leap")
						H.mind?.AddSpell(new /datum/action/cooldown/spell/leap)

