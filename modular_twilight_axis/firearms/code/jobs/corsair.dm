/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/grenzelhoft
	name = "reichsmarine sailor's jacket"
	desc = "A dark coat commonly worn by Grenzelhoft sailors and officers. Made out of studded leather and provides decent protection against blades."
	color = "#3C3C3C"
	icon_state = "longcoat"
	item_state = "longcoat"
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 25

/datum/advclass/wretch/twilight_corsair
	name = "Corsair"
	tutorial = "During the Twilight War, you served aboard a Reichsmarine warship, intercepting, boarding and ravaging Golden Empire's trade vessels on Kaiser's orders. After the war ended, your crew saw it fit to continue with the practice, flying a flag with a different shade of black."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/wretch/twilight_corsair
	category_tags = list(CTAG_WRETCH)
	class_select_category = CLASS_CAT_RANGER
	traits_applied = list(TRAIT_FIREARMS_MARKSMAN)
	maximum_possible_slots = 2
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
	)
	classes = list("Kaper" = "During the Twilight War, you served aboard a Reichsmarine warship, intercepting, \
	boarding and ravaging Golden Empire's trade vessels on Kaiser's orders. \
	After the war ended, your crew saw it fit to continue with the practice, flying a flag with a different shade of black.",

	"Wōkòu" = "For a long time you plundered ships of various flags and origins, \
	burning through your lyfe on the islands of Kazengun. \
	After your peak, you were smashed against the rocks of battles and had to flee further from your native seas \
	to foreign lands to continue your trade.",

	"Reaver" = "Where others rely on speed and stealth, you learned that a ship's deck offers no cover. \
	Clad in maille and plate, you lead the boarding party through grapeshot and blade, \
	shrugging off blows that would fell a lesser corsair.")

	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_corsair.ogg'
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/wretch/twilight_corsair/pre_equip(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return
	..()
	H.adjust_blindness(-3)
	var/classes = list("Kaper", "Wōkòu", "Reaver")
	var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who am I?", "How much have I done?") as anything in crimes
	H.set_blindness(0)
	switch(classchoice)
		if("Kaper")
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.change_stat(STATKEY_SPD, 2)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
			belt = /obj/item/storage/belt/rogue/leather
			beltl = /obj/item/quiver/twilight_bullet/lead
			beltr = /obj/item/rogueweapon/scabbard/sword
			backl = /obj/item/storage/backpack/rogue/satchel
			neck = /obj/item/clothing/neck/roguetown/gorget
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
			head = /obj/item/clothing/head/roguetown/helmet/tricorn/grenzel
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/grenzelhoft
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
			shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
			gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
			r_hand = /obj/item/rogueweapon/sword/sabre
			mask = /obj/item/clothing/mask/rogue/facemask/steel
			backpack_contents = list(/obj/item/twilight_powderflask = 1, /obj/item/bomb = 2, /obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1)
			H.grant_language(/datum/language/grenzelhoftian)
			switch(crimeschoice)
				if("I'm nobody")
					backr = /obj/item/gun/ballistic/twilight_firearm/flintgonne
				if("They fear me")
					wretch_select_bounty(H)
					H.put_in_hands(new /obj/item/grapplinghook)
					backr = /obj/item/gun/ballistic/twilight_firearm/arquebus
					H.change_stat(STATKEY_PER, 1)
					H.change_stat(STATKEY_SPD, 1)
		if("Wōkòu")
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.change_stat(STATKEY_SPD, 2)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			mask = /obj/item/clothing/mask/rogue/facemask/steel/kazengun
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
			armor = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
			cloak = /obj/item/clothing/cloak/eastcloak1
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			head = /obj/item/clothing/head/roguetown/mentorhat
			gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
			shoes = /obj/item/clothing/shoes/roguetown/boots
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
			belt = /obj/item/storage/belt/rogue/leather/black
			beltl = /obj/item/quiver/twilight_bullet/lead
			beltr = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
			backl = /obj/item/storage/backpack/rogue/satchel
			backpack_contents = list(/obj/item/bomb/smoke = 2, /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1, /obj/item/twilight_powderflask = 1, /obj/item/rope/chain = 1)
			H.grant_language(/datum/language/kazengunese)
			switch(crimeschoice)
				if("I'm nobody")
					return
				if("They fear me")
					wretch_select_bounty(H)
					H.put_in_hands(new /obj/item/grapplinghook)
					H.change_stat(STATKEY_PER, 1)
					H.change_stat(STATKEY_SPD, 1)

		if("Reaver")
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
			pants = /obj/item/clothing/under/roguetown/chainlegs
			shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			cloak = /obj/item/clothing/cloak/darkcloak
			wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
			gloves = /obj/item/clothing/gloves/roguetown/plate/iron
			neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
			belt = /obj/item/storage/belt/rogue/leather
			backl = /obj/item/storage/backpack/rogue/satchel
			backpack_contents = list(/obj/item/twilight_powderflask = 1, /obj/item/bomb = 2, /obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1)
			H.grant_language(/datum/language/grenzelhoftian)

			var/helmets = list(
				"Pigface Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
				"Guard Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/guard,
				"Bucket Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
				"Knight Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/knight,
				"Armet" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/grenzelhoft,
				"Visored Sallet" = /obj/item/clothing/head/roguetown/helmet/sallet/visored/grenzelhoft,
				"Klappvisier Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/grenzelhoft,
				"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
				"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
				"Volf-Face Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
				"None"
			)
			var/helmchoice = input(H, "Choose your helm.", "Available helms") as anything in helmets
			if(helmchoice != "None")
				head = helmets[helmchoice]

			var/weapons = list("Steel Dagger", "Battle Axe")
			var/weapon_choice = input(H, "Choose your weapon.", "Available weapons") as anything in weapons
			switch(weapon_choice)
				if("Steel Dagger")
					beltl = /obj/item/rogueweapon/scabbard/sheath
					beltr = /obj/item/quiver/twilight_bullet/lead
					r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
					H.change_stat(STATKEY_SPD, 2)
					H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				if("Battle Axe")
					beltl = /obj/item/rogueweapon/stoneaxe/battle
					beltr = /obj/item/quiver/twilight_bullet/lead
					H.change_stat(STATKEY_STR, 2)
					H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)

			backr = /obj/item/gun/ballistic/twilight_firearm/arquebus
			if(crimeschoice == "They fear me")
				wretch_select_bounty(H)
				H.put_in_hands(new /obj/item/grapplinghook)
				H.change_stat(STATKEY_PER, 1)
				H.change_stat(STATKEY_CON, 1)
