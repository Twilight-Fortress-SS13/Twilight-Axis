/datum/antagonist/wretch
	name = "Wretch"
	roundend_category = "wretches"
	antagpanel_category = "Wretches"
	show_name_in_check_antagonists = FALSE
	has_tempo = TRUE

/datum/antagonist/wretch/get_antag_cap_weight()
	return 0

/datum/antagonist/wretch/on_gain()
	. = ..()
	if(owner)
		owner.special_role = "Wretch"
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			H.wretch_territory_buff = TRUE

/datum/antagonist/wretch/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			H.wretch_territory_buff = FALSE
