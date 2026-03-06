/datum/component/trophy_hunter
	var/mob/living/carbon/human/owner
	var/obj/item/storage/hip/headhook/active_hook
	var/list/rules = list()
	var/list/applied_effects = list() // group_id => /datum/trophy_effect

/datum/component/trophy_hunter/Initialize()
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent

	rules += new /datum/trophy_rule/troll_armor
	rules += new /datum/trophy_rule/minotaur_str
	rules += new /datum/trophy_rule/dragon_per
	rules += new /datum/trophy_rule/aspirant_rage

	RegisterSignal(owner, COMSIG_ITEM_EQUIPPED, PROC_REF(on_item_equipped))
	RegisterSignal(owner, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))

/datum/component/trophy_hunter/Destroy()
	clear_active_hook()
	clear_effects()
	return ..()

/datum/component/trophy_hunter/proc/on_item_equipped(mob/user, obj/item/I, slot)
	if(!istype(I, /obj/item/storage/hip/headhook))
		return
	if(!(slot == SLOT_BELT_L || slot == SLOT_BELT_R))
		return

	set_active_hook(I)
	rebuild_effects()

/datum/component/trophy_hunter/proc/on_item_dropped(mob/user, obj/item/I)
	if(I != active_hook)
		return

	clear_active_hook()
	clear_effects()

/datum/component/trophy_hunter/proc/set_active_hook(obj/item/storage/hip/headhook/H)
	if(active_hook == H)
		return

	clear_active_hook()
	active_hook = H

	RegisterSignal(active_hook, COMSIG_HEADHOOK_CONTENTS_CHANGED, PROC_REF(on_hook_changed))
	RegisterSignal(active_hook, COMSIG_HEADHOOK_UNEQUIPPED, PROC_REF(on_hook_unequipped))

/datum/component/trophy_hunter/proc/clear_active_hook()
	if(!active_hook)
		return

	UnregisterSignal(active_hook, list(
		COMSIG_HEADHOOK_CONTENTS_CHANGED,
		COMSIG_HEADHOOK_UNEQUIPPED
	))
	active_hook = null

/datum/component/trophy_hunter/proc/on_hook_changed()
	rebuild_effects()

/datum/component/trophy_hunter/proc/on_hook_unequipped()
	clear_active_hook()
	clear_effects()

/datum/component/trophy_hunter/proc/rebuild_effects()
	clear_effects()

	if(!owner || !active_hook)
		return

	var/list/best_effects = list()
	var/list/best_scores = list()

	for(var/obj/item/I in active_hook.contents)
		for(var/datum/trophy_rule/R as anything in rules)
			if(!R.matches(I))
				continue

			var/group_id = R.group_id
			var/score = R.get_score(I)

			if(!(group_id in best_effects) || score > best_scores[group_id])
				best_scores[group_id] = score
				best_effects[group_id] = R.build_effect(I)
			break

	for(var/group_id in best_effects)
		var/datum/trophy_effect/E = best_effects[group_id]
		apply_effect(E)
		applied_effects[group_id] = E

/datum/component/trophy_hunter/proc/clear_effects()
	if(!owner)
		return

	for(var/group_id in applied_effects)
		var/datum/trophy_effect/E = applied_effects[group_id]
		remove_effect(E)

	applied_effects.Cut()

/datum/component/trophy_hunter/proc/apply_effect(datum/trophy_effect/E)
	switch(E.effect_type)
		if(TROPHY_EFFECT_STR)
			owner.change_stat(STATKEY_STR, E.value)

		if(TROPHY_EFFECT_PER)
			owner.change_stat(STATKEY_PER, E.value)

		if(TROPHY_EFFECT_RAGE_PACKAGE)
			owner.trophy_rage_duration_bonus += E.value
			owner.trophy_rage_cooldown_mult = min(owner.trophy_rage_cooldown_mult, E.aux_value)

	if(E.message)
		to_chat(owner, span_notice(E.message))

/datum/component/trophy_hunter/proc/remove_effect(datum/trophy_effect/E)
	switch(E.effect_type)
		if(TROPHY_EFFECT_STR)
			owner.change_stat(STATKEY_STR, -E.value)

		if(TROPHY_EFFECT_PER)
			owner.change_stat(STATKEY_PER, -E.value)

		if(TROPHY_EFFECT_RAGE_PACKAGE)
			owner.trophy_rage_duration_bonus = max(owner.trophy_rage_duration_bonus - E.value, 0)
			owner.trophy_rage_cooldown_mult = 1

/datum/component/trophy_hunter/proc/get_armor_bonus_for_zone(def_zone, d_type)
	var/list/valid_damage_types = list("blunt", "slash", "stab", "pierce")
	if(!(d_type in valid_damage_types))
		return 0

	var/datum/trophy_effect/E = applied_effects[TROPHY_GROUP_ARMOR]
	if(!E)
		return 0

	return E.value
