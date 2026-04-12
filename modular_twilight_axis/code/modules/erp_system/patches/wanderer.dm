GLOBAL_LIST_INIT(wanderer_erp_training_map, list(
	/datum/skill/labor/farming = list("action" = /datum/erp_action/other/hands/milking_breasts, "passive" = "wanderer"),
	/datum/skill/labor/mining = list("action" = /datum/erp_action/other/mouth/rimming, "passive" = "wanderer"),
	/datum/skill/labor/fishing = list("action" = /datum/erp_action/other/hands/finger_oral, "passive" = "wanderer"),
	/datum/skill/labor/butchering = list("action" = /datum/erp_action/other/body/grinding, "passive" = "wanderer"),
	/datum/skill/labor/lumberjacking = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "wanderer"),

	/datum/skill/magic/holy = list("action" = /datum/erp_action/other/mouth/cunnilingus, "passive" = "wanderer"),
	/datum/skill/magic/arcane = list("action" = /datum/erp_action/other/mouth/breast_feed, "passive" = "wanderer"),

	/datum/skill/misc/climbing = list("action" = /datum/erp_action/other/body/rubbing, "passive" = "actor"),
	/datum/skill/misc/reading = list("action" = /datum/erp_action/other/vagina/force_face, "passive" = "actor"),
	/datum/skill/misc/stealing = list("action" = /datum/erp_action/other/vagina/face, "passive" = "actor"),
	/datum/skill/misc/sneaking = list("action" = /datum/erp_action/other/hands/force_crotch, "passive" = "actor"),
	/datum/skill/misc/lockpicking = list("action" = /datum/erp_action/other/hands/tease_vagina, "passive" = "wanderer"),
	/datum/skill/misc/riding = list("action" = /datum/erp_action/other/anus/force_face, "passive" = "wanderer"),
	/datum/skill/misc/medicine = list("action" = /datum/erp_action/other/mouth/finger_lick, "passive" = "actor"),
	/datum/skill/misc/tracking = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "wanderer"),

	/datum/skill/craft/crafting = list("action" = /datum/erp_action/other/breasts/breast_feed, "passive" = "actor"),
	/datum/skill/craft/weaponsmithing = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "actor"),
	/datum/skill/craft/armorsmithing = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "actor"),
	/datum/skill/craft/blacksmithing = list("action" = /datum/erp_action/other/anus/butt, "passive" = "wanderer"),
	/datum/skill/craft/smelting = list("action" = /datum/erp_action/other/penis/rubbing, "passive" = "actor"),
	/datum/skill/craft/carpentry = list("action" = /datum/erp_action/other/vagina/rubbing, "passive" = "actor"),
	/datum/skill/craft/masonry = list("action" = /datum/erp_action/other/anus/rubbing, "passive" = "actor"),
	/datum/skill/craft/traps = list("action" = /datum/erp_action/other/anus/face, "passive" = "actor"),
	/datum/skill/craft/engineering = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "wanderer"),
	/datum/skill/craft/cooking = list("action" = /datum/erp_action/other/mouth/kiss, "passive" = "wanderer"),
	/datum/skill/craft/sewing = list("action" = /datum/erp_action/other/hands/rubbing, "passive" = "wanderer"),
	/datum/skill/craft/tanning = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "actor"),
	/datum/skill/craft/ceramics = list("action" = /datum/erp_action/other/hands/breasts_play, "passive" = "wanderer"),
	/datum/skill/craft/alchemy = list("action" = /datum/erp_action/other/hands/milking_penis, "passive" = "wanderer"),

	/datum/skill/combat/knives = list("action" = /datum/erp_action/other/penis/masturbation, "passive" = "actor"),
	/datum/skill/combat/swords = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "wanderer"),
	/datum/skill/combat/polearms = list("action" = /datum/erp_action/other/hands/toy_vaginal, "passive" = "wanderer"),
	/datum/skill/combat/maces = list("action" = /datum/erp_action/other/legs/footjob, "passive" = "wanderer"),
	/datum/skill/combat/axes = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "wanderer"),
	/datum/skill/combat/whipsflails = list("action" = /datum/erp_action/other/hands/tease_testicles, "passive" = "wanderer"),
	/datum/skill/combat/wrestling = list("action" = /datum/erp_action/other/hands/finger_anal, "passive" = "wanderer"),
	/datum/skill/combat/unarmed = list("action" = /datum/erp_action/other/hands/finger_vaginal, "passive" = "wanderer"),
	/datum/skill/combat/shields = list("action" = /datum/erp_action/other/breasts/teasing, "passive" = "actor"),
	/datum/skill/combat/staves = list("action" = /datum/erp_action/other/legs/teasing, "passive" = "actor"),
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
#define WANDERER_BALLOON_COOLDOWN        (0.5 SECONDS)
#define WANDERER_INPUT_PUNCH             1
#define WANDERER_INPUT_KICK              2
#define WANDERER_INPUT_GRAB              3
#define WANDERER_STANCE_PROC             1
#define WANDERER_STANCE_PRECISE          2
#define WANDERER_BUTTON_SWITCH_STANCE    101
#define WANDERER_BUTTON_EROTIC_EMBRACE   102
#define WANDERER_EMBRACE_TRAIT_SOURCE    "wanderer_embrace"

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

	for(var/skill_type as anything in GLOB.wanderer_erp_training_map)
		var/list/entry = GLOB.wanderer_erp_training_map[skill_type]
		if(!islist(entry))
			continue
		if(entry["action"] == A.type)
			return list(
				"skill" = skill_type,
				"passive" = entry["passive"],
			)

	return null

/datum/erp_scene_effects/proc/apply_training(list/active_links)
	if(!controller)
		return

	var/list/wanderers = list()

	var/datum/component/combo_core/wanderer/W = controller.owner?.physical?.GetComponent(/datum/component/combo_core/wanderer)
	if(W && W.erotic_embrace_enabled)
		wanderers += W

	W = controller.active_partner?.physical?.GetComponent(/datum/component/combo_core/wanderer)
	if(W && W.erotic_embrace_enabled)
		wanderers += W

	if(!length(wanderers))
		return

	for(var/datum/component/combo_core/wanderer/current_wanderer as anything in wanderers)
		var/mob/living/wanderer_mob = current_wanderer.owner
		if(!wanderer_mob)
			continue

		for(var/datum/erp_sex_link/L in active_links)
			if(!L || QDELETED(L) || !L.is_valid())
				continue

			var/list/entry = wanderer_erp_get_training_entry(L.action)
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

			receiver.mind.add_sleep_experience(skill_type, 2, FALSE)

/datum/component/combo_core/wanderer
	parent_type = /datum/component/combo_core/combat_style
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/current_stance = WANDERER_STANCE_PROC
	var/erotic_embrace_enabled = FALSE

	var/combo_stacks = 0
	var/max_combo_stacks = WANDERER_MAX_COMBO_STACKS

	var/arousal_stacks = 0
	var/max_arousal_stacks = WANDERER_MAX_AROUSAL_STACKS

	var/last_action_success = FALSE
	var/last_action_skill = 0
	var/last_action_zone = BODY_ZONE_CHEST
	var/mob/living/last_action_target = null

	var/last_finisher_success = FALSE
	var/last_matched_rule = null

	var/list/granted_spells = list()
	var/spells_granted = FALSE

	var/last_balloon_at = 0

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

/datum/component/combo_core/wanderer/DefineRules()
	RegisterRule("heel_tap",      list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_PUNCH, WANDERER_INPUT_PUNCH), 45, PROC_REF(_cb_combo))
	RegisterRule("needle_thread", list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_PUNCH, WANDERER_INPUT_KICK),  50, PROC_REF(_cb_combo))
	RegisterRule("double_strike", list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_PUNCH, WANDERER_INPUT_GRAB),  55, PROC_REF(_cb_combo))
	RegisterRule("low_pressure",  list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_KICK,  WANDERER_INPUT_PUNCH), 50, PROC_REF(_cb_combo))
	RegisterRule("iron_bloom",    list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_KICK,  WANDERER_INPUT_KICK),  55, PROC_REF(_cb_combo))
	RegisterRule("leg_hook",      list(WANDERER_INPUT_PUNCH, WANDERER_INPUT_KICK,  WANDERER_INPUT_GRAB),  60, PROC_REF(_cb_combo))
	RegisterRule("triple_strike", list(WANDERER_INPUT_KICK,  WANDERER_INPUT_PUNCH, WANDERER_INPUT_PUNCH), 50, PROC_REF(_cb_combo))
	RegisterRule("breaker_kicks", list(WANDERER_INPUT_KICK,  WANDERER_INPUT_PUNCH, WANDERER_INPUT_KICK),  55, PROC_REF(_cb_combo))
	RegisterRule("grip_break",    list(WANDERER_INPUT_KICK,  WANDERER_INPUT_PUNCH, WANDERER_INPUT_GRAB),  60, PROC_REF(_cb_combo))
	RegisterRule("body_lock",     list(WANDERER_INPUT_KICK,  WANDERER_INPUT_KICK,  WANDERER_INPUT_PUNCH), 50, PROC_REF(_cb_combo))
	RegisterRule("gatebreaker",   list(WANDERER_INPUT_KICK,  WANDERER_INPUT_KICK,  WANDERER_INPUT_KICK),  55, PROC_REF(_cb_combo))
	RegisterRule("crane_fold",    list(WANDERER_INPUT_KICK,  WANDERER_INPUT_KICK,  WANDERER_INPUT_GRAB),  60, PROC_REF(_cb_combo))

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

/datum/component/combo_core/wanderer/proc/OnAttachApplyHiddenStats()
	var/mob/living/H = owner
	if(!H)
		return

	ADD_TRAIT(H, TRAIT_KEENEARS, type)
	ADD_TRAIT(H, TRAIT_GOODLOVER, type)
	ADD_TRAIT(H, TRAIT_EMPATH, type)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, type)
	ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, type)

	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_WIL, 4)
	H.change_stat(STATKEY_CON, 6)

	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/music, 5, TRUE)

/datum/component/combo_core/wanderer/proc/OnDetachClearHiddenStats()
	var/mob/living/H = owner
	if(!H)
		return

	REMOVE_TRAIT(H, TRAIT_KEENEARS, type)
	REMOVE_TRAIT(H, TRAIT_GOODLOVER, type)
	REMOVE_TRAIT(H, TRAIT_EMPATH, type)
	REMOVE_TRAIT(H, TRAIT_NOPAINSTUN, type)
	REMOVE_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, type)

	H.change_stat(STATKEY_STR, -3)
	H.change_stat(STATKEY_SPD, -2)
	H.change_stat(STATKEY_WIL, -4)
	H.change_stat(STATKEY_CON, -6)

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
	if(!owner || !target)
		return
	if(!owner.cmode)
		return

	last_action_success = TRUE
	last_action_skill = skill_id
	last_action_zone = zone || BODY_ZONE_CHEST
	last_action_target = target
	last_finisher_success = FALSE
	last_matched_rule = null

	AddComboStack()

	if(erotic_embrace_enabled)
		SEND_SIGNAL(target, COMSIG_SEX_RECEIVE_ACTION, 5, 0, TRUE, 2, 2, null)
		AddArousalStack(1)
	else
		if(current_stance == WANDERER_STANCE_PROC)
			var/procced = ApplyProcPressureOnHit(target, last_action_zone, FALSE)
			if(procced)
				TryNutcrackerProc(target, last_action_zone, skill_id)
		else
			ApplyPreciseOnHit(target, last_action_zone)

	var/fired = RegisterInput(skill_id, target, last_action_zone)
	if(fired)
		_balloon("wanderer combo!")

	if(!erotic_embrace_enabled)
		SpendArousalStack(1)

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
	var/precise = (current_stance == WANDERER_STANCE_PRECISE)
	var/combo_mult = GetComboDamageMultiplier()
	var/base_mult = GetComboBaseDamage(rule_id, precise)
	var/dmg = max(1, round(combo_mult * base_mult))

	target.adjustBruteLoss(dmg)

	if(!erotic_embrace_enabled)
		if(precise)
			ApplyPreciseComboEffect(target, zone_used, last_action_skill, rule_id)
		else
			ApplyProcComboEffect(target, zone_used, rule_id)

	ApplyComboAddon(rule_id, target, zone_used, precise)
	return TRUE

/datum/component/combo_core/wanderer/proc/GetComboBaseDamage(rule_id, precise = FALSE)
	switch(rule_id)
		if("heel_tap")
			return precise ? 0.95 : 1.25
		if("needle_thread")
			return precise ? 1.00 : 1.20
		if("double_strike")
			return precise ? 1.00 : 1.25
		if("low_pressure")
			return precise ? 0.95 : 1.15
		if("iron_bloom")
			return precise ? 1.10 : 1.50
		if("leg_hook")
			return precise ? 0.95 : 1.15
		if("triple_strike")
			return precise ? 1.05 : 1.35
		if("breaker_kicks")
			return precise ? 1.00 : 1.30
		if("grip_break")
			return precise ? 1.00 : 1.20
		if("body_lock")
			return precise ? 1.00 : 1.20
		if("gatebreaker")
			return precise ? 1.10 : 1.75
		if("crane_fold")
			return precise ? 1.05 : 1.35

	return precise ? 1.0 : 1.2

/datum/component/combo_core/wanderer/proc/ApplyPreciseComboEffect(mob/living/target, zone, finisher_skill, rule_id)
	if(!target)
		return

	var/zone_used = TryGetZone(zone)

	switch(zone_used)
		if(BODY_ZONE_HEAD)
			if(finisher_skill == WANDERER_INPUT_PUNCH)
				target.Stun(1.5 SECONDS)
			else
				target.Dizzy(1 SECONDS)

		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				H.drop_all_held_items()

			if(finisher_skill == WANDERER_INPUT_GRAB)
				target.Immobilize(1.5 SECONDS)
			else
				target.Immobilize(0.75 SECONDS)

		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			if(finisher_skill == WANDERER_INPUT_KICK)
				SafeOffbalance(target, 2 SECONDS)
			else
				SafeSlow(target, 1.5)

		if(BODY_ZONE_CHEST)
			target.stamina_add(round(target.max_stamina * 0.12))
			if(finisher_skill == WANDERER_INPUT_GRAB)
				target.Knockdown(1.5 SECONDS)

	datum_component_combo_wanderer_precise_rule_addon(src, target, zone_used, rule_id)

/datum/component/combo_core/wanderer/proc/ApplyProcComboEffect(mob/living/target, zone, rule_id)
	if(!target)
		return

	var/zone_used = TryGetZone(zone)
	var/d = get_dir(owner, target)
	if(!d)
		d = owner.dir

	ApplyProcPressureOnHit(target, zone_used, TRUE)

	switch(zone_used)
		if(BODY_ZONE_HEAD)
			target.stamina_add(round(target.max_stamina * 0.15))
			target.Dizzy(1 SECONDS)

		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			target.Immobilize(1 SECONDS)

		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			SafeOffbalance(target, 1.5 SECONDS)

		if(BODY_ZONE_CHEST)
			target.stamina_add(round(target.max_stamina * 0.18))
			Knockback(target, 1, d, MOVE_FORCE_STRONG)

	datum_component_combo_wanderer_proc_rule_addon(src, target, zone_used, rule_id)

/datum/component/combo_core/wanderer/proc/datum_component_combo_wanderer_precise_rule_addon(datum/component/combo_core/wanderer/C, mob/living/target, zone_used, rule_id)
	if(!C || !target || !rule_id)
		return

	switch(rule_id)
		if("heel_tap")
			if(zone_used == BODY_ZONE_L_LEG || zone_used == BODY_ZONE_R_LEG)
				SafeSlow(target, 1)

		if("needle_thread")
			if(zone_used == BODY_ZONE_L_ARM || zone_used == BODY_ZONE_R_ARM)
				target.Immobilize(0.5 SECONDS)

		if("double_strike")
			if(zone_used == BODY_ZONE_HEAD)
				target.Dizzy(1 SECONDS)

		if("low_pressure")
			if(zone_used == BODY_ZONE_CHEST)
				target.stamina_add(round(target.max_stamina * 0.05))

		if("iron_bloom")
			if(zone_used == BODY_ZONE_CHEST)
				target.stamina_add(round(target.max_stamina * 0.08))

		if("leg_hook")
			if(zone_used == BODY_ZONE_L_LEG || zone_used == BODY_ZONE_R_LEG)
				SafeOffbalance(target, 0.5 SECONDS)

		if("triple_strike")
			target.adjustBruteLoss(1)

		if("breaker_kicks")
			if(zone_used == BODY_ZONE_L_LEG || zone_used == BODY_ZONE_R_LEG)
				SafeSlow(target, 1)

		if("grip_break")
			if(zone_used == BODY_ZONE_L_ARM || zone_used == BODY_ZONE_R_ARM)
				target.Immobilize(1 SECONDS)

		if("body_lock")
			if(zone_used == BODY_ZONE_CHEST)
				target.Knockdown(0.5 SECONDS)

		if("gatebreaker")
			if(zone_used == BODY_ZONE_HEAD)
				target.Dizzy(1.5 SECONDS)

		if("crane_fold")
			if(zone_used == BODY_ZONE_HEAD)
				target.Stun(0.5 SECONDS)
			else if(zone_used == BODY_ZONE_L_LEG || zone_used == BODY_ZONE_R_LEG)
				SafeOffbalance(target, 0.75 SECONDS)

/datum/component/combo_core/wanderer/proc/datum_component_combo_wanderer_proc_rule_addon(datum/component/combo_core/wanderer/C, mob/living/target, zone_used, rule_id)
	if(!C || !target || !rule_id)
		return

	var/d = get_dir(C.owner, target)
	if(!d)
		d = C.owner.dir

	switch(rule_id)
		if("heel_tap")
			if(zone_used == BODY_ZONE_L_LEG || zone_used == BODY_ZONE_R_LEG)
				SafeSlow(target, 1.5)

		if("needle_thread")
			if(zone_used == BODY_ZONE_L_ARM || zone_used == BODY_ZONE_R_ARM)
				target.Immobilize(0.5 SECONDS)

		if("double_strike")
			target.adjustBruteLoss(1)

		if("low_pressure")
			target.stamina_add(round(target.max_stamina * 0.05))

		if("iron_bloom")
			target.stamina_add(round(target.max_stamina * 0.08))

		if("leg_hook")
			if(zone_used == BODY_ZONE_L_LEG || zone_used == BODY_ZONE_R_LEG)
				SafeOffbalance(target, 1 SECONDS)

		if("triple_strike")
			target.adjustBruteLoss(1)

		if("breaker_kicks")
			if(zone_used == BODY_ZONE_L_LEG || zone_used == BODY_ZONE_R_LEG)
				SafeOffbalance(target, 0.75 SECONDS)

		if("grip_break")
			if(zone_used == BODY_ZONE_L_ARM || zone_used == BODY_ZONE_R_ARM)
				target.Immobilize(1 SECONDS)

		if("body_lock")
			if(zone_used == BODY_ZONE_CHEST)
				target.Knockdown(1 SECONDS)

		if("gatebreaker")
			Knockback(target, 1, d, MOVE_FORCE_STRONG)

		if("crane_fold")
			if(zone_used == BODY_ZONE_HEAD)
				target.Stun(1 SECONDS)
			else if(zone_used == BODY_ZONE_L_LEG || zone_used == BODY_ZONE_R_LEG)
				SafeOffbalance(target, 1 SECONDS)

/datum/component/combo_core/wanderer/proc/ApplyComboAddon(rule_id, mob/living/target, zone, precise = FALSE)
	if(!target || !rule_id)
		return

	switch(rule_id)
		if("iron_bloom")
			if(!precise && _get_stamina_pct(target) <= 0.4)
				SafeOffbalance(target, 1 SECONDS)

		if("gatebreaker")
			if(!precise)
				target.stamina_add(round(target.max_stamina * 0.05))

		if("crane_fold")
			if(precise && zone == BODY_ZONE_CHEST)
				target.stamina_add(round(target.max_stamina * 0.05))

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
		return FALSE

	var/chance = guaranteed ? 100 : GetPressureChance()
	if(!prob(chance))
		return FALSE

	ApplyArmorDamageToZone(target, zone, GetPressureDamage())
	return TRUE

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

/datum/component/combo_core/wanderer/proc/GetKickOffbalanceDuration(base_duration = 3 SECONDS)
	var/stacks = clamp(combo_stacks, 0, max_combo_stacks)
	if(stacks <= 0)
		return base_duration

	var/mult = 1 - (stacks * 0.10)
	mult = clamp(mult, 0.35, 1)
	return max(WANDERER_KICK_MIN_RECOVERY, round(base_duration * mult))

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

/datum/component/combo_core/wanderer/proc/ResolveAttackInput(atom/target_atom, obj/item/W)
	if(!owner)
		return 0
	if(W)
		return 0

	if(owner.used_intent)
		var/intent_name = lowertext("[owner.used_intent.name]")
		var/intent_type = lowertext("[owner.used_intent.type]")

		if(findtext(intent_name, "grab") || findtext(intent_type, "grab"))
			return WANDERER_INPUT_GRAB

		if(findtext(intent_name, "kick") || findtext(intent_type, "kick"))
			return WANDERER_INPUT_KICK

	return WANDERER_INPUT_PUNCH

/datum/component/combo_core/wanderer/proc/IsBaseInput(skill_id)
	return (skill_id == WANDERER_INPUT_PUNCH || skill_id == WANDERER_INPUT_KICK || skill_id == WANDERER_INPUT_GRAB)

/datum/component/combo_core/wanderer/proc/_balloon(message)
	if(!owner?.client)
		return
	if(world.time < last_balloon_at + WANDERER_BALLOON_COOLDOWN)
		return

	last_balloon_at = world.time
	owner.balloon_alert(owner, message)

/datum/component/combo_core/wanderer/proc/_balloon_stacks()
	_balloon("wanderer stacks: [combo_stacks]")

/datum/component/combo_core/wanderer/proc/_balloon_arousal()
	_balloon("wanderer arousal: [arousal_stacks]")

/datum/component/combo_core/wanderer/proc/_balloon_stance()
	if(current_stance == WANDERER_STANCE_PROC)
		_balloon("stance: proc")
	else
		_balloon("stance: precise")

/datum/component/combo_core/wanderer/proc/_balloon_embrace()
	if(erotic_embrace_enabled)
		_balloon("embrace: on")
	else
		_balloon("embrace: off")

/datum/component/combo_core/wanderer/proc/TryNutcrackerProc(mob/living/target, zone_precise, rule_id)
	if(!owner || !target)
		return FALSE
	if(current_stance != WANDERER_STANCE_PROC)
		return FALSE
	if(zone_precise != BODY_ZONE_PRECISE_GROIN)
		return FALSE

	var/chance = 35 + (combo_stacks * 10)

	switch(rule_id)
		if("double_strike", "grip_break", "body_lock")
			chance += 10
		if("gatebreaker", "crane_fold")
			chance += 15

	if(!prob(chance))
		return FALSE

	target.emote("groin", TRUE)
	target.Stun(20)

	var/obj/item/bodypart/chest/C = target.get_bodypart(BODY_ZONE_CHEST)
	if(C)
		if(prob(40 + combo_stacks * 5))
			C.add_wound(/datum/wound/cbt)

	return TRUE

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

/obj/effect/proc_holder/spell/self/wanderer/switch_stance
	name = "Switch Stance"
	desc = "Switch between proc stance and precise stance."
	overlay_state = "active_strike"

/obj/effect/proc_holder/spell/self/wanderer/switch_stance/Execute(mob/living/user, datum/component/combo_core/wanderer/C)
	if(!user || !C)
		return

	SEND_SIGNAL(user, COMSIG_COMBO_CORE_REGISTER_INPUT, WANDERER_BUTTON_SWITCH_STANCE, null, null)

/obj/effect/proc_holder/spell/self/wanderer/erotic_embrace
	name = "Erotic Embrace"
	desc = "Preparation / play mode."
	overlay_state = "active_wave"

/obj/effect/proc_holder/spell/self/wanderer/erotic_embrace/Execute(mob/living/user, datum/component/combo_core/wanderer/C)
	if(!user || !C)
		return

	SEND_SIGNAL(user, COMSIG_COMBO_CORE_REGISTER_INPUT, WANDERER_BUTTON_EROTIC_EMBRACE, null, null)

#undef WANDERER_COMBO_WINDOW
#undef WANDERER_MAX_HISTORY
#undef WANDERER_MAX_COMBO_STACKS
#undef WANDERER_MAX_AROUSAL_STACKS
#undef WANDERER_COMBO_DMG_PER_STACK
#undef WANDERER_AROUSAL_DMG_PER_STACK
#undef WANDERER_KICK_MIN_RECOVERY
#undef WANDERER_BALLOON_COOLDOWN
#undef WANDERER_INPUT_PUNCH
#undef WANDERER_INPUT_KICK
#undef WANDERER_INPUT_GRAB
#undef WANDERER_STANCE_PROC
#undef WANDERER_STANCE_PRECISE
#undef WANDERER_BUTTON_SWITCH_STANCE
#undef WANDERER_BUTTON_EROTIC_EMBRACE
#undef WANDERER_EMBRACE_TRAIT_SOURCE
