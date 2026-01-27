#define SOUNDBREAKER_COMBO_FILTER "soundbreaker_combo_glow"

/atom/movable/screen/alert/status_effect/buff/soundbreaker_combo
	name = "Rhythmic Combo"
	desc = "My blows follow the rhythm. Consecutive hits build up to 5 stacks, sharpening your strikes."
	icon_state = "buff"

/datum/status_effect/buff/soundbreaker_combo
	id = "soundbreaker_combo"
	status_type = STATUS_EFFECT_REFRESH
	duration = SB_PREP_WINDOW
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/soundbreaker_combo

	var/stacks = 0
	var/max_stacks = 5
	var/mutable_appearance/aura_overlay

/datum/status_effect/buff/soundbreaker_combo/on_apply()
	. = ..()
	if(stacks <= 0)
		stacks = 1
	if(owner)
		to_chat(owner, span_notice("Your rhythm begins to build."))
	return TRUE

/datum/status_effect/buff/soundbreaker_combo/refresh()
	. = ..()
	if(QDELETED(src))
		return

	stacks = min(stacks + 1, max_stacks)
	if(owner)
		to_chat(owner, span_notice("Your rhythm surges ([stacks]/[max_stacks])."))

/datum/status_effect/buff/soundbreaker_combo/on_remove()
	if(owner)
		if(aura_overlay)
			owner.cut_overlay(aura_overlay)
		aura_overlay = null

		SEND_SIGNAL(owner, COMSIG_SOUNDBREAKER_COMBO_CLEARED)

	. = ..()

/datum/status_effect/buff/soundbreaker_prepared
	id = "soundbreaker_prepared"
	status_type = STATUS_EFFECT_REPLACE
	duration = SB_COMBO_WINDOW
	alert_type = /atom/movable/screen/alert/status_effect/buff/soundbreaker_prepared

	var/note_id = 0
	var/damage_mult = 1
	var/damage_type = BRUTE
	var/note_name = "Prepared Note"

/datum/status_effect/buff/soundbreaker_prepared/on_creation(mob/living/new_owner, ...)
	var/old_alert = alert_type
	alert_type = null

	. = ..()

	alert_type = old_alert
	return .

/datum/status_effect/buff/soundbreaker_prepared/on_apply(note_to_prime, mult_to_prime, type_to_prime, note_name_to_prime)
	. = ..()
	note_id = note_to_prime
	damage_mult = mult_to_prime
	damage_type = type_to_prime
	if(note_name_to_prime)
		note_name = note_name_to_prime

	update_alert()
	return TRUE

/datum/status_effect/buff/soundbreaker_prepared/refresh(note_to_prime, mult_to_prime, type_to_prime, note_name_to_prime)
	. = ..()
	if(QDELETED(src))
		return

	note_id = note_to_prime
	damage_mult = mult_to_prime
	damage_type = type_to_prime
	if(note_name_to_prime)
		note_name = note_name_to_prime

	update_alert()

/datum/status_effect/buff/soundbreaker_prepared/proc/set_payload(new_note_id, new_damage_mult, new_damage_type, new_note_name)
	note_id = new_note_id
	damage_mult = new_damage_mult
	damage_type = new_damage_type
	if(new_note_name)
		note_name = new_note_name

	update_alert()

/datum/status_effect/buff/soundbreaker_prepared/proc/update_alert()
	if(!owner)
		return
	if(!owner.client || !owner.hud_used)
		return

	if(!linked_alert)
		if(alert_type)
			var/atom/movable/screen/alert/status_effect/A = owner.throw_alert(id, alert_type)
			if(A)
				A.attached_effect = src
				linked_alert = A

	if(!linked_alert)
		return

	linked_alert.name = "Prepared: [note_name]"
	linked_alert.desc = "Your next strike will play this note."
	linked_alert.icon_state = soundbreaker_note_icon_state(note_id)

/datum/status_effect/buff/soundbreaker_prepared/proc/soundbreaker_note_icon_state(note_id)
	switch(note_id)
		if(SOUNDBREAKER_NOTE_BEND) return "sb_note_bend"
		if(SOUNDBREAKER_NOTE_BARE) return "sb_note_bare"
		if(SOUNDBREAKER_NOTE_SHED) return "sb_note_shed"
		if(SOUNDBREAKER_NOTE_RIFF) return "sb_note_riff"
	return "buff"

/atom/movable/screen/alert/status_effect/buff/soundbreaker_prepared
	name = "Prepared Note"
	desc = "A note is primed."
	icon_state = "buff"

/datum/status_effect/buff/soundbreaker_riff
	id = "soundbreaker_riff"
	status_type = STATUS_EFFECT_REFRESH
	duration = 4 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/soundbreaker_riff

/datum/status_effect/buff/soundbreaker_riff/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_GUIDANCE, "soundbreaker_riff")
	return TRUE

/datum/status_effect/buff/soundbreaker_riff/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GUIDANCE, "soundbreaker_riff")
	. = ..()

/atom/movable/screen/alert/status_effect/buff/soundbreaker_riff
	name = "Riff Guard"
	desc = "A defensive riff is active. A successful defense may grant combo."
	icon_state = "buff"

#define SB_BREAKER_PER_STACK 			10
#define SB_BREAKER_MAX_CHANCE 			90
#define SB_BREAKER_CLICK_MOD_PER_STACK	0.02
#define SB_BREAKER_BASE_SPEEDUP			0.05
#define SB_BREAKER_BASE_CHANCE 			30

/datum/status_effect/buff/soundbreaker_breaker_window
	id = "soundbreaker_breaker_window"
	duration = 2.0 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/success_chance = 0
	var/stacks = 0
	var/original_next_move = null

/datum/status_effect/buff/soundbreaker_breaker_window/on_creation(mob/living/new_owner, stacks = 1)
	src.stacks = stacks
	. = ..()

/datum/status_effect/buff/soundbreaker_breaker_window/on_apply()
	. = ..()
	success_chance = clamp(SB_BREAKER_BASE_CHANCE + stacks * SB_BREAKER_PER_STACK, 0, SB_BREAKER_MAX_CHANCE)
	
	if(!owner)
		return

	var/base_cd = owner.used_intent?.clickcd
	if(!base_cd)
		return

	var/mult = 1 - (SB_BREAKER_BASE_SPEEDUP + stacks * SB_BREAKER_CLICK_MOD_PER_STACK)
	original_next_move = owner.next_move
	var/new_cd = round(base_cd * mult)
	owner.changeNext_move(new_cd)

/datum/status_effect/buff/soundbreaker_breaker_window/on_remove()
	..()

	if(!owner || original_next_move == null)
		return

	if(owner.next_move <= world.time)
		return

	owner.next_move = original_next_move

#undef SB_BREAKER_BASE_SPEEDUP
#undef SB_BREAKER_BASE_CHANCE 
#undef SB_BREAKER_CLICK_MOD_PER_STACK
#undef SB_BREAKER_MAX_CHANCE
#undef SB_BREAKER_PER_STACK
