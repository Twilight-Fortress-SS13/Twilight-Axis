#define CLASS_CAT_HEARTFELT "Heartfelt"

/datum/advclass/mercenary/twilight_republican_troublemaker
	name = "Republican TroubleMaker"
	tutorial = "A true fighter and partisan who took a break from his revolution to earn a few mammons to help his homeland."
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_republican_troublemaker
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_EXPLOSIVE_SUPPLY, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	maximum_possible_slots = 2
	allowed_patrons = list(/datum/patron/divine/undivided, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/ravox, /datum/patron/divine/necra, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/old_god, /datum/patron/inhumen/graggar, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)
	class_select_category = CLASS_CAT_HEARTFELT
	subclass_languages = list(/datum/language/etruscan)
	cmode_music = sound("modular_twilight_axis/sound/music/republicantroublemaker.ogg")

	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = 2
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mercenary/twilight_republican_troublemaker/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle/republican
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/handcrossbow
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	mask = /obj/item/clothing/mask/rogue/spectacles/duelist
	cloak = /obj/item/quiver/bolt/light/bandolier
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/republican
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/twstrap/bombstrap/bomb_and_fire
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/roguekey/mercenary = 1,
	)
	if(H.mind)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/survival/bolt/light/fire)
		var/weapons = list("Le Plagua", "Twin Daggers")
		var/weapon_choice = input(H, "Choose your weapon.", "LET YOUR HANDS SPEAK BEFORE YOUR MOUTH.") as anything in weapons
		switch(weapon_choice)
			if ("Le Plagua")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick/plagua
			if ("Twin Daggers")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel

//Спец приколы
/obj/item/clothing/wrists/roguetown/bracers/handcrossbow
	name = "bracer-mounted crossbow"
	icon = 'icons/roguetown/clothing/wrists.dmi'
	icon_state = "superbracer_crossbow"
	item_state = "superbracer_crossbow"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/wrists.dmi'
	var/icon_state_folded = "superbracer_crossbow"
	var/icon_state_unfolded = "superbracer_crossbow1"
	var/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/wristbow/stored_crossbow
	var/crossbow_type = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/wristbow

/obj/item/clothing/wrists/roguetown/bracers/handcrossbow/Initialize(mapload)
	. = ..()
	stored_crossbow = new crossbow_type(src)
	stored_crossbow.wrist_mount = src

/obj/item/clothing/wrists/roguetown/bracers/handcrossbow/Destroy()
	QDEL_NULL(stored_crossbow)
	return ..()

/obj/item/clothing/wrists/roguetown/bracers/handcrossbow/attack_right(mob/living/user)
	if(!stored_crossbow || QDELETED(stored_crossbow))
		return
	if(stored_crossbow.loc == src)
		user.put_in_hands(stored_crossbow)
	else
		stored_crossbow.fold_back()
	update_icon()

/obj/item/clothing/wrists/roguetown/bracers/handcrossbow/dropped(mob/user, silent)
	. = ..()
	if(stored_crossbow && stored_crossbow.loc != src)
		if(stored_crossbow.chambered)
			qdel(stored_crossbow)
			stored_crossbow = new crossbow_type(src)
			stored_crossbow.wrist_mount = src
		else
			stored_crossbow.fold_back()
	update_icon()

/obj/item/clothing/wrists/roguetown/bracers/handcrossbow/update_icon()
	. = ..()
	if(stored_crossbow && stored_crossbow.loc == src)
		icon_state = icon_state_folded
		item_state = icon_state_folded
	else
		icon_state = icon_state_unfolded
		item_state = icon_state_unfolded
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wrists()

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/wristbow
	name = "wristbow"
	desc = "A small crossbow designed to be mounted on the wrist."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "crossbowshort0"
	item_state = "crossbowshort"
	slot_flags = NONE
	var/obj/item/clothing/wrists/roguetown/bracers/handcrossbow/wrist_mount

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/wristbow/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "wristbow")

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/wristbow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.3,"sx" = -7,"sy" = -3,"nx" = -7,"ny" = -3,"wx" = 3,"wy" = -2,"ex" = -3,"ey" = -2,"northabove" = 1,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = 45,"sturn" = 45,"wturn" = 45,"eturn" = 45,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,)

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/wristbow/attack_right(mob/living/user)
	fold_back()

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/wristbow/proc/fold_back()
	if(!wrist_mount || QDELETED(wrist_mount))
		return
	if(loc == wrist_mount)
		return
	if(chambered)
		if(ismob(loc))
			to_chat(loc, span_warning("Нельзя сложить арбалет с заряженным болтом."))
		return
	forceMove(wrist_mount)
	wrist_mount.update_icon()

/obj/item/ammo_casing/caseless/rogue/bolt/light/fire
	name = "light fire bolt"
	desc = "Лёгкий болт с небольшим алхимическим зарядом огня. Разбивается при ударе, оставляя после себя лишь обычный болт."
	projectile_type = /obj/projectile/bullet/reusable/bolt/light/fire
	icon = 'modular_twilight_axis/icons/roguetown/weapons/ammo.dmi'
	icon_state = "light_bolt_fire"

/obj/projectile/bullet/reusable/bolt/light/fire
	name = "light fire bolt"
	icon_state = "bolt_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/light

/obj/projectile/bullet/reusable/bolt/light/fire/on_hit(atom/target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		apply_scorch_stack(M, 2, def_zone)

/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick/plagua
	name = "Le Plagua"
	desc = "Plagua, or “The Pest,” a worthy ally in taking down the steel idiots."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "plagua"
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/dagger/thrust/pick, /datum/intent/axe/bash)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/dagger/thrust/pick, /datum/intent/axe/bash)
	toolspeed = 2
