/datum/action/cooldown/spell/stasis
	name = "Runed Stasis"
	desc = "Anchor a creature's position in time. After a short duration they will return to where they were marked."
	button_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	background_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	button_icon_state = "runedstasis"
	sound = 'sound/magic/timeforward.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	click_to_activate = TRUE
	self_cast_possible = TRUE
	cast_range = 3
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocations = list("Au Monde.")
	invocation_type = INVOCATION_WHISPER
	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_MINOR
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 2 MINUTES
	associated_skill = /datum/skill/magic/arcane
	point_cost = 2
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/stasis/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(cast_on != owner)
		if(owner)
			owner.balloon_alert(owner, "Can't cast on others!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/stasis/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/target = cast_on
	if(!istype(target))
		return FALSE
	target.apply_status_effect(/datum/status_effect/buff/runed_stasis)
	playsound(target.loc, 'sound/magic/timeforward.ogg', 100, FALSE)
	target.balloon_alert_to_viewers("<font color='[GLOW_COLOR_ARCANE]'>rune anchored!")
	to_chat(target, span_notice("Rune anchors me to this place."))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/runed_stasis
	name = "Runed Stasis"
	desc = "Rune has anchored me to this place."
	icon = 'modular_twilight_axis/icons/mob/screen_alert.dmi'
	icon_state = "volfstasis"

#define RUNED_STASIS_FILTER "runed_stasis"

/datum/status_effect/buff/runed_stasis
	id = "runed_stasis"
	var/outline_colour = "#4b1d52"
	alert_type = /atom/movable/screen/alert/status_effect/buff/runed_stasis
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 SECONDS
	var/turf/origin

/datum/status_effect/buff/runed_stasis/on_creation(mob/living/new_owner)
	. = ..()
	origin = get_turf(new_owner)

/datum/status_effect/buff/runed_stasis/on_apply()
	. = ..()
	var/filter = owner.get_filter(RUNED_STASIS_FILTER)
	if(!filter)
		owner.add_filter(RUNED_STASIS_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 2))

	var/mutable_appearance/effect = mutable_appearance('icons/effects/effects.dmi', "curse", -JOYBRINGER_LAYER, alpha = 128)
	effect.appearance_flags = RESET_COLOR
	effect.blend_mode = BLEND_ADD
	effect.color = "#4b1d52"

	owner.overlays_standing[RUNED_STASIS_FILTER] = effect
	owner.apply_overlay(RUNED_STASIS_FILTER)

	owner.visible_message(span_warning("[owner]'s form turns hazy, as though caught between moments."), span_notice("Rune anchors me to this place."))

/datum/status_effect/buff/runed_stasis/on_remove()
	. = ..()
	if(owner && origin)
		do_teleport(owner, origin, no_effects = TRUE)
		playsound(owner.loc, 'sound/magic/timereverse.ogg', 100, FALSE)
		owner.balloon_alert_to_viewers("<font color='[GLOW_COLOR_ARCANE]'>snaps back!")
		owner.visible_message(span_warning("[owner] suddenly snaps back to an earlier position!"), span_notice("Rune pulls me back."))
	owner.remove_filter(RUNED_STASIS_FILTER)
	owner.remove_overlay(RUNED_STASIS_FILTER)

/datum/action/cooldown/spell/blink/shadowstep/runed
	name = "Runed Blink"
	desc = "Slip through the void and reappear a few paces away before the eye can follow."
	button_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	background_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	button_icon_state = "runedblink"
	invocations = list("Je Passerai.")
	phase = /obj/effect/temp_visual/blink/shadowstep/runed
	cooldown_time = 48 SECONDS
	sound = null

/obj/effect/temp_visual/blink/shadowstep/runed
	icon = 'modular_twilight_axis/icons/effects/effects.dmi'
	icon_state = "curse"
	light_color = COLOR_PALE_PURPLE_GRAY

/obj/effect/proc_holder/spell/invoked/shadowstep/runed
	name = "Runed Walk"
	desc = "Melt into your own shadow and emerge where your mark calls."
	cost = 3
	xp_gain = TRUE
	releasedrain = 20
	warnie = "spellwarning"
	movement_interrupt = TRUE
	associated_skill = /datum/skill/magic/arcane
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	action_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	overlay_state = "runedwalk"
	chargedrain = 1
	chargetime = 0 SECONDS
	recharge_time = 60 SECONDS
	max_range = 5

/obj/effect/proc_holder/spell/invoked/shadowstep/runed/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])
	if(!istransparentturf(T))
		var/reason
		if(max_range >= get_dist(user, T) && !T.density)
			if(check_path(get_turf(user), T))	//We check for opaque turfs or non-climbable windows in the way via a simple pathfind.
				if(get_dist(user, T) < 2 && user.z == T.z)
					to_chat(user, span_info("Too close!"))
					revert_cast()
					return
				to_chat(user, span_info("I begin to meld with the shadows.."))
				lockon(T, user)
				if(do_after(user, 5 SECONDS))
					tp(user)
				else
					reset(silent = TRUE)
					revert_cast()
				return
			else
				to_chat(user, span_info("The path is blocked!"))
				revert_cast()
				return
		else if(get_dist(user, T) > max_range)
			reason = "It's too far."
			revert_cast()
		else if (T.density)
			reason = "It's a wall!"
			revert_cast()
		to_chat(user, span_info("I cannot runewalk there! "+"[reason]"))
	else
		to_chat(user, span_info("I cannot runewalk there!"))
		revert_cast()
	return TRUE

/datum/action/cooldown/spell/projectile/repel/runed
	name = "Runed Repel"
	desc = "Fire a runed hand that drives its target away from you. When cast while in throw mode, it hurls the held object instead."
	button_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	background_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	button_icon_state = "runedrepel"
	projectile_type = /obj/projectile/magic/repel/runed
	cast_range = 7
	cooldown_time = 30 SECONDS
	invocations = list("Laissez-moi entrer!")
	invocation_type = INVOCATION_SHOUT
	charge_sound = 'sound/magic/chargingold.ogg'

/obj/projectile/magic/repel/runed
	name = "hand of repeling"
	icon = 'modular_twilight_axis/icons/effects/effects.dmi'
	icon_state = "cursehand0"
	range = 7

/obj/projectile/magic/repel/runed/on_hit(target, blocked = FALSE)
	var/atom/throw_target = get_edge_target_turf(firer, get_dir(firer, target))
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check() || !firer)
			L.visible_message(span_warning("[src] vanishes on contact with [target]!"))
			return BULLET_ACT_BLOCK
		if(blocked >= 100)
			return
		L.throw_at(throw_target, out_of_effective_range() ? 3 : 7, 4)
	else
		if(isitem(target))
			var/obj/item/I = target
			var/mob/living/carbon/human/carbon_firer
			if (ishuman(firer))
				carbon_firer = firer
				if (carbon_firer?.can_catch_item())
					throw_target = get_edge_target_turf(firer, get_dir(firer, target))
			I.throw_at(throw_target, 7, 4)

/obj/effect/proc_holder/spell/self/invisibility/runed
	name = "Runed Cloak"
	desc = "Veil your presence until violence or carelessness betrays you."
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	action_icon = 'modular_twilight_axis/icons/mob/actions/classuniquespells/volf.dmi'
	overlay_state = "runedcloak"
	action_icon_state = "runedcloak"
	recharge_time = 2 MINUTES

/obj/effect/proc_holder/spell/self/invisibility/runed/cast(list/targets, mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.anti_magic_check(TRUE, TRUE))
			return FALSE
		H.visible_message(span_warning("[H] wavers, their energies simmering down."), span_notice("You start to become invisible!"))
		var/dur = 15
		H.apply_status_effect(/datum/status_effect/buff/psyinvisibility)
		animate(H, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		H.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[H] fades back into view."), span_notice("You become visible again.")), dur SECONDS)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/psyinvisibility
	alert_type = /atom/movable/screen/alert/status_effect/buff/psyinvisibility
	id = "psyinvisibility"
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = 4)

/atom/movable/screen/alert/status_effect/buff/psyinvisibility
	name = "Invisible"
	desc = "Runes covers me."
	icon = 'modular_twilight_axis/icons/mob/screen_alert.dmi'
	icon_state = "volfinvisibility"

/datum/status_effect/buff/psyinvisibility/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_BREAK_SNEAK, PROC_REF(on_break_sneak))
	ADD_TRAIT(owner, TRAIT_VOLF, id)
	ADD_TRAIT(owner, TRAIT_PACIFISM, id)

/datum/status_effect/buff/psyinvisibility/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_BREAK_SNEAK)
	REMOVE_TRAIT(owner, TRAIT_VOLF, id)
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, id)

/datum/status_effect/buff/psyinvisibility/proc/on_break_sneak()
	SIGNAL_HANDLER
	owner.remove_status_effect(/datum/status_effect/buff/psyinvisibility)

/atom/movable/screen/fullscreen/volf
	icon = 'modular_twilight_axis/icons/mob/screen_full.dmi'
	icon_state = "curse1"
	layer = BLIND_LAYER

/datum/client_colour/volf
	colour = list(rgb(169, 116, 204), rgb(74, 114, 162), rgb(16, 16, 16), rgb(0,0,0))
	priority = 1
