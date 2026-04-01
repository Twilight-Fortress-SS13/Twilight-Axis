/obj/item/clothing/head/roguetown/duelhat/pretzel/skelet
	name = "old rebel's hat"
	desc = "Старая фаретровая шляпа, пожёванная временем, идеально подходит какому-нибудь бунтовщику против этого общество, позади которого ничего не осталось кроме кучки костей."
	max_integrity = 100
	armor = ARMOR_LEATHER
	body_parts_covered = HEAD|HAIR|EARS

/datum/advclass/wretch/thehero
	name = "Undead Warrior"
	tutorial = "You're a shkeleton! You already forgot how you got all these bones, but people fears you, they want to dig you down. Do it first."
	outfit = /datum/outfit/job/roguetown/wretch/hero
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT		//how the fuck you're a skeleton
	category_tags = list(CTAG_WRETCH)
	class_select_category = CLASS_CAT_ACCURSED
	min_pq = 30				//better RP?
	maximum_possible_slots = 2
	extra_context = "You're a SKELETON, be ready to shackle your bones. Minimum PQ Required: 30"
	traits_applied = list(
		TRAIT_NOHUNGER, 
		TRAIT_NOBREATH, 
		TRAIT_NOPAIN, 
		TRAIT_TOXIMMUNE, 
		TRAIT_SHOCKIMMUNE, 
		TRAIT_SILVER_WEAK,
		TRAIT_BREADY
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT
	)

/datum/outfit/job/roguetown/wretch/hero/proc/skelet(mob/living/carbon/human/H)
	H.hairstyle = "Bald"
	H.facial_hairstyle = "Shaved"
	ADD_TRAIT(H, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FACELESS_KNOWN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEATHLESS, TRAIT_GENERIC)
	H.dna.species.species_traits |= NOBLOOD
	H.mob_biotypes = MOB_UNDEAD
	for(var/obj/item/bodypart/B in H.bodyparts)
		B.skeletonize(FALSE)
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if (eyes)
		eyes.Remove(H, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(H)
	H.update_body()
	H.update_hair()
	H.update_body_parts(redraw = TRUE)
	for(var/datum/charflaw/cf in H.charflaws)
		H.charflaws.Remove(cf)
		QDEL_NULL(cf)
	H.dna.species.soundpack_m = new /datum/voicepack/skeleton()
	H.dna.species.soundpack_f = new /datum/voicepack/skeleton()

/datum/outfit/job/roguetown/wretch/hero/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	H.STAINT = 5			//Clever shkelet
	skelet(H)
	backpack_contents = list(
		/obj/item/recipe_book/survival = 1,
		/obj/item/repair_kit/metal/bad = 2,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
	)
	var/classes = list("Krieger", "Armbrustschütze", "Toter Aufrührer")
	var/classchoice = input("Choose your archetypes", "Available archetypes") as anything in classes

	switch(classchoice)
		if("Krieger")
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
			head = /obj/item/clothing/head/roguetown/roguehood/red
			backl = /obj/item/storage/backpack/rogue/satchel
			cloak = /obj/item/clothing/cloak/tabard
			armor = /obj/item/clothing/suit/roguetown/armor/plate/full/iron
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
			gloves = /obj/item/clothing/gloves/roguetown/plate/iron
			pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
			shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
			beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
			id = /obj/item/clothing/ring/aalloy
		if("Armbrustschütze")
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
			var/arch = list("Crossbow", "Bow")
			var/archchoice = input("HOW YOU FOUGHT 1000 YILS AGO", "Choose your WEAPON") as anything in arch
			switch(archchoice)
				if("Crossbow")
					H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
					backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
					beltl = /obj/item/quiver/bolt/standard
				if("Bow")
					H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
					backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
					beltl = /obj/item/quiver/arrows/bronze
			backl = /obj/item/storage/backpack/rogue/satchel
			neck = /obj/item/clothing/neck/roguetown/leather
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
			armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze
			cloak =	/obj/item/clothing/cloak/tabard/stabard/surcoat
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			gloves = /obj/item/clothing/gloves/roguetown/angle
			pants = /obj/item/clothing/under/roguetown/trou/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
			belt = /obj/item/storage/belt/rogue/leather
			beltr = /obj/item/rogueweapon/mace/cudgel
		if("Toter Aufrührer")
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/combat/twilight_firearms, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
			head = /obj/item/clothing/head/roguetown/duelhat/pretzel/skelet
			backl = /obj/item/storage/backpack/rogue/satchel
			neck = /obj/item/quiver/twilight_bullet/lead_ten
			shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
			cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
			shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
			belt = /obj/item/storage/belt/rogue/leather/double
			beltl = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
			backpack_contents = list(
				/obj/item/recipe_book/survival = 1,
				/obj/item/rogueweapon/huntingknife/idagger = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1,
				/obj/item/twilight_powderflask = 1,
				/obj/item/clothing/gloves/roguetown/knuckles/ancient = 1
			)

/datum/outfit/job/roguetown/wretch/hero/post_equip(mob/living/carbon/human/H)
	..()
	if(HAS_TRAIT(H, TRAIT_HEAVYARMOR))
		var/weapon = list("Flameberge", "Flail and Shield", "Mace")
		var/weaponchoice = input("HOW YOU FOUGHT 1000 YILS AGO", "Choose your WEAPON") as anything in weapon
		switch(weaponchoice)
			if("Flameberge")
				H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
				var/obj/item/rogueweapon/greatsword/grenz/flamberge/paalloy/W = new(get_turf(H))
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
				if(!H.put_in_hands(W))
					W.forceMove(get_turf(H))
			if("Flail and Shield")
				H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/iron/bone, SLOT_BACK_R, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/flail/sflail/paflail, SLOT_BELT_R, TRUE)
			if("Mace")
				H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
				var/obj/item/rogueweapon/mace/goden/aalloy/W = new(get_turf(H))
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
				if(!H.put_in_hands(W))
					W.forceMove(get_turf(H))

		//no castifico, you're a fucking skeleton. Life already punched you
