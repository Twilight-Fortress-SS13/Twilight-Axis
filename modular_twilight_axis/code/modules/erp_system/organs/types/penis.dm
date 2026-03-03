/datum/erp_sex_organ/penis
	erp_organ_type = SEX_ORGAN_PENIS
	var/have_knot = FALSE
	var/obj/item/organ/penis/source_organ
	var/erect_mode = "auto"
	var/climax_mode = "outside"
	active_arousal = 1.0
	passive_arousal = 1.1
	active_pain = 0.05
	passive_pain = 0.15

/datum/erp_sex_organ/penis/New(obj/item/organ/penis/P)
	. = ..()
	source_organ = P
	host = P
	refresh_from_organ(P)

/datum/erp_sex_organ/penis/get_production_mult()
	return 1

/datum/erp_sex_organ/penis/proc/inject_fraction(ratio = 0.25)
	if(!producing)
		return FALSE

	ratio = clamp(ratio, 0.05, 0.75)
	var/amount = round(producing.total_volume() * ratio)
	if(amount <= 0)
		amount = 1

	return extract_reagents(amount)

/datum/erp_sex_organ/penis/proc/refresh_from_organ(obj/item/organ/penis/P)
	if(!P)
		return

	var/mob/living/carbon/human/H = P.owner
	if(!istype(H))
		return

	switch(P.penis_type)
		if(PENIS_TYPE_KNOTTED, PENIS_TYPE_TAPERED_DOUBLE_KNOTTED, PENIS_TYPE_BARBED_KNOTTED)
			have_knot = TRUE
		else
			have_knot = FALSE

	var/datum/component/erp_knotting/K = H.GetComponent(/datum/component/erp_knotting)
	if(have_knot)
		if(!K)
			H.AddComponent(/datum/component/erp_knotting)
	else
		if(K)
			qdel(K)

	var/double_count = (P.penis_type in list(PENIS_TYPE_TAPERED_DOUBLE,	PENIS_TYPE_TAPERED_DOUBLE_KNOTTED))

	if(double_count)
		count_to_action = 2

	var/obj/item/organ/testicles/T = H.getorganslot(ORGAN_SLOT_TESTICLES)
	if(!T)
		return

	var/ball_size = T.ball_size
	var/new_capacity = 12 + (3 * ball_size)
	var/new_rate = ball_size * 0.25

	if(!storage)
		storage = new(new_capacity, src)

	if(!producing)
		producing = new(new_capacity, src)

	producing.capacity = new_capacity
	producing.producing_reagent = /datum/reagent/erpjuice/cum
	producing.production_rate = new_rate
	if(storage.total_volume() > new_capacity)
		storage.drain(storage.total_volume() - new_capacity)

/obj/item/organ/penis
	var/manual_erection_override = FALSE

/obj/item/organ/penis/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	RegisterSignal(M, COMSIG_SEX_AROUSAL_CHANGED, PROC_REF(on_arousal_changed), TRUE)
	refresh_sex_organ()

/obj/item/organ/penis/Remove(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	UnregisterSignal(M, COMSIG_SEX_AROUSAL_CHANGED)
	var/datum/component/erp_knotting/knoting_object = M.GetComponent(/datum/component/erp_knotting)
	if(knoting_object)
		qdel(knoting_object)

/obj/item/organ/penis/on_arousal_changed()
	if(manual_erection_override)
		return

	var/list/arousal_data = list()
	SEND_SIGNAL(owner, COMSIG_SEX_GET_AROUSAL, arousal_data)

	var/max_arousal = MAX_AROUSAL || 120
	var/current_arousal = arousal_data["arousal"] || 0
	var/arousal_percent = min(100, (current_arousal / max_arousal) * 100)

	var/new_state = ERECT_STATE_NONE
	switch(arousal_percent)
		if(0 to 10)
			new_state = ERECT_STATE_NONE
		if(11 to 35)
			new_state = ERECT_STATE_PARTIAL
		if(36 to 100)
			new_state = ERECT_STATE_HARD

	update_erect_state(new_state)

/obj/item/organ/penis/proc/refresh_sex_organ()
	if(!sex_organ)
		sex_organ = new /datum/erp_sex_organ/penis(src)
	else
		var/datum/erp_sex_organ/penis/SP = sex_organ
		SP.refresh_from_organ(src)

/obj/item/organ/penis/proc/set_manual_erect_state(state)
	manual_erection_override = TRUE
	erect_state = state
	if(owner)
		owner.update_body_parts(TRUE)

/obj/item/organ/penis/proc/disable_manual_erect()
	manual_erection_override = FALSE
	erect_state = null
	on_arousal_changed()
