/datum/trophy_rule/dragon_per
	name = "dragon perception"
	group_id = TROPHY_GROUP_PERCEPTION

/datum/trophy_rule/dragon_per/matches(obj/item/I)
	return istype(I, /obj/item/natural/head/dragon) && !istype(I, /obj/item/natural/head/dragon/broodmother)

/datum/trophy_rule/dragon_per/get_score(obj/item/I)
	return 1

/datum/trophy_rule/dragon_per/build_effect(obj/item/I)
	var/datum/trophy_effect/E = new
	E.group_id = group_id
	E.effect_type = TROPHY_EFFECT_PER
	E.value = 1
	E.message = "You feel the dragon's lethal precision sharpen your senses."
	return E
