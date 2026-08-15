/datum/ai_controller/human_npc/melee/summoned_skeleton // TA EDIT START
	max_target_distance = 12
	idle_requires_client = TRUE // TA EDIT
	planning_subtrees = list(
		/datum/ai_planning_subtree/summoned_skeleton_find_target,
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/generic_wield,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
		/datum/ai_planning_subtree/find_weapon,
		/datum/ai_planning_subtree/equip_item,
		/datum/ai_planning_subtree/being_a_minion,
	) // TA EDIT END

/mob/living/carbon/human/species/skeleton/npc/summon //Unique skilled NPC summons exclusive to necromancers, these guys are a menace to fight. // TA EDIT START
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/npc/summon
	ai_controller = /datum/ai_controller/human_npc/melee/summoned_skeleton
	pet_passive = FALSE
	var/datum/weakref/summoner_ai_ref

/mob/living/carbon/human/species/skeleton/npc/summon/proc/set_summoner(mob/living/master)
	if(QDELETED(master))
		return
	summoner_ai_ref = WEAKREF(master)
	setup_summoner(master)

/mob/living/carbon/human/species/skeleton/npc/summon/after_creation()
	..()
	var/mob/living/master = summoner_ai_ref?.resolve()
	if(master)
		setup_summoner(master)

/mob/living/carbon/human/species/skeleton/npc/summon/proc/setup_summoner(mob/living/master)
	if(QDELETED(master) || !ai_controller)
		return
	if(master.mind?.current)
		master = master.mind.current
	summoner = master.real_name
	faction = list(FACTION_CABAL, "[master.real_name]_faction") // TA EDIT
	var/datum/antagonist/lich/lich_antag = master.mind?.has_antag_datum(/datum/antagonist/lich)
	if(lich_antag && master.real_name)
		faction += FACTION_UNDEAD
	ADD_TRAIT(src, TRAIT_CONJURED_SUMMON, TRAIT_GENERIC)
	pet_passive = FALSE
	ai_controller.CancelActions()
	ai_controller.clear_blackboard_key(BB_FOLLOW_TARGET)
	ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
	ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	ai_controller.clear_blackboard_key(BB_TRAVEL_DESTINATION)
	ai_controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
	ai_controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
	ai_controller.blackboard[BB_MOB_AGGRO_TABLE] = list()
	ai_controller.nudge_target_scan()
	ai_controller.reset_ai_status() // TA EDIT END

/datum/outfit/job/roguetown/npc/skeleton/npc/summon //On par getup almost with greater summons, because sovl.

	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	head = /obj/item/clothing/head/roguetown/helmet/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots

/datum/outfit/job/roguetown/npc/skeleton/npc/summon/pre_equip(mob/living/carbon/human/H)
	..()

	shirt = prob(50) ? /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant : /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	switch(rand(1, 4)) //Random Weaponry choices - Slightly larger pool than bog guards.
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
		if(2)
			r_hand = /obj/item/rogueweapon/spear
		if(3)
			r_hand = /obj/item/rogueweapon/mace
		if(4)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
	switch(rand(1, 3)) //Random Cloaks, akin to regular-ish necro skeletons.
		if(1)
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if(2)
			cloak = /obj/item/clothing/cloak/tabard/necro
		if(3)
			cloak = /obj/item/clothing/cloak/half/lich
	H.STASTR = rand(11,13)
	H.STASPD = 7 //Slightly slower cause you can have a LOT of these guys.
	H.STACON = 7 //Decently tough, has a lifespan + player tied, will still crumble to fients/numbers.
	H.STAINT = 1
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE) //Good parrying, still will crumble to numbers. Intended so lone advs/garrison can't just solo through a necromancer's summons with ease.
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)

	H.energy = H.max_energy //Always combat-ready
