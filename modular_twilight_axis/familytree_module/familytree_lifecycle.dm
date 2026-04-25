/datum/job/roguetown/lady/special_check_latejoin(client/C)
	return SSfamilytree.royal_partner_candidate_allowed(C, src)

/datum/job/roguetown/suitor/special_check_latejoin(client/C)
	return SSfamilytree.royal_partner_candidate_allowed(C, src)
// DLC: Enigma roles integration for familytree tier system.
// Appends enigma job types to existing tier lists at runtime.

/datum/controller/subsystem/familytree/proc/load_enigma_roles()
	// Garrison (military)
	high_tier_military_types |= list(
		/datum/job/roguetown/sheriff,
		/datum/job/roguetown/royal_sergeant,
		/datum/job/roguetown/royal_guard,
		/datum/job/roguetown/town_watch,
		/datum/job/roguetown/vanguard,
		/datum/job/roguetown/overseer,
		/datum/job/roguetown/dungeoneer,
	)

	// Retinue (military)
	high_tier_military_types |= list(
		/datum/job/roguetown/knight_enigma,
	)

	// Town administration
	high_tier_town_types |= list(
		/datum/job/roguetown/mayor,
		/datum/job/roguetown/bailiff,
		/datum/job/roguetown/courtphysician,
	)

/datum/controller/subsystem/familytree/proc/ask_monarch_noble_permission(mob/living/carbon/human/monarch)
	if(!monarch?.client)
		return
	INVOKE_ASYNC(src, PROC_REF(do_ask_monarch_noble_permission), monarch)

/datum/controller/subsystem/familytree/proc/do_ask_monarch_noble_permission(mob/living/carbon/human/monarch)
	if(!monarch?.client)
		return
	var/result = tgui_alert(monarch, "Могут ли другие дворяне (рыцари, советники и прочие с благородной кровью) быть частью вашей семьи?", "Герцогская семья", list("Да", "Нет"))

	if(!monarch || QDELETED(monarch))
		return

	if(result == "Да")
		allow_nobles_in_ruling_family = TRUE
		ftlog("NOBLE DYNASTY: [monarch.real_name] allowed nobles in ruling family")
		to_chat(monarch, span_notice("Дворяне с благородной кровью теперь могут стать частью вашей семьи."))
		if(monarch?.client?.prefs)
			current_royal_partner_owner = null
			current_royal_partner_snapshot = list()
			refresh_royal_partner_jobs(monarch, monarch.client.prefs)
	else
		ftlog("NOBLE DYNASTY: [monarch.real_name] denied nobles in ruling family")

/datum/controller/subsystem/familytree/proc/try_assign_noble_to_dynasty(mob/living/carbon/human/H)
	if(!allow_nobles_in_ruling_family)
		return FALSE
	if(!ruling_family)
		return FALSE
	if(!H || H.family_datum)
		return FALSE
	if(!HAS_TRAIT(H, TRAIT_NOBLE))
		return FALSE

	var/block = get_familytree_runtime_block_reason(H)
	if(block)
		return FALSE

	if(familytree_get_role_tier(H) == ROLE_TIER_LOW)
		ftlog("NOBLE DYNASTY: [H.real_name] blocked - low status role not allowed in ruling family")
		return FALSE
	if(familytree_get_role_tier(H) == ROLE_TIER_NONE && !is_royal_hand_job(get_familytree_job(H)))
		ftlog("NOBLE DYNASTY: [H.real_name] blocked - no tier role")
		return FALSE
	ftlog("NOBLE DYNASTY: [H.real_name] eligible for ruling family (noble dynasty entry)")
	request_family_confirmation(H, CALLBACK(src, PROC_REF(do_assign_noble_to_dynasty), H), "dynasty")
	return TRUE

/datum/controller/subsystem/familytree/proc/do_assign_noble_to_dynasty(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || H.family_datum)
		return
	if(!ruling_family)
		return

	var/datum/family_member/new_member = ruling_family.CreateFamilyMember(H)
	if(!new_member)
		return

	var/datum/family_member/monarch = GetCurrentMonarch()
	if(monarch)
		if(CanBeSiblings(H.age, monarch.person?.age))
			var/list/monarch_parents = monarch.get_parent_members()
			if(monarch_parents.len)
				new_member.AddParent(monarch_parents[1])
				if(monarch_parents.len > 1)
					new_member.AddParent(monarch_parents[2])
			new_member.generation = monarch.generation
		else
			new_member.generation = monarch.generation

	ftlog("NOBLE DYNASTY: [H.real_name] added to ruling family")
	familytree_admin_log_house_assignment(H, ruling_family, "joined ruling family through noble dynasty", monarch)
	to_chat(H, span_love("Вы были приняты в герцогскую семью!"))
	stop_tracking_human(H, "assigned to ruling family as noble")

/datum/controller/subsystem/familytree/proc/notify_family_head_departure(mob/living/carbon/human/departed)
	if(!departed?.family_datum)
		return
	var/datum/heritage/house = departed.family_datum
	if(!house.founder?.person)
		return
	var/mob/living/carbon/human/head = house.founder.person
	if(head == departed)
		return
	if(!head.client)
		return

	var/datum/family_member/departed_member = house.GetFamilyMember(departed)
	if(!departed_member)
		return

	var/relation = head.family_member_datum?.GetRelationshipTo(departed_member)
	if(!relation)
		relation = "родственник"

	to_chat(head, span_warning("Ваш [relation] [departed.real_name] покинул эти земли. Вы чувствуете тревогу."))
	ftlog("NOTIFY: [head.real_name] notified about [departed.real_name] departure ([relation])")

/datum/controller/subsystem/familytree/proc/offer_setspouse_reset(mob/living/carbon/human/H, status)
	if(!H?.client)
		return
	var/result = tgui_alert(H, "Вы уже 30 минут ожидаете фаворита '[H.setspouse]', но он не найден.\n\nХотите сбросить предпочтение по нику и искать пару по текущим настройкам?", "Семейная система", list("Да, сбросить", "Нет, продолжить ждать"))

	if(!H || QDELETED(H))
		return

	if(result == "Да, сбросить")
		ftlog("SETSPOUSE RESET: [H.real_name] cleared setspouse '[H.setspouse]'")
		H.setspouse = ""
		H.familytree_assignment_scheduled = FALSE
		run_local_assignment(H, status)
	else
		ftlog("SETSPOUSE KEEP: [H.real_name] continues waiting for '[H.setspouse]'")
		H.familytree_assignment_scheduled = TRUE
		addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, status), 60 SECONDS)

#define MUTUAL_CONFIRM_TIMEOUT 60 SECONDS
#define CONFIRM_PENDING 0
#define CONFIRM_ACCEPTED 1
#define CONFIRM_REJECTED 2
#define CONFIRM_TIMEOUT 3

/datum/family_confirm_session
	var/mob/living/carbon/human/person_a
	var/mob/living/carbon/human/person_b
	var/datum/callback/on_both_accept
	var/confirm_type
	var/result_a = CONFIRM_PENDING
	var/result_b = CONFIRM_PENDING
	var/resolved = FALSE
	var/timerid

/datum/family_confirm_session/New(mob/living/carbon/human/a, mob/living/carbon/human/b, datum/callback/cb, ctype)
	person_a = a
	person_b = b
	on_both_accept = cb
	confirm_type = ctype

/datum/family_confirm_session/Destroy()
	if(timerid)
		deltimer(timerid)
	if(person_a && !QDELETED(person_a) && result_a != CONFIRM_PENDING)
		person_a.familytree_confirmation_pending = FALSE
	if(person_b && !QDELETED(person_b) && result_b != CONFIRM_PENDING)
		person_b.familytree_confirmation_pending = FALSE
	person_a = null
	person_b = null
	on_both_accept = null
	return ..()

/datum/family_confirm_session/proc/check_resolution()
	if(resolved)
		return

	if(result_a == CONFIRM_REJECTED || result_a == CONFIRM_TIMEOUT || result_b == CONFIRM_REJECTED || result_b == CONFIRM_TIMEOUT)
		resolved = TRUE
		if(timerid)
			deltimer(timerid)
		if(result_a == CONFIRM_REJECTED || result_a == CONFIRM_TIMEOUT)
			handle_refusal(person_a, person_b)
		if(result_b == CONFIRM_REJECTED || result_b == CONFIRM_TIMEOUT)
			handle_refusal(person_b, person_a)
		if(result_a == CONFIRM_ACCEPTED)
			notify_cancelled(person_a)
		if(result_b == CONFIRM_ACCEPTED)
			notify_cancelled(person_b)
		if(result_a != CONFIRM_PENDING && result_b != CONFIRM_PENDING)
			qdel(src)
		return

	if(result_a == CONFIRM_PENDING || result_b == CONFIRM_PENDING)
		return

	resolved = TRUE
	if(timerid)
		deltimer(timerid)

	if(result_a == CONFIRM_ACCEPTED && result_b == CONFIRM_ACCEPTED)
		SSfamilytree.ftlog("MUTUAL CONFIRM: both accepted type=[confirm_type] a=[person_a?.real_name] b=[person_b?.real_name]")
		on_both_accept?.Invoke()

	qdel(src)

/datum/family_confirm_session/proc/handle_refusal(mob/living/carbon/human/refuser, mob/living/carbon/human/other)
	if(!refuser || QDELETED(refuser))
		return
	var/reason = "declined"
	if((refuser == person_a ? result_a : result_b) == CONFIRM_TIMEOUT)
		reason = "timeout"
	SSfamilytree.ftlog("MUTUAL CONFIRM: [refuser.real_name] [reason] type=[confirm_type]")
	refuser.familytree_opted_out = TRUE
	SSfamilytree.unsubscribe_familytree_human(refuser, "player [reason] [confirm_type]")
	to_chat(refuser, span_warning("Вы отказались от участия в семейной системе на этот раунд."))

/datum/family_confirm_session/proc/force_timeout()
	if(resolved)
		return
	if(result_a == CONFIRM_PENDING)
		result_a = CONFIRM_TIMEOUT
	if(result_b == CONFIRM_PENDING)
		result_b = CONFIRM_TIMEOUT
	check_resolution()

/datum/family_confirm_session/proc/notify_cancelled(mob/living/carbon/human/person)
	if(!person || QDELETED(person))
		return
	SSfamilytree.ftlog("MUTUAL CONFIRM: [person.real_name] cancelled (other side refused) type=[confirm_type]")
	to_chat(person, span_warning("Другая сторона отказалась от вступления в семью. Ваш запрос отменён. Система попробует найти вам новую пару."))
	if(!person.familytree_opted_out && !person.family_datum && !person.spouse_mob && person.familytree_pref && person.familytree_pref != FAMILY_NONE)
		person.familytree_assignment_scheduled = TRUE
		addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, run_local_assignment), person, person.familytree_pref), 10 SECONDS)

/datum/controller/subsystem/familytree/proc/request_family_confirmation(mob/living/carbon/human/H, datum/callback/on_accept, confirm_type = "family")
	if(!H || QDELETED(H))
		return
	if(H?.familytree_opted_out)
		ftlog("CONFIRM SKIP: [H?.real_name] opted out")
		return
	if(H?.familytree_confirmation_pending)
		ftlog("CONFIRM SKIP: [H?.real_name] already has pending confirmation")
		return
	if(!H?.client)
		on_accept.Invoke()
		return
	H.familytree_confirmation_pending = TRUE
	INVOKE_ASYNC(src, PROC_REF(do_solo_confirmation), H, on_accept, confirm_type)

/datum/controller/subsystem/familytree/proc/do_solo_confirmation(mob/living/carbon/human/H, datum/callback/on_accept, confirm_type)
	if(!H || QDELETED(H))
		return
	if(!H?.client)
		if(H && !QDELETED(H))
			H.familytree_confirmation_pending = FALSE
		on_accept.Invoke()
		return

	var/found_text = (confirm_type == "spouse") ? "Вам нашли пару!" : "Система нашла для вас семью!"
	to_chat(H, span_love(found_text))

	var/result = tgui_alert(H, "[found_text]\n\nХотите продолжить?\n\nЕсли вы не сделаете выбор — он будет засчитан как отказ.\nОтказавшись, вы потеряете возможность найти семью в этом раунде.", "Семейная система", list("Да", "Нет"), 60 SECONDS)

	if(!H || QDELETED(H))
		return

	H.familytree_confirmation_pending = FALSE

	if(result == "Да")
		ftlog("CONFIRM ACCEPT: [H.real_name] type=[confirm_type]")
		on_accept.Invoke()
	else
		ftlog("CONFIRM REJECT: [H.real_name] type=[confirm_type] result=[result || "timeout"]")
		to_chat(H, span_warning("Вы отказались от участия в семейной системе на этот раунд."))
		H.familytree_opted_out = TRUE
		unsubscribe_familytree_human(H, "player declined [confirm_type]")

/datum/controller/subsystem/familytree/proc/request_mutual_confirmation(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b, datum/callback/on_both_accept, confirm_type = "family")
	if(!person_a || QDELETED(person_a) || !person_b || QDELETED(person_b))
		ftlog("MUTUAL SKIP: invalid participant a=[person_a?.real_name] b=[person_b?.real_name]")
		return
	if(person_a?.familytree_opted_out || person_b?.familytree_opted_out)
		ftlog("MUTUAL SKIP: opted out a=[person_a?.real_name] b=[person_b?.real_name]")
		return
	if(person_a?.familytree_confirmation_pending || person_b?.familytree_confirmation_pending)
		ftlog("MUTUAL SKIP: pending confirmation a=[person_a?.real_name] b=[person_b?.real_name]")
		return

	if(!person_a?.client && !person_b?.client)
		on_both_accept.Invoke()
		return
	if(!person_a?.client)
		person_b.familytree_confirmation_pending = TRUE
		INVOKE_ASYNC(src, PROC_REF(do_solo_confirmation), person_b, on_both_accept, confirm_type)
		return
	if(!person_b?.client)
		person_a.familytree_confirmation_pending = TRUE
		INVOKE_ASYNC(src, PROC_REF(do_solo_confirmation), person_a, on_both_accept, confirm_type)
		return

	person_a.familytree_confirmation_pending = TRUE
	person_b.familytree_confirmation_pending = TRUE
	var/datum/family_confirm_session/session = new(person_a, person_b, on_both_accept, confirm_type)
	session.timerid = addtimer(CALLBACK(session, TYPE_PROC_REF(/datum/family_confirm_session, force_timeout)), MUTUAL_CONFIRM_TIMEOUT, TIMER_STOPPABLE)

	ftlog("MUTUAL CONFIRM: started type=[confirm_type] a=[person_a.real_name] b=[person_b.real_name]")

	INVOKE_ASYNC(src, PROC_REF(do_mutual_ask), session, person_a, TRUE)
	INVOKE_ASYNC(src, PROC_REF(do_mutual_ask), session, person_b, FALSE)

/datum/controller/subsystem/familytree/proc/do_mutual_ask(datum/family_confirm_session/session, mob/living/carbon/human/person, is_person_a)
	if(!person?.client)
		if(person && !QDELETED(person))
			person.familytree_confirmation_pending = FALSE
		if(is_person_a && session.result_a == CONFIRM_PENDING)
			session.result_a = CONFIRM_TIMEOUT
		else if(!is_person_a && session.result_b == CONFIRM_PENDING)
			session.result_b = CONFIRM_TIMEOUT
		if(session.resolved)
			if(session.result_a != CONFIRM_PENDING && session.result_b != CONFIRM_PENDING)
				qdel(session)
		else
			session.check_resolution()
		return
	if(session.resolved)
		if(is_person_a && session.result_a == CONFIRM_PENDING)
			session.result_a = CONFIRM_ACCEPTED
		else if(!is_person_a && session.result_b == CONFIRM_PENDING)
			session.result_b = CONFIRM_ACCEPTED
		person.familytree_confirmation_pending = FALSE
		retry_local_assignment(person, "mutual confirmation cancelled")
		if(session.result_a != CONFIRM_PENDING && session.result_b != CONFIRM_PENDING)
			qdel(session)
		return

	var/found_text = (session.confirm_type == "spouse") ? "Вам нашли пару!" : "Система нашла для вас семейную связь!"
	to_chat(person, span_love(found_text))

	var/result = tgui_alert(person, "[found_text]\n\nХотите продолжить?\n\nЕсли вы не сделаете выбор — он будет засчитан как отказ.\nОтказавшись, вы потеряете возможность найти семью в этом раунде.", "Семейная система", list("Да", "Нет"), 60 SECONDS)

	if(!person || QDELETED(person))
		return

	var/accepted = (result == "Да")

	if(session.resolved)
		if(is_person_a)
			session.result_a = accepted ? CONFIRM_ACCEPTED : (result ? CONFIRM_REJECTED : CONFIRM_TIMEOUT)
		else
			session.result_b = accepted ? CONFIRM_ACCEPTED : (result ? CONFIRM_REJECTED : CONFIRM_TIMEOUT)
		person.familytree_confirmation_pending = FALSE
		if(accepted)
			retry_local_assignment(person, "mutual confirmation cancelled")
		else if(!person.familytree_opted_out)
			ftlog("MUTUAL CONFIRM: [person.real_name] declined cancelled type=[session.confirm_type] result=[result || "timeout"]")
			to_chat(person, span_warning("Вы отказались от участия в семейной системе на этот раунд."))
			person.familytree_opted_out = TRUE
			unsubscribe_familytree_human(person, "player declined [session.confirm_type]")
		if(session.result_a != CONFIRM_PENDING && session.result_b != CONFIRM_PENDING)
			qdel(session)
		return

	if(is_person_a)
		session.result_a = accepted ? CONFIRM_ACCEPTED : CONFIRM_REJECTED
	else
		session.result_b = accepted ? CONFIRM_ACCEPTED : CONFIRM_REJECTED

	session.check_resolution()
