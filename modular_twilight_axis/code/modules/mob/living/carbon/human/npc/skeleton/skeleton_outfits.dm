// Rockhill style medium skeleton
/mob/living/carbon/human/species/skeleton/npc/rockhill
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/rockhill

/datum/outfit/job/roguetown/skeleton/npc/rockhill/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 14
	H.STASPD = 8
	H.STACON = 6
	H.STAWIL = 15
	H.STAINT = 1
	name = "Skeleton"
	if(prob(10))
		head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	if(prob(10))
		armor = /obj/item/clothing/suit/roguetown/armor/plate/aalloy
	if(prob(25))
		shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	if(prob(90))
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(90))
		pants = /obj/item/clothing/under/roguetown/trou/leather
	if(prob(80))
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	if(prob(70))
		neck = /obj/item/clothing/neck/roguetown/coif
	if(prob(70))
		gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	if(prob(20))
		l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy
	if(prob(25))
		r_hand = /obj/item/rogueweapon/spear/aalloy
	else if(prob(25))
		r_hand = /obj/item/rogueweapon/mace/alloy
	else if(prob(25))
		r_hand = /obj/item/rogueweapon/sword/short/ashort
	else
		r_hand = /obj/item/rogueweapon/flail/aflail
	if(prob(40))
		belt = /obj/item/storage/belt/rogue/leather/rope
		if(prob(50))
			beltr = /obj/item/storage/belt/rogue/pouch/treasure/
		else
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
	if(prob(5))
		id = /obj/item/clothing/ring/aalloy
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

/mob/living/carbon/human/species/skeleton/npc/cultist
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/cultist

/datum/outfit/job/roguetown/skeleton/npc/cultist/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 12
	H.STASPD = 10
	H.STACON = 6
	H.STAWIL = 10
	H.STAINT = 1
	name = "Skeleton"
	if(prob(80))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/noc
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
	if(prob(20))
		head = /obj/item/clothing/head/roguetown/roguehood/nochood
	if(prob(30))
		head = /obj/item/clothing/head/roguetown/roguehood/black
	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/tights/random
	else
		pants = /obj/item/clothing/under/roguetown/loincloth
	if(prob(20))
		belt = /obj/item/storage/belt/rogue/leather/rope
		if(prob(50))
			beltr = /obj/item/storage/belt/rogue/pouch/treasure/
		else
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor/
	if(prob(5))
		id = /obj/item/clothing/ring/aalloy
	var/weapon_choice = rand(1, 4)
	switch(weapon_choice)
		if(1)
			r_hand = /obj/item/rogueweapon/sickle/aalloy
		if(2)
			r_hand = /obj/item/rogueweapon/woodstaff
		if(3)
			r_hand = /obj/item/rogueweapon/huntingknife/idagger/adagger
		if(4)
			r_hand = /obj/item/rogueweapon/mace/woodclub
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/obj/item/storage/belt/rogue/pouch/treasure/PopulateContents()
	new /obj/effect/spawner/lootdrop/mobtreasure(src)

/obj/effect/spawner/lootdrop/mobtreasure
	name = "mobtreasure spawner"
	icon_state = "hiclutter"
	lootcount = 1
	loot = list(
		/obj/item/reagent_containers/glass/bottle/clayfancyvase = 20,
		/obj/item/roguestatue/glass = 15,
		/obj/item/roguestatue/gold/loot = 1,
		/obj/item/roguestatue/silver = 2,
		/obj/item/roguestatue/steel = 5,
		/obj/item/clothing/neck/roguetown/psicross/silver = 2,
		/obj/item/clothing/neck/roguetown/psicross/g = 2,
		/obj/item/clothing/neck/roguetown/psicross/bpearl = 2,
		/obj/item/clothing/neck/roguetown/ornateamulet = 3,
		/obj/item/clothing/neck/roguetown/skullamulet = 2,
		/obj/item/clothing/ring/silver = 10,
		/obj/item/clothing/ring/gold = 15,
		/obj/item/clothing/ring/aalloy = 15,
		/obj/item/clothing/ring/emerald = 1,
		/obj/item/clothing/ring/aalloy = 15,
		/obj/item/clothing/neck/roguetown/psicross = 2,
		/obj/item/clothing/neck/roguetown/psicross/wood = 2,
		/obj/item/clothing/neck/roguetown/psicross/shell = 6,
		/obj/item/clothing/neck/roguetown/psicross/shell/bracelet = 6,
		/obj/item/clothing/neck/roguetown/psicross/pearl = 3,
		/obj/item/reagent_containers/glass/cup/silver/small = 3,
		/obj/item/reagent_containers/glass/cup/golden/small = 5,
		/obj/item/kitchen/spoon/gold = 5,
		/obj/item/kitchen/spoon/silver = 5,
		/obj/item/kitchen/fork/gold = 5,
		/obj/item/kitchen/fork/silver = 5,
		/obj/item/reagent_containers/glass/bowl/gold = 5,
		/obj/item/reagent_containers/glass/bowl/silver = 3,
		/obj/item/candle/gold/lit = 5,
		/obj/item/candle/silver/lit = 5,
		/obj/item/ingot/iron = 5,
		/obj/item/ingot/steel = 5,
		/obj/item/ingot/gold = 3,
		/obj/item/reagent_containers/powder/spice = 3,
		/obj/item/reagent_containers/powder/ozium = 3,
		/obj/item/roguecoin/copper/pile = 30,
		/obj/item/roguecoin/silver/pile = 15,
		)

/obj/effect/spawner/lootdrop/mobtreasure/lucky
	lootcount = 2
