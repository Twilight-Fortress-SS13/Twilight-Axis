/datum/charflaw/nude_sleeper
	name = "Nude Sleeper"
	desc = "You just can't seem to fall asleep unless you're <i>truly</i> comfortable..."
	ui_fa_icon = "shirt"
	needs_extra_vice = TRUE

/datum/charflaw/nude_sleeper/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_NUDE_SLEEPER, TRAIT_GENERIC)
