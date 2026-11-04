/obj/effect/proc_holder/spell/invoked/projectile/snowball_toss
	name = "Frost Sphere"
	desc = "Запускает магический снежный шар. При попадании накладывает 2 стака обморожения и отбрасывает цель."
	school = "evocation"
	invocations = list("GLACIES PILLA!")
	invocation_type = "shout"
	projectile_type = /obj/projectile/magic/frost_sphere
	cost = 4
	spell_tier = 2
	releasedrain = 20
	chargetime = 20
	recharge_time = 21 SECONDS
	action_icon = 'modular_twilight_axis/icons/mob/actions/roguespells.dmi'
	overlay_state = "pulse1" 
	glow_color = "#00ffff"
	associated_skill = /datum/skill/magic/arcane
	chargedloop = /datum/looping_sound/invokegen

/obj/effect/proc_holder/spell/invoked/projectile/snowball_toss/cast(list/targets, mob/user)
	user.visible_message(span_warning("<b>[user]</b> throws a massive lump of ice and snow!"))
	return ..()


/obj/projectile/magic/frost_sphere
	name = "magic snowball"
	icon_state = "pulse1" 
	damage = 45
	damage_type = BRUTE
	nodamage = FALSE
	flag = "magic"
	speed = 1.0
	range = 15
	hitsound = 'sound/spellbooks/icicle.ogg'

/obj/projectile/magic/frost_sphere/on_hit(target)
	var/turf/T = get_turf(target)
	
	
	new /obj/effect/temp_visual/snap_freeze(T)
	playsound(T, 'sound/magic/whiteflame.ogg', 40, TRUE)

	if(isliving(target))
		var/mob/living/L = target
		if(!L.anti_magic_check())
			
			L.apply_status_effect(/datum/status_effect/stacking/hypothermia, 2)
			
			
			var/push_dir = get_dir(firer, L)
			if(push_dir)
				
				step(L, push_dir)
			
			to_chat(L, span_warning("A heavy snowball throws me back!"))

	return ..()
