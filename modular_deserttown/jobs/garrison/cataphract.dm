/datum/job/roguetown/cataphract
	title = "Cataphract"
	flag = CATAPHRACT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	tutorial = "Ты — Фарис, катафрактарий высочайшей выучки. \
        Ты был рожден в семье мелкой хассы и с малых лет воспитывался как радиф, ныне же ты стоишь в страже у трона Султанской династии, внимая их приказам и являясь последним оплотом рыцарской чести в эти темные времена. \
        Твой взор устремлен лишь на правящего Султана, а твоя жизнь принадлежит его безопасности. Не подведи."
	display_order = JDO_KNIGHT
	whitelist_req = TRUE
	outfit = /datum/outfit/job/roguetown/cataphract
	advclass_cat_rolls = list(CTAG_CATAPHRACT = 20)
	job_traits = list(TRAIT_NOBLE, TRAIT_STEELHEARTED, TRAIT_GUARDSMAN)
	give_bank_account = 22
	noble_income = 10
	min_pq = 10
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_desert2.ogg'
	job_subclasses = list(
		/datum/advclass/cataphract/greatweapon,
		/datum/advclass/cataphract/shieldmaster,
		/datum/advclass/cataphract/dervish,
		/datum/advclass/cataphract/rais_cataphract,
		)
	same_job_respawn_delay = 30 MINUTES

/datum/outfit/job/roguetown/cataphract
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/cataphract/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Faris"
		if(should_wear_femme_clothes(H))
			honorary = "Farisah"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/client/player = H.client
		if(!player && M)
			player = M.client
		if(player?.prefs)
			if(SSmapping.config.map_name == "Desert Town")
				if(!istype(player.prefs.virtue_origin, /datum/virtue/origin/raneshen) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/naledi) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/zybantian))
					var/list/new_origins = list("Raneshen" = /datum/virtue/origin/raneshen, 
					"Naledi" = /datum/virtue/origin/naledi,
					"Zybantu" = /datum/virtue/origin/zybantian)
					var/new_origin
					var/choice = input(player, "Your origins are not compatible with the Sultanate. Where do you hail from?", "ANCESTRY") as anything in new_origins
					if(choice)
						new_origin = new_origins[choice]
					else
						to_chat(player, span_notice("No choice detected. Picking a random compatible origin."))
						new_origin = pick(/datum/virtue/origin/raneshen, /datum/virtue/origin/naledi, /datum/virtue/origin/zybantian)
					var/datum/virtue/origin/applied_origin = new new_origin()
					player.prefs.virtue_origin = applied_origin
					apply_virtue(H, applied_origin)

/datum/outfit/job/roguetown/cataphract
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
	)

/datum/advclass/cataphract/greatweapon
	name = "Greatweapon Warrior"
	tutorial = "Твои тренировки были суровы, а удары твои сокрушают врагов с силой самой пустынной бури. \
    Ты довел до совершенства владение тяжелыми мечами, боевыми топорами, булавами и алебардами, что подобает истинному Фарису."
	outfit = /datum/outfit/job/roguetown/cataphract/greatweapon

	subclass_virtues = list(
		/datum/virtue/utility/riding)

	category_tags = list(CTAG_CATAPHRACT)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/cataphract/greatweapon/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Claymore","Great Mace","Battle Axe","Greataxe","Estoc","Lucerne","Partizan", "Lance + Scimitar")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Claymore")
				r_hand = /obj/item/rogueweapon/greatsword/zwei
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Great Mace")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("Battle Axe")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("Estoc")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Lucerne")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("Partizan")
				r_hand = /obj/item/rogueweapon/spear/partizan
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("Lance + Scimitar")
				r_hand = /obj/item/rogueweapon/spear/lance
				backl = /obj/item/rogueweapon/scabbard/gwstrap				
				l_hand = /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
				beltl = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	head = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cataphract
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate
	cloak = /obj/item/clothing/cloak/catcloak
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/shalal
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/cataphract = 1
	)

/datum/advclass/cataphract/shieldmaster
	name = "Shieldmaster"
	tutorial = "Ты обучен традиционной пешей рати, мастерски владея мечами, кистенями или палицами. \
    Твоя стойкость и искусство сочетать надежный щит с клинком делают тебя противником, чью оборону почти невозможно сокрушить!"
	outfit = /datum/outfit/job/roguetown/cataphract/shieldmaster
	
	subclass_virtues = list(
		/datum/virtue/utility/riding)

	category_tags = list(CTAG_CATAPHRACT)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,

		/datum/skill/misc/riding = SKILL_EXP_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/cataphract/shieldmaster/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Shamshir","Whip","Warhammer","Sabre")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Shamshir")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("Whip")
				l_hand = /obj/item/rogueweapon/whip/antique
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
			if("Warhammer")
				l_hand = /obj/item/rogueweapon/mace/warhammer
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("Sabre")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	backl = /obj/item/rogueweapon/shield/iron/zybantine
	head = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cataphract
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate
	cloak = /obj/item/clothing/cloak/catcloak
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/shalal
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/cataphract = 1
	)

/datum/advclass/cataphract/dervish
	name = "Royal Dervish"
	tutorial = "Твои боевые навыки необычны для Фариса. \
    Твои стремительные маневры и мастерское владение клинком приводят в восторг даже самую искушенную хассу, ведь ты отдаешь предпочтение быстрым и элегантным стальным клинкам. \
    Пусть ты вполне эффективен в средних доспехах, но твои навыки уклонения по-настоящему раскроются, лишь когда ты облачишься в более легкую защиту."
	outfit = /datum/outfit/job/roguetown/cataphract/dervish
	
	subclass_virtues = list(
		/datum/virtue/utility/riding)
	
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_DODGEEXPERT)
	category_tags = list(CTAG_CATAPHRACT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 3,
		STATKEY_SPD = 4,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/cataphract/dervish/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Scimitar + Longbow","Estoc + Recurve Bow","Sabre + Shield","Whip + Crossbow")
		var/armor_options = list("Light Coat", "Light Brigandine", "Scalemail")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)
			if("Scimitar + Longbow")
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				beltl = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltr = /obj/item/quiver/arrows
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

			if("Estoc + Recurve Bow")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

			if("Sabre + Shield")
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/iron/zybantine
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

			if("Whip + Crossbow")
				beltl = /obj/item/rogueweapon/whip
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/bolt/standard
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)

		switch(armor_choice)
			if("Light Coat")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
			if("Light Brigandine")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
				pants = /obj/item/clothing/under/roguetown/splintlegs
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
			if("Scalemail")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
				pants = /obj/item/clothing/under/roguetown/chainlegs
				armor = /obj/item/clothing/suit/roguetown/armor/plate/raneshen_scale
	head = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate
	cloak = /obj/item/clothing/cloak/catcloak
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/shalal
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/cataphract = 1
	)
    
/datum/advclass/cataphract/rais_cataphract
	name = "Rais-Cataphract"
	tutorial = "Вы - глава и абсолютный авторитет среди катафрактов, стоящий на страже Султаната. \
    Вы так долго вели элитную тяжелую кавалерию сквозь вихри войн, что Вас отметил лично Султан своим вниманием и удостоил Вас честью вести его катафрактов в бой. \
    Пусть ни один враг во всей Гримории не забывает тяжесть вашей поступи. Вашей зибантийской сталью и сокрушительным натиском кавалерии вы растоптали больше жизней, \
    чем любой придворный интриган или палач-наместник когда-либо мог занести в свои тайные списки заговоров."
	outfit = /datum/outfit/job/roguetown/cataphract/rais_cataphract
	maximum_possible_slots = 1
	category_tags = list(CTAG_CATAPHRACT)

	subclass_virtues = list(
	/datum/virtue/utility/riding)

	traits_applied = list(TRAIT_HEAVYARMOR)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 2
	)
	
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/obj/item/clothing/cloak/cataphract_rais
    name = "Rais-Cataphract's cloak"
    desc = "Безумно красиво и не менее безумно дорогой плащ, выполненный из лучшего шёлка и окрашенный в пурпурный цвет. Ловцы багрянок - так называют людей добывающих пурпур - трудятся не менее месяца ради одного такого плаща. Носить такое - признак авторитета и богатства."
    icon = 'icons/roguetown/clothing/special/captain.dmi'
    mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
    sleeved = 'icons/roguetown/clothing/special/onmob/captain.dmi'
    sleevetype = "shirt"
    icon_state = "capcloak"
    detail_tag = "_detail"
    alternate_worn_layer = CLOAK_BEHIND_LAYER
    detail_color = "#8747B1"
    color = "#FFFFFF"
    sellprice = 500

/datum/outfit/job/roguetown/cataphract/rais_cataphract/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Edict","Heavy Scimitar","Shamshir","Warhammer")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/second_weapons = list("Kite Shield & elvish dagger", "Crossbow & bolts", "Recurve Bow & arrows", "Lance")
		var/second_weapon_choice = input(H, "Choose your secondary weapon.", "TAKE UP ARMS") as anything in second_weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Edict")
				r_hand = /obj/item/rogueweapon/sword/sabre/banneret
				beltl = /obj/item/rogueweapon/scabbard/sword/royal
			if("Heavy Scimitar")
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
				beltl = /obj/item/rogueweapon/scabbard/sword/royal
			if("Shamshir")
				beltl = /obj/item/rogueweapon/scabbard/sword/royal
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
			if("Warhammer")
				r_hand = /obj/item/rogueweapon/mace/warhammer/steel
		switch(second_weapon_choice)
			if("Kite Shield & elvish dagger")
				beltr = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
				l_hand = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank(/datum/skill/combat/shields, SKILL_LEVEL_MASTER, TRUE)		
			if("Crossbow & bolts")
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/bolt/standard
				H.adjust_skillrank(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
			if("Recurve Bow & arrows")
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltr = /obj/item/quiver/bodkin
				H.adjust_skillrank(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
			if("Lance")
				l_hand = /obj/item/rogueweapon/spear/lance
				backl = /obj/item/rogueweapon/scabbard/gwstrap
	
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	head = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cataphract
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate
	cloak = /obj/item/clothing/cloak/cataphract_rais
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/shalal
	id = /obj/item/scomstone/garrison

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/cataphract = 1		
	)