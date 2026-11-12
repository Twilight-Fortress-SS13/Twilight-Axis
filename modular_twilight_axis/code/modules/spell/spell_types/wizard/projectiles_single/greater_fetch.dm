// TA: Greater Fetch - Greater Kinesis minor aspect.
// Pulls freestanding items (as lesser Fetch) AND creatures (living or dead) right up next to the caster.

/datum/action/cooldown/spell/projectile/greater_fetch
	name = "Greater Fetch"
	desc = "Shoot out a magical bolt that drags the struck creature - living or dead - or freestanding item right up to the caster. Heavy, anchored, buckled or warded targets resist the pull."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "fetch"
	sound = 'sound/magic/magnet.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 15

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Recolligere Minora")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 8 SECONDS

	projectile_type = /obj/projectile/magic/greater_fetch

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_LOW
	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	allow_cross_z = FALSE

/obj/projectile/magic/greater_fetch
	name = "bolt of greater fetching"
	icon_state = "cursehand0"
	flag = "blunt"
	range = 15
	cannot_cross_z = TRUE

/obj/projectile/magic/greater_fetch/on_hit(atom/target, blocked = FALSE)
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check())
			L.visible_message(span_warning("[src] vanishes on contact with [L]!"))
			return BULLET_ACT_BLOCK
	. = ..()
	if(!firer || QDELETED(target) || target == firer)
		return
	var/turf/firer_turf = get_turf(firer)
	if(!firer_turf)
		return
	if(isliving(target))
		pull_mob(target, firer_turf)
	else if(isitem(target))
		pull_item(target, firer_turf)

/// Drag a mob onto a free tile adjacent to the caster.
/obj/projectile/magic/greater_fetch/proc/pull_mob(mob/living/L, turf/firer_turf)
	if(L.anchored || L.buckled)
		return
	var/turf/start = get_turf(L)
	if(!start || start.z != firer_turf.z || get_dist(start, firer_turf) <= 1)
		return // already adjacent (or on the caster's tile)
	var/turf/landing = get_fetch_landing(L, firer_turf)
	if(!landing)
		return
	var/pull_range = get_dist(start, landing)
	if(pull_range < 1)
		return
	// throw_at goes in a straight line and stops on the first obstacle, so a blocked path just shortens the pull.
	// safe_throw_at with MOVE_FORCE_STRONG respects move_resist like the other kinesis spells.
	L.safe_throw_at(landing, pull_range, 2, firer, force = MOVE_FORCE_STRONG)
	if(ismob(firer))
		log_combat(firer, L, "fetched with [src]")

/// The free tile next to the caster closest to the target; the tile straight toward the target is preferred.
/obj/projectile/magic/greater_fetch/proc/get_fetch_landing(mob/living/L, turf/firer_turf)
	var/turf/start = get_turf(L)
	var/turf/direct = get_step(firer_turf, get_dir(firer_turf, start))
	if(direct && !direct.is_blocked_turf(FALSE, L))
		return direct
	var/turf/best
	var/best_dist
	for(var/turf/T in orange(1, firer_turf))
		if(T.is_blocked_turf(FALSE, L))
			continue
		var/d = get_dist(T, start)
		if(isnull(best_dist) || d < best_dist)
			best = T
			best_dist = d
	return best

/// Lesser Fetch behaviour for items: stop one tile short, or straight into the caster's hand if they can catch it.
/obj/projectile/magic/greater_fetch/proc/pull_item(obj/item/I, turf/firer_turf)
	if(I.anchored || I.move_resist >= MOVE_FORCE_STRONG)
		return
	var/atom/throw_target = get_step(firer_turf, get_dir(firer_turf, I)) || firer_turf
	if(ishuman(firer))
		var/mob/living/carbon/human/carbon_firer = firer
		if(carbon_firer.can_catch_item())
			throw_target = firer_turf
	I.throw_at(throw_target, 200, 3, firer)
