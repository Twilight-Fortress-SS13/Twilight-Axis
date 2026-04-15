#define RUNEBLADE_FORM_TELEGRAPH_DELAY (0.20 SECONDS)
#define RUNEBLADE_AOE_TELEGRAPH_DELAY  (0.30 SECONDS)
#define RUNEBLADE_TRICK_FOLLOWUP_DELAY (0.50 SECONDS)
#define RUNEBLADE_DASH_HITS 4

/proc/runeblade_get_component(mob/living/user)
	if(!isliving(user))
		return null
	var/datum/component/combo_core/runeblade/C = user.GetComponent(/datum/component/combo_core/runeblade)
	if(!C)
		C = user.AddComponent(/datum/component/combo_core/runeblade)
	return C


/proc/runeblade_prime_strike(
	mob/living/user,
	skill_id,
	effect_mult,
	cooldown_mult,
	weapon_self_damage_pct,
	activate_all,
	use_in_combo,
	prepared_name
)
	var/datum/component/combo_core/runeblade/C = runeblade_get_component(user)
	return C ? C.PrimeStrike(skill_id, effect_mult, cooldown_mult, weapon_self_damage_pct, activate_all, use_in_combo, prepared_name) : FALSE

/datum/component/combo_core/runeblade
	parent_type = /datum/component/combo_core
	var/list/granted_spells = list()
	var/spells_granted = FALSE

/datum/component/combo_core/runeblade/Initialize(_combo_window, _max_history)
	. = ..(_combo_window || 10 SECONDS, _max_history || 5)
	if(. == COMPONENT_INCOMPATIBLE)
		return .
	RegisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME, PROC_REF(_sig_attack_committed))
	GrantSpells()

/datum/component/combo_core/runeblade/Destroy(force)
	if(owner)
		UnregisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME)
		RevokeSpells()
	return ..()

/datum/component/combo_core/runeblade/proc/_sig_attack_committed(datum/source, mob/living/target, zone, obj/item/weapon)
	SIGNAL_HANDLER
	ConsumePreparedStrike(target, weapon, zone)
	return 0

/datum/component/combo_core/runeblade/DefineRules()
	RegisterRule("longstrike",   list(1,1),       10,  PROC_REF(_cb_longstrike))
	RegisterRule("projectile",   list(2,2),       20,  PROC_REF(_cb_projectile))
	RegisterRule("dash",         list(3,3),       30,  PROC_REF(_cb_dash))
	RegisterRule("nova",         list(1,2,1),     40,  PROC_REF(_cb_nova))
	RegisterRule("splash",       list(2,3,2),     50,  PROC_REF(_cb_splash))
	RegisterRule("cleave",       list(3,1,3),     60,  PROC_REF(_cb_cleave))
	RegisterRule("overstrain",   list(1,2,3,1,2), 90,  PROC_REF(_cb_overstrain))
	RegisterRule("absorb",       list(2,3,1,2,3),100,  PROC_REF(_cb_absorb))
	RegisterRule("trick",        list(3,1,2,3,1),110,  PROC_REF(_cb_trick))

/datum/component/combo_core/runeblade/proc/GrantSpells()
	if(spells_granted || !owner?.mind)
		return
	var/list/paths = list(
		/obj/effect/proc_holder/spell/self/runeblade/manifestation,
		/obj/effect/proc_holder/spell/self/runeblade/overload,
		/obj/effect/proc_holder/spell/self/runeblade/harmony,
		/obj/effect/proc_holder/spell/self/runeblade/saturation
	)
	for(var/path in paths)
		var/obj/effect/proc_holder/spell/S = new path
		owner.mind.AddSpell(S)
		granted_spells += S
	spells_granted = TRUE

/datum/component/combo_core/runeblade/proc/RevokeSpells()
	if(!owner)
		return
	if(owner.mind)
		for(var/obj/effect/proc_holder/spell/S as anything in granted_spells)
			if(S)
				owner.mind.RemoveSpell(S)
	else
		for(var/obj/effect/proc_holder/spell/S as anything in granted_spells)
			if(S)
				qdel(S)
	granted_spells = list()
	spells_granted = FALSE

/datum/component/combo_core/runeblade/proc/PrimeStrike(
	skill_id,
	effect_mult,
	cooldown_mult,
	weapon_self_damage_pct,
	activate_all,
	use_in_combo,
	prepared_name
)
	if(!owner || !isnum(skill_id))
		return FALSE
	skill_id = round(skill_id)
	if(skill_id < 1 || skill_id > 4)
		return FALSE
	owner.remove_status_effect(/datum/status_effect/buff/runeblade_prepared)
	owner.apply_status_effect(
		/datum/status_effect/buff/runeblade_prepared,
		skill_id,
		effect_mult,
		cooldown_mult,
		weapon_self_damage_pct,
		activate_all,
		use_in_combo,
		prepared_name
	)
	return !!owner.has_status_effect(/datum/status_effect/buff/runeblade_prepared)

/datum/component/combo_core/runeblade/proc/ConsumePreparedStrike(mob/living/target, obj/item/weapon, zone)
	if(!owner || !weapon)
		return FALSE
	var/datum/status_effect/buff/runeblade_prepared/P = owner.has_status_effect(/datum/status_effect/buff/runeblade_prepared)
	if(!P)
		return FALSE
	var/skill_id = P.skill_id
	var/effect_mult = P.effect_mult
	var/cooldown_mult = P.cooldown_mult
	var/weapon_self_damage_pct = P.weapon_self_damage_pct
	var/activate_all = P.activate_all
	var/use_in_combo = P.use_in_combo
	var/datum/component/rune_storage/storage = weapon.GetComponent(/datum/component/rune_storage)
	var/success = FALSE
	if(storage && target)
		if(activate_all)
			success = storage.trigger_runeblade_all_runes(owner, target, effect_mult, cooldown_mult, weapon_self_damage_pct)
		else
			success = storage.trigger_runeblade_best_rune(owner, target, effect_mult, cooldown_mult, weapon_self_damage_pct)
	if(use_in_combo)
		RegisterInput(skill_id, target, zone || owner.zone_selected || BODY_ZONE_CHEST)
	owner.remove_status_effect(/datum/status_effect/buff/runeblade_prepared)
	return success

/datum/component/combo_core/runeblade/proc/GetRunebladeWeapon()
	if(!owner)
		return null
	return owner.get_active_held_item()

/datum/component/combo_core/runeblade/proc/GetRunebladeStorage()
	var/obj/item/I = GetRunebladeWeapon()
	if(!I)
		return null
	return I.GetComponent(/datum/component/rune_storage)

/datum/component/combo_core/runeblade/proc/GetFrontTurf(distance = 1, dir_override = null)
	if(!owner)
		return null
	var/turf/T = get_turf(owner)
	if(!T)
		return null
	var/d = dir_override || owner.dir
	for(var/i in 1 to distance)
		var/turf/next = get_step(T, d)
		if(!next)
			return T
		T = next
	return T

/datum/component/combo_core/runeblade/proc/GetLivingOnTurf(turf/T)
	if(!T)
		return null
	for(var/mob/living/L in T)
		if(L == owner)
			continue
		if(L.stat == DEAD)
			continue
		return L
	return null

/datum/component/combo_core/runeblade/proc/GetLivingInRadius(radius = 1)
	var/list/res = list()
	if(!owner)
		return res
	for(var/mob/living/L in orange(radius, owner))
		if(L == owner)
			continue
		if(L.stat == DEAD)
			continue
		res |= L
	return res

/datum/component/combo_core/runeblade/proc/GetLivingFrontLine(width = 3, distance = 1, dir_override = null)
	var/list/res = list()
	if(!owner)
		return res
	var/d = dir_override || owner.dir
	var/turf/center = GetFrontTurf(distance, d)
	if(!center)
		return res
	var/mob/living/C = GetLivingOnTurf(center)
	if(C)
		res |= C
	if(width >= 3)
		var/turf/LT = get_step(center, turn(d, 90))
		var/turf/RT = get_step(center, turn(d, -90))
		var/mob/living/LL = GetLivingOnTurf(LT)
		var/mob/living/RR = GetLivingOnTurf(RT)
		if(LL)
			res |= LL
		if(RR)
			res |= RR
	return res

/datum/component/combo_core/runeblade/proc/GetTeleportPath(max_steps = RUNEBLADE_DASH_HITS)
	var/list/path = list()
	if(!owner)
		return path
	var/turf/current = get_turf(owner)
	if(!current)
		return path
	var/d = owner.dir
	for(var/i in 1 to max_steps)
		var/turf/next = get_step(current, d)
		if(!next || next.density)
			break
		path += next
		current = next
	return path

/datum/component/combo_core/runeblade/proc/GetAdjacentTurfs()
	var/list/turfs = list()
	if(!owner)
		return turfs
	for(var/turf/T in orange(1, owner))
		turfs += T
	return turfs

/datum/component/combo_core/runeblade/proc/GetLongstrikeTurfs()
	var/list/turfs = list()
	var/turf/T1 = GetFrontTurf(1)
	var/turf/T2 = GetFrontTurf(2)
	if(T1)
		turfs += T1
	if(T2)
		turfs += T2
	return turfs

/datum/component/combo_core/runeblade/proc/GetSplashTurfs()
	var/list/turfs = list()
	if(!owner)
		return turfs
	var/turf/center = GetFrontTurf(1)
	if(!center)
		return turfs
	turfs += center
	var/turf/left = get_step(center, turn(owner.dir, 90))
	var/turf/right = get_step(center, turn(owner.dir, -90))
	if(left)
		turfs += left
	if(right)
		turfs += right
	return turfs

/datum/component/combo_core/runeblade/proc/SwingFX(turf/T)
	if(!T)
		return
	var/obj/effect/temp_visual/special_intent/fx = new(T)
	fx.icon = 'icons/effects/effects.dmi'
	fx.icon_state = "sweep_fx"

/datum/component/combo_core/runeblade/proc/ExclaimFX(turf/T)
	if(!T)
		return
	var/obj/effect/temp_visual/special_intent/fx = new(T)
	fx.icon = 'icons/effects/effects.dmi'
	fx.icon_state = "blip"

/datum/component/combo_core/runeblade/proc/ExclaimTurfs(list/turfs)
	for(var/turf/T in turfs)
		if(T)
			ExclaimFX(T)

/datum/component/combo_core/runeblade/proc/SwingTurfs(list/turfs)
	for(var/turf/T in turfs)
		if(T)
			SwingFX(T)

/datum/component/combo_core/runeblade/proc/ComboTriggerTarget(mob/living/target, effect_mult = 1, cooldown_mult = 1, weapon_self_damage_pct = 0)
	var/datum/component/rune_storage/storage = GetRunebladeStorage()
	if(!storage || !target)
		return FALSE
	return storage.trigger_runeblade_best_rune(owner, target, effect_mult, cooldown_mult, weapon_self_damage_pct)

/datum/component/combo_core/runeblade/proc/ComboTriggerTargetList(list/targets, effect_mult = 1, cooldown_mult = 1, weapon_self_damage_pct = 0)
	if(!length(targets))
		return TRUE
	var/triggered = FALSE
	for(var/mob/living/L in targets)
		if(!L || L.stat == DEAD)
			continue
		if(ComboTriggerTarget(L, effect_mult, cooldown_mult, weapon_self_damage_pct))
			triggered = TRUE
	return triggered

/datum/component/combo_core/runeblade/proc/ComboTriggerAllTargets(list/targets, effect_mult = 1, cooldown_mult = 1, weapon_self_damage_pct = 0)
	var/datum/component/rune_storage/storage = GetRunebladeStorage()
	if(!storage)
		return FALSE
	var/triggered = FALSE
	for(var/mob/living/L in targets)
		if(!L || L.stat == DEAD)
			continue
		if(storage.trigger_runeblade_all_runes(owner, L, effect_mult, cooldown_mult, weapon_self_damage_pct))
			triggered = TRUE
	return triggered

/datum/component/combo_core/runeblade/proc/GetTargetsOnTurfs(list/turfs)
	var/list/targets = list()
	for(var/turf/T in turfs)
		if(!T)
			continue
		var/mob/living/L = GetLivingOnTurf(T)
		if(L)
			targets |= L
	return targets

/datum/component/combo_core/runeblade/proc/_cb_longstrike(rule_id, mob/living/target, zone)
	var/list/turfs = GetLongstrikeTurfs()
	ExclaimTurfs(turfs)
	QueueAction(RUNEBLADE_FORM_TELEGRAPH_DELAY, PROC_REF(_resolve_longstrike), turfs)
	return TRUE

/datum/component/combo_core/runeblade/proc/_resolve_longstrike(list/turfs)
	SwingTurfs(turfs)
	ComboTriggerTargetList(GetTargetsOnTurfs(turfs), 1, 1, 0)

/datum/component/combo_core/runeblade/proc/_cb_projectile(rule_id, mob/living/target, zone)
	var/obj/item/weapon = GetRunebladeWeapon()
	var/datum/component/rune_storage/storage = GetRunebladeStorage()
	if(!weapon || !storage || !owner)
		return FALSE
	var/datum/applied_rune/applied = storage.get_runeblade_candidate()
	if(!applied)
		return FALSE
	var/turf/start = get_turf(owner)
	if(!start)
		return FALSE
	var/atom/aim_target = target || get_step(start, owner.dir)
	var/turf/aim_turf = get_turf(aim_target)
	if(aim_turf)
		ExclaimFX(aim_turf)
	QueueAction(
		RUNEBLADE_FORM_TELEGRAPH_DELAY,
		PROC_REF(_fire_projectile),
		start,
		weapon,
		applied,
		aim_target
	)
	return TRUE

/datum/component/combo_core/runeblade/proc/_fire_projectile(turf/start, obj/item/weapon, datum/applied_rune/applied, atom/aim_target)
	if(!owner || !start || !weapon || QDELETED(weapon) || !applied)
		return
	var/turf/aim_turf = get_turf(aim_target)
	if(aim_turf)
		SwingFX(aim_turf)
	var/obj/projectile/runeblade_bolt/P = new(start, owner, weapon, applied, 1, 1, 0)
	P.preparePixelProjectile(aim_target, owner)
	P.fire()

/datum/component/combo_core/runeblade/proc/_cb_dash(rule_id, atom/target, zone)
	if(!owner)
		return FALSE

	var/list/path = GetTeleportPath()
	if(!length(path))
		return FALSE

	var/turf/current = get_turf(owner)
	if(!current)
		return FALSE

	var/last_hit_success = FALSE

	for(var/turf/next as anything in path)
		if(!next || next.density)
			break

		owner.forceMove(next)
		current = next

		var/mob/living/L = GetLivingOnTurf(next)
		if(!L)
			continue

		var/hit_success = ComboTriggerTarget(L, 1, 1, 0)
		last_hit_success = hit_success

	return last_hit_success

/datum/component/combo_core/runeblade/proc/_cb_nova(rule_id, mob/living/target, zone)
	var/list/turfs = GetAdjacentTurfs()
	ExclaimTurfs(turfs)
	QueueAction(
		RUNEBLADE_AOE_TELEGRAPH_DELAY,
		PROC_REF(_resolve_nova),
		turfs
	)
	return TRUE

/datum/component/combo_core/runeblade/proc/_resolve_nova(list/turfs)
	SwingTurfs(turfs)
	ComboTriggerTargetList(GetTargetsOnTurfs(turfs), 0.8, 1, 0)

/datum/component/combo_core/runeblade/proc/_cb_splash(rule_id, mob/living/target, zone)
	var/list/turfs = GetSplashTurfs()
	ExclaimTurfs(turfs)
	QueueAction(
		RUNEBLADE_AOE_TELEGRAPH_DELAY,
		PROC_REF(_resolve_splash),
		turfs
	)
	return TRUE

/datum/component/combo_core/runeblade/proc/_resolve_splash(list/turfs)
	SwingTurfs(turfs)
	ComboTriggerTargetList(GetTargetsOnTurfs(turfs), 0.9, 1, 0)

/datum/component/combo_core/runeblade/proc/_cb_cleave(rule_id, mob/living/target, zone)
	var/list/turfs = GetAdjacentTurfs()
	ExclaimTurfs(turfs)
	QueueAction(
		RUNEBLADE_AOE_TELEGRAPH_DELAY,
		PROC_REF(_resolve_cleave),
		turfs
	)
	return TRUE

/datum/component/combo_core/runeblade/proc/_resolve_cleave(list/turfs)
	SwingTurfs(turfs)
	ComboTriggerTargetList(GetTargetsOnTurfs(turfs), 1, 1, 0)

/datum/component/combo_core/runeblade/proc/_cb_overstrain(rule_id, mob/living/target, zone)
	var/list/turfs = GetAdjacentTurfs()
	var/list/targets = GetTargetsOnTurfs(turfs)
	if(!length(targets) && target)
		targets += target
	ExclaimTurfs(turfs)
	QueueAction(
		RUNEBLADE_AOE_TELEGRAPH_DELAY,
		PROC_REF(_resolve_all_targets),
		targets
	)
	return TRUE

/datum/component/combo_core/runeblade/proc/_resolve_all_targets(list/targets)
	for(var/mob/living/L in targets)
		if(L)
			SwingFX(get_turf(L))
	ComboTriggerAllTargets(targets, 3.0, 1, 0.20)

/datum/component/combo_core/runeblade/proc/_cb_absorb(rule_id, mob/living/target, zone)
	var/datum/component/rune_storage/storage = GetRunebladeStorage()
	if(!storage)
		return FALSE
	var/datum/applied_rune/applied = storage.get_runeblade_candidate()
	if(!applied?.rune)
		return FALSE
	var/element = applied.rune.element
	if(!storage.remove_rune(applied, owner))
		return FALSE
	owner.apply_status_effect(/datum/status_effect/buff/runeblade_absorption, element)
	return TRUE

/datum/component/combo_core/runeblade/proc/_cb_trick(rule_id, mob/living/target, zone)
	var/obj/item/weapon = GetRunebladeWeapon()
	var/datum/component/rune_storage/storage = GetRunebladeStorage()
	if(!weapon || !storage || !target || target.stat == DEAD)
		return FALSE
	var/rune_count = 0
	for(var/datum/applied_rune/applied in storage.applied_runes)
		if(applied?.rune && !applied.rune.is_persistent)
			rune_count++
	if(rune_count <= 0)
		return FALSE
	var/turf/TT = get_turf(target)
	if(TT)
		ExclaimFX(TT)
	weapon.take_damage(max(1, round(weapon.obj_integrity / 10)), BRUTE, "blunt")
	for(var/i in 1 to rune_count)
		QueueAction(
			RUNEBLADE_AOE_TELEGRAPH_DELAY + ((i - 1) * RUNEBLADE_TRICK_FOLLOWUP_DELAY),
			PROC_REF(_trick_followup_hit),
			target,
			weapon,
			storage
		)
	return TRUE

/datum/component/combo_core/runeblade/proc/_trick_followup_hit(mob/living/target, obj/item/weapon, datum/component/rune_storage/storage)
	if(!owner || !target || target.stat == DEAD)
		return
	if(!weapon || QDELETED(weapon) || !storage || QDELETED(storage))
		return
	var/turf/TT = get_turf(target)
	if(TT)
		SwingFX(TT)
	storage.trigger_runeblade_best_rune(owner, target, 1, 1, 0)

#undef RUNEBLADE_FORM_TELEGRAPH_DELAY
#undef RUNEBLADE_AOE_TELEGRAPH_DELAY
#undef RUNEBLADE_TRICK_FOLLOWUP_DELAY
#undef RUNEBLADE_DASH_HITS
