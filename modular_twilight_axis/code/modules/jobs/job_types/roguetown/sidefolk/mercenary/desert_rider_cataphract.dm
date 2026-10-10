/datum/advclass/mercenary/twilight_desert_rider_cataphract
	name = "Desert Rider Cataphract"
	tutorial = "You once rode for the pretenders for the throne of Golden Empire. After the dust settled, you found yourself amongst the losing side of war, forced to either to die amongst other losers.. Or ride out once more, as mercenary for Desert rider brotherhood. Choice was probably, the easiest one in your life."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_SMALL)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_desert_rider_cataphract
	subclass_languages = list(/datum/language/raneshi)
	origin_limits = list(/datum/virtue/origin/zybantian)
	class_select_category = CLASS_CAT_RANESHENI
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE)
	noble_income = 15
	cmode_music = 'sound/music/combat_desertrider.ogg'
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/twilight_desert_rider_cataphract/pre_equip(mob/living/carbon/human/H)
	..()

	// CLASS ARCHETYPES
	H.adjust_blindness(-3)
	var/classes = list("Shamshir","Mace","Flail","Bardiche","Heavy scimitar")
	if(H.mind)
		var/classchoice = input(H, "Choose your weapon", "Available weapons") as anything in classes
		H.set_blindness(0)
		to_chat(H, span_warning("The weapon you went through the war with was..."))
		switch(classchoice)
			if("Shamshir")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
			if("Heavy scimitar")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
			if("Mace")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				beltl = /obj/item/rogueweapon/mace/steel
			if("Flail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
				beltl = /obj/item/rogueweapon/flail/sflail
			if("Bardiche")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
				r_hand = /obj/item/rogueweapon/halberd/bardiche
				l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather/shalal
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	neck = /obj/item/clothing/neck/roguetown/gorget
	cloak = /obj/item/clothing/cloak/twilight_desert
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	pants = /obj/item/clothing/under/roguetown/platelegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/shield/tower/metal
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/flashlight/flare/torch = 1,
		)
	H.merctype = 10

	if(H.mind)
		var/helmets = list(
			"Cataphract helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/cataphract,
			"Jar Helmet"		= /obj/item/clothing/head/roguetown/helmet/raneshi_jarhelmet,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

	var/choices = list("Body", "Momentum")
	if(H.mind)
		var/choice = input(H, "Are you counting on the body?...", "...Or at your own momentum?") as anything in choices
		to_chat(H, span_warning("I’ve always counted on..."))
		switch(choice)
			if("Body")
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_CON, 1) //Теряет 3 стата (ЕСЛИ СУДИТЬ ПО БАЛАНСУ ОФФОВ, ТО 4, сила же ЗА ДВА да))), т.к. моментум мидкомбат регенит стамину при каждом стаке, если конечно набить, думаю зарезать за это 3 стата будет честным.
			if("Momentum")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/zeybek_momentum/janissary)
