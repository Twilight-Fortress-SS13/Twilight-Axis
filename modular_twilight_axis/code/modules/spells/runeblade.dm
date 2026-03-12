/obj/effect/proc_holder/spell/self/runeblade
	name = "Runeblade Art"
	desc = "Prepare a runeblade technique."
	clothes_req = FALSE
	charge_type = "recharge"
	cost = 0
	xp_gain = FALSE

	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 5 SECONDS

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

	action_icon = 'modular_twilight_axis/icons/roguetown/misc/runebladespells.dmi'

	var/skill_id = 0
	var/effect_mult = 1
	var/cooldown_mult = 1
	var/weapon_self_damage_pct = 0
	var/activate_all = FALSE
	var/use_in_combo = TRUE

/obj/effect/proc_holder/spell/self/runeblade/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.incapacitated())
		return

	runeblade_prime_strike(
		L,
		skill_id,
		effect_mult,
		cooldown_mult,
		weapon_self_damage_pct,
		activate_all,
		use_in_combo,
		name
	)

/obj/effect/proc_holder/spell/self/runeblade/manifestation
	name = "Rune Manifestation"
	desc = "Next successful strike triggers one rune at +10% effect and +5% cooldown."
	overlay_state = "manifestation"
	skill_id = 1
	effect_mult = 1.10
	cooldown_mult = 1.05
	weapon_self_damage_pct = 0
	activate_all = FALSE
	use_in_combo = TRUE

/obj/effect/proc_holder/spell/self/runeblade/overload
	name = "Rune Overload"
	desc = "Next successful strike triggers one rune at +20% effect, but damages the blade."
	overlay_state = "overload"
	skill_id = 2
	effect_mult = 1.20
	cooldown_mult = 1
	weapon_self_damage_pct = 0.05
	activate_all = FALSE
	use_in_combo = TRUE

/obj/effect/proc_holder/spell/self/runeblade/harmony
	name = "Rune Harmony"
	desc = "Next successful strike triggers one rune at -20% effect and -20% cooldown."
	overlay_state = "harmony"
	skill_id = 3
	effect_mult = 0.80
	cooldown_mult = 0.80
	weapon_self_damage_pct = 0
	activate_all = FALSE
	use_in_combo = TRUE

/obj/effect/proc_holder/spell/self/runeblade/saturation
	name = "Rune Saturation"
	desc = "Next successful strike triggers all non-persistent runes at -60% effect."
	overlay_state = "saturation"
	skill_id = 4
	effect_mult = 0.40
	cooldown_mult = 1
	weapon_self_damage_pct = 0
	activate_all = TRUE
	use_in_combo = FALSE
