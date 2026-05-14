#define MAX_RAISED_SKELETONS 2
#define TWILIGHT_NECRO_CRYSTAL_MAX_SUMMONS 1
#define TWILIGHT_NECRO_CRYSTAL_MAX_CHARGES 1

/datum/advclass/wretch/necromancer/post_equip(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(!spawned || QDELETED(spawned))
		return

	spawned.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_to_skeleton)

/obj/effect/proc_holder/spell/invoked/raise_to_skeleton
	name = "Raise to Skeleton"
	desc = "Reanimate a corpse as a player-controlled skeleton. The body must have all limbs and its head. Maximum 2 active skeletons."
	clothes_req = FALSE
	range = 7
	overlay_state = "animate"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 100
	chargetime = 60
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	invocations = list("Hygf'akni'kthakchratah!")
	invocation_type = "shout"
	chargedrain = 2
	recharge_time = 5 MINUTES
	var/list/raised_skeletons = list()
	var/mob/living/registered_caster
	var/caster_signal_registered = FALSE

/obj/effect/proc_holder/spell/invoked/raise_to_skeleton/proc/count_active()
	for(var/i in raised_skeletons.len to 1 step -1)
		var/mob/living/M = raised_skeletons[i]
		if(QDELETED(M) || M.stat == DEAD)
			raised_skeletons -= M
	return raised_skeletons.len

/obj/effect/proc_holder/spell/invoked/raise_to_skeleton/proc/on_skeleton_death(mob/living/source)
	SIGNAL_HANDLER
	raised_skeletons -= source
	UnregisterSignal(source, COMSIG_LIVING_DEATH)
	if(registered_caster && !QDELETED(registered_caster))
		to_chat(registered_caster, span_warning("One of my raised skeletons has fallen. I may raise another."))

/obj/effect/proc_holder/spell/invoked/raise_to_skeleton/proc/on_caster_death(mob/living/source)
	SIGNAL_HANDLER
	for(var/mob/living/M in raised_skeletons)
		to_chat(M, span_userdanger("My master has fallen! The binding weakens..."))
		UnregisterSignal(M, COMSIG_LIVING_DEATH)
	raised_skeletons.Cut()
	UnregisterSignal(source, COMSIG_LIVING_DEATH)
	caster_signal_registered = FALSE

/obj/effect/proc_holder/spell/invoked/raise_to_skeleton/cast(list/targets, mob/living/carbon/human/user)
	. = ..()

	if(!("undead" in user.faction))
		user.faction |= "undead"

	if(count_active() >= MAX_RAISED_SKELETONS)
		to_chat(user, span_warning("I cannot sustain another skeleton. My previous ones must perish first."))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/target = targets[1]

	if(!istype(target))
		to_chat(user, span_warning("I need to cast this spell on a corpse."))
		revert_cast()
		return FALSE

	if(target.stat != DEAD)
		to_chat(user, span_warning("I cannot raise the living."))
		revert_cast()
		return FALSE

	if(target in raised_skeletons)
		to_chat(user, span_warning("This corpse is already one of mine."))
		revert_cast()
		return FALSE

	var/static/list/forbidden_types = list(
		/mob/living/carbon/human/species/goblin,
		/mob/living/carbon/human/species/skeleton/npc
	)
	for(var/forbidden_type in forbidden_types)
		if(istype(target, forbidden_type))
			to_chat(user, span_warning("I cannot raise this body."))
			revert_cast()
			return FALSE

	var/obj/item/bodypart/target_head = target.get_bodypart(BODY_ZONE_HEAD)
	var/obj/item/bodypart/target_larm = target.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/target_rarm = target.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/target_lleg = target.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/target_rleg = target.get_bodypart(BODY_ZONE_R_LEG)
	if(!target_head || !target_larm || !target_rarm || !target_lleg || !target_rleg)
		to_chat(user, span_warning("This corpse is missing limbs."))
		revert_cast()
		return FALSE

	if(target.ckey)
		var/offer = tgui_alert(target, "A Necromancer wishes to reanimate your body as a skeleton minion. Do you accept?", "Raised by Necromancer", list("Yes", "Give to another", "No"), 15 SECONDS)

		if(count_active() >= MAX_RAISED_SKELETONS)
			to_chat(user, span_warning("I already have too many skeletons while waiting for a response."))
			return FALSE
		if(QDELETED(target) || target.stat != DEAD)
			return FALSE

		if(offer == "Yes")
			finalize_raise(target, user, target.ckey)
			return TRUE
		else if(offer == "No")
			to_chat(user, span_warning("The soul resists my power."))
			return FALSE

	var/list/candidates = pollGhostCandidates("Do you want to play as a Necromancer's skeleton?", ROLE_NECRO_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_NECROMANCER_SKELETON)

	if(count_active() >= MAX_RAISED_SKELETONS)
		to_chat(user, span_warning("I already have too many skeletons while waiting for souls."))
		return FALSE
	if(QDELETED(target) || target.stat != DEAD)
		return FALSE

	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("No souls answer my call."))
		return FALSE

	var/mob/dead/candidate = pick(candidates)
	if(QDELETED(candidate) || !istype(candidate, /mob/dead))
		to_chat(user, span_warning("The soul slipped away."))
		return FALSE

	if(istype(candidate, /mob/dead/new_player))
		var/mob/dead/new_player/N = candidate
		N.close_spawn_windows()

	finalize_raise(target, user, candidate.ckey)
	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_to_skeleton/proc/finalize_raise(mob/living/carbon/human/target, mob/living/carbon/human/master, new_ckey)
	target.revive(TRUE, TRUE)
	target.ckey = new_ckey

	if(!target.mind)
		target.mind_initialize()
	target.mind.current.job = null

	target.become_skeleton()

	target.patron = master.patron
	target.faction = list("undead", "[master.real_name]_faction")
	target.ambushable = FALSE
	target.underwear = "Nude"
	target.can_do_sex = FALSE
	target.cmode_music = 'sound/music/combat_cult.ogg'

	ADD_TRAIT(target, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)

	raised_skeletons += target
	RegisterSignal(target, COMSIG_LIVING_DEATH, PROC_REF(on_skeleton_death))

	if(!caster_signal_registered)
		registered_caster = master
		RegisterSignal(master, COMSIG_LIVING_DEATH, PROC_REF(on_caster_death))
		caster_signal_registered = TRUE

	target.visible_message(span_warning("[target.real_name]'s eyes light up with an evil glow!"))
	to_chat(target, span_userdanger("My master is [master.real_name]. I must obey [master.p_them()] as long as [master.p_they()] live."))

/datum/advclass/wretch/necromancer
	outfit = /datum/outfit/job/roguetown/wretch/necromancer/twilight_axis

/datum/outfit/job/roguetown/wretch/necromancer/twilight_axis/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(backpack_contents)
		backpack_contents -= /obj/item/necro_relics/necro_crystal
	else
		backpack_contents = list()
	backpack_contents[/obj/item/necro_relics/necro_crystal/twilight_axis] = 1

/obj/item/necro_relics/necro_crystal/Initialize(mapload)
	. = ..()
	if(type != /obj/item/necro_relics/necro_crystal || !isturf(loc))
		return .
	var/obj/item/necro_relics/necro_crystal/twilight_axis/replacement = new /obj/item/necro_relics/necro_crystal/twilight_axis(loc)
	replacement.copy_necro_crystal_state_from(src)
	return INITIALIZE_HINT_QDEL

/obj/item/necro_relics/necro_crystal/twilight_axis
	max_summons = TWILIGHT_NECRO_CRYSTAL_MAX_SUMMONS
	max_charges = TWILIGHT_NECRO_CRYSTAL_MAX_CHARGES
	current_charges = TWILIGHT_NECRO_CRYSTAL_MAX_CHARGES

/obj/item/necro_relics/necro_crystal/twilight_axis/proc/copy_necro_crystal_state_from(obj/item/necro_relics/necro_crystal/original)
	if(!original)
		return
	name = original.name
	desc = original.desc
	icon = original.icon
	icon_state = original.icon_state
	dir = original.dir
	pixel_x = original.pixel_x
	pixel_y = original.pixel_y
	color = original.color
	alpha = original.alpha
	transform = original.transform
	last_use_time = original.last_use_time
	current_charges = min(original.current_charges, max_charges)
	if(length(original.active_skeletons))
		active_skeletons = original.active_skeletons.Copy()

/obj/item/necro_relics/necro_crystal/twilight_axis/proc/prune_active_skeletons(mob/living/skeleton_to_remove = null)
	for(var/i in active_skeletons.len to 1 step -1)
		var/datum/weakref/W = active_skeletons[i]
		var/mob/living/M = W?.resolve()
		if(!M || QDELETED(M) || M.stat == DEAD || M == skeleton_to_remove)
			active_skeletons.Cut(i, i + 1)
	return active_skeletons.len

/obj/item/necro_relics/necro_crystal/twilight_axis/attack_self(mob/living/user)
	if(!user)
		return FALSE

	if(prune_active_skeletons() >= max_summons)
		to_chat(user, span_warning("The crystal emits an ominous thrumming. The power within is too strained to conjure another skeleton right now."))
		return FALSE

	if(world.time - src.last_use_time < src.use_cooldown)
		to_chat(user, span_warning("The crystal thrums under your touch, but remains inert."))
		return FALSE

	if(current_charges <= 0)
		to_chat(user, span_warning("The crystal feels hollow. It hungers for lux."))
		return FALSE

	var/tasks = list("TOIL","FIGHT","GUARD","SEEK")
	var/tasks_choice = input(user, "WHAT IS THY BIDDING?", "IN HER NAME") as anything in tasks
	if(!tasks_choice)
		to_chat(user, span_warning("You must assign a task for your skeleton!"))
		return FALSE

	src.last_use_time = world.time

	if(!do_after(user, 60, src))
		to_chat(user, span_warning("You lose your concentration."))
		return FALSE
	if(QDELETED(user) || QDELETED(src))
		return FALSE
	if(prune_active_skeletons() >= max_summons)
		to_chat(user, span_warning("The crystal emits an ominous thrumming. The power within is too strained to conjure another skeleton right now."))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_CABAL))
		to_chat(user, span_warning("The crystal rejects you! It shatters within your grasp!"))
		user.flash_fullscreen("redflash1")
		new /obj/item/natural/glass_shard(get_turf(src))
		playsound(src, "glassbreak", 70, TRUE)
		qdel(src)
		return FALSE

	var/turf/T = get_step(user, user.dir)
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	var/necro_name = user.real_name ? user.real_name : user.name
	var/list/candidates = pollGhostCandidates("The veil splits! A hand reaches forth! Serve [necro_name] in undeath as a Greater Skeleton? YOU WILL [tasks_choice]", ROLE_NECRO_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_NECROMANCER_SKELETON)
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("The depths are hollow."))
		return FALSE
	if(QDELETED(user) || QDELETED(src))
		return FALSE
	if(prune_active_skeletons() >= max_summons)
		to_chat(user, span_warning("The crystal emits an ominous thrumming. The power within is too strained to conjure another skeleton right now."))
		return FALSE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		return FALSE

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/skeleton/no_equipment/target = new /mob/living/carbon/human/species/skeleton/no_equipment(T)
	target.crystal = WEAKREF(src)
	target.key = C.key
	current_charges--
	SSjob.EquipRank(target, "Greater Skeleton", TRUE)
	target.visible_message(span_warning("[target]'s eyes light up with an eerie glow!"))
	active_skeletons += WEAKREF(target)

	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "GREATER SKELETON"), 3 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)

	if(current_charges <= 0)
		to_chat(user, span_notice("The crystal dims, its power spent."))
	else
		to_chat(user, span_notice("The crystal's glow lessens. [current_charges] use\s remain."))

	user.flash_fullscreen("redflash1")
	playsound(src, "shatter", 50, TRUE)

	return TRUE

/mob/living/carbon/human/species/skeleton/no_equipment/proc/release_twilight_necro_crystal_slot()
	var/obj/item/necro_relics/necro_crystal/active_crystal = crystal?.resolve()
	if(!istype(active_crystal, /obj/item/necro_relics/necro_crystal/twilight_axis) || QDELETED(active_crystal))
		return FALSE
	var/obj/item/necro_relics/necro_crystal/twilight_axis/twilight_crystal = active_crystal
	twilight_crystal.prune_active_skeletons(src)
	crystal = null
	return TRUE

/mob/living/carbon/human/species/skeleton/no_equipment/death(gibbed, nocutscene = FALSE)
	release_twilight_necro_crystal_slot()
	return ..()

/mob/living/carbon/human/species/skeleton/no_equipment/Destroy()
	release_twilight_necro_crystal_slot()
	return ..()

#undef MAX_RAISED_SKELETONS
#undef TWILIGHT_NECRO_CRYSTAL_MAX_SUMMONS
#undef TWILIGHT_NECRO_CRYSTAL_MAX_CHARGES
