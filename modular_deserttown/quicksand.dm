/// Quicksand

/obj/structure/quicksand
	name = "quicksand"
	desc = "The sand shifts unnaturally beneath your feet."
	icon = 'modular_deserttown/icons/quicksand.dmi'
	icon_state = "quicksand"

	density = FALSE
	anchored = TRUE

	can_buckle = 1
	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	max_integrity = -1
	alpha = 175
	plane = FLOOR_PLANE

/obj/structure/quicksand/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/mob_overlay_effect, 2, -2, 100)

/obj/structure/quicksand/Crossed(atom/movable/AtomMovable)
	. = ..()
	if(has_buckled_mobs())
		return
	if(!ishuman(AtomMovable))
		return
	var/mob/living/carbon/human/Living = AtomMovable
	if(Living.buckled)
		return
	if(Living.is_flying())
		return
	if(Living.m_intent == MOVE_INTENT_SNEAK)
		return
	buckle_mob(Living, TRUE, check_loc = FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_UPDATE, Living)
	playsound(loc, pick('sound/foley/footsteps/FTMUD (1).ogg', 'sound/foley/footsteps/FTMUD (2).ogg', 'sound/foley/footsteps/FTMUD (3).ogg'), 70, TRUE)
	visible_message(span_warning("[Living] sinks into the quicksand!"))
	START_PROCESSING(SSobj, src)

/obj/structure/quicksand/post_unbuckle_mob(mob/living/M)
	. = ..()
	SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, M)
	if(!has_buckled_mobs())
		STOP_PROCESSING(SSobj, src)

/obj/structure/quicksand/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	var/mob/living/carbon/human/Human = buckled_mob
	var/escape_amount = max(CEILING((20 - user.STASTR) / 2, 1), 2)
	var/escape_time = escape_amount SECONDS
	user.visible_message(span_warning("[user] struggles to escape the quicksand!"))

	if(!do_after(user, escape_time, FALSE, src))
		return FALSE

	playsound(loc, pick('sound/foley/footsteps/FTMUD (1).ogg', 'sound/foley/footsteps/FTMUD (2).ogg', 'sound/foley/footsteps/FTMUD (3).ogg'), 60, TRUE)

	unbuckle_mob(Human)
	Human.stamina_add(75)

	visible_message(span_notice("[buckled_mob] drags themselves free of the quicksand!"))
	return TRUE

/obj/structure/quicksand/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/shovel))
		playsound(loc, 'sound/items/dig_shovel.ogg', 100, TRUE)
		to_chat(user, span_info("I start digging up \the [name]..."))
		if(do_after(user, 5 SECONDS, src))
			playsound(loc, 'sound/items/empty_shovel.ogg', 100, TRUE)
			unbuckle_all_mobs(TRUE)
			qdel(src)
			return
	return ..()

/obj/structure/quicksand/attack_hand(mob/user)
	if(has_buckled_mobs())
		var/mob/living/victim = buckled_mobs[1]
		if(user == victim)
			user_unbuckle_mob(user, user)
			return
		user.visible_message(span_warning("[user.name] starts to pull [victim.name] out of the quicksand!"))
		if(do_after(user, 3 SECONDS, target = src))
			if(!has_buckled_mobs() || buckled_mobs[1] != victim)
				return
			playsound(loc, pick('sound/foley/footsteps/FTMUD (1).ogg', 'sound/foley/footsteps/FTMUD (2).ogg', 'sound/foley/footsteps/FTMUD (3).ogg'), 60, TRUE)
			unbuckle_mob(victim, TRUE)
			user.visible_message(span_notice("[user.name] pulls [victim.name] out of the quicksand."))
			return
	. = ..()

/obj/structure/quicksand/process()
	if(!has_buckled_mobs())
		STOP_PROCESSING(SSobj, src)
		return
	for(var/mob/living/carbon/human/L in buckled_mobs)
		L.energy_add(-2)

/obj/structure/quicksand/user_buckle_mob(mob/living/buckled_mob, mob/living/user)
	return

/datum/crafting_recipe/roguetown/quicksand
	name = "quicksand pit"
	result = /obj/structure/quicksand
	reqs = list(/datum/reagent/water = 240)
	time = 10 SECONDS
	verbage_simple = "mixes together"
	verbage = "mixes together"
	craftsound = 'sound/foley/Building-01.ogg'
	craftdiff = 0

/datum/crafting_recipe/roguetown/quicksand/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return FALSE
	if(!istype(T, /turf/open/floor/rogue/dunes))
		return FALSE
	return TRUE
