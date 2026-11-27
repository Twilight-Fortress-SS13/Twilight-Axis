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
	H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)
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
	grant_poke_spell_devotee(H)

// Grants T1 spell of any patron
/proc/grant_poke_spell_devotee(mob/living/carbon/human/user)
	var/list/poke_options = list("Eoran Bud", "Divine Strike", "Locate Dead", "Malum Forge", "Beast Tame", "Enlightenment", "Sacred Flame", "Twined Gaze", "Vicious Mockery", "Vicious Mockery", "Abyssor Bends", "Infestation", "Baothan Blessing", "Heavy Stomp", "Equalize", "Profane Bone", "Absolve")
	var/poke_choice = tgui_input_list(user, "Choose your devotee blessing.", "Devotee Progress", poke_options)
	if(!poke_choice || !user.mind)
		return
	switch(poke_choice)
		if("Eoran Bud")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bud)
		if("Divine Strike")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/TAdivine_strike)
		if("Locate Dead")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/locate_dead)
		if("Divine Forge")
			user.mind.AddSpell(new /datum/action/cooldown/spell/arcyne_forge/miracle)
		if("Beast Tame")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/beasttame)
		if("Enlightenment")
			user.mind.AddSpell(new /datum/action/cooldown/spell/noc/TAenlightenment)
		if("Sacred Flame")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/TAsacred_flame)
		if("Twined Gaze")
			user.mind.AddSpell(new /datum/action/cooldown/spell/undivided/twinned_gaze)
		if("Vicious Mockery")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
		if("Abyssor Bends")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/abyssor_bends)
		if("Infestation")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/infestation)
		if("Baothan Blessing")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/TAbaothablessings)
		if("Heavy Stomp")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/heavy_stomp)
		if("Equalize")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/twilight_equalize)
		if("Profane Bone")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/zizo/profane)
		if("Absolve")
			user.mind.AddSpell(new /datum/action/cooldown/spell/psydon/lux/absolve)
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
	grant_poke_spell(H)
	return

/datum/hag_boon/buff/skeleton
	name = "Skeleton Form"
	desc = "Bearer becomes a Skeleton, nothing else."
	points = 85
	status_type = /datum/status_effect/buff/hag_boon/skeleton_form

/datum/status_effect/buff/hag_boon/skeleton_form/on_apply()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.become_skeleton()
	H.select_skeleton_features()
	return

/datum/hag_boon/rejuvenate // ok, this isn't actually a status effect. but it belongs here more than any of the other files
	name = "Wyrd Rejuvenation"
	desc = "Cures all long-term physical ailments, including: blindness, ugliness, oldness, asundered mind, missing limbs, and leprosy. Does not heal immediate wounds such as fractures and bleeds, and will not fix divine curses such as lux-taint, silver-weakness, vampirisim, or lycanthropy."
	points = 30
	var/cured_asundered_mind = FALSE

/// notably we do not actually apply any woundheal or thelike here; as a hag, you have very high medskill, use that if you want someone alyve, this is for curing permanent disabilities
/datum/hag_boon/rejuvenate/apply_boon_effect(mob/living/L)
	if(!ishuman(L))
		return // we. only want this to apply to humans. ok
	var/mob/living/carbon/human/H = L
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

	// first, cure blindness, and cache other curable flaws for later
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
			if(!head) // something bizarre has happened
				continue
			head.remove_wound(/datum/wound/facial/eyes/left/permanent)
			H.update_fov_angles()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/noeyer))
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
			if(!head) // something bizarre has happened
				continue
			head.remove_wound(/datum/wound/facial/eyes/right/permanent)
			H.update_fov_angles()
			blindness_flaws += cf
		if(istype(cf, /datum/charflaw/colorblind))
			H.remove_client_colour(/datum/client_colour/monochrome)
			blindness_flaws += cf
			cured_blindness = TRUE
		if(istype(cf, /datum/charflaw/leprosy))
			leper = cf
	if(length(blindness_flaws))
		cured_blindness = TRUE
		to_chat(H, span_smallgreen("Light floods my senses as my sight is restored!"))
		for(var/datum/charflaw/cf in blindness_flaws)
			cfs += cf.type
			H.charflaws.Remove(cf)
			qdel(cf)
	if(leper)
		cured_leper = TRUE
		cfs += leper.type
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
	if(H.age == AGE_MIDDLEAGED)
		H.change_stat(STATKEY_SPD, 1)
		to_chat(H, span_warning("You can feel your body becoming as fast and dextrous as it was in your youth!"))
	else if(H.age == AGE_OLD)
		H.change_stat(STATKEY_STR, 1)
		H.change_stat(STATKEY_SPD, 2)
		H.change_stat(STATKEY_PER, 1)
		H.change_stat(STATKEY_CON, 2)
	var/list/regenerable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_TAUR)
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.is_prosthetic_limb())
			BP.dismember(skip_checks = TRUE)
	var/missing_limbs = H.get_missing_limbs()
	for(var/limb_zone in missing_limbs)
		if(limb_zone in regenerable_zones)
			restored_limbs += limb_zone
			H.regenerate_limb(limb_zone)
			H.visible_message(span_warning("[H]'s [parse_zone(limb_zone)] rapidly regrows!"), span_smallgreen("I feel a terrible itching sensation as my [limb_zone] regrows!"))
	if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
		REMOVE_TRAIT(H, TRAIT_UNSEEMLY, null)
		cured_ugly = TRUE
		to_chat(H, span_smallgreen("My posture straigtens, my face is mended; my disfigurement is lifted!"))
	if(HAS_TRAIT(H, TRAIT_PSYCHOSIS))
		REMOVE_TRAIT(H, TRAIT_PSYCHOSIS, null)
		H.hallucination = 0
		cured_asundered_mind = TRUE
		to_chat(H, span_smallgreen("My mind calms down, everything is calm again..."))
	clean_body_parts(H)
	return

// oh you poor soul
/datum/hag_boon/rejuvenate/remove_boon_effect(mob/living/L)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	if(cured_blindness)
		to_chat(H, span_danger("My vision falters once more, my borrowed sight fading to naught!"))
	if(cured_leper)
		to_chat(H, span_danger("My affliction returns in full force, as if it had never left!"))
		H.adjust_triumphs(-3) // we reapply the charflaw which gives 3 triumphs - don't want to farm this
	if(cured_ugly)
		ADD_TRAIT(H, TRAIT_UNSEEMLY, TRAIT_HAG_BOON)
		to_chat(H, span_danger("My disfigurement returns, my visage is horrific once more."))
	if(cured_asundered_mind)
		ADD_TRAIT(H, TRAIT_PSYCHOSIS, TRAIT_HAG_BOON)
		to_chat(H, span_danger("Voices in my head returns, my mind is filled with friends once more."))
	if(length(restored_limbs))
		for(var/limb_zone in restored_limbs)
			var/obj/item/bodypart/BP = H.get_bodypart(limb_zone)
			if(!BP.is_prosthetic_limb()) // to avoid the edge case of someone getting blessed with this, then losing the limb AGAIN and getting a prosthetic, THEN being cursed
				BP.dismember(skip_checks = TRUE)
				H.visible_message(span_danger("[H]'s [BP] rapidly wilts away!"))
				QDEL_NULL(BP)
	for(var/path in cfs)
		if(ispath(path, /datum/charflaw))
			var/datum/charflaw/cf = new path
			H.charflaws += cf
			cf.on_mob_creation(H)
			cf.apply_post_equipment(H)
	return

/datum/hag_boon/buff/gold_bless
	name = "Gold Bless"
	desc = "The bearer, when getting damage, will summon coins under him."
	points = 60
	status_type = /datum/status_effect/buff/hag_boon/gold_bless

/datum/status_effect/buff/hag_boon/gold_bless
	id = "gold_bless"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/buff/hag_boon/gold_bless

/atom/movable/screen/alert/status_effect/buff/hag_boon/gold_bless
	name = "Gold Bless"
	desc = "I will return all attacks to coins!"
	icon_state = "buff"

/datum/status_effect/buff/hag_boon/gold_bless/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damage))

/datum/status_effect/buff/hag_boon/gold_bless/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)

/datum/status_effect/buff/hag_boon/gold_bless/proc/on_damage(datum/source, damage, damagetype)
	SIGNAL_HANDLER
	if(owner.stat != CONSCIOUS)
		return FALSE
	if(damage > 0)
		var/total_value = (damage * 0.4)
		budget2change(total_value, owner, putinhands = FALSE, custom_turf = owner.loc)
		return TRUE
