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

/datum/controller/subsystem/familytree/proc/load_deserttown_roles()
	high_tier_nobility_types |= list(
		/datum/job/roguetown/sultan,
		/datum/job/roguetown/vizier,
		/datum/job/roguetown/sheikh,
	)

	high_tier_military_types |= list(
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/slavemaster,
	)

	low_tier_job_types |= list(
		/datum/job/roguetown/headslave,
		/datum/job/roguetown/slave,
		/datum/job/roguetown/freeman,
	//	/datum/job/roguetown/lost_grenzel, // Lost Grenzel comment
	)

	low_tier_job_titles |= list(
		"Head Slave",
		"Palace Slave",
		"Slave",
		"Freeman",
	//	"Lost Grenzel", // Lost Grenzel comment
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
	request_family_confirmation(H, CALLBACK(src, PROC_REF(do_assign_noble_to_dynasty), H), "dynasty", familytree_role_text_ru("relative"))
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
	if(round_disabled)
		return
	if(!H?.client)
		return
	var/offered_target = familytree_get_target_name(H)
	if(!offered_target || !length(offered_target))
		return
	var/result = tgui_alert(H, "Вы уже [DisplayTimeText(FAMILYTREE_SETSPOUSE_TIMEOUT)] ожидаете фаворита '[offered_target]', но он не найден.\n\nХотите сбросить предпочтение по нику и искать пару по текущим настройкам?", "Семейная система", list("Да, сбросить", "Нет, продолжить ждать"), 60 SECONDS)

	if(!H || QDELETED(H))
		return

	var/current_target = familytree_get_target_name(H)
	if(current_target != offered_target)
		ftlog("SETSPOUSE RESET STALE: [H.real_name] target changed from '[offered_target]' to '[current_target]'")
		H.familytree_setspouse_retries = 0
		H.familytree_setspouse_timeout_offered = FALSE
		H.familytree_setspouse_wait_started = 0
		if(!H.familytree_assignment_scheduled && !H.familytree_confirmation_pending && !H.family_datum && !H.familytree_opted_out && familytree_pref_enabled(H.familytree_pref))
			H.familytree_assignment_scheduled = TRUE
			addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), 1 SECONDS)
		return

	if(result == "Да, сбросить")
		ftlog("SETSPOUSE RESET: [H.real_name] cleared setspouse '[offered_target]'")
		H.setspouse = ""
		var/datum/familytree_prefs/round_prefs = familytree_get_round_prefs(H, FALSE)
		round_prefs?.clear_setspouse()
		var/datum/preferences/P = H.client?.prefs
		if(P)
			P.familytree_module_load_character()
			P.setspouse = ""
			P.familytree_module_save_character()
			load_familytree_runtime_preferences(H, P)
		else
			H.familytree_setspouse_retries = 0
			H.familytree_setspouse_timeout_offered = FALSE
			H.familytree_setspouse_wait_started = 0
		H.familytree_assignment_scheduled = FALSE
		run_local_assignment(H, status)
	else
		var/reset_result = result ? result : "timeout"
		ftlog("SETSPOUSE KEEP: [H.real_name] continues waiting for '[offered_target]' result=[reset_result]")
		H.familytree_assignment_scheduled = TRUE
		addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, status), 60 SECONDS)

#define MUTUAL_CONFIRM_TIMEOUT 2 MINUTES
#define CONFIRM_PENDING 0
#define CONFIRM_ACCEPTED 1
#define CONFIRM_REJECTED 2
#define CONFIRM_TIMEOUT 3

/datum/family_confirm_prompt
	var/mob/living/carbon/human/person
	var/mob/living/carbon/human/context_person
	var/datum/family_confirm_session/session
	var/datum/callback/on_accept
	var/confirm_type = "family"
	var/relation_text
	var/body = ""
	var/button_text = "Система нашла для вас семейную связь!"
	var/is_person_a = FALSE
	var/is_mutual = FALSE
	var/resolved = FALSE
	var/created_at = 0
	var/last_opened_at = 0
	var/open_count = 0

/datum/family_confirm_prompt/New(mob/living/carbon/human/new_person, new_body, new_button_text, new_confirm_type = "family", mob/living/carbon/human/new_context_person = null, datum/callback/new_on_accept = null, datum/family_confirm_session/new_session = null, new_is_person_a = FALSE, new_relation_text = null)
	. = ..()
	person = new_person
	body = new_body
	button_text = new_button_text
	confirm_type = new_confirm_type
	context_person = new_context_person
	on_accept = new_on_accept
	session = new_session
	is_person_a = new_is_person_a
	is_mutual = !!new_session
	relation_text = new_relation_text
	created_at = world.time

/datum/family_confirm_prompt/Destroy(force)
	if(person && !QDELETED(person) && person.familytree_confirm_prompt == src)
		person.familytree_confirm_prompt = null
	person = null
	context_person = null
	session = null
	on_accept = null
	return ..()

/datum/family_confirm_prompt/ui_state(mob/user)
	return GLOB.always_state

/datum/family_confirm_prompt/ui_interact(mob/user, datum/tgui/ui)
	if(SSfamilytree.round_disabled)
		return FALSE
	if(resolved || !person || QDELETED(person) || user != person)
		return FALSE
	if(!person.client || !person.familytree_confirmation_pending)
		return FALSE

	var/was_open = !!ui
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FamilyConfirmPanel")
		open_count++
		last_opened_at = world.time
		SSfamilytree.ftlog("FAMILY CONFIRM UI OPEN: name=[person.real_name] type=[confirm_type] mutual=[is_mutual] open_count=[open_count]")
		ui.open()
	else if(!was_open)
		last_opened_at = world.time
	return TRUE

/datum/family_confirm_prompt/ui_data(mob/user)
	return list(
		"title" = "Семейная система",
		"message" = body,
		"mutual" = is_mutual,
		"openCount" = open_count,
	)

/datum/family_confirm_prompt/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(resolved || !person || QDELETED(person) || ui?.user != person)
		return FALSE

	switch(action)
		if("accept")
			submit_choice(CONFIRM_ACCEPTED)
			return TRUE
		if("reject")
			submit_choice(CONFIRM_REJECTED)
			return TRUE
	return FALSE

/datum/family_confirm_prompt/ui_close()
	if(resolved || !person || QDELETED(person))
		return
	var/elapsed = last_opened_at ? max(0, world.time - last_opened_at) : 0
	SSfamilytree.ftlog("FAMILY CONFIRM UI CLOSE: name=[person.real_name] type=[confirm_type] mutual=[is_mutual] elapsed=[DisplayTimeText(elapsed)] result=pending")

/datum/family_confirm_prompt/proc/open_prompt()
	if(SSfamilytree.round_disabled)
		return
	if(resolved || !person || QDELETED(person) || !person.client)
		return
	if(!person.familytree_confirmation_pending)
		return
	ui_interact(person)

/datum/family_confirm_prompt/proc/submit_choice(choice_result)
	if(SSfamilytree.round_disabled)
		return
	if(resolved || !person || QDELETED(person))
		return
	if(choice_result != CONFIRM_ACCEPTED && choice_result != CONFIRM_REJECTED)
		return

	resolved = TRUE
	var/mob/living/carbon/human/current_person = person
	SSfamilytree.ftlog("FAMILY CONFIRM CHOICE: name=[current_person.real_name] type=[confirm_type] mutual=[is_mutual] result=[choice_result == CONFIRM_ACCEPTED ? "accept" : "reject"]")
	current_person.familytree_clear_confirm_button()
	if(current_person.familytree_confirm_prompt == src)
		current_person.familytree_confirm_prompt = null

	if(is_mutual)
		var/datum/family_confirm_session/current_session = session
		var/current_side = is_person_a
		if(current_session && !QDELETED(current_session))
			if(current_side)
				current_session.prompt_a = null
			else
				current_session.prompt_b = null
		session = null
		if(current_session && !QDELETED(current_session))
			current_session.submit_choice(current_side, choice_result)
		qdel(src)
		return

	if(current_person.familytree_confirm_timerid)
		deltimer(current_person.familytree_confirm_timerid)
		current_person.familytree_confirm_timerid = null
	current_person.familytree_confirmation_pending = FALSE

	if(choice_result == CONFIRM_ACCEPTED)
		SSfamilytree.ftlog("CONFIRM ACCEPT: [current_person.real_name] type=[confirm_type]")
		on_accept?.Invoke()
	else
		SSfamilytree.ftlog("CONFIRM REJECT: [current_person.real_name] type=[confirm_type]")
		SSfamilytree.familytree_apply_refusal(current_person, context_person, confirm_type)
	qdel(src)

/datum/family_confirm_prompt/proc/force_solo_timeout()
	if(resolved || is_mutual || !person || QDELETED(person))
		return
	resolved = TRUE
	var/mob/living/carbon/human/current_person = person
	current_person.familytree_confirm_timerid = null
	current_person.familytree_confirmation_pending = FALSE
	current_person.familytree_clear_confirm_button()
	if(current_person.familytree_confirm_prompt == src)
		current_person.familytree_confirm_prompt = null
	SSfamilytree.ftlog("CONFIRM TIMEOUT: [current_person.real_name] type=[confirm_type] no explicit answer")
	if(current_person.client && !current_person.familytree_opted_out && !current_person.family_datum && !current_person.spouse_mob && familytree_pref_enabled(current_person.familytree_pref))
		to_chat(current_person, span_warning("Предложение семьи истекло без ответа. Система продолжит поиск."))
		SSfamilytree.try_queue_assignment(current_person)
	qdel(src)

/datum/family_confirm_session
	var/mob/living/carbon/human/person_a
	var/mob/living/carbon/human/person_b
	var/datum/callback/on_both_accept
	var/confirm_type
	var/relation_text_a
	var/relation_text_b
	var/result_a = CONFIRM_PENDING
	var/result_b = CONFIRM_PENDING
	var/resolved = FALSE
	var/timerid
	var/datum/family_confirm_prompt/prompt_a
	var/datum/family_confirm_prompt/prompt_b

/datum/family_confirm_session/New(mob/living/carbon/human/a, mob/living/carbon/human/b, datum/callback/cb, ctype, role_text_a = null, role_text_b = null)
	person_a = a
	person_b = b
	on_both_accept = cb
	confirm_type = ctype
	relation_text_a = role_text_a
	relation_text_b = role_text_b

/datum/family_confirm_session/Destroy()
	if(timerid)
		deltimer(timerid)
	QDEL_NULL(prompt_a)
	QDEL_NULL(prompt_b)
	if(person_a && !QDELETED(person_a))
		person_a.familytree_confirmation_pending = FALSE
		person_a.familytree_clear_confirm_button()
		if(person_a.familytree_confirm_prompt?.session == src)
			person_a.familytree_confirm_prompt = null
	if(person_b && !QDELETED(person_b))
		person_b.familytree_confirmation_pending = FALSE
		person_b.familytree_clear_confirm_button()
		if(person_b.familytree_confirm_prompt?.session == src)
			person_b.familytree_confirm_prompt = null
	person_a = null
	person_b = null
	on_both_accept = null
	return ..()

/datum/family_confirm_session/proc/submit_choice(is_person_a, choice_result)
	if(resolved)
		return
	if(is_person_a)
		if(result_a != CONFIRM_PENDING)
			return
		result_a = choice_result
	else
		if(result_b != CONFIRM_PENDING)
			return
		result_b = choice_result
	check_resolution()

/datum/family_confirm_session/proc/check_resolution()
	if(resolved)
		return

	if(result_a == CONFIRM_REJECTED || result_a == CONFIRM_TIMEOUT || result_b == CONFIRM_REJECTED || result_b == CONFIRM_TIMEOUT)
		resolved = TRUE
		if(timerid)
			deltimer(timerid)
		if(result_a == CONFIRM_TIMEOUT || result_b == CONFIRM_TIMEOUT)
			SSfamilytree.familytree_record_pair_offer(person_a, person_b)
		release_person(person_a, result_a, person_b)
		release_person(person_b, result_b, person_a)
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

/datum/family_confirm_session/proc/release_person(mob/living/carbon/human/person, result, mob/living/carbon/human/other)
	if(!person || QDELETED(person))
		return
	person.familytree_confirmation_pending = FALSE
	person.familytree_clear_confirm_button()
	switch(result)
		if(CONFIRM_REJECTED)
			handle_refusal(person, other)
		if(CONFIRM_TIMEOUT)
			handle_timeout(person, other)
		else
			notify_cancelled(person)

/datum/family_confirm_session/proc/handle_refusal(mob/living/carbon/human/refuser, mob/living/carbon/human/other)
	if(!refuser || QDELETED(refuser))
		return
	SSfamilytree.ftlog("MUTUAL CONFIRM: [refuser.real_name] declined type=[confirm_type]")
	SSfamilytree.familytree_apply_refusal(refuser, other, confirm_type)

/datum/family_confirm_session/proc/handle_timeout(mob/living/carbon/human/idler, mob/living/carbon/human/other)
	if(!idler || QDELETED(idler))
		return
	SSfamilytree.ftlog("MUTUAL CONFIRM: [idler.real_name] timeout type=[confirm_type]")
	if(!idler.client)
		SSfamilytree.pause_familytree_human(idler, "disconnected during confirmation")
		return
	if(other && SSfamilytree.familytree_pair_offer_limit_reached(idler, other))
		to_chat(idler, span_warning("Вы не ответили на предложение, и оно истекло. Лимит предложений с этим персонажем исчерпан, эта пара больше не будет предлагаться в текущем раунде."))
	else if(other && SSfamilytree.familytree_record_timeout_block(idler, other))
		to_chat(idler, span_warning("Вы не ответили на предложение, и оно истекло. Эта пара будет отложена на несколько попыток, но система продолжит поиск."))
	else
		to_chat(idler, span_warning("Вы не ответили на предложение, и оно истекло. Система продолжит поиск."))
	SSfamilytree.try_queue_assignment(idler)

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
	if(person.client)
		to_chat(person, span_warning("Другая сторона отказалась от вступления в семью. Ваш запрос отменён. Система попробует найти вам новую пару."))
	if(person.familytree_assignment_scheduled)
		return
	if(!person.familytree_opted_out && !person.family_datum && !person.spouse_mob && familytree_pref_enabled(person.familytree_pref))
		person.familytree_consecutive_match_failures++
		person.familytree_assignment_scheduled = TRUE
		addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, run_local_assignment), person, person.familytree_pref), SSfamilytree.familytree_match_retry_delay(person))

/datum/controller/subsystem/familytree/proc/request_family_confirmation(mob/living/carbon/human/H, datum/callback/on_accept, confirm_type = "family", relation_text = null, busy_attempt = 0, busy_deferred = FALSE)
	if(!H || QDELETED(H))
		return
	if(H?.familytree_opted_out)
		if(busy_deferred)
			H.familytree_confirmation_pending = FALSE
		ftlog("CONFIRM SKIP: [H?.real_name] opted out")
		return
	if(H?.familytree_confirmation_pending && !busy_deferred)
		ftlog("CONFIRM SKIP: [H?.real_name] already has pending confirmation")
		return
	if(!H?.client)
		H.familytree_confirmation_pending = FALSE
		pause_familytree_human(H, "no client at solo confirmation")
		return
	var/busy_reason = is_familytree_player_busy(H)
	if(busy_reason)
		H.familytree_confirmation_pending = TRUE
		if(busy_attempt >= familytree_busy_retry_limit)
			ftlog("CONFIRM SKIP: [H.real_name] still busy ([busy_reason]) after [familytree_busy_retry_limit] retries type=[confirm_type]", "WARN")
			H.familytree_confirmation_pending = FALSE
			try_queue_assignment(H)
			return
		ftlog("CONFIRM DEFER: [H.real_name] busy=[busy_reason] retry=[busy_attempt + 1]/[familytree_busy_retry_limit] type=[confirm_type]")
		addtimer(CALLBACK(src, PROC_REF(request_family_confirmation), H, on_accept, confirm_type, relation_text, busy_attempt + 1, TRUE), familytree_busy_retry_delay)
		return
	H.familytree_confirmation_pending = TRUE
	INVOKE_ASYNC(src, PROC_REF(do_solo_confirmation), H, on_accept, confirm_type, null, relation_text)

/datum/controller/subsystem/familytree/proc/familytree_confirmation_found_text(confirm_type, mob/living/carbon/human/person, mob/living/carbon/human/partner = null, mutual = FALSE, relation_text = null)
	var/base_text
	if(confirm_type == "targeted_spouse" && partner)
		base_text = "Ваша судьба сошлась с [partner.real_name]!"
	else if(confirm_type == "spouse" || confirm_type == "targeted_spouse")
		base_text = "Вам нашли пару!"
	else if(confirm_type == "sibling_house")
		base_text = mutual ? "Вам предлагают основать сиблинговый дом!" : "Вам предлагают основать сиблинговый дом!"
	else if(confirm_type == "family")
		base_text = mutual ? "Система нашла для вас семейную связь!" : "Система нашла для вас семью!"
	else if(confirm_type == "house")
		base_text = "Система нашла для вас семью!"
	else
		base_text = "Система нашла для вас семью!"
	if(relation_text)
		base_text += "\nВаша роль: [relation_text]"
	if(person?.know_your_fate && partner)
		base_text += familytree_format_fate_reveal(partner)
	return base_text

/datum/controller/subsystem/familytree/proc/familytree_confirmation_prompt_body(found_text, mob/living/carbon/human/person, mob/living/carbon/human/partner)
	if(person?.know_your_fate && partner)
		return "[found_text]\n\nХотите продолжить?\n\nЯвный отказ заблокирует эту пару на текущий раунд."
	return "[found_text]\n\nХотите продолжить?\n\nТолько кнопка «Нет» считается отказом."

/datum/controller/subsystem/familytree/proc/familytree_record_blocked_pair(mob/living/carbon/human/refuser, mob/living/carbon/human/other)
	if(!refuser || !other || !other.ckey)
		return FALSE
	if(!islist(refuser.familytree_blocked_ckeys))
		refuser.familytree_blocked_ckeys = list()
	refuser.familytree_blocked_ckeys |= other.ckey
	var/list/entry = familytree_round_ledger_entry(refuser.ckey)
	if(entry)
		var/list/blocked = entry["blocked"]
		blocked |= other.ckey
	return TRUE

/datum/controller/subsystem/familytree/proc/familytree_confirmation_should_chat(confirm_type)
	return confirm_type != "targeted_spouse"

/datum/controller/subsystem/familytree/proc/do_solo_confirmation(mob/living/carbon/human/H, datum/callback/on_accept, confirm_type, mob/living/carbon/human/context_person = null, relation_text = null)
	if(round_disabled)
		return
	if(!H || QDELETED(H))
		return
	if(!H?.client)
		H.familytree_confirmation_pending = FALSE
		pause_familytree_human(H, "no client at solo confirmation")
		return

	var/found_text = familytree_confirmation_found_text(confirm_type, H, context_person, FALSE, relation_text)
	if(familytree_confirmation_should_chat(confirm_type))
		to_chat(H, span_love(found_text))
		H.playsound_local(get_turf(H), 'sound/misc/bell_small.ogg', 50, FALSE, pressure_affected = FALSE)

	if(H.familytree_confirm_prompt && !QDELETED(H.familytree_confirm_prompt))
		qdel(H.familytree_confirm_prompt)
	var/body = familytree_confirmation_prompt_body(found_text, H, context_person)
	var/datum/family_confirm_prompt/prompt = new(H, body, found_text, confirm_type, context_person, on_accept, null, FALSE, relation_text)
	H.familytree_confirm_prompt = prompt

	if(!H.familytree_show_confirm_button(found_text, CALLBACK(prompt, TYPE_PROC_REF(/datum/family_confirm_prompt, open_prompt))))
		prompt.open_prompt()

	if(H.familytree_confirm_timerid)
		deltimer(H.familytree_confirm_timerid)
	H.familytree_confirm_timerid = addtimer(CALLBACK(prompt, TYPE_PROC_REF(/datum/family_confirm_prompt, force_solo_timeout)), MUTUAL_CONFIRM_TIMEOUT, TIMER_STOPPABLE)
	ftlog("CONFIRM READY: [H.real_name] type=[confirm_type] persistent_ui=yes")

/datum/controller/subsystem/familytree/proc/do_solo_confirmation_prompt(mob/living/carbon/human/H, datum/callback/on_accept, confirm_type, mob/living/carbon/human/context_person = null, relation_text = null)
	if(!H || QDELETED(H))
		return
	var/datum/family_confirm_prompt/prompt = H.familytree_confirm_prompt
	if(prompt && !QDELETED(prompt))
		prompt.open_prompt()

/datum/controller/subsystem/familytree/proc/familytree_solo_confirm_expire(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return
	var/datum/family_confirm_prompt/prompt = H.familytree_confirm_prompt
	if(prompt && !QDELETED(prompt))
		prompt.force_solo_timeout()
		return
	H.familytree_confirm_timerid = null
	if(!H.familytree_confirmation_pending)
		return
	H.familytree_clear_confirm_button()
	H.familytree_confirmation_pending = FALSE
	ftlog("CONFIRM TIMEOUT: [H.real_name] prompt missing; clearing stale confirmation", "WARN")
	if(!H.familytree_opted_out && !H.family_datum && !H.spouse_mob && familytree_pref_enabled(H.familytree_pref))
		try_queue_assignment(H)

/datum/controller/subsystem/familytree/proc/request_mutual_confirmation(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b, datum/callback/on_both_accept, confirm_type = "family", relation_text_a = null, relation_text_b = null, busy_attempt = 0, busy_deferred = FALSE)
	if(round_disabled)
		return FALSE
	if(!person_a || QDELETED(person_a) || !person_b || QDELETED(person_b))
		if(busy_deferred)
			if(person_a && !QDELETED(person_a))
				person_a.familytree_confirmation_pending = FALSE
			if(person_b && !QDELETED(person_b))
				person_b.familytree_confirmation_pending = FALSE
		ftlog("MUTUAL SKIP: invalid participant a=[person_a?.real_name] b=[person_b?.real_name]")
		return
	if(person_a?.familytree_opted_out || person_b?.familytree_opted_out)
		if(busy_deferred)
			person_a.familytree_confirmation_pending = FALSE
			person_b.familytree_confirmation_pending = FALSE
		ftlog("MUTUAL SKIP: opted out a=[person_a?.real_name] b=[person_b?.real_name]")
		return
	if((person_a?.familytree_confirmation_pending || person_b?.familytree_confirmation_pending) && !busy_deferred)
		ftlog("MUTUAL SKIP: pending confirmation a=[person_a?.real_name] b=[person_b?.real_name]")
		return

	var/busy_reason_a = person_a?.client ? is_familytree_player_busy(person_a) : null
	var/busy_reason_b = person_b?.client ? is_familytree_player_busy(person_b) : null
	if(busy_reason_a || busy_reason_b)
		if(person_a.client)
			person_a.familytree_confirmation_pending = TRUE
		if(person_b.client)
			person_b.familytree_confirmation_pending = TRUE
		if(busy_attempt >= familytree_busy_retry_limit)
			ftlog("MUTUAL SKIP: busy after [familytree_busy_retry_limit] retries type=[confirm_type] a=[person_a.real_name] busy=[busy_reason_a || "no"] b=[person_b.real_name] busy=[busy_reason_b || "no"]", "WARN")
			person_a.familytree_confirmation_pending = FALSE
			person_b.familytree_confirmation_pending = FALSE
			try_queue_assignment(person_a)
			try_queue_assignment(person_b)
			return
		ftlog("MUTUAL DEFER: type=[confirm_type] retry=[busy_attempt + 1]/[familytree_busy_retry_limit] a=[person_a.real_name] busy=[busy_reason_a || "no"] b=[person_b.real_name] busy=[busy_reason_b || "no"]")
		addtimer(CALLBACK(src, PROC_REF(request_mutual_confirmation), person_a, person_b, on_both_accept, confirm_type, relation_text_a, relation_text_b, busy_attempt + 1, TRUE), familytree_busy_retry_delay)
		return

	if(!person_a.client || !person_b.client)
		person_a.familytree_confirmation_pending = FALSE
		person_b.familytree_confirmation_pending = FALSE
		ftlog("MUTUAL CANCEL: participant without client type=[confirm_type] a=[person_a.real_name] b=[person_b.real_name]")
		if(person_a.client)
			try_queue_assignment(person_a)
		else
			pause_familytree_human(person_a, "no client at mutual confirmation")
		if(person_b.client)
			try_queue_assignment(person_b)
		else
			pause_familytree_human(person_b, "no client at mutual confirmation")
		return

	if(familytree_pair_offer_limit_reached(person_a, person_b))
		person_a.familytree_confirmation_pending = FALSE
		person_b.familytree_confirmation_pending = FALSE
		ftlog("MUTUAL SKIP: pair offer limit reached a=[person_a.real_name] b=[person_b.real_name] limit=[FAMILYTREE_PAIR_OFFER_LIMIT]")
		try_queue_assignment(person_a)
		try_queue_assignment(person_b)
		return

	var/offer_count = min(FAMILYTREE_PAIR_OFFER_LIMIT, familytree_pair_offer_count(person_a, person_b) + 1)
	person_a.familytree_confirmation_pending = TRUE
	person_b.familytree_confirmation_pending = TRUE
	var/datum/family_confirm_session/session = new(person_a, person_b, on_both_accept, confirm_type, relation_text_a, relation_text_b)
	session.timerid = addtimer(CALLBACK(session, TYPE_PROC_REF(/datum/family_confirm_session, force_timeout)), MUTUAL_CONFIRM_TIMEOUT, TIMER_STOPPABLE)

	ftlog("MUTUAL CONFIRM: started type=[confirm_type] a=[person_a.real_name] b=[person_b.real_name] offer=[offer_count]/[FAMILYTREE_PAIR_OFFER_LIMIT] persistent_ui=yes")

	INVOKE_ASYNC(src, PROC_REF(do_mutual_ask), session, person_a, TRUE)
	INVOKE_ASYNC(src, PROC_REF(do_mutual_ask), session, person_b, FALSE)

/datum/controller/subsystem/familytree/proc/do_mutual_ask(datum/family_confirm_session/session, mob/living/carbon/human/person, is_person_a)
	if(round_disabled)
		return
	if(QDELETED(session) || session.resolved)
		return
	if(!person?.client)
		if(person && !QDELETED(person))
			person.familytree_confirmation_pending = FALSE
		if(is_person_a && session.result_a == CONFIRM_PENDING)
			session.result_a = CONFIRM_TIMEOUT
		else if(!is_person_a && session.result_b == CONFIRM_PENDING)
			session.result_b = CONFIRM_TIMEOUT
		session.check_resolution()
		return

	var/mob/living/carbon/human/partner = is_person_a ? session.person_b : session.person_a
	var/relation_text_for_self = is_person_a ? session.relation_text_a : session.relation_text_b
	var/found_text = familytree_confirmation_found_text(session.confirm_type, person, partner, TRUE, relation_text_for_self)
	if(familytree_confirmation_should_chat(session.confirm_type))
		to_chat(person, span_love(found_text))
		person.playsound_local(get_turf(person), 'sound/misc/bell_small.ogg', 50, FALSE, pressure_affected = FALSE)

	var/body = familytree_confirmation_prompt_body(found_text, person, partner)
	if(person.familytree_confirm_prompt && !QDELETED(person.familytree_confirm_prompt))
		qdel(person.familytree_confirm_prompt)
	var/datum/family_confirm_prompt/prompt = new(person, body, found_text, session.confirm_type, partner, null, session, is_person_a, relation_text_for_self)
	person.familytree_confirm_prompt = prompt
	if(is_person_a)
		session.prompt_a = prompt
	else
		session.prompt_b = prompt

	if(!person.familytree_show_confirm_button(found_text, CALLBACK(prompt, TYPE_PROC_REF(/datum/family_confirm_prompt, open_prompt))))
		prompt.open_prompt()
	SSfamilytree.ftlog("MUTUAL CONFIRM READY: name=[person.real_name] type=[session.confirm_type] side=[is_person_a ? "A" : "B"]")

/datum/controller/subsystem/familytree/proc/do_mutual_prompt(datum/family_confirm_session/session, mob/living/carbon/human/person, is_person_a, body)
	if(!person || QDELETED(person) || QDELETED(session) || session.resolved)
		return
	var/datum/family_confirm_prompt/prompt = is_person_a ? session.prompt_a : session.prompt_b
	if(prompt && !QDELETED(prompt))
		prompt.open_prompt()
