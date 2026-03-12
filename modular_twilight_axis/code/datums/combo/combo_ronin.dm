// ============================================================
// ronin.dm
// Refactored to inherit from /datum/component/combo_core/combat_style
// Logic preserved, visuals/messages preserved.
// ============================================================

#define RONIN_STACK_TICK             (1 SECONDS)
#define RONIN_MAX_STACKS_NORMAL      5
#define RONIN_MAX_STACKS_OVERDRIVE   20
#define RONIN_OVERDRIVE_DURATION     (25 SECONDS)
#define RONIN_FORCE_PER_STACK        0.01

#define RONIN_GLOW_BOUND_FILTER      "ronin_bound_glow"
#define RONIN_GLOW_PREP_FILTER       "ronin_prepared_glow"

#define RONIN_GLOW_BOUND_COLOR       "#FFD54A"
#define RONIN_GLOW_PREP_COLOR        "#FF3B3B"

#define RONIN_GLOW_SIZE_BOUND        1.5
#define RONIN_GLOW_SIZE_PREP         2

#define RONIN_TANUKI_PER_BONUS       4
#define RONIN_TANUKI_PER_HITS        4

/proc/ronin_on_parry_success(mob/living/defender, mob/living/attacker)
	if(!isliving(defender))
		return
	SEND_SIGNAL(defender, COMSIG_MOB_PARRY_SUCCESS, attacker)

/proc/ronin_parry_override(mob/living/defender, intenty, mob/living/attacker)
	var/list/parry_query = list(
		"weapon" = null,
		"intent" = intenty,
		"attacker" = attacker
	)
	SEND_SIGNAL(defender, COMSIG_MOB_QUERY_PARRY_WEAPON, parry_query)
	return parry_query["weapon"]

/datum/component/combo_core/ronin
	parent_type = /datum/component/combo_core/combat_style
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/ronin_stacks = 0
	var/next_stack_tick = 0
	var/overdrive_until = 0
	var/list/bound_blades = list()

	var/obj/item/rogueweapon/active_blade = null
	var/pending_hit_input = null
	var/list/base_force_cache = list()

	var/in_counter_stance = FALSE
	var/counter_expires_at = 0

	var/list/granted_spells = list()
	var/spells_granted = FALSE

	var/obj/item/rogueweapon/listened_blade = null

	/// Tanuki (minor): +4 PER на 4 успешных удара
	var/tanuki_per_hits_left = 0
	var/elder_tanuki_riposte_ready = FALSE

/datum/component/combo_core/ronin/Initialize(_combo_window, _max_history)
	. = ..(_combo_window, _max_history)
	if(. == COMPONENT_INCOMPATIBLE)
		return .

	START_PROCESSING(SSprocessing, src)

	RegisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME, PROC_REF(_sig_try_consume), override = TRUE)
	RegisterSignal(owner, COMSIG_COMBO_CORE_REGISTER_INPUT, PROC_REF(_sig_register_input), override = TRUE)
	RegisterSignal(owner, COMSIG_MOB_QUERY_PARRY_WEAPON, PROC_REF(_sig_query_parry_weapon))
	RegisterSignal(owner, COMSIG_MOB_PARRY_SUCCESS, PROC_REF(_sig_counter_defense_success), override = TRUE)

	GrantSpells()
	return .

/datum/component/combo_core/ronin/Destroy(force)
	STOP_PROCESSING(SSprocessing, src)

	if(bound_blades?.len)
		for(var/obj/item/rogueweapon/W as anything in bound_blades)
			if(W && !QDELETED(W))
				W.remove_filter(RONIN_GLOW_BOUND_FILTER)
				W.remove_filter(RONIN_GLOW_PREP_FILTER)

	if(listened_blade && !QDELETED(listened_blade))
		UnregisterSignal(listened_blade, COMSIG_ITEM_ATTACK_SUCCESS)

	if(owner)
		UnregisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME)
		UnregisterSignal(owner, COMSIG_COMBO_CORE_REGISTER_INPUT)
		UnregisterSignal(owner, COMSIG_MOB_PARRY_SUCCESS)
		UnregisterSignal(owner, COMSIG_MOB_QUERY_PARRY_WEAPON)
		RevokeSpells()

	RestoreAllBoundForces()

	owner = null
	listened_blade = null
	active_blade = null
	pending_hit_input = null
	bound_blades.Cut()
	base_force_cache = null
	return ..()

/datum/component/combo_core/ronin/process()
	if(world.time < next_stack_tick)
		return

	next_stack_tick = world.time + RONIN_STACK_TICK

	var/overdrive = (world.time < overdrive_until)
	if(owner.cmode && HasBoundBladeSheathed())
		if(overdrive)
			_set_ronin_stacks(min(ronin_stacks + 2, RONIN_MAX_STACKS_OVERDRIVE))
		else
			_set_ronin_stacks(min(ronin_stacks + 1, RONIN_MAX_STACKS_NORMAL))

	ApplyBoundForceMultiplier()

// ------------------------------------------------------------
// combo rules
// ------------------------------------------------------------

/datum/component/combo_core/ronin/DefineRules()
	RegisterRule("ryu",     list(1, 2, 3), 50, PROC_REF(_cb_combo))
	RegisterRule("kitsune", list(2, 1, 3), 40, PROC_REF(_cb_combo))
	RegisterRule("tengu",   list(3, 1, 2), 30, PROC_REF(_cb_combo))
	RegisterRule("tanuki",  list(1, 1, 2), 30, PROC_REF(_cb_combo))

/datum/component/combo_core/ronin/proc/_cb_combo(rule_id, mob/living/target, zone)
	if(!HasDrawnBoundBlade())
		return StoreElderCombo(rule_id)

	return ExecuteMinorCombo(rule_id, target, zone)

// ------------------------------------------------------------
// lifecycle / spells
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/GrantSpells()
	if(spells_granted || !owner?.mind)
		return

	var/mob/living/L = owner
	RevokeSpells()

	var/list/paths = list(
		/obj/effect/proc_holder/spell/self/ronin/horizontal,
		/obj/effect/proc_holder/spell/self/ronin/vertical,
		/obj/effect/proc_holder/spell/self/ronin/diagonal,
		/obj/effect/proc_holder/spell/self/ronin/blade_path,
		/obj/effect/proc_holder/spell/self/ronin/bind_blade
	)

	for(var/path in paths)
		var/obj/effect/proc_holder/spell/S = new path
		L.mind.AddSpell(S)
		granted_spells += S

	spells_granted = TRUE

/datum/component/combo_core/ronin/proc/RevokeSpells()
	if(!owner)
		return

	if(!granted_spells || !granted_spells.len)
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

	granted_spells.Cut()
	spells_granted = FALSE

// ------------------------------------------------------------
// visuals
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/_ronin_apply_weapon_glow(obj/item/rogueweapon/W)
	if(!W || QDELETED(W))
		return

	var/is_prepared = !!W.ronin_prepared_combo
	var/is_bound = (W in bound_blades)

	W.remove_filter(RONIN_GLOW_BOUND_FILTER)
	W.remove_filter(RONIN_GLOW_PREP_FILTER)

	if(is_prepared)
		W.add_filter(
			RONIN_GLOW_PREP_FILTER,
			1,
			list(
				"type" = "drop_shadow",
				"x" = 0,
				"y" = 0,
				"size" = RONIN_GLOW_SIZE_PREP,
				"color" = RONIN_GLOW_PREP_COLOR
			)
		)
	else if(is_bound)
		W.add_filter(
			RONIN_GLOW_BOUND_FILTER,
			1,
			list(
				"type" = "drop_shadow",
				"x" = 0,
				"y" = 0,
				"size" = RONIN_GLOW_SIZE_BOUND,
				"color" = RONIN_GLOW_BOUND_COLOR
			)
		)

/datum/component/combo_core/ronin/proc/_ronin_refresh_all_weapon_glows()
	if(!bound_blades || !bound_blades.len)
		return

	for(var/obj/item/rogueweapon/W as anything in bound_blades)
		_ronin_apply_weapon_glow(W)

/// called by engine when combo matched successfully
/datum/component/combo_core/ronin/OnComboMatched(rule_id, mob/living/target, zone)
	return

/// optional prepared lifecycle
/datum/component/combo_core/ronin/OnComboPrepared(state_id, payload = null)
	return

/datum/component/combo_core/ronin/OnComboConsumed(state_id, payload = null)
	return

// ------------------------------------------------------------
// weapon / sheath / binding / scaling
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/_GetBladeForce()
	UpdateActiveBlade()
	if(active_blade)
		return max(0, active_blade.force_dynamic)
	return 0

/datum/component/combo_core/ronin/proc/CacheBaseForce(obj/item/rogueweapon/W)
	if(!W)
		return
	if(!islist(base_force_cache))
		base_force_cache = list()
	if(isnull(base_force_cache[W]))
		base_force_cache[W] = W.force_dynamic

/datum/component/combo_core/ronin/proc/GetStackMultiplier()
	return 1 + (ronin_stacks * RONIN_FORCE_PER_STACK)

/datum/component/combo_core/ronin/proc/ApplyBoundForceMultiplier()
	if(!bound_blades || !bound_blades.len)
		return

	var/mult = GetStackMultiplier()
	for(var/obj/item/rogueweapon/W as anything in bound_blades)
		if(!W || QDELETED(W))
			continue
		CacheBaseForce(W)
		var/base = base_force_cache[W]
		if(isnum(base))
			W.force_dynamic = round(base * mult, 1)

/datum/component/combo_core/ronin/proc/RestoreAllBoundForces()
	if(!islist(base_force_cache))
		return

	for(var/obj/item/rogueweapon/W as anything in base_force_cache)
		if(!W || QDELETED(W))
			continue
		var/base = base_force_cache[W]
		if(isnum(base))
			W.force_dynamic = base

/datum/component/combo_core/ronin/proc/RestoreOneForce(obj/item/rogueweapon/W)
	if(!W || !islist(base_force_cache))
		return
	if(isnull(base_force_cache[W]))
		return

	var/base = base_force_cache[W]
	if(isnum(base))
		W.force_dynamic = base
	base_force_cache -= W

/datum/component/combo_core/ronin/proc/UpdateActiveBlade()
	active_blade = null
	if(!owner)
		return

	var/obj/item/I = owner.get_active_held_item()
	if(istype(I, /obj/item/rogueweapon))
		active_blade = I

/datum/component/combo_core/ronin/proc/HasDrawnBoundBlade()
	UpdateActiveBlade()
	return (active_blade && (active_blade in bound_blades))

/datum/component/combo_core/ronin/proc/HasBoundBladeSheathed()
	if(!bound_blades || !bound_blades.len)
		return FALSE

	for(var/obj/item/rogueweapon/W as anything in bound_blades)
		if(!W || QDELETED(W))
			continue
		if(GetBladeHolster(W))
			return TRUE

	return FALSE

/datum/component/combo_core/ronin/proc/GetBladeHolster(obj/item/rogueweapon/W)
	if(!owner || !W)
		return null

	for(var/obj/item/I in owner.contents)
		var/datum/component/holster/H = get_holster_component(I)
		if(!H)
			continue
		if(H.sheathed == W)
			return I

	return null

/datum/component/combo_core/ronin/proc/get_holster_component(obj/item/I)
	if(!I)
		return null
	return I.GetComponent(/datum/component/holster)

/// for parry override signal
/datum/component/combo_core/ronin/proc/GetParrySheathedBlade()
	if(!owner || !bound_blades?.len)
		return null

	for(var/obj/item/rogueweapon/W as anything in bound_blades)
		if(!W || QDELETED(W))
			continue
		if(GetBladeHolster(W))
			return W

	return null

/datum/component/combo_core/ronin/proc/GetNextElderBlade()
	if(!bound_blades || !bound_blades.len)
		return null

	var/obj/item/rogueweapon/oldest = null
	var/oldest_time = INFINITY

	for(var/obj/item/rogueweapon/W as anything in bound_blades)
		if(!W || QDELETED(W))
			continue

		if(!GetBladeHolster(W))
			continue

		if(!W.ronin_prepared_combo)
			return W

		if(W.ronin_prepared_at < oldest_time)
			oldest_time = W.ronin_prepared_at
			oldest = W

	return oldest

/datum/component/combo_core/ronin/proc/QuickDraw(consume_stacks = FALSE)
	if(!owner || !bound_blades.len)
		return FALSE

	var/obj/item/rogueweapon/W = null
	var/obj/item/sheath_item = null
	var/datum/component/holster/H = null

	for(var/obj/item/rogueweapon/candidate as anything in bound_blades)
		if(!candidate || QDELETED(candidate))
			continue

		var/obj/item/found_sheath = GetBladeHolster(candidate)
		if(found_sheath)
			W = candidate
			sheath_item = found_sheath
			H = get_holster_component(sheath_item)
			break

	if(!W || !sheath_item || !H)
		return FALSE

	var/free_hand = 0
	if(owner.get_item_for_held_index(1) == null)
		free_hand = 1
	else if(owner.get_item_for_held_index(2) == null)
		free_hand = 2
	if(!free_hand)
		return FALSE

	H.sheathed = null
	H.update_icon(sheath_item, owner)

	W.forceMove(owner.loc)
	W.pickup(owner)
	owner.put_in_hand(W, free_hand)

	active_blade = W
	UpdateAttackSuccessListener()

	if(consume_stacks)
		_set_ronin_stacks(0)
	else
		ApplyBoundForceMultiplier()

	return TRUE

/datum/component/combo_core/ronin/proc/ReturnToSheath()
	if(!owner)
		return FALSE

	UpdateActiveBlade()
	UpdateAttackSuccessListener()
	if(!active_blade)
		return FALSE

	var/obj/item/sheath_item = null
	var/datum/component/holster/H = null
	for(var/obj/item/I in owner.contents)
		var/datum/component/holster/Hc = get_holster_component(I)
		if(!Hc)
			continue
		if(Hc.weapon_check(owner, active_blade))
			sheath_item = I
			H = Hc
			break

	if(!H || !sheath_item)
		return FALSE

	if(active_blade.loc == owner)
		owner.dropItemToGround(active_blade)

	active_blade.forceMove(sheath_item)
	H.sheathed = active_blade
	H.update_icon(sheath_item, owner)

	active_blade = null
	return TRUE

/datum/component/combo_core/ronin/proc/BindBlade(obj/item/rogueweapon/W)
	if(!owner || !W)
		return FALSE

	if(W in bound_blades)
		bound_blades -= W

	if(bound_blades.len >= 2)
		var/obj/item/rogueweapon/old = bound_blades[1]
		bound_blades.Cut(1, 2)
		if(old)
			RestoreOneForce(old)

	bound_blades += W
	_ronin_apply_weapon_glow(W)
	CacheBaseForce(W)
	ApplyBoundForceMultiplier()
	UpdateAttackSuccessListener()

	to_chat(owner, span_notice("You bind [W] to your path."))
	return TRUE

/datum/component/combo_core/ronin/proc/UpdateAttackSuccessListener()
	if(listened_blade && !QDELETED(listened_blade))
		UnregisterSignal(listened_blade, COMSIG_ITEM_ATTACK_SUCCESS)

	listened_blade = null
	UpdateActiveBlade()

	if(active_blade && (active_blade in bound_blades))
		listened_blade = active_blade
		RegisterSignal(listened_blade, COMSIG_ITEM_ATTACK_SUCCESS, PROC_REF(_sig_item_attack_success))

// ------------------------------------------------------------
// minor / elder state
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/StoreElderCombo(rule_id)
	if(!owner || !rule_id)
		return FALSE

	var/obj/item/rogueweapon/W = GetNextElderBlade()
	if(!W)
		return FALSE

	W.ronin_prepared_combo = rule_id
	W.ronin_prepared_at = world.time
	_ronin_apply_weapon_glow(W)

	var/icon_file = 'modular_twilight_axis/icons/roguetown/misc/roninspells.dmi'
	var/icon_state = null
	switch(rule_id)
		if("ryu")
			icon_state = "ronin_ryu"
		if("tanuki")
			icon_state = "ronin_tanuki"
		if("tengu")
			icon_state = "ronin_tengu"
		if("kitsune")
			icon_state = "ronin_kitsune"

	_ronin_overhead(owner, icon_file, icon_state, 2.0 SECONDS, 20)
	to_chat(owner, span_notice("Elder prepared: [rule_id] -> [W]."))
	OnComboPrepared(rule_id, W)
	return TRUE

/datum/component/combo_core/ronin/proc/_StartTanukiPerBuff()
	if(!owner)
		return

	tanuki_per_hits_left = RONIN_TANUKI_PER_HITS
	owner.apply_status_effect(/datum/status_effect/buff/tanuki_insight)
	to_chat(owner, span_notice("Tanuki's insight begins."))

/datum/component/combo_core/ronin/proc/_EndTanukiPerBuff()
	if(!owner)
		return

	tanuki_per_hits_left = 0
	owner.remove_status_effect(/datum/status_effect/buff/tanuki_insight)
	to_chat(owner, span_notice("Tanuki's insight fades."))

/datum/component/combo_core/ronin/proc/_StartElderTanukiRiposte()
	elder_tanuki_riposte_ready = TRUE
	OnComboPrepared("tanuki_riposte", null)

/datum/component/combo_core/ronin/proc/_HandleElderTanukiRiposteOnHit(mob/living/target, zone)
	if(!owner || !target || !elder_tanuki_riposte_ready)
		return

	elder_tanuki_riposte_ready = FALSE
	OnComboConsumed("tanuki_riposte", target)

	target.Stun(1 SECONDS)
	target.OffBalance(2 SECONDS)
	target.Immobilize(2 SECONDS)
	target.apply_status_effect(/datum/status_effect/debuff/baited)
	target.apply_status_effect(/datum/status_effect/debuff/exposed)
	target.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)
	var/obj/item/in_hand = target.get_active_held_item()
	var/mob/living/carbon/human/target_mob = target
	if(in_hand && target_mob)
		target_mob.disarmed(in_hand)

	owner.visible_message(
		span_danger("[owner] answers with a perfect riposte!"),
		span_notice("Riposte!"),
	)

// ------------------------------------------------------------
// combat helpers / effect application
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/_GetAimDirTo(atom/A)
	if(!owner)
		return SOUTH
	if(!A)
		return owner.dir

	var/turf/ot = get_turf(owner)
	var/turf/tt = get_turf(A)
	if(!ot || !tt)
		return owner.dir

	var/d = get_dir(ot, tt)
	return d ? d : owner.dir

/datum/component/combo_core/ronin/proc/_ApplyBurnFromForce(mob/living/target, zone, mult = 0.5)
	if(!target)
		return

	var/force = _GetBladeForce()
	if(force <= 0)
		return

	var/burn = max(1, round(force * mult))
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		var/obj/item/bodypart/BP = C.get_bodypart(zone)
		if(!BP)
			BP = C.get_bodypart(BODY_ZONE_CHEST)
		if(!BP)
			return

		target.apply_damage(burn, BURN, BP, target.run_armor_check(BP, "fire"))
		return

	target.adjustFireLoss(burn)

/datum/component/combo_core/ronin/proc/_ApplyBleed(mob/living/target, zone, dam_override = null)
	if(!iscarbon(target))
		return

	var/mob/living/carbon/C = target
	var/obj/item/bodypart/BP = C.get_bodypart(zone)
	if(!BP)
		BP = C.get_bodypart(BODY_ZONE_CHEST)
	if(!BP)
		return

	if(!BP.can_bloody_wound())
		return

	var/force_dynamic = isnull(dam_override) ? _GetBladeForce() : dam_override
	if(force_dynamic <= 0)
		return

	var/list/armor_data = _get_slash_armor_data(C, zone, force_dynamic)
	if(!armor_data["can_bleed"])
		return

	var/datum/wound/dynamic/slash/existing = null
	for(var/datum/wound/W as anything in BP.wounds)
		if(istype(W, /datum/wound/dynamic/slash))
			existing = W
			break

	if(existing)
		existing.upgrade(force_dynamic, armor_data["armor"], armor_data["exposed"])
		return

	var/datum/wound/dynamic/slash/new_wound = new
	if(!new_wound.can_apply_to_bodypart(BP))
		qdel(new_wound)
		return

	new_wound.apply_to_bodypart(BP, silent = TRUE)
	new_wound.upgrade(force_dynamic, armor_data["armor"], armor_data["exposed"])

/datum/component/combo_core/ronin/proc/_ApplyArmorWearForward(mult = 0.5, tiles = 2, zone = BODY_ZONE_CHEST)
	if(!owner)
		return

	var/force = _GetBladeForce()
	if(force <= 0)
		return

	var/d = owner.dir
	var/turf/T = get_turf(owner)
	if(!T)
		return

	for(var/i in 1 to tiles)
		T = get_step(T, d)
		if(!T)
			break

		for(var/mob/living/carbon/human/H in T)
			if(H == owner)
				continue
			_apply_combo_armor_wear_simple(H, zone, "slash", force, mult)

/datum/component/combo_core/ronin/proc/_apply_combo_armor_wear_simple(mob/living/carbon/human/target, hit_zone, attack_flag, force_dynamic, multiplier = 1)
	if(!target || !attack_flag || !force_dynamic)
		return

	var/wear = round(force_dynamic * multiplier)
	wear = clamp(wear, 1, 25)
	if(wear <= 0)
		return

	var/cover_flag
	switch(hit_zone)
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

	for(var/obj/item/clothing/C in target.contents)
		if(C.loc != target)
			continue
		if(!(C.body_parts_covered & cover_flag))
			continue
		if(!C.armor)
			continue

		var/rating = C.armor.getRating(attack_flag)
		if(!isnum(rating) || rating <= 0)
			continue

		C.take_damage(wear, BRUTE, "slash")

/datum/component/combo_core/ronin/proc/_DashSlashTengu(mob/living/target, zone)
	if(!owner || !target)
		return

	var/force = _GetBladeForce()
	if(force <= 0)
		return

	var/turf/start = get_turf(owner)
	if(!start)
		return

	var/d = get_dir(owner, target)
	if(!d)
		d = owner.dir

	var/turf/t1 = get_step(start, d)
	if(!t1 || t1.density)
		return

	var/turf/t2 = get_step(t1, d)
	owner.forceMove(t1)
	_RonSlashOnTurf(t1, force, zone)

	if(t2 && !t2.density)
		owner.forceMove(t2)
		_RonSlashOnTurf(t2, force, zone)

/datum/component/combo_core/ronin/proc/_RonSlashOnTurf(turf/T, force, zone)
	if(!T)
		return

	var/mob/living/victim = null
	for(var/mob/living/L in T)
		if(L == owner)
			continue
		if(L.stat == DEAD)
			continue
		victim = L
		break

	if(!victim)
		return

	for(var/i in 1 to 2)
		var/dmg = max(1, round(force * 0.35))
		victim.adjustBruteLoss(dmg)

	_ApplyBleed(victim, zone, max(1, round(force * 0.7)))

/datum/component/combo_core/ronin/proc/_zone_to_cover_flag(zone)
	switch(zone)
		if(BODY_ZONE_HEAD)
			return HEAD
		if(BODY_ZONE_CHEST)
			return CHEST
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			return ARMS
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			return LEGS
	return CHEST

/datum/component/combo_core/ronin/proc/_get_slash_armor_data(mob/living/carbon/target, zone, force_dynamic)
	. = list(
		"can_bleed" = TRUE,
		"armor" = 0,
		"exposed" = TRUE,
	)

	if(!target)
		return .

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

	for(var/obj/item/clothing/C in target.contents)
		if(C.loc != target)
			continue
		if(!(C.body_parts_covered & cover_flag))
			continue
		if(!C.armor)
			continue

		.["exposed"] = FALSE

		var/rating = C.armor.getRating("slash")
		if(isnum(rating))
			.["armor"] = rating

		var/integrity = C.obj_integrity
		if(!isnum(integrity))
			integrity = 0

		.["can_bleed"] = ((force_dynamic * 2) >= integrity)
		return .

	return .

// ------------------------------------------------------------
// execution
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/ExecuteMinorCombo(rule_id, mob/living/target, zone)
	if(!owner || !target || !rule_id)
		return FALSE

	switch(rule_id)
		if("ryu")
			_ApplyBurnFromForce(target, zone, 0.5)

		if("kitsune")
			var/d = _GetAimDirTo(target)
			Knockback(target, 1, d, MOVE_FORCE_STRONG)

		if("tanuki")
			_StartTanukiPerBuff()

		if("tengu")
			_ApplyBleed(target, zone)

	ShowMinorComboIcon(target, rule_id)
	owner.visible_message(
		span_danger("[owner] executes a minor ronin technique!"),
		span_notice("Minor technique: [rule_id]."),
	)

	return TRUE

/datum/component/combo_core/ronin/proc/ExecuteElderCombo(rule_id, mob/living/target, zone)
	if(!owner || !rule_id)
		return

	switch(rule_id)
		if("ryu")
			if(!target)
				return

			var/force = _GetBladeForce()
			var/stam = null
			if(isnum(target.stamina))
				stam = target.stamina

			if(isnull(stam))
				target.OffBalance(1.5 SECONDS)
			else if(force > stam)
				target.OffBalance(2 SECONDS)
			else
				_set_ronin_stacks(min(ronin_stacks + 2, RONIN_MAX_STACKS_OVERDRIVE))
				ApplyBoundForceMultiplier()

		if("kitsune")
			_ApplyArmorWearForward(1.2, 2, zone)

		if("tanuki")
			_StartElderTanukiRiposte()

		if("tengu")
			if(target)
				_DashSlashTengu(target, zone)

	owner.visible_message(
		span_danger("[owner] releases an elder ronin technique!"),
		span_notice("Elder technique: [rule_id]."),
	)

// ------------------------------------------------------------
// counter / parry / riposte flow
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/EnterCounterStance()
	if(in_counter_stance)
		return

	UpdateActiveBlade()
	if(active_blade)
		return

	in_counter_stance = TRUE
	counter_expires_at = world.time + RONIN_COUNTER_WINDOW

/datum/component/combo_core/ronin/proc/ExitCounterStance()
	in_counter_stance = FALSE
	counter_expires_at = 0

/datum/component/combo_core/ronin/proc/CheckCounterExpire()
	if(in_counter_stance && world.time >= counter_expires_at)
		ExitCounterStance()

/datum/component/combo_core/ronin/proc/TryCounterInstantStrike(mob/living/attacker)
	if(!owner || !attacker)
		return FALSE

	UpdateActiveBlade()
	if(!active_blade || QDELETED(active_blade))
		return FALSE

	if(!(active_blade in bound_blades))
		return FALSE

	owner.apply_status_effect(/datum/status_effect/buff/empowered_strike)
	active_blade.attack(attacker, owner)
	return TRUE

// ------------------------------------------------------------
// signals
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/_sig_query_parry_weapon(datum/source, list/parry_query)
	SIGNAL_HANDLER

	if(!owner || !islist(parry_query))
		return FALSE

	var/obj/item/rogueweapon/W = GetParrySheathedBlade()
	if(!W)
		return FALSE

	parry_query["weapon"] = W
	return TRUE

/datum/component/combo_core/ronin/proc/_sig_try_consume(datum/source, atom/target_atom, zone)
	SIGNAL_HANDLER

	if(ronin_stacks > 0)
		_set_ronin_stacks(ronin_stacks - 1)

	if(tanuki_per_hits_left > 0)
		tanuki_per_hits_left--
		if(tanuki_per_hits_left <= 0)
			_EndTanukiPerBuff()

	if(elder_tanuki_riposte_ready)
		var/mob/living/L = target_atom
		if(isliving(L))
			_HandleElderTanukiRiposteOnHit(L, zone)
		else
			elder_tanuki_riposte_ready = FALSE

	return 0

/datum/component/combo_core/ronin/proc/_sig_item_attack_success(datum/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(user != owner)
		return

	overdrive_until = max(overdrive_until, world.time + RONIN_OVERDRIVE_DURATION)

	if(pending_hit_input)
		var/icon_file = 'modular_twilight_axis/icons/roguetown/misc/roninspells.dmi'
		var/icon_state = null
		switch(pending_hit_input)
			if(1)
				icon_state = "ch_input"
			if(2)
				icon_state = "cv_input"
			if(3)
				icon_state = "cd_input"

		_ronin_overhead(owner, icon_file, icon_state, 1.5 SECONDS, 20)
		RegisterInput(pending_hit_input, target, user.zone_selected)
		pending_hit_input = null

	var/obj/item/rogueweapon/W = source
	if(istype(W) && W.ronin_prepared_combo)
		var/rule_id = W.ronin_prepared_combo
		W.ronin_prepared_combo = null
		W.ronin_prepared_at = 0
		_ronin_apply_weapon_glow(W)
		to_chat(owner, span_danger("ELDER COMBO RELEASED: [rule_id]!"))
		OnComboConsumed(rule_id, W)
		ExecuteElderCombo(rule_id, target, user.zone_selected)

/datum/component/combo_core/ronin/_sig_register_input(datum/source, skill_id, mob/living/target, zone)
	if(!owner || !skill_id)
		return 0

	INVOKE_ASYNC(src, PROC_REF(_async_register_input), skill_id, target, zone)
	return COMPONENT_COMBO_ACCEPTED

/datum/component/combo_core/ronin/proc/_async_register_input(skill_id, mob/living/target, zone)
	if(QDELETED(src) || !owner || QDELETED(owner) || !skill_id)
		return

	if(HasDrawnBoundBlade())
		pending_hit_input = skill_id
		return

	RegisterInput(skill_id, null, zone)

/// now used for parry/defense success, not just dodge
/datum/component/combo_core/ronin/proc/_sig_counter_defense_success(datum/source, mob/living/attacker)
	SIGNAL_HANDLER
	CheckCounterExpire()

	if(!in_counter_stance)
		return

	INVOKE_ASYNC(src, PROC_REF(_async_counter_defense_success), attacker)

/// async resolution of successful defensive trigger
/datum/component/combo_core/ronin/proc/_async_counter_defense_success(mob/living/attacker)
	if(QDELETED(src) || !owner || QDELETED(owner) || !isliving(attacker) || attacker.stat == DEAD)
		in_counter_stance = FALSE
		return

	UpdateActiveBlade()
	if(!active_blade)
		if(QuickDraw(FALSE))
			TryCounterInstantStrike(attacker)

	in_counter_stance = FALSE

// ------------------------------------------------------------
// ui / small visuals
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/ShowMinorComboIcon(mob/living/target, rule_id)
	if(!target || !rule_id)
		return

	var/icon_file = 'modular_twilight_axis/icons/roguetown/misc/roninspells.dmi'
	var/icon_state = null

	switch(rule_id)
		if("ryu")
			icon_state = "ronin_ryu"
		if("tanuki")
			icon_state = "ronin_tanuki"
		if("tengu")
			icon_state = "ronin_tengu"
		if("kitsune")
			icon_state = "ronin_kitsune"

	_ronin_overhead(target, icon_file, icon_state, 1.0 SECONDS, 20)

/datum/component/combo_core/ronin/proc/_ronin_overhead(mob/living/M, icon_file, icon_state, dur = 0.7 SECONDS, pixel_y = 20)
	if(!M || !icon_file || !icon_state)
		return
	M.play_overhead_indicator_flick(icon_file, icon_state, dur, ABOVE_MOB_LAYER + 0.3, null, pixel_y)

// ------------------------------------------------------------
// stack setter
// ------------------------------------------------------------

/datum/component/combo_core/ronin/proc/_set_ronin_stacks(new_value, show_balloon = TRUE)
	var/old_value = ronin_stacks
	ronin_stacks = max(0, new_value)

	if(old_value == ronin_stacks)
		return

	ApplyBoundForceMultiplier()

	if(show_balloon && owner?.client)
		owner.balloon_alert(owner, "Ronin stacks: [ronin_stacks]")

#undef RONIN_TANUKI_PER_BONUS
#undef RONIN_TANUKI_PER_HITS
#undef RONIN_STACK_TICK
#undef RONIN_MAX_STACKS_NORMAL
#undef RONIN_MAX_STACKS_OVERDRIVE
#undef RONIN_OVERDRIVE_DURATION
#undef RONIN_FORCE_PER_STACK
#undef RONIN_GLOW_BOUND_FILTER
#undef RONIN_GLOW_PREP_FILTER
#undef RONIN_GLOW_BOUND_COLOR
#undef RONIN_GLOW_PREP_COLOR
#undef RONIN_GLOW_SIZE_BOUND
#undef RONIN_GLOW_SIZE_PREP
