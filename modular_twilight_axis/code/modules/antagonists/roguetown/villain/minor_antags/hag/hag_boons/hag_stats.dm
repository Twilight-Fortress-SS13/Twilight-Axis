/datum/hag_boon/stats
	name = "stat boon"
	points = 30
	var/amount
	var/stat
	var/grant_name

/datum/hag_boon/stats/apply_boon_effect(mob/living/L)
	if(!amount || !stat)
		return
	L.change_stat(stat, amount)

	to_chat(L, span_notice("You feel strange feeling, power of [grant_name] roots in your body."))
	return

/datum/hag_boon/stats/remove_boon_effect(mob/living/L)
	if(!amount || !stat)
		return

	L.change_stat(stat, -amount)

	to_chat(L, span_notice("You feel strange feeling, power of [grant_name] leaves your body..."))
	return

/datum/hag_boon/stats/str
	name = "strength boon"
	amount = 2
	stat = STATKEY_STR
	grant_name = "strength"

/datum/hag_boon/stats/per
	name = "perception boon"
	amount = 3
	stat = STATKEY_PER
	grant_name = "perception"

/datum/hag_boon/stats/int
	name = "intellect boon"
	amount = 3
	stat = STATKEY_INT
	grant_name = "intellect"

/datum/hag_boon/stats/con
	name = "constitution boon"
	amount = 3
	stat = STATKEY_CON
	grant_name = "constitution"

/datum/hag_boon/stats/spd
	name = "speed boon"
	amount = 2
	stat = STATKEY_SPD
	grant_name = "speed"

/datum/hag_boon/stats/wil
	name = "willpower boon"
	amount = 3
	stat = STATKEY_WIL
	grant_name = "willpower"

/datum/hag_boon/stats/lck
	name = "luck boon"
	amount = 4
	stat = STATKEY_LCK
	grant_name = "luck"
