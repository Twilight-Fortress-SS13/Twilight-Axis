/datum/component/rune_storage
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// List of /datum/applied_rune
	var/list/applied_runes = list()

	/// List of persistent applied runes for direct access
	var/list/persistent_runes = list()

	/// Maximum runes that may be stored on the weapon
	var/max_runes = 4

	/// Which slot will be overwritten next when storage is full
	var/next_rune_index = 1

/datum/component/rune_storage/Initialize(max_runes_count = 4)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	max_runes = max_runes_count
	next_rune_index = 1

	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SUCCESS, PROC_REF(on_weapon_hit))
	RegisterSignal(parent, COMSIG_RUNE_PERSIST_ATTACH, PROC_REF(on_persist_attach))
	RegisterSignal(parent, COMSIG_RUNE_PERSIST_DETACH, PROC_REF(on_persist_detach))

/datum/component/rune_storage/Destroy(force, silent)
	QDEL_LIST(applied_runes)
	applied_runes = null
	persistent_runes = null
	return ..()

/datum/component/rune_storage/proc/advance_next_rune_index()
	next_rune_index++
	if(next_rune_index > max_runes)
		next_rune_index = 1

/datum/component/rune_storage/proc/get_weapon()
	return parent

/datum/component/rune_storage/proc/add_rune(datum/rune/new_rune, mob/living/user)
	var/obj/item/weapon = get_weapon()
	if(!weapon || !new_rune)
		return FALSE

	if(length(applied_runes) < max_runes)
		var/datum/applied_rune/applied = new(new_rune, user)
		applied_runes += applied

		new_rune.on_apply(weapon, user, src, applied)

		if(new_rune.is_persistent)
			persistent_runes += applied
			new_rune.on_persistent_apply(weapon, user, src, applied)

		if(length(applied_runes) >= max_runes)
			if(next_rune_index < 1 || next_rune_index > max_runes)
				next_rune_index = 1

		return TRUE

	return overwrite_rune(new_rune, user)

/datum/component/rune_storage/proc/overwrite_rune(datum/rune/new_rune, mob/living/user)
	var/obj/item/weapon = get_weapon()
	if(!weapon || !new_rune || !length(applied_runes))
		return FALSE

	if(next_rune_index < 1 || next_rune_index > length(applied_runes))
		next_rune_index = 1

	var/datum/applied_rune/old_applied = applied_runes[next_rune_index]
	if(!old_applied)
		return FALSE

	var/datum/rune/old_rune = old_applied.rune
	if(old_rune?.is_persistent && (old_applied in persistent_runes))
		old_rune.on_persistent_remove(weapon, user, src, old_applied)
		persistent_runes -= old_applied

	old_rune?.on_remove(weapon, user, src, old_applied)

	var/datum/applied_rune/new_applied = new(new_rune, user)
	applied_runes[next_rune_index] = new_applied

	new_rune.on_apply(weapon, user, src, new_applied)

	if(new_rune.is_persistent)
		persistent_runes += new_applied
		new_rune.on_persistent_apply(weapon, user, src, new_applied)

	qdel(old_applied)

	advance_next_rune_index()
	return TRUE

/datum/component/rune_storage/proc/remove_rune(datum/applied_rune/applied, mob/living/user)
	var/obj/item/weapon = get_weapon()
	if(!weapon || !applied || !(applied in applied_runes))
		return FALSE

	var/index = applied_runes.Find(applied)
	if(!index)
		return FALSE

	var/datum/rune/rune = applied.rune
	if(rune?.is_persistent && (applied in persistent_runes))
		rune.on_persistent_remove(weapon, user, src, applied)
		persistent_runes -= applied

	rune?.on_remove(weapon, user, src, applied)

	applied_runes.Cut(index, index + 1)
	qdel(applied)

	if(!length(applied_runes))
		next_rune_index = 1
	else if(next_rune_index > length(applied_runes))
		next_rune_index = 1
	else if(index < next_rune_index)
		next_rune_index--

	return TRUE

/datum/component/rune_storage/proc/clear_runes(mob/living/user)
	for(var/datum/applied_rune/applied as anything in applied_runes.Copy())
		remove_rune(applied, user)

/datum/component/rune_storage/proc/get_random_rune()
	if(!length(applied_runes))
		return null
	return pick(applied_runes)

/datum/component/rune_storage/proc/trigger_random_rune(mob/living/user, atom/target)
	var/datum/applied_rune/applied = get_random_rune()
	if(!applied)
		return FALSE

	return trigger_specific_rune(applied, user, target)

/datum/component/rune_storage/proc/trigger_all_runes(mob/living/user, atom/target)
	if(!length(applied_runes))
		return FALSE

	var/triggered_any = FALSE

	for(var/datum/applied_rune/applied as anything in applied_runes)
		if(trigger_specific_rune(applied, user, target))
			triggered_any = TRUE

	return triggered_any

/datum/component/rune_storage/proc/trigger_specific_rune(datum/applied_rune/applied, mob/living/user, atom/target)
	var/obj/item/weapon = get_weapon()
	if(!weapon || !applied?.rune)
		return FALSE

	var/datum/rune/rune = applied.rune
	if(!(rune.trigger_flags & RUNE_TRIGGER_ON_HIT))
		return FALSE

	if(!rune.can_trigger(weapon, user, target, src, applied))
		return FALSE

	rune.on_trigger(weapon, user, target, src, applied)
	applied.next_trigger_time = world.time + rune.cooldown
	return TRUE

/datum/component/rune_storage/proc/process_persistent_attach(mob/living/user)
	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return

	for(var/datum/applied_rune/applied as anything in persistent_runes)
		applied.rune?.on_persistent_apply(weapon, user, src, applied)

/datum/component/rune_storage/proc/process_persistent_detach(mob/living/user)
	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return

	for(var/datum/applied_rune/applied as anything in persistent_runes)
		applied.rune?.on_persistent_remove(weapon, user, src, applied)

/datum/component/rune_storage/proc/on_weapon_hit(obj/item/source, mob/living/target, mob/living/user, mass_activation = FALSE)
	SIGNAL_HANDLER

	if(!length(applied_runes))
		return

	if(mass_activation)
		trigger_all_runes(user, target)
	else
		trigger_random_rune(user, target)

/datum/component/rune_storage/proc/on_persist_attach(obj/item/source, mob/living/user)
	SIGNAL_HANDLER
	process_persistent_attach(user)

/datum/component/rune_storage/proc/on_persist_detach(obj/item/source, mob/living/user)
	SIGNAL_HANDLER
	process_persistent_detach(user)
