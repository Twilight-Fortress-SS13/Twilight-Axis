// Base song debuff/buff status effect types - shared by all songs
#define SONG_DEBUFF_FILTER "song_debuff_glow"

/datum/status_effect/debuff/song
	var/outline_colour = "#CC3333" // Red outline for all song debuffs

/datum/status_effect/debuff/song/on_apply()
	. = ..()
	var/filter = owner.get_filter(SONG_DEBUFF_FILTER)
	if(!filter)
		owner.add_filter(SONG_DEBUFF_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 40, "size" = 1))

/datum/status_effect/debuff/song/on_remove()
	. = ..()
	// Only remove filter if no other song debuffs remain
	var/has_other_song_debuff = FALSE
	for(var/datum/status_effect/debuff/song/S in owner.status_effects)
		if(S != src)
			has_other_song_debuff = TRUE
			break
	if(!has_other_song_debuff)
		owner.remove_filter(SONG_DEBUFF_FILTER)

/datum/status_effect/buff/playing_dirge
	id = "play_dirge"
	alert_type = /atom/movable/screen/alert/status_effect/buff/playing_dirge
	var/effect_color
	var/datum/status_effect/debuff/debuff_to_apply // Applied by T1 (lesser) bards, or as default if no full variant
	var/datum/status_effect/debuff/debuff_to_apply_full // Applied by T2 (full) bards. If null, uses debuff_to_apply for all tiers
	var/pulse = 0
	var/ticks_to_apply = SONG_SUSTAIN_TICKS
	duration = -1
	var/obj/effect/temp_visual/songs/effect = /obj/effect/temp_visual/songs/inspiration_dirget1
	var/energytodrain = SONG_SUSTAIN_COST

/atom/movable/screen/alert/status_effect/buff/playing_dirge
	name = "Playing Dirge"
	desc = "Terrorizing the world with my craft."
	icon_state = "buff"

/datum/status_effect/buff/playing_dirge/tick()
	var/mob/living/carbon/human/O = owner
	if(!song_check_instrument(O))
		return
	pulse += 1
	new effect(get_turf(owner))
	// Spawn telltale notes on debuffed enemies every tick (2s) for visibility
	for(var/mob/living/carbon/human/H in hearers(10, O))
		if (H.stat == DEAD)
			continue
		if(!O.in_audience(H))
			for(var/datum/status_effect/debuff/song/S in H.status_effects)
				new /obj/effect/temp_visual/song_telltale/debuff(get_turf(H))
				break // One note per target per tick
	if (pulse >= ticks_to_apply)
		pulse = 0
		O.energy_add(energytodrain)
		apply_song_effects(O)

/// Apply debuff to all non-audience in range. Separated so on_apply can call it too.
/datum/status_effect/buff/playing_dirge/proc/apply_song_effects(mob/living/carbon/human/O)
	var/debuff = debuff_to_apply
	if(debuff_to_apply_full && O.inspiration.level >= BARD_T2)
		debuff = debuff_to_apply_full
	for (var/mob/living/carbon/human/H in hearers(10, O))
		if (H.stat == DEAD)
			continue
		if(!O.in_audience(H))
			H.apply_status_effect(debuff)

/datum/status_effect/buff/playing_dirge/on_apply()
	. = ..()
	// Apply effects immediately on song start, don't wait for first full pulse cycle
	var/mob/living/carbon/human/O = owner
	if(O?.inspiration)
		apply_song_effects(O)

/datum/status_effect/buff/playing_dirge/on_remove()
	. = ..()
	// Clean up debuffs on enemies when song stops
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/O = owner
	if(!O.inspiration)
		return
	for(var/mob/living/carbon/human/H in hearers(10, O))
		for(var/datum/status_effect/debuff/song/song2remove in H.status_effects)
			H.remove_status_effect(song2remove)

#undef SONG_DEBUFF_FILTER

// DISCORDANT DIRGE
/datum/action/cooldown/spell/song/discordant_dirge
	name = "Discordant Dirge"
	desc = "Play a dissonant dirge that slows your enemies. Reduces SPD of non-audience members nearby."
	button_icon_state = "dirge_t1_base"
	sound = 'sound/magic/debuffroll.ogg'
	invocations = list("plays a grinding, dissonant melody. The air grows heavy and sluggish.")
	song_effect = /datum/status_effect/buff/playing_dirge/discordant_dirge

/datum/status_effect/buff/playing_dirge/discordant_dirge
	effect = /obj/effect/temp_visual/songs/inspiration_dirget1
	debuff_to_apply = /datum/status_effect/debuff/song/discordant_dirge
	debuff_to_apply_full = /datum/status_effect/debuff/song/discordant_dirge/full

/datum/status_effect/debuff/song/discordant_dirge
	id = "discordant_dirge"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/discordant_dirge
	effectedstats = list(STATKEY_SPD = -BARD_STAT_LESSER)
	duration = 15 SECONDS

/datum/status_effect/debuff/song/discordant_dirge/full
	effectedstats = list(STATKEY_SPD = -BARD_STAT_FULL)

/atom/movable/screen/alert/status_effect/debuff/song/discordant_dirge
	name = "Discordant Dirge"
	desc = "A terrible melody weighs on my limbs. Everything feels slower."
	icon_state = "debuff"

// ENERVATING ELEGY
/datum/action/cooldown/spell/song/enervating_elegy
	name = "Enervating Elegy"
	desc = "Play a draining elegy that saps the energy of your enemies. Drains blue from non-audience members nearby."
	button_icon_state = "dirge_t2_base"
	sound = 'sound/magic/debuffroll.ogg'
	invocations = list("plays a mournful, droning elegy. The will to fight seems to drain from the air.")
	song_effect = /datum/status_effect/buff/playing_dirge/enervating_elegy

/datum/status_effect/buff/playing_dirge/enervating_elegy
	effect = /obj/effect/temp_visual/songs/inspiration_dirget2
	debuff_to_apply = /datum/status_effect/debuff/song/enervating_elegy
	debuff_to_apply_full = /datum/status_effect/debuff/song/enervating_elegy/full

/atom/movable/screen/alert/status_effect/debuff/song/enervating_elegy
	name = "Enervating Elegy"
	desc = "This droning music saps my will to fight. I can feel my energy draining away."
	icon_state = "debuff"

// Uses a status effect so multiple bards don't stack/nuke - refreshes duration instead
/datum/status_effect/debuff/song/enervating_elegy
	id = "enervating_elegy"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/enervating_elegy
	duration = 15 SECONDS
	var/drain_amount = 4 // Blue drained per tick (lesser bard, 66%)

/datum/status_effect/debuff/song/enervating_elegy/full
	drain_amount = 6 // Blue drained per tick (full bard, 100%)

/datum/status_effect/debuff/song/enervating_elegy/tick()
	owner.energy_add(-drain_amount)

// RATTING REQUIREM
/datum/action/cooldown/spell/song/rattling_requiem
	name = "Rattling Requiem"
	desc = "Play a dirge that rattles your enemies' confidence, making their strikes and defenses imprecise."
	button_icon_state = "dirge_t3_base"
	sound = 'sound/magic/debuffroll.ogg'
	invocations = list("plays an unsettling, discordant requiem. Those nearby feel their confidence shaken.")
	song_effect = /datum/status_effect/buff/playing_dirge/rattling_requiem

/datum/status_effect/buff/playing_dirge/rattling_requiem
	effect = /obj/effect/temp_visual/songs/inspiration_dirget3
	debuff_to_apply = /datum/status_effect/debuff/song/rattling_requiem
	debuff_to_apply_full = /datum/status_effect/debuff/song/rattling_requiem/full

/atom/movable/screen/alert/status_effect/debuff/song/rattling_requiem
	name = "Rattling Requiem"
	desc = "This dreadful music shakes my confidence. My hands feel unsteady."
	icon_state = "debuff"

/datum/status_effect/debuff/song/rattling_requiem
	id = "rattling_requiem"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/rattling_requiem
	duration = 15 SECONDS
	effectedstats = list(STATKEY_PER = -2)

/datum/status_effect/debuff/song/rattling_requiem/full
	effectedstats = list(STATKEY_PER = -3)

// Effects
/obj/effect/temp_visual/songs/inspiration_dirget1
	icon_state = "dirge_t1_base"

/obj/effect/temp_visual/songs/inspiration_dirget2
	icon_state = "dirge_t2_base"

/obj/effect/temp_visual/songs/inspiration_dirget3
	icon_state = "dirge_t3_base"

// Red notes for debuffed enemies
/obj/effect/temp_visual/song_telltale/debuff
	note_color = "#CC3333"
