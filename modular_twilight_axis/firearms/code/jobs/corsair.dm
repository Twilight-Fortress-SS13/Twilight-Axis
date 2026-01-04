/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/grenzelhoft
	name = "reichsmarine sailor's jacket"
	desc = "A dark coat commonly worn by Grenzelhoft sailors and officers. Made out of studded leather and provides decent protection against blades."
	color = "#3C3C3C"
	icon_state = "longcoat"
	item_state = "longcoat"
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 25

/datum/advclass/wretch/twilight_corsair
	name = "Sea Rogue"
	tutorial = "You spent your entire lyfe making a living through piracy in the seas of Grimoria, where gunpowder and steel were always your loyal companions."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/twilight_corsair
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_FIREARMS_MARKSMAN, TRAIT_DODGEEXPERT)
	maximum_possible_slots = 2
	classes = list("Kaper" = "During the Twilight War, you served aboard a Reichsmarine warship, intercepting, \
	boarding and ravaging Golden Empire's trade vessels on Kaiser's orders. \
	After the war ended, your crew saw it fit to continue with the practice, flying a flag with a different shade of black.",
	
	"Wōkòu" = "For a long time you plundered ships of various flags and origins, \
	burning through your lyfe on the islands of Kazengun. \
	After your peak, you were smashed against the rocks of battles and had to flee further from your native seas \
	to foreign lands to continue your trade.")

	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_corsair.ogg'
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/wretch/twilight_corsair/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	var/classes = list("Kaper", "Wōkòu")
	var/classchoice = input("Choose your archetypes", "Available archetypes") as anything in classes

	switch(classchoice)
		if("Kaper")
			H.set_blindness(0)
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
			backr = /obj/item/gun/ballistic/twilight_firearm/flintgonne
			r_hand = /obj/item/rogueweapon/sword/cutlass
			mask = /obj/item/clothing/mask/rogue/facemask/steel
			backpack_contents = list(/obj/item/twilight_powderflask = 1, /obj/item/natural/cloth = 1, /obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1)
			H.grant_language(/datum/language/grenzelhoftian)

		if("Wōkòu")
			H.set_blindness(0)
			mask = /obj/item/clothing/mask/rogue/facemask/steel/kazengun
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
			cloak = /obj/item/clothing/cloak/eastcloak1
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			head = /obj/item/clothing/head/roguetown/mentorhat
			gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
			shoes = /obj/item/clothing/shoes/roguetown/boots
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
			belt = /obj/item/storage/belt/rogue/leather/black
			beltl = /obj/item/quiver/twilight_bullet/lead
			beltr = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
			backl = /obj/item/storage/backpack/rogue/satchel
			backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1, /obj/item/twilight_powderflask = 1, /obj/item/natural/cloth = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1)
			H.grant_language(/datum/language/kazengunese)
	wretch_select_bounty(H)
