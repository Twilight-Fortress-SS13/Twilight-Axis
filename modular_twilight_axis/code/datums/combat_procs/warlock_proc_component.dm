// ============================================================
// warlock_proc_component.dm
// Warlock proc component.
// ============================================================

#define WARLOCK_SCHOOL_FIRE "fire"
#define WARLOCK_SCHOOL_FROST "frost"
#define WARLOCK_SCHOOL_FIREFROST "firefrost"

#define WARLOCK_SLOT_1 "slot_1"
#define WARLOCK_SLOT_2 "slot_2"
#define WARLOCK_SLOT_3 "slot_3"
#define WARLOCK_SLOT_4 "slot_4"
#define WARLOCK_SLOT_SWITCH "slot_switch"

#define WARLOCK_BASE_PROC_CHANCE 15
#define WARLOCK_PROC_PER_STACK 5
#define WARLOCK_DAMAGE_PER_STACK 0.10

/proc/warlock_get_component(mob/living/user)
	if(!isliving(user))
		return null

	var/datum/component/spell_proc/warlock/C = user.GetComponent(/datum/component/spell_proc/warlock)
	if(!C)
		C = user.AddComponent(/datum/component/spell_proc/warlock)
	return C

/proc/warlock_get_component_safe(mob/living/user)
	if(!isliving(user))
		return null

	return user.GetComponent(/datum/component/spell_proc/warlock)

/datum/component/spell_proc/warlock
	parent_type = /datum/component/spell_proc

	var/current_school = WARLOCK_SCHOOL_FIRE

	/// slot_id => actual spell datum currently occupying slot
	var/list/slot_spell_refs

	/// spell datum => slot_id
	var/list/spell_to_slot

	/// spell datum => school tag assigned on bar build
	var/list/spell_to_school

	/// slot_id => proc active?
	var/list/slot_proc_active

	/// slot_id => saved remaining cooldown of base spell bound to slot
	var/list/slot_saved_cooldown

/datum/component/spell_proc/warlock/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return .

	slot_spell_refs = list()
	spell_to_slot = list()
	spell_to_school = list()
	slot_proc_active = list()
	slot_saved_cooldown = list()

	slot_proc_active[WARLOCK_SLOT_1] = FALSE
	slot_proc_active[WARLOCK_SLOT_2] = FALSE
	slot_proc_active[WARLOCK_SLOT_3] = FALSE
	slot_proc_active[WARLOCK_SLOT_4] = FALSE

	slot_saved_cooldown[WARLOCK_SLOT_1] = 0
	slot_saved_cooldown[WARLOCK_SLOT_2] = 0
	slot_saved_cooldown[WARLOCK_SLOT_3] = 0
	slot_saved_cooldown[WARLOCK_SLOT_4] = 0

	GrantInitialSpells()
	return .

/datum/component/spell_proc/warlock/Destroy(force)
	RemoveManagedSpells()

	slot_spell_refs = null
	spell_to_slot = null
	spell_to_school = null
	slot_proc_active = null
	slot_saved_cooldown = null

	return ..()

/datum/component/spell_proc/warlock/proc/GrantInitialSpells()
	if(!owner?.mind)
		return FALSE

	return RebuildSpellBar()

/datum/component/spell_proc/warlock/proc/ToggleSchool()
	if(!owner?.mind)
		return FALSE

	SnapshotCooldowns()
	ClearAllProcSlots()

	current_school = (current_school == WARLOCK_SCHOOL_FIRE) ? WARLOCK_SCHOOL_FROST : WARLOCK_SCHOOL_FIRE
	return RebuildSpellBar()

/datum/component/spell_proc/warlock/proc/ClearAllProcSlots()
	slot_proc_active[WARLOCK_SLOT_1] = FALSE
	slot_proc_active[WARLOCK_SLOT_2] = FALSE
	slot_proc_active[WARLOCK_SLOT_3] = FALSE
	slot_proc_active[WARLOCK_SLOT_4] = FALSE

/datum/component/spell_proc/warlock/proc/RebuildSpellBar()
	if(!owner?.mind)
		return FALSE

	SnapshotCooldowns()
	RemoveManagedSpells()

	slot_spell_refs = list()
	spell_to_slot = list()
	spell_to_school = list()

	AddSpellToSlot(WARLOCK_SLOT_1)
	AddSpellToSlot(WARLOCK_SLOT_2)
	AddSpellToSlot(WARLOCK_SLOT_3)
	AddSpellToSlot(WARLOCK_SLOT_4)
	AddSpellToSlot(WARLOCK_SLOT_SWITCH)

	return TRUE

/datum/component/spell_proc/warlock/proc/RemoveManagedSpells()
	if(!owner?.mind || !islist(slot_spell_refs))
		return FALSE

	for(var/slot_id in slot_spell_refs)
		var/obj/effect/proc_holder/spell/S = slot_spell_refs[slot_id]
		if(S)
			owner.mind.RemoveSpell(S)

	return TRUE

/datum/component/spell_proc/warlock/proc/AddSpellToSlot(slot_id)
	if(!owner?.mind)
		return FALSE

	var/spell_type = GetSpellTypeForSlot(slot_id)
	if(!spell_type)
		return FALSE

	var/obj/effect/proc_holder/spell/S = new spell_type()
	if(!S)
		return FALSE

	owner.mind.AddSpell(S)

	slot_spell_refs[slot_id] = S
	spell_to_slot[S] = slot_id

	if(slot_id == WARLOCK_SLOT_SWITCH)
		spell_to_school[S] = null
	else
		spell_to_school[S] = current_school

	if(slot_id != WARLOCK_SLOT_SWITCH && !slot_proc_active[slot_id])
		ApplySavedCooldown(slot_id, S)

	return TRUE

/datum/component/spell_proc/warlock/proc/GetSpellTypeForSlot(slot_id)
	if(slot_id == WARLOCK_SLOT_SWITCH)
		return /obj/effect/proc_holder/spell/self/warlock_stance_switch

	if(slot_proc_active[slot_id])
		return GetProcSpellType(slot_id)

	return GetBaseSpellType(slot_id, current_school)

/datum/component/spell_proc/warlock/proc/GetBaseSpellType(slot_id, school)
	switch(slot_id)
		if(WARLOCK_SLOT_1)
			if(school == WARLOCK_SCHOOL_FIRE)
				return /obj/effect/proc_holder/spell/invoked/projectile/fire_arrow
			return /obj/effect/proc_holder/spell/invoked/projectile/frost_arrow

		if(WARLOCK_SLOT_2)
			if(school == WARLOCK_SCHOOL_FIRE)
				return /obj/effect/proc_holder/spell/invoked/dragon_breath
			return /obj/effect/proc_holder/spell/invoked/projectile/ice_ball

		if(WARLOCK_SLOT_3)
			if(school == WARLOCK_SCHOOL_FIRE)
				return /obj/effect/proc_holder/spell/invoked/projectile/pyroblast
			return /obj/effect/proc_holder/spell/invoked/chill_winds

		if(WARLOCK_SLOT_4)
			if(school == WARLOCK_SCHOOL_FIRE)
				return /obj/effect/proc_holder/spell/invoked/sun_nova
			return /obj/effect/proc_holder/spell/invoked/cold_glare

	return null

/datum/component/spell_proc/warlock/proc/GetProcSpellType(slot_id)
	switch(slot_id)
		if(WARLOCK_SLOT_1)
			return /obj/effect/proc_holder/spell/invoked/projectile/scorch_bolt
		if(WARLOCK_SLOT_2)
			return /obj/effect/proc_holder/spell/invoked/projectile/northern_spike
		if(WARLOCK_SLOT_3)
			return /obj/effect/proc_holder/spell/invoked/grave_grasp
		if(WARLOCK_SLOT_4)
			return /obj/effect/proc_holder/spell/invoked/immolate
	return null

/datum/component/spell_proc/warlock/proc/IsProcSlot(slot_id)
	if(slot_id == WARLOCK_SLOT_SWITCH)
		return FALSE
	return !!slot_proc_active[slot_id]

/datum/component/spell_proc/warlock/proc/SnapshotCooldowns()
	if(!islist(slot_spell_refs))
		return

	for(var/slot_id in list(WARLOCK_SLOT_1, WARLOCK_SLOT_2, WARLOCK_SLOT_3, WARLOCK_SLOT_4))
		if(slot_proc_active[slot_id])
			continue

		var/obj/effect/proc_holder/spell/S = slot_spell_refs[slot_id]
		if(!S)
			continue

		slot_saved_cooldown[slot_id] = GetRemainingCooldown(S)

/datum/component/spell_proc/warlock/proc/GetRemainingCooldown(obj/effect/proc_holder/spell/S)
	if(!S)
		return 0

	return max(S.recharge_time - S.charge_counter, 0)

/datum/component/spell_proc/warlock/proc/ApplySavedCooldown(slot_id, obj/effect/proc_holder/spell/S)
	if(!S)
		return

	var/remaining = slot_saved_cooldown[slot_id]
	var/datum/action/spell_action/SA = S.action

	if(!remaining || remaining <= 0)
		S.charge_counter = S.recharge_time
		S.last_process_time = world.time
		SA?.update_all_maptext(0)
		S.action?.build_all_button_icons()
		STOP_PROCESSING(SSfastprocess, S)
		return

	S.charge_counter = max(S.recharge_time - remaining, 0)
	S.last_process_time = world.time
	START_PROCESSING(SSfastprocess, S)
	SA?.update_all_maptext(remaining)
	S.action?.build_all_button_icons()

/datum/component/spell_proc/warlock/proc/GetSpellSchoolFromSlot(spell_slot)
	if(spell_slot == WARLOCK_SLOT_SWITCH)
		return null

	var/obj/effect/proc_holder/spell/S = slot_spell_refs[spell_slot]
	if(!S)
		return current_school

	var/spell_school = spell_to_school[S]
	if(spell_school == WARLOCK_SCHOOL_FIREFROST)
		return current_school

	return spell_school

/datum/component/spell_proc/warlock/proc/ResolveEffectiveSchool(spell_slot, spell_school)
	if(spell_school == WARLOCK_SCHOOL_FIRE)
		return WARLOCK_SCHOOL_FIRE
	if(spell_school == WARLOCK_SCHOOL_FROST)
		return WARLOCK_SCHOOL_FROST
	return null

/datum/component/spell_proc/warlock/proc/GetOppositeSchool(school)
	switch(school)
		if(WARLOCK_SCHOOL_FIRE)
			return WARLOCK_SCHOOL_FROST
		if(WARLOCK_SCHOOL_FROST)
			return WARLOCK_SCHOOL_FIRE
	return null

/datum/component/spell_proc/warlock/proc/GetHeatStatus()
	if(!owner)
		return null
	return owner.has_status_effect(/datum/status_effect/warlock_heat)

/datum/component/spell_proc/warlock/proc/GetColdStatus()
	if(!owner)
		return null
	return owner.has_status_effect(/datum/status_effect/warlock_cold)

/datum/component/spell_proc/warlock/proc/GetStacksForSchool(school)
	switch(school)
		if(WARLOCK_SCHOOL_FIRE)
			var/datum/status_effect/warlock_heat/H = GetHeatStatus()
			return H ? H.stacks : 0

		if(WARLOCK_SCHOOL_FROST)
			var/datum/status_effect/warlock_cold/C = GetColdStatus()
			return C ? C.stacks : 0

	return 0

/datum/component/spell_proc/warlock/proc/AddStackForSchool(school, amount = 1)
	if(!owner || amount <= 0)
		return

	switch(school)
		if(WARLOCK_SCHOOL_FIRE)
			owner.apply_status_effect(/datum/status_effect/warlock_heat)

		if(WARLOCK_SCHOOL_FROST)
			owner.apply_status_effect(/datum/status_effect/warlock_cold)

/datum/component/spell_proc/warlock/proc/ClearStacksForSchool(school)
	if(!owner)
		return

	switch(school)
		if(WARLOCK_SCHOOL_FIRE)
			var/datum/status_effect/warlock_heat/H = GetHeatStatus()
			if(H)
				qdel(H)

		if(WARLOCK_SCHOOL_FROST)
			var/datum/status_effect/warlock_cold/C = GetColdStatus()
			if(C)
				qdel(C)

/datum/component/spell_proc/warlock/proc/CalculateProcChanceForSchool(school)
	return WARLOCK_BASE_PROC_CHANCE + (GetStacksForSchool(school) * WARLOCK_PROC_PER_STACK)

/datum/component/spell_proc/warlock/OnSpellProcPreCast(spell_slot, spell_school, list/context)
	if(!spell_slot || spell_slot == WARLOCK_SLOT_SWITCH)
		return

	var/effective_school = ResolveEffectiveSchool(spell_slot, spell_school)
	if(!effective_school)
		return

	var/same_school_stacks = GetStacksForSchool(effective_school)
	var/opposite_school = GetOppositeSchool(effective_school)
	var/opposite_school_stacks = GetStacksForSchool(opposite_school)
	var/is_proc = IsProcSlot(spell_slot)
	var/proc_chance = CalculateProcChanceForSchool(effective_school)
	var/damage_mult = 1

	if(is_proc && same_school_stacks > 0)
		damage_mult += (same_school_stacks * WARLOCK_DAMAGE_PER_STACK)

	if(opposite_school_stacks > 0)
		damage_mult += (opposite_school_stacks * WARLOCK_DAMAGE_PER_STACK)

	context["effective_school"] = effective_school
	context["same_school_stacks"] = same_school_stacks
	context["opposite_school_stacks"] = opposite_school_stacks
	context["proc_chance"] = proc_chance
	context["damage_mult"] = damage_mult
	context["is_proc"] = is_proc

/datum/component/spell_proc/warlock/OnSpellProcCastResolved(spell_slot, spell_school, success, list/context)
	if(!success)
		return

	if(!spell_slot || spell_slot == WARLOCK_SLOT_SWITCH)
		return

	var/effective_school = context["effective_school"]
	if(!effective_school)
		effective_school = ResolveEffectiveSchool(spell_slot, spell_school)

	if(!effective_school)
		return

	var/is_proc = context["is_proc"]
	if(isnull(is_proc))
		is_proc = IsProcSlot(spell_slot)

	if(is_proc)
		ClearStacksForSchool(effective_school)
		slot_proc_active[spell_slot] = FALSE
		RebuildSpellBar()
		return

	var/opposite_school = GetOppositeSchool(effective_school)
	var/opposite_school_stacks = context["opposite_school_stacks"]
	if(isnull(opposite_school_stacks))
		opposite_school_stacks = GetStacksForSchool(opposite_school)

	if(opposite_school && opposite_school_stacks > 0)
		ClearStacksForSchool(opposite_school)

	AddStackForSchool(effective_school, 1)
	var/obj/effect/proc_holder/spell/S = slot_spell_refs[spell_slot]
	if(S)
		slot_saved_cooldown[spell_slot] = GetRemainingCooldown(S)

	var/proc_chance = context["proc_chance"]
	if(isnull(proc_chance))
		proc_chance = CalculateProcChanceForSchool(effective_school)

	if(prob(proc_chance))
		slot_proc_active[spell_slot] = TRUE
		RebuildSpellBar()

#undef WARLOCK_SLOT_SWITCH
#undef WARLOCK_BASE_PROC_CHANCE
#undef WARLOCK_PROC_PER_STACK
#undef WARLOCK_DAMAGE_PER_STACK

/proc/warlock_spell_pre_cast(mob/living/user, spell_slot, spell_school, obj/effect/proc_holder/spell/S)
	var/list/context = list()

	if(!isliving(user))
		return context

	SEND_SIGNAL(user, COMSIG_SPELL_PROC_PRE_CAST, spell_slot, spell_school, context)

	if(S)
		S.StoreWarlockPreCastContext(context)

	return context

/proc/warlock_spell_post_cast(mob/living/user, spell_slot, spell_school, success, list/context)
	if(!isliving(user))
		return

	if(!islist(context))
		context = list()

	SEND_SIGNAL(user, COMSIG_SPELL_PROC_CAST_RESOLVED, spell_slot, spell_school, success, context)

/proc/warlock_get_damage_mult(list/context)
	if(!islist(context))
		return 1

	var/damage_mult = context["damage_mult"]
	return isnull(damage_mult) ? 1 : damage_mult

/obj/effect/proc_holder/spell/proc/StoreWarlockPreCastContext(list/context)
	return

/obj/effect/proc_holder/spell/self/warlock_stance_switch
	name = "Warlock Stance"
	desc = "Переключает стойку варлока."
	panel = "Spells"

	clothes_req = FALSE
	human_req = FALSE
	nonabstract_req = FALSE
	stat_allowed = FALSE
	phase_allowed = FALSE
	antimagic_allowed = FALSE

	charge_type = "recharge"
	recharge_time = 1
	charge_counter = 1
	cost = 0
	xp_gain = FALSE

	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	no_early_release = TRUE
	hide_charge_effect = TRUE
	charging_slowdown = 0
	chargedloop = null
	invocation_type = "none"
	overlay_state = null
	ignore_los = TRUE
	range = 0
	cast_without_targets = TRUE

	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "stance_switch"

/obj/effect/proc_holder/spell/self/warlock_stance_switch/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return

	perform(null, user = user)

/obj/effect/proc_holder/spell/self/warlock_stance_switch/cast(list/targets, mob/living/user = usr)
	if(!isliving(user))
		return FALSE

	var/datum/component/spell_proc/warlock/W = warlock_get_component_safe(user)
	if(!W)
		return FALSE

	return W.ToggleSchool()
