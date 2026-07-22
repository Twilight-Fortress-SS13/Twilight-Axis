/datum/controller/subsystem/familytree
	var/list/familytree_round_ledger = list()

/datum/controller/subsystem/familytree/proc/familytree_round_ledger_entry(ckey)
	if(!ckey)
		return null
	var/list/entry = familytree_round_ledger[ckey]
	if(!entry)
		entry = list("opted_out" = FALSE, "blocked" = list())
		familytree_round_ledger[ckey] = entry
	return entry

/datum/controller/subsystem/familytree/proc/familytree_hydrate_round_state(mob/living/carbon/human/H)
	if(!H?.ckey)
		return
	var/list/entry = familytree_round_ledger[H.ckey]
	if(!entry)
		return
	if(entry["opted_out"] && !H.familytree_opted_out)
		H.familytree_opted_out = TRUE
		ftlog("LEDGER: [H.real_name] ([H.ckey]) opted out earlier this round; keeping opt-out")
	var/list/blocked = entry["blocked"]
	if(islist(blocked) && blocked.len)
		if(!islist(H.familytree_blocked_ckeys))
			H.familytree_blocked_ckeys = list()
		H.familytree_blocked_ckeys |= blocked

/datum/controller/subsystem/familytree/proc/familytree_mark_opted_out(mob/living/carbon/human/H, reason)
	if(!H)
		return
	H.familytree_opted_out = TRUE
	var/list/entry = familytree_round_ledger_entry(H.ckey)
	if(entry)
		entry["opted_out"] = TRUE
	unsubscribe_familytree_human(H, reason)

/datum/controller/subsystem/familytree/proc/familytree_apply_refusal(mob/living/carbon/human/refuser, mob/living/carbon/human/other, confirm_type)
	if(!refuser || QDELETED(refuser))
		return
	if(refuser.know_your_fate && other && familytree_record_blocked_pair(refuser, other))
		to_chat(refuser, span_warning("Вы больше не будете матчиться с этим персонажем в этом раунде."))
		try_queue_assignment(refuser)
		return
	to_chat(refuser, span_warning("Вы отказались от участия в семейной системе на этот раунд."))
	familytree_mark_opted_out(refuser, "player declined [confirm_type]")
