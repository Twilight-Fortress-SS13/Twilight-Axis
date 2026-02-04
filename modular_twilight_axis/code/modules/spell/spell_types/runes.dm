/obj/effect/proc_holder/spell/invoked/stasis/runed
	name = "Stasis"
	desc = "Dangerous rune spell copied from Naledi schools. It will leave your or yours victim mark on the floor, then teleport after a short time"
	releasedrain = 25
	chargedrain = 5
	chargetime = 10
	recharge_time = 2 MINUTES
	associated_skill = /datum/skill/magic
	miracle = FALSE
	devotion_cost = 0
	hide_charge_effect = TRUE
	cost = 15

/obj/effect/proc_holder/spell/invoked/stasis/runed/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		brute = target.getBruteLoss()
		burn = target.getFireLoss()
		oxy = target.getOxyLoss()
		toxin = target.getToxLoss()
		origin = get_turf(target)
		blood = target.blood_volume
		var/datum/status_effect/fire_handler/fire_stacks/fire_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
		firestacks = fire_status?.stacks
		var/datum/status_effect/fire_handler/fire_stacks/sunder/sunder_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
		sunderfirestacks = sunder_status?.stacks
		var/datum/status_effect/fire_handler/fire_stacks/divine/divine_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
		divinefirestacks = divine_status?.stacks
		to_chat(target, span_warning("I feel a part of me was left behind..."))
		play_indicator(target,'modular_twilight_axis/icons/mob/overhead_effects.dmi', "timestop_rune", 30 SECONDS, OBJ_LAYER)
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 30 SECONDS)
		return TRUE
