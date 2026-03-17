/atom/movable/screen/alert/status_effect/buff/runeblade_prepared
	name = "Prepared Rune Art"
	desc = "A runeblade technique is primed."
	icon_state = "buff"

/datum/status_effect/buff/runeblade_prepared
	id = "runeblade_prepared"
	status_type = STATUS_EFFECT_REPLACE
	duration = 8 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/runeblade_prepared

	var/skill_id = 0
	var/effect_mult = 1
	var/cooldown_mult = 1
	var/weapon_self_damage_pct = 0
	var/activate_all = FALSE
	var/use_in_combo = TRUE
	var/prepared_name = "Prepared Rune Art"

/datum/status_effect/buff/runeblade_prepared/on_creation(
	mob/living/new_owner,
	new_skill_id,
	new_effect_mult,
	new_cooldown_mult,
	new_weapon_self_damage_pct,
	new_activate_all,
	new_use_in_combo,
	new_prepared_name
)
	skill_id = isnum(new_skill_id) ? round(new_skill_id) : 0
	effect_mult = isnum(new_effect_mult) ? new_effect_mult : 1
	cooldown_mult = isnum(new_cooldown_mult) ? new_cooldown_mult : 1
	weapon_self_damage_pct = isnum(new_weapon_self_damage_pct) ? new_weapon_self_damage_pct : 0
	activate_all = !!new_activate_all
	use_in_combo = !!new_use_in_combo

	if(new_prepared_name)
		prepared_name = "[new_prepared_name]"

	return ..()

/datum/status_effect/buff/runeblade_prepared/on_apply()
	. = ..()
	if(!.)
		return FALSE

	update_alert()
	return TRUE

/datum/status_effect/buff/runeblade_prepared/refresh(
	mob/living/new_owner,
	new_skill_id,
	new_effect_mult,
	new_cooldown_mult,
	new_weapon_self_damage_pct,
	new_activate_all,
	new_use_in_combo,
	new_prepared_name
)
	skill_id = isnum(new_skill_id) ? round(new_skill_id) : 0
	effect_mult = isnum(new_effect_mult) ? new_effect_mult : 1
	cooldown_mult = isnum(new_cooldown_mult) ? new_cooldown_mult : 1
	weapon_self_damage_pct = isnum(new_weapon_self_damage_pct) ? new_weapon_self_damage_pct : 0
	activate_all = !!new_activate_all
	use_in_combo = !!new_use_in_combo

	if(new_prepared_name)
		prepared_name = "[new_prepared_name]"

	. = ..()

	if(QDELETED(src))
		return

	update_alert()

/datum/status_effect/buff/runeblade_prepared/proc/update_alert()
	if(!owner || !owner.client || !owner.hud_used)
		return

	if(!linked_alert && alert_type)
		var/atom/movable/screen/alert/status_effect/A = owner.throw_alert(id, alert_type)
		if(A)
			A.attached_effect = src
			linked_alert = A

	if(!linked_alert)
		return

	linked_alert.name = "Prepared: [prepared_name]"
	linked_alert.desc = activate_all \
		? "Your next swing will trigger all non-persistent runes." \
		: "Your next swing will trigger one non-persistent rune."

/atom/movable/screen/alert/status_effect/buff/runeblade_absorption
	name = "Absorbed Rune"
	desc = "A rune empowers you."
	icon_state = "buff"

/datum/status_effect/buff/runeblade_absorption
	id = "runeblade_absorption"
	status_type = STATUS_EFFECT_REPLACE
	duration = 10 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/runeblade_absorption

	var/rune_element = null

/datum/status_effect/buff/runeblade_absorption/on_creation(mob/living/new_owner, new_rune_element)
	rune_element = new_rune_element
	return ..()

/datum/status_effect/buff/runeblade_absorption/on_apply()
	. = ..()
	if(!.)
		return FALSE

	if(!owner)
		return TRUE

	switch(rune_element)
		if(RUNE_ELEMENT_FIRE)
			owner.change_stat(STATKEY_STR, 2)
		if(RUNE_ELEMENT_WATER)
			owner.change_stat(STATKEY_WIL, 2)
		if(RUNE_ELEMENT_AIR)
			owner.change_stat(STATKEY_SPD, 2)
		if(RUNE_ELEMENT_EARTH)
			owner.change_stat(STATKEY_CON, 2)

	update_alert()
	return TRUE

/datum/status_effect/buff/runeblade_absorption/refresh(mob/living/new_owner, new_rune_element)
	if(owner)
		switch(rune_element)
			if(RUNE_ELEMENT_FIRE)
				owner.change_stat(STATKEY_STR, -2)
			if(RUNE_ELEMENT_WATER)
				owner.change_stat(STATKEY_WIL, -2)
			if(RUNE_ELEMENT_AIR)
				owner.change_stat(STATKEY_SPD, -2)
			if(RUNE_ELEMENT_EARTH)
				owner.change_stat(STATKEY_CON, -2)

	rune_element = new_rune_element

	if(owner)
		switch(rune_element)
			if(RUNE_ELEMENT_FIRE)
				owner.change_stat(STATKEY_STR, 2)
			if(RUNE_ELEMENT_WATER)
				owner.change_stat(STATKEY_WIL, 2)
			if(RUNE_ELEMENT_AIR)
				owner.change_stat(STATKEY_SPD, 2)
			if(RUNE_ELEMENT_EARTH)
				owner.change_stat(STATKEY_CON, 2)

	. = ..()

	if(QDELETED(src))
		return

	update_alert()

/datum/status_effect/buff/runeblade_absorption/on_remove()
	if(owner)
		switch(rune_element)
			if(RUNE_ELEMENT_FIRE)
				owner.change_stat(STATKEY_STR, -2)
			if(RUNE_ELEMENT_WATER)
				owner.change_stat(STATKEY_WIL, -2)
			if(RUNE_ELEMENT_AIR)
				owner.change_stat(STATKEY_SPD, -2)
			if(RUNE_ELEMENT_EARTH)
				owner.change_stat(STATKEY_CON, -2)

	return ..()

/datum/status_effect/buff/runeblade_absorption/proc/update_alert()
	if(!owner || !owner.client || !owner.hud_used)
		return

	if(!linked_alert && alert_type)
		var/atom/movable/screen/alert/status_effect/A = owner.throw_alert(id, alert_type)
		if(A)
			A.attached_effect = src
			linked_alert = A

	if(!linked_alert)
		return

	switch(rune_element)
		if(RUNE_ELEMENT_FIRE)
			linked_alert.name = "Absorbed Rune: Fire"
			linked_alert.desc = "Your body surges with stolen fire. Strength is increased."
		if(RUNE_ELEMENT_WATER)
			linked_alert.name = "Absorbed Rune: Water"
			linked_alert.desc = "Your mind steadies under stolen water. Will is increased."
		if(RUNE_ELEMENT_AIR)
			linked_alert.name = "Absorbed Rune: Air"
			linked_alert.desc = "Your step lightens with stolen air. Speed is increased."
		if(RUNE_ELEMENT_EARTH)
			linked_alert.name = "Absorbed Rune: Earth"
			linked_alert.desc = "Your frame hardens with stolen earth. Constitution is increased."
		else
			linked_alert.name = "Absorbed Rune"
			linked_alert.desc = "A rune empowers you."
