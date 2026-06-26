#define EX_BRUTE_DEV 120
#define EX_BURN_DEV 60
#define EX_UNC_DEV_D 50
#define EX_UNC_DEV_F 15
#define EX_KD_DEV 30

#define EX_BRUTE_HEAVY 40
#define EX_BURN_HEAVY 20
#define EX_UNC_HEAVY_H 10
#define EX_UNC_HEAVY_F 5
#define EX_KD_HEAVY 30

#define EX_BRUTE_LIGHT 10


/mob/living/carbon/human/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	if (!severity)
		return
	if (!epicenter)
		return ..()

	var/is_artillery = (devastation_range == ARTILLERY_DEV_RANGE && heavy_impact_range == ARTILLERY_HEAVY_RANGE && light_impact_range == ARTILLERY_LIGHT_RANGE)
	if(!is_artillery)
		return ..()

	var/turf/epicenter_turf = get_turf(epicenter)
	var/turf/my_turf = get_turf(src)
	if(!epicenter_turf || !my_turf || epicenter_turf.z != my_turf.z)
		return ..()

	log_combat(target, src, "blown up by artillery")
	flash_act()

	SEND_SIGNAL(src, COMSIG_ATOM_EX_ACT, severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	if(QDELETED(src))
		return
	var/ddist = devastation_range
	var/hdist = heavy_impact_range
	var/ldist = light_impact_range
	var/fdist = flame_range
	var/fodist = get_dist(my_turf, epicenter_turf)
	var/brute_loss = 0
	var/burn_loss = 0
	var/dmgmod = rand(5, 15) * 0.1
	
	var/bullet_tier = getarmor(BODY_ZONE_CHEST, "bullet") || 0
	var/fire_tier = getarmor(BODY_ZONE_CHEST, "fire") || 0
	
	var/bullet_mult = 1
	var/fire_mult = 1
	if(bullet_tier > 0)
		bullet_mult = 1 / (1 + 0.1 * bullet_tier)
	if(fire_tier > 0)
		fire_mult = 1 / (1 + 0.1 * fire_tier)

	if(fdist && fodist < fdist)
		var/stacks = (fdist - fodist) * 2
		adjust_fire_stacks(stacks)
		ignite_mob()

	switch(severity)
		if(EXPLODE_DEVASTATE)
			var/base_brute = max(EX_BRUTE_DEV * (ddist - fodist) * dmgmod, 0)
			var/base_burn = max(EX_BURN_DEV * (ddist - fodist) * dmgmod, 0)
			brute_loss = base_brute * bullet_mult
			burn_loss = base_burn * fire_mult
			adjustEarDamage(30, 120)
			artillery_damage_clothes(max(base_brute * 4, 0), BRUTE, "bullet")
			Unconscious(max(((EX_UNC_DEV_D * ddist) - (EX_UNC_DEV_F * fodist)) * bullet_mult, 0))
			Knockdown(max(EX_KD_DEV * (ddist - fodist) * bullet_mult, 0))

		if(EXPLODE_HEAVY)
			var/base_brute = max(EX_BRUTE_HEAVY * (hdist - fodist) * dmgmod, 0)
			var/base_burn = max(EX_BURN_HEAVY * (hdist - fodist) * dmgmod, 0)
			brute_loss = base_brute * bullet_mult
			burn_loss = base_burn * fire_mult
			adjustEarDamage(15, 60)
			artillery_damage_clothes(max(base_brute * 2, 0), BRUTE, "bullet")
			Unconscious(max(((EX_UNC_HEAVY_H * hdist) - (EX_UNC_HEAVY_F * fodist)) * bullet_mult, 0))
			Knockdown(max(EX_KD_HEAVY * (hdist - fodist) * bullet_mult, 0))

		if(EXPLODE_LIGHT)
			var/base_brute = max(EX_BRUTE_LIGHT * (ldist - fodist) * dmgmod, 0)
			brute_loss = base_brute * bullet_mult
			artillery_damage_clothes(max(base_brute, 0), BRUTE, "bullet")

	var/chest_brute = brute_loss * 0.5
	var/chest_burn = burn_loss * 0.5
	apply_damage(chest_brute, BRUTE, BODY_ZONE_CHEST)
	apply_damage(chest_burn, BURN, BODY_ZONE_CHEST)
	take_overall_damage(max(brute_loss - chest_brute, 0), max(burn_loss - chest_burn, 0))

	if(severity <= EXPLODE_HEAVY)
		var/limb_loss_mult = 1
		if(bullet_tier < 3)
			limb_loss_mult = 4
		else if(bullet_tier < 4)
			limb_loss_mult = 2
			
		var/max_limb_loss = rand(0, round(3/severity))
		if(bullet_tier < 4 && severity == EXPLODE_DEVASTATE)
			max_limb_loss = max(max_limb_loss, rand(1, 3))
			
		if(bodyparts)
			for(var/X in bodyparts.Copy())
				var/obj/item/bodypart/bp = X
				if(!bp)
					continue
				if(prob(25/severity * limb_loss_mult) && !prob(15) && bp.body_zone != BODY_ZONE_HEAD && bp.body_zone != BODY_ZONE_CHEST)
					bp.receive_damage(bp.max_damage, 0)
					bp.dismember()
					max_limb_loss--
					if(max_limb_loss <= 0)
						break

/mob/living/carbon/human/proc/artillery_damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5
	var/list/torn_items = list()

	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		if(glasses)
			torn_items |= glasses
		if(wear_mask)
			torn_items |= wear_mask
		if(wear_neck)
			torn_items |= wear_neck
		if(head)
			torn_items |= head
		if(ears)
			torn_items |= ears


	if(!def_zone || def_zone == BODY_ZONE_CHEST)
		if(wear_shirt)
			torn_items |= wear_shirt
		if(wear_pants)
			torn_items |= wear_pants
		if(wear_armor)
			torn_items |= wear_armor
		if(cloak)
			torn_items |= cloak


	if(!def_zone || def_zone == BODY_ZONE_L_ARM || def_zone == BODY_ZONE_R_ARM)
		if(gloves)
			torn_items |= gloves
		if(wear_wrists)
			torn_items |= wear_wrists
		if(wear_shirt && ((wear_shirt.body_parts_covered & HANDS) || (wear_shirt.body_parts_covered & ARMS)))
			torn_items |= wear_shirt
		if(wear_pants && ((wear_pants.body_parts_covered & HANDS) || (wear_pants.body_parts_covered & ARMS)))
			torn_items |= wear_pants
		if(wear_armor && ((wear_armor.body_parts_covered & HANDS) || (wear_armor.body_parts_covered & ARMS)))
			torn_items |= wear_armor


	if(!def_zone || def_zone == BODY_ZONE_L_LEG || def_zone == BODY_ZONE_R_LEG)
		if(shoes)
			torn_items |= shoes
		if(wear_pants && ((wear_pants.body_parts_covered & FEET) || (wear_pants.body_parts_covered & LEGS)))
			torn_items |= wear_pants
		if(wear_armor && ((wear_armor.body_parts_covered & FEET) || (wear_armor.body_parts_covered & LEGS)))
			torn_items |= wear_armor

	for(var/obj/item/torn_item as anything in torn_items)
		if(!torn_item)
			continue
		torn_item.take_damage(damage_amount, damage_type, damage_flag, 0)

#undef EX_BRUTE_DEV
#undef EX_BURN_DEV
#undef EX_UNC_DEV_D
#undef EX_UNC_DEV_F
#undef EX_KD_DEV

#undef EX_BRUTE_HEAVY
#undef EX_BURN_HEAVY
#undef EX_UNC_HEAVY_H
#undef EX_UNC_HEAVY_F
#undef EX_KD_HEAVY

#undef EX_BRUTE_LIGHT
