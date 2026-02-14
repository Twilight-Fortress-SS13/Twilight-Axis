/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/bandit
	name = "studied jacket"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin but it does look fancy."
	color = "#B36A57"
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER

/datum/advclass/twilight_afreet
	name = "Afreet"
	tutorial = "'Demon of Fire', the slaves used to call you, when you, dressed in black uniform, emerged from the sands, having shot their masters dead with weapons they could not comprehend. During the War, you were deployed deep within the Naledi lands, tasked with plundering Golden Empire's slave trade routes. Perhaps you found it too profitable and enjoyable to leave behind, or perhaps you still wage your war to this day — either way, you no longer answer to the Kaiser or his lackeys."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/twilight_afreet
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_corsair.ogg'
	maximum_possible_slots = 2
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_FIREARMS_MARKSMAN, TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT)
	classes = list("Jäger Deserter" = "Ex-soldier with handgonne, excellent survival skills and axe to chop some wood and heads", "Veteran" = "Long ago you were a soldier...or pretend to be. Now you are a man from the road with your trusty pistol and dagger")
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 3,
		STATKEY_PER = 3,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
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
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/bandit/twilight_afreet/pre_equip(mob/living/carbon/human/H) //Basically an evil jager
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/zizo) || istype(H.patron, /datum/patron/inhumen/matthios) || istype(H.patron, /datum/patron/inhumen/graggar) || istype(H.patron, /datum/patron/inhumen/baotha)))
		to_chat(H, span_warning("My former deity has abandoned me.. Matthios is my new master."))
		H.set_patron(/datum/patron/inhumen/matthios)	//We allow other heretics into the cool-kids club, but if you are a tennite/psydonian it sets you to matthiosan.
	beltl = /obj/item/quiver/twilight_bullet/lead
	neck = /obj/item/clothing/neck/roguetown/coif
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	id = /obj/item/mattcoin
	var/classes = list("Jäger Deserter", "Veteran")
	var/classchoice = input("Choose your archetypes", "Available archetypes") as anything in classes
	switch(classchoice)
		if("Jäger Deserter")
			mask = /obj/item/clothing/mask/rogue/facemask/steel
			cloak = /obj/item/clothing/cloak/half/brown
			backr = /obj/item/gun/ballistic/twilight_firearm/flintgonne
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
			armor = /obj/item/clothing/suit/roguetown/armor/leather
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
			beltr = /obj/item/rogueweapon/stoneaxe/woodcut
			backl = /obj/item/storage/backpack/rogue/backpack
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
			head = /obj/item/clothing/head/roguetown/grenzelhofthat
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			belt = /obj/item/storage/belt/rogue/leather
			backpack_contents = list(
				/obj/item/twilight_powderflask = 1, 
				/obj/item/rogueweapon/huntingknife = 1, 
				/obj/item/flint = 1, /obj/item/bedroll = 1, 
				/obj/item/needle/thorn = 1, 
				/obj/item/natural/cloth/bandage = 1, 
				/obj/item/flashlight/flare/torch = 1
			)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("Veteran")
			mask = /obj/item/clothing/mask/rogue/ragmask/red
			armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/bandit
			shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
			beltr = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
			backl = /obj/item/storage/backpack/rogue/satchel
			wrists = /obj/item/rogueweapon/katar/punchdagger
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
			belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt
			backpack_contents = list(
				/obj/item/twilight_powderflask = 1,  
				/obj/item/needle/thorn = 1, 
				/obj/item/natural/cloth/bandage = 1, 
				/obj/item/flashlight/flare/torch = 1,
				/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1
			)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 1, TRUE)
