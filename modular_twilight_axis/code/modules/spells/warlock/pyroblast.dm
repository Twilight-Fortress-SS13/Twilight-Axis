
/obj/effect/proc_holder/spell/invoked/projectile/pyroblast
	name = "Pyroblast"
	desc = "Огромный шар концентрированного пламени. Наносит колоссальный урон и вызывает мощную ударную волну."
	cost = 7
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue/pyroblast
	overlay_state = "fireball_artillery"
	sound = list('sound/magic/fireball.ogg')
	releasedrain = SPELLCOST_SUPER_PROJECTILE
	chargetime = 30
	recharge_time = 25 SECONDS
	spell_tier = 4
	invocations = list("IGNIS MAXIMUS!")
	chargedloop = /datum/looping_sound/invokegen
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	no_early_release = TRUE
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "pyroblast"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/projectile/pyroblast/cast(list/targets, mob/user)
	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_3, WARLOCK_SCHOOL_FIRE, src)
	var/success = ..()
	warlock_spell_post_cast(user, WARLOCK_SLOT_3, WARLOCK_SCHOOL_FIRE, success, context)
	return success

/obj/projectile/magic/aoe/fireball/rogue/pyroblast
	name = "pyroblast"
	damage = 70
	damage_type = BURN
	speed = 1.2
	arcyne_aoe_radius = 1
	structural_damage = 50 
	structural_damage_radius = 2
	impact_effect_type = /obj/effect/temp_visual/explosion
	guard_deflectable = TRUE
	var/tmp/damage_mult = 1

/obj/projectile/magic/aoe/fireball/rogue/pyroblast/Initialize()
	. = ..()
	if(isliving(firer))
		var/list/context = warlock_spell_pre_cast(firer, WARLOCK_SLOT_3, WARLOCK_SCHOOL_FIRE, src)
		damage_mult = warlock_get_damage_mult(context)

/obj/projectile/magic/aoe/fireball/rogue/pyroblast/on_hit(target)
	damage = round(initial(damage) * damage_mult)

	var/turf/epicenter = get_turf(target)
	var/cached_radius = arcyne_aoe_radius

	. = ..()
	
	if(. == BULLET_ACT_BLOCK)
		return
	
	if(epicenter)
		for(var/mob/living/L in range(cached_radius, epicenter))
			if(L.anti_magic_check()) 
				continue
			
			if(L.has_status_effect(/datum/status_effect/buff/clash))
				continue

			if(L.client) 
				shake_camera(L, 4, 3)
			
			L.Knockdown(20)
			var/throw_dir = get_dir(epicenter, L) || pick(GLOB.cardinals)
			L.safe_throw_at(get_edge_target_turf(epicenter, throw_dir), 3, 1, firer)
