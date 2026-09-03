/proc/random_blood_type()
	return pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

/proc/random_eye_color()
	switch(pick(20;"brown",20;"hazel",20;"grey",15;"blue",15;"green",1;"amber",1;"albino"))
		if("brown")
			return "630"
		if("hazel")
			return "542"
		if("grey")
			return pick("666","777","888","999","aaa","bbb","ccc")
		if("blue")
			return "36c"
		if("green")
			return "060"
		if("amber")
			return "fc0"
		if("albino")
			return pick("c","d","e","f") + pick("0","1","2","3","4","5","6","7","8","9") + pick("0","1","2","3","4","5","6","7","8","9")
		else
			return "000"

/proc/random_features()
	return MANDATORY_FEATURE_LIST

/proc/random_unique_name(gender, attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		if(gender==FEMALE)
			. = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			. = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

		if(!findname(.))
			break

/proc/random_unique_lizard_name(gender, attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(lizard_name(gender))

		if(!findname(.))
			break

/proc/random_unique_plasmaman_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(plasmaman_name())

		if(!findname(.))
			break

/proc/random_unique_ethereal_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(ethereal_name())

		if(!findname(.))
			break

/proc/random_unique_moth_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(pick(GLOB.moth_first)) + " " + capitalize(pick(GLOB.moth_last))

		if(!findname(.))
			break


GLOBAL_LIST_INIT(skin_tones, sortList(list(
	"skin1" = "ffe0d1",
	"skin2" = "fcccb3",
	"skin3" = "e8b59b"
	)))

/proc/random_skin_tone()
	return GLOB.skin_tones[pick(GLOB.skin_tones)]

GLOBAL_LIST_INIT(haircolor, sortList(list(
	"black" = "#0a0707",
	"brown" = "#362e25",
	"blonde" = "#dfc999",
	"red" = "#a34332"
	)))


/proc/random_haircolor()
	return GLOB.haircolor[pick(GLOB.haircolor)]

GLOBAL_LIST_INIT(oldhc, sortList(list(
	"decay" = "6a6a6a",
	"elderly" = "9e9e9e",
	"ancient" = "c9c9c9",
	"mythic" = "f4f4f4"
	)))

/proc/skintone2hex(skin_tone)
	. = 0
	switch(skin_tone)
		if("caucasian1")
			. = "ffe0d1"
		if("caucasian2")
			. = "fcccb3"
		if("caucasian3")
			. = "e8b59b"
		if("latino")
			. = "d9ae96"
		if("mediterranean")
			. = "c79b8b"
		if("asian1")
			. = "ffdeb3"
		if("asian2")
			. = "e3ba84"
		if("arab")
			. = "c4915e"
		if("indian")
			. = "b87840"
		if("african1")
			. = "754523"
		if("african2")
			. = "471c18"
		if("albino")
			. = "fff4e6"
		if("orange")
			. = "ffc905"
		if("skin1")
			. = "ffe0d1"
		if("skin2")
			. = "fcccb3"
		if("skin3")
			. = "e8b59b"

/proc/haircolor2hex(haircolor)
	. = 0
	switch(haircolor)
		if("cave black")
			. = "#0a0707"
		if("mud brown")
			. = "#362e25"
		if("pale blonde")
			. = "#dfc999"
		if("dusk red")
			. = "#a34332"
		if("decay grey")
			. = "#6a6a6a"


GLOBAL_LIST_EMPTY(species_list)

/proc/age2agedescription(age)
	switch(age)
		if(0 to 30)
			return "young adult"
		if(30 to 45)
			return "adult"
		if(45 to 60)
			return "middle-aged"
		if(60 to 70)
			return "aging"
		if(70 to INFINITY)
			return "elderly"
		else
			return "unknown"

/proc/do_mob(mob/user , mob/target, time = 30, uninterruptible = 0, progress = 1, datum/callback/extra_checks = null, double_progress = 0, can_move = TRUE)
	if(!user || !target)
		return 0

	if(user.doing)
		return 0
	user.doing = 1
	var/doing_generation = ++user.doing_generation // TA EDIT

	var/datum/component/do_mob_component/do_mob_component = user.AddComponent(/datum/component/do_mob_component, target, time, uninterruptible, progress, extra_checks, double_progress, can_move, doing_generation) // TA EDIT START
	if(QDELETED(do_mob_component))
		if(user.doing_generation == doing_generation)
			user.doing = FALSE
		return FALSE
	. = do_mob_component.sync() // TA EDIT END


//some additional checks as a callback for for do_afters that want to break on losing health or on the mob taking action
/mob/proc/break_do_after_checks(list/checked_health, check_clicks)
	if(check_clicks && next_move > world.time)
		return FALSE
	return TRUE

//pass a list in the format list("health" = mob's health var) to check health during this
/mob/living/break_do_after_checks(list/checked_health, check_clicks)
	if(islist(checked_health))
		if(health < checked_health["health"])
			return FALSE
		checked_health["health"] = health
	return ..()

/mob
	var/doing = FALSE
	var/pronouns = null // LETHALSTONE ADDITION: this is cheap so i'm doing it. preferences in human will set this appropriately
	var/titles_pref = null
	var/clothes_pref = CLOTHES_M
	var/obscured_flags = NONE
	var/override_advclass_examine = FALSE // if you get converted to a different role like servant with advjob_examine set to true, your title won't change on examine bcs your advclass hasn't actually changed - so we override that setting

/**
 * Timed action involving one mob user. Target is optional.
 *
 * mob/user - The mob performing the action.
 *
 * delay = the time in deciseconds. Use time defines (SECONDS, MINUTES) for readability.
 *
 * needhand - check for an empty hand
 *
 * target - the target of the action
 *
 * progress - whether to display a progress bar
 *
 * datum/callback/extra_checks - additional check callbacks to perform during do_after
 *
 * same_direction - whether the mob performing the action may switch directions or not
 *
 * interrupt - whether to interrupt a prior do_after or not
*/

/proc/do_after(mob/user, delay, needhand = TRUE, atom/target = null, progress = TRUE, datum/callback/extra_checks = null, same_direction = FALSE, no_interrupt = FALSE, allow_movement = FALSE)
	if(!user)
		return FALSE

	if(user.doing)
		if(no_interrupt)
			return
		return FALSE

	user.doing = TRUE
	var/doing_generation = ++user.doing_generation // TA EDIT
	SEND_SIGNAL(user, COMSIG_DO_AFTER_BEGAN)

	delay *= user.do_after_coefficent()
	var/datum/component/do_after_component/do_after_component = user.AddComponent(/datum/component/do_after_component, delay, needhand, target, progress, extra_checks, same_direction, allow_movement, doing_generation) // TA EDIT START
	if(QDELETED(do_after_component))
		if(user.doing_generation == doing_generation)
			user.doing = FALSE
		SEND_SIGNAL(user, COMSIG_DO_AFTER_ENDED)
		return FALSE
	. = do_after_component.sync() // TA EDIT END

/mob/proc/stop_all_doing()
	for(var/datum/component/do_after_component/do_after_component as anything in GetComponents(/datum/component/do_after_component)) // TA EDIT START
		do_after_component.cancel()
	for(var/datum/component/do_mob_component/do_mob_component as anything in GetComponents(/datum/component/do_mob_component))
		do_mob_component.cancel()
	for(var/datum/component/move_after_component/move_after_component as anything in GetComponents(/datum/component/move_after_component))
		move_after_component.cancel()
	for(var/datum/component/do_after_mob_component/do_after_mob_component as anything in GetComponents(/datum/component/do_after_mob_component))
		do_after_mob_component.cancel()
	doing = FALSE // TA EDIT END
	for(var/interaction_key in do_afters)
		LAZYREMOVE(do_afters, interaction_key)

/// do_after copypasta but you can move
/proc/move_after(mob/user, delay, needhand = 1, atom/target = null, progress = 1, datum/callback/extra_checks = null, same_direction = FALSE)
	if(!user)
		return 0

	if(user.doing)
		return 0
	user.doing = 1
	var/doing_generation = ++user.doing_generation // TA EDIT
	SEND_SIGNAL(user, COMSIG_DO_AFTER_BEGAN)

	delay *= user.do_after_coefficent()
	var/datum/component/move_after_component/move_after_component = user.AddComponent(/datum/component/move_after_component, delay, needhand, target, progress, extra_checks, same_direction, doing_generation) // TA EDIT START
	if(QDELETED(move_after_component))
		if(user.doing_generation == doing_generation)
			user.doing = FALSE
		SEND_SIGNAL(user, COMSIG_DO_AFTER_ENDED)
		return FALSE
	. = move_after_component.sync() // TA EDIT END

/mob/proc/do_after_coefficent() // This gets added to the delay on a do_after, default 1
	. = 1
	return

/proc/do_after_mob(mob/user, list/targets, time = 30, uninterruptible = 0, progress = 1, datum/callback/extra_checks, required_mobility_flags = MOBILITY_STAND)
	if(!user || !targets)
		return 0

	if(user.doing)
		return 0
	user.doing = 1
	var/doing_generation = ++user.doing_generation // TA EDIT

	if(!islist(targets))
		targets = list(targets)

	var/datum/component/do_after_mob_component/do_after_mob_component = user.AddComponent(/datum/component/do_after_mob_component, targets, time, uninterruptible, progress, extra_checks, required_mobility_flags, doing_generation) // TA EDIT START
	if(QDELETED(do_after_mob_component))
		if(user.doing_generation == doing_generation)
			user.doing = FALSE
		return FALSE
	. = do_after_mob_component.sync() // TA EDIT END

/proc/is_species(A, species_datum)
	. = FALSE
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.dna && istype(H.dna.species, species_datum))
			. = TRUE

/proc/spawn_atom_to_turf(spawn_type, target, amount, admin_spawn=FALSE, list/extra_args)
	var/turf/T = get_turf(target)
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/new_args = list(T)
	if(extra_args)
		new_args += extra_args
	var/atom/X
	for(var/j in 1 to amount)
		X = new spawn_type(arglist(new_args))
		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1
	return X //return the last mob spawned

/proc/spawn_and_random_walk(spawn_type, target, amount, walk_chance=100, max_walk=3, always_max_walk=FALSE, admin_spawn=FALSE)
	var/turf/T = get_turf(target)
	var/step_count = 0
	if(!T)
		CRASH("attempt to spawn atom type: [spawn_type] in nullspace")

	var/list/spawned_mobs = new(amount)

	for(var/j in 1 to amount)
		var/atom/movable/X

		if (istype(spawn_type, /list))
			var/mob_type = pick(spawn_type)
			X = new mob_type(T)
		else
			X = new spawn_type(T)

		if (admin_spawn)
			X.flags_1 |= ADMIN_SPAWNED_1

		spawned_mobs[j] = X

		if(always_max_walk || prob(walk_chance))
			if(always_max_walk)
				step_count = max_walk
			else
				step_count = rand(1, max_walk)

			for(var/i in 1 to step_count)
				step(X, pick(NORTH, SOUTH, EAST, WEST))

	return spawned_mobs

// Displays a message in deadchat, sent by source. Source is not linkified, message is, to avoid stuff like character names to be linkified.
// Automatically gives the class deadsay to the whole message (message + source)
/proc/deadchat_broadcast(message, source=null, mob/follow_target=null, turf/turf_target=null, speaker_key=null, message_type=DEADCHAT_REGULAR)
	message = span_deadsay("[source]<span class='linkify'>[message]</span>")
	for(var/mob/M in GLOB.player_list)
		var/override = FALSE
	//	if(M.client.holder && (prefs.chat_toggles & CHAT_DSAY))
	//		override = TRUE
		if(HAS_TRAIT(M, TRAIT_SIXTHSENSE))
			override = TRUE
		if(isnewplayer(M) && !override)
			continue
		if(M.stat != DEAD && !override)
			continue

		if(isobserver(M))
			var/rendered_message = message

			if(follow_target)
//				var/F
//				if(turf_target)
//					F = FOLLOW_OR_TURF_LINK(M, follow_target, turf_target)
//				else
//					F = FOLLOW_LINK(M, follow_target)
//				rendered_message = "[F] [message]"
				rendered_message = "[message]"
			else if(turf_target)
//				var/turf_link = TURF_LINK(M, turf_target)
//				rendered_message = "[turf_link] [message]"
				rendered_message = "[message]"

			to_chat(M, rendered_message)
		else
			to_chat(M, message)

//Used in chemical_mob_spawn. Generates a random mob based on a given gold_core_spawnable value.
/proc/create_random_mob(spawn_location, mob_class = HOSTILE_SPAWN)
	var/static/list/mob_spawn_meancritters = list() // list of possible hostile mobs
	var/static/list/mob_spawn_nicecritters = list() // and possible friendly mobs

	if(mob_spawn_meancritters.len <= 0 || mob_spawn_nicecritters.len <= 0)
		for(var/T in typesof(/mob/living/simple_animal))
			var/mob/living/simple_animal/SA = T
			switch(initial(SA.gold_core_spawnable))
				if(HOSTILE_SPAWN)
					mob_spawn_meancritters += T
				if(FRIENDLY_SPAWN)
					mob_spawn_nicecritters += T

	var/chosen
	if(mob_class == FRIENDLY_SPAWN)
		chosen = pick(mob_spawn_nicecritters)
	else
		chosen = pick(mob_spawn_meancritters)
	var/mob/living/simple_animal/C = new chosen(spawn_location)
	return C

/proc/passtable_on(target, source)
	var/mob/living/L = target
	if (!HAS_TRAIT(L, TRAIT_PASSTABLE) && L.pass_flags & PASSTABLE)
		ADD_TRAIT(L, TRAIT_PASSTABLE, INNATE_TRAIT)
	ADD_TRAIT(L, TRAIT_PASSTABLE, source)
	L.pass_flags |= PASSTABLE

/proc/passtable_off(target, source)
	var/mob/living/L = target
	REMOVE_TRAIT(L, TRAIT_PASSTABLE, source)
	if(!HAS_TRAIT(L, TRAIT_PASSTABLE))
		L.pass_flags &= ~PASSTABLE

/proc/dance_rotate(atom/movable/AM, datum/callback/callperrotate, set_original_dir=FALSE)
	set waitfor = FALSE
	var/originaldir = AM.dir
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		if(!AM)
			return
		AM.setDir(i)
		callperrotate?.Invoke()
		sleep(1)
	if(set_original_dir)
		AM.setDir(originaldir)

//When you cop out of the round
/mob/proc/make_me_an_observer(existing = FALSE)
	var/mob/dead/new_player/lobbyer

	if(!existing)
		lobbyer = src
		var/choice = alert(src,"Are you sure you wish to observe? Playing is a lot more fun.","VOYEUR","Yes","No")

		if(QDELETED(src) || !client || choice != "Yes")
			lobbyer.ready = PLAYER_NOT_READY
			return FALSE
	else
		var/choice = alert(src, "Are you sure you wish to let go and observe?", "LET GO", "Yes", "No")

		if(stat != DEAD || choice != "Yes")
			return FALSE

	var/mob/dead/observer/observer	// Transfer safety to observer spawning proc.
	if(check_rights(R_WATCH, FALSE))
		observer = new /mob/dead/observer/admin(src)
	else
		observer = new /mob/dead/observer/nodraw(src)
	if(!existing)
		lobbyer.spawning = TRUE

	observer.started_as_observer = TRUE
	if(!existing)
		lobbyer.close_spawn_windows()
		var/obj/effect/landmark/observer_start/O = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
		to_chat(src, span_notice("Now teleporting."))
		if (O)
			observer.forceMove(O.loc)
		else
			to_chat(src, span_notice("Teleporting failed. Ahelp an admin please"))
			stack_trace("There's no freaking observer landmark available on this map or you're making observers before the map is initialised")

	observer.key = key
	observer.client = client
	observer.set_ghost_appearance()
	if(observer.client)
		observer.client.update_ooc_verb_visibility()
	if(observer.client && observer.client.prefs)
		observer.real_name = observer.client.prefs.real_name
		observer.name = observer.real_name
	observer.update_icon()
	observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	if(!existing)
		qdel(mind)
		mind = null
		qdel(src)
	return TRUE

/proc/is_human_part_visible(mob/living/carbon/human/human, flags_inv)
	if(!human)
		return TRUE
	if(flags_inv == NONE)
		return TRUE
	// this previously monumentally sucked and iterated over every item in a person's inventory every time their appearance needed to be checked, which was often.
	// replaced it by checking what hide slots are obscured at any given point in a /mob/'s `obscured_flags` var, so we check that instead
	return !(human.obscured_flags & flags_inv)

/mob/living/proc/rebuild_obscured_flags()
	// we do this when we equip and unequip anything to make sure all our flags are set properly
	var/list/equipped_items = get_equipped_items(FALSE)
	var/new_flags = NONE
	for(var/obj/item/thing as anything in equipped_items)
		if (thing.flags_inv)
			new_flags |= thing.flags_inv

	if(new_flags == obscured_flags)
		return
	obscured_flags = new_flags
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.update_body_parts()
