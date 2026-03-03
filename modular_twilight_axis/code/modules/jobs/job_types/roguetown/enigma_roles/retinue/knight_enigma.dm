/datum/job/roguetown/knight_enigma
	title = "Royal Knight"
	flag = ROYALKNIGHT
	department_flag = RETINUE
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	allowed_races = RACES_NO_CONSTRUCT
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "Вы - воин с экспертной подготовкой; рожденный в мелком дворянстве и с юных лет воспитанный как оруженосец. \
	Ваша доблесть и воинские умения были замечены еще давно короной и теперь вы удостоены величайшей чести - быть подле Короля. \
	Уже как 12 лет вы защищаете его в этом проклятом баронстве. Вам не на кого положиться, кроме как на себя, Короля и маршала, \
	а также королевскую гвардию, ведь за стенами замка лишь гнилозубые крестьяне и глупцы, что слепо отрицают смерть Барона."
	display_order = JDO_ROYALKNIGHT
	whitelist_req = TRUE
	outfit = /datum/outfit/job/roguetown/knight_enigma
	advclass_cat_rolls = list(CTAG_ROYALKNIGHT = 20)
	job_traits = list(TRAIT_NOBLE, TRAIT_STEELHEARTED)
	give_bank_account = TRUE
	noble_income = 10
	min_pq = 10
	max_pq = null
	round_contrib_points = 2
	same_job_respawn_delay = 30 MINUTES

	cmode_music = 'modular_twilight_axis/sound/music/combat/combat_retinue.ogg'

	job_subclasses = list(
		/datum/advclass/knight_enigma/heavy
		)

/datum/outfit/job/roguetown/knight_enigma
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/knight_enigma/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
	/*	if(istype(H.cloak, /obj/item/clothing/cloak)) //TA EDIT
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "[S.name] ([index])" */
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ser"
		if(should_wear_femme_clothes(H))
			honorary = "Dame"
		// check if they already have it to avoid stacking titles
		if(findtextEx(H.real_name, "[honorary] ") == 0)
			H.real_name = "[honorary] [prev_real_name]"
			H.name = "[honorary] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/outfit/job/roguetown/knight_enigma/post_equip(mob/living/carbon/human/H)  //TA EDIT
	..()
	if(istype(H.cloak, /obj/item/clothing/cloak))
		var/obj/item/clothing/S = H.cloak
		var/index = findtext(H.name_archive, " ")
		if(index)
			index = copytext(H.name_archive, 1,index)
		if(!index)
			index = H.name
		S.name = "[S.name] ([index])" //TA EDIT

/datum/outfit/job/roguetown/knight_enigma
	//cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/guard
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full
	pants = /obj/item/clothing/under/roguetown/platelegs

/datum/advclass/knight_enigma/heavy
	name = "Royal Knight"
	tutorial = "Вы - воин с экспертной подготовкой; рожденный в мелком дворянстве и с юных лет воспитанный как оруженосец. \
	Ваша доблесть и воинские умения были замечены еще давно короной и теперь вы удостоены величайшей чести - быть подле Короля. \
	Уже как 12 лет вы защищаете его в этом проклятом баронстве. Вам не на кого положиться, кроме как на себя, Короля и маршала, \
	а также королевскую гвардию, ведь за стенами замка лишь гнилозубые крестьяне и глупцы, что слепо отрицают смерть Барона."
	outfit = /datum/outfit/job/roguetown/knight_enigma/heavy

	category_tags = list(CTAG_ROYALKNIGHT)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 4,
		STATKEY_INT = 2,
		STATKEY_CON = 3,
		STATKEY_PER = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)
/datum/outfit/job/roguetown/knight_enigma/heavy/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Zweihander","Great Mace","Battle Axe & Shield","Poleaxe","Estoc","Lucerne", "Partizan", "Longsword & Shield", "Flail & Shield", "Warhammer & Shield", "Sabre & Shield")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Zweihander")
				r_hand = /obj/item/rogueweapon/greatsword/grenz
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Great Mace")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
			if("Battle Axe & Shield")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Poleaxe")
				r_hand = /obj/item/rogueweapon/greataxe/steel/knight
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Estoc")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Lucerne")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Partizan")
				r_hand = /obj/item/rogueweapon/spear/partizan
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Longsword & Shield")
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/long
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Flail & Shield")
				beltr = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Warhammer & Shield")
				beltr = /obj/item/rogueweapon/mace/warhammer/steel
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Sabre & Shield")
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/tower/metal

	if(H.mind)
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Klappvisier Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/heraldy = list(
				"Surcoat" 	= /obj/item/clothing/cloak/tabard/stabard/guard,
				"Tabard"		= /obj/item/clothing/cloak/tabard/knight,
				"Jupon"		= /obj/item/clothing/cloak/tabard/stabard/surcoat/guard,
				)
		var/heraldychoice = input(H, "Choose your heraldy.", "RAISE UP THE BANNER") as anything in heraldy
		cloak = heraldy[heraldychoice]

		var/onhelm = list(
			"horns" = /obj/item/clothing/head/roguetown/tw_d_horns,
			"towers" = /obj/item/clothing/head/roguetown/tw_d_castle_red,
			"afreet" = /obj/item/clothing/head/roguetown/tw_d_efreet,
			"sun" = /obj/item/clothing/head/roguetown/tw_d_sun,
			"astrata" = /obj/item/clothing/head/roguetown/tw_d_peace,
			"feathers" = /obj/item/clothing/head/roguetown/tw_d_feathers,
			"lion" = /obj/item/clothing/head/roguetown/tw_d_lion,
			"dragon" = /obj/item/clothing/head/roguetown/tw_d_dragon_red,
			"swan" = /obj/item/clothing/head/roguetown/tw_d_swan,
			"Le Fishe" = /obj/item/clothing/head/roguetown/tw_d_fish,
			"mighty windmill" = /obj/item/clothing/head/roguetown/tw_d_windmill,
			"oath" = /obj/item/clothing/head/roguetown/tw_d_oathtaker,
			"skull" = /obj/item/clothing/head/roguetown/tw_d_skull
			)
		var/onhelmchoice = input(H, "Choose your decor.", "RAISE UP THE SYMBOL") as anything in onhelm
		l_hand = onhelm[onhelmchoice]

		backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/storage/keyring/knight = 1,
		)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")
