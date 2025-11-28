/datum/reagent/consumable/ethanol/beer/emberwine
	name = "Emberwine"
	boozepwr = 10
	taste_description = "searing sweetness"
	taste_mult = 0.5
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.02 * REAGENTS_METABOLISM
	overdose_threshold = 16
	addiction_threshold = 24 //Five sips, or a full goblet (and then some, because it metabolizes while you're drinking)
	var/addiction_permanent = TRUE
	color = "#721a46"

/datum/reagent/consumable/ethanol/beer/emberwine/on_mob_metabolize(mob/living/carbon/human/C)
	..()
	var/datum/component/arousal/arc = C.GetComponent(/datum/component/arousal)
	if(arc)
		arc.aphrodisiac++

/datum/reagent/consumable/ethanol/beer/emberwine/on_mob_end_metabolize(mob/living/carbon/human/C)
	var/datum/component/arousal/arc = C.GetComponent(/datum/component/arousal)
	if(arc)
		arc.aphrodisiac--
	..()

/datum/reagent/consumable/ethanol/beer/emberwine/on_mob_life(mob/living/carbon/human/C)
	var/high_message = pick("Your stomach feels hot.", "Your skin feels prickly to the touch.", "Your loins throb involuntarily.", "Your heart beats irregularly.", "You feel cold sweat running down your neck.")
	switch(current_cycle)
		if(0 to 19)
			current_cycle++
			return //Dormant
		if(20)
			to_chat(C, "<span class='aphrodisiac'>You feel a warm glow spreading through your stomach.</span>")
		if(21 to 25)
			var/list/arousal_data = list()
			SEND_SIGNAL(C, COMSIG_SEX_GET_AROUSAL, arousal_data)
			if(arousal_data["arousal"] < 50)
				SEND_SIGNAL(C, COMSIG_SEX_ADJUST_AROUSAL, 3)
		if(26 to INFINITY)
			C.apply_status_effect(/datum/status_effect/debuff/emberwine)
			SEND_SIGNAL(C, COMSIG_SEX_FREEZE_AROUSAL, FALSE)
			var/list/arousal_data = list()
			SEND_SIGNAL(C, COMSIG_SEX_GET_AROUSAL, arousal_data)
			if(arousal_data["arousal"] < 50)
				SEND_SIGNAL(C, COMSIG_SEX_SET_AROUSAL, 50)
			if(prob(8))
				C.emote("sexmoanlight", forced = TRUE)
				to_chat(C, "<span class='love_high'>[high_message]</span>")
	return ..()

/datum/reagent/consumable/ethanol/beer/emberwine/overdose_start(mob/living/carbon/human/C)
	if(current_cycle < 20)
		current_cycle = 20
		to_chat(C, "<span class='aphrodisiac'>You feel a warm glow spreading through your stomach.</span>")
		stoplag(10)
	to_chat(C, "<span class='aphrodisiac'>The glow in your stomach spreads, rushing to your head and warming your face.</span>")
	metabolization_rate = 0.1 * REAGENTS_METABOLISM //Purges faster while overdosing because this is really debilitating
	C.emote("sexmoanhvy", forced = TRUE)
	var/datum/component/arousal/arc = C.GetComponent(/datum/component/arousal)
	if(arc)
		arc.aphrodisiac++

/datum/reagent/consumable/ethanol/beer/emberwine/overdose_process(mob/living/carbon/human/C)
	if(prob(5))
		C.emote("sexmoanhvy", forced = TRUE)

/datum/reagent/consumable/ethanol/beer/emberwine/addiction_act_stage3(mob/living/carbon/human/C)
	if(prob(20))
		to_chat(C, span_danger("I have an intense craving for [name]."))
		var/list/arousal_data = list()
		SEND_SIGNAL(C, COMSIG_SEX_GET_AROUSAL, arousal_data)
		if(arousal_data["arousal"] < 50)
			SEND_SIGNAL(C, COMSIG_SEX_ADJUST_AROUSAL, 3)
	if(istype(C, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = C
		if(!istype(H.charflaw, /datum/charflaw/addiction/lovefiend))
			H.charflaw = new /datum/charflaw/addiction/lovefiend(H)
	return

/datum/reagent/consumable/ethanol/beer/emberwine/addiction_act_stage4(mob/living/carbon/human/C)
	SEND_SIGNAL(C, COMSIG_SEX_FREEZE_AROUSAL, TRUE)
	SEND_SIGNAL(C, COMSIG_SEX_SET_AROUSAL, 40)
	var/datum/component/arousal/arc = C.GetComponent(/datum/component/arousal)
	if(arc && arc.aphrodisiac < 1.5)
		arc.aphrodisiac = 1.5
	if(prob(10))
		to_chat(C, span_boldannounce("The feeling in your loins has subsided to a dull ache. Only more [name] would scratch the itch..."))
	return
