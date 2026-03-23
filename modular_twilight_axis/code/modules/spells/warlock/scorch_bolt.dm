
/obj/effect/proc_holder/spell/invoked/projectile/scorch_bolt
	name = "Scorch Bolt"
	desc = "Магический болт, раскаленный добела. Он прошивает врагов насквозь."
	cost = 4
	projectile_type = /obj/projectile/magic/scorch_bolt
	overlay_state = "fireball"
	releasedrain = SPELLCOST_MAJOR_PROJECTILE
	chargetime = 10
	recharge_time = 12 SECONDS
	spell_tier = 3
	invocations = list("Ignis Transfigere!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "scorch_bolt"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/projectile/scorch_bolt/cast(list/targets, mob/user)
	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_1, WARLOCK_SCHOOL_FIRE, src)
	var/success = ..()
	warlock_spell_post_cast(user, WARLOCK_SLOT_1, WARLOCK_SCHOOL_FIRE, success, context)
	return success

/obj/projectile/magic/scorch_bolt
	name = "scorch bolt"
	icon_state = "omnilaser"
	damage = 25
	damage_type = BURN
	nodamage = FALSE
	flag = "magic"
	speed = 0.7
	guard_deflectable = TRUE
	var/tmp/damage_mult = 1

/obj/projectile/magic/scorch_bolt/on_hit(target, blocked = FALSE)
	var/mob/living/L = target
	if(ismob(target))
		if(L.anti_magic_check())
			return BULLET_ACT_BLOCK

		if(isliving(firer))
			var/list/context = warlock_spell_pre_cast(firer, WARLOCK_SLOT_1, WARLOCK_SCHOOL_FIRE, src)
			damage_mult = warlock_get_damage_mult(context)

		temporary_unstoppable_movement = TRUE
		movement_type |= UNSTOPPABLE

		L.adjust_fire_stacks(3)
		L.ignite_mob()

		arcyne_strike(firer, L, null, round(15 * damage_mult), def_zone, BCLASS_BURN, spell_name = "Scorch Bolt", skip_animation = TRUE, skip_message = TRUE)

		return BULLET_ACT_FORCE_PIERCE
	return ..()
