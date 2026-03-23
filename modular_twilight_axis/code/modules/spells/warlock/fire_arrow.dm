
/obj/effect/proc_holder/spell/invoked/projectile/fire_arrow
	name = "Fire Arrow"
	desc = "Выпускает стрелу из спрессованного пламени. Игнорирует часть брони и глубоко вонзается в плоть, поджигая цель."
	cost = 3
	projectile_type = /obj/projectile/magic/fire_arrow
	overlay_state = "fireball"
	sound = list('sound/magic/abyssor_splash.ogg')
	releasedrain = SPELLCOST_MINOR_PROJECTILE
	chargetime = 5
	recharge_time = 7 SECONDS
	spell_tier = 2
	invocations = list("Ignis Sagitta!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "fire_arrow"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/projectile/fire_arrow/cast(list/targets, mob/user)
	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_1, WARLOCK_SCHOOL_FIRE, src)
	var/success = ..()
	warlock_spell_post_cast(user, WARLOCK_SLOT_1, WARLOCK_SCHOOL_FIRE, success, context)
	return success

/obj/projectile/magic/fire_arrow
	name = "fire arrow"
	icon_state = "lava"
	damage = 35 
	armor_penetration = 30 
	speed = 0.6
	flag = "magic"
	nodamage = FALSE
	guard_deflectable = TRUE
	woundclass = BCLASS_STAB
	npc_simple_damage_mult = 2 
	var/tmp/damage_mult = 1

/obj/projectile/magic/fire_arrow/Initialize()
	. = ..()
	if(isliving(firer))
		var/list/context = warlock_spell_pre_cast(firer, WARLOCK_SLOT_1, WARLOCK_SCHOOL_FIRE, src)
		damage_mult = warlock_get_damage_mult(context)

/obj/projectile/magic/fire_arrow/on_hit(target)
	var/mob/living/L = target
	damage = round(initial(damage) * damage_mult)

	. = ..()

	if(ismob(target))
		if(L.anti_magic_check())
			visible_message(span_warning("[src] шипит и гаснет при контакте с [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK

		L.adjust_fire_stacks(3)
		L.ignite_mob()

		playsound(get_turf(target), 'sound/items/firelight.ogg', 100)
		to_chat(L, span_danger("Огненная стрела вонзается в ваше тело!"))
	else
		return
