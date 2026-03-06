/datum/trophy_rule/aspirant_rage
	name = "aspirant rage"
	group_id = TROPHY_GROUP_RAGE

/datum/trophy_rule/aspirant_rage/matches(obj/item/I)
	return istype(I, /obj/item/natural/head/dragon/broodmother)

/datum/trophy_rule/aspirant_rage/get_score(obj/item/I)
	return 15

/datum/trophy_rule/aspirant_rage/build_effect(obj/item/I)
	var/datum/trophy_effect/E = new
	E.group_id = group_id
	E.effect_type = TROPHY_EFFECT_RAGE_PACKAGE
	E.value = 15 SECONDS
	E.aux_value = 0.85
	E.message = "The fury you felt battling this horror burns through your body once more."
	return E
