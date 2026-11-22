// TA: Greater Repel - Greater Kinesis minor aspect.
// Pure mob-repel spell: hurls struck creatures (living or dead) away from the caster. Items/objects are ignored.
// Tinted light blue (button, overhead charge rune, bolt, impact wisps) to tell it apart from Greater Fetch. No new sprites.

#define GREATER_REPEL_TINT "#9fd3ff"

/datum/action/cooldown/spell/projectile/greater_repel
	name = "Greater Repel"
	desc = "Shoot out a magical bolt that hurls a struck creature - living or dead - away from the caster. It affects only creatures; items and objects are left untouched. Heavy, anchored, buckled or warded targets resist the push."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "fetch"
	sound = 'sound/magic/unmagnet.ogg'
	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 15

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Exmoveo!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_MINOR
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 15 SECONDS

	projectile_type = /obj/projectile/magic/greater_repel

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW
	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	allow_cross_z = FALSE

/datum/action/cooldown/spell/projectile/greater_repel/New(Target)
	. = ..()
	mob_charge_effect?.color = GREATER_REPEL_TINT // the rune shown over the caster while charging

/// Tint only the button's own icon. button.color is not used: update_button_status() resets it
/// (null / red when unavailable / green when active) and it would also tint the background underlay.
/datum/action/cooldown/spell/projectile/greater_repel/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	. = ..()
	if(!button_icon || !button_icon_state)
		return
	var/static/list/tinted_icons = list()
	var/cache_key = "[button_icon]"
	var/icon/tinted = tinted_icons[cache_key]
	if(!tinted)
		tinted = icon(button_icon)
		tinted.Blend(GREATER_REPEL_TINT, ICON_MULTIPLY)
		tinted_icons[cache_key] = tinted
	current_button.icon = tinted
	current_button.icon_state = button_icon_state

/obj/projectile/magic/greater_repel
	name = "bolt of greater repelling"
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	color = GREATER_REPEL_TINT
	spell_impact_color = GREATER_REPEL_TINT
	flag = "blunt"
	range = 15
	cannot_cross_z = TRUE

/obj/projectile/magic/greater_repel/on_hit(atom/target, blocked = FALSE)
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check())
			L.visible_message(span_warning("[src] vanishes on contact with [L]!"))
			return BULLET_ACT_BLOCK
	. = ..()
	if(!firer || QDELETED(target) || target == firer)
		return
	if(!isliving(target))
		return // creatures only; items and objects are ignored
	var/mob/living/L = target
	if(L.anchored || L.buckled)
		return
	var/push_dir = get_dir(get_turf(firer), get_turf(L))
	if(!push_dir)
		push_dir = dir // same tile as the caster - push along the bolt's flight
	var/turf/throw_target = get_edge_target_turf(L, push_dir)
	if(!throw_target)
		return
	// safe_throw_at respects move_resist, so very heavy mobs are not thrown
	L.safe_throw_at(throw_target, 7, 4, firer, force = MOVE_FORCE_STRONG)
	if(ismob(firer))
		log_combat(firer, L, "repelled with [src]")

#undef GREATER_REPEL_TINT
