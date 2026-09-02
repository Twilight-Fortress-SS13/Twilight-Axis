/datum/advclass/blackoak/warmaster
	name = "Warmaster"
	tutorial = "You are the guiding hand and ruthless commander of the Black Oaken cell. While your brethren bleed in the brush, you direct their wrath, bound by a oath to reclaim what was stolen. You see the False Crown's reign as a disease and its subjects as parasites. Leading your pure-blooded kin through fear, duty, and righteous fury, you spend your daes orchestrating the downfall of foreign invaders. Your only victory is the complete purging of your homeland."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_BLACKOAK)
	outfit = /datum/outfit/job/roguetown/blackoak/warmaster
	category_tags = list(CTAG_BLACKOAK)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	subclass_languages = list(/datum/language/elvish)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/blackoak/warmaster/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/warmaster
	armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	beltl = /obj/item/quiver/silver
	beltr = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/blackoak/warmaster
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/elvish = 1,
		)
	H.merctype = 2

/datum/outfit/job/roguetown/blackoak/warmaster/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Elvish Glaive", "Elvish Curveblade", "Elvish Longsword")
	var/weapon_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in weapons
	switch(weapon_choice)
		if("Elvish Glaive")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/halberd/glaive/elvish/silver)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
		if("Elvish Curveblade")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
		if("Elvish Longsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BACK_L, TRUE)
