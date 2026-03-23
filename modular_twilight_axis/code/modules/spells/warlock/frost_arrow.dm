
/obj/effect/proc_holder/spell/invoked/projectile/frost_arrow
	name = "Frost Arrow"
	desc = "Выпускает стрелу из магического льда. Игнорирует часть брони и вызывает сильное обморожение цели."
	cost = 3
	projectile_type = /obj/projectile/magic/frost_arrow
	overlay_state = "ice_spear" 
	sound = list('sound/magic/abyssor_splash.ogg')
	releasedrain = SPELLCOST_MINOR_PROJECTILE
	chargetime = 5
	recharge_time = 7 SECONDS
	spell_tier = 2
	invocations = list("Gelu Sagitta!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "frost_arrow"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/projectile/frost_arrow/cast(list/targets, mob/user)
	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_1, WARLOCK_SCHOOL_FROST, src)
	var/success = ..()
	warlock_spell_post_cast(user, WARLOCK_SLOT_1, WARLOCK_SCHOOL_FROST, success, context)
	return success

/obj/projectile/magic/frost_arrow
	name = "frost arrow"
	icon_state = "ice_2" 
	damage = 45 
	armor_penetration = 30 
	speed = 0.6
	flag = "magic"
	nodamage = FALSE
	guard_deflectable = TRUE
	woundclass = BCLASS_STAB
	npc_simple_damage_mult = 2 
	var/tmp/damage_mult = 1

/obj/projectile/magic/frost_arrow/on_hit(target, blocked = FALSE)
	var/mob/living/L = target
	if(isliving(firer))
		var/list/context = warlock_spell_pre_cast(firer, WARLOCK_SLOT_1, WARLOCK_SCHOOL_FROST, src)
		damage_mult = warlock_get_damage_mult(context)

	damage = round(initial(damage) * damage_mult)

	. = ..()

	if(ismob(target))
		if(L.anti_magic_check())
			visible_message(span_warning("[src] рассыпается ледяной пылью при контакте с [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK

		L.apply_status_effect(/datum/status_effect/buff/frostbite)

		playsound(get_turf(target), 'sound/magic/charged.ogg', 100)
		to_chat(L, span_userdanger("Ледяная стрела пробивает вашу плоть, сковывая тело холодом!"))
	else
		return
