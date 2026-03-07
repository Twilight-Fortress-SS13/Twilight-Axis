/datum/trophy_rule/troll_armor
	name = "troll armor"
	group_id = TROPHY_GROUP_ARMOR

/datum/trophy_rule/troll_armor/matches(obj/item/I)
	return istype(I, /obj/item/natural/head/troll)

/datum/trophy_rule/troll_armor/get_score(obj/item/I)
	if(istype(I, /obj/item/natural/head/troll/cave))
		return 20
	if(istype(I, /obj/item/natural/head/troll/axe))
		return 15
	return 10

/datum/trophy_rule/troll_armor/build_effect(obj/item/I)
	var/datum/trophy_effect/E = new
	E.group_id = group_id
	E.effect_type = TROPHY_EFFECT_ARMOR
	E.value = get_score(I)
	E.message = "You feel your skin harden with the resilience of a troll."
	return E
