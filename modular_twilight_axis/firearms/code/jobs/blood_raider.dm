#define VITAE_PER_DRINK 300

/datum/advclass/wretch/twilight_blood_raider
	name = "Blood Raider"
	tutorial = "Having harnessed Cain's GIFT, you came to be known as a dhampir. With mastery over your newfound abilities, you obtained the weapon through honest or not-so-honest means, you carry the consequences of your actions across the surface of Grimoria, showcasing the true might of drow craftsmanship."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	outfit = /datum/outfit/job/roguetown/wretch/twilight_blood_raider
	category_tags = list(CTAG_WRETCH)
	class_select_category = CLASS_CAT_RANGER
	traits_applied = list(TRAIT_FIREARMS_MARKSMAN, TRAIT_DODGEEXPERT, TRAIT_ARCYNE)
	maximum_possible_slots = 1

	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_bloodraider.ogg'
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/wretch/twilight_blood_raider/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	if(istype(H.dna.species, /datum/species/elf/dark))
		H.set_blindness(0)
		backl = /obj/item/storage/backpack/rogue/satchel/black
		neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle/bloodraider
		head = /obj/item/clothing/head/roguetown/helmet/bloodhelmet
		armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/bloodraider
		pants = /obj/item/clothing/under/roguetown/bloodsplintlegs
		gloves = /obj/item/clothing/gloves/roguetown/bloodraider
		r_hand = /obj/item/rogueweapon/sword/sabre/stalker
		backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1, /obj/item/rogueweapon/huntingknife/idagger/steel/stalker = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/chalk = 1, /obj/item/rogueweapon/spellbook = 1)
		switch(crimeschoice)
			if("I'm nobody")
				to_chat(H, span_warning("Моя прошлая жизнь не даёт мне покоя по ночам. Кошмары заставляют меня оглядываться назад чаще..."))
			if("They fear me")
				wretch_select_bounty(H)
				ADD_TRAIT(H, TRAIT_ANTHRAXI, "bloodraider")
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_PER, 1)
				to_chat(H, span_warning("Они боятся меня. Моя ловкость и зоркость не подводили ни разу на рейдах мерзких чужеземцев."))
	else
		H.set_blindness(0)

		backl = /obj/item/storage/backpack/rogue/satchel
		neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
		head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/handmade
		pants = /obj/item/clothing/under/roguetown/brigandinelegs
		gloves = /obj/item/clothing/gloves/roguetown/plate
		r_hand = /obj/item/rogueweapon/sword/sabre
		backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1, /obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/chalk = 1, /obj/item/rogueweapon/spellbook = 1)
		switch(crimeschoice)
			if("I'm nobody")
				to_chat(H, span_warning("Антракси идут по мою душу, я не могу быть уверенным в завтрашнем дне..."))
			if("They fear me")
				wretch_select_bounty(H)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_CON, 1)
				to_chat(H, span_warning("Приспособившись к новому оружию, мне стало легче избегать охотников за головой."))


	H.set_patron(/datum/patron/inhumen/zizo)
	ADD_TRAIT(H, TRAIT_NOHUNGER, "bloodraider")
	ADD_TRAIT(H, TRAIT_NOBREATH, "bloodraider")
	ADD_TRAIT(H, TRAIT_VAMPBITE, "bloodraider")
	ADD_TRAIT(H, TRAIT_NASTY_EATER, "bloodraider")
	ADD_TRAIT(H, TRAIT_DARKVISION, "bloodraider")
	ADD_TRAIT(H, TRAIT_NOSLEEP, "bloodraider")
	ADD_TRAIT(H, TRAIT_SILVER_BLESSED, "bloodraider")
	shoes = /obj/item/clothing/shoes/roguetown/boots/bloodboots
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/twilight_elven/bloodraider
	shirt = /obj/item/clothing/suit/roguetown/shirt/bloodraider
	belt = /obj/item/storage/belt/rogue/leather/double
	beltl = /obj/item/quiver/twilight_bullet/lead
	beltr = /obj/item/rogueweapon/scabbard/sword
	H.grant_language(/datum/language/undead)

	H.maxbloodpool = 3500
	H.hud_used?.shutdown_bloodpool()
	H.hud_used?.initialize_bloodpool()
	H.hud_used?.bloodpool.set_fill_color("#510000")
	H.set_bloodpool(H.maxbloodpool)

	RegisterSignal(H, COMSIG_LIVING_DRINKED_LIMB_BLOOD, PROC_REF(on_drink_blood))

/datum/outfit/job/roguetown/wretch/twilight_blood_raider/proc/on_drink_blood(mob/living/drinker, mob/living/target)
	SIGNAL_HANDLER

	drinker.adjust_bloodpool(VITAE_PER_DRINK)

#undef VITAE_PER_DRINK
