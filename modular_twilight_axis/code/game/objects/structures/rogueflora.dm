/obj/structure/flora/rogueshroom/happy/mushroom2
	icon = 'modular_twilight_axis/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "happymush2"

/obj/structure/flora/rogueshroom/happy/mushroom3
	icon = 'modular_twilight_axis/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "happymush3"

/obj/structure/flora/rogueshroom/happy/mushroom4
	icon = 'modular_twilight_axis/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "happymush4"

/obj/structure/flora/rogueshroom/happy/mushroom5
	icon = 'modular_twilight_axis/icons/roguetown/misc/foliagetall.dmi'
	icon_state = "happymush5"

/obj/structure/flora/roguetree/proc/bless_tree(mob/user)
	if(obj_integrity < max_integrity)
		obj_integrity = min(max_integrity, obj_integrity + round(max_integrity / 2))
		return TRUE
	return FALSE

/obj/structure/flora/roguetree/proc/reinvigorate_tree(mob/user)
	if(type == /obj/structure/flora/roguetree)
		spawn_reinvigorated_tree()
		if(isliving(user) && user.mind)
			user.mind.add_sleep_experience(/datum/skill/magic/druidic, 20)
		return TRUE
	return FALSE

/obj/structure/flora/roguetree/proc/spawn_reinvigorated_tree()
	new /obj/structure/flora/newtree(get_turf(src))
	qdel(src)
	return TRUE

/obj/structure/flora/roguetree/evil/reinvigorate_tree(mob/user)
	var/turf/T = get_turf(src)
	for(var/D in GLOB.cardinals)
		var/turf/adj = get_step(T, D)
		if(!isclosedturf(adj) && !locate(/obj/structure/glowshroom) in adj)
			new /obj/structure/glowshroom(adj)
	new /obj/structure/flora/roguetree/wise/sanctified(T)
	qdel(src)
	if(isliving(user) && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, 50)
	return TRUE

/obj/structure/flora/roguetree/wise/bless_tree(mob/user)
	if(obj_integrity < max_integrity)
		obj_integrity = min(max_integrity, obj_integrity + 50)
		return TRUE
	return FALSE

/obj/structure/flora/roguetree/wise/reinvigorate_tree(mob/user)
	if(istype(src, /obj/structure/flora/roguetree/wise/sanctified))
		return FALSE
	var/turf/T = get_turf(src)
	new /obj/structure/flora/roguetree/wise/sanctified/wise(T)
	qdel(src)
	if(isliving(user) && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, 50)
	return TRUE

/obj/structure/flora/roguetree/burnt/reinvigorate_tree(mob/user)
	spawn_reinvigorated_tree()
	if(isliving(user) && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, 20)
	return TRUE

/obj/structure/flora/newtree/proc/bless_tree(mob/user)
	if(obj_integrity < max_integrity)
		obj_integrity = min(max_integrity, obj_integrity + round(max_integrity / 2))
		return TRUE
	return FALSE

