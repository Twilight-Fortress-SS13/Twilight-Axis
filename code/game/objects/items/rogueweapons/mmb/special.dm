/datum/intent/special
	name = "special"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE

/datum/intent/special/on_mmb(atom/target, mob/living/user, params)
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!user.mind)
		return
	if(!user.cmode && ishuman(user) && ishuman(target)) // TA EDIT
		var/mob/living/carbon/human/H = user // TA EDIT
		if(target.Adjacent(H)) // TA EDIT
			H.attempt_steal(H, target) // TA EDIT
		return // TA EDIT
	user.try_special(target)
	. = ..()
