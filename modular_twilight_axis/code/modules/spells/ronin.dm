/obj/effect/proc_holder/spell/self/ronin
	name = "Ronin Ability"
	desc = "Base ronin technique."
	clothes_req = FALSE
	charge_type = "recharge"
	associated_skill = /datum/skill/combat/swords
	cost = 0
	xp_gain = FALSE

	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 0

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

	action_icon = 'modular_twilight_axis/icons/roguetown/misc/roninspells.dmi'

/obj/effect/proc_holder/spell/self/ronin/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.incapacitated())
		return

/obj/effect/proc_holder/spell/self/ronin/horizontal
	name = "Sweeping Cut"
	desc = "A wide horizontal slash."
	recharge_time = 0
	overlay_state = "cut_horizontal"

/obj/effect/proc_holder/spell/self/ronin/horizontal/cast(list/targets, mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_COMBO_CORE_REGISTER_INPUT, 1, null, user.zone_selected)

/obj/effect/proc_holder/spell/self/ronin/vertical
	name = "Falling Cut"
	desc = "A focused vertical strike."
	recharge_time = 0
	overlay_state = "cut_vertical"

/obj/effect/proc_holder/spell/self/ronin/vertical/cast(list/targets, mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_COMBO_CORE_REGISTER_INPUT, 2, null, user.zone_selected)

/obj/effect/proc_holder/spell/self/ronin/diagonal
	name = "Crossing Cut"
	desc = "A diagonal, deceptive slash."
	recharge_time = 0
	overlay_state = "cut_diagonal"

/obj/effect/proc_holder/spell/self/ronin/diagonal/cast(list/targets, mob/living/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_COMBO_CORE_REGISTER_INPUT, 3, null, user.zone_selected)

/obj/effect/proc_holder/spell/self/ronin/blade_path
	name = "Way of the Blade"
	desc = "Adopt a counter stance, or draw your blade in an instant."
	overlay_state = "blade_path"

/obj/effect/proc_holder/spell/self/ronin/blade_path/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return

	var/datum/component/combo_core/ronin/C = user.GetComponent(/datum/component/combo_core/ronin)
	if(!C)
		return

	C.UpdateActiveBlade()
	if(C.active_blade && (C.active_blade in C.bound_blades))
		if(C.ReturnToSheath())
			to_chat(user, span_notice("You calmly return your blade to its scabbard."))
		return

	if(C.in_counter_stance)
		C.ExitCounterStance()
		C.QuickDraw(FALSE)
		return

	C.EnterCounterStance()
	to_chat(user, span_notice("You assume a still, deadly stance."))

/obj/effect/proc_holder/spell/self/ronin/bind_blade
	name = "Bind Blade"
	desc = "Bind your blade to your path."
	overlay_state = "blade_bind"

/obj/effect/proc_holder/spell/self/ronin/bind_blade/cast(list/targets, mob/living/user)
	var/obj/item/rogueweapon/W = user.get_active_held_item()
	if(!W)
		to_chat(user, span_warning("You must hold a blade."))
		return
	var/datum/component/combo_core/ronin/C = user.GetComponent(/datum/component/combo_core/ronin)
	if(C)
		C.BindBlade(W)
