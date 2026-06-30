/datum/advclass/lost_grenzel/lost_jager
	name = "Lost Jäger"
	tutorial = "В пустынях Зибантии именно вы стали тем, кто помог выжить остальным товарищам - имея навыки к охоте и ориентированию на месте, вы смогли обеспечить своим товарищам безопасный проход."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/lost_grenzel/lost_jager
	traits_applied = list(TRAIT_SURVIVAL_EXPERT, TRAIT_SLEUTH, TRAIT_DODGEEXPERT, TRAIT_BADTRAINER)
	category_tags = list(CTAG_LOSTGRENZEL)
	subclass_languages = list(/datum/language/grenzelhoftian)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 4,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,	
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,	
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/hunting = SKILL_LEVEL_EXPERT,
	)
	extra_context = "Choose between Arquebus, Crossbow and Heavy Crossbow as your tool of the trade, gaining Mastery of selected weapon."

/datum/outfit/job/roguetown/lost_grenzel/lost_jager/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Trackers, Huntsmen, Marksmen. Those are the first words that describe a Jäger of the Freikorps. Usually drafted from recruits with hunting background, Jägers serve as support troops for the Imperial armies, scouting ahead of the main force, assassinating enemy officers, arranging crossings and foraging for much-needed supplies. As one of those elite soldiers, you are expected to provide the Guild with your expertise in tracking, and scouting. Alongside your marksmanship.")) //TA EDIT
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick/jager
	if(H.mind)
		var/armor_options = list("Light Brigandine", "Studded Leather Vest")
		var/armor_choice = input(H, "Choose your armor.", "DRESS UP") as anything in armor_options
		switch(armor_choice)
			if("Light Brigandine")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
			if("Studded Leather Vest")
				armor = /obj/item/clothing/suit/roguetown/armor/leather/studded	
		var/weapons = list("Crossbow & 20 Bolts","Heavy Crossbow & 8 Heavy Bolts","Arquebus & 30 Lead Bullets")
		var/weapon_choice = input(H, "Choose your weapon.", "TOOLS OF THE TRADE") as anything in weapons
		switch(weapon_choice)
			if("Crossbow & 20 Bolts")
				beltr = /obj/item/quiver/bolt/standard
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 5, TRUE)
			if("Heavy Crossbow & 8 Heavy Bolts")
				beltr = /obj/item/quiver/bolt/heavy/standard/
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_SPD, -1)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 5, TRUE)
			if("Arquebus & 30 Lead Bullets") //TA EDIT
				r_hand = /obj/item/gun/ballistic/twilight_firearm/arquebus
				l_hand = /obj/item/twilight_powderflask
				beltr = /obj/item/quiver/twilight_bullet/lead
				H.adjust_skillrank_up_to(/datum/skill/combat/twilight_firearms, 5, TRUE)
				ADD_TRAIT(H, TRAIT_FIREARMS_MARKSMAN, TRAIT_GENERIC)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/takeapprentice)
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/roguehood/shalal
	cloak = /obj/item/clothing/cloak/twilight_desert
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)