#define TA_DEATH_GIFT_DARKSIGHT_SEE_IN_DARK 15
#define TA_DEATH_GIFT_DARKSIGHT_LIGHTING_ALPHA LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
#define TA_DEATH_GIFT_BERSERK_DURATION (1 MINUTES)
#define TA_DEATH_GIFT_TIRED_DURATION (10 MINUTES)
#define TA_DEATH_GIFT_BERSERK_SLEEP_DURATION (3 MINUTES)
#define TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE 30
#define TA_DEATH_GIFT_BERSERK_HIT_CHANCE 75
#define TA_DEATH_GIFT_BERSERK_ATTACK_DELAY (CLICK_CD_MELEE * 0.75)
#define TA_DEATH_GIFT_BERSERK_BITE_INTERVAL 5
#define TA_DEATH_GIFT_BERSERK_MOVE_SPEED_STAT 15
#define TA_DEATH_GIFT_BERSERK_PUSH_DISTANCE 3
#define TA_DEATH_GIFT_BERSERK_SILVER_HITS_MIN 2
#define TA_DEATH_GIFT_BERSERK_SILVER_HITS_MAX 3

/datum/antagonist/vampire
	var/ta_death_gifts_given = 0

/datum/antagonist/vampire/proc/ta_death_gift_limit()
	switch(generation)
		if(GENERATION_METHUSELAH)
			return INFINITY
		if(GENERATION_ANCILLAE)
			return 10
		if(GENERATION_NEONATE)
			return 3 // Licker/Wretch vampires use Neonate generation in this codebase.
		if(GENERATION_THINBLOOD)
			return 0
	return 0

/datum/antagonist/vampire/proc/ta_can_offer_death_gift()
	var/limit = ta_death_gift_limit()
	if(limit == INFINITY)
		return TRUE
	return ta_death_gifts_given < limit

/datum/antagonist/vampire/proc/ta_record_death_gift()
	var/limit = ta_death_gift_limit()
	if(limit <= 0)
		return FALSE
	if(limit != INFINITY)
		ta_death_gifts_given++
	return TRUE

/proc/ta_tgui_tooltip_alert(mob/user, message = "", title, list/buttons = list("Ok"), timeout = 0, autofocus = TRUE, strict_byond = FALSE, ui_state = GLOB.tgui_always_state, list/button_tooltips = null)
	if(istext(buttons))
		stack_trace("ta_tgui_tooltip_alert() received text for buttons instead of list")
		return
	if(istext(user))
		stack_trace("ta_tgui_tooltip_alert() received text for user instead of mob")
		return
	if(!user)
		user = usr
	if(!istype(user))
		if(istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	if((!user.client.prefs.tgui_pref || strict_byond) && length(buttons))
		switch(length(buttons))
			if(1)
				return alert(user, message, title, buttons[1])
			if(2)
				return alert(user, message, title, buttons[1], buttons[2])
			if(3)
				return alert(user, message, title, buttons[1], buttons[2], buttons[3])

	var/datum/tgui_alert/ta_tooltip/alert = new(user, message, title, buttons, timeout, autofocus, ui_state, button_tooltips)
	alert.ui_interact(user)
	alert.wait()
	if(alert)
		. = alert.choice
		qdel(alert)

/datum/tgui_alert/ta_tooltip
	var/list/button_tooltips

/datum/tgui_alert/ta_tooltip/New(mob/user, message, title, list/buttons, timeout, autofocus, ui_state, list/button_tooltips)
	..(user, message, title, buttons, timeout, autofocus, ui_state)
	src.button_tooltips = button_tooltips?.Copy()

/datum/tgui_alert/ta_tooltip/Destroy(force, ...)
	button_tooltips?.Cut()
	return ..()

/datum/tgui_alert/ta_tooltip/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TwilightTooltipAlertModal")
		ui.open()

/datum/tgui_alert/ta_tooltip/ui_static_data(mob/user)
	var/list/data = ..()
	data["button_tooltips"] = button_tooltips ? button_tooltips : list()
	return data

/mob/living/carbon/human/proc/ta_stabilize_death_gift_body(revive_if_dead = FALSE, datum/mind/original_mind = null)
	if(QDELETED(src))
		return FALSE

	if(stat == DEAD)
		if(!revive_if_dead)
			return FALSE
		adjustOxyLoss(-getOxyLoss())
		if(!revive(full_heal = FALSE))
			return FALSE
		if(original_mind && original_mind.current != src)
			original_mind.transfer_to(src, TRUE)
		if(client)
			client.verbs.Remove(GLOB.ghost_verbs)
		remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
		mind?.remove_antag_datum(/datum/antagonist/zombie)

	suppress_bloodloss(TA_VAMP_DRAIN_STUN_TIME)

	for(var/datum/wound/wound as anything in simple_wounds)
		wound.set_bleed_rate(0)

	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		for(var/datum/wound/wound as anything in bodypart.wounds)
			wound.set_bleed_rate(0)
		bodypart.bleeding = 0

	bleed_rate = 0
	simple_bleeding = 0

	if(blood_volume < TA_VAMP_DRAIN_MIN_BLOOD_VOLUME)
		blood_volume = TA_VAMP_DRAIN_MIN_BLOOD_VOLUME
		handle_blood()

	adjustOxyLoss(-getOxyLoss())
	remove_status_effect(/datum/status_effect/debuff/bleeding)
	remove_status_effect(/datum/status_effect/debuff/bleedingworse)
	remove_status_effect(/datum/status_effect/debuff/bleedingworst)
	updatehealth()
	return TRUE

/mob/living/carbon/human/proc/ta_offer_death_gift(mob/living/carbon/human/sire, datum/antagonist/vampire/VDrinker)
	if(QDELETED(src) || !mind || !istype(VDrinker) || !VDrinker.ta_can_offer_death_gift())
		return FALSE

	var/list/available_gifts = list()
	if(!has_status_effect(/datum/status_effect/buff/ta_death_gift_darksight))
		available_gifts += "Дар темного прозрения"
	if(!has_status_effect(/datum/status_effect/buff/ta_death_gift_power))
		available_gifts += "Дар силы"
	if(!has_status_effect(/datum/status_effect/buff/ta_death_gift_berserk))
		available_gifts += "Дар берсерка"

	if(!length(available_gifts))
		return FALSE

	var/static/list/death_gift_descriptions = list(
		"Дар темного прозрения" = "Усиливает зрение в темноте почти до предела глаз умертвия.",
		"Дар силы" = "+1 ко всем статам и случайным образом +1 к силе или +1 к скорости или +2 к интеллекту.",
		"Дар берсерка" = "Сильные раны могут сорвать остатки воли и выпустить темную ярость. Тело поднимется через боль и переломы, разум утонет в голоде, а ближайшие живые станут добычей. После придет изнуряющий сон.",
	)

	var/use_byond_alert = stat != CONSCIOUS || InCritical()
	var/list/options = available_gifts.Copy()
	var/choice = ta_tgui_tooltip_alert(
		src,
		"Темное создание иссушило вашу душу и тело, но ваша воля позволила вам преодолеть его проклятье.\n\nВыберите темный дар, который вы похитите.",
		"ДАР СМЕРТИ",
		options,
		2 MINUTES,
		strict_byond = use_byond_alert,
		ui_state = GLOB.tgui_always_state,
		button_tooltips = death_gift_descriptions
	)

	if(QDELETED(src) || !mind || !istype(VDrinker) || !VDrinker.ta_can_offer_death_gift())
		return FALSE

	if(!choice || !(choice in options))
		return FALSE

	if(!ta_apply_death_gift(choice, sire))
		return FALSE

	VDrinker.ta_record_death_gift()
	return TRUE

/mob/living/carbon/human/proc/ta_apply_death_gift(choice, mob/living/carbon/human/sire)
	switch(choice)
		if("Дар темного прозрения")
			if(has_status_effect(/datum/status_effect/buff/ta_death_gift_darksight))
				return FALSE
			apply_status_effect(/datum/status_effect/buff/ta_death_gift_darksight)
			to_chat(src, span_notice("Мои глаза раскрываются для ночи. Темнота больше не прячет от меня мир."))
			return TRUE
		if("Дар силы")
			if(has_status_effect(/datum/status_effect/buff/ta_death_gift_power))
				return FALSE
			apply_status_effect(/datum/status_effect/buff/ta_death_gift_power)
			to_chat(src, span_notice("Темная сила наполняет мое тело и разум."))
			return TRUE
		if("Дар берсерка")
			if(has_status_effect(/datum/status_effect/buff/ta_death_gift_berserk))
				return FALSE
			apply_status_effect(/datum/status_effect/buff/ta_death_gift_berserk)
			to_chat(src, span_notice("В глубине крови просыпается ярость, готовая поднять меня на ноги в час смерти."))
			return TRUE
	return FALSE

/datum/status_effect/buff/ta_death_gift_darksight
	id = "ta_death_gift_darksight"
	duration = -1
	needs_processing = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/buff/ta_death_gift_darksight

/datum/status_effect/buff/ta_death_gift_darksight/on_apply()
	. = ..()
	if(.)
		RegisterSignal(owner, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(apply_undead_sight))
		owner.update_sight()

/datum/status_effect/buff/ta_death_gift_darksight/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_UPDATE_SIGHT)
		owner.update_sight()
	return ..()

/datum/status_effect/buff/ta_death_gift_darksight/proc/apply_undead_sight(mob/living/source)
	SIGNAL_HANDLER
	var/obj/item/organ/eyes/night_vision/zombie/undead_eyes = /obj/item/organ/eyes/night_vision/zombie
	source.see_in_dark = max(source.see_in_dark, initial(undead_eyes.see_in_dark), TA_DEATH_GIFT_DARKSIGHT_SEE_IN_DARK)
	var/undead_lighting_alpha = initial(undead_eyes.lighting_alpha)
	if(!isnull(undead_lighting_alpha))
		source.lighting_alpha = min(source.lighting_alpha, undead_lighting_alpha, TA_DEATH_GIFT_DARKSIGHT_LIGHTING_ALPHA)

/atom/movable/screen/alert/status_effect/buff/ta_death_gift_darksight
	name = "Дар темного прозрения"
	desc = "Мои глаза идеально видят в темноте, подобно созданиям ночи."
	icon_state = "buff"

/datum/status_effect/buff/ta_death_gift_power
	id = "ta_death_gift_power"
	duration = -1
	needs_processing = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/buff/ta_death_gift_power
	var/extra_stat
	var/extra_stat_amount = 0

/datum/status_effect/buff/ta_death_gift_power/on_creation(mob/living/new_owner, selected_extra_stat = null)
	var/list/candidates = list(STATKEY_STR, STATKEY_SPD, STATKEY_INT)
	if(selected_extra_stat in candidates)
		extra_stat = selected_extra_stat
	else
		extra_stat = pick(candidates)
	extra_stat_amount = (extra_stat == STATKEY_INT) ? 2 : 1
	effectedstats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1,
	)
	effectedstats[extra_stat] += extra_stat_amount
	return ..()

/datum/status_effect/buff/ta_death_gift_power/on_apply()
	. = ..()
	if(!.)
		return
	switch(extra_stat)
		if(STATKEY_STR)
			to_chat(owner, span_notice("Темный дар сильнее всего отзывается в моих мышцах."))
		if(STATKEY_SPD)
			to_chat(owner, span_notice("Темный дар сильнее всего отзывается в моей скорости."))
		if(STATKEY_INT)
			to_chat(owner, span_notice("Темный дар сильнее всего отзывается ясностью ума."))

/atom/movable/screen/alert/status_effect/buff/ta_death_gift_power
	name = "Дар силы"
	desc = "Темная сила укрепляет мое тело и разум."
	icon_state = "buff"

/datum/status_effect/buff/ta_death_gift_berserk
	id = "ta_death_gift_berserk"
	duration = -1
	needs_processing = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/buff/ta_death_gift_berserk

/datum/status_effect/buff/ta_death_gift_berserk/on_apply()
	. = ..()
	if(. && ishuman(owner))
		owner.AddComponent(/datum/component/ta_death_gift_berserk)

/datum/status_effect/buff/ta_death_gift_berserk/on_remove()
	if(owner)
		var/datum/component/ta_death_gift_berserk/berserk = owner.GetComponent(/datum/component/ta_death_gift_berserk)
		if(berserk)
			qdel(berserk)
	return ..()

/atom/movable/screen/alert/status_effect/buff/ta_death_gift_berserk
	name = "Дар берсерка"
	desc = "Сильные раны могут пробудить во мне великую ярость."
	icon_state = "buff"

/datum/status_effect/debuff/ta_death_gift_tired
	id = "ta_death_gift_tired"
	duration = TA_DEATH_GIFT_TIRED_DURATION
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_death_gift_tired

/atom/movable/screen/alert/status_effect/debuff/ta_death_gift_tired
	name = "Tired"
	desc = "Темная ярость исчерпала меня. Я валюсь с ног от усталости."
	icon_state = "sleepy"

/datum/component/ta_death_gift_berserk
	var/active = FALSE
	var/starting = FALSE
	var/ending = FALSE
	var/end_time = 0
	var/applied_frenzy_visuals = FALSE
	var/gibbing = FALSE
	var/silver_hits_taken = 0
	var/silver_hits_to_break = 0
	var/next_berserk_attack = 0
	var/berserk_attack_count = 0
	var/datum/previous_click_intercept
	var/datum/component/after_image/berserk_after_image

/datum/component/ta_death_gift_berserk/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_change))
	RegisterSignal(parent, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_update))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(parent, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_unarmed_attack))
	RegisterSignal(parent, COMSIG_ITEM_ATTACKED_SUCCESS, PROC_REF(on_item_attacked_success))
	START_PROCESSING(SSprocessing, src)

/datum/component/ta_death_gift_berserk/Destroy()
	var/mob/living/carbon/human/owner = parent
	if(active && istype(owner))
		set_berserk_click_intercept(owner, FALSE)
		set_berserk_traits(owner, FALSE)
	if(istype(owner))
		clear_berserk_overlay(owner)
	UnregisterSignal(parent, list(COMSIG_MOB_STATCHANGE, COMSIG_LIVING_HEALTH_UPDATE, COMSIG_LIVING_DEATH, COMSIG_MOB_ATTACK_HAND, COMSIG_ITEM_ATTACKED_SUCCESS))
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/ta_death_gift_berserk/process()
	var/mob/living/carbon/human/owner = parent
	if(!istype(owner) || QDELETED(owner))
		qdel(src)
		return

	if(active)
		if(ending)
			return
		if(owner.stat == DEAD || !owner.get_bodypart(BODY_ZONE_HEAD))
			ta_bloody_gib(owner)
			return
		keep_berserk_upright(owner)
		if(world.time >= end_time)
			end_berserk(owner)
			return
		return

	if(!starting && can_start_berserk(owner))
		start_berserk(owner)

/datum/component/ta_death_gift_berserk/proc/can_start_berserk(mob/living/carbon/human/owner)
	if(!istype(owner) || QDELETED(owner) || owner.stat == DEAD || active)
		return FALSE
	if(owner.has_status_effect(/datum/status_effect/debuff/sleepytime) || owner.has_status_effect(/datum/status_effect/debuff/ta_death_gift_tired))
		return FALSE
	if(!owner.get_bodypart(BODY_ZONE_HEAD))
		return FALSE
	return owner.InCritical() || owner.health <= owner.crit_threshold || ((owner.blood_volume in -INFINITY to BLOOD_VOLUME_SURVIVE) && !HAS_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE))

/datum/component/ta_death_gift_berserk/proc/start_berserk(mob/living/carbon/human/owner)
	starting = FALSE
	if(!can_start_berserk(owner))
		return

	active = TRUE
	ending = FALSE
	end_time = world.time + TA_DEATH_GIFT_BERSERK_DURATION
	applied_frenzy_visuals = !HAS_TRAIT(owner, TRAIT_IN_FRENZY)
	silver_hits_taken = 0
	silver_hits_to_break = rand(TA_DEATH_GIFT_BERSERK_SILVER_HITS_MIN, TA_DEATH_GIFT_BERSERK_SILVER_HITS_MAX)
	next_berserk_attack = 0
	berserk_attack_count = 0

	set_berserk_traits(owner, TRUE)
	set_berserk_click_intercept(owner, TRUE)
	apply_berserk_overlay(owner)

	if(applied_frenzy_visuals)
		owner.add_client_colour(/datum/client_colour/glass_colour/red)
		GLOB.frenzy_list |= owner

	owner.a_intent = INTENT_HARM
	owner.ta_stabilize_death_gift_body(FALSE)
	keep_berserk_upright(owner)
	owner.frenzy_target = find_berserk_target(owner)
	owner.clear_frenzy_cache()
	drive_berserk(owner)
	schedule_berserk_loop(owner)
	owner.visible_message(span_userdanger("[owner] поднимается в кровавой ярости!"), span_userdanger("Темная ярость окутала мой разум. Я ГОТОВ ПОГУБИТЬ ЭТОТ МИР."))

/datum/component/ta_death_gift_berserk/proc/end_berserk(mob/living/carbon/human/owner, broken_by_silver = FALSE)
	if(!active && !ending)
		return
	if(!istype(owner) || QDELETED(owner))
		active = FALSE
		ending = FALSE
		return

	active = FALSE
	ending = FALSE
	set_berserk_click_intercept(owner, FALSE)
	set_berserk_traits(owner, FALSE)
	clear_berserk_overlay(owner)
	owner.ta_stabilize_death_gift_body(FALSE)
	owner.apply_status_effect(/datum/status_effect/debuff/ta_death_gift_tired)
	owner.Sleeping(TA_DEATH_GIFT_BERSERK_SLEEP_DURATION, ignore_canstun = TRUE)
	owner.clear_frenzy_cache()
	if(broken_by_silver)
		owner.visible_message(span_warning("Серебро гасит темную ярость [owner]."), span_userdanger("Серебро прожигает мою ярость и бросает меня обратно в слабость."))
	else
		owner.visible_message(span_warning("[owner] содрогается и падает после вспышки темной ярости."), span_warning("Темная ярость отпускает меня, оставляя изнурение."))

/datum/component/ta_death_gift_berserk/proc/set_berserk_traits(mob/living/carbon/human/owner, enabled)
	var/static/list/berserk_traits = list(
		TRAIT_MOVEMENT_BLOCKED,
		TRAIT_SLEEPIMMUNE,
		TRAIT_STUNIMMUNE,
		TRAIT_NOSOFTCRIT,
		TRAIT_NOHARDCRIT,
		TRAIT_NOCRITDAMAGE,
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_NOLIMBDISABLE,
	)
	for(var/trait in berserk_traits)
		if(enabled)
			ADD_TRAIT(owner, trait, "ta_death_gift")
		else
			REMOVE_TRAIT(owner, trait, "ta_death_gift")
	owner.update_disabled_bodyparts()
	if(applied_frenzy_visuals && !HAS_TRAIT(owner, TRAIT_IN_FRENZY))
		owner.remove_client_colour(/datum/client_colour/glass_colour/red)
		GLOB.frenzy_list -= owner
	if(!enabled)
		applied_frenzy_visuals = FALSE

/datum/component/ta_death_gift_berserk/proc/set_berserk_click_intercept(mob/living/carbon/human/owner, enabled)
	if(enabled)
		if(owner.click_intercept == src)
			return
		previous_click_intercept = owner.click_intercept
		owner.click_intercept = src
		return
	if(owner.click_intercept == src)
		owner.click_intercept = previous_click_intercept
	previous_click_intercept = null

/datum/component/ta_death_gift_berserk/proc/InterceptClickOn(mob/living/clicker, params, atom/target)
	return active && !ending

/datum/component/ta_death_gift_berserk/proc/apply_berserk_overlay(mob/living/carbon/human/owner)
	if(!owner.GetComponent(/datum/component/after_image))
		berserk_after_image = owner.AddComponent(/datum/component/after_image)
	if(!owner.get_filter("ta_death_gift_berserk"))
		owner.add_filter("ta_death_gift_berserk", 2, list("type" = "outline", "color" = "#7a0000", "alpha" = 120, "size" = 1))

/datum/component/ta_death_gift_berserk/proc/clear_berserk_overlay(mob/living/carbon/human/owner)
	if(istype(owner))
		owner.remove_filter("ta_death_gift_berserk")
	if(berserk_after_image && !QDELETED(berserk_after_image))
		qdel(berserk_after_image)
	berserk_after_image = null

/datum/component/ta_death_gift_berserk/proc/keep_berserk_upright(mob/living/carbon/human/owner)
	owner.remove_CC(FALSE)
	owner.SetSleeping(0, FALSE, TRUE)
	owner.SetUnconscious(0, FALSE, TRUE)
	owner.SetParalyzed(0, FALSE, TRUE)
	owner.SetImmobilized(0, FALSE, TRUE)
	owner.SetStun(0, FALSE, TRUE)
	owner.SetKnockdown(0, FALSE, TRUE)
	owner.setStaminaLoss(0)
	owner.a_intent = INTENT_HARM
	owner.updatehealth()
	owner.update_mobility()
	if(owner.resting && (owner.mobility_flags & MOBILITY_CANSTAND))
		owner.set_resting(FALSE, TRUE)

/datum/component/ta_death_gift_berserk/proc/get_berserk_move_delay()
	var/berserk_run_delay = CONFIG_GET(number/movedelay/run_delay) + ((10 - TA_DEATH_GIFT_BERSERK_MOVE_SPEED_STAT) * SPEED_MOVSPD_MOD)
	return max(world.tick_lag, berserk_run_delay)

/datum/component/ta_death_gift_berserk/proc/drive_berserk(mob/living/carbon/human/owner)
	if(!active || ending || !istype(owner) || QDELETED(owner) || owner.stat == DEAD)
		return
	var/mob/living/target = owner.frenzy_target
	if(!is_valid_berserk_target(owner, target))
		target = find_berserk_target(owner)
		owner.frenzy_target = target
		owner.clear_frenzy_cache()
	if(!target)
		return
	owner.face_atom(target)
	if(get_dist(owner, target) <= 1)
		try_berserk_attack(owner, target)
		return
	owner.set_glide_size(DELAY_TO_GLIDE_SIZE(get_berserk_move_delay()))
	owner.frenzy_pathfind_to_target()

/datum/component/ta_death_gift_berserk/proc/schedule_berserk_loop(mob/living/carbon/human/owner)
	if(!active || ending || !istype(owner) || QDELETED(owner))
		return
	addtimer(CALLBACK(src, PROC_REF(berserk_loop), WEAKREF(owner)), get_berserk_move_delay())

/datum/component/ta_death_gift_berserk/proc/berserk_loop(datum/weakref/owner_ref)
	if(!active || ending)
		return
	var/mob/living/carbon/human/owner = owner_ref?.resolve()
	if(!istype(owner) || QDELETED(owner))
		return
	if(owner.stat == DEAD || !owner.get_bodypart(BODY_ZONE_HEAD))
		ta_bloody_gib(owner)
		return
	keep_berserk_upright(owner)
	if(world.time >= end_time)
		end_berserk(owner)
		return
	drive_berserk(owner)
	schedule_berserk_loop(owner)

/datum/component/ta_death_gift_berserk/proc/is_valid_berserk_target(mob/living/carbon/human/owner, mob/living/target)
	if(!istype(owner) || !isliving(target) || QDELETED(target))
		return FALSE
	if(target == owner || target.stat == DEAD)
		return FALSE
	return get_dist(owner, target) <= 7

/datum/component/ta_death_gift_berserk/proc/find_berserk_target(mob/living/carbon/human/owner, mob/living/excluded_target = null)
	var/mob/living/best_target = null
	var/best_dist = INFINITY
	for(var/mob/living/possible_target in oviewers(7, owner))
		if(possible_target == owner || possible_target == excluded_target || possible_target.stat == DEAD)
			continue
		var/current_dist = get_dist(owner, possible_target)
		if(current_dist < best_dist)
			best_target = possible_target
			best_dist = current_dist
	if(best_target)
		return best_target
	if(excluded_target && !QDELETED(excluded_target) && excluded_target.stat != DEAD)
		return excluded_target
	return null

/datum/component/ta_death_gift_berserk/proc/pick_berserk_zone(mob/living/target, prefer_accessible = FALSE)
	if(!iscarbon(target))
		return BODY_ZONE_CHEST
	var/mob/living/carbon/carbon_target = target
	var/static/list/possible_zones = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_PRECISE_NECK,
		BODY_ZONE_PRECISE_MOUTH,
		BODY_ZONE_CHEST,
		BODY_ZONE_PRECISE_STOMACH,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_PRECISE_R_FOOT,
	)
	var/list/available_zones = list()
	var/list/accessible_zones = list()
	for(var/zone in possible_zones)
		if(!carbon_target.get_bodypart(check_zone(zone)))
			continue
		available_zones += zone
		if(get_location_accessible(carbon_target, zone, grabs = TRUE))
			accessible_zones += zone
	if(prefer_accessible && length(accessible_zones))
		return pick(accessible_zones)
	if(length(available_zones))
		return pick(available_zones)
	return BODY_ZONE_CHEST

/datum/component/ta_death_gift_berserk/proc/on_stat_change(mob/living/carbon/human/source, new_stat, old_stat)
	SIGNAL_HANDLER
	if(active || starting || new_stat == DEAD)
		return
	if(can_start_berserk(source))
		starting = TRUE
		INVOKE_ASYNC(src, PROC_REF(start_berserk), source)

/datum/component/ta_death_gift_berserk/proc/on_health_update(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(active || starting || source.stat == DEAD)
		return
	if(can_start_berserk(source))
		starting = TRUE
		INVOKE_ASYNC(src, PROC_REF(start_berserk), source)

/datum/component/ta_death_gift_berserk/proc/on_death(mob/living/carbon/human/source, gibbed)
	SIGNAL_HANDLER
	if(active && !gibbed)
		INVOKE_ASYNC(src, PROC_REF(ta_bloody_gib), source)

/datum/component/ta_death_gift_berserk/proc/on_item_attacked_success(mob/living/carbon/human/source, obj/item/weapon, mob/living/attacker)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = parent
	if(!active || ending || source != owner || !ta_is_silver_weapon(weapon))
		return
	silver_hits_taken++
	if(silver_hits_taken < silver_hits_to_break)
		to_chat(owner, span_userdanger("Серебро вгрызается в темную ярость. Еще немного, и оно погасит ее."))
		return
	ending = TRUE
	INVOKE_ASYNC(src, PROC_REF(end_berserk), owner, TRUE)

/datum/component/ta_death_gift_berserk/proc/ta_is_silver_weapon(obj/item/weapon)
	var/static/list/silver_smeltresults = list(
		/obj/item/ingot/silver,
		/obj/item/ingot/aaslag,
		/obj/item/ingot/aalloy,
		/obj/item/ingot/purifiedaalloy,
	)
	if(!istype(weapon))
		return FALSE
	if(weapon.is_silver || weapon.is_lesser_silver)
		return TRUE
	return weapon.smeltresult in silver_smeltresults

/datum/component/ta_death_gift_berserk/proc/on_unarmed_attack(mob/living/carbon/human/source, mob/living/carbon/human/attacker, mob/living/target, datum/martial_art/attacker_style)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = parent
	if(!active || ending || source != owner || attacker != owner || !isliving(target) || target == owner || target.stat == DEAD)
		return

	INVOKE_ASYNC(src, PROC_REF(try_berserk_attack), owner, target)

/datum/component/ta_death_gift_berserk/proc/try_berserk_attack(mob/living/carbon/human/owner, mob/living/target)
	if(!active || ending || !istype(owner) || QDELETED(owner) || !is_valid_berserk_target(owner, target) || get_dist(owner, target) > 1)
		return
	if(world.time < next_berserk_attack)
		return

	next_berserk_attack = world.time + TA_DEATH_GIFT_BERSERK_ATTACK_DELAY
	owner.changeNext_move(TA_DEATH_GIFT_BERSERK_ATTACK_DELAY)
	owner.setStaminaLoss(0)
	owner.a_intent = INTENT_HARM
	owner.face_atom(target)
	berserk_attack_count++

	var/bite_attack = !(berserk_attack_count % TA_DEATH_GIFT_BERSERK_BITE_INTERVAL)
	var/selected_zone = pick_berserk_zone(target, bite_attack)
	if(!prob(TA_DEATH_GIFT_BERSERK_HIT_CHANCE))
		owner.visible_message(span_danger("[owner] рвется к [target], но промахивается!"), span_warning("Ярость ведет меня мимо цели."))
		return
	if(bite_attack)
		handle_berserk_bite(owner, target, selected_zone)
	else
		handle_berserk_unarmed_attack(owner, target, selected_zone)

/datum/component/ta_death_gift_berserk/proc/handle_berserk_unarmed_attack(mob/living/carbon/human/owner, mob/living/target, selected_zone)
	if(!active || ending || !istype(owner) || QDELETED(owner) || !isliving(target) || QDELETED(target) || target == owner || target.stat == DEAD)
		return

	var/zone = check_zone(selected_zone)
	if(!zone)
		zone = BODY_ZONE_CHEST
	target.apply_damage(TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, BRUTE, zone, forced = TRUE)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/affecting = carbon_target.get_bodypart(zone)
		affecting?.bodypart_attacked_by(BCLASS_BLUNT, TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, owner, zone, crit_message = TRUE, armor = 0)
	else
		target.simple_woundcritroll(BCLASS_BLUNT, TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, owner, zone, crit_message = TRUE)

	var/push_dir = get_dir(owner, target)
	if(push_dir)
		var/turf/throw_target = get_ranged_target_turf(target, push_dir, TA_DEATH_GIFT_BERSERK_PUSH_DISTANCE)
		target.safe_throw_at(throw_target, TA_DEATH_GIFT_BERSERK_PUSH_DISTANCE, 1, owner, force = MOVE_FORCE_STRONG)

	owner.frenzy_target = find_berserk_target(owner, target)
	owner.clear_frenzy_cache()

/datum/component/ta_death_gift_berserk/proc/handle_berserk_bite(mob/living/carbon/human/owner, mob/living/target, selected_zone)
	if(!active || ending || !istype(owner) || QDELETED(owner) || !isliving(target) || QDELETED(target) || target == owner || target.stat == DEAD)
		return

	var/zone = check_zone(selected_zone)
	if(!zone)
		zone = BODY_ZONE_CHEST
	owner.do_attack_animation(target, "bite")
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/affecting = carbon_target.get_bodypart(zone)
		if(!affecting)
			return
		carbon_target.next_attack_msg.Cut()
		carbon_target.apply_damage(TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, BRUTE, zone, forced = TRUE)
		affecting.bodypart_attacked_by(BCLASS_BITE, TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, owner, selected_zone, crit_message = TRUE, armor = 0)
		carbon_target.visible_message(span_danger("[owner] вгрызается в [parse_zone(selected_zone)] [carbon_target]![carbon_target.next_attack_msg.Join()]"), span_userdanger("[owner] вгрызается в мой [parse_zone(selected_zone)]![carbon_target.next_attack_msg.Join()]"), span_hear("Слышно мокрое рвущее жевание!"), COMBAT_MESSAGE_RANGE, owner)
		carbon_target.next_attack_msg.Cut()
	else
		target.apply_damage(TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, BRUTE, zone, forced = TRUE)
		target.simple_woundcritroll(BCLASS_BITE, TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE, owner, zone, crit_message = TRUE)
		target.visible_message(span_danger("[owner] вгрызается в [target]!"), span_userdanger("[owner] вгрызается в меня!"), span_hear("Слышно мокрое рвущее жевание!"), COMBAT_MESSAGE_RANGE, owner)

	playsound(target, 'sound/gore/flesh_eat_01.ogg', vol = 50, vary = FALSE, extrarange = -2, ignore_walls = FALSE, quiet = TRUE)
	owner.frenzy_target = find_berserk_target(owner, target)
	owner.clear_frenzy_cache()

/datum/component/ta_death_gift_berserk/proc/ta_bloody_gib(mob/living/carbon/human/owner)
	if(gibbing || !istype(owner) || QDELETED(owner))
		return
	gibbing = TRUE
	owner.visible_message(span_userdanger("[owner] разрывается кровавыми ошметками, когда темная ярость пожирает тело!"))
	owner.gib(FALSE, FALSE, FALSE)

#undef TA_DEATH_GIFT_DARKSIGHT_SEE_IN_DARK
#undef TA_DEATH_GIFT_DARKSIGHT_LIGHTING_ALPHA
#undef TA_DEATH_GIFT_BERSERK_DURATION
#undef TA_DEATH_GIFT_TIRED_DURATION
#undef TA_DEATH_GIFT_BERSERK_SLEEP_DURATION
#undef TA_DEATH_GIFT_BERSERK_PUNCH_DAMAGE
#undef TA_DEATH_GIFT_BERSERK_HIT_CHANCE
#undef TA_DEATH_GIFT_BERSERK_ATTACK_DELAY
#undef TA_DEATH_GIFT_BERSERK_BITE_INTERVAL
#undef TA_DEATH_GIFT_BERSERK_MOVE_SPEED_STAT
#undef TA_DEATH_GIFT_BERSERK_PUSH_DISTANCE
#undef TA_DEATH_GIFT_BERSERK_SILVER_HITS_MIN
#undef TA_DEATH_GIFT_BERSERK_SILVER_HITS_MAX
