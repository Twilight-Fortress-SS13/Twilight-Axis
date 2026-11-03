/datum/intent/hand/splash
	name = "splash"
	icon_state = "inuse"

/obj/item/melee/new_touch_attack/prestidigitation
	desc = "Clean, Spark, Light, Sense and Splash. Splash fires a harmless water bolt that extinguishes fires and cools the target."
	possible_item_intents = list(/datum/intent/hand/clean, /datum/intent/hand/spark, /datum/intent/hand/light, /datum/intent/hand/sense, /datum/intent/hand/splash)

/obj/item/melee/new_touch_attack/prestidigitation/proc/ta_climate_shoot_waterbolt(mob/living/carbon/user, atom/target)
	if(!user || !target)
		return FALSE
	var/turf/source_turf = get_turf(user)
	if(!source_turf)
		return FALSE
	var/obj/projectile/energy/waterbolt/projectile = new(source_turf)
	projectile.zone_aimed = user.zone_selected
	projectile.firer = user
	projectile.original = target
	if(target == user)
		projectile.on_hit(user)
		qdel(projectile)
	else
		projectile.preparePixelProjectile(target, user)
		projectile.fire()
	return TRUE
