/datum/component/contractor
	var/mob/living/carbon/human/owner
	var/level = CONTRACTOR_LEVEL_SLEEPING
	var/lux_power = 0
	var/concealment_power = 0
	var/completed_contracts = 0
	var/list/contracts = list()
	var/list/contractees = list()
	var/list/imprinted_targets = list()
	var/true_form = FALSE
	var/true_form_type
	var/tmp/true_form_original_name
	var/tmp/true_form_original_real_name
	var/tmp/true_form_original_color
	var/tmp/true_form_identity_cached = FALSE
	var/tmp/true_form_visual_applied = FALSE
	var/tmp/true_form_filter
	var/tmp/mutable_appearance/true_form_overlay
	var/tmp/true_form_overlay_state
	var/tmp/true_form_suspended = FALSE
	var/tmp/mob/living/carbon/human/species/wildshape/contractor_trueform/true_form_body
	var/tmp/mob/living/carbon/human/true_form_original_body
	var/tmp/true_form_original_invisibility
	var/tmp/true_form_original_status_flags
	var/tmp/next_devotion_drain = 0
	var/tmp/next_seal_decay = 0
	var/tmp/hunger_penalty_applied = 0
	var/tmp/true_form_bonus_applied = FALSE
	var/tmp/true_form_embrace_trait_applied = FALSE
	var/tmp/last_embrace_pulse = 0
	var/tmp/last_embrace_gain = 0
	var/allow_erp_training = FALSE
	var/tmp/entity_erp_training_enabled = FALSE
	var/tmp/last_return_turf
	var/tmp/return_action_expires_at = 0
	var/tmp/evasion_active = FALSE
	var/tmp/exchange_active = FALSE
	var/tmp/invisibility_active = FALSE
	var/tmp/incorporeal_active = FALSE
	var/tmp/old_density
	var/tmp/old_invisibility
	var/tmp/old_alpha
	var/tmp/old_mouse_opacity
	var/tmp/old_pass_flags
	var/tmp/old_movement_type
	var/tmp/evasion_trait_applied = FALSE
	var/tmp/exchange_trait_applied = FALSE
	var/tmp/current_weaving_target
	var/tmp/invisibility_end_time = 0
	var/tmp/evasion_end_time = 0
	var/tmp/exchange_end_time = 0
	var/tmp/incorporeal_end_time = 0

/datum/component/contractor/Initialize(_level = CONTRACTOR_LEVEL_SLEEPING)
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	level = max(CONTRACTOR_LEVEL_SLEEPING, min(CONTRACTOR_LEVEL_COMPLETE, _level))
	ensure_contractor_devotion()
	next_devotion_drain = world.time + 1 MINUTES
	next_seal_decay = world.time + CONTRACTOR_SEAL_DECAY_INTERVAL
	START_PROCESSING(SSprocessing, src)
	if(!istype(owner, /mob/living/carbon/human/species/wildshape/contractor_trueform) && !is_entity_subclass())
		prompt_true_type()
	grant_contractor_actions()
	addtimer(CALLBACK(src, PROC_REF(grant_contractor_actions)), 1 SECONDS)

/datum/component/contractor/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	clear_hunger_penalty()
	end_weaving()
	end_evasion()
	end_exchange()
	end_invisibility()
	end_incorporeal()
	clear_return_to_summon()
	if(true_form)
		set_true_form(FALSE, TRUE)
	clear_true_form_embrace_trait()
	if(istype(owner?.devotion, /datum/devotion/contractor))
		qdel(owner.devotion)
	owner = null
	contracts.Cut()
	contractees.Cut()
	imprinted_targets.Cut()
	return ..()

/datum/component/contractor/process(seconds_per_tick)
	if(QDELETED(owner))
		qdel(src)
		return

	if(true_form_suspended)
		return

	if(!is_entity_subclass())
		if(world.time >= next_devotion_drain)
			handle_devotion_decay()
			next_devotion_drain = world.time + 1 MINUTES

		if(world.time >= next_seal_decay)
			handle_seal_decay()
			next_seal_decay = world.time + CONTRACTOR_SEAL_DECAY_INTERVAL

		apply_hunger_penalties()
	if(invisibility_active)
		refresh_invisibility()
	if(last_return_turf && return_action_expires_at && world.time >= return_action_expires_at)
		clear_return_to_summon(TRUE)
	process_true_form_embrace()
	grant_contractor_actions()

/datum/component/contractor/proc/is_entity_subclass()
	return istype(src, /datum/component/contractor/entity)

/datum/component/contractor/proc/ensure_contractor_devotion()
	if(!owner)
		return FALSE
	if(istype(owner.devotion, /datum/devotion/contractor))
		return TRUE
	if(owner.devotion)
		qdel(owner.devotion)
	new /datum/devotion/contractor(owner)
	return TRUE

/datum/component/contractor/proc/get_devotion_datum()
	ensure_contractor_devotion()
	return owner?.devotion

/datum/component/contractor/proc/get_devotion()
	var/datum/devotion/D = get_devotion_datum()
	return D?.devotion || 0

/datum/component/contractor/proc/adjust_devotion(amount, silent = TRUE)
	var/datum/devotion/D = get_devotion_datum()
	if(!D)
		return FALSE
	D.update_devotion(amount, 0, silent)
	return TRUE

/datum/component/contractor/proc/fill_devotion(silent = TRUE)
	var/datum/devotion/D = get_devotion_datum()
	if(!D)
		return FALSE
	D.update_devotion(D.max_devotion, 0, silent)
	return TRUE

/datum/component/contractor/proc/pay_ability_cost(required_level)
	if(required_level <= CONTRACTOR_LEVEL_SLEEPING)
		return TRUE
	if(is_inside_active_seal())
		return FALSE
	if(get_devotion() <= 0)
		return FALSE
	adjust_devotion(-CONTRACTOR_ABILITY_DEVOTION_COST, TRUE)
	return TRUE

/datum/component/contractor/proc/handle_devotion_decay()
	if(is_inside_active_seal())
		return
	var/decay = CONTRACTOR_DEVOTION_MINUTE_DRAIN
	if(true_form)
		decay += CONTRACTOR_TRUE_FORM_MINUTE_DRAIN
	adjust_devotion(-decay, TRUE)

/datum/component/contractor/proc/apply_hunger_penalties()
	if(get_devotion() > 0)
		clear_hunger_penalty()
		return
	if(hunger_penalty_applied == level)
		return
	clear_hunger_penalty()
	hunger_penalty_applied = level
	if(hunger_penalty_applied <= 0)
		return
	contractor_apply_all_stat_delta(owner, -hunger_penalty_applied)
	if(!true_form && level >= CONTRACTOR_LEVEL_AWAKENED)
		set_true_form(TRUE, TRUE)
	to_chat(owner, span_userdanger("Your starving devotion tears the doll-shell away and hollows your flesh."))

/datum/component/contractor/proc/clear_hunger_penalty()
	if(!hunger_penalty_applied)
		return
	contractor_apply_all_stat_delta(owner, hunger_penalty_applied)
	hunger_penalty_applied = 0

/datum/component/contractor/proc/handle_seal_decay()
	var/atom/seal = contractor_find_nearby_seal(owner)
	if(!seal)
		return
	owner.Immobilize(CONTRACTOR_SEAL_DECAY_INTERVAL + 1 SECONDS)
	contractor_damage_seal(seal, CONTRACTOR_SEAL_BASE_DECAY + (length(contracts) * CONTRACTOR_SEAL_CONTRACT_DECAY))
	contractor_heal_in_seal(owner)
	if(!true_form)
		set_true_form(TRUE, TRUE)

/datum/component/contractor/proc/is_inside_active_seal()
	return !!contractor_find_nearby_seal(owner)

/datum/component/contractor/proc/can_use_contractor_power(mob/user, required_level = CONTRACTOR_LEVEL_SLEEPING, spend_devotion = FALSE, feedback = TRUE)
	if(level < required_level)
		if(feedback && user)
			to_chat(user, span_warning("Your contractor nature is not awake enough for this."))
		return FALSE
	if(is_entity_subclass())
		return TRUE
	
	
	
	if(required_level > CONTRACTOR_LEVEL_SLEEPING && is_inside_active_seal())
		if(feedback && user)
			to_chat(user, span_warning("The seal suppresses your power."))
		return FALSE
	if(get_devotion() <= 0)
		if(feedback && user)
			to_chat(user, span_warning("You are too starved to shape infernal power."))
		return FALSE
	if(spend_devotion && required_level > CONTRACTOR_LEVEL_SLEEPING)
		adjust_devotion(-CONTRACTOR_ABILITY_DEVOTION_COST, TRUE)
	return TRUE

/datum/component/contractor/proc/grant_contractor_actions()
	if(!owner?.mind)
		return FALSE
	if(is_entity_subclass())
		return grant_entity_actions()
	var/list/spells = list(
		/datum/action/cooldown/spell/contractor/status,
		/datum/action/cooldown/spell/contractor/drink_lux,
		/datum/action/cooldown/spell/contractor/offer_contract,
		/datum/action/cooldown/spell/contractor/test_pipeline,
	)
	if(level < CONTRACTOR_LEVEL_COMPLETE)
		spells += /datum/action/cooldown/spell/contractor/test_level_up
	else
		contractor_remove_mind_spell(owner, /datum/action/cooldown/spell/contractor/test_level_up)
	if(level >= CONTRACTOR_LEVEL_AWAKENED)
		spells += /datum/action/cooldown/spell/contractor/change_form
	if(level >= CONTRACTOR_LEVEL_AWARE)
		spells += /datum/action/cooldown/spell/contractor/evasion
		spells += /datum/action/cooldown/spell/contractor/exchange
	if(last_return_turf && (!return_action_expires_at || world.time < return_action_expires_at))
		spells += /datum/action/cooldown/spell/contractor/return_to_summon
	else
		contractor_remove_mind_spell(owner, /datum/action/cooldown/spell/contractor/return_to_summon)
	if(level >= CONTRACTOR_LEVEL_WATCHFUL)
		spells += /datum/action/cooldown/spell/contractor/invisibility
		spells += /datum/action/cooldown/spell/contractor/gift_contractee
		spells += /datum/action/cooldown/spell/contractor/body_change
	if(level >= CONTRACTOR_LEVEL_COMPLETE)
		spells += /datum/action/cooldown/spell/contractor/incorporeal
		spells += /datum/action/cooldown/spell/contractor/paralytic_embrace
	for(var/spell_type in spells)
		contractor_grant_mind_spell_if_missing(owner, spell_type)
	return TRUE

/datum/component/contractor/proc/get_or_create_contractee(mob/living/carbon/human/target)
	var/datum/component/contractee/contractee = get_or_add_contractee(target, src)
	if(contractee && !(contractee in contractees))
		contractees += contractee
	return contractee

/datum/component/contractor/proc/try_drink_lux(atom/target)
	if(!can_use_contractor_power(owner, CONTRACTOR_LEVEL_SLEEPING, FALSE))
		return FALSE
	if(!target)
		return FALSE
	if(ishuman(target))
		return try_drink_mob_lux(target)
	return try_drink_loose_lux(target)

/datum/component/contractor/proc/try_drink_loose_lux(atom/target)
	var/available = contractor_get_loose_lux_amount(target)
	if(available <= 0)
		to_chat(owner, span_warning("There is no loose Lux to drink."))
		return FALSE
	lux_power += available
	to_chat(owner, span_notice("You drink [available] loose Lux. Lux power: [lux_power]."))
	qdel(target)
	return TRUE

/datum/component/contractor/proc/try_drink_mob_lux(mob/living/carbon/human/target)
	var/datum/component/contractee/contractee = get_or_create_contractee(target)
	if(!contractee)
		return FALSE

	if(target.has_status_effect(/datum/status_effect/debuff/devitalised))
		to_chat(owner, span_warning("[target] is already devitalised. Their Lux will not answer again yet."))
		return FALSE

	if(contractee.is_submitted())
		var/devotion_gain = max(0, CONTRACTOR_SUBMITTED_DEVOTION_GAIN - (contractee.lux_drink_count * CONTRACTOR_SUBMITTED_DEVOTION_DECAY))
		var/lux_gain = max(0, CONTRACTOR_SUBMITTED_LUX_POWER_GAIN - (contractee.lux_drink_count * CONTRACTOR_SUBMITTED_LUX_DECAY))
		contractee.on_lux_drunk(0, FALSE)
		if(devotion_gain)
			adjust_devotion(devotion_gain, TRUE)
		if(lux_gain)
			lux_power += lux_gain
		target.apply_status_effect(/datum/status_effect/debuff/devitalised)
		to_chat(owner, span_notice("You drink from your submitted contractee: +[devotion_gain] Devotion, +[lux_gain] Lux power."))
		return TRUE

	if(target.client)
		var/answer = alert(target, "Allow [owner] to drink your Lux and offer an infernal contract?", "Contractor", "Yes", "No")
		if(answer != "Yes")
			return FALSE

	var/requested_amount = CONTRACTOR_MOB_LUX_BASE_POWER + (CONTRACTOR_MOB_LUX_LEVEL_BONUS * level)
	var/drunk_amount = contractor_drain_lux(target, requested_amount)
	if(drunk_amount <= 0)
		drunk_amount = requested_amount
		try_imprint_from(target)

	lux_power += drunk_amount
	contractee.on_lux_drunk(drunk_amount, TRUE)
	adjust_devotion(min(drunk_amount, CONTRACTOR_CONTRACT_DEVOTION_GAIN), TRUE)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised)
	to_chat(owner, span_notice("You drink [drunk_amount] Lux from [target]. Lux power: [lux_power]."))

	open_contract(target)
	return TRUE

/datum/component/contractor/proc/try_imprint_from(mob/living/carbon/human/target)
	if(!target)
		return FALSE
	var/key = "\ref[target]"
	if(key in imprinted_targets)
		return FALSE
	imprinted_targets += key
	contractor_imprint_best_from(owner, target)
	to_chat(owner, span_notice("No devotion yields, so you steal an echo of [target]'s strongest nature."))
	return TRUE

/datum/component/contractor/proc/open_contract(mob/living/carbon/human/target)
	if(!can_use_contractor_power(owner, CONTRACTOR_LEVEL_SLEEPING, FALSE))
		return FALSE
	if(!ishuman(target))
		return FALSE
	var/datum/component/contractee/contractee = get_or_create_contractee(target)
	if(!contractee)
		return FALSE
	var/datum/contractor_contract/contract = new(src, contractee)
	contractee.contracts += contract
	contracts += contract
	contract.ui_interact(target)
	return TRUE

/datum/component/contractor/proc/on_contract_fulfilled(datum/contractor_contract/contract)
	completed_contracts++
	fill_devotion(TRUE)
	update_level_from_contracts()
	grant_contractor_actions()

/datum/component/contractor/proc/update_level_from_contracts()
	var/new_level = CONTRACTOR_LEVEL_SLEEPING
	if(completed_contracts >= 8)
		new_level = CONTRACTOR_LEVEL_COMPLETE
	else if(completed_contracts >= 6)
		new_level = CONTRACTOR_LEVEL_WATCHFUL
	else if(completed_contracts >= 4)
		new_level = CONTRACTOR_LEVEL_AWARE
	else if(completed_contracts >= 2)
		new_level = CONTRACTOR_LEVEL_AWAKENED
	if(new_level <= level)
		return
	level = new_level
	to_chat(owner, span_boldnotice("Your infernal nature rises to level [level]."))
	update_true_form_embrace_trait()
	grant_contractor_actions()

/datum/component/contractor/proc/get_completed_contracts_required_for_level(target_level)
	switch(target_level)
		if(CONTRACTOR_LEVEL_AWAKENED)
			return 2
		if(CONTRACTOR_LEVEL_AWARE)
			return 4
		if(CONTRACTOR_LEVEL_WATCHFUL)
			return 6
		if(CONTRACTOR_LEVEL_COMPLETE)
			return 8
	return 0

/datum/component/contractor/proc/test_level_up(mob/user)
	if(!owner || QDELETED(owner))
		return FALSE
	if(level >= CONTRACTOR_LEVEL_COMPLETE)
		contractor_remove_mind_spell(owner, /datum/action/cooldown/spell/contractor/test_level_up)
		to_chat(user || owner, span_notice("Contractor test level-up is no longer needed: maximum level reached."))
		return FALSE
	var/old_level = level
	var/next_level = min(CONTRACTOR_LEVEL_COMPLETE, level + 1)
	completed_contracts = max(completed_contracts, get_completed_contracts_required_for_level(next_level))
	update_level_from_contracts()
	grant_contractor_actions()
	to_chat(user || owner, span_boldnotice("TEST: contractor level [old_level] -> [level]. Completed contracts set to [completed_contracts]."))
	to_chat(user || owner, span_notice("TEST: abilities refreshed; devotion costs and level locks can now be checked from the Contractor panel."))
	if(level >= CONTRACTOR_LEVEL_COMPLETE)
		contractor_remove_mind_spell(owner, /datum/action/cooldown/spell/contractor/test_level_up)
	return TRUE

/datum/component/contractor/proc/test_self_contract_pipeline(mob/user)
	if(!owner || QDELETED(owner))
		return FALSE
	if(!can_use_contractor_power(owner, CONTRACTOR_LEVEL_SLEEPING, FALSE))
		return FALSE
	var/datum/component/contractee/contractee = get_or_create_contractee(owner)
	if(!contractee)
		return FALSE
	var/generated_lux = CONTRACTOR_MOB_LUX_BASE_POWER + (CONTRACTOR_MOB_LUX_LEVEL_BONUS * level)
	lux_power += generated_lux
	contractee.on_lux_drunk(generated_lux, TRUE)
	adjust_devotion(min(generated_lux, CONTRACTOR_CONTRACT_DEVOTION_GAIN), TRUE)
	owner.apply_status_effect(/datum/status_effect/debuff/devitalised)
	owner.visible_message(span_warning("[owner] kisses themself, drawing a bright thread of Lux into an infernal contract."), span_notice("TEST: You kiss yourself, generate [generated_lux] Lux, apply the devitalised debuff, and start a self-contract."))
	return open_contract(owner)

/datum/component/contractor/proc/toggle_form()
	return set_true_form(!true_form)


/datum/component/contractor/proc/set_true_form(enabled, forced = FALSE)
	if(enabled == true_form)
		return TRUE
	if(!owner || QDELETED(owner))
		return FALSE
	if(!enabled && !forced && get_devotion() <= 0)
		to_chat(owner, span_warning("You are too starved to hide your true form."))
		return FALSE
	if(enabled && !forced && !can_use_contractor_power(owner, CONTRACTOR_LEVEL_AWAKENED, FALSE))
		return FALSE
	if(enabled && !ensure_true_form_type(!forced))
		return FALSE
	if(enabled)
		return enter_true_form_body(forced)
	return exit_true_form_body(forced)

/datum/component/contractor/proc/enter_true_form_body(forced = FALSE)
	if(true_form)
		return TRUE
	if(!owner || QDELETED(owner) || !owner.mind)
		return FALSE
	if(istype(owner, /mob/living/carbon/human/species/wildshape/contractor_trueform))
		true_form = TRUE
		cache_true_form_identity()
		apply_true_form_visuals()
		update_true_form_embrace_trait()
		if(!true_form_bonus_applied)
			contractor_apply_all_stat_delta(owner, 1)
			contractor_apply_all_skill_delta(owner, 1)
			true_form_bonus_applied = TRUE
		return TRUE

	var/mob/living/carbon/human/original = owner
	var/turf/start_turf = get_turf(original)
	if(!start_turf)
		return FALSE

	var/mob/living/carbon/human/species/wildshape/contractor_trueform/body = new /mob/living/carbon/human/species/wildshape/contractor_trueform(start_turf)
	if(!body || QDELETED(body))
		return FALSE

	body.stored_mob = original
	body.gender = original.gender
	body.name = original.name
	body.real_name = original.real_name
	body.dir = original.dir
	body.pixel_x = CONTRACTOR_TRUE_FORM_PIXEL_X
	body.pixel_y = CONTRACTOR_TRUE_FORM_PIXEL_Y
	body.set_patron(original.patron)
	body.regenerate_icons()
	body.after_creation()
	
	
	body.regenerate_icons()

	true_form_original_invisibility = original.invisibility
	true_form_original_status_flags = original.status_flags
	true_form_body = body
	true_form = TRUE
	true_form_suspended = TRUE

	ADD_TRAIT(original, TRAIT_NOSLEEP, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	ADD_TRAIT(original, TRAIT_NOBREATH, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	ADD_TRAIT(original, TRAIT_NOPAIN, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	ADD_TRAIT(original, TRAIT_TOXIMMUNE, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	ADD_TRAIT(original, TRAIT_NOHUNGER, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	ADD_TRAIT(original, TRAIT_NOMOOD, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	original.status_flags |= GODMODE
	original.invisibility = INVISIBILITY_MAXIMUM
	original.forceMove(body)

	var/datum/mind/original_mind = original.mind
	original_mind.transfer_to(body)

	var/datum/component/contractor/body_core = body.GetComponent(/datum/component/contractor)
	if(!body_core)
		body_core = body.AddComponent(src.type, level)
	if(!body_core)
		original_mind.transfer_to(original)
		original.forceMove(start_turf)
		restore_original_body_after_true_form(original)
		qdel(body)
		true_form = FALSE
		true_form_suspended = FALSE
		true_form_body = null
		return FALSE

	copy_contractor_state_to(body_core)
	body_core.owner = body
	body_core.true_form = TRUE
	body_core.true_form_suspended = FALSE
	body_core.true_form_original_body = original
	body_core.true_form_original_invisibility = true_form_original_invisibility
	body_core.true_form_original_status_flags = true_form_original_status_flags
	body_core.true_form_body = null
	body_core.update_true_form_embrace_trait()
	if(!body_core.true_form_bonus_applied)
		contractor_apply_all_stat_delta(body, 1)
		contractor_apply_all_skill_delta(body, 1)
		body_core.true_form_bonus_applied = TRUE
	body_core.sync_devotion_from(src)
	body_core.grant_contractor_actions()
	addtimer(CALLBACK(body_core, PROC_REF(grant_contractor_actions)), 1)

	to_chat(body, span_userdanger("Your true form blooms through the shell."))
	return TRUE

/datum/component/contractor/proc/exit_true_form_body(forced = FALSE)
	if(!true_form)
		return TRUE

	if(true_form_body && !QDELETED(true_form_body))
		var/datum/component/contractor/body_core = true_form_body.GetComponent(/datum/component/contractor)
		if(body_core)
			return body_core.exit_true_form_body(forced)

	if(!istype(owner, /mob/living/carbon/human/species/wildshape/contractor_trueform))
		true_form = FALSE
		true_form_suspended = FALSE
		clear_true_form_embrace_trait()
		if(true_form_bonus_applied)
			contractor_apply_all_skill_delta(owner, -1)
			contractor_apply_all_stat_delta(owner, -1)
			true_form_bonus_applied = FALSE
		remove_true_form_visuals()
		restore_true_form_identity()
		if(!forced)
			to_chat(owner, span_notice("You fold yourself back into the doll-shell."))
		return TRUE

	var/mob/living/carbon/human/species/wildshape/contractor_trueform/body = owner
	var/mob/living/carbon/human/original = true_form_original_body || body.stored_mob
	if(!original || QDELETED(original) || !body.mind)
		return FALSE

	var/datum/component/contractor/original_core = original.GetComponent(/datum/component/contractor)
	if(!original_core)
		original_core = original.AddComponent(src.type, level)
	if(!original_core)
		return FALSE

	if(true_form_bonus_applied)
		contractor_apply_all_skill_delta(body, -1)
		contractor_apply_all_stat_delta(body, -1)
		true_form_bonus_applied = FALSE
	clear_true_form_embrace_trait()

	copy_contractor_state_to(original_core)
	sync_devotion_to(original_core)

	var/turf/exit_turf = get_turf(body)
	if(!exit_turf)
		exit_turf = get_turf(original)

	restore_original_body_after_true_form(original)
	original.forceMove(exit_turf)

	var/datum/mind/current_mind = body.mind
	current_mind.transfer_to(original)

	original_core.owner = original
	original_core.true_form = FALSE
	original_core.true_form_suspended = FALSE
	original_core.true_form_body = null
	original_core.true_form_original_body = null
	original_core.clear_true_form_embrace_trait()
	original_core.grant_contractor_actions()
	addtimer(CALLBACK(original_core, PROC_REF(grant_contractor_actions)), 1)

	true_form = FALSE
	true_form_suspended = TRUE
	true_form_original_body = null
	body.stored_mob = null
	body.invisibility = INVISIBILITY_MAXIMUM
	body.icon = null

	if(!forced)
		to_chat(original, span_notice("You fold yourself back into the doll-shell."))
	playsound(get_turf(original), 'sound/body/shapeshift-end.ogg', 80, FALSE, 3)
	qdel(body)
	return TRUE

/datum/component/contractor/proc/restore_original_body_after_true_form(mob/living/carbon/human/original)
	if(!original || QDELETED(original))
		return FALSE
	REMOVE_TRAIT(original, TRAIT_NOSLEEP, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	REMOVE_TRAIT(original, TRAIT_NOBREATH, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	REMOVE_TRAIT(original, TRAIT_NOPAIN, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	REMOVE_TRAIT(original, TRAIT_TOXIMMUNE, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	REMOVE_TRAIT(original, TRAIT_NOHUNGER, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	REMOVE_TRAIT(original, TRAIT_NOMOOD, CONTRACTOR_TRUE_FORM_TRAIT_SOURCE)
	original.status_flags &= ~GODMODE
	if(!isnull(true_form_original_invisibility))
		original.invisibility = true_form_original_invisibility
	if(!isnull(true_form_original_status_flags))
		original.status_flags = true_form_original_status_flags
	original.regenerate_icons()
	return TRUE

/datum/component/contractor/proc/copy_contractor_state_to(datum/component/contractor/target)
	if(!target)
		return FALSE
	target.level = level
	target.lux_power = lux_power
	target.completed_contracts = completed_contracts
	target.true_form_type = true_form_type
	target.last_return_turf = last_return_turf
	target.return_action_expires_at = return_action_expires_at
	target.entity_erp_training_enabled = entity_erp_training_enabled
	target.contracts = contracts.Copy()
	target.contractees = contractees.Copy()
	target.imprinted_targets = imprinted_targets.Copy()
	target.next_devotion_drain = next_devotion_drain
	target.next_seal_decay = next_seal_decay
	return TRUE

/datum/component/contractor/proc/sync_devotion_from(datum/component/contractor/source)
	if(!source)
		return FALSE
	var/datum/devotion/source_devotion = source.get_devotion_datum()
	var/datum/devotion/target_devotion = get_devotion_datum()
	if(!source_devotion || !target_devotion)
		return FALSE
	target_devotion.max_devotion = source_devotion.max_devotion
	target_devotion.devotion = source_devotion.devotion
	return TRUE

/datum/component/contractor/proc/sync_devotion_to(datum/component/contractor/target)
	if(!target)
		return FALSE
	return target.sync_devotion_from(src)

/datum/component/contractor/proc/ensure_true_form_type(allow_prompt = TRUE)
	true_form_type = contractor_normalize_true_form_type(true_form_type)
	if(length(true_form_type))
		return TRUE
	if(!allow_prompt)
		return FALSE
	return prompt_true_type()

/datum/component/contractor/proc/prompt_true_type()
	true_form_type = contractor_normalize_true_form_type(true_form_type)
	if(!owner?.client)
		return length(true_form_type) > 0
	var/list/valid_cats = list("Normal", "Red", "Purple", "Albino")
	var/selection = tgui_input_list(owner, "Choose a true form type:", "True Form", valid_cats)
	if(selection)
		true_form_type = contractor_normalize_true_form_type(selection)
	return length(true_form_type) > 0

/datum/component/contractor/proc/cache_true_form_identity()
	if(true_form_identity_cached || !owner)
		return FALSE
	true_form_original_name = owner.name
	true_form_original_real_name = owner.real_name
	true_form_original_color = owner.color
	true_form_identity_cached = TRUE
	return TRUE

/datum/component/contractor/proc/apply_true_form_identity()
	return TRUE

/datum/component/contractor/proc/restore_true_form_identity()
	if(!owner || !true_form_identity_cached)
		clear_true_form_identity_cache()
		return FALSE
	if(!isnull(true_form_original_name))
		owner.name = true_form_original_name
	if(!isnull(true_form_original_real_name))
		owner.real_name = true_form_original_real_name
	owner.color = true_form_original_color
	clear_true_form_identity_cache()
	return TRUE

/datum/component/contractor/proc/clear_true_form_identity_cache()
	true_form_original_name = null
	true_form_original_real_name = null
	true_form_original_color = null
	true_form_identity_cached = FALSE
	return TRUE

/datum/component/contractor/proc/apply_true_form_visuals()
	if(!owner || true_form_visual_applied)
		return FALSE
	true_form_visual_applied = TRUE
	apply_true_form_fallback_visuals()
	return TRUE

/datum/component/contractor/proc/apply_true_form_overlay()
	return FALSE

/datum/component/contractor/proc/apply_true_form_fallback_visuals()
	if(!owner)
		return FALSE
	owner.color = CONTRACTOR_TRUE_FORM_COLOR
	true_form_filter = filter(type="outline", size=CONTRACTOR_TRUE_FORM_FILTER_SIZE, color=CONTRACTOR_TRUE_FORM_OUTLINE)
	if(!owner.filters)
		owner.filters = list()
	owner.filters += true_form_filter
	return TRUE

/datum/component/contractor/proc/remove_true_form_visuals()
	if(!owner || !true_form_visual_applied)
		true_form_filter = null
		true_form_overlay = null
		true_form_overlay_state = null
		true_form_visual_applied = FALSE
		return FALSE

	if(true_form_overlay)
		owner.cut_overlay(true_form_overlay)
		true_form_overlay = null
		true_form_overlay_state = null

	if(true_form_filter)
		owner.filters -= true_form_filter
	true_form_filter = null
	true_form_visual_applied = FALSE
	return TRUE

/datum/component/contractor/proc/update_true_form_visuals()
	return FALSE

/datum/component/contractor/proc/get_true_form_icon_state()
	return CONTRACTOR_TRUE_FORM_ICON_STATE

/datum/component/contractor/proc/is_true_form_active()
	return true_form && owner && !QDELETED(owner)


/datum/component/contractor/proc/get_true_form_examine_text(mob/user)
	if(!owner || QDELETED(owner))
		return null
	if(is_true_form_active())
		trigger_true_form_examine_embrace(user)
		return span_userdanger("There is no mortal soul behind [owner.p_their()] gaze. This is a demonic entity wearing flesh like a promise.")
	return null

/datum/component/contractor/proc/can_true_form_examine_embrace()
	if(is_entity_subclass())
		return FALSE
	return is_true_form_active() && level >= CONTRACTOR_LEVEL_WATCHFUL

/datum/component/contractor/proc/can_true_form_pulse_embrace()
	if(is_entity_subclass())
		return FALSE
	return is_true_form_active() && level >= CONTRACTOR_LEVEL_COMPLETE

/datum/component/contractor/proc/can_contractor_train_erp()
	if(is_entity_subclass())
		return allow_erp_training && entity_erp_training_enabled
	return allow_erp_training && is_true_form_active()

/datum/component/contractor/proc/update_true_form_embrace_trait()
	if(!owner || is_entity_subclass())
		clear_true_form_embrace_trait()
		return FALSE
	if(is_true_form_active() && level >= CONTRACTOR_LEVEL_WATCHFUL)
		if(!true_form_embrace_trait_applied)
			ADD_TRAIT(owner, TRAIT_DODGEEXPERT, CONTRACTOR_EMBRACE_TRAIT_SOURCE)
			true_form_embrace_trait_applied = TRUE
		return TRUE
	clear_true_form_embrace_trait()
	return FALSE

/datum/component/contractor/proc/clear_true_form_embrace_trait()
	if(owner && true_form_embrace_trait_applied)
		REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, CONTRACTOR_EMBRACE_TRAIT_SOURCE)
	true_form_embrace_trait_applied = FALSE
	return TRUE

/datum/component/contractor/proc/process_true_form_embrace()
	if(!owner || !can_true_form_pulse_embrace())
		return FALSE
	if(world.time < last_embrace_pulse + CONTRACTOR_EMBRACE_PULSE_CD)
		return FALSE

	last_embrace_pulse = world.time

	var/list/targets = list()
	for(var/mob/living/M in view(CONTRACTOR_EMBRACE_RANGE, owner))
		if(M == owner)
			continue
		if(M.stat == DEAD)
			continue
		targets += M

	if(!length(targets))
		return FALSE

	var/strong_pulse = world.time >= last_embrace_gain + CONTRACTOR_EMBRACE_GAIN_CD
	for(var/mob/living/M as anything in targets)
		SEND_SIGNAL(M, COMSIG_SEX_RECEIVE_ACTION, strong_pulse ? 2 : 1, 0, TRUE, 1, 1, null)

	if(strong_pulse)
		last_embrace_gain = world.time
		trigger_true_form_self_arousal()

	return TRUE

/datum/component/contractor/proc/trigger_true_form_examine_embrace(mob/living/user)
	if(!can_true_form_examine_embrace())
		return FALSE
	if(!isliving(user) || user == owner)
		return FALSE
	if(world.time < last_embrace_gain + CONTRACTOR_EMBRACE_GAIN_CD)
		return FALSE

	SEND_SIGNAL(user, COMSIG_SEX_RECEIVE_ACTION, 6, 0, TRUE, 2, 2, null)
	trigger_true_form_self_arousal()
	last_embrace_gain = world.time
	return TRUE

/datum/component/contractor/proc/trigger_true_form_self_arousal()
	if(!owner)
		return FALSE
	if(ishuman(owner))
		return contractor_add_arousal(owner, 1, CONTRACTOR_EMBRACE_GAIN_CD)
	SEND_SIGNAL(owner, COMSIG_SEX_RECEIVE_ACTION, 1, 0, TRUE, 1, 1, null)
	return TRUE

/datum/component/contractor/entity
	entity_erp_training_enabled = FALSE

/datum/component/contractor/entity/ensure_contractor_devotion()
	return FALSE

/datum/component/contractor/entity/get_devotion_datum()
	return null

/datum/component/contractor/entity/get_devotion()
	return CONTRACTOR_DEFAULT_MAX_DEVOTION

/datum/component/contractor/entity/adjust_devotion(amount, silent = TRUE)
	return TRUE

/datum/component/contractor/entity/fill_devotion(silent = TRUE)
	return TRUE

/datum/component/contractor/entity/pay_ability_cost(required_level)
	return TRUE

/datum/component/contractor/entity/handle_devotion_decay()
	return FALSE

/datum/component/contractor/entity/apply_hunger_penalties()
	return FALSE

/datum/component/contractor/entity/handle_seal_decay()
	return FALSE

/datum/component/contractor/entity/is_inside_active_seal()
	return FALSE

/datum/component/contractor/entity/get_or_create_contractee(mob/living/carbon/human/target)
	return null

/datum/component/contractor/entity/try_drink_lux(atom/target)
	return FALSE

/datum/component/contractor/entity/try_drink_loose_lux(atom/target)
	return FALSE

/datum/component/contractor/entity/try_drink_mob_lux(mob/living/carbon/human/target)
	return FALSE

/datum/component/contractor/entity/test_self_contract_pipeline(mob/user)
	return FALSE

/datum/component/contractor/entity/open_contract(mob/living/carbon/human/target)
	return FALSE

/datum/component/contractor/entity/prepare_gift(mob/living/carbon/human/target)
	return FALSE

/datum/component/contractor/proc/grant_entity_actions()
	if(!owner?.mind)
		return FALSE
	var/list/remove_spells = list(
		/datum/action/cooldown/spell/contractor/status,
		/datum/action/cooldown/spell/contractor/drink_lux,
		/datum/action/cooldown/spell/contractor/offer_contract,
		/datum/action/cooldown/spell/contractor/test_pipeline,
		/datum/action/cooldown/spell/contractor/test_level_up,
		/datum/action/cooldown/spell/contractor/return_to_summon,
		/datum/action/cooldown/spell/contractor/change_form,
		/datum/action/cooldown/spell/contractor/evasion,
		/datum/action/cooldown/spell/contractor/exchange,
		/datum/action/cooldown/spell/contractor/invisibility,
		/datum/action/cooldown/spell/contractor/gift_contractee,
		/datum/action/cooldown/spell/contractor/body_change,
		/datum/action/cooldown/spell/contractor/incorporeal,
		/datum/action/cooldown/spell/contractor/paralytic_embrace,
	)
	for(var/spell_type in remove_spells)
		contractor_remove_mind_spell(owner, spell_type)
	contractor_grant_mind_spell_if_missing(owner, /datum/action/cooldown/spell/contractor/entity_training_toggle)
	contractor_grant_mind_spell_if_missing(owner, /datum/action/cooldown/spell/contractor/entity_body_change)
	return TRUE

/datum/component/contractor/proc/show_status(mob/user)
	if(!user)
		return FALSE
	to_chat(user, span_notice("----- Contractor -----"))
	var/datum/devotion/D = get_devotion_datum()
	to_chat(user, span_notice("Level: [level] / [CONTRACTOR_LEVEL_COMPLETE]"))
	to_chat(user, span_notice("Devotion: [D ? D.devotion : 0]/[D ? D.max_devotion : CONTRACTOR_DEFAULT_MAX_DEVOTION]"))
	to_chat(user, span_notice("Lux Power: [lux_power]"))
	to_chat(user, span_notice("Completed Contracts: [completed_contracts]"))
	to_chat(user, span_notice("Active Contracts: [length(contracts)]"))
	to_chat(user, span_notice("Contractees: [length(contractees)]"))
	return TRUE

/datum/component/contractor/proc/get_active_power_text()
	var/list/powers = list()
	if(evasion_active)
		powers += "evasion"
	if(exchange_active)
		powers += "exchange"
	if(invisibility_active)
		powers += "invisibility"
	if(incorporeal_active)
		powers += "incorporeal"
	if(!length(powers))
		return "none"
	return jointext(powers, ", ")

/datum/component/contractor/proc/get_contractor_effect_duration(required_level)
	var/effective_level = max(level, required_level)
	return CONTRACTOR_EFFECT_BASE_DURATION + (effective_level * CONTRACTOR_EFFECT_LEVEL_DURATION)

/datum/component/contractor/proc/apply_contractor_buff(effect_type, duration)
	if(!owner || !effect_type)
		return FALSE
	owner.apply_status_effect(effect_type, duration)
	return TRUE

/datum/component/contractor/proc/clear_contractor_buff(effect_type)
	if(!owner || !effect_type)
		return FALSE
	owner.remove_status_effect(effect_type)
	return TRUE

/datum/component/contractor/proc/start_evasion()
	if(evasion_active)
		return FALSE
	var/duration = get_contractor_effect_duration(CONTRACTOR_LEVEL_AWARE)
	evasion_active = TRUE
	evasion_end_time = world.time + duration
	if(owner)
		ADD_TRAIT(owner, TRAIT_DODGEEXPERT, CONTRACTOR_TRAIT_SOURCE)
		evasion_trait_applied = TRUE
		RegisterSignal(owner, COMSIG_MOB_DODGE_SUCCESS, PROC_REF(_sig_evasion_dodge_success))
		apply_contractor_buff(/datum/status_effect/buff/contractor_evasion, duration)
	to_chat(owner, span_notice("Your body is ready to slip behind attackers for [round(duration / 10)] seconds."))
	addtimer(CALLBACK(src, PROC_REF(end_evasion_at), evasion_end_time), duration)
	return TRUE

/datum/component/contractor/proc/end_evasion_at(expected_end_time)
	if(evasion_end_time != expected_end_time)
		return TRUE
	return end_evasion()

/datum/component/contractor/proc/end_evasion()
	if(!evasion_active && !evasion_trait_applied)
		return TRUE
	evasion_active = FALSE
	evasion_end_time = 0
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_DODGE_SUCCESS)
		clear_contractor_buff(/datum/status_effect/buff/contractor_evasion)
		if(evasion_trait_applied)
			REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, CONTRACTOR_TRAIT_SOURCE)
	evasion_trait_applied = FALSE
	return TRUE

/datum/component/contractor/proc/_sig_evasion_dodge_success(datum/source, mob/living/attacker, turf/dodge_turf)
	SIGNAL_HANDLER
	if(!evasion_active || !owner || !attacker || attacker.stat == DEAD)
		return
	INVOKE_ASYNC(src, PROC_REF(teleport_behind), attacker)

/datum/component/contractor/proc/start_exchange()
	if(exchange_active)
		return FALSE
	var/duration = get_contractor_effect_duration(CONTRACTOR_LEVEL_AWARE)
	exchange_active = TRUE
	exchange_end_time = world.time + duration
	if(owner)
		ADD_TRAIT(owner, TRAIT_PARRYEXPERT, CONTRACTOR_TRAIT_SOURCE)
		exchange_trait_applied = TRUE
		RegisterSignal(owner, COMSIG_MOB_PARRY_SUCCESS, PROC_REF(_sig_exchange_defense_success))
		apply_contractor_buff(/datum/status_effect/buff/contractor_exchange, duration)
	to_chat(owner, span_notice("Your body is ready to trade places with attackers for [round(duration / 10)] seconds."))
	addtimer(CALLBACK(src, PROC_REF(end_exchange_at), exchange_end_time), duration)
	return TRUE

/datum/component/contractor/proc/end_exchange_at(expected_end_time)
	if(exchange_end_time != expected_end_time)
		return TRUE
	return end_exchange()

/datum/component/contractor/proc/end_exchange()
	if(!exchange_active && !exchange_trait_applied)
		return TRUE
	exchange_active = FALSE
	exchange_end_time = 0
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_PARRY_SUCCESS)
		clear_contractor_buff(/datum/status_effect/buff/contractor_exchange)
		if(exchange_trait_applied)
			REMOVE_TRAIT(owner, TRAIT_PARRYEXPERT, CONTRACTOR_TRAIT_SOURCE)
	exchange_trait_applied = FALSE
	return TRUE

/datum/component/contractor/proc/_sig_exchange_defense_success(datum/source, mob/living/attacker)
	SIGNAL_HANDLER
	if(!exchange_active || !owner || !attacker || attacker.stat == DEAD)
		return
	INVOKE_ASYNC(src, PROC_REF(swap_with_attacker), attacker)

/datum/component/contractor/proc/start_invisibility()
	if(invisibility_active)
		return FALSE
	if(!owner)
		return FALSE
	var/duration = get_contractor_effect_duration(CONTRACTOR_LEVEL_WATCHFUL)
	invisibility_active = TRUE
	invisibility_end_time = world.time + duration
	old_invisibility = owner.invisibility
	old_alpha = owner.alpha
	old_mouse_opacity = owner.mouse_opacity
	refresh_invisibility()
	apply_contractor_buff(/datum/status_effect/buff/contractor_invisibility, duration)
	RegisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME, PROC_REF(_sig_invisibility_attack))
	to_chat(owner, span_notice("You vanish beneath a hungry veil for [round(duration / 10)] seconds."))
	addtimer(CALLBACK(src, PROC_REF(end_invisibility_at), invisibility_end_time), duration)
	return TRUE

/datum/component/contractor/proc/end_invisibility_at(expected_end_time)
	if(invisibility_end_time != expected_end_time)
		return TRUE
	return end_invisibility()

/datum/component/contractor/proc/refresh_invisibility()
	if(!invisibility_active || !owner)
		return FALSE
	owner.invisibility = max(owner.invisibility, INVISIBILITY_OBSERVER)
	owner.alpha = 0
	owner.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	return TRUE

/datum/component/contractor/proc/end_invisibility()
	if(!invisibility_active || !owner)
		return FALSE
	invisibility_active = FALSE
	invisibility_end_time = 0
	UnregisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME)
	clear_contractor_buff(/datum/status_effect/buff/contractor_invisibility)
	owner.invisibility = old_invisibility || 0
	owner.alpha = isnull(old_alpha) ? 255 : old_alpha
	owner.mouse_opacity = isnull(old_mouse_opacity) ? MOUSE_OPACITY_ICON : old_mouse_opacity
	return TRUE

/datum/component/contractor/proc/_sig_invisibility_attack(datum/source, atom/target_atom, zone, obj/item/W)
	SIGNAL_HANDLER
	end_invisibility()
	return 0

/datum/component/contractor/proc/is_incorporeal_active()
	return incorporeal_active && owner && !QDELETED(owner)

/datum/component/contractor/proc/start_incorporeal()
	if(incorporeal_active)
		return FALSE
	if(!owner)
		return FALSE
	var/duration = get_contractor_effect_duration(CONTRACTOR_LEVEL_COMPLETE)
	incorporeal_active = TRUE
	incorporeal_end_time = world.time + duration
	old_density = owner.density
	old_pass_flags = owner.pass_flags
	old_movement_type = owner.movement_type
	true_form_original_status_flags = owner.status_flags
	owner.status_flags |= GODMODE
	owner.density = FALSE
	var/pass_bits = 0
#ifdef PASSMOB
	pass_bits |= PASSMOB
#endif
#ifdef PASSTABLE
	pass_bits |= PASSTABLE
#endif
#ifdef PASSGLASS
	pass_bits |= PASSGLASS
#endif
#ifdef PASSDOORS
	pass_bits |= PASSDOORS
#endif
	if(pass_bits)
		owner.pass_flags |= pass_bits
	var/movement_bits = 0
#ifdef PHASING
	movement_bits |= PHASING
#endif
	if(movement_bits)
		owner.movement_type |= movement_bits
	apply_contractor_buff(/datum/status_effect/buff/contractor_incorporeal, duration)
	to_chat(owner, span_notice("Your flesh thins into a contract-shaped shadow for [round(duration / 10)] seconds."))
	addtimer(CALLBACK(src, PROC_REF(end_incorporeal_at), incorporeal_end_time), duration)
	return TRUE

/datum/component/contractor/proc/end_incorporeal_at(expected_end_time)
	if(incorporeal_end_time != expected_end_time)
		return TRUE
	return end_incorporeal()

/datum/component/contractor/proc/end_incorporeal()
	if(!incorporeal_active || !owner)
		return FALSE
	incorporeal_active = FALSE
	incorporeal_end_time = 0
	clear_contractor_buff(/datum/status_effect/buff/contractor_incorporeal)
	owner.density = old_density
	if(!isnull(true_form_original_status_flags))
		owner.status_flags = true_form_original_status_flags
	if(!isnull(old_pass_flags))
		owner.pass_flags = old_pass_flags
	if(!isnull(old_movement_type))
		owner.movement_type = old_movement_type
	return TRUE

/datum/component/contractor/proc/teleport_behind(mob/living/target)
	if(!owner || !target)
		return FALSE
	var/turf/T = get_step(target, turn(target.dir, 180))
	if(!T || T.density)
		T = get_step(get_turf(target), turn(get_dir(target, owner), 180))
	if(!T || T.density)
		return FALSE
	owner.forceMove(T)
	owner.face_atom(target)
	return TRUE

/datum/component/contractor/proc/swap_with_attacker(mob/living/attacker)
	if(!owner || !attacker)
		return FALSE
	var/turf/owner_turf = get_turf(owner)
	var/turf/attacker_turf = get_turf(attacker)
	if(!owner_turf || !attacker_turf)
		return FALSE
	owner.forceMove(attacker_turf)
	attacker.forceMove(owner_turf)
	owner.face_atom(attacker)
	attacker.face_atom(owner)
	return TRUE


/datum/component/contractor/proc/prepare_gift(mob/living/carbon/human/target)
	var/datum/component/contractee/contractee = target?.GetComponent(/datum/component/contractee)
	if(!contractee || contractee.contractor != src || !contractee.is_submitted())
		to_chat(owner, span_warning("This contractee is not fully submitted to you."))
		return FALSE
	var/datum/contractor_contract/contract = new(src, contractee)
	contract.gift_contract = TRUE
	contract.status = CONTRACTOR_CONTRACT_PENDING_CONTRACTOR
	contractee.contracts += contract
	contracts += contract
	contract.ui_interact(owner)
	return TRUE


/datum/component/contractor/proc/alter_body(mob/living/carbon/human/target)
	if(!target)
		return FALSE
	return perform_contractor_mirror_transform(owner, target)

/datum/component/contractor/proc/start_weaving(mob/living/target)
	if(!target || target == owner)
		return FALSE
	if(get_dist(owner, target) > 1)
		to_chat(owner, span_warning("You must be next to the target to weave stillness."))
		return FALSE
	current_weaving_target = target
	owner.Immobilize(9999 SECONDS)
	target.Immobilize(9999 SECONDS)
	to_chat(owner, span_userdanger("You bind yourself and [target] in stillness."))
	to_chat(target, span_userdanger("[owner] binds you in stillness."))
	return TRUE

/datum/component/contractor/proc/end_weaving()
	if(owner)
		owner.SetImmobilized(0)
	var/mob/living/target = current_weaving_target
	if(target)
		target.SetImmobilized(0)
	current_weaving_target = null
	return TRUE

/datum/component/contractor/proc/accept_summon(mob/living/carbon/human/summoner, obj/item/offering)
	if(!owner || !summoner || !offering || QDELETED(owner) || QDELETED(summoner) || QDELETED(offering))
		return FALSE
	var/turf/origin = get_turf(owner)
	var/turf/destination = get_turf(summoner)
	if(!origin || !destination)
		return FALSE
	set_summon_return_point(origin, CONTRACTOR_RETURN_TO_SUMMON_DURATION)
	owner.forceMove(destination)
	if(offering.loc != owner)
		offering.forceMove(get_turf(owner))
	if(!owner.put_in_hands(offering))
		offering.forceMove(get_turf(owner))
	to_chat(owner, span_notice("You answer [summoner]'s offering. The path back will remain open for 30 minutes."))
	to_chat(summoner, span_notice("[owner] answers your offering."))
	return TRUE

/datum/component/contractor/proc/set_summon_return_point(turf/origin, duration = CONTRACTOR_RETURN_TO_SUMMON_DURATION)
	if(!origin || !owner)
		return FALSE
	last_return_turf = origin
	return_action_expires_at = world.time + duration
	contractor_grant_mind_spell_if_missing(owner, /datum/action/cooldown/spell/contractor/return_to_summon)
	addtimer(CALLBACK(src, PROC_REF(expire_return_to_summon_at), return_action_expires_at), duration)
	return TRUE

/datum/component/contractor/proc/expire_return_to_summon_at(expected_expire_time)
	if(return_action_expires_at != expected_expire_time)
		return TRUE
	return clear_return_to_summon(TRUE)

/datum/component/contractor/proc/clear_return_to_summon(expired = FALSE)
	if(owner)
		contractor_remove_mind_spell(owner, /datum/action/cooldown/spell/contractor/return_to_summon)
		if(expired && last_return_turf)
			to_chat(owner, span_warning("The path back to your accepted summon closes."))
	last_return_turf = null
	return_action_expires_at = 0
	return TRUE

/datum/component/contractor/proc/return_to_summon_origin()
	if(!last_return_turf)
		to_chat(owner, span_warning("You have no accepted summons to return from."))
		clear_return_to_summon()
		return FALSE
	if(return_action_expires_at && world.time >= return_action_expires_at)
		to_chat(owner, span_warning("The path back to your accepted summon has already closed."))
		clear_return_to_summon()
		return FALSE
	owner.forceMove(last_return_turf)
	clear_return_to_summon()
	return TRUE

/datum/component/contractor/proc/on_contractor_death()
	for(var/datum/contractor_contract/contract as anything in contracts.Copy())
		contract.break_contract("contractor_death")



/datum/devotion/contractor
	max_devotion = CONTRACTOR_DEFAULT_MAX_DEVOTION
	devotion = CONTRACTOR_DEFAULT_DEVOTION
	passive_devotion_gain = 0
	passive_progression_gain = 0
	prayer_effectiveness = 0

/datum/devotion/contractor/New(mob/living/carbon/human/new_holder)
	holder = new_holder
	patron = null
	level = CLERIC_T0
	last_level = null
	max_devotion = CONTRACTOR_DEFAULT_MAX_DEVOTION
	max_progression = CONTRACTOR_DEFAULT_MAX_DEVOTION
	devotion = CONTRACTOR_DEFAULT_DEVOTION
	progression = 0

	if(holder)
		holder.devotion = src
		holder?.hud_used?.initialize_bloodpool()
		holder?.hud_used?.bloodpool?.set_fill_color(CONTRACTOR_DEVOTION_COLOR)

	update_devotion(0, 0, TRUE)

/datum/devotion/contractor/Destroy(force)
	if(holder?.hud_used)
		holder.hud_used.shutdown_bloodpool()
	if(holder?.devotion == src)
		holder.devotion = null
	holder = null
	patron = null
	granted_spells = null
	return ..()

/datum/devotion/contractor/proc/set_contractor_devotion(amount, silent = TRUE)
	devotion = clamp(amount, 0, max_devotion)
	update_devotion(0, 0, silent)

/datum/devotion/contractor/proc/fill_contractor_devotion(silent = TRUE)
	set_contractor_devotion(max_devotion, silent)




/datum/component/contractor/entity/accept_summon(mob/living/carbon/human/summoner, obj/item/offering)
	return FALSE

/datum/component/contractor/entity/set_summon_return_point(turf/origin, duration = CONTRACTOR_RETURN_TO_SUMMON_DURATION)
	return FALSE

/datum/component/contractor/entity/return_to_summon_origin()
	return FALSE
