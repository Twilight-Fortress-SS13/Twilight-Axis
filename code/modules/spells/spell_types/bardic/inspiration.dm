/datum/inspiration
	var/mob/living/carbon/human/holder
	var/level = BARD_T1
	var/maxaudience = 3
	var/list/audience = list()
	var/audience_selecting = FALSE
	var/maxsongs = 2
	var/songsbought = 0
	var/datum/rhythm_tracker/rhythm_tracker = null
	var/allegro_enabled = FALSE	// Maestro - Wretch Bard only — restore energy every 5th rhythm proc
	var/allegro_counter = 0
	var/bonus_rhythm_picks = 0	// Added on top of the tier's default pick count

/datum/inspiration/New(mob/living/carbon/human/holder)
	. = ..()
	src.holder = holder
	holder?.inspiration = src
	ADD_TRAIT(holder, TRAIT_INSPIRING_MUSICIAN, "inspiration")

/datum/inspiration/Destroy(force)
	. = ..()
	holder?.inspiration = null
	holder = null
	QDEL_NULL(rhythm_tracker)
	STOP_PROCESSING(SSobj, src)

/datum/inspiration/proc/grant_inspiration(mob/living/carbon/human/H, bard_tier)
	if(!H || !H.mind)
		return
	level = bard_tier
	switch(bard_tier)
		if(BARD_T1)
			maxaudience = 4
			maxsongs = 2
		if(BARD_T2)
			maxaudience = 6
			maxsongs = 4
			rhythm_tracker = new /datum/rhythm_tracker()
			var/datum/action/cooldown/spell/crescendo/C = new()
			C.tracker = rhythm_tracker
			rhythm_tracker.crescendo_action = C
			H.mind.AddSpell(C)
	audience |= H // Bard is always in their own audience
	add_verb(H, list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/open_songbook, /mob/living/carbon/human/proc/explain_bard))

/datum/inspiration/proc/toggle_audience_member(mob/living/carbon/human/target)
	if(!holder || !target || target == holder)
		return FALSE
	if(target in audience)
		audience -= target
		for(var/datum/status_effect/buff/song/lingering in target.status_effects)
			target.remove_status_effect(lingering)
		to_chat(holder, span_notice("I stop performing for [target.real_name]."))
		target.balloon_alert(holder, "removed from audience")
		return TRUE
	if((audience.len - 1) >= maxaudience)
		to_chat(holder, span_warning("I cannot maintain an audience larger than [maxaudience]!"))
		return FALSE
	audience |= target
	var/datum/status_effect/buff/playing_melody/melody = locate() in holder.status_effects
	melody?.apply_song_effects(holder)
	to_chat(holder, span_notice("I begin performing for [target.real_name]."))
	target.balloon_alert(holder, "added to audience")
	return TRUE

//TA edit - Bard chages start
/datum/inspiration/proc/prune_audience()
	for(var/audience_entry in audience)
		var/mob/living/carbon/human/audience_member = audience_entry
		if(!istype(audience_member) || QDELETED(audience_member) || audience_member.stat == DEAD)
			audience -= audience_entry
	if(holder)
		audience |= holder

/datum/inspiration/proc/clear_audience()
	audience_selecting = FALSE
	for(var/audience_entry in audience)
		var/mob/living/carbon/human/audience_member = audience_entry
		if(!istype(audience_member) || QDELETED(audience_member))
			continue
		for(var/datum/status_effect/buff/song/song_buff in audience_member.status_effects)
			audience_member.remove_status_effect(song_buff)
	audience = holder ? list(holder) : list()
//TA edit - Bard chages end

/mob/living/carbon/human/proc/in_audience(mob/living/carbon/human/audiencee)
	if(!src.mind)
		return FALSE
	if(!src.inspiration)
		return FALSE
	if(audiencee in src.inspiration.audience)
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/setaudience()
	set name = "Audience Choice"
	set category = "RoleUnique.Inspiration"

	if(!inspiration)
		return FALSE
	//TA edit - Bard chages start
	inspiration.audience_selecting = !inspiration.audience_selecting
	if(inspiration.audience_selecting)
		to_chat(src, span_notice("Audience targeting enabled. Middle-click people to add or remove them. Left-click or right-click to cancel."))
		balloon_alert(src, "audience targeting")
	else
		to_chat(src, span_notice("Audience targeting canceled."))
		balloon_alert(src, "targeting canceled")
	//TA edit - Bard chages end

	return TRUE

//TA edit - Bard chages start
/mob/proc/handle_bard_audience_click(atom/A, list/modifiers)
	return FALSE

/mob/living/carbon/human/handle_bard_audience_click(atom/A, list/modifiers)
	if(!inspiration?.audience_selecting)
		return FALSE
	if(modifiers["left"] || modifiers["right"])
		inspiration.audience_selecting = FALSE
		to_chat(src, span_notice("Audience targeting canceled."))
		balloon_alert(src, "targeting canceled")
		return TRUE
	if(!modifiers["middle"])
		return TRUE
	var/mob/living/carbon/human/target = A
	if(!istype(target) || target == src)
		balloon_alert(src, "middle-click a person")
		return TRUE
	inspiration.prune_audience()
	if(!(target in view(7, src)))
		balloon_alert(src, "too far")
		return TRUE
	if(target in inspiration.audience)
		inspiration.audience -= target
		target.balloon_alert(src, "removed from audience")
		target.balloon_alert(target, "removed from audience")
		return TRUE
	var/audience_count = inspiration.audience.len - 1
	if(audience_count >= inspiration.maxaudience)
		balloon_alert(src, "audience full")
		to_chat(src, span_warning("I cannot maintain an audience larger than [inspiration.maxaudience]!"))
		return TRUE
	inspiration.audience |= target
	target.balloon_alert(src, "added to audience")
	target.balloon_alert(target, "added to audience")
	return TRUE
//TA edit - Bard chages end

/mob/living/carbon/human/proc/clearaudience()
	set name = "Clear Audience"
	set category = "RoleUnique.Inspiration"
	if(!inspiration)
		return FALSE
	//TA edit - Bard chages start
	inspiration.clear_audience()
	balloon_alert(src, "audience cleared")
	//TA edit - Bard chages end

	return TRUE

/mob/living/carbon/human/proc/checkaudience()
	set name = "Check Audience"
	set category = "RoleUnique.Inspiration"

	if(!inspiration)
		return FALSE
	var/text = ""
	for(var/mob/living/carbon/human/folks in inspiration.audience)
		text += "[folks.real_name], "
	if(!text)
		return
	to_chat(src, "My audience members are: [text]")
	return TRUE

/mob/living/carbon/human/proc/explain_bard()
	set name = "Explain Bardic Inspiration"
	set category = "RoleUnique.Inspiration"
	if(!inspiration)
		return FALSE
	var/tier_name = inspiration.level == BARD_T2 ? "Full Bard" : "Lesser Bard"
	to_chat(src, span_info("Bardic Inspiration allows you to inspire your allies with music. \
	Set your audience using the 'Audience Choice' verb, or middle-click someone while holding an instrument in your active hand to add or remove them on the spot. \
	Open your Songbook from the action bar to learn songs and rhythms. \
	To activate a song, hold an instrument in one hand and toggle the song from your action bar. \
	Songs are mutually exclusive - activating a new song replaces the current one."))
	to_chat(src, span_info("Rhythm: Activate a rhythm, then strike within 8 seconds to trigger its effect. \
	All rhythms share a cooldown. Full Bards can build toward a Crescendo - a powerful blast after 3 rhythm procs."))
	to_chat(src, span_smallnotice("You're a [tier_name] and can have up to [inspiration.maxaudience] audience members and know [inspiration.maxsongs] songs."))

	return TRUE

/mob/living/carbon/human/MiddleClickOn(atom/A, params)
	if(!mmb_intent && inspiration && A != src && ishuman(A))
		if(istype(get_active_held_item(), /obj/item/rogue/instrument))
			if(get_dist(src, A) > 7 || A.z != z)
				to_chat(src, span_warning("[A] is too far away to invite into my audience."))
				return
			inspiration.toggle_audience_member(A)
			return
	return ..()
