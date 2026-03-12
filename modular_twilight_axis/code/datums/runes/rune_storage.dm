/datum/component/rune_storage
	var/list/applied_runes = list()
	var/list/persistent_runes = list()
	var/max_runes = 4
	var/active_rune = 1


/datum/component/rune_storage/proc/get_weapon()
	return parent


/datum/component/rune_storage/proc/advance_active_rune()
	active_rune++

	if(active_rune > max_runes)
		active_rune = 1


/datum/component/rune_storage/proc/add_rune(datum/rune/rune, mob/living/user)
	if(!rune)
		return FALSE

	if(max_runes < 1)
		max_runes = 1

	if(length(applied_runes) >= max_runes)
		return overwrite_rune(rune, user)

	var/datum/applied_rune/applied = new(rune, user)
	applied_runes += applied

	if(rune.is_persistent)
		persistent_runes += applied
		rune.on_persistent_apply(get_weapon(), user, src, applied)

	var/obj/item/weapon = get_weapon()
	if(weapon && weapon.max_integrity)
		var/reduction = round(weapon.max_integrity * 0.10)
		weapon.max_integrity = max(1, weapon.max_integrity - reduction)

	advance_active_rune()
	return TRUE


/datum/component/rune_storage/proc/overwrite_rune(datum/rune/new_rune, mob/living/user)
	if(!new_rune)
		return FALSE

	if(!length(applied_runes))
		return FALSE

	if(active_rune < 1 || active_rune > max_runes)
		active_rune = 1

	if(active_rune > length(applied_runes))
		active_rune = 1

	var/datum/applied_rune/old_applied = applied_runes[active_rune]
	if(!old_applied)
		return FALSE

	var/obj/item/weapon = get_weapon()
	var/datum/rune/old_rune = old_applied.rune

	if(old_rune?.is_persistent)
		persistent_runes -= old_applied
		old_rune.on_persistent_remove(weapon, user, src, old_applied)

	var/datum/applied_rune/new_applied = new(new_rune, user)
	applied_runes[active_rune] = new_applied

	if(new_rune.is_persistent)
		persistent_runes += new_applied
		new_rune.on_persistent_apply(weapon, user, src, new_applied)

	if(weapon && weapon.max_integrity)
		var/reduction = round(weapon.max_integrity * 0.10)
		weapon.max_integrity = max(1, weapon.max_integrity - reduction)

	qdel(old_applied)

	advance_active_rune()
	return TRUE


/datum/component/rune_storage/proc/remove_rune(datum/applied_rune/applied, mob/living/user)
	if(!applied)
		return FALSE

	var/index = applied_runes.Find(applied)
	if(!index)
		return FALSE

	var/datum/rune/rune = applied.rune
	if(rune?.is_persistent)
		persistent_runes -= applied
		rune.on_persistent_remove(get_weapon(), user, src, applied)

	applied_runes.Cut(index, index + 1)
	qdel(applied)

	if(!length(applied_runes))
		active_rune = 1
	else
		if(active_rune > length(applied_runes))
			active_rune = 1
		else if(index < active_rune)
			active_rune--

	return TRUE


/datum/component/rune_storage/proc/get_runeblade_candidate()
	if(!length(applied_runes))
		return null

	var/list/ready = list()
	var/datum/applied_rune/best_cd
	var/best_remaining = 1e31

	for(var/datum/applied_rune/A as anything in applied_runes)
		if(!A?.rune)
			continue
		if(A.rune.is_persistent)
			continue

		var/rem = max(A.next_trigger_time - world.time, 0)

		if(rem <= 0)
			ready += A
		else if(rem < best_remaining)
			best_remaining = rem
			best_cd = A

	if(length(ready))
		return pick(ready)

	return best_cd


/datum/component/rune_storage/proc/trigger_runeblade_best_rune(mob/living/user, atom/target, effect_mult, cooldown_mult, self_damage)
	var/datum/applied_rune/A = get_runeblade_candidate()
	if(!A || !A.rune)
		return FALSE

	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return FALSE

	A.rune.on_trigger(weapon, user, target, src, A)
	A.rune.finalize_runtime_trigger(weapon, A, cooldown_mult, self_damage)

	return TRUE


/datum/component/rune_storage/proc/trigger_runeblade_all_runes(mob/living/user, atom/target, effect_mult, cooldown_mult, self_damage)
	var/triggered = FALSE
	var/obj/item/weapon = get_weapon()

	if(!weapon)
		return FALSE

	for(var/datum/applied_rune/A as anything in applied_runes)
		if(!A?.rune)
			continue
		if(A.rune.is_persistent)
			continue

		A.rune.on_trigger(weapon, user, target, src, A)
		A.rune.finalize_runtime_trigger(weapon, A, cooldown_mult, self_damage)

		triggered = TRUE

	return triggered
