/mob/living/carbon/human/proc/become_skeleton()
	// Revenant's on_species_loss and on_head_destroyed both call death() — and the
	// dullahan head's drop_limb assumes the owner is still dullahan, so it runtimes
	// after a species swap. Replace the head with a vanilla one first under GODMODE,
	// then swap species.
	var/had_godmode = (status_flags & GODMODE)
	status_flags |= GODMODE
	if(isdullahan(src))
		var/obj/item/bodypart/head/old_head = get_bodypart(BODY_ZONE_HEAD)
		if(old_head)
			var/obj/item/bodypart/head/new_head = new /obj/item/bodypart/head()
			new_head.replace_limb(src, TRUE)
			qdel(old_head)
	set_species(/datum/species/human/northern)
	if(!had_godmode)
		status_flags &= ~GODMODE

	for(var/datum/charflaw/cf in charflaws)
		charflaws.Remove(cf)
		QDEL_NULL(cf)
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	mob_biotypes = MOB_UNDEAD
	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(src)
	for(var/obj/item/bodypart/B in bodyparts)
		B.skeletonize(FALSE)
	src.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	update_a_intents()

	update_body()
	update_hair()
	update_body_parts(redraw = TRUE)

	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DEATHLESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NO_VOICEPACK_OVERRIDE, TRAIT_GENERIC) //No sexy moaning skeletons W/Dainty.
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_FACELESS_KNOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOWW, TRAIT_GENERIC) // you're a SKELETON

	// Skeleton voicepack
	if(dna?.species)
		dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/skeleton]
		dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/skeleton]

	// Undead language
	grant_language(/datum/language/undead)


	// Offer to clear flavor text / OOC notes since they likely don't match a skeleton
	if(flavortext || ooc_notes)
		var/clear_choice = alert(src, "Your character is now a skeleton. Would you like to clear your flavor text and OOC notes?", "Skeleton Transformation", "Clear Both", "Keep Both")
		if(clear_choice == "Clear Both")
			if(flavortext)
				flavortext = null
				flavortext_cached = ""
			if(ooc_notes)
				ooc_notes = null
				ooc_notes_cached = ""

// TA ADDITION START - T3 Miracle Rituos can be used to become a real skeleton.
/mob/living/carbon/human/proc/become_skeleton_zizo()
	to_chat(src, span_warning("You decide to become true undead!"))
	if(isdullahan(src))
		var/obj/item/bodypart/head/old_head = get_bodypart(BODY_ZONE_HEAD)
		if(old_head)
			var/obj/item/bodypart/head/new_head = new /obj/item/bodypart/head()
			new_head.replace_limb(src, TRUE)
			qdel(old_head)
	// set_species(/datum/species/human/northern)
	/*
	for(var/datum/charflaw/cf in charflaws)
		charflaws.Remove(cf)
		QDEL_NULL(cf)
	*/
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	mob_biotypes = MOB_UNDEAD
	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(src)
	for(var/obj/item/bodypart/B in bodyparts)
		B.skeletonize(FALSE)
		new /obj/effect/temp_visual/zizorite(get_turf(src))
		playsound(loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
	src.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	update_a_intents()

	update_body()
	update_hair()
	update_body_parts(redraw = TRUE)

	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DEATHLESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NO_VOICEPACK_OVERRIDE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_FACELESS_KNOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOWW, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SHATTER_KILL, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SKELETAL_GIB_ON_DEATH, TRAIT_GENERIC) // You only get one chance!
	ADD_TRAIT(src, TRAIT_WARLOCK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_UNLYCKERABLE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)

	// Skeleton voicepack
	if(dna?.species)
		dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/skeleton]
		dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/skeleton]

	// Undead language
	grant_language(/datum/language/undead)

	// Offer to clear flavor text / OOC notes since they likely don't match a skeleton
	if(flavortext || ooc_notes)
		var/clear_choice = alert(src, "Your character is now a skeleton. Would you like to clear your flavor text and OOC notes?", "Skeleton Transformation", "Clear Both", "Keep Both")
		if(clear_choice == "Clear Both")
			if(flavortext)
				flavortext = null
				flavortext_cached = ""
			if(ooc_notes)
				ooc_notes = null
				ooc_notes_cached = ""

	select_skeleton_features()
	energy = max_energy
	adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
	if(mind)
		mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
		mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
		mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
		mind.add_antag_datum(new /datum/antagonist/skeleton())
		mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
		grant_poke_spell_zizo(src)

	visible_message(
		span_boldwarning("[src]'s flesh burns away in necrotic flames, revealing bone beneath as they are consumed by the Lesser Work!"),
		span_notice("THE LESSER WORK IS DONE! My flesh is forfeit - and death itself answers my call!")
	)

	to_chat(src, span_purple("You have performed the Rituos to perfection. You should be a full-fledged Lich by now... and yet..."))
	sleep(30)
	to_chat(src, "<i>...Vestiges of mortality still cling to me...? Why?</i>")

// TA ADDITION END - T3 Miracle Rituos can be used to become a real skeleton.
