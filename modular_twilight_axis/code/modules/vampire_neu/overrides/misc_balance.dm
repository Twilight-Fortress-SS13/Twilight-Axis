/*
 * Smaller balance and quality-of-life changes from Azure-Peak/Azure-Peak#7383.
 * Isolated from the discipline rewrites so this block can be reverted alone.
 */

// FAE TRICKERY TRAPS
/obj/structure/ta_fae_trickery_trap
	name = "ловушка фей"
	desc = "Почти невидимые чары фей. Выглядят достаточно хрупкими, чтобы их разрушить."
	anchored = TRUE
	density = FALSE
	max_integrity = 20
	alpha = 25
	icon = 'icons/effects/clan.dmi'
	icon_state = "rune1"
	color = "#4182ad"
	var/unique = FALSE
	var/mob/trap_owner

/obj/structure/ta_fae_trickery_trap/Crossed(atom/movable/crossing, oldloc)
	..()
	if(!isliving(crossing) || !trap_owner || crossing == trap_owner || unique)
		return

	var/mob/living/victim = crossing
	var/atom/throw_target
	if(!oldloc)
		throw_target = get_edge_target_turf(victim, pick(GLOB.cardinals))
	else
		throw_target = get_edge_target_turf(victim, get_dir(victim, oldloc))

	victim.apply_damage(45, BRUTE)
	victim.OffBalance(2 SECONDS)
	victim.throw_at(throw_target, rand(8, 10), 4, trap_owner, spin = TRUE)
	qdel(src)

/obj/structure/ta_fae_trickery_trap/disorient
	unique = TRUE
	icon_state = "rune2"

/obj/structure/ta_fae_trickery_trap/disorient/Crossed(atom/movable/crossing)
	..()
	if(!isliving(crossing) || !trap_owner || crossing == trap_owner)
		return

	var/mob/living/victim = crossing
	var/rotation = 50
	for(var/screen_type in victim.hud_used?.plane_masters)
		var/atom/movable/screen/plane_master/whole_screen = victim.hud_used?.plane_masters[screen_type]
		animate(whole_screen, transform = matrix(rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING, loop = -1)
		animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING)

	addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob/living, ta_clear_fae_disorientation)), 15 SECONDS)
	qdel(src)

/mob/living/proc/ta_clear_fae_disorientation()
	for(var/screen_type in hud_used?.plane_masters)
		var/atom/movable/screen/plane_master/whole_screen = hud_used?.plane_masters[screen_type]
		animate(whole_screen, transform = matrix(), time = 0.5 SECONDS, easing = QUAD_EASING)

/obj/structure/ta_fae_trickery_trap/drop
	unique = TRUE
	icon_state = "rune3"

/obj/structure/ta_fae_trickery_trap/drop/Crossed(mob/living/carbon/crossing)
	..()
	if(!iscarbon(crossing) || !trap_owner || crossing == trap_owner)
		return

	crossing.adjustBruteLoss(35)
	crossing.Knockdown(5)
	crossing.visible_message(span_suicide("[crossing] роняет оружие!"), span_boldwarning("Я роняю оружие!"))
	playsound(get_turf(crossing), 'sound/magic/mockery.ogg', 40, FALSE)
	var/target_turf = get_ranged_target_turf(get_turf(crossing), pick(GLOB.cardinals), rand(2, 5))
	crossing.throw_item(target_turf, FALSE)
	qdel(src)

/datum/coven_power/fae_trickery/chanjelin_ward/activate()
	. = ..()
	var/selected_trap = input(owner, "Выберите ловушку:", "Ловушка") as null|anything in list("Сокрушение", "Кружение", "Разоружение")
	if(!selected_trap)
		return

	var/obj/structure/ta_fae_trickery_trap/trap
	switch(selected_trap)
		if("Сокрушение")
			trap = new /obj/structure/ta_fae_trickery_trap(get_turf(owner))
		if("Кружение")
			trap = new /obj/structure/ta_fae_trickery_trap/disorient(get_turf(owner))
		if("Разоружение")
			trap = new /obj/structure/ta_fae_trickery_trap/drop(get_turf(owner))
	trap?.trap_owner = owner
