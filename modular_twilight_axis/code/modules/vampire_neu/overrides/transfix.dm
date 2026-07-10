/obj/effect/proc_holder/spell/targeted/TA_transfix_neu
	name = "Заворожить"
	overlay_state = "transfix"
	associated_skill = /datum/skill/magic/blood
	range = 7
	chargetime = 0
	releasedrain = 100
	recharge_time = 17 SECONDS
	var/powerful = FALSE
	var/int_divisor = 3.3
	var/blood_dice = 9
	var/will_dice = 6
	var/drowsyness_gain = 26
	var/eora_empathic_bond_drowsyness_multiplier = 3.4
	var/eora_empathic_bond_bloodroll_bonus = 2
	var/transfix_msg

/datum/status_effect/debuff/transfix_paste_int
	id = "transfix_paste_int"
	duration = -1
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = /atom/movable/screen/alert/status_effect/debuff/transfix_paste_int
	effectedstats = list(STATKEY_INT = -TA_TRANSFIX_PASTE_INT_LOSS)

/atom/movable/screen/alert/status_effect/debuff/transfix_paste_int
	name = "Sorcerous Overreach"
	desc = "Я превысил пределы своей магии. Мой разум наказан за неестественно быструю речь."
	icon_state = "debuff"

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/choose_targets(mob/user = usr)
	var/list/selection = list()
	for(var/mob/living/carbon/human/target in get_hearers_in_view(6, usr))
		if(!target.mind || target.stat != CONSCIOUS)
			continue
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			continue
		if(HAS_TRAIT(target, TRAIT_SILVER_BLESSED))
			continue
		selection += target

	if(!selection.len)
		revert_cast(user)
		return

	perform(selection, user=user)

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/cast(list/targets, mob/user = usr)
	if(!length(targets))
		to_chat(user, span_warning("Рядом нет смертных..."))
		revert_cast(user)
		return

	if(QDELETED(user))
		return


	if(!user.can_speak())
		to_chat(user, span_warning("Вы не можете говорить!"))
		revert_cast(user)
		return
	var/transfix_input_started_at = world.time
	transfix_msg = tgui_input_text(user, "Произнесите фразу вслух. Нужно минимум [TA_TRANSFIX_MIN_MSG_LENGTH] символов; счетчик снизу.", "Заворожить", max_length = MAX_MESSAGE_LEN, encode = FALSE)

	if(QDELETED(user))
		return

	if(user.stat != CONSCIOUS)
		revert_cast(user)
		return

	if(!user.can_speak())
		to_chat(user, span_warning("Вы не можете говорить!"))
		revert_cast(user)
		return

	var/transfix_msg_length = transfix_msg ? length_char(transfix_msg) : 0
	var/transfix_input_elapsed = max(world.time - transfix_input_started_at, 1)
	if(transfix_msg_length >= TA_TRANSFIX_MIN_MSG_LENGTH && transfix_exceeds_input_speed(transfix_msg_length, transfix_input_elapsed))
		handle_transfix_speed_violation(user, transfix_msg_length, transfix_input_elapsed)
		revert_cast(user)
		return

	if(transfix_msg_length < TA_TRANSFIX_MIN_MSG_LENGTH)
		to_chat(user, span_userdanger("Слишком короткая фраза ([transfix_msg_length]/[TA_TRANSFIX_MIN_MSG_LENGTH]) — разум жертвы не поддастся!"))
		revert_cast(user)
		return

	if(!powerful)
		var/mob/selected = input(user, "Выберите цель для ворожбы.", "Заворожить") as null|anything in targets
		if(QDELETED(src) || QDELETED(user) || QDELETED(selected))
			if(!QDELETED(user))
				revert_cast(user)
			return
		targets = list(selected)

	var/bloodskill = user.get_skill_level(/datum/skill/magic/blood)
	var/bloodroll = roll(bloodskill, blood_dice)
	user.say(transfix_msg, forced = "spell ([name])")
	if(powerful)
		user.visible_message(span_danger("Глаза [user] вспыхивают жутким красным светом!"))

	for(var/mob/living/carbon/human/target as anything in targets)
		if(QDELETED(target) || target.stat != CONSCIOUS)
			continue

		var/current_will_dice = will_dice
		if(target.cmode)
			current_will_dice += 1
		if(target.compliance)
			current_will_dice = 0

		var/willpower = round(target.STAINT / int_divisor, 1)
		var/willroll = roll(willpower, current_will_dice)
		var/target_bloodroll = bloodroll + get_bloodroll_bonus(target, user)
		var/knowledgable = (willroll - target_bloodroll) >= 3

		if(!powerful)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(istype(H.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver) || istype(H.wear_wrists, /obj/item/clothing/neck/roguetown/psicross/silver) || istype(H.wear_ring, /obj/item/clothing/neck/roguetown/psicross/silver))
					var/extra = "!"
					if(knowledgable)
						extra = ", кажется, это был [user]!"
					to_chat(target, span_notice("Серебряный крест сияет и защищает меня от нечестивой магии[extra]"))
					to_chat(user, span_userdanger("У [target] моя ПОГИБЕЛЬ! Я не могу опутать разум!"))
					continue

		if(target_bloodroll >= willroll)
			target.drowsyness = min(target.drowsyness + get_drowsyness_gain(target, user), 150)
			switch(target.drowsyness)
				if(0 to 50)
					to_chat(target, span_warning("Мой разум словно застилает пелена..."))
					to_chat(user, span_notice("Разум [target] слегка поддаётся."))
					target.Slowdown(20)
				if(51 to 90)
					to_chat(target, span_warning("Веки смыкаются, тело наполняет свинцовая усталость."))
					to_chat(user, span_notice("[target] долго не продержится."))
					force_close_eyes(target)
					target.Slowdown(50)
				if(91 to INFINITY)
					to_chat(target, span_userdanger("Больше не могу... Ноги подкашиваются, мир уплывает."))
					to_chat(user, span_boldnotice("[target] теперь мой."))
					force_close_eyes(target)
					target.Slowdown(50)
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, Sleeping), 1 MINUTES), 5 SECONDS)
			continue

		if(!powerful)
			var/holypower = target.get_skill_level(/datum/skill/magic/holy)
			var/magicpower = round(target.get_skill_level(/datum/skill/magic/arcane) * 0.6, 1)
			var/counterroll = roll(1 + holypower + magicpower, 5)
			if(counterroll > target_bloodroll)
				to_chat(target, span_warning("Нечестивая магия... Кажется, она исходит от [user]."))

		to_chat(user, span_userdanger("Мне не удалось опутать разум [target]!"))
		to_chat(target, span_userdanger("Что-то не так в этом месте. Я чувствую, что моя жизнь под угрозой!"))

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/force_close_eyes(mob/living/carbon/human/target)
	target.eyesclosed = TRUE
	target.become_blind("eyelids")
	if(target.hud_used)
		for(var/atom/movable/screen/eye_intent/eyet in target.hud_used.static_inventory)
			eyet.update_icon(target)

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/get_drowsyness_gain(mob/living/carbon/human/target, mob/user)
	if(has_eora_empathic_bond_from(user, target))
		return round(drowsyness_gain * eora_empathic_bond_drowsyness_multiplier)
	return drowsyness_gain

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/get_bloodroll_bonus(mob/living/carbon/human/target, mob/user)
	if(has_eora_empathic_bond_from(user, target))
		return eora_empathic_bond_bloodroll_bonus
	return 0

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/has_eora_empathic_bond_from(mob/user, mob/living/carbon/human/target)
	if(!user || !target)
		return FALSE

	var/datum/component/empathic_obsession/obsession = user.GetComponent(/datum/component/empathic_obsession)
	if(!obsession || obsession.obsession_target != target)
		return FALSE

	// Empathic Bond creates a 2-minute obsession; Beauty's Restoration uses the same component for 5 minutes.
	return obsession.obsession_duration == 2 MINUTES

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/transfix_exceeds_input_speed(transfix_msg_length, transfix_input_elapsed)
	return (transfix_msg_length * (1 MINUTES)) > (TA_TRANSFIX_CHARS_PER_MINUTE * transfix_input_elapsed)

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/handle_transfix_speed_violation(mob/user, transfix_msg_length, transfix_input_elapsed)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/elapsed_seconds = max(round(transfix_input_elapsed / (1 SECONDS), 0.1), 0.1)
	message_admins("[ADMIN_LOOKUPFLW(H)] triggered transfix speed guard: [transfix_msg_length] chars in [elapsed_seconds]s. СКОРЕЕ ВСЕГО - копипаста.")
	log_admin("[key_name(H)] triggered transfix speed guard: [transfix_msg_length] chars in [elapsed_seconds]s. СКОРЕЕ ВСЕГО - копипаста.")

	H.apply_status_effect(/datum/status_effect/debuff/transfix_paste_int)
	H.apply_status_effect(/datum/status_effect/incapacitating/stun, TA_TRANSFIX_PASTE_STUN_TIME)
	H.apply_status_effect(/datum/status_effect/incapacitating/knockdown, TA_TRANSFIX_PASTE_STUN_TIME)
	break_transfix_disguise(H)
	H.visible_message(span_danger("[H] превысил пределы своей могучей магии!"), span_userdanger("Я превысил пределы своей могучей магии!"))

	if(H.STAINT >= TA_TRANSFIX_PASTE_DEATH_INT)
		return

	H.visible_message(span_danger("[H] превысил свои пределы, разрываясь на куски от темной силы!"), span_userdanger("Превысил свои пределы, разрываясь на куски от темной силы!"))
	ADD_TRAIT(H, TRAIT_DUSTABLE, "transfix_paste")
	if(!QDELETED(H) && H.stat != DEAD)
		H.death()

/obj/effect/proc_holder/spell/targeted/TA_transfix_neu/proc/break_transfix_disguise(mob/living/carbon/human/H)
	var/datum/component/vampire_disguise/disguise = H.GetComponent(/datum/component/vampire_disguise)
	if(disguise?.disguised)
		disguise.remove_disguise(H)
		return

	SEND_SIGNAL(H, COMSIG_FORCE_UNDISGUISE)

/mob/living/carbon/human/proc/ta_grant_eora_transfix()
	if(!mind)
		return FALSE

	mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/transfix_neu)
	RemoveSpell(/obj/effect/proc_holder/spell/targeted/transfix_neu)

	if(mind.has_spell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu) || HasSpell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu))
		return FALSE

	AddSpell(new /obj/effect/proc_holder/spell/targeted/TA_transfix_neu)
	to_chat(src, span_notice("Объятия Эоры становятся все крепче, и я учусь завораживать умы смертных."))
	return TRUE

/datum/coven_power/eora/beautys_restoration/post_gain()
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return

	H.ta_grant_eora_transfix()

/mob/living/carbon/human/pre_coven_removal(datum/coven/coven)
	. = ..()

	if(!istype(coven, /datum/coven/eora))
		return

	mind?.RemoveSpell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu)
	RemoveSpell(/obj/effect/proc_holder/spell/targeted/TA_transfix_neu)
