/*============
Necra's Censer
============*/
/*
- Cleans in an area around the person after
  a do_after call, infinite uses. Should aid
  the morticians with cleaning the town.
*/

/obj/item/necra_censer
	name = "Necra's censer"
	desc = "A small bronze censer that expels an otherworldly mist."
	icon = 'modular_twilight_axis/icons/roguetown/items/misc.dmi'
	icon_state ="necra_censer"
	lefthand_file = 'modular_twilight_axis/icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'modular_twilight_axis/icons/mob/inhands/items_righthand.dmi'
	item_state = "necra_censer"
	w_class = WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 64
	throw_speed = 3
	throw_range = 7
	throwforce = 4
	//hitsound = 'sound/blank.ogg'
	sellprice = 10 // Shouldn't be worth a lot in world
	dropshrink = 0.6

/obj/item/necra_censer/attack_self(mob/user)
	if(do_after(user, 3 SECONDS))
		playsound(user.loc,  'modular_twilight_axis/sound/items/censer_use.ogg', 100)
		user.visible_message(span_info("[user.name] lifts up their arm and swings the chain on \the [name] around lightly."))
		var/datum/effect_system/smoke_spread/smoke/necra_censer/S = new
		S.set_up(2, user.loc)
		S.start()
