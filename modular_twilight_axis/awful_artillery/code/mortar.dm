#define PROJECTILE_NUM 30 
#define PROJECTILE_DEGREES_DIV 12
/obj/projectile/bullet/shell_shrapnel
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	flag = "piercing"
	hitsound_wall = "ricochet"
	ricochet_chance = 85
	ricochets_max = 3
	armor_penetration = 40

/obj/projectile/bullet/shell_shrapnel/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/bullet_tier = H.getarmor(def_zone, "bullet")
		
		var/limb_loss_mult = 0
		
		if(bullet_tier >= 50) 
			H.damage_clothes(400, BRUTE, "bullet", def_zone)
			H.apply_damage(40, BRUTE, def_zone)
			limb_loss_mult = 0
		else if(bullet_tier >= 10)
			H.damage_clothes(400, BRUTE, "bullet", def_zone)
			H.apply_damage(80, BRUTE, def_zone)
			limb_loss_mult = 0
		else
			H.damage_clothes(400, BRUTE, "bullet", def_zone) 
			H.apply_damage(80, BRUTE, def_zone)
			limb_loss_mult = 4

		if(limb_loss_mult > 0)
			var/obj/item/bodypart/BP = H.get_bodypart(def_zone)
			if(BP && prob(25 * limb_loss_mult) && BP.body_zone != BODY_ZONE_HEAD && BP.body_zone != BODY_ZONE_CHEST)
				BP.brute_dam = BP.max_damage
				BP.dismember(skip_checks = TRUE)

/obj/item/artillery_shell/mortar
	name = "mortar shell"
	sellprice = 50

/obj/item/artillery_shell/shell_action()
	var/turf/T = GET_TURF_ABOVE(get_turf(src))
	if(!T)
		T =  get_turf(src)
		
	while(GET_TURF_ABOVE(T))
		T = GET_TURF_ABOVE(T)

	if(!T)
		T = get_turf(src)

	while(GET_TURF_BELOW(T) && istype(T, /turf/open/transparent))
		T = GET_TURF_BELOW(T)
	
	playsound(src, 'modular_twilight_axis/awful_artillery/sound/fallingonyou.ogg', 100, 0, 10, 1, null, null, FALSE, TRUE)
	sleep(0.5 SECONDS)

	for(var/mob/M in GLOB.player_list)
		M.playsound_local(src, 'modular_twilight_axis/awful_artillery/sound/far_explosion.ogg', 100, FALSE, pressure_affected = FALSE)
	

	var/list/hit_turfs = list(T)

	if(istype(T, /turf/closed))
		explosion(T, 4, 10, 20)
	else 
		var/turf/turf_below = GET_TURF_BELOW(T)
		if(istype(turf_below, /turf/open))
			explosion(T, 4, 10, 20, flame_range = 3, smoke = TRUE, ignorecap = TRUE)
			T.ChangeTurf(/turf/open/transparent/openspace)

			var/ex_range = 5
			for(var/turf/affected_turf in range(ex_range, T))
				if(affected_turf == T)
					continue

				var/dist = get_dist(T, affected_turf)

				if(dist > ex_range)
					continue

				var/falloff = 1 - (dist / ex_range)
				var/chance = 100 * (falloff * falloff)

				if(prob(chance))
					affected_turf.ChangeTurf(/turf/open/transparent/openspace)

			explosion(turf_below, 4, 10, 20, flame_range = 3, smoke = TRUE, ignorecap = TRUE)
			hit_turfs += turf_below
		else 
			explosion(T, 4, 10, 20, flame_range = 3, smoke = TRUE, ignorecap = TRUE)
	
	for(var/turf/target_turf in hit_turfs)
		for(var/i in 1 to PROJECTILE_NUM)
			var/obj/projectile/bullet/shell_shrapnel/P = new(target_turf)
			P.starting = target_turf
			P.def_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD)
			P.fire((i * PROJECTILE_DEGREES_DIV) % 360)
	
	qdel(src)

/obj/structure/artillery/mortar
	name = "mortar"
	desc = "Тяжелое оружие навесного боя, предназначенное для забрасывания врага снарядам за стены и укрепления.\
		Стреляет крутым подъемом, полагаясь на силу пороха и руку артиллериста, а не на прямую наводку."

	elevation = 45
	elevation_min = 45
	elevation_max = 90

	ammo_type = /obj/item/artillery_shell/mortar

/obj/structure/artillery/mortar/get_parts()
	return list(/obj/item/mortar_wheel, /obj/item/mortar_wheel, /obj/item/mortar_wheel, /obj/item/mortar_wheel, /obj/item/mortar_used_barrel, /obj/item/artillery_assembly/mortar)


/obj/item/artillery_assembly/mortar
	name = "mortar carriage"
	icon = 'modular_twilight_axis/awful_artillery/icons/artillery.dmi'
	icon_state = "mortar_base"
	w_class = WEIGHT_CLASS_HUGE


/mob/living/carbon/human/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5
	var/list/torn_items = list()

	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		if(glasses) torn_items |= glasses
		if(wear_mask) torn_items |= wear_mask
		if(wear_neck) torn_items |= wear_neck
		if(head) torn_items |= head
		if(ears) torn_items |= ears

	if(!def_zone || def_zone == BODY_ZONE_CHEST)
		if(wear_shirt) torn_items |= wear_shirt
		if(wear_pants) torn_items |= wear_pants
		if(wear_armor) torn_items |= wear_armor
		if(cloak) torn_items |= cloak

	if(!def_zone || def_zone == BODY_ZONE_L_ARM || def_zone == BODY_ZONE_R_ARM)
		if(gloves) torn_items |= gloves
		if(wear_wrists) torn_items |= wear_wrists
		if(wear_shirt && ((wear_shirt.body_parts_covered & HANDS) || (wear_shirt.body_parts_covered & ARMS))) torn_items |= wear_shirt
		if(wear_pants && ((wear_pants.body_parts_covered & HANDS) || (wear_pants.body_parts_covered & ARMS))) torn_items |= wear_pants
		if(wear_armor && ((wear_armor.body_parts_covered & HANDS) || (wear_armor.body_parts_covered & ARMS))) torn_items |= wear_armor

	if(!def_zone || def_zone == BODY_ZONE_L_LEG || def_zone == BODY_ZONE_R_LEG)
		if(shoes) torn_items |= shoes
		if(wear_pants && ((wear_pants.body_parts_covered & FEET) || (wear_pants.body_parts_covered & LEGS))) torn_items |= wear_pants
		if(wear_armor && ((wear_armor.body_parts_covered & FEET) || (wear_armor.body_parts_covered & LEGS))) torn_items |= wear_armor

	for(var/obj/item/I as anything in torn_items)
		I.take_damage(damage_amount, damage_type, damage_flag, 0)

/obj/item/mortar_wheel 
	name = "mortar carriage wheel"
	icon = 'modular_twilight_axis/awful_artillery/icons/artillery.dmi'
	icon_state = "mortar_wheel"
	sellprice = 5
	

/obj/item/mortar_barrel 
	name = "barrel of the mortar"
	icon = 'modular_twilight_axis/awful_artillery/icons/artillery.dmi'
	icon_state = "barrel"
	sellprice = 150
	w_class = WEIGHT_CLASS_HUGE

/obj/item/mortar_used_barrel
	name = "damaged mortar barrel"
	desc = "Если обжечь в печи, можно частично восстановить ствол."
	icon = 'modular_twilight_axis/awful_artillery/icons/artillery.dmi'
	icon_state = "barrel"
	color = "#ecaf86"
	sellprice = 25
	smeltresult = /obj/item/artillery_barrel_assembly
/*
GLOBAL_VAR_INIT(has_mortar_spawned, FALSE)
/datum/job/roguetown/marshal/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	if(!GLOB.has_mortar_spawned)
		GLOB.has_mortar_spawned = TRUE
		var/obj/structure/artillery/mortar/mortar = new /obj/structure/artillery/mortar(H.loc)
		H.start_pulling(mortar)
		to_chat(H, span_danger("Со мной моя трофейная мортира, замечательно."))
*/
#undef PROJECTILE_NUM 
#undef PROJECTILE_DEGREES_DIV
