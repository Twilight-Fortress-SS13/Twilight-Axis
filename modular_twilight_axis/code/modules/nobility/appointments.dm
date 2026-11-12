/datum/mind
	var/ta_squire_next_use = 0
	var/ta_champion_next_use = 0
	var/ta_initial_knight_spawn = FALSE

/mob/living/carbon/human
	var/ta_squire_pending = FALSE
	var/ta_champion_pending = FALSE

/mob/living/carbon/human/proc/taRegisterNobleAppointmentSignals()
	RegisterSignal(src, list(
		SIGNAL_ADDTRAIT(TRAIT_NOBLE),
		SIGNAL_REMOVETRAIT(TRAIT_NOBLE),
		COMSIG_MOB_MIND_TRANSFERRED_INTO,
		COMSIG_MOB_MIND_TRANSFERRED_OUT_OF,
	), PROC_REF(taNobleAppointmentTraitChanged))
	RegisterSignal(src, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(taOnNobilityLogin))

/mob/living/carbon/human/proc/taNobleAppointmentTraitChanged()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(taRefreshNobleRoleActions))

/mob/living/carbon/human/proc/taRefreshNobleRoleActions()
	taSyncNobleAppointments()
	taSyncRetinueVerbs()

/mob/living/carbon/human/proc/taCanDeclareChampion()
	if(!mind || !HAS_TRAIT(src, TRAIT_NOBLE))
		return FALSE
	var/role = mind.assigned_role
	if(role in list("Hand", "Steward", "Marshal", "King", "Queen"))
		return FALSE
	if(role == "Grand Duke" && SSmapping.config?.map_name == "Rockhill")
		return FALSE
	return role == "Prince" || taAppliedNobilityTier() == 3

/mob/living/carbon/human/proc/taSyncNobleAppointments()
	if(/mob/living/carbon/human/proc/declarechampion in verbs)
		remove_verb(src, /mob/living/carbon/human/proc/declarechampion)
	if(!mind || mind.current != src)
		remove_verb(src, list(
			/mob/living/carbon/human/proc/taAppointSquire,
			/mob/living/carbon/human/proc/taDeclareChampion,
		))
		return
	mind.RemoveSpell(/datum/action/cooldown/spell/takeprotege)
	if(HAS_TRAIT(src, TRAIT_NOBLE))
		add_verb(src, /mob/living/carbon/human/proc/taAppointSquire)
	else
		remove_verb(src, /mob/living/carbon/human/proc/taAppointSquire)

	if(taCanDeclareChampion())
		add_verb(src, /mob/living/carbon/human/proc/taDeclareChampion)
	else
		remove_verb(src, /mob/living/carbon/human/proc/taDeclareChampion)
	if(mind.assigned_role == "Grand Duke")
		SSticker.taTryAssignDucalChampion()
	else
		taRegisterInitialBanneret()

/mob/living/carbon/human/proc/taNobleAppointmentExamineText()
	var/list/lines = list()
	var/mob/living/carbon/human/liege = skills?.knight_lord
	if(!QDELETED(liege) && liege.skills?.my_squire == src)
		lines += span_notice("Squire of [html_encode(liege.real_name)].")
	var/mob/living/carbon/ward = mind?.ward
	if(!QDELETED(ward) && ward.mind?.champion == src)
		lines += span_notice("Champion of [html_encode(ward.real_name)].")
	return lines

/mob/living/carbon/human/proc/taCanUseNobleAppointment(champion = FALSE)
	if(
		!mind \
		|| mind.current != src \
		|| !client \
		|| stat != CONSCIOUS \
		|| incapacitated() \
		|| !HAS_TRAIT(src, TRAIT_NOBLE)
	)
		return FALSE
	if(champion)
		return taCanDeclareChampion() \
			&& world.time >= mind.ta_champion_next_use
	return world.time >= mind.ta_squire_next_use

/mob/living/carbon/human/proc/taSelectAppointmentTarget(prompt, title)
	var/list/candidates = list()
	for(var/mob/living/carbon/human/candidate in view(1, src))
		if(
			candidate != src \
			&& candidate.stat == CONSCIOUS \
			&& candidate.client \
			&& candidate.mind?.current == candidate
		)
			candidates += candidate
	if(!length(candidates))
		to_chat(src, span_notice("There is no one nearby to appoint."))
		return null
	return tgui_input_list(src, prompt, title, candidates, \
		timeout = 30 SECONDS)

/// Check the same two characters again after an invitation or ceremony can
// sleep.
/proc/taAppointmentParticipantsNear(
	mob/living/carbon/human/appointer,
	mob/living/carbon/human/recipient,
	datum/mind/appointer_mind,
	datum/mind/recipient_mind
)
	if(QDELETED(appointer) || QDELETED(recipient) || appointer == recipient)
		return FALSE
	if(
		!appointer_mind \
		|| !recipient_mind \
		|| appointer.mind != appointer_mind \
		|| recipient.mind != recipient_mind
	)
		return FALSE
	if(
		appointer_mind.current != appointer \
		|| recipient_mind.current != recipient
	)
		return FALSE
	if(
		appointer.stat != CONSCIOUS \
		|| recipient.stat != CONSCIOUS \
		|| !appointer.client \
		|| !recipient.client
	)
		return FALSE
	return recipient in view(1, appointer)

/mob/living/carbon/human/proc/taAppointSquire()
	set name = "Appoint Squire"
	set desc = "Invite a nearby squire to serve as your protégé."
	set category = "RoleUnique.Noble"

	if(!taCanUseNobleAppointment() || ta_squire_pending)
		return FALSE
	var/mob/living/carbon/human/liege = src
	var/datum/mind/liege_mind = mind
	ta_squire_pending = TRUE
	var/mob/living/carbon/human/squire = taSelectAppointmentTarget(
		"Who will be your squire?", "Appoint Squire"
	)
	if(QDELETED(src))
		return FALSE
	ta_squire_pending = FALSE
	var/datum/mind/squire_mind = squire?.mind
	if(
		mind != liege_mind \
		|| !taCanUseNobleAppointment() \
		|| !taAppointmentParticipantsNear(
			liege, squire, liege_mind, squire_mind
		)
	)
		return FALSE
	if(!HAS_TRAIT(squire, TRAIT_SQUIRE_REPAIR))
		to_chat(
			liege,
			span_warning("I can only appoint someone trained as a squire.")
		)
		return FALSE
	if(taHasActiveSquireBond(liege) || taHasActiveSquireBond(squire))
		to_chat(liege, span_warning("One of us already has a squire bond."))
		return FALSE

	ta_squire_pending = TRUE
	var/answer = tgui_alert(squire, \
		"[liege.real_name] offers to take you as their squire. They will be \
		able to read your feelings. Do you accept?", \
		"Appoint Squire", list(
		"Accept",
		"Decline",
	), 30 SECONDS)
	if(QDELETED(src))
		return FALSE
	ta_squire_pending = FALSE
	if(
		mind != liege_mind \
		|| !taCanUseNobleAppointment() \
		|| !taAppointmentParticipantsNear(
			liege,
			squire,
			liege_mind,
			squire_mind
		)
	)
		return FALSE
	if(answer != "Accept")
		to_chat(liege, span_notice("The appointment was not accepted."))
		return FALSE
	if(!HAS_TRAIT(squire, TRAIT_SQUIRE_REPAIR))
		return FALSE
	if(taHasActiveSquireBond(liege) || taHasActiveSquireBond(squire))
		return FALSE
	taClearDepartedSquirePartners(liege)
	taClearDepartedSquirePartners(squire)
	taLinkSquire(liege, squire)
	liege.visible_message(span_notice("[liege] takes [squire] as a squire."))
	to_chat(liege, span_nicegreen("[squire] is now your squire."))
	to_chat(squire, span_nicegreen("[liege] has taken you as a squire."))
	liege_mind.ta_squire_next_use = world.time + 30 SECONDS
	return TRUE

/proc/taHasActiveSquireBond(mob/living/carbon/human/character)
	var/mob/living/carbon/human/squire = character.get_squire()
	var/mob/living/carbon/human/liege = character.get_knight_lord()
	return (squire && !squire_bond_partner_despawned(squire)) || (liege \
		&& !squire_bond_partner_despawned(liege))

/proc/taClearDepartedSquirePartners(mob/living/carbon/human/character)
	var/mob/living/carbon/human/squire = character.get_squire()
	if(squire && squire_bond_partner_despawned(squire))
		squire_bond_break(character, squire)
	var/mob/living/carbon/human/liege = character.get_knight_lord()
	if(liege && squire_bond_partner_despawned(liege))
		squire_bond_break(liege, character)

/proc/taLinkSquire(
	mob/living/carbon/human/liege,
	mob/living/carbon/human/squire
)
	liege.set_squire(squire)
	squire.set_knight_lord(liege)
	liege.RegisterSignal(
		liege,
		COMSIG_MOVABLE_MOVED,
		TYPE_PROC_REF(/mob/living/carbon/human, squire_bond_on_move),
		TRUE
	)
	squire.RegisterSignal(
		squire,
		COMSIG_MOVABLE_MOVED,
		TYPE_PROC_REF(/mob/living/carbon/human, squire_bond_on_move),
		TRUE
	)
	liege.RegisterSignal(
		squire,
		COMSIG_LIVING_DEATH,
		TYPE_PROC_REF(/mob/living/carbon/human, on_protege_death),
		TRUE
	)
	squire.RegisterSignal(
		liege,
		COMSIG_LIVING_DEATH,
		TYPE_PROC_REF(/mob/living/carbon/human, on_lord_death),
		TRUE
	)
	if(squire_bond_buff_eligible(liege, squire))
		liege.apply_status_effect(/datum/status_effect/buff/protege_ward)
		squire.apply_status_effect(/datum/status_effect/buff/protege_vigilance)

/mob/living/carbon/human/proc/taDeclareChampion()
	set name = "Declare Champion"
	set desc = "Appoint a champion, or choose your champion to dismiss them."
	set category = "RoleUnique.Noble"

	if(!taCanUseNobleAppointment(TRUE) || ta_champion_pending)
		return FALSE
	var/mob/living/carbon/human/ward = src
	var/datum/mind/ward_mind = mind
	ta_champion_pending = TRUE
	var/mob/living/carbon/human/champion = taSelectAppointmentTarget(
		"Who will be your champion? Choose your champion to dismiss them.",
		"Declare Champion",
	)
	if(QDELETED(src))
		return FALSE
	ta_champion_pending = FALSE
	var/datum/mind/champion_mind = champion?.mind
	if(
		mind != ward_mind \
		|| !taCanUseNobleAppointment(TRUE) \
		|| !taAppointmentParticipantsNear(
			ward, champion, ward_mind, champion_mind
		)
	)
		return FALSE
	var/revoking = ward_mind.champion == champion
	if(!revoking && !taCanStartChampionBond(ward, champion))
		to_chat(ward, span_warning( \
			"One of us already has a champion bond in that position." \
		))
		return FALSE

	ta_champion_pending = TRUE
	if(!revoking)
		ward.say("Be my champion, [champion]!")
		var/answer = tgui_alert(champion, \
			"Will you become the champion of [ward.real_name]?", \
			"Declare Champion", list("Accept", "Decline"), 30 SECONDS)
		if(QDELETED(src))
			return FALSE
		if(answer != "Accept" || mind != ward_mind \
			|| !taCanUseNobleAppointment(TRUE) \
			|| !taAppointmentParticipantsNear(
				ward, champion, ward_mind, champion_mind
			) \
			|| !taCanStartChampionBond(ward, champion))
			ta_champion_pending = FALSE
			return FALSE
		champion.say("I serve you, [ward]!")

	var/ceremony = revoking ? "untying" : "tying"
	ward.visible_message(span_notice( \
		"[ward] begins [ceremony] a golden ribbon on [champion]'s wrist." \
	))
	var/completed = do_after(ward, 10 SECONDS, target = champion)
	if(QDELETED(src))
		return FALSE
	ta_champion_pending = FALSE
	if(!completed || mind != ward_mind \
		|| !taCanUseNobleAppointment(TRUE) \
		|| !taAppointmentParticipantsNear(
			ward, champion, ward_mind, champion_mind
		))
		return FALSE

	if(revoking)
		if(!taIsChampionPair(ward, champion))
			return FALSE
		taClearChampionPair(ward, champion, TRUE)
		ward.visible_message(span_notice( \
			"[ward] unties the golden ribbon from [champion]'s wrist." \
		))
		ward.say("I revoke your championship, [champion]!")
	else
		if(!taCanStartChampionBond(ward, champion))
			return FALSE
		taClearChampionPair(ward, ward_mind.champion, FALSE)
		taClearChampionPair(champion_mind.ward, champion, FALSE)
		if(!taLinkChampion(ward, champion))
			return FALSE
		ward.visible_message(
			span_notice("[ward] ties a golden ribbon to [champion]'s wrist.")
		)
	ward_mind.ta_champion_next_use = world.time + 30 SECONDS
	return TRUE

/proc/taCanStartChampionBond(
	mob/living/carbon/human/ward,
	mob/living/carbon/human/champion
)
	if(ward.mind?.ward == champion)
		return FALSE
	var/mob/living/carbon/old_champion = ward.mind?.champion
	if(taIsChampionPair(ward, old_champion) && old_champion.stat != DEAD)
		return FALSE
	var/mob/living/carbon/old_ward = champion.mind?.ward
	return !taIsChampionPair(old_ward, champion) || old_ward.stat == DEAD

/proc/taIsChampionPair(mob/living/carbon/ward, mob/living/carbon/champion)
	return !QDELETED(ward) && !QDELETED(champion) \
		&& ward.mind?.champion == champion && champion.mind?.ward == ward

/proc/taLinkChampion(
	mob/living/carbon/human/ward,
	mob/living/carbon/human/champion
)
	if(
		QDELETED(ward) \
		|| QDELETED(champion) \
		|| ward == champion \
		|| !ward.mind \
		|| !champion.mind
	)
		return FALSE
	if(taIsChampionPair(ward, champion))
		return TRUE
	if(ward.mind.champion || champion.mind.ward || ward.mind.ward == champion)
		return FALSE
	ward.mind.champion = champion
	champion.mind.ward = ward
	var/datum/status_effect/ward_effect = ward.apply_status_effect(
		/datum/status_effect/buff/noble_ward
	)
	var/datum/status_effect/champion_effect = champion.apply_status_effect(
		/datum/status_effect/buff/noble_champion
	)
	if(!ward_effect || !champion_effect)
		taClearChampionPair(ward, champion, FALSE)
		return FALSE
	return TRUE

/proc/taClearChampionPair(
	mob/living/carbon/ward,
	mob/living/carbon/champion,
	grief = TRUE
)
	if(!ward || !champion)
		return
	var/ward_linked = ward.mind?.champion == champion
	var/champion_linked = champion.mind?.ward == ward
	if(ward_linked)
		ward.mind.champion = null
	if(champion_linked)
		champion.mind.ward = null
	// Clear both references first so the effects' on_remove calls cannot unlink
	// twice.
	if(ward_linked && !QDELETED(ward))
		ward.remove_status_effect(/datum/status_effect/buff/noble_ward)
		if(grief && ward.stat != DEAD)
			ward.add_stress(/datum/stressevent/lostchampion)
	if(champion_linked && !QDELETED(champion))
		champion.remove_status_effect(/datum/status_effect/buff/noble_champion)
		if(grief && champion.stat != DEAD)
			champion.add_stress(/datum/stressevent/lostward)

/datum/status_effect/buff/noble_champion
	id = "ta_noble_champion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/noble_champion
	on_remove_on_mob_delete = TRUE
	effectedstats = list(STATKEY_CON = 1, STATKEY_WIL = 1)
	var/mob/living/carbon/ward

/datum/status_effect/buff/noble_champion/on_apply()
	ward = owner.mind?.ward
	return ..()

/datum/status_effect/buff/noble_champion/tick()
	var/mob/living/carbon/champion = owner
	if(!taIsChampionPair(ward, champion))
		qdel(src)
		return
	if(
		ward.stat != DEAD \
		&& champion.stat != DEAD \
		&& !champion.has_stress_event(/datum/stressevent/champion) \
		&& (ward in view(5, champion))
	)
		champion.add_stress(/datum/stressevent/champion)

/datum/status_effect/buff/noble_champion/on_remove()
	. = ..()
	var/mob/living/carbon/champion = owner
	taClearChampionPair(ward, champion)

/atom/movable/screen/alert/status_effect/buff/noble_champion
	name = "Champion"
	desc = "I have been chosen as a champion."
	icon_state = "buff"

/datum/status_effect/buff/noble_ward
	id = "ta_noble_ward"
	alert_type = /atom/movable/screen/alert/status_effect/buff/noble_ward
	on_remove_on_mob_delete = TRUE
	effectedstats = list(STATKEY_LCK = 1, STATKEY_WIL = 1)
	var/mob/living/carbon/champion

/datum/status_effect/buff/noble_ward/on_apply()
	champion = owner.mind?.champion
	return ..()

/datum/status_effect/buff/noble_ward/tick()
	var/mob/living/carbon/ward = owner
	if(!taIsChampionPair(ward, champion))
		qdel(src)
		return
	if(
		ward.stat != DEAD \
		&& champion.stat != DEAD \
		&& !ward.has_stress_event(/datum/stressevent/ward) \
		&& (champion in view(5, ward))
	)
		ward.add_stress(/datum/stressevent/ward)

/datum/status_effect/buff/noble_ward/on_remove()
	. = ..()
	var/mob/living/carbon/ward = owner
	taClearChampionPair(ward, champion)

/atom/movable/screen/alert/status_effect/buff/noble_ward
	name = "Ward"
	desc = "I have declared a champion."
	icon_state = "buff"

/datum/controller/subsystem/ticker
	var/datum/weakref/ta_initial_duke
	var/datum/weakref/ta_initial_banneret
	var/ta_ducal_champion_assigned = FALSE

/datum/controller/subsystem/ticker/proc/taRegisterInitialDuke(
	mob/living/carbon/human/duke
)
	if(
		ta_ducal_champion_assigned \
		|| duke.mind?.assigned_role != "Grand Duke" \
		|| SSmapping.config?.map_name == "Rockhill"
	)
		return
	ta_initial_duke = WEAKREF(duke)
	taTryAssignDucalChampion()

/mob/living/carbon/human/proc/taRegisterInitialBanneret()
	if(
		!mind?.ta_initial_knight_spawn \
		|| mind.assigned_role != "Knight" \
		|| advjob != "Knight Banneret"
	)
		return
	if(SSticker.ta_ducal_champion_assigned)
		return
	SSticker.ta_initial_banneret = WEAKREF(src)
	SSticker.taTryAssignDucalChampion()

/datum/controller/subsystem/ticker/proc/taTryAssignDucalChampion()
	if(ta_ducal_champion_assigned)
		return FALSE
	var/mob/living/carbon/human/duke = ta_initial_duke?.resolve()
	var/mob/living/carbon/human/banneret = ta_initial_banneret?.resolve()
	if(QDELETED(duke) || QDELETED(banneret) || rulermob != duke)
		return FALSE
	if(
		duke.stat == DEAD \
		|| banneret.stat == DEAD \
		|| duke.mind?.current != duke \
		|| banneret.mind?.current != banneret
	)
		return FALSE
	if(!taIsChampionPair(duke, banneret))
		if(duke.mind.champion)
			taClearChampionPair(duke, duke.mind.champion, FALSE)
		if(banneret.mind.ward)
			taClearChampionPair(banneret.mind.ward, banneret, FALSE)
		if(duke.mind.ward == banneret)
			taClearChampionPair(banneret, duke, FALSE)
	if(!taLinkChampion(duke, banneret))
		return FALSE
	ta_ducal_champion_assigned = TRUE
	ta_initial_duke = null
	ta_initial_banneret = null
	to_chat(duke, span_notice("[banneret.real_name] is your sworn champion."))
	to_chat(
		banneret,
		span_notice("You are the sworn champion of [duke.real_name].")
	)
	return TRUE
