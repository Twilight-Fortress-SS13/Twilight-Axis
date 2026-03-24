/obj/effect/decal/cleanable/coom
	name = "mess"
	desc = ""
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "mess1"
	random_icon_states = list("mess1", "mess2", "mess3")
	beauty = -100
	alpha = 150
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = NO_CLIENT_COLOR
	var/reagents_capacity = 50

/obj/effect/decal/cleanable/coom/Initialize(mapload)
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

	if(!reagents)
		reagents = new /datum/reagents(reagents_capacity)
		reagents.my_atom = src

/obj/effect/decal/cleanable/coom/Destroy()
	if(reagents)
		qdel(reagents)
		reagents = null
	return ..()

/obj/effect/decal/cleanable/coom/proc/is_empty()
	return !reagents || reagents.total_volume <= 0

/turf/open/floor/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return

		if(iscarbon(user))
			var/mob/living/carbon/CARB = user
			if(!CARB.lying)
				return
			if(CARB.is_mouth_covered())
				return

		for(var/obj/effect/decal/cleanable/coom/M in src)
			if(!M.reagents || M.reagents.total_volume <= 0)
				continue

			playsound(user, pick('sound/misc/mat/guymouth (1).ogg','sound/misc/mat/guymouth (2).ogg','sound/misc/mat/guymouth (3).ogg','sound/misc/mat/guymouth (4).ogg','sound/misc/mat/guymouth (5).ogg'), 100, FALSE, ignore_walls = FALSE)
			user.visible_message("<span class='love'>[user] начинает облизывать [src].</span>")
			if(do_after(L, 25, target = src))
				playsound(user, pick('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg'), 100, FALSE, ignore_walls = FALSE)
				user.visible_message("<span class='love'>[user] облизывает [src] нежно.</span>")
				var/take = min(6, M.reagents.total_volume)
				if(user.reagents && take > 0)
					M.reagents.trans_to(user, take, 1, TRUE, TRUE)
					if(ishuman(user))
						var/mob/living/carbon/human/H = user
						var/datum/status_effect/erp_coating/E = H.has_status_effect(/datum/status_effect/erp_coating/face)
						if(!E)
							E = H.apply_status_effect(/datum/status_effect/erp_coating/face, 30)
						if(E)
							var/datum/reagents/Rcoat = new /datum/reagents(take)
							Rcoat.add_reagent(/datum/reagent/water, 0)
							M.reagents.trans_to(Rcoat, take, 1, TRUE, TRUE)
							E.add_from(Rcoat, Rcoat.total_volume)
							qdel(Rcoat)

				if(M.reagents.total_volume <= 0)
					qdel(M)

			return

	..()
