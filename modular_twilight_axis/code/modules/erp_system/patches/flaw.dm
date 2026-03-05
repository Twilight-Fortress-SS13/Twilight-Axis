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

	var/oldsated = sated
	var/now_sated = (Aro.satisfaction_points >= ERP_NYMPHO_SATED_SP)
	if(oldsated != now_sated)
		sated = now_sated
		unsate_time = world.time
		if(!sated)
			var/hard = (Aro.satisfaction_points < ERP_NYMPHO_HARD_HUNGER_SP)
			to_chat(H, hard ? span_boldred("I don't indulge my vice.") : span_boldwarning(needsate_text))
		else
			if(sated_text)
				to_chat(H, span_blue(sated_text))
			H.remove_stress(/datum/stressevent/vice)
			if(debuff)
				H.remove_status_effect(debuff)

	if(!sated)
		H.add_stress(/datum/stressevent/vice)
		if(debuff)
			H.apply_status_effect(debuff)
