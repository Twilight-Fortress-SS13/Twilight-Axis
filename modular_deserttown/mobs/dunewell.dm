//Nomads from Dunewell, these travellers have since turned to prey upon the weak along Al Ashurs trade routes.
//Hostile bandit mobs for desert town

/datum/outfit/job/roguetown/human/northern/dunewell_raider/proc/add_random_deserter_cloak(mob/living/carbon/human/H)
	var/random_deserter_cloak = rand(1,4)
	switch(random_deserter_cloak)
		if(1)
			cloak = /obj/item/clothing/cloak/cape
		if(2)
			cloak = /obj/item/clothing/cloak
		if(3)
			cloak = /obj/item/clothing/cloak/dunestalker

/datum/outfit/job/roguetown/human/northern/dunewell_raider/proc/add_random_deserter_weapon(mob/living/carbon/human/H)
	var/random_deserter_weapon = rand(1,2)
	switch(random_deserter_weapon)
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
			l_hand = /obj/item/rogueweapon/shield/iron
		if(2)
			r_hand = /obj/item/rogueweapon/spear
			l_hand = /obj/item/rogueweapon/shield/iron

/datum/outfit/job/roguetown/human/northern/dunewell_raider/proc/add_random_deserter_weapon_hard(mob/living/carbon/human/H)
	var/add_random_deserter_weapon_hard = rand(1,4)
	switch(add_random_deserter_weapon_hard)
		if(1)
			r_hand = /obj/item/rogueweapon/sword/sabre/iron
			l_hand = /obj/item/rogueweapon/shield/iron
		if(2)
			r_hand = /obj/item/rogueweapon/spear
			l_hand = /obj/item/rogueweapon/shield/iron
		if(3)
			r_hand = /obj/item/rogueweapon/halberd/bardiche
		if(4)
			r_hand = /obj/item/rogueweapon/flail
			l_hand = /obj/item/rogueweapon/shield/iron

/datum/outfit/job/roguetown/human/northern/dunewell_raider/proc/add_random_deserter_beltl_stuff(mob/living/carbon/human/H)
	var/add_random_deserter_beltl_stuff = rand(1,9)
	switch(add_random_deserter_beltl_stuff)
		if(1)
			beltl = /obj/item/storage/belt/rogue/pouch/food
		if(2)
			beltl = /obj/item/storage/belt/rogue/pouch/medicine
		if(3)
			beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
		if(4)
			beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
		if(5)
			beltl = /obj/item/reagent_containers/glass/bottle/waterskin
		if(6)
			beltl = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot
		if(7)
			beltl = /obj/item/rogueweapon/scabbard/sheath
		if(8)
			beltl = /obj/item/storage/belt/rogue/pouch/treasure
		if(9)
			beltl = /obj/item/storage/belt/rogue/pouch/treasure

/datum/outfit/job/roguetown/human/northern/dunewell_raider/proc/add_random_deserter_beltr_stuff(mob/living/carbon/human/H)
	var/add_random_deserter_beltr_stuff = rand(1,7)
	switch(add_random_deserter_beltr_stuff)
		if(1)
			beltr = /obj/item/storage/belt/rogue/pouch/food
		if(2)
			beltr = /obj/item/storage/belt/rogue/pouch/medicine
		if(3)
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
		if(4)
			beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
		if(5)
			beltr = /obj/item/reagent_containers/glass/bottle/waterskin
		if(6)
			beltr = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot
		if(7)
			beltr = /obj/item/rogueweapon/scabbard/sword

/datum/outfit/job/roguetown/human/northern/dunewell_raider/proc/add_random_deserter_armor_hard(mob/living/carbon/human/H)
	var/random_deserter_armor_hard = rand(1,3)
	switch(random_deserter_armor_hard)
		if(1)
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
		if(2)
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/heavy
		if(3)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/scale

/mob/living/carbon/human/species/human/northern/dunewell_raider
	name = "Dunewell Raider"
	ai_controller = /datum/ai_controller/human_npc
	faction = list("dunewell", FACTION_BANDITS)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/human/northern/dunewell_raider/ambush
	threat_point = THREAT_HIGH
	ambush_faction = "dunewell"

/mob/living/carbon/human/species/human/northern/dunewell_raider/Initialize(mapload)
	. = ..()
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	INVOKE_ASYNC(src, .proc/dunewell_post_init)

/mob/living/carbon/human/species/human/northern/dunewell_raider/proc/dunewell_post_init()
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/dunewell_raider)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	if(head)
		head.sellprice = 50

/datum/outfit/job/roguetown/human/northern/dunewell_raider/pre_equip(mob/living/carbon/human/H)
	..()
	H.eye_color = "27becc"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle = "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
		H.facial_hairstyle = "Beard (Manly)"
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.STASTR = rand(12, 14)
	H.STASPD = 11
	H.STACON = rand(11, 13)
	H.STAWIL = 13
	H.STAPER = 11
	H.STAINT = 10
	add_random_deserter_cloak(H)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/roguehood/shalal
	gloves = /obj/item/clothing/gloves/roguetown/bandages
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/splintlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	add_random_deserter_weapon(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)

/mob/living/carbon/human/species/human/northern/dunewell_raider/better_gear
	name = "Dunewell Veteran Raider"
	ai_controller = /datum/ai_controller/human_npc
	faction = list("dunewell", FACTION_BANDITS)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/human/northern/dunewell_raider/better_gear/ambush
	threat_point = THREAT_TOUGH
	ambush_faction = "dunewell"

/mob/living/carbon/human/species/human/northern/dunewell_raider/better_gear/Initialize(mapload)
	. = ..()
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	INVOKE_ASYNC(src, .proc/dunewell_post_init)

/mob/living/carbon/human/species/human/northern/dunewell_raider/better_gear/proc/dunewell_post_init()
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/dunewell_raider/better_gear)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	if(head)
		head.sellprice = 50

/datum/outfit/job/roguetown/human/northern/dunewell_raider/better_gear/pre_equip(mob/living/carbon/human/H)
	H.eye_color = "27becc"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle = "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
		H.facial_hairstyle = "Beard (Manly)"
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.STASTR = rand(12, 14)
	H.STASPD = 11
	H.STACON = rand(11, 13)
	H.STAWIL = 13
	H.STAPER = 11
	H.STAINT = 10
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	add_random_deserter_armor_hard(H)
	add_random_deserter_cloak(H)
	neck = /obj/item/clothing/neck/roguetown/coif/padded
	head = /obj/item/clothing/head/roguetown/roguehood/shalal
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	add_random_deserter_weapon_hard(H)
	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)
