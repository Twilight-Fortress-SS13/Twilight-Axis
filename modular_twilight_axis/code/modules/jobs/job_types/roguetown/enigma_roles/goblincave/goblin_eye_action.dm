/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/New(Target)
	..()
	name = "Use wild goblin eyes"

/mob/living/carbon/human/proc/is_goblin_cave_eye_glow_role()
	var/static/list/goblin_eye_glow_roles = list("Goblin Chief", "Goblin Warrior", "Goblin Shaman")
	return (job in goblin_eye_glow_roles) || (mind?.assigned_role in goblin_eye_glow_roles)

/mob/living/carbon/human/proc/can_show_goblin_cave_eye_glow_examine()
	if(is_eyes_covered(FALSE, TRUE, TRUE))
		return FALSE
	if((wear_mask?.flags_inv & HIDEFACE) || (head?.flags_inv & HIDEFACE) || (wear_neck?.flags_inv & HIDEFACE))
		return FALSE
	return TRUE

/mob/living/get_villain_text(mob/examiner)
	. = ..()

	if(!ishuman(src))
		return .

	var/mob/living/carbon/human/H = src
	if(!H.is_goblin_cave_eye_glow_role())
		return .
	if(!H.can_show_goblin_cave_eye_glow_examine())
		return .

	if(.)
		. += "<br>"
	. += span_userdanger("Глаза странно светятся, прямо как у дикого гоблина!")

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
