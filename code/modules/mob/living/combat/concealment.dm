/mob/living/proc/attempt_concealment(datum/intent/intenty, mob/living/user)
	var/mob/living/H = src
	if(!HAS_TRAIT(H, TRAIT_CONCEALMENT_EXPERT))
		return FALSE
	if(pulledby || pulling)
		return FALSE
	if(world.time < last_dodge + dodgetime)
		if(!istype(rmb_intent, /datum/rmb_intent/riposte))
			return FALSE
	if(has_status_effect(/datum/status_effect/debuff/riposted))
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed) || has_status_effect(/datum/status_effect/debuff/vulnerable))
		return FALSE
	last_dodge = world.time
	if(src.loc == user.loc)
		return FALSE
	if(intenty)
		if(!intenty.candodge)
			return FALSE
	if(HAS_TRAIT(src, TRAIT_NODEF))
		return FALSE
	if(do_concealment(user))
		flash_fullscreen("blackflash2")
		user.aftermiss()
		return TRUE
	else
		return FALSE

/mob/proc/do_concealment(mob/user)
	if(dodgecd)
		return FALSE
	var/mob/living/L = src
	var/mob/living/U = user
	var/mob/living/carbon/human/H
	var/mob/living/carbon/human/UH
	var/obj/item/I
	if(ishuman(src))
		H = src
	if(ishuman(user))
		UH = user
		I = UH.used_intent.masteritem

	var/chance_to_hit = 80

	if(U)
		if(I)
			chance_to_hit += (U.get_skill_level(I.associated_skill) * 8)
			if(I.wlength == WLENGTH_SHORT)
				chance_to_hit += 10
		
		if(U.STAPER > 10)
			chance_to_hit += (min((U.STAPER-10)*8, 40))

		if(U.STAPER < 10)
			chance_to_hit -= ((10-U.STAPER)*10)

		if(istype(U.rmb_intent, /datum/rmb_intent/aimed))
			chance_to_hit += 20
		if(istype(U.rmb_intent, /datum/rmb_intent/swift))
			chance_to_hit -= 20
		
		if(HAS_TRAIT(U, TRAIT_CURSE_RAVOX))
			chance_to_hit -= 40

	if(UH && UH.used_intent)
		if(UH.used_intent.blade_class == BCLASS_STAB)
			chance_to_hit += 10
		if(UH.used_intent.blade_class == BCLASS_PICK)
			chance_to_hit += 20	//Double that of stab
		if(UH.used_intent.blade_class == BCLASS_CUT)
			chance_to_hit += 6
		if(UH.used_intent.blade_class == BCLASS_BLUNT || UH.used_intent.blade_class == BCLASS_SMASH)
			chance_to_hit -= 10
		if(UH.used_intent.accuracy_modifier)
			chance_to_hit += UH.used_intent.accuracy_modifier

	if(U && L)
		chance_to_hit += (U.STAPER - L.STAPER) * 5
	if(H)
		chance_to_hit -= H.get_skill_level(/datum/skill/misc/sneaking) * 8

	chance_to_hit = CLAMP(chance_to_hit, 45, 93)

	if(client?.prefs.showrolls)
		to_chat(src, span_info("Roll for concealment... [100 - chance_to_hit]%"))
	if(prob(chance_to_hit))
		return FALSE
	playsound(src, 'sound/combat/dodge.ogg', 100, FALSE)
	src.visible_message(span_warning("<b>[src]</b> is protected by their concealment!"))
	return TRUE

