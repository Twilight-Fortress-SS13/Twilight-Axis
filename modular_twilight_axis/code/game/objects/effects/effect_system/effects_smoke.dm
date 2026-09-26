/*====================
Zizo Bane sleep powder
====================*/
/datum/effect_system/smoke_spread/zizosleep
	effect_type = /obj/effect/particle_effect/smoke/zizosleep

/obj/effect/particle_effect/smoke/zizosleep/smoke_mob(mob/living/carbon/M)
	if(..())
		M.emote("cough")
		M.apply_status_effect(/datum/status_effect/debuff/knockout)
		return 1

/obj/effect/particle_effect/smoke/zizosleep
	name = "sleep spores"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sleep"
	pixel_x = 0
	pixel_y = 0
	opacity = 0
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate_movement = 0
	amount = 4
	lifetime = 8
	density = 0
	opaque =  0 //whether the smoke can block the view when in enough amount

/*Cleansing smoke*/
//for the necra censer.
/obj/effect/particle_effect/smoke/necra_censer
	name = "cleansing mist"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	pixel_x = 0
	pixel_y = 0
	opacity = 0
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate_movement = 0
	amount = 4
	lifetime = 1
	density = 0
	opaque =  0 //whether the smoke can block the view when in enough amount

/obj/effect/particle_effect/smoke/necra_censer/New(loc, ...)
	. = ..()
	if(istype(loc, /turf))
		var/turf/T = loc
		for(var/obj/effect/decal/cleanable/C in T)
			qdel(C)

		for(var/obj/effect/decal/remains/R in T)
			qdel(R) //clean remains up

		for(var/atom/A in T)
			wash_atom(A, CLEAN_STRONG)


/datum/effect_system/smoke_spread/smoke/necra_censer
	effect_type = /obj/effect/particle_effect/smoke/necra_censer
