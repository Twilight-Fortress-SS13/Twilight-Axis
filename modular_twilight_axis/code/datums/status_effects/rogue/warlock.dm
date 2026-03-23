// ============================================================
// warlock_statuses.dm
// Heat / Cold cross-school stack statuses.
// ============================================================

#define WARLOCK_MAX_STACKS 5

/atom/movable/screen/alert/status_effect/warlock_heat
	name = "Cursed Heat"
	desc = "Жар другой школы копится в вашем теле."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/warlock_cold
	name = "Doom Cold"
	desc = "Холод другой школы копится в вашем теле."
	icon_state = "buff"

/datum/status_effect/warlock_heat
	id = "warlock_heat"
	status_type = STATUS_EFFECT_REFRESH
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/warlock_heat
	var/stacks = 1

/datum/status_effect/warlock_heat/on_apply()
	. = ..()
	UpdateAlert()
	return TRUE

/datum/status_effect/warlock_heat/refresh()
	. = ..()
	AddStacks(1)

/datum/status_effect/warlock_heat/proc/AddStacks(amount = 1)
	stacks = clamp(stacks + amount, 1, WARLOCK_MAX_STACKS)
	duration = initial(duration)
	UpdateAlert()

/datum/status_effect/warlock_heat/proc/UpdateAlert()
	if(linked_alert)
		linked_alert.name = "Cursed Heat ([stacks])"
		linked_alert.desc = "Даёт +[stacks * 5]% шанса прока огненной школе и +[stacks * 10]% урона ледяной школе."

/datum/status_effect/warlock_cold
	id = "warlock_cold"
	status_type = STATUS_EFFECT_REFRESH
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/warlock_cold
	var/stacks = 1

/datum/status_effect/warlock_cold/on_apply()
	. = ..()
	UpdateAlert()
	return TRUE

/datum/status_effect/warlock_cold/refresh()
	. = ..()
	AddStacks(1)

/datum/status_effect/warlock_cold/proc/AddStacks(amount = 1)
	stacks = clamp(stacks + amount, 1, WARLOCK_MAX_STACKS)
	duration = initial(duration)
	UpdateAlert()

/datum/status_effect/warlock_cold/proc/UpdateAlert()
	if(linked_alert)
		linked_alert.name = "Doom Cold ([stacks])"
		linked_alert.desc = "Даёт +[stacks * 5]% шанса прока ледяной школе и +[stacks * 10]% урона огненной школе."

#undef WARLOCK_MAX_STACKS
