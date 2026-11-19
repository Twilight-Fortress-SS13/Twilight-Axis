/obj/structure/well/fountainswamp
	name = "water fountain"
	desc = "Green-tinted bogwater dances through sheets of thick floating algae."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "fountain"
	color = "#a3c2a8"
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	pixel_x = -15

/obj/structure/well/fountainswamp/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		user.visible_message(span_info("[user] starts to drink from [src]."))
		drink_act(user, L)
		return
	..()

/obj/structure/well/fountainswamp/proc/drink_act(mob/user, mob/living/L)
	playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	if(L.stat != CONSCIOUS)
		return
	if(do_after(L, 25, target = src))
		var/list/waterl = list(/datum/reagent/water/gross = 5)
		var/datum/reagents/reagents = new()
		reagents.add_reagent_list(waterl)
		reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = INGEST)
		playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
		drink_act(user, L)
	return
