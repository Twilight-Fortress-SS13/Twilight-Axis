


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
	name = "Состояние контрактника"
	desc = "Показать уровень, devotion, силу Lux, форму и контракты."
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
	name = "Поглощение"
	desc = "Поглотить Lux с земли или из живого существа."
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
	return contractor_get_loose_lux_amount(cast_on) > 0

/datum/action/cooldown/spell/contractor/drink_lux/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	if(!core)
		return FALSE
	return core.try_drink_lux(cast_on)

/datum/action/cooldown/spell/contractor/offer_contract
	name = "Заключить контракт"
	desc = "Предложить двусторонний контракт цели, тратя накопленную силу Lux."
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
	name = "Вернуться"
	desc = "Вернуться туда, где контрактник согласилась на призыв."
	button_icon_state = "spell_default"
	cooldown_time = 30 SECONDS
	required_contractor_level = CONTRACTOR_LEVEL_SLEEPING
	devotion_cost_on_success = FALSE

/datum/action/cooldown/spell/contractor/return_to_summon/cast(atom/cast_on)
	. = ..()
	var/datum/component/contractor/core = get_core()
	return core?.return_to_summon_origin()

/datum/action/cooldown/spell/contractor/change_form
	name = "Смена формы"
	desc = "Переключиться между оболочкой и истинной формой."
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
	name = "Уклонение"
	desc = "На короткое время усиливает уклонения; при атаке телепортирует за спину атакующего."
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
	name = "Обмен"
	desc = "На короткое время усиливает парирования; при атаке меняется местами с атакующим."
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
	name = "Невидимость"
	desc = "Стать невидимой на короткое время. Атака должна прервать эффект."
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
	name = "Подготовка дара"
	desc = "Открыть/изменить контракт полностью подчинённого контрактника."
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
	name = "Изменение тела"
	desc = "Изменить тело цели через контрактную силу."
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
	name = "Бестелесность"
	desc = "На короткое время пройти сквозь препятствия и игнорировать немагический урон."
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
	name = "Сплетение"
	desc = "Сковать себя и цель станом до отмены повторным применением."
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
	name = "Share pleasure"
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
	core.set_body_empowered(core.entity_erp_training_enabled)
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
	var/datum/component/contractor/core = get_core()
	if(!istype(core, /datum/component/contractor/entity))
		return FALSE
	return core.alter_body(cast_on)

/datum/action/cooldown/spell/contractor/entity_training_toggle/cast(atom/cast_on)
	. = ..()
	
	return TRUE

#define TEMPRESS_BODY_POWER_TRAIT_SOURCE "tempress_body_power"
#define TEMPRESS_BODY_POWER_PUNCH_DAMAGE 100

/datum/component/contractor/entity/proc/set_body_empowered(enabled)
	var/mob/living/L = parent
	if(!isliving(L))
		return

	if(entity_erp_training_enabled)
		ADD_TRAIT(L, TRAIT_STRONGKICK, TEMPRESS_BODY_POWER_TRAIT_SOURCE)
		RegisterSignal(L, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_body_power_unarmed_hit))
		to_chat(L, span_notice("You feel power inside you."))
	else
		REMOVE_TRAIT(L, TRAIT_STRONGKICK, TEMPRESS_BODY_POWER_TRAIT_SOURCE)
		UnregisterSignal(L, COMSIG_MOB_ATTACK_HAND)
		to_chat(L, span_notice("Your body returns to normal."))

/datum/component/contractor/entity/proc/on_body_power_unarmed_hit(datum/source, mob/living/attacker, mob/living/target)
	SIGNAL_HANDLER

	if(!entity_erp_training_enabled)
		return
	if(!isliving(target))
		return
	if(istype(attacker.used_intent, /datum/intent/unarmed/help))
		return
	if(istype(attacker.used_intent, /datum/intent/unarmed/shove))
		return
	var/zone = attacker.zone_selected

	INVOKE_ASYNC(src, PROC_REF(apply_body_power_punch_damage_async), target, zone)

/datum/component/contractor/entity/proc/apply_body_power_punch_damage_async(mob/living/target, zone)
	if(!entity_erp_training_enabled)
		return
	if(!isliving(target))
		return

	apply_body_power_punch_damage(target, zone)

/datum/component/contractor/entity/proc/apply_body_power_punch_damage(mob/living/target, zone)
	var/mob/living/L = parent
	if(!isliving(L))
		return FALSE

	if(iscarbon(target))
		var/mob/living/carbon/C = target
		var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(zone) || BODY_ZONE_CHEST)
		if(!affecting)
			return FALSE

		C.apply_damage(TEMPRESS_BODY_POWER_PUNCH_DAMAGE, BRUTE, affecting, 0)
	else
		target.apply_damage(TEMPRESS_BODY_POWER_PUNCH_DAMAGE, BRUTE)

	target.visible_message(
		span_danger("[L]'s empowered strike drives force straight into [target]'s body!"),
		span_userdanger("The empowered strike drives force straight through your body!")
	)

	return TRUE

#undef TEMPRESS_BODY_POWER_TRAIT_SOURCE
#undef TEMPRESS_BODY_POWER_PUNCH_DAMAGE
