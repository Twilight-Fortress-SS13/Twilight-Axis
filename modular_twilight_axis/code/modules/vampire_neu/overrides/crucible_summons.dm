/*
 * Crimson Crucible servant summon race fixes.
 *
 * Servant projects poll ghosts during on_complete(). Upstream keeps the project
 * active while that poll sleeps, so cancelling the project can refund vitae while
 * the pending poll still spawns the servant afterwards.
 */

/datum/vampire_project
	var/ta_cancelled = FALSE
	var/ta_refunded = FALSE

/datum/vampire_project/on_cancel()
	ta_cancelled = TRUE
	if(ta_refunded)
		return
	ta_refunded = TRUE
	return ..()

/datum/vampire_project/servant/proc/ta_summon_was_cancelled(atom/feedback_atom)
	if(!ta_cancelled && !QDELETED(src) && feedback_atom && !QDELETED(feedback_atom))
		return FALSE
	if(feedback_atom && !QDELETED(feedback_atom))
		feedback_atom.visible_message(span_warning("The crucible's call is severed before it can bind a servant."))
	return TRUE

/datum/vampire_project/servant/summon(type, atom/feedback_atom, poll_prompt)
	if(ta_summon_was_cancelled(feedback_atom))
		return FALSE

	feedback_atom.visible_message("The crucible stirs, summoning a servant from the realms beyond...")
	if(!poll_prompt)
		poll_prompt = "Do you want to play as a Vampire Lord's [type]?"

	var/list/candidates = pollGhostCandidates(poll_prompt, ROLE_VAMPIRE_SUMMON, null, null, 30 SECONDS, POLL_IGNORE_VL_SERVANT)
	if(ta_summon_was_cancelled(feedback_atom))
		return FALSE
	if(!LAZYLEN(candidates))
		feedback_atom.visible_message("But alas, the depths are hollow...")
		return FALSE

	var/mob/C = pick(candidates)
	if(ta_summon_was_cancelled(feedback_atom))
		return FALSE
	if(!C || !istype(C, /mob/dead))
		feedback_atom.visible_message("But alas, the depths are hollow...")
		return FALSE

	. = TRUE

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/human/northern/target = new /mob/living/carbon/human/species/human/northern(get_turf(feedback_atom))
	target.key = C.key
	target.visible_message(span_warning("[target] manifests from the crimson crucible in a kneel, before rising upwards."))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, load_char_or_namechoice)), 3 SECONDS)
	switch(type)
		if("Vampire Servant")
			SSjob.EquipRank(target, "Vampire Servant", TRUE)
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_NEONATE)
			target.mind.add_antag_datum(new_antag)
		if("Vampire Guard")
			SSjob.EquipRank(target, "Vampire Guard", TRUE)
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_NEONATE)
			target.mind.add_antag_datum(new_antag)
		if("Vampire Spawn")
			SSjob.EquipRank(target, "Vampire Spawn", TRUE)
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_ANCILLAE)
			target.mind.add_antag_datum(new_antag)
	ADD_TRAIT(target, TRAIT_BLOODPOOL_BORN, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_DUSTABLE, TRAIT_GENERIC)
