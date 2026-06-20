#define NECRA_GARDEN_HOWL_MIN 8 SECONDS
#define NECRA_GARDEN_HOWL_MAX 18 SECONDS
#define NECRA_GARDEN_LIFESPAN 5 MINUTES
#define MOVESPEED_ID_NECRA_GARDEN "necra_garden_swift"
#define MOVESPEED_ID_NECRA_GARDEN_RETURN "necra_garden_return"
#define BB_NECRA_GARDEN_RETURN_TARGET "necra_garden_return_target"

/datum/ai_controller/human_npc/necra_garden
	var/datum/weakref/necra_garden_summoner_ref
	var/datum/weakref/necra_garden_last_target_ref
	var/necra_garden_returning_to_summoner = FALSE
	var/necra_garden_ignore_target_change = FALSE
	planning_subtrees = list(
		/datum/ai_planning_subtree/necra_garden_return_to_summoner,
		/datum/ai_planning_subtree/call_for_help,
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/use_throwable,
		/datum/ai_planning_subtree/generic_wield,
		/datum/ai_planning_subtree/kick_attack,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/leap_attack,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
	)

/datum/ai_planning_subtree/necra_garden_return_to_summoner/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/datum/ai_controller/human_npc/necra_garden/garden_ai = controller
	if(!istype(garden_ai) || !garden_ai.necra_garden_returning_to_summoner)
		return
	return garden_ai.necra_garden_process_return_to_summoner()

/datum/targetting_datum/basic/necra_garden/can_attack(mob/living/living_mob, atom/the_target)
	var/datum/ai_controller/human_npc/necra_garden/garden_ai = living_mob.ai_controller
	if(istype(garden_ai) && garden_ai.necra_garden_get_summoner() == the_target)
		return necra_garden_can_attack_summoner(living_mob, the_target)
	return ..()

/datum/targetting_datum/basic/necra_garden/proc/necra_garden_can_attack_summoner(mob/living/living_mob, atom/the_target)
	if(isturf(the_target) || !the_target)
		return FALSE
	if(ismob(the_target))
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE
	if(living_mob.see_invisible < the_target.invisibility)
		return FALSE
	if(isturf(the_target.loc) && living_mob.z != the_target.z)
		return FALSE
	if(isliving(the_target))
		var/mob/living/L = the_target
		if(L.stat)
			return FALSE
		return TRUE
	return FALSE

/datum/ai_controller/human_npc/necra_garden/TryPossessPawn(atom/new_pawn)
	. = ..()
	set_blackboard_key(BB_TARGETTING_DATUM, new /datum/targetting_datum/basic/necra_garden)
	RegisterSignal(new_pawn, COMSIG_AI_BLACKBOARD_KEY_SET(BB_BASIC_MOB_CURRENT_TARGET), PROC_REF(necra_garden_on_target_set))

/datum/ai_controller/human_npc/necra_garden/UnpossessPawn(destroy)
	var/mob/living/living_pawn = pawn
	if(istype(living_pawn))
		living_pawn.remove_movespeed_modifier(MOVESPEED_ID_NECRA_GARDEN_RETURN)
	UnregisterSignal(pawn, COMSIG_AI_BLACKBOARD_KEY_SET(BB_BASIC_MOB_CURRENT_TARGET))
	necra_garden_summoner_ref = null
	necra_garden_last_target_ref = null
	necra_garden_returning_to_summoner = FALSE
	return ..()

/datum/ai_controller/human_npc/necra_garden/proc/necra_garden_set_summoner(mob/living/target)
	if(!istype(target) || necra_garden_summoner_ref)
		return
	necra_garden_summoner_ref = WEAKREF(target)

/datum/ai_controller/human_npc/necra_garden/proc/necra_garden_get_summoner()
	var/mob/living/summoner_target = necra_garden_summoner_ref?.resolve()
	if(summoner_target && !QDELETED(summoner_target))
		return summoner_target
	return null

/datum/ai_controller/human_npc/necra_garden/proc/necra_garden_on_target_set(mob/living/source, key)
	SIGNAL_HANDLER
	if(necra_garden_ignore_target_change)
		return
	var/atom/new_target = blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(new_target))
		return
	if(!necra_garden_summoner_ref && isliving(new_target))
		necra_garden_set_summoner(new_target)
	var/atom/last_target = necra_garden_last_target_ref?.resolve()
	var/mob/living/summoner_target = necra_garden_get_summoner()
	if(last_target && new_target != last_target && summoner_target && new_target != summoner_target)
		necra_garden_begin_return_to_summoner(summoner_target)
	necra_garden_last_target_ref = WEAKREF(new_target)

/datum/ai_controller/human_npc/necra_garden/proc/necra_garden_begin_return_to_summoner(mob/living/summoner_target)
	var/mob/living/living_pawn = pawn
	if(necra_garden_returning_to_summoner || QDELETED(living_pawn) || QDELETED(summoner_target))
		return
	necra_garden_returning_to_summoner = TRUE
	if(!living_pawn.has_movespeed_modifier(MOVESPEED_ID_NECRA_GARDEN_RETURN))
		living_pawn.add_movespeed_modifier(MOVESPEED_ID_NECRA_GARDEN_RETURN, multiplicative_slowdown = -1.0)
	clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
	clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
	clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	set_blackboard_key(BB_NECRA_GARDEN_RETURN_TARGET, summoner_target)
	set_ai_status(AI_STATUS_ON)
	CancelActions()

/datum/ai_controller/human_npc/necra_garden/proc/necra_garden_stop_return_to_summoner()
	necra_garden_returning_to_summoner = FALSE
	var/mob/living/living_pawn = pawn
	if(istype(living_pawn))
		living_pawn.remove_movespeed_modifier(MOVESPEED_ID_NECRA_GARDEN_RETURN)
	clear_blackboard_key(BB_NECRA_GARDEN_RETURN_TARGET)

/datum/ai_controller/human_npc/necra_garden/proc/necra_garden_process_return_to_summoner()
	var/mob/living/living_pawn = pawn
	var/mob/living/summoner_target = necra_garden_get_summoner()
	if(QDELETED(living_pawn) || living_pawn.stat == DEAD || QDELETED(summoner_target) || summoner_target.stat == DEAD)
		necra_garden_stop_return_to_summoner()
		return
	if(can_see(living_pawn, summoner_target))
		necra_garden_stop_return_to_summoner()
		necra_garden_ignore_target_change = TRUE
		set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, summoner_target)
		set_blackboard_key(BB_HIGHEST_THREAT_MOB, summoner_target)
		clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
		CancelActions()
		necra_garden_last_target_ref = WEAKREF(summoner_target)
		necra_garden_ignore_target_change = FALSE
		return
	if(blackboard[BB_NECRA_GARDEN_RETURN_TARGET] != summoner_target)
		set_blackboard_key(BB_NECRA_GARDEN_RETURN_TARGET, summoner_target)
	queue_behavior(/datum/ai_behavior/travel_towards, BB_NECRA_GARDEN_RETURN_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/mob/living/carbon/human/species/skeleton/npc/necra_garden
	threat_point = THREAT_MODERATE
	skel_outfit = /datum/outfit/job/roguetown/skeleton/npc/necra_garden
	ai_controller = /datum/ai_controller/human_npc/necra_garden
	pass_flags = PASSCLOSEDTURF

/mob/living/carbon/human/species/skeleton/npc/necra_garden/after_creation()
	..()
	pass_flags |= PASSCLOSEDTURF
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STUNIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
	add_movespeed_modifier(MOVESPEED_ID_NECRA_GARDEN, multiplicative_slowdown = -1.0)
	add_filter("necra_garden_aura", 2, list("type" = "outline", "color" = "#dcdcdc", "alpha" = 220, "size" = 1.5))
	add_filter("necra_garden_glow", 1, list("type" = "drop_shadow", "color" = "#c8c8c8a8", "size" = 2.5, "offset" = 0))
	addtimer(CALLBACK(src, PROC_REF(necra_garden_howl)), rand(2 SECONDS, 5 SECONDS))
	addtimer(CALLBACK(src, PROC_REF(necra_garden_expire)), NECRA_GARDEN_LIFESPAN)

/mob/living/carbon/human/species/skeleton/npc/necra_garden/proc/necra_garden_howl()
	if(QDELETED(src))
		return
	if(stat != DEAD)
		playsound(get_turf(src), 'sound/effects/ghost.ogg', 70, TRUE)
	addtimer(CALLBACK(src, PROC_REF(necra_garden_howl)), rand(NECRA_GARDEN_HOWL_MIN, NECRA_GARDEN_HOWL_MAX))

/mob/living/carbon/human/species/skeleton/npc/necra_garden/proc/aggro_at(atom/target)
	if(QDELETED(src) || QDELETED(target) || stat == DEAD)
		return
	var/datum/ai_controller/human_npc/necra_garden/garden_ai = ai_controller
	if(istype(garden_ai) && isliving(target))
		garden_ai.necra_garden_set_summoner(target)
	if(ai_controller)
		ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, target)
		ai_controller.set_ai_status(AI_STATUS_ON)
		ai_controller.CancelActions()

/mob/living/carbon/human/species/skeleton/npc/necra_garden/proc/necra_garden_purge_inventory()
	var/list/to_delete = list()
	for(var/obj/item/I in get_equipped_items(include_pockets = TRUE))
		to_delete += I
	for(var/obj/item/I as anything in held_items)
		if(I)
			to_delete += I
	QDEL_LIST(to_delete)

/mob/living/carbon/human/species/skeleton/npc/necra_garden/death(gibbed, nocutscene = FALSE)
	necra_garden_purge_inventory()
	..()
	new /obj/effect/temp_visual/gib_animation(get_turf(src), "gibbed-h")
	qdel(src)

/mob/living/carbon/human/species/skeleton/npc/necra_garden/proc/necra_garden_expire()
	if(QDELETED(src))
		return
	necra_garden_purge_inventory()
	visible_message(span_warning("[src] crumbles into ash as Necra's gardens call it back."))
	new /obj/effect/temp_visual/gib_animation(get_turf(src), "gibbed-h")
	qdel(src)

/datum/outfit/job/roguetown/skeleton/npc/necra_garden/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 14
	H.STASPD = 10
	H.STACON = 12
	H.STAWIL = 16
	H.STAINT = 3
	H.STALUC = 8
	name = "Skeleton"
	if(prob(75))
		head = /obj/item/clothing/head/roguetown/necrahood
	else
		mask = /obj/item/clothing/head/roguetown/necramask
		head = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
	cloak = /obj/item/clothing/cloak/templar/necran
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	pants = /obj/item/clothing/under/roguetown/tights/vagrant
	shoes = /obj/item/clothing/shoes/roguetown/boots
	switch(rand(1, 3))
		if(1)
			r_hand = /obj/item/rogueweapon/sword/iron
		if(2)
			r_hand = /obj/item/rogueweapon/mace
		if(3)
			r_hand = /obj/item/rogueweapon/spear
	H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/outfit/job/roguetown/skeleton/npc/necra_garden/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/I in H.get_equipped_items(include_pockets = TRUE))
		ADD_TRAIT(I, TRAIT_NODROP, TRAIT_GENERIC)
	for(var/obj/item/I as anything in H.held_items)
		if(I)
			ADD_TRAIT(I, TRAIT_NODROP, TRAIT_GENERIC)

#undef NECRA_GARDEN_HOWL_MIN
#undef NECRA_GARDEN_HOWL_MAX
#undef NECRA_GARDEN_LIFESPAN
#undef MOVESPEED_ID_NECRA_GARDEN
#undef MOVESPEED_ID_NECRA_GARDEN_RETURN
#undef BB_NECRA_GARDEN_RETURN_TARGET
