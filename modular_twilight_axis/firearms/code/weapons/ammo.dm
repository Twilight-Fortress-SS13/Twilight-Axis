/obj/projectile/bullet
	var/silver = FALSE
	var/blessed = FALSE
	var/always_drop = FALSE
	var/critfactor = 1
	var/gunpowder_npc_critfactor = 1
	var/gunpowder

/**
 * Generic ammo used by handgonnes and arquebuses
 */
/obj/projectile/bullet/twilight_lead
	name = "lead sphere"
	desc = "Небольшая свинцовая сфера. Хорошо сочетается с порохом."
	damage = 70
	damage_type = BRUTE
	icon = 'modular_twilight_axis/firearms/icons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/twilight_lead
	range = 12		
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag = "stab"
	armor_penetration = 42
	speed = 0.1

/obj/projectile/bullet/twilight_lead/silver
	name = "silver sphere"
	desc = "Небольшая серебряная сфера. Мягче, чем свинцовая пуля, но крайне эффективна против нежити."
	ammo_type = /obj/item/ammo_casing/caseless/twilight_lead/silver
	damage = 60
	armor_penetration = 35
	silver = TRUE
	critfactor = 0.8

/obj/projectile/bullet/twilight_cannonball
	name = "cannonball"
	desc = "Крупная свинцовая сфера. Важен не размер ствола, а размер отверстия, что он делает в вашем противнике."
	damage = 60
	damage_type = BRUTE
	icon = 'modular_twilight_axis/firearms/icons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/twilight_cannonball
	range = 16		
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 0
	woundclass = BCLASS_STAB
	flag = "blunt"
	armor_penetration = 5
	speed = 0.1

/obj/projectile/bullet/twilight_grapeshot
	name = "grapeshot"
	desc = "Плотно упакованный в бумагу набор небольших металлических шариков. Хорошо сочетается с порохом."
	damage = 20
	damage_type = BRUTE
	icon = 'modular_twilight_axis/firearms/icons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/twilight_cannonball/grapeshot
	range = 10
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag = "stab"
	armor_penetration = 42
	speed = 0.1
	critfactor = 0.67

/**
 * Special runelock ammo
 * Meant to be LIMITED, but reusable
 */

/obj/projectile/bullet/twilight_lead/twilight_runelock
	name = "runed sphere"
	desc = "Небольшой, идеально круглый металлический шар, покрытый псайдонитскими рунами. Смертоносен на высокой скорости."
	damage = 90
	armor_penetration = 75
	speed = 0.6
	damage_type = BRUTE
	icon = 'modular_twilight_axis/firearms/icons/ammo.dmi'
	icon_state = "musketball_runed"
	ammo_type = /obj/item/ammo_casing/caseless/twilight_lead/runelock
	range = 20
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag = "piercing"
	always_drop = TRUE

/obj/projectile/bullet/twilight_lead/twilight_runelock/blessed
	name = "blessed sphere"
	desc = "Небольшой, идеально круглый шар, изготовленный из чистого серебра. Такие боеприпасы создаются лучшими из отавианских кузнецов и освящяются лично Великим Магистром. Смертоностны против нежити, но весьма эффективны и против других еретиков."
	damage = 100
	ammo_type = /obj/item/ammo_casing/caseless/twilight_lead/runelock/blessed
	icon_state = "musketball_blessed"
	silver = TRUE
	blessed = TRUE

/atom/movable/screen/alert/status_effect/debuff/thunderpowder
	name = "Struck by Thunder"
	desc = "I was struck by a Thunderpowder shot. My muscles are tense, and it's difficult to move."
	icon_state = "muscles"

/datum/status_effect/debuff/thunderpowder
	id = "thunderpowder"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thunderpowder
	effectedstats = list(STATKEY_SPD = -2)
	duration = 1 MINUTES

/datum/status_effect/debuff/corrosivesplash
	id = "corrosive splash"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/corrosivesplash
	duration = 10 SECONDS

/datum/status_effect/debuff/corrosivesplash/on_apply()
	. = ..()
	owner.playsound_local(get_turf(owner), 'sound/misc/lava_death.ogg', 35, FALSE, pressure_affected = FALSE)
	owner.visible_message(span_warning("[owner] is covered in acid!"), span_danger("I am covered in acid!"))
	owner.emote("scream")

/atom/movable/screen/alert/status_effect/debuff/corrosivesplash
	name = "Corrosion"
	desc = "My armor is boiling on me!"
	icon_state = "debuff"

/datum/status_effect/debuff/corrosivesplash/tick()
	var/mob/living/target = owner
	target.adjustFireLoss(2)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/list/armor = list()
		var/list/body_parts = list(H.head, H.wear_mask, H.wear_wrists, H.wear_shirt, H.wear_neck, H.wear_armor, H.wear_pants, H.gloves, H.shoes, H.belt, H.glasses)
		for(var/bp in body_parts)
			if(!bp)
				continue
			if(bp && istype(bp, /obj/item/clothing))
				armor += bp
		if(armor)
			var/obj/item/clothing/C = pick(armor)
			if(C.obj_integrity > (C.max_integrity * 0.03))
				C.take_damage(damage_amount = (C.max_integrity * 0.03), damage_type = BURN, damage_flag = "fire")

/obj/projectile/bullet/fire(angle, atom/direct_target)
	if(istype(fired_from, /obj/item/gun/ballistic/twilight_firearm))
		var/obj/item/gun/ballistic/twilight_firearm/gun = fired_from
		if(isliving(firer))
			var/mob/living/L = firer
			damage *= gun.damfactor * (L.STAPER > 10 ? L.STAPER / 10 : 1)
		else
			damage *= gun.damfactor
		critfactor *= gun.critfactor
		gunpowder_npc_critfactor *= gun.npcdamfactor
		gunpowder = gun.gunpowder
	..()

/obj/projectile/bullet/on_hit(atom/target, blocked = FALSE)
	if(isliving(target))
		var/mob/living/T = target
		if(istype(fired_from, /obj/item/gun/ballistic/twilight_firearm)) //Double damage in close range
			var/obj/item/gun/ballistic/twilight_firearm/G = fired_from
			for(var/mob/M in range(G.effective_range, T))
				if(M == firer)
					damage *= 2
					armor_penetration *= 2
					if(!istype(T.get_inactive_held_item(), /obj/item/rogueweapon/shield) && !istype(T.get_active_held_item(), /obj/item/rogueweapon/shield) && (blocked == 0))
						switch(gunpowder) //Hande gunpowder types that are BLOCKED by shields and armor
							if("fyrepowder")
								if(istype(src, /obj/projectile/bullet/twilight_grapeshot))
									T.adjust_fire_stacks(2)
								else
									T.adjust_fire_stacks(5)
								T.ignite_mob()
							if("holy fyrepowder")
								if(HAS_TRAIT(T, TRAIT_SILVER_WEAK))
									if(!T.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder))
										if(T.patron)
											to_chat(T, span_danger("The trice-cursed Otavan silver! By [T.patron.name], it hurts!!"))
										else
											to_chat(T, span_danger("The trice-cursed Otavan silver! By all that's holy, it hurts!!"))
									if(istype(src, /obj/projectile/bullet/twilight_grapeshot))
										T.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
									else
										T.adjust_fire_stacks(5, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
								else
									if(istype(src, /obj/projectile/bullet/twilight_grapeshot))
										T.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/divine)
									else
										T.adjust_fire_stacks(5, /datum/status_effect/fire_handler/fire_stacks/divine)
								T.ignite_mob()
							if("thunderpowder")
								T.Immobilize(30)
								T.apply_status_effect(/datum/status_effect/debuff/thunderpowder)
							if("corrosive gunpowder")
								playsound(src, 'sound/misc/drink_blood.ogg', 100)
								T.apply_status_effect(/datum/status_effect/debuff/corrosivesplash)
								new /obj/effect/temp_visual/acidsplash(get_turf(T))
							if("arcyne gunpowder")
								if(ishuman(T))
									var/mob/living/carbon/human/H = T
									if(istype(H.wear_ring, /obj/item/clothing/ring/fate_weaver))
										H.wear_ring.obj_break()
									H.set_silence(5 SECONDS)
							if("terrorpowder")
								gunpowder_npc_critfactor += 1
					else
						switch(gunpowder) //Hande gunpowder types that are NOT BLOCKED by shields and armor
							if("corrosive gunpowder")
								playsound(src, 'sound/misc/drink_blood.ogg', 100)
								T.apply_status_effect(/datum/status_effect/debuff/corrosivesplash)
								new /obj/effect/temp_visual/acidsplash(get_turf(T))
							if("terrorpowder")
								gunpowder_npc_critfactor += 1
					if(!T.mind)
						damage *= gunpowder_npc_critfactor
				else
					T.visible_message(span_danger("The [src.name] misses [T] narrowly, grazing them!"), \
									span_danger("The [src.name] misses me narrowly, grazing me!"), null, COMBAT_MESSAGE_RANGE)
	. = ..()
	if(isliving(firer) && (istype(fired_from, /obj/item/gun/ballistic/twilight_firearm) || istype(fired_from, /obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock)))
		var/mob/living/M = firer
		var/skill = (M?.mind ? M.get_skill_level(/datum/skill/combat/twilight_firearms) : 1)
		if(isliving(target))
			var/mob/living/T = target
			if(skill >= 1 && M.mind) //Exp gain from firing a gun
				if(isanimal(T) && (T.stat != DEAD || (T.stat == DEAD && T.timeofdeath == world.time)))
					M.mind.add_sleep_experience(/datum/skill/combat/twilight_firearms, M.STAINT * 2)
				else if(ishuman(T) && (T.stat != DEAD || (T.stat == DEAD && T.timeofdeath == world.time)))
					M.mind.add_sleep_experience(/datum/skill/combat/twilight_firearms, M.STAINT * 4)
			if(silver && HAS_TRAIT(T, TRAIT_SILVER_WEAK))
				if(blessed)
					if(!T.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder))
						if(T.patron)
							to_chat(T, span_danger("The trice-cursed Otavan silver! By [T.patron.name], it hurts!!"))
						else
							to_chat(T, span_danger("The trice-cursed Otavan silver! By all that's holy, it hurts!!"))
					T.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
				else
					if(!T.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
						to_chat(T, span_danger("Silver rebukes my presence! These fires are lashing at my very soul!"))
					T.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder)
				T.ignite_mob()
		if(always_drop)
			var/turf/T = get_turf(src)
			dropped = new ammo_type(T)

/*/mob/living/carbon/check_projectile_wounding(obj/projectile/P, def_zone, blocked)
	if(isliving(P.firer) && (istype(P.fired_from, /obj/item/gun/ballistic/twilight_firearm) || istype(P.fired_from, /obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock)))
		var/mob/living/M = P.firer
		var/obj/projectile/bullet/B = P
		blocked = run_armor_check(def_zone, P.flag, "", "",armor_penetration = B.armor_penetration, damage = P.damage)
		if(blocked == 0) //Handle crits. Gunpowder weapons have a separate crit roll that ignores bodypart health
			var/zone = def_zone
			var/obj/item/bodypart/affecting = get_bodypart(zone)
			if(affecting)
				var/check_crit_against_con = rand(10, 20)
				check_crit_against_con *= B.critfactor * (M.STAPER > 10 ? M.STAPER / 10 : 1)
				if(check_crit_against_con > (src.STACON))
					if(getarmor(zone, B.flag) >= (B.armor_penetration / 2))
						if(prob(50))
							affecting.twilight_gunpowder_crit(P.woundclass, zone_precise = zone, silent = FALSE, crit_message = TRUE)
					else
						if(prob(90))
							affecting.twilight_gunpowder_crit(P.woundclass, zone_precise = zone, silent = FALSE, crit_message = TRUE)
	. = ..()*/

/obj/projectile/bullet/twilight_cannonball/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/turf/T = get_turf(target)
	switch(gunpowder)
		if("fyrepowder")
			explosion(T, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 1, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
		if("holy fyrepowder")
			explosion(T, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
			for(var/mob/living/L in range(2, T))
				if(!(L == target))
					if(HAS_TRAIT(L, TRAIT_SILVER_WEAK))
						if(!L.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder))
							if(L.patron)
								to_chat(L, span_danger("The trice-cursed Otavan silver! By [L.patron.name], it hurts!!"))
							else
								to_chat(L, span_danger("The trice-cursed Otavan silver! By all that's holy, it hurts!!"))
						L.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
					else
						L.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/divine)
					L.ignite_mob()
		if("corrosive gunpowder")
			explosion(T, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
			for(var/mob/living/L in range(1, T)) //apply damage over time to mobs
				if(!(L == target))
					var/mob/living/carbon/M = L
					M.apply_status_effect(/datum/status_effect/debuff/corrosivesplash)
					new /obj/effect/temp_visual/acidsplash(get_turf(M))
			for(var/turf/turfs_in_range in range(2, T)) //make a splash
				new /obj/effect/temp_visual/acidsplash(turfs_in_range)
		if("thunderpowder")
			explosion(T, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
			for(var/mob/living/L in range(2, T))
				if(!(L == target))
					L.Immobilize(30)
					L.apply_status_effect(/datum/status_effect/debuff/thunderpowder)
		if("arcyne gunpowder")
			explosion(T, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
			for(var/mob/living/carbon/human/L in range(2, T))
				if(!(L == target))
					if(istype(L.wear_ring, /obj/item/clothing/ring/fate_weaver))
						L.wear_ring.obj_break()
					L.set_silence(5 SECONDS)
		else
			explosion(T, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 1, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

/obj/item/ammo_casing/caseless/twilight_lead
	name = "lead sphere"
	desc = "Небольшая свинцовая сфера. Хорошо сочетается с порохом."
	projectile_type = /obj/projectile/bullet/twilight_lead
	caliber = "lead_sphere"
	icon = 'modular_twilight_axis/firearms/icons/ammo.dmi'
	icon_state = "musketball"
	dropshrink = 0.5
	max_integrity = 0.1

/obj/item/ammo_casing/caseless/twilight_lead/runelock
	name = "runed sphere"
	desc = "Небольшой, идеально круглый металлический шар, покрытый псайдонитскими рунами. Смертоносен на высокой скорости."
	projectile_type = /obj/projectile/bullet/twilight_lead/twilight_runelock
	caliber = "runed_sphere"
	icon = 'modular_twilight_axis/firearms/icons/ammo.dmi'
	icon_state = "musketball_runed"
	possible_item_intents = list(/datum/intent/use)
	max_integrity = 0
	w_class = WEIGHT_CLASS_TINY

/obj/item/ammo_casing/caseless/twilight_lead/runelock/Initialize()
	. = ..()
	var/filter = src.get_filter("rune_filter")
	if(!filter)
		src.add_filter("rune_filter", 2, list("type" = "outline", "color" = rgb(112, 28, 28, 1), "alpha" = 200, "size" = 2))

/obj/item/ammo_casing/caseless/twilight_lead/runelock/equipped(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!HAS_TRAIT(H, TRAIT_INQUISITION) && !(H.STAINT >= 15) && !(H.patron?.type == /datum/patron/old_god) && !(H.merctype == 10))
			to_chat(H, "<font color='yellow'>The [name] is extremely hot to touch! It burns your hand!</font>")
			var/def_zone = "[(H.active_hand_index == 2) ? "r" : "l" ]_hand"
			H.apply_damage(rand(5,15), BURN, def_zone)
			src.forceMove(get_turf(H))
	else
		to_chat(user, "<font color='yellow'>The [name] is extremely hot to touch! It burns your hand!</font>")
		user.apply_damage(rand(5,15), BURN)
		src.forceMove(get_turf(user))
	..()

/obj/item/ammo_casing/caseless/twilight_lead/silver
	name = "silver sphere"
	desc = "Небольшая серебряная сфера. Мягче, чем свинцовая пуля, но крайне эффективна против нежити."
	projectile_type = /obj/projectile/bullet/twilight_lead/silver
	icon_state = "musketball_silver"

/obj/item/ammo_casing/caseless/twilight_lead/runelock/blessed
	name = "blessed sphere"
	desc = "Небольшой, идеально круглый шар, изготовленный из чистого серебра. Такие боеприпасы создаются лучшими из отавианских кузнецов и освящяются лично Великим Магистром. Смертоностны против нежити, но весьма эффективны и против других еретиков."
	projectile_type = /obj/projectile/bullet/twilight_lead/twilight_runelock/blessed
	icon_state = "musketball_blessed"
	w_class = WEIGHT_CLASS_TINY
	smeltresult = /obj/item/rogueore/silver

/obj/item/ammo_casing/caseless/twilight_cannonball
	name = "lead cannonball"
	desc = "Крупная свинцовая сфера. Важен не размер ствола, а размер отверстия, что он делает в вашем противнике."
	projectile_type = /obj/projectile/bullet/twilight_cannonball
	caliber = "cannonball"
	icon = 'modular_twilight_axis/firearms/icons/ammo.dmi'
	icon_state = "cball"
	dropshrink = 0.5
	max_integrity = 0.1
	grid_width = 32
	grid_height = 64

/obj/item/ammo_casing/caseless/twilight_cannonball/grapeshot
	name = "grapeshot"
	desc = "Плотно упакованный в бумагу набор небольших металлических шариков. Хорошо сочетается с порохом."
	projectile_type = /obj/projectile/bullet/twilight_grapeshot
	caliber = "cannonball"
	icon = 'modular_twilight_axis/firearms/icons/ammo.dmi'
	icon_state = "grapeshot"
	dropshrink = 0.5
	max_integrity = 0.1
	pellets = 6
	variance = 30
