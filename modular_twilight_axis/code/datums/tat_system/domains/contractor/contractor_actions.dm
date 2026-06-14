/datum/action/cooldown/spell/contractor
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "spell_default"
	background_icon = 'icons/mob/actions/roguespells.dmi'
	background_icon_state = "spell0"
	base_background_icon_state = "spell0"
	active_background_icon_state = "spell1"
	panel = "Contractor"
	charge_required = FALSE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0
	associated_stat = null
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	var/required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	var/devotion_cost_on_success = FALSE

/datum/action/cooldown/spell/contractor/proc/get_core()
	return owner?.GetComponent(/datum/component/contractor)

/datum/action/cooldown/spell/contractor/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	var/datum/component/contractor/core = get_core()
	if(!core)
		if(feedback && owner)
			owner.balloon_alert(owner, "not a contractor")
		return FALSE
	return core.can_use_contractor_power(owner, required_contractor_level, FALSE, feedback)

/datum/action/cooldown/spell/contractor/proc/pay_contractor_cost()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	if(!devotion_cost_on_success)
		return TRUE
	return core.pay_ability_cost(required_contractor_level)

/datum/action/cooldown/spell/contractor/proc/refund_contractor_cost()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	if(!devotion_cost_on_success || required_contractor_level <= CONTRACTOR_LEVEL_SLEEPING)
		return TRUE
	core.adjust_devotion(CONTRACTOR_ABILITY_DEVOTION_COST, TRUE)
	return TRUE

/datum/action/cooldown/spell/contractor/status
	name = "Contractor Status"
	desc = "Show your contractor level, devotion, Lux power, form, and contracts."
	button_icon_state = "spell_default"
	cooldown_time = 1 SECONDS
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE

/datum/action/cooldown/spell/contractor/status/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	core.show_status(owner)
	return TRUE

/datum/action/cooldown/spell/contractor/drink_lux
	name = "Absorb Lux"
	desc = "Absorb Lux from the ground or from a living being."
	button_icon_state = "spell_default"
	cooldown_time = 10 SECONDS
	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 1
	aim_assist = TRUE
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE

/datum/action/cooldown/spell/contractor/drink_lux/is_valid_target(atom/cast_on)
	if(!..())
		return FALSE
	if(ishuman(cast_on))
		return TRUE
	if(istype(cast_on, /obj/item/reagent_containers/lux) || istype(cast_on, /obj/item/reagent_containers/lux_impure) || istype(cast_on, /obj/item/reagent_containers/lux_moss) )
		return TRUE
	return contractor_get_loose_lux_amount(cast_on) > 0

/datum/action/cooldown/spell/contractor/drink_lux/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	return core.try_drink_lux(cast_on)

/datum/action/cooldown/spell/contractor/offer_contract
	name = "Form Contract"
	desc = "Form a two-sided contract with the target, spending accumulated Lux power."
	button_icon_state = "spell_default"
	cooldown_time = 10 SECONDS
	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 1
	aim_assist = TRUE
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE

/datum/action/cooldown/spell/contractor/offer_contract/is_valid_target(atom/cast_on)
	if(!..())
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/contractor/offer_contract/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	return core.open_contract(cast_on)

/datum/action/cooldown/spell/contractor/test_level_up
	name = "TEST: Awaken Contractor"
	desc = "Debug spell: raises contractor level by one step and refreshes unlocked skills. Removes itself at level 4."
	button_icon_state = "spell_default"
	cooldown_time = 1 SECONDS
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE

/datum/action/cooldown/spell/contractor/test_level_up/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	return core.test_level_up(owner)

/datum/action/cooldown/spell/contractor/test_pipeline
	name = "TEST: Self Contract Pipeline"
	desc = "Debug spell: self-kiss, generate Lux from yourself, apply the drink debuff, and run the full contract pipeline on yourself."
	button_icon_state = "spell_default"
	cooldown_time = 3 SECONDS
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE
	self_cast_possible = TRUE
	click_to_activate = FALSE

/datum/action/cooldown/spell/contractor/test_pipeline/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	return core.test_self_contract_pipeline(owner)

/datum/action/cooldown/spell/contractor/return_to_summon
	name = "Return"
	desc = "Return to the place where the contractor accepted the summoning."
	button_icon_state = "spell_default"
	cooldown_time = 30 SECONDS
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE

/datum/action/cooldown/spell/contractor/return_to_summon/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	return core?.return_to_summon_origin()

/datum/action/cooldown/spell/contractor/change_form
	name = "Change Form"
	desc = "Switch between your shell and your true form."
	button_icon_state = "spell_default"
	cooldown_time = 30 SECONDS
	required_contractor_level = CONTRACTOR_LEVEL_AWAKENED
	devotion_cost_on_success = TRUE

/datum/action/cooldown/spell/contractor/change_form/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	var/was_true_form = core.true_form
	if(!was_true_form && !pay_contractor_cost())
		return FALSE
	var/success = core.toggle_form()
	if(!success && !was_true_form)
		refund_contractor_cost()
	return success

/datum/action/cooldown/spell/contractor/evasion
	name = "Evasion"
	desc = "Briefly enhances your dodges; when attacked, teleport behind the attacker."
	button_icon_state = "spell_default"
	cooldown_time = 90 SECONDS
	required_contractor_level = CONTRACTOR_LEVEL_AWARE
	devotion_cost_on_success = TRUE

/datum/action/cooldown/spell/contractor/evasion/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!pay_contractor_cost())
		return FALSE
	var/success = core?.start_evasion()
	if(!success)
		refund_contractor_cost()
	return success

/datum/action/cooldown/spell/contractor/exchange
	name = "Exchange"
	desc = "Briefly enhances your parries; when attacked, swap places with the attacker."
	button_icon_state = "spell_default"
	cooldown_time = 90 SECONDS
	required_contractor_level = CONTRACTOR_LEVEL_AWARE
	devotion_cost_on_success = TRUE

/datum/action/cooldown/spell/contractor/exchange/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!pay_contractor_cost())
		return FALSE
	var/success = core?.start_exchange()
	if(!success)
		refund_contractor_cost()
	return success

/datum/action/cooldown/spell/contractor/invisibility
	name = "Invisibility"
	desc = "Become invisible for a short time. Attacking should break the effect."
	button_icon_state = "spell_default"
	cooldown_time = 1 MINUTES
	required_contractor_level = CONTRACTOR_LEVEL_WATCHFUL
	devotion_cost_on_success = TRUE

/datum/action/cooldown/spell/contractor/invisibility/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!pay_contractor_cost())
		return FALSE
	var/success = core?.start_invisibility()
	if(!success)
		refund_contractor_cost()
	return success

/datum/action/cooldown/spell/contractor/gift_contractee
	name = "Prepare Gift"
	desc = "Open or change the contract gift of a fully bound contractee."
	button_icon_state = "spell_default"
	cooldown_time = 30 SECONDS
	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 1
	aim_assist = TRUE
	required_contractor_level = CONTRACTOR_LEVEL_WATCHFUL
	devotion_cost_on_success = TRUE

/datum/action/cooldown/spell/contractor/gift_contractee/is_valid_target(atom/cast_on)
	if(!..())
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/contractor/gift_contractee/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	if(!pay_contractor_cost())
		return FALSE
	var/success = core.prepare_gift(cast_on)
	if(!success)
		refund_contractor_cost()
	return success

/datum/action/cooldown/spell/contractor/body_change
	name = "Alter Body"
	desc = "Alter the target's body through contractual power."
	button_icon_state = "spell_default"
	cooldown_time = 2 MINUTES
	click_to_activate = TRUE
	self_cast_possible = TRUE
	cast_range = 1
	aim_assist = TRUE
	required_contractor_level = CONTRACTOR_LEVEL_WATCHFUL
	devotion_cost_on_success = TRUE

/datum/action/cooldown/spell/contractor/body_change/is_valid_target(atom/cast_on)
	if(!..())
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/contractor/body_change/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!pay_contractor_cost())
		return FALSE
	var/success = core?.alter_body(cast_on)
	if(!success)
		refund_contractor_cost()
	return success

/datum/action/cooldown/spell/contractor/body_mark_contract
	name = "Body Mark"
	desc = "Temporary contract price: reshape the marked contractee."
	button_icon_state = "spell_default"
	cooldown_time = 5 SECONDS
	click_to_activate = TRUE
	self_cast_possible = TRUE
	cast_range = 1
	aim_assist = TRUE
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE
	var/mob/living/carbon/human/mark_target
	var/expire_time = 0

/datum/action/cooldown/spell/contractor/body_mark_contract/is_valid_target(atom/cast_on)
	if(!..())
		return FALSE
	if(world.time > expire_time)
		if(owner)
			to_chat(owner, span_warning("The Body Mark contract power has expired."))
		qdel(src)
		return FALSE
	return cast_on == mark_target && ishuman(cast_on)

/datum/action/cooldown/spell/contractor/body_mark_contract/cast(atom/cast_on)
	. = ..()
	if(world.time > expire_time)
		qdel(src)
		return FALSE
	if(cast_on != mark_target || !ishuman(cast_on))
		return FALSE
	var/datum/component/contractor/core = get_core()
	return core?.alter_body(mark_target)

/datum/action/cooldown/spell/contractor/incorporeal
	name = "Incorporeal"
	desc = "Briefly pass through obstacles and ignore non-magical damage."
	button_icon_state = "spell_default"
	cooldown_time = 2 MINUTES
	required_contractor_level = CONTRACTOR_LEVEL_COMPLETE
	devotion_cost_on_success = TRUE

/datum/action/cooldown/spell/contractor/incorporeal/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!pay_contractor_cost())
		return FALSE
	var/success = core?.start_incorporeal()
	if(!success)
		refund_contractor_cost()
	return success

/datum/action/cooldown/spell/contractor/paralytic_embrace
	name = "Paralytic Embrace"
	desc = "Stun yourself and the target until cancelled by using this again."
	button_icon_state = "spell_default"
	cooldown_time = 2 MINUTES
	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 1
	aim_assist = TRUE
	required_contractor_level = CONTRACTOR_LEVEL_COMPLETE
	devotion_cost_on_success = TRUE

/datum/action/cooldown/spell/contractor/paralytic_embrace/is_valid_target(atom/cast_on)
	if(!..())
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/contractor/paralytic_embrace/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	if(core.current_weaving_target)
		return core.end_weaving()
	if(!pay_contractor_cost())
		return FALSE
	var/success = core.start_weaving(cast_on)
	if(!success)
		refund_contractor_cost()
	return success

/datum/action/cooldown/spell/contractor/entity_training_toggle
	name = "Share Pleasure"
	desc = "Toggle Tempress training."
	button_icon_state = "spell_default"
	cooldown_time = 5 SECONDS
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE

/datum/action/cooldown/spell/contractor/entity_training_toggle/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/entity/core = get_core()
	if(!istype(core, /datum/component/contractor/entity))
		return FALSE

	core.entity_erp_training_enabled = !core.entity_erp_training_enabled
	if(core.entity_erp_training_enabled)
		to_chat(owner, span_notice("You start sharing Tempress training through intimate actions."))
	else
		to_chat(owner, span_notice("You stop sharing Tempress training."))
	return TRUE

/datum/action/cooldown/spell/contractor/entity_body_change
	name = "Shape Body"
	desc = "Change your own or another nearby body."
	button_icon_state = "spell_default"
	cooldown_time = 5 SECONDS
	click_to_activate = TRUE
	self_cast_possible = TRUE
	cast_range = 1
	aim_assist = TRUE
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE

/datum/action/cooldown/spell/contractor/entity_body_change/is_valid_target(atom/cast_on)
	if(!..())
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/contractor/entity_body_change/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/entity/core = get_core()
	if(!istype(core, /datum/component/contractor/entity))
		return FALSE
	return core.alter_body(cast_on)

// /mob/living/carbon/human/verb/call_contractor()
// 	set name = "Offering"
// 	set category = "IC"
// 	set desc = "Call a contractor by presenting the item in your active hand."

// 	var/obj/item/held_item = get_active_held_item()
// 	if(!held_item)
// 		to_chat(src, span_warning("You need to hold something in your active hand."))
// 		return

// 	var/list/contractors = list()

// 	for(var/mob/living/carbon/human/contractor in GLOB.player_list)
// 		if(contractor == src)
// 			continue
// 		if(QDELETED(contractor))
// 			continue
// 		if(contractor.stat == DEAD)
// 			continue
// 		if(!contractor.client)
// 			continue
// 		if(!contractor.GetComponent(/datum/component/contractor))
// 			continue

// 		contractors += contractor

// 	if(!length(contractors))
// 		to_chat(src, span_warning("No contractor answers your call."))
// 		return

// 	to_chat(src, span_notice("You raise [held_item] and call for a contractor."))

// 	var/answered = FALSE
// 	var/declined = 0
// 	var/mob/living/carbon/human/summoner = src
// 	var/obj/item/tribute = held_item

// 	for(var/mob/living/carbon/human/contractor as anything in contractors)
// 		spawn(0)
// 			if(answered)
// 				return

// 			var/choice = alert(
// 				contractor,
// 				"[summoner] calls for a contractor and presents [tribute].",
// 				"Contractor Call",
// 				"Answer",
// 				"Ignore"
// 			)

// 			if(answered)
// 				return

// 			if(choice != "Answer")
// 				declined++
// 				if(declined >= length(contractors) && !answered && !QDELETED(summoner))
// 					to_chat(summoner, span_warning("No contractor answers your call."))
// 				return

// 			answered = TRUE

// 			if(QDELETED(summoner) || QDELETED(contractor) || QDELETED(tribute))
// 				return

// 			if(summoner.get_active_held_item() != tribute)
// 				to_chat(summoner, span_warning("The item is no longer in your hand."))
// 				to_chat(contractor, span_warning("The item is no longer in [summoner]'s hand."))
// 				return

// 			for(var/mob/living/carbon/human/other_contractor as anything in contractors)
// 				if(other_contractor == contractor)
// 					continue
// 				if(QDELETED(other_contractor))
// 					continue
// 				to_chat(other_contractor, span_warning("Another contractor has already answered the call."))

// 			var/turf/target_turf = get_step(summoner, summoner.dir)
// 			if(!target_turf)
// 				target_turf = get_turf(summoner)

// 			contractor.forceMove(target_turf)

// 			if(!summoner.dropItemToGround(tribute, TRUE))
// 				to_chat(summoner, span_warning("You fail to release [tribute]."))
// 				to_chat(contractor, span_warning("[summoner] fails to release [tribute]."))
// 				return

// 			if(!contractor.put_in_hands(tribute))
// 				tribute.forceMove(get_turf(contractor))

// 			contractor.visible_message(span_notice("[contractor] answers [summoner]'s call and takes [tribute]."))
