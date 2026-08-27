/datum/bond_disposition/proc/applies_to(mob/living/carbon/human/person)
	if(!flaw_type || !ishuman(person))
		return FALSE
	return person.has_flaw(flaw_type)

/datum/bond_disposition/masochist
	flaw_type = /datum/charflaw/addiction/masochist
	category_scales = list(
		BOND_CATEGORY_VIOLENCE = 0,
	)

/datum/bond_disposition/paranoid
	flaw_type = /datum/charflaw/paranoid
	category_scales = list(
		BOND_CATEGORY_VIOLENCE = 1.5,
		BOND_CATEGORY_KINDNESS = 0.5,
	)

/datum/bond_disposition/lonely
	flaw_type = /datum/charflaw/lonely
	category_scales = list(
		BOND_CATEGORY_KINDNESS = 1.5,
	)

/datum/bond_disposition/clingy
	flaw_type = /datum/charflaw/clingy
	category_scales = list(
		BOND_CATEGORY_KINDNESS = 1.5,
	)
