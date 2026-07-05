/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/freeman
	name = "studied jacket"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin but it does look fancy."
	color = "#B36A57"
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER

/datum/advclass/rih_al_sahra
	name = "Rih-Al-Sahra" // Что означает "Ветер Пустыни"
	tutorial = "«... Они, что были сломлены однажды, сломились вновь под ударами судьбы. Вернейшие из воинов Султана - стали его злейшими врагами ...»"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/freeman/rih_al_sahra
	category_tags = list(CTAG_FREEMAN)
	maximum_possible_slots = 3
	traits_applied = list(TRAIT_FIREARMS_MARKSMAN, TRAIT_STEELHEARTED)
	classes = list("Jannisary Deserter" = "Вы предали своего собственного Султана ради свободы своего народа. Вы были стрелком - и стрелком отличным.", "Desert Raider" = "Вы грабили караваны Султана ещё задолго до восстания шейхов, однако теперь у вас есть удачная возможность пограбить ещё - и за праведное дело, кто-же от такого отказывается?")
	subclass_stats = list(
		STATKEY_STR = 1, 
		STATKEY_WIL = 2,
		STATKEY_SPD = 3,
		STATKEY_PER = 3,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/freeman/rih_al_sahra/pre_equip(mob/living/carbon/human/H)
	..()
	if (!istype(H.patron, /datum/patron/inhumen/matthios))
		to_chat(H, span_warning("Борясь за свободу народа - или грабя богачей - я неминуемо стал исповедовать Аль-Маттиоса."))
		H.set_patron(/datum/patron/inhumen/matthios)
	beltl = /obj/item/quiver/twilight_bullet/lead
	neck = /obj/item/clothing/neck/roguetown/coif
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	id = /obj/item/mattcoin
	var/classes = list("Jannisary Deserter", "Desert Raider")
	var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes
	switch(classchoice)
		if("Jannisary Deserter")
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)        
			mask = /obj/item/clothing/mask/rogue/ragmask/red
			cloak = /obj/item/clothing/cloak/dunestalker
			backr = /obj/item/gun/ballistic/twilight_firearm/flintgonne
			pants = /obj/item/clothing/under/roguetown/sirwal/brown
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
			beltr = /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
			backl = /obj/item/storage/backpack/rogue/satchel
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
			head = /obj/item/clothing/head/roguetown/turban/brown
			wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
			belt = /obj/item/storage/belt/rogue/leather/cloth/sash/brown
			neck = /obj/item/clothing/neck/roguetown/gorget/steel
			backpack_contents = list(
				/obj/item/twilight_powderflask = 1, 
				/obj/item/rogueweapon/huntingknife = 1, 
				/obj/item/flint = 1, /obj/item/bedroll = 1, 
				/obj/item/needle/thorn = 1, 
				/obj/item/natural/cloth/bandage = 1, 
				/obj/item/flashlight/flare/torch = 1
			)
		if("Desert Raider")
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)        
			mask = /obj/item/clothing/mask/rogue/ragmask/red
			armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/freeman
			cloak = /obj/item/clothing/cloak/dunestalker
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
			beltr = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
			backl = /obj/item/storage/backpack/rogue/satchel
			wrists = /obj/item/rogueweapon/katar/punchdagger
			pants = /obj/item/clothing/under/roguetown/sirwal/brown
			belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt
			head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/raneshen
			backpack_contents = list(
				/obj/item/twilight_powderflask = 1,  
				/obj/item/needle/thorn = 1, 
				/obj/item/natural/cloth/bandage = 1, 
				/obj/item/flashlight/flare/torch = 1,
				/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1
			)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/riding, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 1, TRUE)
			apply_virtue(H, new /datum/virtue/utility/riding)
