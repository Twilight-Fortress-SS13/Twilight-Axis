/obj/structure/roguesand/dune
	name = "dune"
	desc = "A high bank of sand blocks the view beyond it. Reach its top to see across, traveler."
	icon = 'modular_deserttown/icons/dunes.dmi'
	icon_state = "dune_1"
	density = FALSE
	opacity = TRUE
	mouse_opacity = 0
	max_integrity = 10
	layer = 4.1
	plane = FLOOR_PLANE
	blade_dulling = DULLING_CUT
	climb_offset = 10

/obj/structure/roguesand/dune/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/roguedune) //bro its fine trust me

/datum/component/roguedune/Initialize()
	RegisterSignal(parent, list(COMSIG_MOVABLE_CROSSED), PROC_REF(Crossed))

/datum/component/roguedune/proc/Crossed(datum/source, atom/movable/AM)
	var/atom/Parent = parent

	if(isliving(AM))
		var/mob/living/Living = AM
		if(Living.m_intent == MOVE_INTENT_SNEAK)
			return
		else
			if(!(HAS_TRAIT(Living, TRAIT_AZURENATIVE) && Living.m_intent != MOVE_INTENT_RUN))
				playsound(Parent.loc, 'modular_deserttown/sound/foley/footsteps/dunewalk2.ogg', 100, FALSE, -1)
			Living.consider_ambush()
	return

/obj/structure/roguesand/dune/Crossed(atom/movable/O)
	. = ..()
	if(!isliving(O))
		return
	var/mob/living/carbon/human/Human = O
	opacity = FALSE
	if(istype(Human))
		Human.OffBalance(3 SECONDS)

/obj/structure/roguesand/dune/Uncrossed(atom/movable/O)
	. = ..()
	if(!isliving(O))
		return
	var/turf/Turf = get_turf(src)
	for(var/mob/living/Living in Turf)
		if(Living != O)
			return
	opacity = TRUE

/obj/structure/roguesand/dune/one
	icon_state = "dune_1"

/obj/structure/roguesand/dune/two
	icon_state = "dune_2"

/obj/structure/roguesand/dune/three
	icon_state = "dune_3"

/obj/structure/roguesand/dune/four
	icon_state = "dune_4"

/obj/structure/roguesand/dune/five
	icon_state = "dune_5"

/obj/structure/roguesand/dune/six
	icon_state = "dune_6"
