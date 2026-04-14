#define RUNE_INTEGRITY_PENALTY_PCT 0.10

/datum/component/rune_storage
	var/list/applied_runes = list()
	var/list/persistent_runes = list()
	var/max_runes = 4
	var/active_rune = 1

	/// Базовая прочность оружия без рунных штрафов
	var/base_max_integrity = null

	/// Носитель, на которого сейчас реально навешаны persistent-эффекты
	var/mob/living/current_persistent_holder = null

/datum/component/rune_storage/Initialize(...)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return .

	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_parent_moved))
	var/obj/item/rogueweapon/weapon = parent
	if(weapon)
		max_runes = weapon.get_rune_capacity()
	cache_base_integrity()
	refresh_persistent_holder(get_current_holder())
	return .

/datum/component/rune_storage/proc/on_parent_moved()
	SIGNAL_HANDLER
	refresh_persistent_holder()

/datum/component/rune_storage/Destroy(force)
	clear_all_persistent_effects()
	return ..()

/datum/component/rune_storage/proc/get_weapon()
	return parent

/datum/component/rune_storage/proc/cache_base_integrity()
	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return

	if(isnull(base_max_integrity))
		base_max_integrity = weapon.max_integrity

/datum/component/rune_storage/proc/get_current_holder()
	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return null

	if(!isliving(weapon.loc))
		return null

	var/mob/living/holder = weapon.loc
	if(!(weapon in holder.held_items))
		return null

	return holder

/datum/component/rune_storage/proc/get_rune_integrity_penalty_pct()
	return RUNE_INTEGRITY_PENALTY_PCT

/datum/component/rune_storage/proc/recalculate_weapon_integrity()
	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return FALSE

	cache_base_integrity()

	if(isnull(base_max_integrity))
		return FALSE

	var/rune_count = length(applied_runes)
	var/penalty_pct = get_rune_integrity_penalty_pct() * rune_count
	penalty_pct = clamp(penalty_pct, 0, 0.90)

	var/new_max = max(1, round(base_max_integrity * (1 - penalty_pct)))
	weapon.max_integrity = new_max

	if(weapon.obj_integrity > weapon.max_integrity)
		weapon.obj_integrity = weapon.max_integrity

	return TRUE

/datum/component/rune_storage/proc/advance_active_rune()
	active_rune++
	if(active_rune > max_runes)
		active_rune = 1

/datum/component/rune_storage/proc/find_same_rune_type(datum/rune/check_rune, datum/applied_rune/skip_applied = null)
	if(!check_rune)
		return null

	for(var/datum/applied_rune/applied as anything in applied_runes)
		if(applied == skip_applied)
			continue

		var/datum/rune/existing = applied?.rune
		if(!existing)
			continue

		if(existing.type == check_rune.type)
			return applied

	return null

/datum/component/rune_storage/proc/can_add_rune(datum/rune/rune, mob/living/user)
	if(!rune)
		return FALSE

	if(!rune.can_stack)
		var/datum/applied_rune/duplicate = find_same_rune_type(rune)
		if(duplicate)
			if(user)
				to_chat(user, span_warning("You cannot apply another [rune.name] to this weapon."))
			return FALSE

	return TRUE

/datum/component/rune_storage/proc/apply_all_persistent_effects(mob/living/holder)
	if(!holder)
		return FALSE

	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return FALSE

	for(var/datum/applied_rune/applied as anything in persistent_runes)
		var/datum/rune/rune = applied?.rune
		if(!rune)
			continue

		rune.on_persistent_apply(weapon, holder, src, applied)

	current_persistent_holder = holder
	return TRUE

/datum/component/rune_storage/proc/remove_all_persistent_effects(mob/living/holder)
	if(!holder)
		return FALSE

	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return FALSE

	for(var/datum/applied_rune/applied as anything in persistent_runes)
		var/datum/rune/rune = applied?.rune
		if(!rune)
			continue

		rune.on_persistent_remove(weapon, holder, src, applied)

	if(current_persistent_holder == holder)
		current_persistent_holder = null

	return TRUE

/datum/component/rune_storage/proc/clear_all_persistent_effects()
	if(current_persistent_holder)
		remove_all_persistent_effects(current_persistent_holder)
	current_persistent_holder = null
	return TRUE

/datum/component/rune_storage/proc/refresh_persistent_holder(mob/living/new_holder = null)
	if(isnull(new_holder))
		new_holder = get_current_holder()

	if(current_persistent_holder == new_holder)
		return FALSE

	if(current_persistent_holder)
		remove_all_persistent_effects(current_persistent_holder)

	if(new_holder)
		apply_all_persistent_effects(new_holder)

	current_persistent_holder = new_holder
	return TRUE

/datum/component/rune_storage/proc/on_holder_changed(mob/living/new_holder)
	return refresh_persistent_holder(new_holder)

/datum/component/rune_storage/proc/add_rune(datum/rune/rune, mob/living/user)
	if(!rune)
		return FALSE

	if(!can_add_rune(rune, user))
		return FALSE

	if(max_runes < 1)
		max_runes = 1

	if(length(applied_runes) >= max_runes)
		return overwrite_rune(rune, user)

	var/datum/applied_rune/applied = new(rune, user)
	applied_runes += applied

	if(rune.is_persistent)
		persistent_runes += applied

		var/mob/living/holder = get_current_holder()
		if(holder)
			rune.on_persistent_apply(get_weapon(), holder, src, applied)
			current_persistent_holder = holder

	recalculate_weapon_integrity()
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

	if(!new_rune.can_stack)
		var/datum/applied_rune/duplicate = find_same_rune_type(new_rune, old_applied)
		if(duplicate)
			if(user)
				to_chat(user, span_warning("You cannot apply another [new_rune.name] to this weapon."))
			return FALSE

	var/obj/item/weapon = get_weapon()
	var/mob/living/holder = get_current_holder()

	var/datum/rune/old_rune = old_applied.rune
	if(old_rune?.is_persistent)
		persistent_runes -= old_applied
		if(holder)
			old_rune.on_persistent_remove(weapon, holder, src, old_applied)

	var/datum/applied_rune/new_applied = new(new_rune, user)
	applied_runes[active_rune] = new_applied

	if(new_rune.is_persistent)
		persistent_runes += new_applied
		if(holder)
			new_rune.on_persistent_apply(weapon, holder, src, new_applied)

	qdel(old_applied)

	recalculate_weapon_integrity()
	advance_active_rune()
	return TRUE

/datum/component/rune_storage/proc/remove_rune(datum/applied_rune/applied, mob/living/user)
	if(!applied)
		return FALSE

	var/index = applied_runes.Find(applied)
	if(!index)
		return FALSE

	var/datum/rune/rune = applied.rune
	var/mob/living/holder = get_current_holder()

	if(rune?.is_persistent)
		persistent_runes -= applied
		if(holder)
			rune.on_persistent_remove(get_weapon(), holder, src, applied)

	applied_runes.Cut(index, index + 1)
	qdel(applied)

	if(!length(applied_runes))
		active_rune = 1
	else if(active_rune > length(applied_runes))
		active_rune = 1
	else if(index < active_rune)
		active_rune--

	recalculate_weapon_integrity()

	if(!length(persistent_runes))
		current_persistent_holder = null
	else
		refresh_persistent_holder(get_current_holder())

	return TRUE

/datum/component/rune_storage/proc/get_random_ready_on_hit_rune(mob/living/user, atom/target)
	if(!length(applied_runes))
		return null

	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return null

	var/list/candidates = list()

	for(var/datum/applied_rune/A as anything in applied_runes)
		if(!A?.rune)
			continue
		if(A.rune.is_persistent)
			continue
		if(!(A.rune.trigger_flags & RUNE_TRIGGER_ON_HIT))
			continue
		if(!A.rune.can_trigger(weapon, user, target, src, A))
			continue

		candidates += A

	if(!length(candidates))
		return null

	return pick(candidates)

/datum/component/rune_storage/proc/trigger_random_weapon_rune(mob/living/user, atom/target)
	var/obj/item/weapon = get_weapon()
	if(!weapon)
		return FALSE

	var/datum/applied_rune/A = get_random_ready_on_hit_rune(user, target)
	if(!A || !A.rune)
		return FALSE

	A.rune.on_trigger(weapon, user, target, src, A)
	A.rune.finalize_trigger(weapon, A)
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

#undef RUNE_INTEGRITY_PENALTY_PCT

/obj/item/rogueweapon/attack(mob/living/target, mob/living/user, params)
	. = ..()

	if(!.)
		return .

	if(!isliving(target))
		return .

	var/datum/component/rune_storage/storage = GetComponent(/datum/component/rune_storage)
	if(storage)
		storage.refresh_persistent_holder()
		storage.trigger_random_weapon_rune(user, target)

	return .

/obj/item/rogueweapon/proc/get_rune_capacity()
	return 1

/obj/item/rogueweapon/huntingknife/get_rune_capacity()
	return 1

/obj/item/rogueweapon/flail/get_rune_capacity()
	return 1

/obj/item/rogueweapon/whip/get_rune_capacity()
	return 1

/obj/item/rogueweapon/axe/get_rune_capacity()
	return 2

/obj/item/rogueweapon/sword/get_rune_capacity()
	return 2

/obj/item/rogueweapon/mace/get_rune_capacity()
	return 2

/obj/item/rogueweapon/blunt/get_rune_capacity()
	return 2

/obj/item/rogueweapon/pick/get_rune_capacity()
	return 2

/obj/item/rogueweapon/spear/get_rune_capacity()
	return 3

/obj/item/rogueweapon/polearm/get_rune_capacity()
	return 3

/obj/item/rogueweapon/sword/long/get_rune_capacity()
	return 3

/obj/item/rogueweapon/sword/great/get_rune_capacity()
	return 3

/obj/item/rogueweapon/axe/twohanded/get_rune_capacity()
	return 3

/obj/item/rogueweapon/axe/great/get_rune_capacity()
	return 3

/obj/item/rogueweapon/mace/maul/grand/malum/get_rune_capacity()
	return 4

/obj/item/rogueweapon/greatsword/grenz/flamberge/malum/get_rune_capacity()
	return 4

/obj/item/rogueweapon/huntingknife/idagger/steel/malum/get_rune_capacity()
	return 4

/obj/item/rogueweapon/sword/blacksteel/get_rune_capacity()
	return 4

/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel/get_rune_capacity()
	return 4

/obj/item/rogueweapon/pick/blacksteel/get_rune_capacity()
	return 4
