/datum/hag_boon/buff/bard_initiate
	name = "Bard Initiate"
	desc = "The bearer becomes a bard, and also gets a musical instrument!"
	points = 50
	status_type = /datum/status_effect/buff/hag_boon/bard_initiate

/datum/status_effect/buff/hag_boon/bard_initiate
	id = "bard_initiate"
	duration = 1 SECONDS

/datum/status_effect/buff/hag_boon/bard_initiate/on_apply()
	var/mob/living/carbon/human/H = owner
	H.adjust_skillrank_up_to(/datum/skill/misc/music, SKILL_LEVEL_EXPERT, TRUE)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	if(H.mind)
		var/instruments = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute", "Drum", "Shamisen")
		var/instrument_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", instruments)
		var/obj/item/rogue/instrument/instrument
		switch(instrument_choice)
			if("Harp")
				instrument = /obj/item/rogue/instrument/harp
			if("Lute")
				instrument = /obj/item/rogue/instrument/lute
			if("Accordion")
				instrument = /obj/item/rogue/instrument/accord
			if("Guitar")
				instrument = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				instrument = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				instrument = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				instrument = /obj/item/rogue/instrument/vocals
			if("Psyaltery")
				instrument = /obj/item/rogue/instrument/psyaltery
			if("Flute")
				instrument = /obj/item/rogue/instrument/flute
			if("Drum")
				instrument = /obj/item/rogue/instrument/drum
			if("Shamisen")
				instrument = /obj/item/rogue/instrument/shamisen

		new instrument(H.loc)

/datum/hag_boon/buff/devotee
	name = "Devotee"
	desc = "Bearer gain the miracles of their god, but if they already has it, their devotee regeneration will be increased."
	points = 60
	status_type = /datum/status_effect/buff/hag_boon/devotee

/datum/status_effect/buff/hag_boon/devotee
	id = "Devotee"
	duration = 1 SECONDS

/datum/status_effect/buff/hag_boon/devotee/on_apply()
	var/mob/living/carbon/human/H = owner
	H.adjust_skillrank_up_to(/datum/skill/magic/holy, 4, TRUE)
	if(!H.devotion)
		var/datum/devotion/new_faith = new /datum/devotion(H, H.patron)
		new_faith.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = (CLERIC_REQ_1))
	else if(H.devotion.level < CLERIC_T1)
		var/datum/devotion/our_faith = H.devotion
		our_faith.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = (CLERIC_REQ_1))
	else if(H.devotion.level >= CLERIC_T1)
		var/datum/devotion/our_faith = H.devotion
		our_faith.passive_devotion_gain += CLERIC_REGEN_MINOR
		START_PROCESSING(SSobj, our_faith)
	return

/datum/hag_boon/buff/arcyne_affinity
	name = "Arcyne Affinity"
	desc = "Bearer gain the arcyne potencial and learn some spells!"
	points = 60
	status_type = /datum/status_effect/buff/hag_boon/arcyne_affinity

/datum/status_effect/buff/hag_boon/arcyne_affinity
	id = "Arcyne Affinity"
	duration = 1 SECONDS

/datum/status_effect/buff/hag_boon/arcyne_affinity/on_apply()
	var/mob/living/carbon/human/H = owner
	if (!H.get_skill_level(/datum/skill/magic/arcane))
		if (!H.mind?.has_spell(/datum/action/cooldown/spell/touch/prestidigitation))
			H.mind?.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
			ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
			if(!LAZYLEN(H.mind.mage_aspect_config))
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 8), grant_attunement = FALSE)
			H.mind.check_learnspell()
	else
		H.mind.mage_aspect_config["minor"] += 2
		H.mind.mage_aspect_config["utilities"] += 8
		H.mind.check_learnspell()
	H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 4, TRUE)
	return

/datum/hag_boon/buff/skeleton
	name = "Skeleton Form"
	desc = "Bearer becomes a Skeleton, nothing else."
	points = 85

/datum/hag_boon/buff/skeleton/apply_boon_effect(mob/living/L)
	var/mob/living/carbon/human/H = L
	H.become_skeleton()
	H.select_skeleton_features()
	return

/datum/hag_boon/buff/rejuvenate
	name = "Wyrd's Rejuvenation"
	desc = "Cures all long-term physical ailments, including: blindness, ugliness, missing limbs, and leprosy. Does not heal immediate wounds such as fractures and bleeds, and will not fix divine curses such as lux-taint, silver-weakness, vampirisim, or lycanthropy."
	points = 50
	status_type = /datum/status_effect/buff/hag_boon/wyrd_rejuv

/datum/status_effect/buff/hag_boon/wyrd_rejuv
	id = "wyrd_rejuv"
	duration = 1 SECONDS

/datum/status_effect/buff/hag_boon/wyrd_rejuv/on_apply()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.visible_message(span_warning("[H] stands, wreathed in a strange energy as [H.p_their()] body restores itself!"), span_green("I feel the burdens of the flesh lift from me!"))
	H.SetUnconscious(0) // this is all copied from the surge spell. it's just for aura, and shouldn't have any real effect
	H.SetSleeping(0)
	H.SetParalyzed(0)
	H.SetImmobilized(0)
	H.SetStun(0)
	H.SetKnockdown(0)
	if(H.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		H.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	H.stam_paralyzed = FALSE
	H.set_resting(FALSE)
	H.rest_locked_until = world.time + 1 SECONDS

	var/list/blindness_flaws = list()
	var/datum/charflaw/leprosy/leper
	for(var/datum/charflaw/cf in H.charflaws)
		if(istype(cf, /datum/charflaw/noeyeall))
			H.clear_fullscreen("blind_flaw")
			REMOVE_TRAIT(H, TRAIT_NITEVISION, TRAIT_GENERIC)
			H.update_sight()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/noeyel))
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head && H.dna?.species && istype(H.dna.species, /datum/species/dullahan))
				var/datum/species/dullahan/rev = H.dna.species
				if(rev.headless) // that'd explain it. attach their head before we proceed
					rev.my_head.attach_limb(H)
					H.update_a_intents()
					var/obj/item/organ/dullahan_vision/vision = H.getorganslot(ORGAN_SLOT_HUD)
					vision.viewing_head = FALSE
					H.reset_perspective()
					head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head)
				continue
			head.remove_wound(/datum/wound/facial/eyes/left/permanent)
			H.update_fov_angles()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/noeyer))
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head && H.dna?.species && istype(H.dna.species, /datum/species/dullahan))
				var/datum/species/dullahan/rev = H.dna.species
				if(rev.headless)
					rev.my_head.attach_limb(H)
					H.update_a_intents()
					var/obj/item/organ/dullahan_vision/vision = H.getorganslot(ORGAN_SLOT_HUD)
					vision.viewing_head = FALSE
					H.reset_perspective()
					head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head)
				continue
			head.remove_wound(/datum/wound/facial/eyes/right/permanent)
			H.update_fov_angles()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/colorblind))
			H.remove_client_colour(/datum/client_colour/monochrome)
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/leprosy))
			leper = cf
	if(length(blindness_flaws))
		to_chat(H, span_smallgreen("Light floods my senses as my sight is restored!"))
		for(var/datum/charflaw/cf in blindness_flaws)
			H.charflaws.Remove(cf)
			qdel(cf)
	if(leper)
		REMOVE_TRAIT(H, TRAIT_LEPROSY, TRAIT_GENERIC)
		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.change_stat(STATKEY_CON, 1)
		H.change_stat(STATKEY_WIL, 1)
		H.change_stat(STATKEY_SPD, 1)
		H.change_stat(STATKEY_LCK, 1)
		to_chat(H, span_smallgreen("My constitution bolsters as my illness vanishes!"))
		H.charflaws.Remove(leper)
		QDEL_NULL(leper)
	var/list/regenerable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_TAUR)
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.is_prosthetic_limb())
			BP.dismember(skip_checks = TRUE)
	var/missing_limbs = H.get_missing_limbs()
	for(var/limb_zone in missing_limbs)
		if(limb_zone in regenerable_zones)
			H.regenerate_limb(limb_zone)
			H.visible_message(span_warning("[H]'s [limb_zone] rapidly regrows!"), span_smallgreen("I feel a terrible itching sensation as my [limb_zone] regrows!"))
	if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
		REMOVE_TRAIT(H, TRAIT_UNSEEMLY, null)
		to_chat(H, span_smallgreen("My posture straigtens, my face is mended; my disfigurement is lifted!"))
	clean_body_parts(H)
	return
