/datum/advclass/mercenary/atgervi_shaman
	name = "Atgervi Shaman"
	tutorial = "You are a Shaman of the Fjall, The Northern Empty. Shamans are savage combatants who commune with the Ecclesical Beast Gods through ritualistic violence, rather than idle prayer."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/mercenary/atgervi_shaman
	subclass_languages = list(/datum/language/gronnic)
	cmode_music = 'sound/music/combat_shaman2.ogg'
	class_select_category = CLASS_CAT_GRONN
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_BULWARK)
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_CIVILIZEDBARBARIAN, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -1,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/spiritism = SKILL_LEVEL_MASTER,
	)

/datum/outfit/job/roguetown/mercenary/atgervi_shaman
	allowed_patrons = ALL_GRONNIC_PATRONS //Variant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.

/datum/outfit/job/roguetown/mercenary/atgervi_shaman/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	to_chat(H, span_warning("You are a Shaman of the Fjall, The Northern Empty. Shamans are savage combatants who commune with the Ecclesical Beast gods through ritualistic violence, rather than idle prayer."))
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	if(H.mind)
		for(var/recipe_type in shamanic_totem_block_recipe_types)
			H.mind.teach_crafting_recipe(recipe_type)

	head = /obj/item/clothing/head/roguetown/helmet/leather/shaman_hood
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/flashlight/flare/torch
	H.put_in_hands(new /obj/item/rogueweapon/handclaw/gronn)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			if(H.mind) //TA EDIT START
				var/talismans = list("The Wolf, Plotting", "The Spider, Rising")
				var/talismanschoice = input(H, "Choose your path", "Beasts of the North") as anything in talismans
				switch(talismanschoice)
					if("The Wolf, Plotting")
						id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
					if("The Spider, Rising")
						id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/spider
			else
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn //TA EDIT END
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 1
