/mob/living/carbon/human/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	set waitfor = FALSE
	contents_explosion(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	SEND_SIGNAL(src, COMSIG_ATOM_EX_ACT, severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	if (!severity)
		return
	var/ddist = devastation_range
	var/hdist = heavy_impact_range
	var/ldist = light_impact_range
	var/fdist = flame_range
	var/fodist = get_dist(src, epicenter)
	var/brute_loss = 0
	var/burn_loss = 0
	var/dmgmod = round(rand(0.5, 1.5), 0.1)
	
	var/bullet_tier = getarmor(null, "bullet")
	var/fire_tier = getarmor(null, "fire")
	
	var/bullet_mult = 1
	var/fire_mult = 1
	if(bullet_tier > 0)
		bullet_mult = 1 / (1 + 0.1 * bullet_tier)
	if(fire_tier > 0)
		fire_mult = 1 / (1 + 0.1 * fire_tier)

	if(fdist)
		var/stacks = ((fdist - fodist) * 2)
		fire_act(max(stacks, 0))

	switch(severity)
		if(EXPLODE_DEVASTATE)
			var/base_brute = ((120 * ddist) - (120 * fodist)) * dmgmod
			var/base_burn = ((60 * ddist) - (60 * fodist)) * dmgmod
			brute_loss = base_brute * bullet_mult
			burn_loss = base_burn * fire_mult
			damage_clothes(max(base_brute * 4, 0), BRUTE, "bullet")
			Unconscious(max(((50 * ddist) - (15 * fodist)) * bullet_mult, 0))
			Knockdown(max(((30 * ddist) - (30 * fodist)) * bullet_mult, 0))

		if(EXPLODE_HEAVY)
			var/base_brute = ((40 * hdist) - (40 * fodist)) * dmgmod
			var/base_burn = ((20 * hdist) - (20 * fodist)) * dmgmod
			brute_loss = base_brute * bullet_mult
			burn_loss = base_burn * fire_mult
			damage_clothes(max(base_brute * 2, 0), BRUTE, "bullet")
			Unconscious(max(((10 * hdist) - (5 * fodist)) * bullet_mult, 0))
			Knockdown(max(((30 * hdist) - (30 * fodist)) * bullet_mult, 0))

		if(EXPLODE_LIGHT)
			var/base_brute = ((10 * ldist) - (10 * fodist)) * dmgmod
			brute_loss = base_brute * bullet_mult
			damage_clothes(max(base_brute, 0), BRUTE, "bullet")

	var/chest_brute = brute_loss * 0.5
	var/chest_burn = burn_loss * 0.5
	apply_damage(chest_brute, BRUTE, BODY_ZONE_CHEST)
	apply_damage(chest_burn, BURN, BODY_ZONE_CHEST)
	take_overall_damage(max(brute_loss - chest_brute, 0), max(burn_loss - chest_burn, 0))

	if(severity <= 2)
		var/limb_loss_mult = 1
		if(bullet_tier < 3)
			limb_loss_mult = 4
		else if(bullet_tier < 4)
			limb_loss_mult = 2
			
		var/max_limb_loss = rand(0, floor(3/severity))
		if(bullet_tier < 4 && severity == EXPLODE_DEVASTATE)
			max_limb_loss = max(max_limb_loss, rand(1, 3))
			
		for(var/X in bodyparts)
			var/obj/item/bodypart/BP = X
			if(prob(25/severity * limb_loss_mult) && !prob(15) && BP.body_zone != BODY_ZONE_HEAD && BP.body_zone != BODY_ZONE_CHEST)
				BP.brute_dam = BP.max_damage
				BP.dismember()
				max_limb_loss--
				if(max_limb_loss <= 0)
					break

/mob/living/carbon/human/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
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

	for(var/obj/item/I as anything in torn_items)
		I.take_damage(damage_amount, damage_type, damage_flag, 0)
