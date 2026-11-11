/datum/preferences/copy_to(
	mob/living/carbon/human/character,
	icon_updates = 1,
	roundstart_checks = TRUE,
	character_setup = FALSE,
	antagonist = FALSE,
)
	. = ..()
	character.manor_treasury_retention = manor_treasury_retention
	character.manor_type_pref = manor_type
	character.manor_industry_profiles = taSanitizeManorIndustryProfiles(
		manor_industry_profiles,
		virtue_origin?.type,
	)
