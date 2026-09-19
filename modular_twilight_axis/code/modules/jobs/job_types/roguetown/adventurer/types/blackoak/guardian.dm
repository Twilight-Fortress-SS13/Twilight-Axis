/datum/advclass/blackoak/guardian
	name = "Guardian"
	tutorial = "You are the woad bulwark of the old woods. While others whisper in the shadows, you stand openly against the tide of mongrels and foreign invaders who dare claim Azurian soil. You have sworn a blood oath to the Peaks. Clad in the ancestral plate of your forefathers, you spend your daes severing the limbs of trespassers. You are no hired sword; you are the executioner of the False Crown, striking down the unworthy with cold, unyielding steel."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_BLACKOAK)
	outfit = /datum/outfit/job/roguetown/blackoak/guardian
	category_tags = list(CTAG_BLACKOAK)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	subclass_languages = list(/datum/language/elvish)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
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

/datum/outfit/job/roguetown/blackoak/guardian/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm
	armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	beltl = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	beltr = /obj/item/flashlight/flare/torch
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/elvish = 1,
		)

/datum/outfit/job/roguetown/blackoak/guardian/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Elvish Glaive", "Elvish Curveblade", "Elvish Longsword", "Elvish Saber")
	var/weapon_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in weapons
	switch(weapon_choice)
		if("Elvish Glaive")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/halberd/glaive/elvish/silver)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("Elvish Curveblade")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("Elvish Longsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BACK_R, TRUE)
