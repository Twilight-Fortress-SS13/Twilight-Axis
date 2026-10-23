/obj/item/broom
	associated_skill = null

/obj/item/broom/sweep_time(mob/living/user)
	return max(40 - (user.get_skill_level(/datum/skill/craft/cooking) * 15), 5)

/obj/item/broom/sweep_move_time(mob/living/user)
	return max(40 - (user.get_skill_level(/datum/skill/craft/cooking) * 15), 5)

/obj/item/kitchen/rollingpin
	associated_skill = null
