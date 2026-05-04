


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


