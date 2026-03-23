
/obj/effect/proc_holder/spell/invoked/projectile/ice_ball
	name = "Ice Ball"
	desc = "Тяжелая сфера из магического льда.."
	cost = 4
	projectile_type = /obj/projectile/magic/ice_ball
	overlay_state = "force_dart" 
	sound = list('sound/magic/abyssor_splash.ogg')
	releasedrain = SPELLCOST_MAJOR_PROJECTILE
	chargetime = 10
	recharge_time = 12 SECONDS
	spell_tier = 2
	invocations = list("Gelu Sphaera!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "ice_ball"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/projectile/ice_ball/cast(list/targets, mob/user)
	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_2, WARLOCK_SCHOOL_FROST, src)
	var/success = ..()
	warlock_spell_post_cast(user, WARLOCK_SLOT_2, WARLOCK_SCHOOL_FROST, success, context)
	return success

/obj/projectile/magic/ice_ball
	name = "ice ball"
	icon_state = "pulse1"
	damage = 30
	damage_type = BRUTE
	nodamage = FALSE
	speed = 0.9 
	flag = "magic"
	guard_deflectable = TRUE
	woundclass = BCLASS_BLUNT
	var/tmp/damage_mult = 1

/obj/projectile/magic/ice_ball/Initialize()
	. = ..()
	if(isliving(firer))
		var/list/context = warlock_spell_pre_cast(firer, WARLOCK_SLOT_2, WARLOCK_SCHOOL_FROST, src)
		damage_mult = warlock_get_damage_mult(context)

/obj/projectile/magic/ice_ball/on_hit(target, blocked = FALSE)
	var/mob/living/L = target
	if(ismob(target))
		if(L.anti_magic_check())
			return BULLET_ACT_BLOCK

		temporary_unstoppable_movement = TRUE
		movement_type |= UNSTOPPABLE

		L.apply_status_effect(/datum/status_effect/buff/frostbite)
		L.Knockdown(1.5 SECONDS)

		var/base_dir = src.dir
		var/push_angle = pick(45, -45, 90, -90)
		var/throw_dir = turn(base_dir, push_angle)

		L.safe_throw_at(get_edge_target_turf(L, throw_dir), 2, 1, firer)

		arcyne_strike(firer, L, null, round(15 * damage_mult), def_zone, BCLASS_BLUNT, spell_name = "Ice Ball", skip_animation = TRUE, skip_message = TRUE)

		return BULLET_ACT_FORCE_PIERCE
	return ..()
