/datum/mind
	var/list/datum/ta_retainer_contract/ta_retinue_employments
	var/datum/ta_retainer_contract/ta_retinue_service
	var/ta_retinue_offer_pending = FALSE
	var/ta_retinue_next_favor = 0

/mob/living/carbon/human/proc/taRetinueCapacity()
	switch(taAppliedNobilityTier())
		if(1)
			return 1
		if(2)
			return 3
		if(3)
			return 10
	return 0

/mob/living/carbon/human/proc/taSyncRetinueVerbs()
	if(taRetinueCapacity())
		add_verb(src, /mob/living/carbon/human/proc/taOfferRetinueService)
	else
		remove_verb(src, /mob/living/carbon/human/proc/taOfferRetinueService)
	if(length(mind?.ta_retinue_employments))
		add_verb(src, /mob/living/carbon/human/proc/taManageRetinueService)
	else
		remove_verb(src, /mob/living/carbon/human/proc/taManageRetinueService)
	if(mind?.ta_retinue_service)
		add_verb(src, /mob/living/carbon/human/proc/taLeaveRetinueService)
	else
		remove_verb(src, /mob/living/carbon/human/proc/taLeaveRetinueService)

/mob/living/carbon/human/proc/taCanOfferRetinueService(
	mob/living/carbon/human/candidate
)
	var/capacity = taRetinueCapacity()
	if(
		!capacity \
		|| stat != CONSCIOUS \
		|| !client \
		|| mind?.current != src \
		|| length(mind.ta_retinue_employments) >= capacity
	)
		return FALSE
	if(
		QDELETED(candidate) \
		|| candidate == src \
		|| candidate.stat != CONSCIOUS \
		|| !candidate.client \
		|| candidate.mind?.current != candidate \
		|| candidate.mind.ta_retinue_service
	)
		return FALSE
	if(!Adjacent(candidate) || !(candidate in view(1, src)))
		return FALSE

	// A noble may serve another noble, but the chain of service cannot lead
	// back to them.
	var/datum/mind/superior = mind
	while(superior)
		if(superior == candidate.mind)
			return FALSE
		superior = superior.ta_retinue_service?.employer_ref?.resolve()
	return TRUE

/mob/living/carbon/human/proc/taOfferRetinueService()
	set name = "Предложить службу"
	set category = "RoleUnique.Noble"

	var/capacity = taRetinueCapacity()
	if(
		!capacity \
		|| stat != CONSCIOUS \
		|| !client \
		|| mind?.current != src \
		|| mind.ta_retinue_offer_pending
	)
		return
	if(length(mind.ta_retinue_employments) >= capacity)
		to_chat(src, span_warning("Все места в твоей свите заняты."))
		return

	var/list/candidates = list()
	for(var/mob/living/carbon/human/candidate in view(1, src))
		if(
			taCanOfferRetinueService(candidate) \
			&& !candidate.mind.ta_retinue_offer_pending
		)
			candidates += candidate
	if(!length(candidates))
		to_chat(
			src,
			span_notice("Рядом нет никого, кому можно предложить службу.")
		)
		return

	var/datum/mind/employer_mind = mind
	employer_mind.ta_retinue_offer_pending = TRUE
	var/mob/living/carbon/human/retainer = tgui_input_list(
		src,
		"Кому предложить службу?",
		"Свита",
		candidates,
		timeout = 30 SECONDS,
	)
	if(
		QDELETED(src) \
		|| mind != employer_mind \
		|| !taCanOfferRetinueService(retainer) \
		|| retainer.mind.ta_retinue_offer_pending
	)
		employer_mind.ta_retinue_offer_pending = FALSE
		return

	var/datum/mind/retainer_mind = retainer.mind
	retainer_mind.ta_retinue_offer_pending = TRUE
	var/accepted = tgui_alert(retainer, \
		"Поступить на службу к [real_name]? Твоя служба будет видна при \
		осмотре.", \
		"Предложение службы", list(
		"Принять",
		"Отказаться",
	), 30 SECONDS, autofocus = FALSE) == "Принять"
	employer_mind.ta_retinue_offer_pending = FALSE
	retainer_mind.ta_retinue_offer_pending = FALSE
	if(
		QDELETED(src) \
		|| QDELETED(retainer) \
		|| mind != employer_mind \
		|| retainer.mind != retainer_mind
	)
		return
	if(!accepted)
		to_chat(src, span_notice("Предложение службы не принято."))
		return
	if(!taCanOfferRetinueService(retainer))
		to_chat(
			src,
			span_warning("Сейчас принять этого человека на службу уже нельзя.")
		)
		return

	new /datum/ta_retainer_contract(employer_mind, retainer_mind)
	visible_message(span_notice("[src] принимает [retainer] в свою свиту."))
	to_chat(
		retainer,
		span_notice("Ты поступил на службу к [html_encode(real_name)].")
	)

/mob/living/carbon/human/proc/taManageRetinueService()
	set name = "Управлять свитой"
	set category = "RoleUnique.Noble"

	if(
		stat != CONSCIOUS \
		|| !client \
		|| mind?.current != src \
		|| !length(mind.ta_retinue_employments)
	)
		return
	var/list/choices = list()
	var/list/repeat_names = list()
	for(var/datum/ta_retainer_contract/contract in mind.ta_retinue_employments)
		var/datum/mind/retainer_mind = contract.retainer_ref.resolve()
		if(retainer_mind)
			var/label = avoid_assoc_duplicate_keys(
				retainer_mind.current?.real_name || retainer_mind.name,
				repeat_names
			)
			choices[label] = contract
	if(!length(choices))
		return
	var/selected = tgui_input_list(
		src,
		"Чью службу обсудить?",
		"Свита",
		choices,
		timeout = 30 SECONDS,
	)
	var/datum/ta_retainer_contract/contract = choices[selected]
	if(!QDELETED(contract))
		contract.requestEnd(src)

/mob/living/carbon/human/proc/taLeaveRetinueService()
	set name = "Обсудить свою службу"
	set category = "RoleUnique.Noble"

	mind?.ta_retinue_service?.requestEnd(src)

/datum/ta_retainer_contract
	var/datum/weakref/employer_ref
	var/datum/weakref/retainer_ref
	var/mob/living/carbon/human/employer_body
	var/mob/living/carbon/human/retainer_body
	var/mood_timer
	var/mutual_end_pending = FALSE

/datum/ta_retainer_contract/New(datum/mind/employer, datum/mind/retainer)
	. = ..()
	employer_ref = WEAKREF(employer)
	retainer_ref = WEAKREF(retainer)
	LAZYADD(employer.ta_retinue_employments, src)
	retainer.ta_retinue_service = src
	RegisterSignal(
		employer,
		COMSIG_MIND_TRANSFERRED,
		PROC_REF(onMindTransferred)
	)
	RegisterSignal(
		retainer,
		COMSIG_MIND_TRANSFERRED,
		PROC_REF(onMindTransferred)
	)
	RegisterSignal(employer, COMSIG_PARENT_QDELETING, PROC_REF(onMindDeleted))
	RegisterSignal(retainer, COMSIG_PARENT_QDELETING, PROC_REF(onMindDeleted))
	bindEmployer(employer.current)
	bindRetainer(retainer.current)
	mood_timer = addtimer( \
		CALLBACK(src, PROC_REF(observeMood)), \
		10 SECONDS, \
		TIMER_STOPPABLE | TIMER_LOOP \
	)

/datum/ta_retainer_contract/Destroy()
	if(mood_timer)
		deltimer(mood_timer)
		mood_timer = null
	var/datum/mind/employer = employer_ref?.resolve()
	var/datum/mind/retainer = retainer_ref?.resolve()
	if(employer)
		UnregisterSignal(employer, list(
			COMSIG_MIND_TRANSFERRED,
			COMSIG_PARENT_QDELETING,
		))
		LAZYREMOVE(employer.ta_retinue_employments, src)
	if(retainer)
		UnregisterSignal(retainer, list(
			COMSIG_MIND_TRANSFERRED,
			COMSIG_PARENT_QDELETING,
		))
		if(retainer.ta_retinue_service == src)
			retainer.ta_retinue_service = null
	bindEmployer(null)
	bindRetainer(null)
	return ..()

/datum/ta_retainer_contract/proc/bindEmployer(mob/new_body)
	var/mob/living/carbon/human/old_body = employer_body
	if(old_body)
		UnregisterSignal(old_body, list(
			COMSIG_LIVING_DEATH,
			COMSIG_PARENT_QDELETING,
			COMSIG_MOB_HUGGED,
			COMSIG_MOB_PATTED,
		))
	employer_body = ishuman(new_body) && !QDELETED(new_body) ? new_body : null
	if(old_body && !QDELETED(old_body))
		old_body.taSyncRetinueVerbs()
	if(employer_body)
		RegisterSignal(employer_body, COMSIG_LIVING_DEATH, PROC_REF(on_death))
		RegisterSignal(
			employer_body,
			COMSIG_PARENT_QDELETING,
			PROC_REF(onBodyDeleted)
		)
		RegisterSignal(employer_body, COMSIG_MOB_HUGGED, PROC_REF(onAttention))
		RegisterSignal(employer_body, COMSIG_MOB_PATTED, PROC_REF(onAttention))
		employer_body.taSyncRetinueVerbs()

/datum/ta_retainer_contract/proc/bindRetainer(mob/new_body)
	var/mob/living/carbon/human/old_body = retainer_body
	if(old_body)
		UnregisterSignal(old_body, list(
			COMSIG_LIVING_DEATH,
			COMSIG_PARENT_QDELETING,
			COMSIG_PARENT_EXAMINE,
		))
	retainer_body = ishuman(new_body) && !QDELETED(new_body) ? new_body : null
	if(old_body && !QDELETED(old_body))
		old_body.taSyncRetinueVerbs()
	if(retainer_body)
		RegisterSignal(retainer_body, COMSIG_LIVING_DEATH, PROC_REF(on_death))
		RegisterSignal(
			retainer_body,
			COMSIG_PARENT_QDELETING,
			PROC_REF(onBodyDeleted)
		)
		RegisterSignal(
			retainer_body,
			COMSIG_PARENT_EXAMINE,
			PROC_REF(on_examine)
		)
		retainer_body.taSyncRetinueVerbs()

/datum/ta_retainer_contract/proc/onMindTransferred(
	datum/mind/source,
	mob/old_body
)
	SIGNAL_HANDLER
	if(source == employer_ref.resolve())
		bindEmployer(source.current)
	else if(source == retainer_ref.resolve())
		bindRetainer(source.current)

/datum/ta_retainer_contract/proc/onMindDeleted(datum/mind/source)
	SIGNAL_HANDLER
	LAZYREMOVE(source.ta_retinue_employments, src)
	if(source.ta_retinue_service == src)
		source.ta_retinue_service = null
	qdel(src)

/datum/ta_retainer_contract/proc/onBodyDeleted(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(source == employer_body)
		bindEmployer(null)
	if(source == retainer_body)
		bindRetainer(null)

/datum/ta_retainer_contract/proc/on_examine(
	mob/living/carbon/human/source,
	mob/user,
	list/lines
)
	SIGNAL_HANDLER
	var/datum/mind/employer = employer_ref.resolve()
	var/employer_name = employer_body?.real_name || employer?.name
	if(!employer_name || source.stat == DEAD)
		return
	if(
		user != source \
		&& !isobserver(user) \
		&& source.get_visible_name() != source.real_name
	)
		return
	lines += span_notice("In the service of [html_encode(employer_name)].")

/datum/ta_retainer_contract/proc/onAttention(
	mob/living/carbon/human/source,
	mob/target
)
	SIGNAL_HANDLER
	if(target == retainer_body)
		grantFavor()

/datum/ta_retainer_contract/proc/observeMood()
	if(
		!employer_body?.client \
		|| !retainer_body?.client \
		|| world.time < retainer_body.mind?.ta_retinue_next_favor \
		|| get_dist(employer_body, retainer_body) > 3
	)
		return
	if(
		!(
			employer_body.has_status_effect(/datum/status_effect/mood/good) \
			|| employer_body.has_status_effect(/datum/status_effect/mood/vgood)
		)
	)
		return
	if(employer_body in view(3, retainer_body))
		grantFavor()

/datum/ta_retainer_contract/proc/grantFavor()
	var/datum/mind/retainer = retainer_ref.resolve()
	if(
		!retainer \
		|| world.time < retainer.ta_retinue_next_favor \
		|| !employer_body?.client \
		|| !retainer_body?.client \
		|| employer_body.stat != CONSCIOUS \
		|| retainer_body.stat != CONSCIOUS
	)
		return
	if(retainer_body.has_stress_event(/datum/stressevent/ta_retinue_favor))
		return
	retainer.ta_retinue_next_favor = world.time + 5 MINUTES
	retainer_body.add_stress(/datum/stressevent/ta_retinue_favor)

/datum/ta_retainer_contract/proc/on_death(
	mob/living/carbon/human/source,
	gibbed
)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/survivor = source == employer_body \
		? retainer_body : employer_body
	var/datum/mind/survivor_mind = source == employer_body \
		? retainer_ref.resolve() : employer_ref.resolve()
	if(survivor_mind)
		if(
			survivor?.client \
			&& survivor.stat == CONSCIOUS \
			&& get_dist(source, survivor) <= 5 \
			&& (source in view(5, survivor))
		)
			survivor.add_stress(/datum/stressevent/ta_retinue_grief)
		else if(!gibbed)
			new /datum/ta_retainer_loss(source, survivor_mind)
	qdel(src)

/datum/ta_retainer_contract/proc/requestEnd(mob/living/carbon/human/user)
	var/datum/mind/employer = employer_ref.resolve()
	var/datum/mind/retainer = retainer_ref.resolve()
	var/datum/mind/initiator = user.mind
	if(
		!user.client \
		|| user.stat != CONSCIOUS \
		|| initiator?.current != user \
		|| (initiator != employer && initiator != retainer)
	)
		return
	var/is_employer = initiator == employer
	var/datum/mind/other = is_employer ? retainer : employer
	var/end_verb = is_employer ? "Отпустить" : "Уйти"
	var/choice = tgui_alert(user, "Как закончить службу?", "Свита", list(
		end_verb,
		"По согласию",
		"Отмена",
	), 30 SECONDS)
	if(
		QDELETED(src) \
		|| QDELETED(user) \
		|| user.mind != initiator \
		|| initiator.current != user \
		|| user.stat != CONSCIOUS
	)
		return
	if(choice == end_verb)
		var/mob/living/carbon/human/other_body = other?.current
		if(istype(other_body) && other_body.stat != DEAD)
			other_body.add_stress(/datum/stressevent/ta_retinue_departure)
			to_chat(
				other_body,
				span_notice("Твоя договорённость о службе расторгнута.")
			)
		to_chat(user, span_notice("Служба окончена."))
		qdel(src)
	else if(choice == "По согласию" && !mutual_end_pending)
		var/mob/living/carbon/human/other_body = other?.current
		if(
			!istype(other_body) \
			|| other_body.stat != CONSCIOUS \
			|| !other_body.client
		)
			to_chat(
				user,
				span_notice("Сейчас вторая сторона не может ответить.")
			)
			return
		mutual_end_pending = TRUE
		var/accepted = tgui_alert(other_body, \
			"[user.real_name] предлагает закончить службу по взаимному \
			согласию.", \
			"Свита", list(
			"Согласиться",
			"Отказаться",
		), 30 SECONDS, autofocus = FALSE) == "Согласиться"
		if(QDELETED(src))
			return
		mutual_end_pending = FALSE
		if(
			QDELETED(user) \
			|| QDELETED(other_body) \
			|| user.mind != initiator \
			|| initiator.current != user \
			|| other_body.mind != other \
			|| other.current != other_body \
			|| user.stat != CONSCIOUS \
			|| other_body.stat != CONSCIOUS
		)
			return
		if(!accepted)
			to_chat(
				user,
				span_notice("Предложение закончить службу не принято.")
			)
			return
		to_chat(user, span_notice("Служба окончена по взаимному согласию."))
		to_chat(
			other_body,
			span_notice("Служба окончена по взаимному согласию.")
		)
		qdel(src)

/// Record an unwitnessed loss until the survivor sees the body or the body is
// gone.
/datum/ta_retainer_loss
	var/datum/weakref/body_ref
	var/datum/weakref/survivor_ref

/datum/ta_retainer_loss/New(mob/living/carbon/human/body, datum/mind/survivor)
	. = ..()
	body_ref = WEAKREF(body)
	survivor_ref = WEAKREF(survivor)
	RegisterSignal(body, COMSIG_PARENT_EXAMINE, PROC_REF(onDiscovery))
	RegisterSignal(body, COMSIG_LIVING_REVIVE, PROC_REF(onGone))
	RegisterSignal(body, COMSIG_PARENT_QDELETING, PROC_REF(onGone))
	RegisterSignal(survivor, COMSIG_PARENT_QDELETING, PROC_REF(onGone))

/datum/ta_retainer_loss/Destroy()
	var/mob/living/carbon/human/body = body_ref?.resolve()
	var/datum/mind/survivor = survivor_ref?.resolve()
	if(body)
		UnregisterSignal(body, list(
			COMSIG_PARENT_EXAMINE,
			COMSIG_LIVING_REVIVE,
			COMSIG_PARENT_QDELETING,
		))
	if(survivor)
		UnregisterSignal(survivor, COMSIG_PARENT_QDELETING)
	return ..()

/datum/ta_retainer_loss/proc/onDiscovery(
	mob/living/carbon/human/body,
	mob/living/carbon/human/user,
	list/lines
)
	SIGNAL_HANDLER
	if(
		!istype(user) \
		|| !user.client \
		|| user.stat != CONSCIOUS \
		|| user.mind != survivor_ref.resolve() \
		|| body.stat != DEAD
	)
		return
	if(get_dist(body, user) > 5 || !(body in view(5, user)))
		return
	user.add_stress(/datum/stressevent/ta_retinue_grief)
	qdel(src)

/datum/ta_retainer_loss/proc/onGone(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/stressevent/ta_retinue_favor
	stressadd = -1
	timer = 2 MINUTES
	desc = span_green("Мою службу ценят.")

/datum/stressevent/ta_retinue_grief
	stressadd = 2
	timer = 8 MINUTES
	desc = span_red("Смерть оборвала нашу службу.")

/datum/stressevent/ta_retinue_departure
	stressadd = 1
	timer = 5 MINUTES
	desc = span_red("Нашу службу расторгли без моего согласия.")
