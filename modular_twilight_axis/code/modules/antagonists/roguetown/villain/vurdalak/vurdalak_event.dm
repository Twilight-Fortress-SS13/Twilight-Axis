GLOBAL_LIST_EMPTY(vurdalak_animated_graves)
GLOBAL_LIST_EMPTY(vurdalak_landmarks)

GLOBAL_VAR_INIT(vurdalak_night_slots, 0)
GLOBAL_VAR_INIT(vurdalak_last_processed_night, -1)
GLOBAL_VAR_INIT(vurdalak_consumed_slots, 0)

/obj/structure/vurdalak_ambush_mound
	name = "disturbed dirt"
	desc = "Подозрительный рыхлый холмик болотной грязи."
	icon = 'icons/mob/actions/vurdalak_abilities.dmi'
	icon_state = "ambush_object"
	alpha = 100
	density = FALSE
	anchored = TRUE
	max_integrity = 30
	var/mob/living/carbon/human/vurdalak_mob
	var/datum/action/cooldown/spell/vurdalak_ambush/ambush_spell


	var/vurdalak_animated = FALSE
	var/vurdalak_slot_ready = FALSE
	var/timer_id_vurdalak = null
	var/datum/looping_sound/boneloop/vurdalak_soundloop = null

/obj/structure/vurdalak_ambush_mound/Initialize(mapload, mob/living/carbon/human/user, datum/action/cooldown/spell/vurdalak_ambush/spell)
	. = ..()
	vurdalak_mob = user
	ambush_spell = spell

/obj/structure/vurdalak_ambush_mound/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = TRUE, attack_dir)
	. = ..()
	if(obj_integrity <= 0)
		qdel(src)

/obj/structure/vurdalak_ambush_mound/obj_destruction(damage_flag)
	if(vurdalak_animated)
		cancel_vurdalak_slot()
	if(ambush_spell && vurdalak_mob && ambush_spell.is_burrowed)
		visible_message(span_userdanger("Яма засады разрушена! Вурдалака насильно выбивает из-под земли!"))
		ambush_spell.forced_emerge(vurdalak_mob)
	. = ..()

/obj/structure/vurdalak_ambush_mound/proc/activate_vurdalak_slot()
	if(!vurdalak_animated)
		return
	vurdalak_slot_ready = TRUE

	if(!vurdalak_soundloop)
		vurdalak_soundloop = new /datum/looping_sound/boneloop(src, FALSE)
		vurdalak_soundloop.start()


	notify_ghosts(
		"Оскверненная болотная могила созрела!",
		source = src,
		action = NOTIFY_ATTACK,
		flashwindow = TRUE
	)
	visible_message(span_warning("От рыхлого холмика земли [src] раздается зловещий хруст и шепот проклятых костей..."))

/obj/structure/vurdalak_ambush_mound/proc/cancel_vurdalak_slot()
	if(vurdalak_animated)
		if(timer_id_vurdalak)
			deltimer(timer_id_vurdalak)
			timer_id_vurdalak = null
		vurdalak_animated = FALSE
		vurdalak_slot_ready = FALSE

		if(vurdalak_soundloop)
			vurdalak_soundloop.stop()
			QDEL_NULL(vurdalak_soundloop)

		GLOB.vurdalak_animated_graves -= src

		new /obj/item/reagent_containers/lux_impure(get_turf(src))
		visible_message(span_notice("Темная болотная магия рассеивается от раскопок! Из земли выпадает сгусток Люкса!"))

/obj/structure/vurdalak_ambush_mound/proc/vurdalak_emerge_sequence(mob/living/carbon/human/V)
	if(QDELETED(V) || V.stat == DEAD)
		return
	sleep(2 SECONDS)
	if(QDELETED(V))
		return
	visible_message(span_alert("Когтистая рука с хрустом вырывается из земли [src]!"))
	playsound(src, 'sound/foley/plantcross1.ogg', 100, TRUE)
	sleep(3 SECONDS)
	if(QDELETED(V))
		return

	if(vurdalak_soundloop)
		vurdalak_soundloop.stop()
		QDEL_NULL(vurdalak_soundloop)

	var/turf/T = get_turf(src)
	V.alpha = 255
	V.forceMove(T)
	new /obj/structure/closet/dirthole(T)

	playsound(T, 'sound/foley/breaksound.ogg', 100, TRUE)
	playsound(T, 'sound/vo/mobs/vurdalak/vurdalak_spawn_near.ogg', 90, TRUE)

	var/area/spawn_area = get_area(T)
	if(spawn_area)
		for(var/mob/living/L in GLOB.player_list)
			if(get_area(L) == spawn_area)
				L.playsound_local(get_turf(L), 'sound/vo/mobs/vurdalak/vurdalak_spawn_far.ogg', 100, FALSE)

	visible_message(span_warning("[V] с ревом выбирается из [src] на поверхность!"))
	qdel(src)

/obj/structure/vurdalak_ambush_mound/Destroy()
	if(vurdalak_soundloop)
		vurdalak_soundloop.stop()
		QDEL_NULL(vurdalak_soundloop)
	GLOB.vurdalak_animated_graves -= src
	vurdalak_mob = null
	ambush_spell = null
	return ..()

/obj/effect/landmark/start/vurdalak
	name = "vurdalak"
	icon = 'modular_twilight_axis/icons/roguetown/mob/monster/vurdalak.dmi'
	icon_state = "vurdalak"
	delete_after_roundstart = FALSE
	jobspawn_override = list("Vurdalak")

/obj/effect/landmark/start/vurdalak/Initialize(mapload)
	. = ..()
	GLOB.vurdalak_landmarks |= src

/obj/effect/landmark/start/vurdalak/Destroy()
	GLOB.vurdalak_landmarks -= src
	return ..()


/proc/get_vurdalak_spawn_location()
	var/list/turf/landmark_turfs = list()

	for(var/obj/effect/landmark/start/vurdalak/L in GLOB.vurdalak_landmarks)
		var/turf/T = get_turf(L)
		if(T && !T.density)
			landmark_turfs += T

	if(length(landmark_turfs))
		return pick(landmark_turfs)

	var/turf/bog_turf = get_random_vurdalak_swamp_turf()
	if(bog_turf)
		return bog_turf

	var/list/turf/fallback_turfs = list()
	for(var/turf/open/floor/rogue/T in GLOB.areas)
		var/area/A = get_area(T)
		if(A && A.outdoors && !T.density)
			fallback_turfs += T
			if(length(fallback_turfs) >= 50)
				break

	if(length(fallback_turfs))
		return pick(fallback_turfs)

	return null

/proc/get_random_vurdalak_swamp_turf()
	var/list/area/valid_bog_areas = list()
	for(var/area/rogue/outdoors/A in GLOB.areas)
		if(istype(A, /area/rogue/outdoors/bog) || istype(A, /area/rogue/outdoors/bograt))
			valid_bog_areas += A

	if(!length(valid_bog_areas))
		return null

	var/area/target_area = pick(valid_bog_areas)

	var/list/turf/open/candidates = list()
	for(var/turf/open/T in target_area)
		if(!T.density)
			candidates += T
			if(length(candidates) >= 50)
				break

	while(length(candidates))
		var/turf/open/T = pick(candidates)
		candidates -= T

		var/blocked = FALSE
		for(var/atom/movable/AM in T)
			if(AM.density)
				blocked = TRUE
				break
		if(!blocked)
			return T

	return null


/proc/vurdalak_on_nightfall()
	if(SSmapping.config?.map_name != "Rockhill" && SSmapping.config?.map_name != "Roguetest")
		return

	GLOB.vurdalak_night_slots += 1

	var/datum/job/roguetown/vurdalak/J = SSjob.GetJob("Vurdalak")
	if(J)
		vurdalakslot_update()

	for(var/mob/living/L in GLOB.player_list)
		var/area/A = get_area(L)
		if(!A)
			continue
		if(istype(A, /area/rogue/outdoors/bog) || \
		   istype(A, /area/rogue/outdoors/bograt) || \
		   istype(A, /area/rogue/outdoors/town) || \
		   istype(A, /area/rogue/indoors/shelter/bog) || \
		   istype(A, /area/rogue/indoors/shelter/bograt) || \
		   istype(A, /area/rogue/indoors/shelter/town))
			L.playsound_local(get_turf(L), 'sound/vo/mobs/vurdalak/vurdalak_spawn_far.ogg', 100, FALSE)
			to_chat(L, span_boldannounce("С наступлением ночи жуткий, мертвенный вой эхом разносится по топям Террорбога... Кошмарный Вурдалак пробудился!"))


/proc/vurdalakslot_update()
	if(GLOB.antagonist_positions && !("Vurdalak" in GLOB.antagonist_positions))
		GLOB.antagonist_positions += "Vurdalak"

	var/datum/job/roguetown/vurdalak/J = SSjob.GetJob("Vurdalak")
	if(!J)
		return

	var/extra_grave_slots = 0
	for(var/obj/structure/vurdalak_ambush_mound/M in GLOB.vurdalak_animated_graves)
		if(M.vurdalak_animated && M.vurdalak_slot_ready)
			extra_grave_slots++

	J.current_positions = GLOB.vurdalak_consumed_slots
	J.total_positions = GLOB.vurdalak_night_slots + extra_grave_slots



/datum/round_event/ghost_role/vurdalak
	role_name = "Vurdalak Swamp Awakening"
	minimum_required = 1

/datum/round_event/ghost_role/vurdalak/spawn_role()
	if(SSmapping.config?.map_name != "Rockhill" && SSmapping.config?.map_name != "Roguetest")
		return MAP_ERROR

	var/list/candidates = pollGhostCandidates(
		"Болотные топи зовут вас... Хотите восстать в роли ужасного Вурдалака?",
		"Vurdalak",
		null,
		0,
		30 SECONDS
	)

	if(!length(candidates))
		return NOT_ENOUGH_PLAYERS

	var/spawn_count = 1
	var/online = length(GLOB.player_list)
	if(online >= 40)
		spawn_count = rand(3, 4)
	else if(online >= 20)
		spawn_count = 2

	var/spawns_succeeded = 0
	for(var/i in 1 to spawn_count)
		if(!length(candidates))
			break
		var/mob/ghost = pick_n_take(candidates)
		if(!ghost || !ghost.key)
			continue

		var/turf/spawn_loc = get_vurdalak_spawn_location()
		if(!spawn_loc)
			continue

		var/mob/living/carbon/human/species/vurdalak/V = new /mob/living/carbon/human/species/vurdalak(spawn_loc)
		V.gender = ghost.gender
		V.key = ghost.key
		V.mind.add_antag_datum(/datum/antagonist/vurdalak)
		spawned_mobs += V
		spawns_succeeded++

	if(spawns_succeeded)
		for(var/mob/living/L in GLOB.player_list)
			var/area/A = get_area(L)
			if(!A)
				continue
			if(istype(A, /area/rogue/outdoors/bog) || \
			   istype(A, /area/rogue/outdoors/bograt) || \
			   istype(A, /area/rogue/outdoors/town) || \
			   istype(A, /area/rogue/indoors/shelter/bog) || \
			   istype(A, /area/rogue/indoors/shelter/bograt) || \
			   istype(A, /area/rogue/indoors/shelter/town))
				L.playsound_local(get_turf(L), 'sound/vo/mobs/vurdalak/vurdalak_spawn_far.ogg', 100, FALSE)
				to_chat(L, span_boldannounce("Жуткий, мертвенный вой эхом разносится по топям Террорбога... Кошмарные Вурдалаки пробудились!"))
		return SUCCESSFUL_SPAWN

	return NOT_ENOUGH_PLAYERS
