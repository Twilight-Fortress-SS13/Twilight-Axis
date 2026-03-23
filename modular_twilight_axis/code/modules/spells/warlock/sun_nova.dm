
/obj/effect/proc_holder/spell/invoked/sun_nova
	name = "Sun Nova"
	desc = "Создает неподвижное кольцо магического огня."
	cost = 5
	range = 2
	releasedrain = SPELLCOST_MAJOR_AOE
	chargetime = 15
	recharge_time = 25 SECONDS
	spell_tier = 3
	invocations = list("Sol Invictus!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	glow_intensity = GLOW_INTENSITY_HIGH
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "sun_nova"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/sun_nova/cast(list/targets, mob/user)
	var/turf/center = get_turf(user)
	if(!center)
		return FALSE

	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_4, WARLOCK_SCHOOL_FIRE, src)
	damage_mult = src.damage_mult

	playsound(center, 'sound/magic/fireball.ogg', 100, TRUE)
	
	for(var/turf/T in orange(2, center))
		if(get_dist(center, T) != 2)
			continue
		
		if(T.density)
			continue
			
		var/blocked = FALSE
		for(var/obj/O in T.contents)
			if(O.density)
				blocked = TRUE
				break
		
		if(blocked)
			continue

		var/obj/effect/sun_nova_fire/F = new /obj/effect/sun_nova_fire(T, user)
		F.damage_mult = damage_mult

	warlock_spell_post_cast(user, WARLOCK_SLOT_4, WARLOCK_SCHOOL_FIRE, TRUE, context)
	return TRUE

/obj/effect/sun_nova_fire
	name = "magical fire"
	desc = "Магическое пламя."
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	var/mob/living/caster
	var/duration = 10 SECONDS
	var/tmp/damage_mult = 1

/obj/effect/sun_nova_fire/Initialize(mapload, mob/living/user)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return .

	ASYNC(CALLBACK(src, PROC_REF(postInit), user))

/obj/effect/sun_nova_fire/proc/postInit(mob/living/user)
	if(QDELETED(src))
		return

	caster = user
	set_light(2, 2, "#ff4500")

	var/mob/living/target = locate(/mob/living) in loc
	if(target)
		burn_target(target)

	QDEL_IN(src, duration)
/obj/effect/sun_nova_fire/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		burn_target(AM)


/obj/effect/sun_nova_fire/proc/burn_target(mob/living/L)
	if(!L || L == caster || L.stat == DEAD)
		return
	
	if(L.anti_magic_check())
		return


	L.adjust_fire_stacks(5)
	L.ignite_mob()
	
	arcyne_strike(caster, L, null, round(15 * damage_mult), BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "Sun Nova", skip_animation = TRUE, skip_message = FALSE)
	
	to_chat(L, span_userdanger("Вы наступили в магический огонь!"))
