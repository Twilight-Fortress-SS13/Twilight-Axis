GLOBAL_LIST_INIT(wanderer_erp_training_map, list(
    // Labor
    /datum/erp_action/other/hands/milking_breasts = list("skill" = /datum/skill/labor/farming, "passive" = "wanderer"),
    /datum/erp_action/other/mouth/rimming = list("skill" = /datum/skill/labor/mining, "passive" = "wanderer"),
    /datum/erp_action/other/hands/finger_oral = list("skill" = /datum/skill/labor/fishing, "passive" = "wanderer"),
    /datum/erp_action/other/body/grinding = list("skill" = /datum/skill/labor/butchering, "passive" = "wanderer"),
    /datum/erp_action/other/hands/spanking = list("skill" = /datum/skill/labor/lumberjacking, "passive" = "wanderer"),

    // Magic
    /datum/erp_action/other/mouth/cunnilingus = list("skill" = /datum/skill/magic/holy, "passive" = "wanderer"),
    /datum/erp_action/other/mouth/breast_feed = list("skill" = /datum/skill/magic/arcane, "passive" = "wanderer"),

    // Misc
    /datum/erp_action/other/body/rubbing = list("skill" = /datum/skill/misc/climbing, "passive" = "actor"),
    /datum/erp_action/other/vagina/force_face = list("skill" = /datum/skill/misc/reading, "passive" = "actor"),
    /datum/erp_action/other/vagina/face = list("skill" = /datum/skill/misc/stealing, "passive" = "actor"),
    /datum/erp_action/other/hands/force_crotch = list("skill" = /datum/skill/misc/sneaking, "passive" = "actor"),
    /datum/erp_action/other/hands/tease_vagina = list("skill" = /datum/skill/misc/lockpicking, "passive" = "wanderer"),
    /datum/erp_action/other/anus/force_face = list("skill" = /datum/skill/misc/riding, "passive" = "wanderer"),
    /datum/erp_action/other/mouth/finger_lick = list("skill" = /datum/skill/misc/medicine, "passive" = "actor"),
	/datum/erp_action/other/mouth/foot_lick = list("skill" = /datum/skill/misc/tracking, "passive" = "wanderer"),

    // Craft
    /datum/erp_action/other/breasts/breast_feed = list("skill" = /datum/skill/craft/crafting, "passive" = "actor"),
    /datum/erp_action/other/hands/toy_anal = list("skill" = /datum/skill/craft/weaponsmithing, "passive" = "actor"),
    /datum/erp_action/other/hands/toy_oral = list("skill" = /datum/skill/craft/armorsmithing, "passive" = "actor"),
    /datum/erp_action/other/anus/butt = list("skill" = /datum/skill/craft/blacksmithing, "passive" = "wanderer"),
    /datum/erp_action/other/penis/rubbing = list("skill" = /datum/skill/craft/smelting, "passive" = "actor"),
    /datum/erp_action/other/vagina/rubbing = list("skill" = /datum/skill/craft/carpentry, "passive" = "actor"),
    /datum/erp_action/other/anus/rubbing = list("skill" = /datum/skill/craft/masonry, "passive" = "actor"),
    /datum/erp_action/other/anus/face = list("skill" = /datum/skill/craft/traps, "passive" = "actor"),
    /datum/erp_action/other/hands/toy_oral = list("skill" = /datum/skill/craft/engineering, "passive" = "wanderer"),
    /datum/erp_action/other/mouth/kiss = list("skill" = /datum/skill/craft/cooking, "passive" = "wanderer"),
    /datum/erp_action/other/hands/rubbing = list("skill" = /datum/skill/craft/sewing, "passive" = "wanderer"),
    /datum/erp_action/other/hands/spanking = list("skill" = /datum/skill/craft/tanning, "passive" = "actor"),
    /datum/erp_action/other/hands/breasts_play = list("skill" = /datum/skill/craft/ceramics, "passive" = "wanderer"),
    /datum/erp_action/other/hands/milking_penis = list("skill" = /datum/skill/craft/alchemy, "passive" = "wanderer"),

    // Combat
    /datum/erp_action/other/penis/masturbation = list("skill" = /datum/skill/combat/knives, "passive" = "actor"),
    /datum/erp_action/other/hands/toy_anal = list("skill" = /datum/skill/combat/swords, "passive" = "wanderer"),
    /datum/erp_action/other/hands/toy_vaginal = list("skill" = /datum/skill/combat/polearms, "passive" = "wanderer"),
    /datum/erp_action/other/legs/footjob = list("skill" = /datum/skill/combat/maces, "passive" = "wanderer"),
    /datum/erp_action/other/mouth/foot_lick = list("skill" = /datum/skill/combat/axes, "passive" = "wanderer"),
    /datum/erp_action/other/hands/tease_testicles = list("skill" = /datum/skill/combat/whipsflails, "passive" = "wanderer"),
    /datum/erp_action/other/hands/finger_anal = list("skill" = /datum/skill/combat/wrestling, "passive" = "wanderer"),
    /datum/erp_action/other/hands/finger_vaginal = list("skill" = /datum/skill/combat/unarmed, "passive" = "wanderer"),
    /datum/erp_action/other/breasts/teasing = list("skill" = /datum/skill/combat/shields, "passive" = "actor"),
    /datum/erp_action/other/legs/teasing = list("skill" = /datum/skill/combat/staves, "passive" = "actor"),
))

GLOBAL_LIST_INIT(wanderer_combat_skills, list(
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

#define WANDERER_COMBO_WINDOW            (7 SECONDS)
#define WANDERER_MAX_HISTORY             5

#define WANDERER_MAX_COMBO_STACKS        5
#define WANDERER_MAX_AROUSAL_STACKS      10

#define WANDERER_COMBO_DMG_PER_STACK     0.10
#define WANDERER_AROUSAL_DMG_PER_STACK   0.05

#define WANDERER_KICK_MIN_RECOVERY       (0.5 SECONDS)

#define WANDERER_INPUT_PUNCH             1
#define WANDERER_INPUT_KICK              2
#define WANDERER_INPUT_GRAB              3

#define WANDERER_STANCE_PROC             1
#define WANDERER_STANCE_PRECISE          2

#define WANDERER_BUTTON_SWITCH_STANCE    101
#define WANDERER_BUTTON_EROTIC_EMBRACE   102

#define WANDERER_EMBRACE_TRAIT_SOURCE    "wanderer_embrace"
#define WANDERER_STAT_INDEX 			 "wanderer_buff"

// ------------------------------------------------------------
// helpers
// ------------------------------------------------------------

/proc/wanderer_get_component(mob/living/user)
	if(!isliving(user))
		return null

	var/datum/component/combo_core/wanderer/C = user.GetComponent(/datum/component/combo_core/wanderer)
	if(!C)
		C = user.AddComponent(/datum/component/combo_core/wanderer)
	return C

/proc/wanderer_get_component_safe(mob/living/user)
	if(!isliving(user))
		return null

	return user.GetComponent(/datum/component/combo_core/wanderer)

/proc/wanderer_erp_get_training_entry(datum/erp_action/A)
	if(!A)
		return null

	var/type = A.type
	if(type in GLOB.wanderer_erp_training_map)
		return GLOB.wanderer_erp_training_map[type]

	return null

/datum/erp_scene_effects/proc/apply_training(list/active_links)
	if(!controller)
		return

	var/training = FALSE
	var/datum/component/combo_core/wanderer/W = controller.owner?.physical?.GetComponent(/datum/component/combo_core/wanderer)
	if(W && W.erotic_embrace_enabled)
		training = TRUE

	W = controller.active_partner?.physical?.GetComponent(/datum/component/combo_core/wanderer)
	if(W && W.erotic_embrace_enabled)
		training = TRUE

	if(!training)
		return

	var/mob/living/wanderer_mob = W.owner
	if(!wanderer_mob)
		return

	for(var/datum/erp_sex_link/L in active_links)
		if(!L || QDELETED(L) || !L.is_valid())
			continue

		var/entry = wanderer_erp_get_training_entry(L.action)
		if(!entry)
			continue

		var/expected_passive = entry["passive"]
		var/skill_type = entry["skill"]

		var/datum/erp_actor/active = L.actor_active
		var/datum/erp_actor/passive = L.actor_passive

		if(!active || !passive)
			continue

		var/mob/living/m_active = active.get_effect_mob()
		var/mob/living/m_passive = passive.get_effect_mob()

		if(!m_active || !m_passive)
			continue

		var/is_wanderer_active = (m_active == wanderer_mob)
		var/is_wanderer_passive = (m_passive == wanderer_mob)

		if(expected_passive == "wanderer" && !is_wanderer_passive)
			continue

		if(expected_passive == "actor" && !is_wanderer_active)
			continue

		var/mob/living/receiver = null
		if(is_wanderer_active)
			receiver = m_passive
		else if(is_wanderer_passive)
			receiver = m_active
		else
			continue

		if(!receiver?.mind)
			continue

		if(skill_type in GLOB.wanderer_combat_skills)
			if(L.force < SEX_FORCE_HIGH)
				continue

		var/exp = 2
		receiver.mind.add_sleep_experience(skill_type, exp, FALSE)

// ============================================================
// Component
// ============================================================

/datum/component/combo_core/wanderer
	parent_type = /datum/component/combo_core/combat_style
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// Current stance is always active.
	var/current_stance = WANDERER_STANCE_PROC

	/// Play / prep mode.
	var/erotic_embrace_enabled = FALSE

	/// +1 per successful base hit, spent on finisher.
	var/combo_stacks = 0
	var/max_combo_stacks = WANDERER_MAX_COMBO_STACKS

	/// Direct damage resource.
	var/arousal_stacks = 0
	var/max_arousal_stacks = WANDERER_MAX_AROUSAL_STACKS

	/// Last successful resolved base action.
	var/last_action_success = FALSE
	var/last_action_skill = 0
	var/last_action_zone = BODY_ZONE_CHEST
	var/mob/living/last_action_target = null

	var/last_finisher_success = FALSE
	var/last_matched_rule = null

	var/list/granted_spells = list()
	var/spells_granted = FALSE

/datum/component/combo_core/wanderer/Initialize(_combo_window, _max_history)
	. = ..(_combo_window || WANDERER_COMBO_WINDOW, _max_history || WANDERER_MAX_HISTORY)
	if(. == COMPONENT_INCOMPATIBLE)
		return .

	StripExternalStyleSpells()
	GrantSpells()
	OnAttachApplyHiddenStats()

	RegisterSignal(owner, COMSIG_COMBO_CORE_REGISTER_INPUT, PROC_REF(_sig_register_input), override = TRUE)
	RegisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME, PROC_REF(_sig_try_consume))
	RegisterSignal(owner, COMSIG_PARENT_EXAMINE, PROC_REF(_sig_examined))

	_balloon_stance()
	return .

/datum/component/combo_core/wanderer/Destroy(force)
	if(owner)
		UnregisterSignal(owner, COMSIG_COMBO_CORE_REGISTER_INPUT)
		UnregisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME)
		UnregisterSignal(owner, COMSIG_PARENT_EXAMINE)

		REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, WANDERER_EMBRACE_TRAIT_SOURCE)

		OnDetachClearHiddenStats()
		RevokeSpells()

	owner = null
	granted_spells = null
	return ..()

// ------------------------------------------------------------
// combo_core overrides
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/DefineRules()

	// ======================
	// 2-hit combos
	// ======================

	RegisterRule("heel_tap",      list(WANDERER_INPUT_KICK,  WANDERER_INPUT_PUNCH), 30, PROC_REF(_cb_combo))
	RegisterRule("needle_thread", list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_GRAB),  35, PROC_REF(_cb_combo))
	RegisterRule("double_strike", list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_PUNCH), 25, PROC_REF(_cb_combo))
	RegisterRule("low_pressure",  list(WANDERER_INPUT_KICK,  WANDERER_INPUT_KICK),  25, PROC_REF(_cb_combo))

	// ======================
	// 3-hit combos
	// ======================

	RegisterRule("iron_bloom",    list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_PUNCH, WANDERER_INPUT_KICK), 50, PROC_REF(_cb_combo))
	RegisterRule("leg_hook",      list(WANDERER_INPUT_KICK,  WANDERER_INPUT_PUNCH, WANDERER_INPUT_GRAB), 55, PROC_REF(_cb_combo))
	RegisterRule("triple_strike", list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_PUNCH, WANDERER_INPUT_PUNCH), 45, PROC_REF(_cb_combo))
	RegisterRule("breaker_kicks", list(WANDERER_INPUT_KICK,  WANDERER_INPUT_KICK,  WANDERER_INPUT_KICK),  45, PROC_REF(_cb_combo))
	RegisterRule("grip_break",    list(WANDERER_INPUT_GRAB,  WANDERER_INPUT_GRAB,  WANDERER_INPUT_PUNCH), 40, PROC_REF(_cb_combo))
	RegisterRule("body_lock",     list(WANDERER_INPUT_GRAB,  WANDERER_INPUT_GRAB,  WANDERER_INPUT_KICK),  40, PROC_REF(_cb_combo))

	// ======================
	// 4-hit combos
	// ======================

	RegisterRule("gatebreaker", list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_KICK, WANDERER_INPUT_GRAB, WANDERER_INPUT_KICK), 70, PROC_REF(_cb_combo))
	RegisterRule("crane_fold",  list(WANDERER_INPUT_KICK,  WANDERER_INPUT_PUNCH, WANDERER_INPUT_GRAB, WANDERER_INPUT_KICK), 75, PROC_REF(_cb_combo))

/datum/component/combo_core/wanderer/OnHistoryChanged()
	return

/datum/component/combo_core/wanderer/OnHistoryCleared(reason)
	last_matched_rule = null
	last_finisher_success = FALSE

/datum/component/combo_core/wanderer/OnComboExpired()
	last_matched_rule = null
	last_finisher_success = FALSE

/datum/component/combo_core/wanderer/OnComboMatched(rule_id, mob/living/target, zone)
	last_finisher_success = TRUE
	last_matched_rule = rule_id

/datum/component/combo_core/wanderer/ConsumeOnCombo(rule_id)
	ClearHistory("combo")
	ResetComboStacks()

// ------------------------------------------------------------
// spells / strip old style abilities
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/proc/StripExternalStyleSpells()
	if(!owner?.mind)
		return

	var/list/current = owner.mind.spell_list?.Copy()
	if(!length(current))
		return

	for(var/obj/effect/proc_holder/spell/S as anything in current)
		if(!S)
			continue

		if(istype(S, /obj/effect/proc_holder/spell/self/wanderer))
			owner.mind.RemoveSpell(S)
			continue

		if(istype(S, /obj/effect/proc_holder/spell/self/soundbreaker))
			owner.mind.RemoveSpell(S)
			continue

		if(istype(S, /obj/effect/proc_holder/spell/self/ronin))
			owner.mind.RemoveSpell(S)
			continue

/datum/component/combo_core/wanderer/proc/GrantSpells()
	if(spells_granted || !owner?.mind)
		return

	var/mob/living/L = owner
	RevokeSpells()

	var/list/paths = list(
		/obj/effect/proc_holder/spell/self/wanderer/switch_stance,
		/obj/effect/proc_holder/spell/self/wanderer/erotic_embrace,
		/obj/effect/proc_holder/spell/invoked/massage
	)

	for(var/path in paths)
		var/obj/effect/proc_holder/spell/S = new path
		L.mind.AddSpell(S)
		granted_spells += S

	spells_granted = TRUE

/datum/component/combo_core/wanderer/proc/RevokeSpells()
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

// ------------------------------------------------------------
// hidden stats hooks
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/proc/OnAttachApplyHiddenStats()
    var/mob/living/H = owner
    if(!H)
        return

    // ===== TRAITS =====
    ADD_TRAIT(H, TRAIT_KEENEARS, type)
    ADD_TRAIT(H, TRAIT_NUTCRACKER, type)
    ADD_TRAIT(H, TRAIT_GOODLOVER, type)
    ADD_TRAIT(H, TRAIT_EMPATH, type)
    ADD_TRAIT(H, TRAIT_NOPAINSTUN, type)
    ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, type)

    // ===== STATS =====
    H.change_stat(STATKEY_STR, 3, WANDERER_STAT_INDEX)
    H.change_stat(STATKEY_SPD, 2, WANDERER_STAT_INDEX)
    H.change_stat(STATKEY_LCK, 2, WANDERER_STAT_INDEX)
    H.change_stat(STATKEY_PER, 1, WANDERER_STAT_INDEX)
    H.change_stat(STATKEY_WIL, 2, WANDERER_STAT_INDEX)
    H.change_stat(STATKEY_CON, 2, WANDERER_STAT_INDEX)

    // ===== SKILLS =====
    H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
    H.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
    H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
    H.adjust_skillrank(/datum/skill/misc/music, 5, TRUE)

/datum/component/combo_core/wanderer/proc/OnDetachClearHiddenStats()
    var/mob/living/H = owner
    if(!H)
        return

    // ===== TRAITS =====
    REMOVE_TRAIT(H, TRAIT_KEENEARS, type)
    REMOVE_TRAIT(H, TRAIT_NUTCRACKER, type)
    REMOVE_TRAIT(H, TRAIT_GOODLOVER, type)
    REMOVE_TRAIT(H, TRAIT_EMPATH, type)
    REMOVE_TRAIT(H, TRAIT_NOPAINSTUN, type)
    REMOVE_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, type)

    // ===== STATS =====
    H.change_stat(null, 0, WANDERER_STAT_INDEX)

// ------------------------------------------------------------
// signals
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/_sig_register_input(datum/source, skill_id, mob/living/target, zone)
	if(!owner || !skill_id)
		return 0

	switch(skill_id)
		if(WANDERER_BUTTON_SWITCH_STANCE)
			ToggleStance()
			return COMPONENT_COMBO_ACCEPTED

		if(WANDERER_BUTTON_EROTIC_EMBRACE)
			ToggleEroticEmbrace()
			return COMPONENT_COMBO_ACCEPTED

	return 0

/datum/component/combo_core/wanderer/proc/_sig_examined(datum/source, mob/living/user)
	SIGNAL_HANDLER

	if(!erotic_embrace_enabled)
		return 0
	if(!isliving(user))
		return 0
	if(user == owner)
		return 0

	SEND_SIGNAL(user, COMSIG_SEX_RECEIVE_ACTION, 10, 0, TRUE, 2, 2, null)
	AddArousalStack(1)
	return 0

/datum/component/combo_core/wanderer/proc/_sig_try_consume(datum/source, atom/target_atom, zone, obj/item/W, forced_skill_id)
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

/datum/component/combo_core/wanderer/proc/_handle_try_consume_async(skill_id, mob/living/target, zone)
	if(!owner)
		return

	last_action_success = TRUE
	last_action_skill = skill_id
	last_action_zone = zone || BODY_ZONE_CHEST
	last_action_target = target
	last_finisher_success = FALSE
	last_matched_rule = null

	AddComboStack()

	if(erotic_embrace_enabled)
		if(target)
			SEND_SIGNAL(target, COMSIG_SEX_RECEIVE_ACTION, 5, 0, TRUE, 2, 2, null)
		AddArousalStack(1)
	else
		if(current_stance == WANDERER_STANCE_PROC)
			ApplyProcPressureOnHit(target, last_action_zone, FALSE)
		else
			ApplyPreciseOnHit(target, last_action_zone)

	var/fired = RegisterInput(skill_id, target, last_action_zone)
	if(fired && owner?.client)
		owner.balloon_alert(owner, "wanderer combo!")

	if(!erotic_embrace_enabled)
		SpendArousalStack(1)

// ------------------------------------------------------------
// stance / embrace
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/proc/ToggleStance()
	if(current_stance == WANDERER_STANCE_PROC)
		SetStance(WANDERER_STANCE_PRECISE)
	else
		SetStance(WANDERER_STANCE_PROC)

/datum/component/combo_core/wanderer/proc/SetStance(new_stance)
	if(current_stance == new_stance)
		return

	current_stance = new_stance
	_balloon_stance()

/datum/component/combo_core/wanderer/proc/ToggleEroticEmbrace()
	erotic_embrace_enabled = !erotic_embrace_enabled

	if(erotic_embrace_enabled)
		ADD_TRAIT(owner, TRAIT_DODGEEXPERT, WANDERER_EMBRACE_TRAIT_SOURCE)
	else
		REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, WANDERER_EMBRACE_TRAIT_SOURCE)

	_balloon_embrace()

// ------------------------------------------------------------
// combo callback / execution
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/proc/_cb_combo(rule_id, mob/living/target, zone)
	if(!last_action_success)
		return FALSE
	if(!owner)
		return FALSE

	if(!target)
		target = last_action_target
	if(!zone)
		zone = last_action_zone

	if(!target)
		return FALSE

	ExecuteCombo(rule_id, target, zone)
	return TRUE

/datum/component/combo_core/wanderer/proc/ExecuteCombo(rule_id, mob/living/target, zone)
	if(!owner || !target || !rule_id)
		return FALSE

	var/zone_used = TryGetZone(zone)
	var/combo_mult = GetComboDamageMultiplier()

	switch(rule_id)
		if("heel_tap")
			if(current_stance == WANDERER_STANCE_PROC)
				var/dmg1 = max(1, round(combo_mult * 1.25))
				target.adjustBruteLoss(dmg1)
				target.stamina_add(round(target.max_stamina * 0.12))

				if(!erotic_embrace_enabled)
					SafeSlow(target, 1.5)
					ApplyProcPressureOnHit(target, zone_used, TRUE)
			else
				var/dmg1p = max(1, round(combo_mult * 0.95))
				target.adjustBruteLoss(dmg1p)

				if(!erotic_embrace_enabled)
					ApplyPreciseFinisher(target, zone_used, last_action_skill)

		if("needle_thread")
			if(current_stance == WANDERER_STANCE_PROC)
				if(!erotic_embrace_enabled)
					target.Immobilize(1 SECONDS)
				target.stamina_add(round(target.max_stamina * 0.12))

				if(!erotic_embrace_enabled)
					ApplyProcPressureOnHit(target, zone_used, TRUE)
			else
				var/dmg_nt = max(1, round(combo_mult * 0.90))
				target.adjustBruteLoss(dmg_nt)

				if(!erotic_embrace_enabled)
					ApplyPreciseFinisher(target, zone_used, last_action_skill)

		if("iron_bloom")
			if(current_stance == WANDERER_STANCE_PROC)
				var/dmg2 = max(2, round(combo_mult * 1.5))
				target.adjustBruteLoss(dmg2)

				if(!erotic_embrace_enabled)
					if(_get_stamina_pct(target) <= 0.4)
						SafeOffbalance(target, 2 SECONDS)
					else
						target.stamina_add(round(target.max_stamina * 0.18))
					ApplyProcPressureOnHit(target, zone_used, TRUE)
			else
				var/dmg2p = max(1, round(combo_mult * 1.10))
				target.adjustBruteLoss(dmg2p)

				if(!erotic_embrace_enabled)
					ApplyPreciseFinisher(target, zone_used, last_action_skill)

		if("leg_hook")
			if(current_stance == WANDERER_STANCE_PROC)
				var/dmg_lh = max(1, round(combo_mult * 0.85))
				target.adjustBruteLoss(dmg_lh)

				if(!erotic_embrace_enabled)
					SafeOffbalance(target, 1.5 SECONDS)
					target.stamina_add(round(target.max_stamina * 0.10))
					ApplyProcPressureOnHit(target, zone_used, TRUE)
			else
				var/dmg_lhp = max(1, round(combo_mult * 0.85))
				target.adjustBruteLoss(dmg_lhp)

				if(!erotic_embrace_enabled)
					ApplyPreciseFinisher(target, zone_used, last_action_skill)

		if("gatebreaker")
			var/d = get_dir(owner, target)
			if(!d)
				d = owner.dir

			if(current_stance == WANDERER_STANCE_PROC)
				var/dmg3 = max(3, round(combo_mult * 2.0))
				target.adjustBruteLoss(dmg3)

				if(!erotic_embrace_enabled)
					target.stamina_add(round(target.max_stamina * 0.22))
					Knockback(target, 1, d, MOVE_FORCE_STRONG)
					SafeOffbalance(target, 2.2 SECONDS)
					ApplyProcPressureOnHit(target, zone_used, TRUE)
			else
				var/dmg3p = max(2, round(combo_mult * 1.25))
				target.adjustBruteLoss(dmg3p)

				if(!erotic_embrace_enabled)
					ApplyPreciseFinisher(target, zone_used, last_action_skill)

		if("crane_fold")
			if(current_stance == WANDERER_STANCE_PROC)
				var/dmg_cf = max(2, round(combo_mult * 1.15))
				target.adjustBruteLoss(dmg_cf)

				if(!erotic_embrace_enabled)
					if(zone_used == BODY_ZONE_HEAD)
						target.Stun(1.5 SECONDS)
					else if(zone_used == BODY_ZONE_L_LEG || zone_used == BODY_ZONE_R_LEG)
						SafeOffbalance(target, 2.5 SECONDS)
					else
						target.Immobilize(1.5 SECONDS)

					ApplyProcPressureOnHit(target, zone_used, TRUE)
			else
				var/dmg_cfp = max(1, round(combo_mult * 1.00))
				target.adjustBruteLoss(dmg_cfp)

				if(!erotic_embrace_enabled)
					ApplyPreciseFinisher(target, zone_used, last_action_skill)

		if("double_strike")
			target.adjustBruteLoss(max(1, round(combo_mult * 1.1)))

		if("low_pressure")
			target.adjustBruteLoss(max(1, round(combo_mult * 1.1)))

		if("triple_strike")
			target.adjustBruteLoss(max(2, round(combo_mult * 1.4)))

		if("breaker_kicks")
			target.adjustBruteLoss(max(2, round(combo_mult * 1.4)))

		if("grip_break")
			target.adjustBruteLoss(max(2, round(combo_mult * 1.2)))
			target.Immobilize(1 SECONDS)

		if("body_lock")
			target.adjustBruteLoss(max(2, round(combo_mult * 1.2)))
			SafeOffbalance(target, 1.5 SECONDS)

	return TRUE

// ------------------------------------------------------------
// proc pressure
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/proc/GetPressureChance()
	return clamp(20 + (combo_stacks * 10), 0, 100)

/datum/component/combo_core/wanderer/proc/GetPressureDamage()
	if(!owner)
		return 1
	return max(1, round(owner.get_stat(STAT_STRENGTH) / 2))

/datum/component/combo_core/wanderer/proc/ApplyArmorDamageToZone(mob/living/target, zone, amount)
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

/datum/component/combo_core/wanderer/proc/ApplyProcPressureOnHit(mob/living/target, zone, guaranteed = FALSE)
	if(!owner || !target)
		return

	var/chance = guaranteed ? 100 : GetPressureChance()
	if(!prob(chance))
		return

	ApplyArmorDamageToZone(target, zone, GetPressureDamage())

// ------------------------------------------------------------
// precise stance
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/proc/GetPreciseStaminaDamage()
	if(!owner)
		return 1
	return max(1, round(owner.get_stat(STAT_STRENGTH) / 2))

/datum/component/combo_core/wanderer/proc/ApplyPreciseOnHit(mob/living/target, zone)
	if(!owner || !target)
		return

	var/zone_used = TryGetZone(zone)

	switch(zone_used)
		if(BODY_ZONE_HEAD)
			if(prob(25))
				target.Dizzy(1 SECONDS)

		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			if(prob(25))
				SafeSlow(target, 1)

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

/datum/component/combo_core/wanderer/proc/ApplyPreciseFinisher(mob/living/target, zone, finisher_skill)
	if(!target)
		return

	var/zone_used = TryGetZone(zone)

	switch(zone_used)
		if(BODY_ZONE_HEAD)
			var/chance_head = 25
			if(finisher_skill == WANDERER_INPUT_PUNCH)
				chance_head = 50
			if(prob(chance_head))
				target.Stun(1.5 SECONDS)

		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			var/chance_arms = 25
			if(finisher_skill == WANDERER_INPUT_GRAB)
				chance_arms = 50
			if(prob(chance_arms))
				target.Immobilize(1.5 SECONDS)

		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			var/chance_legs = 25
			if(finisher_skill == WANDERER_INPUT_KICK)
				chance_legs = 50
			if(prob(chance_legs))
				SafeOffbalance(target, 2 SECONDS)

		if(BODY_ZONE_CHEST)
			var/chance_chest = 15
			if(finisher_skill == WANDERER_INPUT_GRAB)
				chance_chest = 25
			if(prob(chance_chest))
				target.Knockdown(1.5 SECONDS)

// ------------------------------------------------------------
// kick helpers
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/proc/GetKickOffbalanceDuration(base_duration = 3 SECONDS)
	var/stacks = clamp(combo_stacks, 0, max_combo_stacks)
	if(stacks <= 0)
		return base_duration

	var/mult = 1 - (stacks * 0.10)
	mult = clamp(mult, 0.35, 1)
	return max(WANDERER_KICK_MIN_RECOVERY, round(base_duration * mult))

// ------------------------------------------------------------
// arousal / resources
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/proc/AddComboStack(amount = 1)
	if(amount <= 0)
		return

	combo_stacks = clamp(combo_stacks + amount, 0, max_combo_stacks)
	_balloon_stacks()

/datum/component/combo_core/wanderer/proc/ResetComboStacks()
	if(combo_stacks <= 0)
		return

	combo_stacks = 0
	_balloon_stacks()

/datum/component/combo_core/wanderer/proc/AddArousalStack(amount = 1)
	if(amount <= 0)
		return

	arousal_stacks = clamp(arousal_stacks + amount, 0, max_arousal_stacks)
	_balloon_arousal()

/datum/component/combo_core/wanderer/proc/SpendArousalStack(amount = 1)
	if(amount <= 0)
		return
	if(arousal_stacks <= 0)
		return

	arousal_stacks = clamp(arousal_stacks - amount, 0, max_arousal_stacks)
	_balloon_arousal()

/datum/component/combo_core/wanderer/proc/GetComboDamageMultiplier()
	if(erotic_embrace_enabled)
		return 0.10

	var/mult = 1
	mult += (combo_stacks * WANDERER_COMBO_DMG_PER_STACK)
	mult += (arousal_stacks * WANDERER_AROUSAL_DMG_PER_STACK)
	return max(1, mult)

// ------------------------------------------------------------
// utils
// ------------------------------------------------------------

/datum/component/combo_core/wanderer/proc/ResolveAttackInput(atom/target_atom, obj/item/W)
	if(!owner)
		return 0

	if(W)
		return 0

	if(owner.used_intent && findtext(lowertext("[owner.used_intent.type]"), "grab"))
		return WANDERER_INPUT_GRAB
	if(owner.used_intent && findtext(lowertext("[owner.used_intent.name]"), "grab"))
		return WANDERER_INPUT_GRAB

	return WANDERER_INPUT_PUNCH

/datum/component/combo_core/wanderer/proc/IsBaseInput(skill_id)
	return (skill_id == WANDERER_INPUT_PUNCH || skill_id == WANDERER_INPUT_KICK || skill_id == WANDERER_INPUT_GRAB)

/datum/component/combo_core/wanderer/proc/_balloon_stacks()
	if(owner?.client)
		owner.balloon_alert(owner, "wanderer stacks: [combo_stacks]")

/datum/component/combo_core/wanderer/proc/_balloon_arousal()
	if(owner?.client)
		owner.balloon_alert(owner, "wanderer arousal: [arousal_stacks]")

/datum/component/combo_core/wanderer/proc/_balloon_stance()
	if(!owner?.client)
		return

	if(current_stance == WANDERER_STANCE_PROC)
		owner.balloon_alert(owner, "stance: proc")
	else
		owner.balloon_alert(owner, "stance: precise")

/datum/component/combo_core/wanderer/proc/_balloon_embrace()
	if(!owner?.client)
		return

	if(erotic_embrace_enabled)
		owner.balloon_alert(owner, "embrace: on")
	else
		owner.balloon_alert(owner, "embrace: off")

// ============================================================
// Wanderer spells
// ============================================================

/obj/effect/proc_holder/spell/self/wanderer
	name = "Wanderer Ability"
	desc = "Base wanderer ability."
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

/obj/effect/proc_holder/spell/self/wanderer/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.incapacitated())
		return

	var/datum/component/combo_core/wanderer/C = wanderer_get_component_safe(L)
	if(!C)
		return

	Execute(L, C)

/obj/effect/proc_holder/spell/self/wanderer/proc/Execute(mob/living/user, datum/component/combo_core/wanderer/C)
	return

// ------------------------------------------------------------
// Ability 1 = Switch Stance
// ------------------------------------------------------------

/obj/effect/proc_holder/spell/self/wanderer/switch_stance
	name = "Switch Stance"
	desc = "Switch between proc stance and precise stance."
	overlay_state = "active_strike"

/obj/effect/proc_holder/spell/self/wanderer/switch_stance/Execute(mob/living/user, datum/component/combo_core/wanderer/C)
	if(!user || !C)
		return

	SEND_SIGNAL(user, COMSIG_COMBO_CORE_REGISTER_INPUT, WANDERER_BUTTON_SWITCH_STANCE, null, null)

// ------------------------------------------------------------
// Ability 2 = Erotic Embrace
// ------------------------------------------------------------

/obj/effect/proc_holder/spell/self/wanderer/erotic_embrace
	name = "Erotic Embrace"
	desc = "Preparation / play mode."
	overlay_state = "active_wave"

/obj/effect/proc_holder/spell/self/wanderer/erotic_embrace/Execute(mob/living/user, datum/component/combo_core/wanderer/C)
	if(!user || !C)
		return

	SEND_SIGNAL(user, COMSIG_COMBO_CORE_REGISTER_INPUT, WANDERER_BUTTON_EROTIC_EMBRACE, null, null)

// ============================================================
// cleanup
// ============================================================

#undef WANDERER_COMBO_WINDOW
#undef WANDERER_MAX_HISTORY
#undef WANDERER_MAX_COMBO_STACKS
#undef WANDERER_MAX_AROUSAL_STACKS
#undef WANDERER_COMBO_DMG_PER_STACK
#undef WANDERER_AROUSAL_DMG_PER_STACK
#undef WANDERER_KICK_MIN_RECOVERY
#undef WANDERER_INPUT_PUNCH
#undef WANDERER_INPUT_GRAB
#undef WANDERER_STANCE_PROC
#undef WANDERER_STANCE_PRECISE
#undef WANDERER_BUTTON_SWITCH_STANCE
#undef WANDERER_BUTTON_EROTIC_EMBRACE
#undef WANDERER_EMBRACE_TRAIT_SOURCE
