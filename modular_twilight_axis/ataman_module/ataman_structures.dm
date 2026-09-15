/obj/structure/trap/ataman_ambush_stone
	name = "stone"
	desc = "A piece of rough ground stone."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stone1"
	charges = 1
	time_between_triggers = 0
	checks_antimagic = FALSE
	var/datum/weakref/placed_by_ref
	var/list/bandit_types = list(/mob/living/carbon/human/npc/ataman_bandit)
	var/being_removed = FALSE

/obj/structure/trap/ataman_ambush_stone/Crossed(atom/movable/AM)
	var/mob/living/carbon/human/placer = placed_by_ref?.resolve()
	if(ataman_bandit_belongs_to(AM, placer))
		return
	return ..()

/obj/structure/trap/ataman_ambush_stone/proc/set_placer(mob/living/carbon/human/placer)
	if(!placer)
		return
	placed_by_ref = WEAKREF(placer)
	if(placer.mind)
		immune_minds += placer.mind
	ataman_register_ambush(placer, src)

/obj/structure/trap/ataman_ambush_stone/proc/disguise_as_prop(new_name, new_desc, new_icon, new_icon_state)
	name = new_name
	desc = new_desc
	icon = new_icon
	icon_state = new_icon_state

/obj/structure/trap/ataman_ambush_stone/flare()
	alpha = 200
	last_trigger = world.time
	charges--
	animate(src, alpha = 0, time = 2)
	QDEL_IN(src, 2)

/obj/structure/trap/ataman_ambush_stone/examine(mob/user)
	return

/obj/structure/trap/ataman_ambush_stone/attack_hand(mob/user)
	var/mob/living/carbon/human/placer = placed_by_ref?.resolve()
	if(user == placer)
		begin_owner_removal(placer)
		return TRUE
	return ..()

/obj/structure/trap/ataman_ambush_stone/attackby(obj/item/I, mob/user, params)
	var/mob/living/carbon/human/placer = placed_by_ref?.resolve()
	if(user == placer)
		begin_owner_removal(placer)
		return TRUE
	return ..()

/obj/structure/trap/ataman_ambush_stone/proc/begin_owner_removal(mob/living/carbon/human/placer)
	if(being_removed || QDELETED(src))
		return
	being_removed = TRUE
	placer.visible_message(
		span_notice("[placer] begins dismantling something hidden on the ground."),
		span_notice("I begin dismantling my ambush."),
	)
	if(do_after(placer, 5 SECONDS, target = src) && !QDELETED(src))
		to_chat(placer, span_notice("I dismantle my ambush."))
		qdel(src)
		return
	being_removed = FALSE

/obj/structure/trap/ataman_ambush_stone/trap_effect(mob/living/L)
	spring_ambush(L)

/obj/structure/trap/ataman_ambush_stone/proc/is_valid_ambush_spawn(turf/candidate, turf/spawn_center, list/used_turfs, exact_distance)
	if(!isopenturf(candidate) || candidate == spawn_center || (candidate in used_turfs))
		return FALSE
	if(istype(candidate, /turf/open/transparent/openspace) || candidate.is_blocked_turf(exclude_mobs = TRUE))
		return FALSE
	if(exact_distance && get_dist(candidate, spawn_center) != exact_distance)
		return FALSE
	var/distance = get_dist(candidate, spawn_center)
	return distance >= 1 && distance <= 5

/obj/structure/trap/ataman_ambush_stone/proc/pick_ambush_spawn(turf/spawn_center, list/used_turfs)
	var/desired_distance = rand(1, 5)
	var/list/candidates = list()
	for(var/turf/candidate as anything in RANGE_TURFS(5, spawn_center))
		if(is_valid_ambush_spawn(candidate, spawn_center, used_turfs, desired_distance))
			candidates += candidate
	if(!length(candidates))
		for(var/turf/candidate as anything in RANGE_TURFS(5, spawn_center))
			if(is_valid_ambush_spawn(candidate, spawn_center, used_turfs, 0))
				candidates += candidate
	if(!length(candidates))
		return null
	return pick(candidates)

/obj/structure/trap/ataman_ambush_stone/proc/spring_ambush(mob/living/trigger)
	var/mob/living/carbon/human/placer = placed_by_ref?.resolve()
	var/turf/spawn_center = get_turf(src)
	if(!spawn_center || !isliving(trigger))
		return

	var/datum/ataman_squad/squad = new
	squad.target_ref = WEAKREF(trigger)
	squad.gear_tier = placer ? clamp(max(placer.ataman_loot_tier, 1), 1, 5) : 1

	var/list/squad_size_range = ataman_squad_size_for_tier(placer?.ataman_loot_tier || 0)
	var/list/used_spawn_turfs = list()
	var/amount = rand(squad_size_range[1], squad_size_range[2])
	var/grabber_count = amount >= 4 ? 2 : 1
	ataman_ai_log(placer, "AMBUSH: springing on [trigger] at [spawn_center] - size=[amount] (range [squad_size_range[1]]-[squad_size_range[2]]) gear_tier=[squad.gear_tier] grabbers=[grabber_count]")
	for(var/i in 1 to amount)
		var/turf/spawn_location = pick_ambush_spawn(spawn_center, used_spawn_turfs)
		if(!spawn_location)
			break
		used_spawn_turfs += spawn_location
		var/mob_type = pick(bandit_types)
		var/mob/living/carbon/human/npc/ataman_bandit/bandit = new mob_type(spawn_location)
		var/role = i <= grabber_count ? ATAMAN_ROLE_GRABBER : (i == grabber_count + 1 ? ATAMAN_ROLE_BINDER : ATAMAN_ROLE_ENFORCER)
		bandit.set_ataman(placer, spawn_center, trigger, role, squad)

	if(placer)
		to_chat(placer, span_notice("My ambush springs on [trigger]!"))

/obj/structure/trap/ataman_snare
	name = "clod"
	desc = "A handful of earth."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "clod1"
	charges = 1
	time_between_triggers = 0
	trap_damage = 35
	var/bleed_bonus = 30
	var/datum/weakref/placed_by_ref

/obj/structure/trap/ataman_snare/examine(mob/user)
	return

/obj/structure/trap/ataman_snare/Crossed(atom/movable/AM)
	var/mob/living/carbon/human/placer = placed_by_ref?.resolve()
	if(ataman_bandit_belongs_to(AM, placer))
		return
	return ..()

/obj/structure/trap/ataman_snare/proc/set_placer(mob/living/carbon/human/placer)
	if(!placer)
		return
	placed_by_ref = WEAKREF(placer)
	if(placer.mind)
		immune_minds += placer.mind
	ataman_register_trap(placer, src)

/obj/structure/trap/ataman_snare/trap_effect(mob/living/L)
	def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	L.apply_damage(trap_damage, BRUTE, def_zone, L.run_armor_check(def_zone, "stab", armor_penetration = PEN_LIGHT, damage = trap_damage))
	L.simple_bleeding += bleed_bonus
	L.Paralyze(30)
	to_chat(L, span_danger("<B>[src] bites into me - I'm bleeding badly!</B>"))
	playsound(src, 'sound/items/beartrap.ogg', 100, TRUE)
	var/mob/living/carbon/human/placer = placed_by_ref?.resolve()
	L.AddComponent(/datum/component/ataman_marked, placer)

/obj/structure/trap/ataman_snare/beartrap_type
	name = "stick"
	desc = "A tree branch perhaps."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stick1"

/obj/structure/trap/ataman_snare/beartrap_type/trap_effect(mob/living/L)
	..()
	L.visible_message(span_danger("A hidden trap snaps shut on [L]!"))

/obj/structure/trap/ataman_snare/bomb_type
	name = "stone"
	desc = "A piece of rough ground stone."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stone1"

/obj/structure/trap/ataman_snare/bomb_type/trap_effect(mob/living/L)
	..()
	L.visible_message(span_danger("A buried charge rips into [L]!"))

/obj/structure/trap/ataman_snare/stakes_type
	name = "clod"
	desc = "A handful of earth."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "clod1"

/obj/structure/trap/ataman_snare/stakes_type/trap_effect(mob/living/L)
	..()
	L.visible_message(span_danger("[L] falls onto a bed of hidden stakes!"))

/datum/component/ataman_marked
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/datum/weakref/marked_by_ref
	var/mutable_appearance/marker_overlay
	var/expire_timer

/datum/component/ataman_marked/Initialize(mob/living/carbon/human/marker, duration = 90 SECONDS)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	if(marker)
		marked_by_ref = WEAKREF(marker)

	var/mob/living/L = parent
	marker_overlay = mutable_appearance('icons/mob/mob_effects.dmi', "eff_exposed", ABOVE_MOB_LAYER)
	marker_overlay.pixel_y = 32
	marker_overlay.plane = ABOVE_LIGHTING_PLANE
	marker_overlay.alpha = 255
	marker_overlay.appearance_flags = RESET_ALPHA | RESET_COLOR
	L.add_overlay(marker_overlay)

	expire_timer = addtimer(CALLBACK(src, PROC_REF(expire)), duration, TIMER_STOPPABLE)

/datum/component/ataman_marked/proc/expire()
	qdel(src)

/datum/component/ataman_marked/proc/get_marker()
	if(!marked_by_ref)
		return null
	return marked_by_ref.resolve()

/datum/component/ataman_marked/Destroy()
	var/mob/living/L = parent
	if(L && marker_overlay)
		L.cut_overlay(marker_overlay)
	marker_overlay = null
	if(expire_timer)
		deltimer(expire_timer)
		expire_timer = null
	return ..()

/datum/component/ataman_finishing_projectile
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/datum/weakref/shooter_ref
	var/datum/weakref/target_ref
	var/datum/weakref/mark_ref

/datum/component/ataman_finishing_projectile/Initialize(mob/living/carbon/human/shooter, mob/living/target, datum/component/ataman_marked/mark)
	if(!istype(parent, /obj/projectile) || !shooter || !target || !mark)
		return COMPONENT_INCOMPATIBLE
	shooter_ref = WEAKREF(shooter)
	target_ref = WEAKREF(target)
	mark_ref = WEAKREF(mark)
	RegisterSignal(parent, COMSIG_PROJECTILE_SELF_ON_HIT, PROC_REF(on_projectile_hit))

/datum/component/ataman_finishing_projectile/proc/on_projectile_hit(obj/projectile/source, mob/firer, atom/hit_target, angle)
	SIGNAL_HANDLER
	var/mob/living/expected_target = target_ref?.resolve()
	if(hit_target != expected_target)
		qdel(src)
		return
	var/mob/living/carbon/human/shooter = shooter_ref?.resolve()
	var/datum/component/ataman_marked/mark = mark_ref?.resolve()
	if(!QDELETED(mark) && shooter && ataman_get_owned_mark(expected_target, shooter) == mark)
		qdel(mark)
	if(shooter)
		shooter.visible_message(
			span_danger("[shooter]'s finishing shot slams into [expected_target]!"),
			span_notice("My finishing shot slams into [expected_target]!"),
		)
	qdel(src)

/datum/component/ataman_finishing_projectile/Destroy()
	if(parent)
		UnregisterSignal(parent, COMSIG_PROJECTILE_SELF_ON_HIT)
	shooter_ref = null
	target_ref = null
	mark_ref = null
	return ..()

/mob/living/carbon/human/npc/ataman_bandit
	name = "bandit"
	real_name = "bandit"
	ai_controller = /datum/ai_controller/human_npc/ataman_bandit
	faction = list(FACTION_BANDITS)
	ambushable = FALSE

	var/datum/weakref/ataman_owner_ref
	var/datum/weakref/ataman_target_ref
	var/turf/ataman_spawn_turf
	var/ataman_role = ATAMAN_ROLE_ENFORCER
	var/datum/ataman_squad/ataman_squad
	var/ataman_gave_up = FALSE
	var/ataman_disbanding = FALSE
	var/ataman_idle_until = 0

/mob/living/carbon/human/npc/ataman_bandit/Initialize(mapload)
	. = ..()
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src)
	addtimer(CALLBACK(src, PROC_REF(finish_bandit_setup)), 1 SECONDS)

/mob/living/carbon/human/npc/ataman_bandit/proc/finish_bandit_setup()
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/highwayman)
	ataman_apply_bandit_gear(src, ataman_squad?.gear_tier || 1)
	ataman_ai_log(src, "gear applied at tier [ataman_squad?.gear_tier || 1]")
	dna.species.handle_body(src)
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()
	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/names/first_female.txt"))
	else
		real_name = pick(world.file2list("strings/names/first_male.txt"))
	name = real_name

/mob/living/carbon/human/npc/ataman_bandit/proc/set_ataman(mob/living/carbon/human/owner, turf/spawn_turf, mob/living/target, role = ATAMAN_ROLE_ENFORCER, datum/ataman_squad/squad)
	ataman_spawn_turf = spawn_turf || get_turf(src)
	ataman_role = role
	ataman_squad = squad
	if(role == ATAMAN_ROLE_GRABBER)
		upgrade_ai_controller(/datum/ai_controller/human_npc/ataman_bandit/grabber)
	if(target)
		ataman_target_ref = WEAKREF(target)
	if(ai_controller)
		ai_controller.set_blackboard_key(BB_ATAMAN_SPAWN_TURF, ataman_spawn_turf)
		ai_controller.set_blackboard_key(BB_ATAMAN_OWNER, owner)
		ai_controller.set_blackboard_key(BB_ATAMAN_TARGET, target)
		ai_controller.set_blackboard_key(BB_ATAMAN_ROLE, ataman_role)
		ai_controller.set_blackboard_key(BB_ATAMAN_SQUAD, squad)
		ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, target)
	ataman_ai_log(src, "spawned: role=[role] target=[target] spawn_turf=[ataman_spawn_turf] squad=[squad ? "#[REF(squad)]" : "none"]")
	if(!owner)
		return
	ataman_owner_ref = WEAKREF(owner)
	summoner = owner.real_name
	faction += "[owner.real_name]_ataman_gang"
	apply_mob_lifespan(src, owner, 5 MINUTES)

/proc/ataman_target_is_secured(atom/target)
	var/mob/living/carbon/C = target
	return istype(C) && C.handcuffed

/datum/targetting_datum/basic/ataman_bandit/can_attack(mob/living/living_mob, atom/the_target)
	var/datum/ai_controller/controller = living_mob.ai_controller
	if(!controller || the_target != controller.blackboard[BB_ATAMAN_TARGET])
		return FALSE
	if(the_target == controller.blackboard[BB_ATAMAN_OWNER] || ataman_target_is_secured(the_target))
		return FALSE
	return ..()

/datum/targetting_datum/basic/ataman_bandit/faction_check(mob/living/living_mob, mob/living/the_target)
	return FALSE

/datum/ai_controller/human_npc/ataman_bandit
	blackboard = list(
		BB_WEAPON_TYPE = /obj/item/rogueweapon,
		BB_ARMOR_CLASS = 2,
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/ataman_bandit(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/ataman_bandit(),

		BB_HUMAN_NPC_ATTACK_ZONE_COUNTER = 0,
		BB_HUMAN_NPC_LAST_ATTACK_ZONE = null,
		BB_HUMAN_NPC_WEAKPOINT = null,
		BB_HUMAN_NPC_JUMP_COOLDOWN = 0,
		BB_HUMAN_NPC_FLANK_ANGLE = null,
		BB_HUMAN_NPC_FLANK_TARGET = null,
		BB_HUMAN_NPC_HARASS_MODE = FALSE,
		BB_HUMAN_NPC_HARASS_RETREATING = FALSE,
		BB_HUMAN_NPC_HARASS_COOLDOWN = 0,
		BB_HUMAN_NPC_JUKE_COOLDOWN = 0,
		BB_HUMAN_NPC_FEINT_COOLDOWN = INFINITY,

		BB_ATAMAN_SPAWN_TURF = null,
		BB_ATAMAN_OWNER = null,
		BB_ATAMAN_TARGET = null,
		BB_ATAMAN_ROLE = ATAMAN_ROLE_ENFORCER,
		BB_ATAMAN_SQUAD = null,
		BB_ATAMAN_INTERCEPT_TURF = null,
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/ataman_leash,
		/datum/ai_planning_subtree/ataman_intercept,
		/datum/ai_planning_subtree/squad_flank,
		/datum/ai_planning_subtree/ataman_squad_tactics,
		/datum/ai_planning_subtree/ataman_disarm_restrain,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
	)

/datum/ai_controller/human_npc/ataman_bandit/TryPossessPawn(atom/new_pawn)
	. = ..()
	RegisterSignal(new_pawn, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(cancel_invalid_item_attack))
	RegisterSignal(new_pawn, COMSIG_HUMAN_EARLY_UNARMED_ATTACK, PROC_REF(cancel_invalid_unarmed_attack))

/datum/ai_controller/human_npc/ataman_bandit/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, COMSIG_HUMAN_EARLY_UNARMED_ATTACK))
	return ..()

/datum/ai_controller/human_npc/ataman_bandit/proc/cancel_invalid_item_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(user != pawn)
		return
	if(target == blackboard[BB_ATAMAN_OWNER] || target != blackboard[BB_ATAMAN_TARGET] || target.stat != CONSCIOUS || ataman_target_is_secured(target))
		return COMPONENT_ITEM_NO_ATTACK
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/victim = target
	var/mob/living/carbon/human/attacker = pawn
	var/zone = check_zone(attacker.zone_selected)
	if(zone == BODY_ZONE_CHEST && ataman_chest_broken(victim))
		return COMPONENT_ITEM_NO_ATTACK
	if(!ataman_weapon_is_blunt(weapon) && (zone == BODY_ZONE_HEAD || !ataman_zone_is_armored(victim, zone)))
		return COMPONENT_ITEM_NO_ATTACK

/datum/ai_controller/human_npc/ataman_bandit/proc/cancel_invalid_unarmed_attack(mob/living/source, atom/target, proximity)
	SIGNAL_HANDLER
	if(source != pawn)
		return
	var/mob/living/living_target = target
	if(target == blackboard[BB_ATAMAN_OWNER] || target != blackboard[BB_ATAMAN_TARGET] || !istype(living_target) || living_target.stat != CONSCIOUS || ataman_target_is_secured(target))
		return COMPONENT_NO_ATTACK_HAND

/datum/ai_controller/human_npc/ataman_bandit/grabber
	planning_subtrees = list(
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/ataman_leash,
		/datum/ai_planning_subtree/ataman_squad_tactics,
		/datum/ai_planning_subtree/ataman_disarm_restrain,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
	)
