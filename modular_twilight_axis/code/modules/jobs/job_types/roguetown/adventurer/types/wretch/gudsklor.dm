/datum/advclass/wretch/gudsklor
	name = "Guds Klør"
	tutorial = "You are a Shaman of the Fjall, The Northern Empty. Your rituals call elder spirits and Gods through violence and ordinances which was forbidden even by your brothers"
	outfit = /datum/outfit/job/roguetown/wretch/gudsklor
	category_tags = list(CTAG_WRETCH)
	class_select_category = CLASS_CAT_CLERIC
	maximum_possible_slots = 2
	subclass_languages = list(/datum/language/gronnic)
	cmode_music = sound("modular_twilight_axis/sound/music/combat_hakkerskaldyr.ogg")
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_CIVILIZEDBARBARIAN, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_DUALWIELDER, TRAIT_PSYCHOSIS)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE
	)
	extra_context = "This subclass has two choices: Spiritism (Master spiritism, shamanic totems) or Miracles (Journeyman Holy, capped to T2). You cannot walk both paths."

/datum/outfit/job/roguetown/wretch/gudsklor
	allowed_patrons = ALL_GRONNIC_PATRONS

/datum/outfit/job/roguetown/wretch/gudsklor/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	to_chat(H, span_warning("You are a Shaman of the Fjall, The Northern Empty. Your rituals call elder spirits and Gods through violence and ordinances which was forbidden even by your brothers."))
	H.mind?.current.faction += "[H.name]_faction"
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	var/is_miracles = FALSE
	if(H.mind)
		var/paths = list("Spiritism", "Miracles")
		var/path_choice = input(H, "Choose your path", "YOUR CALLING") as anything in paths
		is_miracles = (path_choice == "Miracles")
	if(is_miracles)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles, same as the old commented-out Atgervi Shaman.
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if(H.patron?.type == /datum/patron/inhumen/zizo)
			H.mind?.AddSpell(new /datum/action/cooldown/spell/minion_order)
			H.mind?.AddSpell(new /datum/action/cooldown/spell/gravemark)
	else
		H.adjust_skillrank_up_to(/datum/skill/craft/spiritism, SKILL_LEVEL_MASTER, TRUE)
		if(H.mind)
			for(var/recipe_type in shamanic_totem_block_recipe_types)
				H.mind.teach_crafting_recipe(recipe_type)
		H.grant_shamanic_totem_verbs(TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/leather/shaman_hood
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/atgervi
	pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/atgervi
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	mask = /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/wretch

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			if(H.mind)
				var/talismans = list("The Wolf, Plotting", "The Spider, Rising")
				var/talismanschoice = input(H, "Choose your path", "Beasts of the North") as anything in talismans
				switch(talismanschoice)
					if("The Wolf, Plotting")
						id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
					if("The Spider, Rising")
						id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/spider
			else
				id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
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
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special

	backpack_contents = list(
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/stoneknife = 1
		)

/*	var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves
	var/technique_choice = input(H,"Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
	switch(technique_choice)
		if("Dropkick - Pushback + Extra Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
		if("Chokeslam - Stamina Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
		if("Stunner - Dazed Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
		if("Headbutt - Vulnerable Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
	*/
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			GLOB.excommunicated_players += H.real_name
			H.put_in_hands(new /obj/item/rogueweapon/handclaw/gronn)
			H.put_in_hands(new /obj/item/rogueweapon/handclaw/gronn)
		if("They fear me")
			to_chat(H, span_red("Они ничтожны, как и их боги. Этими когтями я разорву их словно шавок!"))
			wretch_select_bounty(H)
			H.put_in_hands(new /obj/item/rogueweapon/handclaw/steel)
			H.put_in_hands(new /obj/item/rogueweapon/handclaw/steel)
