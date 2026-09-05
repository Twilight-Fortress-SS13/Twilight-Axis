/datum/advclass/janissary/flagbearer
	name = "Standard Bearer"
	tutorial = "You're the sergeant's second, entrusted with the palace's standard when you sally out into battle. \
	Your fellow soldiers know to rally around you, should you keep it safe."
	outfit = /datum/outfit/job/roguetown/janissary/flagbearer
	category_tags = list(CTAG_JANISSARY)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_STANDARD_BEARER, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	maximum_possible_slots = 1

/datum/outfit/job/roguetown/janissary/flagbearer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	pants = /obj/item/clothing/under/roguetown/splintlegs
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/knight = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		H.set_blindness(0)
		r_hand = /obj/item/rogueweapon/spear/keep_standard
