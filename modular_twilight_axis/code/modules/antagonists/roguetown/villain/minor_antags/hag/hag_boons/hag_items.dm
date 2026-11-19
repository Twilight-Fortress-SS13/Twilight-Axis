/datum/hag_boon/item/hag_axe
	name = "wyrd axe"
	desc = "An axe equivalent to steel made out of gnarled wood. It regenerates whilst on natural tiles."
	points = 20

/datum/hag_boon/item/hag_axe/apply_boon_effect(mob/living/L)
	if(!L.GetComponent(/datum/component/hag_artifact_repair))
		L.AddComponent(/datum/component/hag_artifact_repair)
	return

/datum/hag_boon/item/hag_spear
	name = "wyrd polearm"
	desc = "A strange polearm equivalent to steel made out of gnarled wood. It regenerates whilst on natural tiles."
	points = 20

/datum/hag_boon/item/hag_spear/apply_boon_effect(mob/living/L)
	if(!L.GetComponent(/datum/component/hag_artifact_repair))
		L.AddComponent(/datum/component/hag_artifact_repair)
	return

/datum/hag_boon/item/hag_sword
	name = "wyrd sword"
	desc = "A strange sword equivalent to steel made out of gnarled wood. It regenerates whilst on natural tiles."
	points = 20

/datum/hag_boon/item/hag_sword/apply_boon_effect(mob/living/L)
	if(!L.GetComponent(/datum/component/hag_artifact_repair))
		L.AddComponent(/datum/component/hag_artifact_repair)
	return

/obj/item/clothing/neck/roguetown/psicross/hag/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/alch/hag_moss))
		if(!do_after(user, 2 SECONDS, target = I))
			return FALSE
		playsound(src, 'sound/gore/flesh_eat_01.ogg', 70, TRUE)
		to_chat(user, span_warning("As you touch [src.name] with [I.name], it's absorbs the moss and fills with something..."))
		tonic_spent = FALSE
		qdel(I)
		return TRUE
	..()
