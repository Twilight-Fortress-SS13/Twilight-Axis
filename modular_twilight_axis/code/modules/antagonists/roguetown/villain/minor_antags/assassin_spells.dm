/obj/effect/proc_holder/spell/invoked/assassin_track
	name = "Blood Veil"
	desc = "I pierce the veil of mortality and sense those marked by Graggar for death. Cast on self to attune to a new target, cast again to feel their direction."
	recharge_time = 0.5 SECONDS
	chargetime = 0.1 SECONDS
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "sniff"
	action_icon_state = "sniff"
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>I close my eyes and reach through the veil...</span>"

	var/mob/living/tracked_target = null
	var/shown_disclaimer = FALSE

/obj/effect/proc_holder/spell/invoked/assassin_track/cast(list/targets, mob/user)
	if(!length(targets))
		return FALSE
	var/mob/living/target = targets[1]

	if(!tracked_target || QDELETED(tracked_target) || tracked_target.stat == DEAD || target == user)
		select_new_target(user)
	else
		give_tracking_directions(user)

	if(is_valid_target(target) && target != user)
		tracked_target = target
		to_chat(user, span_notice("The mark of Graggar burns upon [target.real_name]. Their soul calls to my blade."))
		return TRUE

	return TRUE

/obj/effect/proc_holder/spell/invoked/assassin_track/proc/select_new_target(mob/user)
	var/list/possible_targets = list()

	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L == user || istype(L, /mob/living/carbon/human/dummy) || !L.mind)
			continue
		if(!is_valid_target(L))
			continue

		var/entry_name = "[L.real_name]"
		if(L.job)
			entry_name += " - [L.job]"
		possible_targets[entry_name] = L

	if(!length(possible_targets))
		to_chat(user, span_warning("The veil is silent... no souls marked for Graggar remain."))
		return

	var/selection = tgui_input_list(user, "Whose soul bears the mark of Graggar?", "Blood Veil", sort_list(possible_targets))
	if(!selection)
		return

	tracked_target = possible_targets[selection]

	if(!shown_disclaimer)
		to_chat(user, span_boldnotice("A soul has been marked. Only those chosen by Graggar matter."))
		shown_disclaimer = TRUE

	to_chat(user, span_notice("I have bound my will to [tracked_target.real_name]. Their fate is sealed."))
	give_tracking_directions(user)

/obj/effect/proc_holder/spell/invoked/assassin_track/proc/give_tracking_directions(mob/user)
	if(!tracked_target || QDELETED(tracked_target) || tracked_target.stat == DEAD)
		to_chat(user, span_warning("The connection fades... the marked soul has passed."))
		tracked_target = null
		return

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(tracked_target)

	if(user_turf.z != target_turf.z)
		to_chat(user, span_notice("The mark of [tracked_target.real_name] pulses from [user_turf.z > target_turf.z ? "below" : "above"]."))
	else
		var/dist = get_dist(user, tracked_target)
		var/dir_text = dir2text(get_dir(user, tracked_target))

		if(dist <= 1)
			to_chat(user, span_boldnotice("The prey stands before me. The creed demands blood!"))
		else if(dist < 8)
			to_chat(user, span_notice("The mark burns strongly to the [dir_text]. They are near."))
		else
			to_chat(user, span_notice("I feel a faint pull toward [tracked_target.real_name] in the [dir_text]."))

/obj/effect/proc_holder/spell/invoked/assassin_track/proc/is_valid_target(atom/A)
	if(!isliving(A))
		return FALSE
	var/mob/living/L = A
	if(QDELETED(L) || L.stat == DEAD)
		return FALSE
	if(L.has_flaw(/datum/charflaw/targeted))
		return TRUE
	if(HAS_TRAIT(L, TRAIT_ZIZOID_HUNTED))
		return TRUE
	
	return FALSE

/datum/antagonist/assassin/on_gain()
	..()
	if(!owner || !owner.current)
		return
	var/obj/effect/proc_holder/spell/invoked/assassin_track/track_spell = new
	owner.current.AddSpell(track_spell)
