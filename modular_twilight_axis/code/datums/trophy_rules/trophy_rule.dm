/datum/trophy_rule
	var/name = "trophy rule"
	var/group_id = null

/datum/trophy_rule/proc/matches(obj/item/I)
	return FALSE

/datum/trophy_rule/proc/get_score(obj/item/I)
	return 0

/datum/trophy_rule/proc/build_effect(obj/item/I)
	return null
