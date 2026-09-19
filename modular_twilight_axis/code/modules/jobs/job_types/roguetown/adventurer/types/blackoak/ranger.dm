/datum/advclass/blackoak/ranger
	name = "Ranger"
	tutorial = "A phantom of the deep timber, you are the unseen terror that haunts the settler's nightmares. Disgusted by the lesser races polluting your ancestral homeland, you have taken to the canopy, dealing death from afar. You do not negotiate with invaders; you hunt them like beasts. Armed with your recurve bow and a heart full of righteous venom, you spend your daes stalking the treeline, ensuring every outsider who strays from the road becomes fertilizer for the Black Oaks"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_BLACKOAK)
	outfit = /datum/outfit/job/roguetown/blackoak/ranger
	category_tags = list(CTAG_BLACKOAK)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	subclass_languages = list(/datum/language/elvish)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_PERFECT_TRACKER, TRAIT_SLEUTH)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 3,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
    )

/datum/outfit/job/roguetown/blackoak/ranger/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	beltl = /obj/item/quiver/arrows
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/elvish = 1,
		)

/datum/outfit/job/roguetown/mercenary/blackoak_ranger/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/rangedweapons = list("Woad Recurve Bow", "Woad Longbow")
	var/rangedweapon_choice = input(H,"Choose your BOW.", "DEATH FROM THE CANOPY.") as anything in rangedweapons
	switch(rangedweapon_choice)
		if("Woad Recurve Bow")
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/blackoak)
		if("Woad Longbow")
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/blackoak)
	var/weapons = list("Elvish Dagger", "Elvish Saber")
	var/weapon_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in weapons
	switch(weapon_choice)
		if("Elvish Dagger")
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/silver/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_R, TRUE)
		if("Elvish Saber")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE) //I think it will be fair for the silver and high defense
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/elf)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
	var/armors = list("Woad Elven Maille", "Trophy Fur Robes")
	var/armor_choice = input(H, "Choose your ARMOR.", "THE FOREST CLOAKS YOU.") as anything in armors
	switch(armor_choice)
		if("Woad Elven Maille")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/light, SLOT_ARMOR, TRUE)
		if("Trophy Fur Robes")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/elven, SLOT_ARMOR, TRUE)
	var/helmets = list("Woad Elven Barbute", "Elven Barbute", "Winged Elven Barbute")
	var/helmet_choice = input(H, "Choose your HELMET.", "LEAVES OVER STEEL.") as anything in helmets
	switch(helmet_choice)
		if("Woad Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/light, SLOT_HEAD, TRUE)
		if("Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak, SLOT_HEAD, TRUE)
		if("Winged Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak, SLOT_HEAD, TRUE)
