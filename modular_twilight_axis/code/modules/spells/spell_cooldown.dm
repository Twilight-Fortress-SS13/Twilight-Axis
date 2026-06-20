/datum/action/cooldown/spell/can_cast_spell(feedback = TRUE)
	if(!owner)
		CRASH("[type] - can_cast_spell called on a spell without an owner!")
////////////////////////////////////////
	if(!iscarbon(owner) && !istype(owner, /mob/living/simple_animal/pet/familiar)) //TA changes
		return FALSE
////////////////////////////////////////
	if(!(spell_flags & SPELL_IGNORE_SPELLBLOCK) && (HAS_TRAIT(owner, TRAIT_SPELLBLOCK) || HAS_TRAIT(owner, TRAIT_SPELLCOCKBLOCK)))
		if(feedback)
			owner.balloon_alert(owner, "Can't focus on casting...")
		return FALSE

	if(HAS_TRAIT(owner, TRAIT_NOC_CURSE))
		if(feedback)
			owner.balloon_alert(owner, "My magicka has left me...")
		return FALSE

	for(var/datum/action/cooldown/spell/spell in owner.actions)
		if(spell == src)
			continue
		if(spell.currently_charging)
			if(feedback)
				owner.balloon_alert(owner, "Already channeling!")
			return FALSE

	if(!check_cost(feedback = feedback))
		return FALSE

	// Certain spells are not allowed on the centcom zlevel
	var/turf/caster_turf = get_turf(owner)
	if((spell_requirements & SPELL_REQUIRES_STATION) && is_centcom_level(caster_turf.z))
		if(feedback)
			owner.balloon_alert(owner, "Cannot cast here!")
		return FALSE

	if((spell_requirements & SPELL_REQUIRES_MIND) && !owner.mind)
		// No point in feedback here, as mindless mobs aren't players
		return FALSE

	// If the spell requires the user has no antimagic equipped, and they're holding antimagic
	// that corresponds with the spell's antimagic, then they can't actually cast the spell
	if((spell_requirements & SPELL_REQUIRES_NO_ANTIMAGIC) && owner.anti_magic_check())
		if(feedback)
			owner.balloon_alert(owner, "Antimagic is preventing casting!")
		return FALSE

	if(!can_invoke(feedback = feedback))
		return FALSE

	if(!ishuman(owner))
		if(spell_requirements & (SPELL_REQUIRES_HUMAN))
			if(feedback)
				owner.balloon_alert(owner, "Can only be cast by humans!")
			return FALSE

	if(LAZYLEN(required_items))
		var/found = FALSE
		for(var/obj/item/I in owner.contents)
			if(is_type_in_list(I, required_items))
				found = TRUE
				break
		if(!found && feedback)
			owner.balloon_alert(owner, "Missing something to cast!")
			return FALSE

	return TRUE
