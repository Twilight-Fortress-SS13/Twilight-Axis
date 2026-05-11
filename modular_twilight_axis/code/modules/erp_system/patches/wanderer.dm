// ============================================================
// MARTIAL MASTER
// Full combat-style component.
// ============================================================

#define MARTIAL_MASTER_COMBO_WINDOW            (7 SECONDS)
#define MARTIAL_MASTER_MAX_HISTORY             6
#define MARTIAL_MASTER_MAX_AROUSAL_STACKS      10
#define MARTIAL_MASTER_AROUSAL_DMG_PER_STACK   0.05
#define MARTIAL_MASTER_KICK_MIN_RECOVERY       (0.5 SECONDS)

#define MARTIAL_MASTER_INPUT_PUNCH             1
#define MARTIAL_MASTER_INPUT_KICK              2
#define MARTIAL_MASTER_INPUT_GRAB              3

#define MARTIAL_MASTER_STANCE_PROC             1
#define MARTIAL_MASTER_STANCE_PRECISE          2

#define MARTIAL_MASTER_BUTTON_SWITCH_STANCE    101

#define MARTIAL_MASTER_REVERSE_WINDOW          (3 SECONDS)
#define MARTIAL_MASTER_CHAIN_STEP_WINDOW       (2 SECONDS)
#define MARTIAL_MASTER_CHARGE_RANGE            8
#define MARTIAL_MASTER_CHAIN_STEP_RANGE        3
#define MARTIAL_MASTER_LINE_RANGE              2
#define MARTIAL_MASTER_CONE_RANGE              2

#define MARTIAL_MASTER_BALLOON_COOLDOWN        (0.5 SECONDS)
#define MARTIAL_MASTER_STRONG_KICK_THROW       1
#define MARTIAL_MASTER_STRONG_KICK_BONUS       0.20

/proc/martial_master_get_component(mob/living/user)
	if(!isliving(user))
		return null

	var/datum/component/combo_core/martial_master/C = user.GetComponent(/datum/component/combo_core/martial_master)
	if(!C)
		C = user.AddComponent(/datum/component/combo_core/martial_master)
	return C

/proc/martial_master_get_component_safe(mob/living/user)
	if(!isliving(user))
		return null

	return user.GetComponent(/datum/component/combo_core/martial_master)

/datum/component/combo_core/martial_master
	parent_type = /datum/component/combo_core/combat_style
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/current_stance = MARTIAL_MASTER_STANCE_PROC

	var/arousal_stacks = 0
	var/max_arousal_stacks = MARTIAL_MASTER_MAX_AROUSAL_STACKS

	var/last_action_success = FALSE
	var/last_action_skill = 0
	var/last_action_zone = BODY_ZONE_CHEST
	var/mob/living/last_action_target = null

	var/last_finisher_success = FALSE
	var/last_matched_rule = null

	var/reverse_ready = FALSE
	var/reverse_expires_at = 0

	var/chain_step_ready = FALSE
	var/chain_step_expires_at = 0
	var/mob/living/chain_step_target = null

	var/list/granted_spells = list()
	var/spells_granted = FALSE

	var/last_balloon_at = 0

/datum/component/combo_core/martial_master/Initialize(_combo_window, _max_history)
	. = ..(_combo_window || MARTIAL_MASTER_COMBO_WINDOW, _max_history || MARTIAL_MASTER_MAX_HISTORY)
	if(. == COMPONENT_INCOMPATIBLE)
		return .

	START_PROCESSING(SSprocessing, src)

	StripExternalStyleSpells()
	GrantSpells()
	OnAttachApplyHiddenStats()

	RegisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME, PROC_REF(_sig_try_consume))
	RegisterSignal(owner, COMSIG_MOB_PARRY_SUCCESS, PROC_REF(_sig_reverse_defense_success))

	_balloon_stance()
	return .

/datum/component/combo_core/martial_master/Destroy(force)
	STOP_PROCESSING(SSprocessing, src)

	if(owner)
		UnregisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME)
		UnregisterSignal(owner, COMSIG_MOB_PARRY_SUCCESS)

		OnDetachClearHiddenStats()
		RevokeSpells()

	owner = null
	granted_spells = null
	chain_step_target = null
	last_action_target = null
	return ..()

/datum/component/combo_core/martial_master/process()
	if(reverse_ready && world.time >= reverse_expires_at)
		reverse_ready = FALSE
		reverse_expires_at = 0

	if(chain_step_ready && world.time >= chain_step_expires_at)
		chain_step_ready = FALSE
		chain_step_expires_at = 0
		chain_step_target = null

/datum/component/combo_core/martial_master/DefineRules()
	RegisterRule("line",       list(MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_PUNCH), 40, PROC_REF(_cb_combo))
	RegisterRule("cone",       list(MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_KICK),  45, PROC_REF(_cb_combo))
	RegisterRule("charge",     list(MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_GRAB),  50, PROC_REF(_cb_combo))

	RegisterRule("spear",      list(MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_PUNCH), 45, PROC_REF(_cb_combo))
	RegisterRule("push",       list(MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_KICK),  50, PROC_REF(_cb_combo))

	RegisterRule("spin",       list(MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_KICK),  45, PROC_REF(_cb_combo))
	RegisterRule("swap",       list(MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_PUNCH), 50, PROC_REF(_cb_combo))
	RegisterRule("chain_step", list(MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_GRAB),  55, PROC_REF(_cb_combo))

	RegisterRule("silence",    list(MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_KICK),  45, PROC_REF(_cb_combo))
	RegisterRule("cross",      list(MARTIAL_MASTER_INPUT_KICK,  MARTIAL_MASTER_INPUT_PUNCH, MARTIAL_MASTER_INPUT_PUNCH), 45, PROC_REF(_cb_combo))

	RegisterRule("reverse",    list(MARTIAL_MASTER_INPUT_GRAB,  MARTIAL_MASTER_INPUT_GRAB,  MARTIAL_MASTER_INPUT_GRAB),  55, PROC_REF(_cb_combo))

/datum/component/combo_core/martial_master/OnHistoryChanged()
	return

/datum/component/combo_core/martial_master/OnHistoryCleared(reason)
	last_matched_rule = null
	last_finisher_success = FALSE

/datum/component/combo_core/martial_master/OnComboExpired()
	last_matched_rule = null
	last_finisher_success = FALSE

/datum/component/combo_core/martial_master/OnComboMatched(rule_id, mob/living/target, zone)
	last_finisher_success = TRUE
	last_matched_rule = rule_id

/datum/component/combo_core/martial_master/ConsumeOnCombo(rule_id)
	ClearHistory("combo")

/datum/component/combo_core/martial_master/proc/StripExternalStyleSpells()
	if(!owner?.mind)
		return

	var/list/current = owner.mind.spell_list?.Copy()
	if(!length(current))
		return

	for(var/obj/effect/proc_holder/spell/S as anything in current)
		if(!S)
			continue

		if(istype(S, /obj/effect/proc_holder/spell/self/martial_master))
			owner.mind.RemoveSpell(S)
			continue

		if(istype(S, /obj/effect/proc_holder/spell/self/temptress))
			owner.mind.RemoveSpell(S)
			continue

		if(istype(S, /obj/effect/proc_holder/spell/self/soundbreaker))
			owner.mind.RemoveSpell(S)
			continue

		if(istype(S, /obj/effect/proc_holder/spell/self/ronin))
			owner.mind.RemoveSpell(S)
			continue

/datum/component/combo_core/martial_master/proc/GrantSpells()
	if(spells_granted || !owner?.mind)
		return

	var/mob/living/L = owner
	RevokeSpells()

	var/list/paths = list(
		/obj/effect/proc_holder/spell/self/martial_master/switch_stance
	)

	for(var/path in paths)
		var/obj/effect/proc_holder/spell/S = new path
		L.mind.AddSpell(S)
		granted_spells += S

	spells_granted = TRUE

/datum/component/combo_core/martial_master/proc/RevokeSpells()
	if(!owner)
		return

	if(!length(granted_spells))
		spells_granted = FALSE
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

/datum/component/combo_core/martial_master/proc/OnAttachApplyHiddenStats()
	var/mob/living/H = owner
	if(!H)
		return

	ADD_TRAIT(H, TRAIT_KEENEARS, type)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, type)
	ADD_TRAIT(H, TRAIT_EMPATH, type)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, type)
	ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, type)

	H.change_stat(STATKEY_STR, 4)
	H.change_stat(STATKEY_SPD, 3)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_WIL, 5)
	H.change_stat(STATKEY_CON, 4)

	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)

/datum/component/combo_core/martial_master/proc/OnDetachClearHiddenStats()
	var/mob/living/H = owner
	if(!H)
		return

	REMOVE_TRAIT(H, TRAIT_KEENEARS, type)
	REMOVE_TRAIT(H, TRAIT_NUTCRACKER, type)
	REMOVE_TRAIT(H, TRAIT_EMPATH, type)
	REMOVE_TRAIT(H, TRAIT_NOPAINSTUN, type)
	REMOVE_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, type)

	H.change_stat(STATKEY_STR, -4)
	H.change_stat(STATKEY_SPD, -3)
	H.change_stat(STATKEY_PER, -2)
	H.change_stat(STATKEY_WIL, -5)
	H.change_stat(STATKEY_CON, -4)

/datum/component/combo_core/martial_master/proc/_sig_try_consume(datum/source, atom/target_atom, zone, obj/item/W, forced_skill_id)
	SIGNAL_HANDLER

	if(!owner)
		return 0

	if(W)
		return 0

	var/skill_id = forced_skill_id || ResolveAttackInput(target_atom, W)
	if(!IsBaseInput(skill_id))
		return 0

	var/mob/living/target = null
	if(isliving(target_atom))
		target = target_atom

	INVOKE_ASYNC(src, PROC_REF(_handle_try_consume_async), skill_id, target, zone)
	return 0

/datum/component/combo_core/martial_master/proc/_handle_try_consume_async(skill_id, mob/living/target, zone)
	if(!owner)
		return

	last_action_success = TRUE
	last_action_skill = skill_id
	last_action_zone = zone || BODY_ZONE_CHEST
	last_action_target = target
	last_finisher_success = FALSE
	last_matched_rule = null

	if(current_stance == MARTIAL_MASTER_STANCE_PROC)
		ApplyProcPressureOnHit(target, last_action_zone, FALSE)
	else
		ApplyPreciseOnHit(target, last_action_zone)

	if(chain_step_ready)
		if(world.time >= chain_step_expires_at || !chain_step_target)
			chain_step_ready = FALSE
			chain_step_expires_at = 0
			chain_step_target = null
		else if(target == chain_step_target)
			target.adjustBruteLoss(max(1, round(GetComboDamageMultiplier() * 1.5)))
			ApplyArmorDamageToZone(target, last_action_zone, GetPressureDamage() * 2)

			if(HasStrongKick())
				_throw_target_dir(target, get_dir(owner, target), MARTIAL_MASTER_STRONG_KICK_THROW, TRUE)

			chain_step_ready = FALSE
			chain_step_expires_at = 0
			chain_step_target = null

			_balloon("chain-step hit")

	RegisterInput(skill_id, target, last_action_zone)
	SpendArousalStack(1)

	datum_component_combo_martial_master_check_nutcracker(src, target, last_action_zone, skill_id)

/datum/component/combo_core/martial_master/proc/_sig_reverse_defense_success(datum/source, mob/living/attacker)
	SIGNAL_HANDLER

	if(!reverse_ready)
		return
	if(world.time >= reverse_expires_at)
		reverse_ready = FALSE
		reverse_expires_at = 0
		return
	if(!attacker || attacker.stat == DEAD)
		return

	INVOKE_ASYNC(src, PROC_REF(_async_reverse_counter), attacker)

/datum/component/combo_core/martial_master/proc/_async_reverse_counter(mob/living/attacker)
	if(!owner || !attacker || attacker.stat == DEAD)
		return

	reverse_ready = FALSE
	reverse_expires_at = 0

	MartialMasterWaveUp("#5a0f1f")
	var/d = get_dir(owner, attacker)
	var/turf/my_turf = get_turf(owner)
	if(my_turf && d)
		var/turf/back = get_step(my_turf, turn(d, 180))
		if(back && !back.density)
			MartialMasterAfterimage(my_turf, 0.8 SECONDS)
			owner.forceMove(back)

	ProcStrike(attacker, BODY_ZONE_CHEST, 1.40, 1.25)
	attacker.Knockdown(1 SECONDS)

/datum/component/combo_core/martial_master/proc/ToggleStance()
	if(current_stance == MARTIAL_MASTER_STANCE_PROC)
		SetStance(MARTIAL_MASTER_STANCE_PRECISE)
	else
		SetStance(MARTIAL_MASTER_STANCE_PROC)

/datum/component/combo_core/martial_master/proc/SetStance(new_stance)
	if(current_stance == new_stance)
		return

	current_stance = new_stance
	if(current_stance == MARTIAL_MASTER_STANCE_PROC)
		MartialMasterParticleUp("#6b1f2b")
	else
		MartialMasterParticleUp("#4a4f7a")

	_balloon_stance()

/datum/component/combo_core/martial_master/proc/_cb_combo(rule_id, mob/living/target, zone)
	if(!last_action_success)
		return FALSE
	if(!owner)
		return FALSE

	if(!target)
		target = last_action_target
	if(!zone)
		zone = last_action_zone

	var/success = FALSE

	if(current_stance == MARTIAL_MASTER_STANCE_PRECISE)
		success = ExecutePreciseCombo(rule_id, target, zone)
	else
		success = ExecuteProcCombo(rule_id, target, zone)

	if(success)
		_balloon_combo(rule_id)

	ConsumeOnCombo(rule_id)
	return success

/datum/component/combo_core/martial_master/proc/_balloon_combo(rule_id)
	switch(rule_id)
		if("line")
			_balloon("combo: line")
		if("cone")
			_balloon("combo: cone")
		if("charge")
			_balloon("combo: charge")
		if("spear")
			_balloon("combo: spear")
		if("push")
			_balloon("combo: push")
		if("spin")
			_balloon("combo: spin")
		if("swap")
			_balloon("combo: swap")
		if("chain_step")
			_balloon("combo: chain-step")
		if("silence")
			_balloon("combo: silence")
		if("cross")
			_balloon("combo: cross")
		if("reverse")
			_balloon("combo: reverse")
		else
			_balloon("combo!")

/datum/component/combo_core/martial_master/proc/ExecutePreciseCombo(rule_id, mob/living/target, zone)
	if(!owner || !target || !rule_id)
		return FALSE

	var/zone_used = TryGetZone(zone)
	var/mult = GetComboDamageMultiplier()

	if(ComboUsesKick(rule_id) && HasStrongKick())
		mult += MARTIAL_MASTER_STRONG_KICK_BONUS

	var/dmg = max(1, round(mult * GetComboBaseDamage(rule_id, TRUE)))
	target.adjustBruteLoss(dmg)
	ApplyPreciseFinisher(target, zone_used, last_action_skill, rule_id)

	return TRUE

/datum/component/combo_core/martial_master/proc/ExecuteProcCombo(rule_id, mob/living/target, zone)
	if(!owner || !rule_id)
		return FALSE

	switch(rule_id)
		if("line")
			return ProcComboLine(zone)

		if("cone")
			return ProcComboCone(zone)

		if("charge")
			return ProcComboCharge(zone)

		if("spear")
			return ProcComboSpear(zone)

		if("push")
			return ProcComboPush(zone)

		if("spin")
			return ProcComboSpin(zone)

		if("swap")
			return ProcComboSwap(zone)

		if("chain_step")
			return ProcComboChainStep()

		if("silence")
			return ProcComboSilence(zone)

		if("cross")
			return ProcComboCross(zone)

		if("reverse")
			return ProcComboReverse()

	return FALSE

/datum/component/combo_core/martial_master/proc/GetComboBaseDamage(rule_id, precise = FALSE)
	switch(rule_id)
		if("line")
			return precise ? 1.00 : 1.20
		if("cone")
			return precise ? 1.05 : 1.15
		if("charge")
			return precise ? 1.10 : 1.35
		if("spear")
			return precise ? 1.00 : 1.10
		if("push")
			return precise ? 0.95 : 1.05
		if("spin")
			return precise ? 1.00 : 1.10
		if("swap")
			return precise ? 1.00 : 1.10
		if("chain_step")
			return precise ? 1.05 : 1.15
		if("silence")
			return precise ? 0.90 : 1.00
		if("cross")
			return precise ? 1.00 : 1.10
		if("reverse")
			return precise ? 0.95 : 1.00

	return precise ? 1.0 : 1.2

// ------------------------------------------------------------
// proc stance forms
// ------------------------------------------------------------

/datum/component/combo_core/martial_master/proc/CalcPureDamage()
	if(!owner)
		return 0

	var/mob/living/carbon/human/H = owner
	var/used_str = H.get_stat(STATKEY_STR)
	if(H.domhand)
		var/hand = H.active_hand_index
		used_str = H.get_str_arms(hand)

	var/damage
	if(H.get_stat(STATKEY_STR) > UNARMED_DAMAGE_DEFAULT || H.get_stat(STATKEY_STR) < 10)
		damage = H.get_stat(STATKEY_STR)
	else
		damage = UNARMED_DAMAGE_DEFAULT

	if(used_str >= 11)
		damage = max(damage + (damage * ((used_str - 10) * 0.33)), 1)

	if(used_str <= 9)
		damage = max(damage - (damage * ((10 - used_str) * 0.1)), 1)

	var/obj/G = H.get_item_by_slot(SLOT_GLOVES)
	if(istype(G, /obj/item/clothing/gloves/roguetown))
		var/obj/item/clothing/gloves/roguetown/GL = G
		damage = (damage + GL.unarmed_bonus)

	if(H.dna?.species)
		damage += H.dna.species.punch_damage

	return max(1, round(damage))

/datum/component/combo_core/martial_master/proc/ProcStrike(mob/living/target, zone, damage_mult = 1.0, armor_mult = 1.0)
	if(!owner || !target)
		return FALSE

	var/zone_used = TryGetZone(zone)
	var/pure_damage = CalcPureDamage()
	var/dmg_mult = GetComboDamageMultiplier() * damage_mult

	if((last_action_skill == MARTIAL_MASTER_INPUT_KICK || ComboUsesKick(last_matched_rule)) && HasStrongKick())
		dmg_mult += MARTIAL_MASTER_STRONG_KICK_BONUS

	var/dmg = max(1, round(dmg_mult * pure_damage))

	owner.face_atom(target)
	owner.do_attack_animation(target, ATTACK_EFFECT_DISARM)

	target.adjustBruteLoss(dmg)
	ApplyArmorDamageToZone(target, zone_used, max(1, round(GetPressureDamage() * armor_mult)))

	if(last_action_skill == MARTIAL_MASTER_INPUT_KICK && HasStrongKick())
		_try_strong_kick_throw(target)

	return TRUE

/datum/component/combo_core/martial_master/proc/ProcComboLine(zone)
	if(!owner)
		return FALSE

	var/turf/T = get_turf(owner)
	if(!T)
		return FALSE

	var/d = owner.dir
	var/any = FALSE
	for(var/i in 1 to MARTIAL_MASTER_LINE_RANGE)
		T = get_step(T, d)
		if(!T)
			break

		MartialMasterTileFX(T, "sweep_fx")
		for(var/mob/living/L in T)
			if(L == owner || L.stat == DEAD)
				continue
			if(ProcStrike(L, zone, 1.35, 1.0))
				any = TRUE
			break

	return any

/datum/component/combo_core/martial_master/proc/ProcComboCone(zone)
	if(!owner)
		return FALSE

	var/list/turfs = GetProcConeTurfs(owner.dir, MARTIAL_MASTER_CONE_RANGE)
	var/any = FALSE

	for(var/turf/T as anything in turfs)
		if(!T)
			continue

		MartialMasterTileFX(T, "blip")
		for(var/mob/living/L in T)
			if(L == owner || L.stat == DEAD)
				continue
			if(ProcStrike(L, zone, 1.15, 0.8))
				any = TRUE
			break

	return any

/datum/component/combo_core/martial_master/proc/GetProcConeTurfs(dir, range = 2)
	var/list/result = list()
	var/turf/origin = get_turf(owner)
	if(!origin)
		return result

	var/turf/front = get_step(origin, dir)
	if(front)
		result += front

	if(range >= 2 && front)
		var/turf/front2 = get_step(front, dir)
		if(front2)
			result += front2

		var/left_dir = turn(dir, 45)
		var/right_dir = turn(dir, -45)

		var/turf/left = get_step(front, left_dir)
		var/turf/right = get_step(front, right_dir)

		if(left)
			result += left
		if(right)
			result += right

	return result

/datum/component/combo_core/martial_master/proc/ProcComboSpin(zone)
	if(!owner)
		return FALSE

	var/list/dirs = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
	var/turf/origin = get_turf(owner)
	if(!origin)
		return FALSE

	var/delay = 0
	for(var/d in dirs)
		var/turf/T = get_step(origin, d)
		if(!T)
			continue

		addtimer(CALLBACK(src, PROC_REF(_spin_hit_turf), T, zone), delay)
		delay += 1

	return TRUE

/datum/component/combo_core/martial_master/proc/_spin_hit_turf(turf/T, zone)
	if(!owner || !T)
		return

	MartialMasterTileFX(T, "sweep_fx")
	for(var/mob/living/L in T)
		if(L == owner || L.stat == DEAD)
			continue
		ProcStrike(L, zone, 1.10, 0.8)
		break

/datum/component/combo_core/martial_master/proc/ProcComboCharge(zone)
	if(!owner)
		return FALSE

	var/mob/living/target = FindFrontTarget(MARTIAL_MASTER_CHARGE_RANGE)
	if(!target)
		return FALSE

	var/turf/origin = get_turf(owner)
	var/turf/tt = get_turf(target)
	if(!tt)
		return FALSE

	var/d = get_dir(owner, target)
	if(!d)
		d = owner.dir

	var/turf/before_target = get_step(tt, turn(d, 180))
	if(before_target && !before_target.density)
		MartialMasterAfterimage(origin, 0.8 SECONDS)
		owner.forceMove(before_target)

	return ProcStrike(target, zone, 1.45, 1.2)

/// PKP - spear
/datum/component/combo_core/martial_master/proc/ProcComboSpear(zone)
	if(!owner)
		return FALSE

	var/turf/origin = get_turf(owner)
	if(!origin)
		return FALSE

	var/any = FALSE
	var/dir_forward = owner.dir
	var/dir_back = turn(owner.dir, 180)

	var/turf/front = get_step(origin, dir_forward)
	var/turf/back = get_step(origin, dir_back)

	for(var/turf/T as anything in list(front, back))
		if(!T)
			continue

		MartialMasterTileFX(T, "sweep_fx")
		for(var/mob/living/L in T)
			if(L == owner || L.stat == DEAD)
				continue

			var/hit_dir = get_dir(owner, L)
			if(ProcStrike(L, zone, 1.10, 1.0))
				_throw_target_dir(L, hit_dir, 1, TRUE)
				any = TRUE
			break

	return any

/// PKK - push
/datum/component/combo_core/martial_master/proc/ProcComboPush(zone)
	if(!owner)
		return FALSE

	var/mob/living/target = last_action_target
	if(!target || target.stat == DEAD)
		target = FindNearbyTarget(1)
	if(!target)
		return FALSE

	if(!ProcStrike(target, zone, 1.00, 0.9))
		return FALSE

	var/push_dist = 3
	if(HasStrongKick())
		push_dist++

	_throw_target_dir(target, get_dir(owner, target), push_dist, TRUE)
	return TRUE

/// KKP - swap
/datum/component/combo_core/martial_master/proc/ProcComboSwap(zone)
	if(!owner)
		return FALSE

	var/mob/living/target = last_action_target
	if(!target || target.stat == DEAD)
		target = FindNearbyTarget(1)
	if(!target)
		return FALSE

	var/turf/my_turf = get_turf(owner)
	var/turf/target_turf = get_turf(target)
	if(!my_turf || !target_turf)
		return FALSE

	MartialMasterAfterimage(my_turf, 0.6 SECONDS)
	target.forceMove(my_turf)
	owner.forceMove(target_turf)
	owner.face_atom(target)

	return ProcStrike(target, zone, 1.10, 1.0)

/// KPK - silence
/datum/component/combo_core/martial_master/proc/ProcComboSilence(zone)
	if(!owner)
		return FALSE

	var/mob/living/target = last_action_target
	if(!target || target.stat == DEAD)
		target = FindNearbyTarget(1)
	if(!target)
		return FALSE

	if(!ProcStrike(target, zone, 1.00, 1.0))
		return FALSE

	target.apply_status_effect(/datum/status_effect/silenced, 4 SECONDS)
	return TRUE

/// KPP - cross
/datum/component/combo_core/martial_master/proc/ProcComboCross(zone)
	if(!owner)
		return FALSE

	var/turf/origin = get_turf(owner)
	if(!origin)
		return FALSE

	var/d = owner.dir
	var/turf/front = get_step(origin, d)
	if(front)
		MartialMasterTileFX(front, "sweep_fx")
		for(var/mob/living/L in front)
			if(L == owner || L.stat == DEAD)
				continue
			ProcStrike(L, zone, 1.00, 1.0)
			break

	addtimer(CALLBACK(src, PROC_REF(_cross_followup), d, zone), 0.25 SECONDS)
	return TRUE

/datum/component/combo_core/martial_master/proc/_cross_followup(d, zone)
	if(!owner)
		return

	var/turf/origin = get_turf(owner)
	if(!origin)
		return

	var/turf/front = get_step(origin, d)
	if(!front)
		return

	var/turf/left = get_step(front, turn(d, 45))
	var/turf/right = get_step(front, turn(d, -45))

	for(var/turf/T as anything in list(left, right))
		if(!T)
			continue

		MartialMasterTileFX(T, "blip")
		for(var/mob/living/L in T)
			if(L == owner || L.stat == DEAD)
				continue
			ProcStrike(L, zone, 0.90, 0.8)
			break

/datum/component/combo_core/martial_master/proc/FindFrontTarget(max_range = 8)
	if(!owner)
		return null

	var/turf/T = get_turf(owner)
	if(!T)
		return null

	var/d = owner.dir
	for(var/i in 1 to max_range)
		T = get_step(T, d)
		if(!T)
			break

		for(var/mob/living/L in T)
			if(L == owner || L.stat == DEAD)
				continue
			return L

	return null

/datum/component/combo_core/martial_master/proc/ProcComboChainStep()
	if(!owner)
		return FALSE

	var/mob/living/target = FindNearbyTarget(MARTIAL_MASTER_CHAIN_STEP_RANGE, last_action_target)
	if(!target)
		return FALSE

	var/turf/origin = get_turf(owner)
	var/turf/tt = get_turf(target)
	if(!tt)
		return FALSE

	var/d = get_dir(owner, target)
	if(!d)
		d = owner.dir

	var/turf/behind = get_step(tt, d)
	if(behind && !behind.density)
		MartialMasterAfterimage(origin, 0.8 SECONDS)
		owner.forceMove(behind)

	owner.face_atom(target)

	chain_step_ready = TRUE
	chain_step_expires_at = world.time + MARTIAL_MASTER_CHAIN_STEP_WINDOW
	chain_step_target = target

	return TRUE

/datum/component/combo_core/martial_master/proc/FindNearbyTarget(max_range = 3, mob/living/preferred = null)
	if(preferred && get_dist(owner, preferred) <= max_range && preferred.stat != DEAD)
		return preferred

	for(var/mob/living/L in view(max_range, owner))
		if(L == owner || L.stat == DEAD)
			continue
		return L

	return null

/// GGG - reverse
/datum/component/combo_core/martial_master/proc/ProcComboReverse()
	if(!owner)
		return FALSE

	reverse_ready = TRUE
	reverse_expires_at = world.time + MARTIAL_MASTER_REVERSE_WINDOW

	MartialMasterWaveUp("#5a0f1f")
	return TRUE

// ------------------------------------------------------------
// proc pressure
// ------------------------------------------------------------

/datum/component/combo_core/martial_master/proc/GetPressureChance()
	var/chance = 25
	if(HasStrongKick())
		chance += 10
	return clamp(chance, 0, 100)

/datum/component/combo_core/martial_master/proc/GetPressureDamage()
	if(!owner)
		return 1

	var/amount = max(1, round(owner.get_stat(STAT_STRENGTH) / 2))
	if(HasStrongKick() && last_action_skill == MARTIAL_MASTER_INPUT_KICK)
		amount += 1
	return amount

/datum/component/combo_core/martial_master/proc/ApplyArmorDamageToZone(mob/living/target, zone, amount)
	if(!ishuman(target))
		return

	var/mob/living/carbon/human/H = target
	var/cover_flag

	switch(zone)
		if(BODY_ZONE_HEAD)
			cover_flag = HEAD
		if(BODY_ZONE_CHEST)
			cover_flag = CHEST
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			cover_flag = ARMS
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			cover_flag = LEGS
		else
			cover_flag = CHEST

	for(var/obj/item/clothing/C in H.contents)
		if(C.loc != H)
			continue
		if(!(C.body_parts_covered & cover_flag))
			continue
		if(!C.armor)
			continue

		C.take_damage(amount, BRUTE, "slash")
		break

/datum/component/combo_core/martial_master/proc/ApplyProcPressureOnHit(mob/living/target, zone, guaranteed = FALSE)
	if(!owner || !target)
		return FALSE

	var/chance = guaranteed ? 100 : GetPressureChance()
	if(!prob(chance))
		return FALSE

	ApplyArmorDamageToZone(target, zone, GetPressureDamage())
	return TRUE

// ------------------------------------------------------------
// precise stance
// ------------------------------------------------------------

/datum/component/combo_core/martial_master/proc/GetPreciseStaminaDamage()
	if(!owner)
		return 1

	var/amount = max(1, round(owner.get_stat(STAT_STRENGTH) / 2))
	if(HasStrongKick() && last_action_skill == MARTIAL_MASTER_INPUT_KICK)
		amount += 1
	return amount

/datum/component/combo_core/martial_master/proc/ApplyPreciseOnHit(mob/living/target, zone)
	if(!owner || !target)
		return

	var/zone_used = TryGetZone(zone)

	if(IsMouthZone(zone_used))
		if(prob(40))
			target.apply_status_effect(/datum/status_effect/silenced, 3 SECONDS)
		return

	switch(zone_used)
		if(BODY_ZONE_HEAD)
			if(prob(25))
				target.Dizzy(1 SECONDS)

		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			if(prob(25))
				SafeSlow(target, HasStrongKick() ? 1.5 : 1)

		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			if(prob(25))
				if(ishuman(target))
					var/mob/living/carbon/human/H = target
					H.drop_all_held_items()
				else
					target.Immobilize(0.5 SECONDS)

		if(BODY_ZONE_CHEST)
			if(prob(25))
				target.stamina_add(GetPreciseStaminaDamage())

/datum/component/combo_core/martial_master/proc/ApplyPreciseFinisher(mob/living/target, zone, finisher_skill, rule_id)
	if(!target)
		return

	var/zone_used = TryGetZone(zone)

	if(IsMouthZone(zone_used))
		if(prob(80))
			target.apply_status_effect(/datum/status_effect/silenced, 5 SECONDS)
		return

	switch(zone_used)
		if(BODY_ZONE_HEAD)
			if(finisher_skill == MARTIAL_MASTER_INPUT_PUNCH)
				target.Stun(1.5 SECONDS)
			else
				target.Dizzy(1 SECONDS)

		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				H.drop_all_held_items()

			if(finisher_skill == MARTIAL_MASTER_INPUT_GRAB)
				target.Immobilize(1.5 SECONDS)
			else
				target.Immobilize(0.75 SECONDS)

		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			if(finisher_skill == MARTIAL_MASTER_INPUT_KICK)
				SafeOffbalance(target, HasStrongKick() ? 2.5 SECONDS : 2 SECONDS)
			else
				SafeSlow(target, HasStrongKick() ? 2 : 1.5)

		if(BODY_ZONE_CHEST)
			target.stamina_add(round(target.max_stamina * 0.12))
			if(finisher_skill == MARTIAL_MASTER_INPUT_GRAB)
				target.Knockdown(1.5 SECONDS)

// ------------------------------------------------------------
// kick helpers
// ------------------------------------------------------------

/datum/component/combo_core/martial_master/proc/GetKickOffbalanceDuration(base_duration = 3 SECONDS)
	if(HasStrongKick())
		return max(MARTIAL_MASTER_KICK_MIN_RECOVERY, round(base_duration * 0.7))
	return base_duration

/datum/component/combo_core/martial_master/proc/HasStrongKick()
	if(!owner)
		return FALSE
	return HAS_TRAIT(owner, TRAIT_STRONGKICK)

/// kept small and only for direct kick hits
/datum/component/combo_core/martial_master/proc/_try_strong_kick_throw(mob/living/target)
	if(!target || !HasStrongKick())
		return FALSE
	if(prob(30))
		_throw_target_dir(target, get_dir(owner, target), MARTIAL_MASTER_STRONG_KICK_THROW, TRUE)
		return TRUE
	return FALSE

/datum/component/combo_core/martial_master/proc/ComboUsesKick(rule_id)
	switch(rule_id)
		if("cone", "spear", "push", "spin", "swap", "chain_step", "silence", "cross")
			return TRUE
	return FALSE

/datum/component/combo_core/martial_master/proc/_throw_target_dir(mob/living/target, d, distance = 1, spin = TRUE)
	if(!target || !d)
		return FALSE

	var/turf/throw_target = target.loc
	for(var/i = 1 to distance)
		var/turf/next = get_step(throw_target, d)
		if(!next)
			break
		throw_target = next

	target.safe_throw_at(throw_target, distance, 1, owner, spin = spin)
	return TRUE

// ------------------------------------------------------------
// arousal / resources
// ------------------------------------------------------------

/datum/component/combo_core/martial_master/proc/AddArousalStack(amount = 1)
	if(amount <= 0)
		return

	arousal_stacks = clamp(arousal_stacks + amount, 0, max_arousal_stacks)

/datum/component/combo_core/martial_master/proc/SpendArousalStack(amount = 1)
	if(amount <= 0)
		return
	if(arousal_stacks <= 0)
		return

	arousal_stacks = clamp(arousal_stacks - amount, 0, max_arousal_stacks)

/datum/component/combo_core/martial_master/proc/GetComboDamageMultiplier()
	var/mult = 1
	mult += (arousal_stacks * MARTIAL_MASTER_AROUSAL_DMG_PER_STACK)
	return max(1, mult)

// ------------------------------------------------------------
// utils
// ------------------------------------------------------------

/datum/component/combo_core/martial_master/proc/ResolveAttackInput(atom/target_atom, obj/item/W)
	if(!owner)
		return 0

	if(W)
		return 0

	if(owner.used_intent)
		var/intent_name = lowertext("[owner.used_intent.name]")
		var/intent_type = lowertext("[owner.used_intent.type]")

		if(findtext(intent_name, "grab") || findtext(intent_type, "grab"))
			return MARTIAL_MASTER_INPUT_GRAB

		if(findtext(intent_name, "kick") || findtext(intent_type, "kick"))
			return MARTIAL_MASTER_INPUT_KICK

	return MARTIAL_MASTER_INPUT_PUNCH

/datum/component/combo_core/martial_master/proc/IsBaseInput(skill_id)
	return (skill_id == MARTIAL_MASTER_INPUT_PUNCH || skill_id == MARTIAL_MASTER_INPUT_KICK || skill_id == MARTIAL_MASTER_INPUT_GRAB)

/// helper to preserve nutcracker flavor
/proc/datum_component_combo_martial_master_check_nutcracker(datum/component/combo_core/martial_master/C, mob/living/target, zone_precise, skill_id)
	if(!C || !target)
		return FALSE
	if(C.current_stance != MARTIAL_MASTER_STANCE_PROC)
		return FALSE
	if(zone_precise != BODY_ZONE_PRECISE_GROIN)
		return FALSE

	var/chance = C.arousal_stacks * 5

	switch(C.last_matched_rule)
		if("reverse", "chain_step")
			chance += 20
		if("charge", "spin", "push")
			chance += 40

	if(C.HasStrongKick() && skill_id == MARTIAL_MASTER_INPUT_KICK)
		chance += 15

	var/obj/item/bodypart/chest/CH = target.get_bodypart(BODY_ZONE_CHEST)
	if(!CH)
		return FALSE

	if(prob(chance))
		CH.add_wound(/datum/wound/cbt)
		target.emote("groin", TRUE)
		target.Stun(20)
		return TRUE

	return FALSE

/datum/component/combo_core/martial_master/proc/IsMouthZone(zone)
	var/zone_text = lowertext("[zone]")
	return (findtext(zone_text, "mouth") || findtext(zone_text, "face_mouth") || findtext(zone_text, "precise_mouth"))

/datum/component/combo_core/martial_master/proc/_balloon(message)
	if(!owner?.client)
		return
	if(world.time < last_balloon_at + MARTIAL_MASTER_BALLOON_COOLDOWN)
		return

	last_balloon_at = world.time
	owner.balloon_alert(owner, message)

/datum/component/combo_core/martial_master/proc/_balloon_stance()
	if(current_stance == MARTIAL_MASTER_STANCE_PROC)
		_balloon("stance: proc")
	else
		_balloon("stance: precise")

/datum/component/combo_core/martial_master/proc/MartialMasterTileFX(turf/T, icon_state = "sweep_fx")
	if(!T)
		return

	var/obj/effect/temp_visual/fx = new(T)
	fx.icon = 'icons/effects/effects.dmi'
	fx.icon_state = icon_state

/datum/component/combo_core/martial_master/proc/MartialMasterAfterimage(turf/T, duration = 0.8 SECONDS)
	if(!owner || !T)
		return

	var/mutable_appearance/ma = mutable_appearance(owner)
	ma.alpha = 140
	ma.layer = owner.layer - 0.01
	ma.appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | RESET_COLOR | RESET_ALPHA

	var/obj/effect/temp_visual/dir_setting/martial_master_afterimage/A = new(T)
	A.appearance = ma
	A.dir = owner.dir
	QDEL_IN(A, duration)

/obj/effect/temp_visual/dir_setting/martial_master_afterimage
	name = "afterimage"
	icon = null
	icon_state = null
	duration = 10
	randomdir = FALSE

/datum/component/combo_core/martial_master/proc/MartialMasterWaveUp(color = "#6b1f2b")
	if(!owner)
		return

	var/obj/effect/temp_visual/wave_up/W = new(get_turf(owner), owner)
	W.color = color
	owner.vis_contents += W

/datum/component/combo_core/martial_master/proc/MartialMasterParticleUp(color = null)
	if(!owner)
		return

	var/obj/effect/temp_visual/particle_up/P = new(get_turf(owner), owner, null)
	if(color)
		P.color = color
	owner.vis_contents += P

// ------------------------------------------------------------
// spells
// ------------------------------------------------------------

/obj/effect/proc_holder/spell/self/martial_master
	name = "Martial Master Ability"
	desc = "Base martial master ability."
	clothes_req = FALSE
	charge_type = "recharge"
	cost = 0
	xp_gain = FALSE

	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 6 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1

	invocations = list()
	invocation_type = "none"
	hide_charge_effect = TRUE
	charging_slowdown = 0
	chargedloop = null
	overlay_state = null

	action_icon = 'modular_twilight_axis/icons/roguetown/misc/soundspells.dmi'

/obj/effect/proc_holder/spell/self/martial_master/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.incapacitated())
		return

	var/datum/component/combo_core/martial_master/C = martial_master_get_component_safe(L)
	if(!C)
		return

	Execute(L, C)

/obj/effect/proc_holder/spell/self/martial_master/proc/Execute(mob/living/user, datum/component/combo_core/martial_master/C)
	return

/obj/effect/proc_holder/spell/self/martial_master/switch_stance
	name = "Switch Stance"
	desc = "Switch between proc stance and precise stance."
	overlay_state = "switch_stance"
	recharge_time = 4 SECONDS

/obj/effect/proc_holder/spell/self/martial_master/switch_stance/Execute(mob/living/user, datum/component/combo_core/martial_master/C)
	if(!user || !C)
		return

	C.ToggleStance()

#undef MARTIAL_MASTER_COMBO_WINDOW
#undef MARTIAL_MASTER_MAX_HISTORY
#undef MARTIAL_MASTER_MAX_AROUSAL_STACKS
#undef MARTIAL_MASTER_AROUSAL_DMG_PER_STACK
#undef MARTIAL_MASTER_KICK_MIN_RECOVERY
#undef MARTIAL_MASTER_INPUT_PUNCH
#undef MARTIAL_MASTER_INPUT_KICK
#undef MARTIAL_MASTER_INPUT_GRAB
#undef MARTIAL_MASTER_STANCE_PROC
#undef MARTIAL_MASTER_STANCE_PRECISE
#undef MARTIAL_MASTER_BUTTON_SWITCH_STANCE

#undef MARTIAL_MASTER_REVERSE_WINDOW
#undef MARTIAL_MASTER_CHAIN_STEP_WINDOW
#undef MARTIAL_MASTER_CHARGE_RANGE
#undef MARTIAL_MASTER_CHAIN_STEP_RANGE
#undef MARTIAL_MASTER_LINE_RANGE
#undef MARTIAL_MASTER_CONE_RANGE
#undef MARTIAL_MASTER_BALLOON_COOLDOWN
#undef MARTIAL_MASTER_STRONG_KICK_THROW
#undef MARTIAL_MASTER_STRONG_KICK_BONUS

// ============================================================
// TEMPTRESS
// Martial master inheritor with ERP/training hooks.
// ============================================================

#define TEMPTRESS_EMBRACE_TRAIT_SOURCE    "temptress_embrace"
#define TEMPTRESS_EMBRACE_PULSE_CD        (1 SECONDS)
#define TEMPTRESS_EMBRACE_GAIN_CD         (3 SECONDS)
#define TEMPTRESS_EMBRACE_RANGE           2

/proc/temptress_get_component(mob/living/user)
	if(!isliving(user))
		return null

	var/datum/component/combo_core/temptress/C = user.GetComponent(/datum/component/combo_core/temptress)
	if(!C)
		C = user.AddComponent(/datum/component/combo_core/temptress)
	return C

/proc/temptress_get_component_safe(mob/living/user)
	if(!isliving(user))
		return null

	return user.GetComponent(/datum/component/combo_core/temptress)

GLOBAL_LIST_INIT(temptress_erp_training_map, list(
	/datum/skill/labor/farming = list("action" = /datum/erp_action/other/hands/milking_breasts, "passive" = "temptress"),
	/datum/skill/labor/mining = list("action" = /datum/erp_action/other/mouth/rimming, "passive" = "temptress"),
	/datum/skill/labor/fishing = list("action" = /datum/erp_action/other/hands/finger_oral, "passive" = "temptress"),
	/datum/skill/labor/butchering = list("action" = /datum/erp_action/other/body/grinding, "passive" = "temptress"),
	/datum/skill/labor/lumberjacking = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "temptress"),

	/datum/skill/magic/holy = list("action" = /datum/erp_action/other/mouth/cunnilingus, "passive" = "temptress"),
	/datum/skill/magic/arcane = list("action" = /datum/erp_action/other/mouth/breast_feed, "passive" = "temptress"),

	/datum/skill/misc/climbing = list("action" = /datum/erp_action/other/body/rubbing, "passive" = "actor"),
	/datum/skill/misc/reading = list("action" = /datum/erp_action/other/vagina/force_face, "passive" = "actor"),
	/datum/skill/misc/stealing = list("action" = /datum/erp_action/other/vagina/face, "passive" = "actor"),
	/datum/skill/misc/sneaking = list("action" = /datum/erp_action/other/hands/force_crotch, "passive" = "actor"),
	/datum/skill/misc/lockpicking = list("action" = /datum/erp_action/other/hands/tease_vagina, "passive" = "temptress"),
	/datum/skill/misc/riding = list("action" = /datum/erp_action/other/anus/force_face, "passive" = "temptress"),
	/datum/skill/misc/medicine = list("action" = /datum/erp_action/other/mouth/finger_lick, "passive" = "actor"),
	/datum/skill/misc/tracking = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "temptress"),

	/datum/skill/craft/crafting = list("action" = /datum/erp_action/other/breasts/breast_feed, "passive" = "actor"),
	/datum/skill/craft/weaponsmithing = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "actor"),
	/datum/skill/craft/armorsmithing = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "actor"),
	/datum/skill/craft/blacksmithing = list("action" = /datum/erp_action/other/anus/butt, "passive" = "temptress"),
	/datum/skill/craft/smelting = list("action" = /datum/erp_action/other/penis/rubbing, "passive" = "actor"),
	/datum/skill/craft/carpentry = list("action" = /datum/erp_action/other/vagina/rubbing, "passive" = "actor"),
	/datum/skill/craft/masonry = list("action" = /datum/erp_action/other/anus/rubbing, "passive" = "actor"),
	/datum/skill/craft/traps = list("action" = /datum/erp_action/other/anus/face, "passive" = "actor"),
	/datum/skill/craft/engineering = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "temptress"),
	/datum/skill/craft/cooking = list("action" = /datum/erp_action/other/mouth/kiss, "passive" = "temptress"),
	/datum/skill/craft/sewing = list("action" = /datum/erp_action/other/hands/rubbing, "passive" = "temptress"),
	/datum/skill/craft/tanning = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "actor"),
	/datum/skill/craft/ceramics = list("action" = /datum/erp_action/other/hands/breasts_play, "passive" = "temptress"),
	/datum/skill/craft/alchemy = list("action" = /datum/erp_action/other/hands/milking_penis, "passive" = "temptress"),

	/datum/skill/combat/knives = list("action" = /datum/erp_action/other/penis/masturbation, "passive" = "actor"),
	/datum/skill/combat/swords = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "temptress"),
	/datum/skill/combat/polearms = list("action" = /datum/erp_action/other/hands/toy_vaginal, "passive" = "temptress"),
	/datum/skill/combat/maces = list("action" = /datum/erp_action/other/legs/footjob, "passive" = "temptress"),
	/datum/skill/combat/axes = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "temptress"),
	/datum/skill/combat/whipsflails = list("action" = /datum/erp_action/other/hands/tease_testicles, "passive" = "temptress"),
	/datum/skill/combat/wrestling = list("action" = /datum/erp_action/other/hands/finger_anal, "passive" = "temptress"),
	/datum/skill/combat/unarmed = list("action" = /datum/erp_action/other/hands/finger_vaginal, "passive" = "temptress"),
	/datum/skill/combat/shields = list("action" = /datum/erp_action/other/breasts/teasing, "passive" = "actor"),
	/datum/skill/combat/staves = list("action" = /datum/erp_action/other/legs/teasing, "passive" = "actor")
))

GLOBAL_LIST_INIT(temptress_combat_skills, list(
	/datum/skill/combat/knives,
	/datum/skill/combat/swords,
	/datum/skill/combat/polearms,
	/datum/skill/combat/maces,
	/datum/skill/combat/axes,
	/datum/skill/combat/whipsflails,
	/datum/skill/combat/wrestling,
	/datum/skill/combat/unarmed,
	/datum/skill/combat/shields,
	/datum/skill/combat/staves
))

/proc/temptress_erp_get_training_entry(datum/erp_action/A, expected_passive)
	if(!A || !expected_passive)
		return null

	var/action_type = A.type

	for(var/skill_type as anything in GLOB.temptress_erp_training_map)
		var/list/entry = GLOB.temptress_erp_training_map[skill_type]
		if(!islist(entry))
			continue

		if(entry["action"] != action_type)
			continue

		if(entry["passive"] != expected_passive)
			continue

		return list("skill" = skill_type, "passive" = entry["passive"])

	return null

/datum/erp_scene_effects/proc/apply_training(list/active_links)
	if(!controller)
		return

	var/list/temptresses = list()

	var/datum/component/combo_core/temptress/TC = controller.owner?.physical?.GetComponent(/datum/component/combo_core/temptress)
	if(TC && TC.erotic_embrace_enabled && TC.owner)
		temptresses += TC.owner

	TC = controller.active_partner?.physical?.GetComponent(/datum/component/combo_core/temptress)
	if(TC && TC.erotic_embrace_enabled && TC.owner)
		if(!(TC.owner in temptresses))
			temptresses += TC.owner

	if(!length(temptresses))
		return

	for(var/mob/living/temptress_mob as anything in temptresses)
		if(!temptress_mob)
			continue

		for(var/datum/erp_sex_link/L in active_links)
			if(!L || QDELETED(L) || !L.is_valid())
				continue

			var/datum/erp_actor/active = L.actor_active
			var/datum/erp_actor/passive = L.actor_passive
			if(!active || !passive)
				continue

			var/mob/living/m_active = active.get_effect_mob()
			var/mob/living/m_passive = passive.get_effect_mob()
			if(!m_active || !m_passive)
				continue

			var/expected_passive = null
			var/mob/living/receiver = null

			if(m_active == temptress_mob)
				expected_passive = "actor"
				receiver = m_passive
			else if(m_passive == temptress_mob)
				expected_passive = "temptress"
				receiver = m_active
			else
				continue

			if(!receiver?.mind)
				continue

			var/list/entry = temptress_erp_get_training_entry(L.action, expected_passive)
			if(!entry)
				continue

			var/skill_type = entry["skill"]
			if(!skill_type)
				continue

			if(skill_type in GLOB.temptress_combat_skills)
				if(L.force < SEX_FORCE_HIGH)
					continue

			receiver.mind.add_sleep_experience(skill_type, 2, FALSE)

/datum/component/combo_core/temptress
	parent_type = /datum/component/combo_core/martial_master
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/erotic_embrace_enabled = FALSE
	var/temptress_awakened = FALSE

	var/last_embrace_pulse = 0
	var/last_embrace_gain = 0

/datum/component/combo_core/temptress/Initialize(_combo_window, _max_history)
	. = ..(_combo_window, _max_history)
	if(. == COMPONENT_INCOMPATIBLE)
		return .

	RegisterSignal(owner, COMSIG_PARENT_EXAMINE, PROC_REF(_sig_examined))
	return .

/datum/component/combo_core/temptress/Destroy(force)
	if(owner)
		UnregisterSignal(owner, COMSIG_PARENT_EXAMINE)
		REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, TEMPTRESS_EMBRACE_TRAIT_SOURCE)

	return ..()

/datum/component/combo_core/temptress/process()
	. = ..()

	if(!owner || !erotic_embrace_enabled)
		return

	if(world.time < last_embrace_pulse + TEMPTRESS_EMBRACE_PULSE_CD)
		return

	last_embrace_pulse = world.time

	var/list/targets = list()

	for(var/mob/living/M in view(TEMPTRESS_EMBRACE_RANGE, owner))
		if(M == owner)
			continue
		if(M.stat == DEAD)
			continue
		targets += M

	if(!length(targets))
		return

	if(world.time >= last_embrace_gain + TEMPTRESS_EMBRACE_GAIN_CD)
		for(var/mob/living/M as anything in targets)
			AddArousalStack(1)
			SEND_SIGNAL(M, COMSIG_SEX_RECEIVE_ACTION, 2, 0, TRUE, 1, 1, null)

		last_embrace_gain = world.time
	else
		for(var/mob/living/M as anything in targets)
			SEND_SIGNAL(M, COMSIG_SEX_RECEIVE_ACTION, 1, 0, TRUE, 1, 1, null)

/datum/component/combo_core/temptress/GetComboDamageMultiplier()
	var/mult = 1
	mult += (arousal_stacks * 0.10)
	return max(1, mult)

/datum/component/combo_core/temptress/GrantSpells()
	if(!owner?.mind)
		return

	var/mob/living/L = owner
	RevokeSpells()

	var/list/paths = list(
		/obj/effect/proc_holder/spell/self/martial_master/switch_stance
	)

	if(!temptress_awakened)
		paths += /obj/effect/proc_holder/spell/self/temptress_awaken
	else
		paths += /obj/effect/proc_holder/spell/self/temptress/erotic_embrace
		paths += /obj/effect/proc_holder/spell/invoked/massage
		paths += /datum/action/cooldown/spell/mirror_transform

	for(var/path in paths)
		var/obj/effect/proc_holder/spell/S = new path
		L.mind.AddSpell(S)
		granted_spells += S

	spells_granted = TRUE

/datum/component/combo_core/temptress/proc/UnlockTemptressArts()
	if(temptress_awakened)
		return

	temptress_awakened = TRUE
	GrantSpells()
	MartialMasterWaveUp("#6b2240")
	_balloon("awakened")

/datum/component/combo_core/temptress/proc/ToggleEroticEmbrace()
	erotic_embrace_enabled = !erotic_embrace_enabled

	if(erotic_embrace_enabled)
		ADD_TRAIT(owner, TRAIT_DODGEEXPERT, TEMPTRESS_EMBRACE_TRAIT_SOURCE)
		MartialMasterWaveUp("#6b2240")
	else
		REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, TEMPTRESS_EMBRACE_TRAIT_SOURCE)
		MartialMasterParticleUp("#6b2240")

	_balloon_embrace()

/datum/component/combo_core/temptress/proc/_sig_examined(datum/source, mob/living/user)
	SIGNAL_HANDLER

	if(!erotic_embrace_enabled)
		return 0
	if(!isliving(user))
		return 0
	if(user == owner)
		return 0
	if(world.time < last_embrace_gain + TEMPTRESS_EMBRACE_GAIN_CD)
		return 0

	SEND_SIGNAL(user, COMSIG_SEX_RECEIVE_ACTION, 6, 0, TRUE, 2, 2, null)
	AddArousalStack(1)
	last_embrace_gain = world.time
	return 0

/datum/component/combo_core/temptress/proc/_balloon_embrace()
	if(erotic_embrace_enabled)
		_balloon("embrace: on")
	else
		_balloon("embrace: off")

// ------------------------------------------------------------
// spells
// ------------------------------------------------------------

/obj/effect/proc_holder/spell/self/temptress
	name = "Temptress Ability"
	desc = "Base temptress ability."
	clothes_req = FALSE
	charge_type = "recharge"
	cost = 0
	xp_gain = FALSE

	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 6 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1

	invocations = list()
	invocation_type = "none"
	hide_charge_effect = TRUE
	charging_slowdown = 0
	chargedloop = null
	overlay_state = null

	action_icon = 'modular_twilight_axis/icons/roguetown/misc/soundspells.dmi'

/obj/effect/proc_holder/spell/self/temptress/proc/Execute(mob/living/user, datum/component/combo_core/temptress/C)
	return

/obj/effect/proc_holder/spell/self/temptress_awaken
	name = "Temptress Awakening"
	desc = "Awaken the tempting flow within yourself."
	clothes_req = FALSE
	charge_type = "recharge"
	cost = 0
	xp_gain = FALSE

	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 2 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1

	invocations = list()
	invocation_type = "none"
	hide_charge_effect = TRUE
	charging_slowdown = 0
	chargedloop = null
	overlay_state = "embrace"

	action_icon = 'modular_twilight_axis/icons/roguetown/misc/soundspells.dmi'

/obj/effect/proc_holder/spell/self/temptress_awaken/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.incapacitated())
		return

	var/datum/component/combo_core/temptress/C = temptress_get_component(L)
	if(!C)
		return

	if(C.temptress_awakened)
		L.balloon_alert(L, "Already awakened.")
		return

	C.UnlockTemptressArts()

	if(L.mind)
		L.mind.RemoveSpell(src)
	qdel(src)

/obj/effect/proc_holder/spell/self/temptress/erotic_embrace
	name = "Erotic Embrace"
	desc = "Toggle erotic embrace mode."
	overlay_state = "embrace"
	recharge_time = 2 SECONDS

/obj/effect/proc_holder/spell/self/temptress/erotic_embrace/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.incapacitated())
		return

	var/datum/component/combo_core/temptress/C = temptress_get_component_safe(L)
	if(!C)
		return

	if(!C.temptress_awakened)
		return

	C.ToggleEroticEmbrace()

#undef TEMPTRESS_EMBRACE_TRAIT_SOURCE
#undef TEMPTRESS_EMBRACE_PULSE_CD
#undef TEMPTRESS_EMBRACE_GAIN_CD
#undef TEMPTRESS_EMBRACE_RANGE
