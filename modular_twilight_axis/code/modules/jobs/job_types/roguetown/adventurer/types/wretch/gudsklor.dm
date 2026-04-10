/datum/advclass/wretch/gudsklor
	name = "Guds Klør"
	tutorial = "You are a Shaman of the Fjall, The Northern Empty. Your rituals call elder spirits and Gods through violence and ordinances which was forbidden even by your brothers"
	outfit = /datum/outfit/job/roguetown/wretch/gudsklor
	category_tags = list(CTAG_WRETCH)
	class_select_category = CLASS_CAT_CLERIC
	maximum_possible_slots = 2
	subclass_languages = list(/datum/language/gronnic)
	cmode_music = 'modular_twilight_axis/sound/music/combat_hakkerskaldyr.ogg'
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
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE
	)

/datum/outfit/job/roguetown/wretch/gudsklor
	allowed_patrons = ALL_GRONNIC_PATRONS

/datum/outfit/job/roguetown/wretch/gudsklor/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	to_chat(H, span_warning("You are a Shaman of the Fjall, The Northern Empty. Your rituals call elder spirits and Gods through violence and ordinances which was forbidden even by your brothers."))
	H.mind?.current.faction += "[H.name]_faction"
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	head = /obj/item/clothing/head/roguetown/helmet/leather/shaman_hood
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	mask = /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/wretch

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
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

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
	backpack_contents = list(
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/stoneknife = 1
		)
	
	var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves
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
