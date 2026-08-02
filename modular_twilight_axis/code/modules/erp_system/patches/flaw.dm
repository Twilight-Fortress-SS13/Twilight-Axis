/datum/charflaw/addiction/lovefiend/flaw_on_life(mob/user)
	if(!ishuman(user))
		return

	if(user.mind?.antag_datums)
		for(var/datum/antagonist/D in user.mind?.antag_datums)
			if(istype(D, /datum/antagonist/vampire/lord) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie) || istype(D, /datum/antagonist/lich))
				return

	var/mob/living/carbon/human/H = user
	var/datum/component/arousal/Aro = H.GetComponent(/datum/component/arousal)
	if(!Aro)
		return ..()

	Aro.sync_lovefiend_sated_from_sp()

	if(!sated)
		H.add_stress(/datum/stressevent/vice)
		if(debuff)
			H.apply_status_effect(debuff)
