/datum/sleep_adv
	var/list/queued_wake_events = list()
	var/noc_inspired = FALSE
	var/dream_roll_cost = 5

/datum/sleep_adv/proc/roll_dream_event()
	var/mob/living/carbon/human/H = mind.current
	if(!istype(H))
		return

	if(sleep_adv_points < dream_roll_cost)
		to_chat(H, span_warning("Мне не хватает очков снов для погружения в глубокий сон."))
		return

	sleep_adv_points -= dream_roll_cost
	var/stress = H.get_stress_amount()
	var/positive_chance = 50
	if(stress < 0)
		positive_chance += abs(stress) * 3
	else
		positive_chance -= stress * 2

	var/bed_bonus = -15
	var/comfort = 0

	if(H.buckled)
		comfort = H.buckled.sleepy
	else
		var/turf/T = get_turf(H)
		if(T)
			for(var/obj/structure/S in T)
				if(S.sleepy > comfort)
					comfort = S.sleepy

	if(comfort > 0)
		if(comfort >= 3)
			bed_bonus = 25
			to_chat(H, span_notice("Мягкая постель согревает мою душу, даруя спокойные и легкие сны."))
		else if(comfort >= 2)
			bed_bonus = 15
			to_chat(H, span_notice("Я сплю в относительном тепле и удобстве."))
		else if(comfort >= 1.5)
			bed_bonus = 10
			to_chat(H, span_warning("Жесткое спальное место колет мне бока."))
		else
			bed_bonus = 5
			to_chat(H, span_danger("Ужасное и холодное ложе навевает мне кошмары..."))
	else
		to_chat(H, span_danger("Сон на холодном, сыром полу отзывается сильной ломотой во всем теле..."))

	positive_chance += bed_bonus

	var/blanket_bonus = -10
	for(var/obj/item/bedsheet/BS in H.loc)
		if(BS.signal_sleeper?.resolve() == H)
			if(istype(BS, /obj/item/bedsheet/rogue/double_pelt) || istype(BS, /obj/item/bedsheet/rogue/fabric_double))
				blanket_bonus = 20
			else if(istype(BS, /obj/item/bedsheet/rogue/pelt) || istype(BS, /obj/item/bedsheet/rogue/wool))
				blanket_bonus = 15
			else
				blanket_bonus = 10
			break
	positive_chance += blanket_bonus
	if(noc_inspired)
		positive_chance += 25
		noc_inspired = FALSE
		to_chat(H, span_blue("Голубой полумесяц на моем лбу сияет теплым астральным светом, направляя мои сны по благословенному пути Нок..."))

	positive_chance = clamp(positive_chance, 5, 95)

	if(prob(20))
		to_chat(H, span_notice("Мой сон был глубок и спокоен, но ничто не потревожило мою душу."))
		return

	var/is_positive = prob(positive_chance)
	var/list/viable_events = list()
	for(var/path in GLOB.dream_events)
		var/datum/dream_event/DE = GLOB.dream_events[path]
		if(DE.is_positive == is_positive && DE.can_trigger(H))
			viable_events += DE

	if(!length(viable_events))
		to_chat(H, span_notice("Никакие знамения не явились мне в этом сне."))
		return

	var/datum/dream_event/chosen_event = pick(viable_events)
	chosen_event.on_dream(H, src)
	queued_wake_events += chosen_event.type

/mob/living/carbon/human/proc/reset_sleep_deprivation()
	days_without_sleep = 0
	remove_status_effect(/datum/status_effect/debuff/sleepytime)
	remove_stress(/datum/stressevent/sleepytime)
	remove_stress(/datum/stressevent/sleep_deprivation_2)
	remove_stress(/datum/stressevent/sleep_deprivation_3)
	remove_stress(/datum/stressevent/sleep_deprivation_4)

	if(hallucination > 0 && !has_flaw(/datum/charflaw/mind_broken))
		hallucination = 0
	REMOVE_TRAIT(src, TRAIT_PSYCHOSIS, "sleep_deprivation")
