/obj/effect/proc_holder/spell/self/soundbreaker
	name = "Soundbreaker Ability"
	desc = "Base soundbreaking ability."
	clothes_req = FALSE
	charge_type = "recharge"
	associated_skill = /datum/skill/misc/music
	cost = 0
	xp_gain = FALSE

	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = SB_BASE_COOLDOWN

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1

	invocations = list()
	invocation_type = "none"
	hide_charge_effect = TRUE
	charging_slowdown = 0
	chargedloop = null
	overlay_state = null

	var/note_id = 0
	var/damage_mult = 1
	var/damage_type = BRUTE
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/soundspells.dmi'

/obj/effect/proc_holder/spell/self/soundbreaker/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/L = user

	if(L.incapacitated())
		return

	if(!soundbreaker_prime_note(L, note_id, damage_mult, damage_type, name))
		return

/obj/effect/proc_holder/spell/self/soundbreaker/bend
	name = "Bend"
	desc = "Prepare a resonant strike for your next blow. Does 95% damage."
	note_id = SOUNDBREAKER_NOTE_BEND
	damage_mult = 0.95
	damage_type = BRUTE
	overlay_state = "active_strike"

/obj/effect/proc_holder/spell/self/soundbreaker/bare
	name = "Barre"
	desc = "Prepare a wave note for your next blow. Does 75% damage in front long range."
	note_id = SOUNDBREAKER_NOTE_BARE
	damage_mult = 0.75
	damage_type = BRUTE
	overlay_state = "active_wave"

/obj/effect/proc_holder/spell/self/soundbreaker/shed
	name = "Shred"
	desc = "Prepare an overload note for your next blow. Does 60% damage and weakens target armor."
	note_id = SOUNDBREAKER_NOTE_SHED
	damage_mult = 0.6
	damage_type = BRUTE
	overlay_state = "active_encore"


/obj/effect/proc_holder/spell/self/soundbreaker/riff
	name = "Riff"
	desc = "Prepare a Riff chord for your next blow. Does 40% damage, puts you in a Riff stance, that will generate addition combo-point if you will block your opponent next attack."
	note_id = SOUNDBREAKER_NOTE_RIFF
	damage_mult = 0.4
	damage_type = BRUTE
	overlay_state = "active_riff"
