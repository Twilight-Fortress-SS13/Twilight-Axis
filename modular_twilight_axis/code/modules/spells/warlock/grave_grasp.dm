
/obj/effect/proc_holder/spell/invoked/grave_grasp
	name = "Grave Grasp"
	desc = "Призывает руку мертвеца в указанной точке. Она схватит и подожжет любого, кто окажется над ней."
	cost = 4
	range = 7
	releasedrain = SPELLCOST_SINGLE_CC
	chargetime = 10
	recharge_time = 15 SECONDS
	spell_tier = 3
	invocations = list("Capere!")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_VAMPIRIC
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_twilight_axis/icons/roguetown/misc/warlock.dmi'
	overlay_state = "grave_grasp"
	var/tmp/damage_mult = 1

/obj/effect/proc_holder/spell/invoked/grave_grasp/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])
	if(!T || T.density)
		to_chat(user, span_warning("Я не могу призвать руку тут!"))
		return FALSE

	var/list/context = warlock_spell_pre_cast(user, WARLOCK_SLOT_4, WARLOCK_SCHOOL_FIRE, src)
	damage_mult = src.damage_mult

	var/obj/effect/grave_hand/H = new /obj/effect/grave_hand(T, user)
	H.damage_mult = damage_mult
	new /obj/effect/temp_visual/gravity_trap(T)

	warlock_spell_post_cast(user, WARLOCK_SLOT_4, WARLOCK_SCHOOL_FIRE, TRUE, context)
	return TRUE

/obj/effect/grave_hand
	name = "grave hand"
	desc = "Мертвенно-бледная рука, тянущаяся из-под земли."
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	color = "#4b0082" 
	anchored = TRUE
	density = FALSE
	var/mob/living/caster
	var/duration = 15 SECONDS
	var/active = TRUE
	var/tmp/damage_mult = 1

/obj/effect/grave_hand/Initialize(mapload, mob/living/user)
	. = ..()
	caster = user
	playsound(src, 'sound/effects/hood_ignite.ogg', 80, TRUE)
	
	var/mob/living/target = locate(/mob/living) in loc
	if(target)
		spawn(1)
			grab_target(target)
	
	QDEL_IN(src, duration)

/obj/effect/grave_hand/Crossed(atom/movable/AM)
	. = ..()
	if(active && isliving(AM))
		grab_target(AM)

/obj/effect/grave_hand/proc/grab_target(mob/living/L)
	if(!active || L == caster || L.stat == DEAD)
		return
	
	if(L.anti_magic_check())
		visible_message(span_warning("Рука рассыпается в прах при попытке схватить [L]!"))
		qdel(src)
		return

	active = FALSE
	visible_message(span_danger("Из-под земли вырывается рука мертвеца и мертвой хваткой вцепляется в [L]!"))
	new /obj/effect/temp_visual/ensnare/long(get_turf(L))
	playsound(src, 'sound/effects/hood_ignite.ogg', 100, TRUE)
	
	L.Immobilize(4 SECONDS)
	L.adjust_fire_stacks(5)
	L.ignite_mob()
	
	if(caster)
		arcyne_strike(caster, L, null, round(25 * damage_mult), BODY_ZONE_CHEST, BCLASS_BURN, 0, "Grave Grasp", TRUE, TRUE)

	to_chat(L, span_userdanger("Вы чувствуете, как холодные пальцы сжимают вашу ногу, обжигая нечестивым пламенем!"))
	
	new /obj/effect/temp_visual/fire(get_turf(L))
	
	qdel(src)
