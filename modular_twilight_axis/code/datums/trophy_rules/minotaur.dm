/datum/trophy_rule/minotaur_str
	name = "minotaur strength"
	group_id = TROPHY_GROUP_STRONG

/datum/trophy_rule/minotaur_str/matches(obj/item/I)
	return istype(I, /obj/item/natural/head/minotaur)

/datum/trophy_rule/minotaur_str/get_score(obj/item/I)
	return 2

/datum/trophy_rule/minotaur_str/build_effect(obj/item/I)
	var/datum/trophy_effect/E = new
	E.group_id = group_id
	E.effect_type = TROPHY_EFFECT_STR
	E.value = 1
	E.message = "You feel the crushing strength of the minotaur flow into your limbs."
	return E
