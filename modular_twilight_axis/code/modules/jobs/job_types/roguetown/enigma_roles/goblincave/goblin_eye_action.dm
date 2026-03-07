/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/New(Target)
	..()
	name = "Use wild goblin eyes"
	button.name = name

/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/Trigger()
	if(!..())
		return FALSE

	var/obj/item/organ/eyes/eyes = target
	if(!istype(eyes))
		return FALSE

	eyes.sight_flags = initial(eyes.sight_flags)
	if(isnull(eyes.lighting_alpha))
		eyes.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE

	switch(eyes.lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			eyes.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			eyes.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			eyes.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			eyes.lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			eyes.sight_flags &= ~SEE_BLACKNESS

	if(eyes.owner)
		eyes.owner.update_sight()
	return TRUE
