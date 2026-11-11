// Round-local state. Account PQ gates the estate choice but is not spent.
/datum/mind
	var/ta_nobility_tier = null
	var/ta_nobility_pending = FALSE
	var/ta_nobility_setup_running = FALSE
	var/ta_nobility_title_id
	var/ta_nobility_title_pending = FALSE
	var/ta_nobility_title_resume = FALSE
	var/ta_nobility_prefix
	var/ta_nobility_origin_type
	var/ta_nobility_virtue_picks = 0

GLOBAL_LIST_INIT(ta_nobility_estate_names, list( \
	"Нет надела", \
	"Малый", \
	"Богатый", \
	"Великий", \
))
GLOBAL_LIST_INIT(ta_nobility_pq_requirements, list(0, 0, 25, 50))

/mob/living/carbon/human/proc/taOnNobilityLogin()
	SIGNAL_HANDLER
	if(mind?.ta_nobility_pending || mind?.ta_nobility_title_resume)
		INVOKE_ASYNC(src, PROC_REF(taResumeNobility))

/mob/living/carbon/human/proc/taResumeNobility()
	if(!client || mind?.current != src)
		return
	if(mind.ta_nobility_pending)
		taFinishNobility()
	else if(mind.ta_nobility_title_resume)
		taFinishNobilityTitle(TRUE)

// Preserve an interactive choice before its delayed callback can lose a client.
/mob/living/carbon/human/proc/taQueueNobilityTitle(request_choice)
	if(!mind)
		return
	if(request_choice && !mind.ta_nobility_title_id)
		mind.ta_nobility_title_resume = TRUE
	addtimer(CALLBACK(src, PROC_REF(taFinishNobilityTitle)), 1)

/mob/living/carbon/human/proc/taRoleNobilityTier()
	var/role = mind?.assigned_role
	if(advjob == "Knight Banneret" || (role in GLOB.noble_positions) \
		|| (role in list(
		"Hand",
		"Marshal",
		"Steward",
		"Vizier",
	)))
		return 3
	if(role in list(
		"Councillor",
		"Court Magician",
		"Knight",
		"Royal Knight",
		"Suitor",
		"Sheikh",
		"Cataphract",
		"Slave Master",
	))
		return 2
	return null

/mob/living/carbon/human/proc/taNobilityTier()
	if(!isnull(mind?.ta_nobility_tier))
		return mind.ta_nobility_tier
	var/role_tier = taRoleNobilityTier()
	if(!isnull(role_tier))
		return role_tier
	return taNobilityDefaultTier()

/mob/living/carbon/human/proc/taNobilityDefaultTier()
	if(
		HAS_TRAIT(src, TRAIT_NOBLE_UNLANDED) \
		|| HAS_TRAIT(src, TRAIT_OUTLAW) \
		|| !check_manor_pref
	)
		return 0
	var/datum/advclass/subclass = get_advclass_datum()
	return isnull(
		subclass?.ta_wandering_nobility_tier
	) ? 1 : subclass.ta_wandering_nobility_tier

/// Lifestyle effects apply only to nobles whose round-start package has been
// resolved.
/mob/living/carbon/human/proc/taAppliedNobilityTier()
	if(
		!HAS_TRAIT(src, TRAIT_NOBLE) \
		|| mind?.ta_nobility_pending \
		|| isnull(mind?.ta_nobility_tier)
	)
		return -1
	return mind.ta_nobility_tier

/mob/living/carbon/human/proc/taIsCityNoble()
	var/role = mind?.assigned_role
	if(!isnull(taRoleNobilityTier()))
		return TRUE
	return (role in GLOB.noble_positions) \
		|| (role in GLOB.courtier_positions) \
		|| (role in GLOB.retinue_positions) \
		|| (role in GLOB.garrison_positions) \
		|| (role in GLOB.citywatch_positions) \
		|| (role in GLOB.vanguard_positions) \
		|| (role in GLOB.burgher_positions) \
		|| (role in GLOB.atc_positions) \
		|| (role in GLOB.peasant_positions) \
		|| (role in GLOB.church_positions) \
		|| (role in GLOB.inquisition_positions)

/mob/living/carbon/human/proc/taNobilityCulture()
	var/origin_type = mind?.ta_nobility_origin_type
	if(!origin_type)
		var/datum/virtue/origin/origin = client?.prefs?.virtue_origin
		origin_type = origin?.type
	switch(origin_type)
		if(/datum/virtue/origin/enigma)
			return "enigma"
		if(/datum/virtue/origin/grenzelhoft)
			return "grenzelhoft"
		if(/datum/virtue/origin/valorian)
			return "valoria"
		if(/datum/virtue/origin/heartfelt)
			return "heartfelt"
		if(/datum/virtue/origin/etrusca)
			return "etrusca"
		if(/datum/virtue/origin/otava)
			return "otava"
		if(/datum/virtue/origin/gronn)
			return "gronn"
		if(/datum/virtue/origin/hammerhold)
			return "hammerhold"
		if(/datum/virtue/origin/avar)
			return "aavnr"
		if(/datum/virtue/origin/raneshen)
			return "raneshen"
		if(/datum/virtue/origin/naledi)
			return "naledi"
		if(
			/datum/virtue/origin/zybantian,
			/datum/virtue/origin/racial/crimson_lands
		)
			return "zybantu"
		if(/datum/virtue/origin/kazengun)
			return "kazengun"
		if(/datum/virtue/origin/lingyue)
			return "jeoseon"
		if(/datum/virtue/origin/gyedzenese)
			return "gyedzai"
	return "azuria"

/mob/living/carbon/human/proc/taFixedNobilityTitle()
	if(!taIsCityNoble())
		return null
	var/role = mind?.assigned_role
	var/id
	switch(role)
		if("Grand Duke")
			id = SSmapping.config.map_name == "Rockhill" ? "court/3/King" \
				: "court/3/Grand Duke"
		if("Sultan")
			id = "court/3/Sultan"
		if("Prince")
			id = "court/3/Prince"
		if("Consort")
			id = "court/3/Ducal Consort"
		if("Harem Favorite")
			id = "court/3/Consort"
		if("Hand", "Marshal", "Steward")
			id = "court/3/High Lord"
		if("Vizier")
			id = "court/3/Vizier"
		if("Knight", "Royal Knight")
			id = advjob == "Knight Banneret" ? "court/3/Ser" : "court/2/Ser"
		if("Cataphract")
			id = "court/2/Faris"
		if("Councillor", "Court Magician", "Suitor", "Sheikh", "Slave Master")
			id = "court/2/Lord"
	if(!id)
		switch(taNobilityTier())
			if(0)
				id = "court/0/Ser"
			if(1)
				id = "court/1/Lord"
			if(2)
				id = "court/2/Baron"
			if(3)
				id = "court/3/High Lord"
	return GLOB.ta_noble_titles[id]

/mob/living/carbon/human/proc/taNobilityTitleOptions()
	var/list/options = list()
	var/datum/ta_noble_title/squire_title = taSquireNobilityTitle()
	if(squire_title)
		options[squire_title.id] = squire_title
		return options
	if(
		!HAS_TRAIT(src, TRAIT_NOBLE) \
		|| isnull(mind?.ta_nobility_tier) \
		|| mind.ta_nobility_pending
	)
		return options
	var/datum/ta_noble_title/fixed = taFixedNobilityTitle()
	if(fixed)
		options[fixed.id] = fixed
		return options
	var/culture = taNobilityCulture()
	var/tier = taNobilityTier()
	for(var/id in GLOB.ta_noble_titles)
		var/datum/ta_noble_title/title = GLOB.ta_noble_titles[id]
		if(
			title.culture == culture \
			&& title.tier <= tier \
			&& title.tier >= max(0, tier - 1)
		)
			options[id] = title
	return options

/mob/living/carbon/human/proc/taSelectNobilityTitle(id)
	var/list/options = taNobilityTitleOptions()
	var/datum/ta_noble_title/title = options[id]
	if(!title)
		return FALSE
	mind.ta_nobility_title_id = id
	taApplyNobilityPrefix(title.honorific(titles_pref == TITLES_F))
	return TRUE

/mob/living/carbon/human/proc/taNobilityTitle()
	var/datum/ta_noble_title/squire_title = taSquireNobilityTitle()
	if(squire_title)
		return squire_title
	var/datum/ta_noble_title/fixed = taFixedNobilityTitle()
	if(fixed)
		return fixed
	var/list/options = taNobilityTitleOptions()
	var/datum/ta_noble_title/selected = options[mind?.ta_nobility_title_id]
	if(selected)
		return selected
	for(var/id in options)
		var/datum/ta_noble_title/title = options[id]
		if(title.tier == taNobilityTier())
			return title
	return null

// Called a tick after setup so legacy job after_spawn prefixes cannot stack on
// it.
/mob/living/carbon/human/proc/taFinishNobilityTitle(reselect = FALSE)
	set waitfor = FALSE
	if(!mind || mind.ta_nobility_pending || mind.ta_nobility_title_pending)
		return
	if(mind.ta_nobility_title_resume && !client)
		return
	var/datum/ta_noble_title/squire_title = taSquireNobilityTitle()
	if(
		!squire_title \
		&& (!HAS_TRAIT(src, TRAIT_NOBLE) || isnull(mind.ta_nobility_tier))
	)
		return
	if(
		mind.ta_nobility_title_id \
		&& !reselect \
		&& (!squire_title || mind.ta_nobility_title_id == squire_title.id)
	)
		return
	var/list/options = taNobilityTitleOptions()
	var/datum/ta_noble_title/default_title = taNobilityTitle()
	if(!default_title)
		return
	var/id = default_title.id
	// A hidden or dismissed prompt must never leave the character without a
	// title.
	taSelectNobilityTitle(id)
	if(!taIsCityNoble() && client && length(options) > 1)
		verbs |= /mob/living/carbon/human/proc/taChooseNobleTitle
		mind.ta_nobility_title_pending = TRUE
		mind.ta_nobility_title_resume = TRUE
		var/list/menu = list()
		var/default_label
		for(var/option_id in options)
			var/datum/ta_noble_title/title = options[option_id]
			var/label = "[title.honorific(titles_pref == TITLES_F)] \
			([title.analogue])"
			menu[label] = option_id
			if(option_id == id)
				default_label = label
		var/datum/mind/choosing_mind = mind
		var/client/choosing_client = client
		var/choice = tgui_input_list(
			src,
			"Выберите дворянский титул своей культуры.",
			"Титул",
			menu,
			default_label,
		)
		choosing_mind.ta_nobility_title_pending = FALSE
		if(QDELETED(src) || mind != choosing_mind || mind.current != src)
			return
		// A closed connection is not a deliberate cancellation of the choice.
		if(!client || client != choosing_client)
			if(client)
				addtimer(CALLBACK(src, PROC_REF(taResumeNobility)), 1)
			return
		if(choice && (choice in menu))
			id = menu[choice]
	mind.ta_nobility_title_resume = FALSE
	taSelectNobilityTitle(id)

/mob/living/carbon/human/proc/taChooseNobleTitle()
	set name = "Noble Title"
	set category = "IC"
	if(taIsCityNoble())
		return
	taFinishNobilityTitle(TRUE)

/mob/living/carbon/human/proc/taApplyNobilityPrefix(prefix)
	var/old_name = real_name
	var/base_name = real_name
	var/old_prefix = mind?.ta_nobility_prefix
	if(old_prefix && findtextEx(base_name, "[old_prefix] ") == 1)
		base_name = copytext(base_name, length(old_prefix) + 2)
	else
		// Only strip a known, complete leading honorific, never a substring of
		// a name.
		var/longest = ""
		var/list/prefixes = list(
			"Lord",
			"Lady",
			"Ser",
			"Dame",
			"Duke",
			"Duchess",
			"King",
			"Queen",
			"Amir",
			"Amirah",
			"Mushir",
			"Mushirah",
			"Consort",
		)
		for(var/id in GLOB.ta_noble_titles)
			var/datum/ta_noble_title/title = GLOB.ta_noble_titles[id]
			prefixes |= title.male
			prefixes |= title.female
		for(var/candidate in prefixes)
			if(
				length(candidate) > length(longest) \
				&& findtextEx(base_name, "[candidate] ") == 1
			)
				longest = candidate
		if(length(longest))
			base_name = copytext(base_name, length(longest) + 2)
	var/new_name = "[prefix] [base_name]"
	mind.ta_nobility_prefix = prefix
	if(new_name == old_name)
		return
	fully_replace_character_name(old_name, new_name)
	for(var/datum/mind/observer in SSticker.minds)
		if(observer.known_people?[old_name])
			observer.known_people[new_name] = observer.known_people[old_name]
			observer.known_people -= old_name
	if(GLOB.lord_titles[old_name])
		GLOB.lord_titles[new_name] = GLOB.lord_titles[old_name]
		GLOB.lord_titles -= old_name

/mob/living/carbon/human/proc/taPrepareNobility()
	if(!mind || !isnull(mind.ta_nobility_tier) || mind.ta_nobility_pending)
		return FALSE
	mind.ta_nobility_pending = TRUE
	return TRUE

/mob/living/carbon/human/proc/taNobilityAccountPq()
	return get_playerquality(ckey, FALSE) || 0

/mob/living/carbon/human/proc/taNobilityMaxPurchasedTier()
	var/role = mind?.assigned_role
	if((role in GLOB.noble_positions) || (role in GLOB.courtier_positions) \
		|| (role in GLOB.retinue_positions) || (role in list(
		"Servant",
		"Court Agent",
		"Royal Guard",
		"Royal Guard Sergeant",
	)))
		return 1
	var/datum/advclass/subclass = get_advclass_datum()
	return subclass?.ta_wandering_nobility_max_tier || 3

/mob/living/carbon/human/proc/taNobilityEstateCost(tier)
	if(tier <= 1)
		return 0
	return (tier - 1) * 20 - (mind?.ta_nobility_virtue_picks >= 2 ? 20 : 0)

/mob/living/carbon/human/proc/taNobilityEstateMultiplier()
	if(!mind || isnull(taRoleNobilityTier()))
		return 1
	return 1 + clamp(mind.ta_nobility_virtue_picks, 0, 2) * 0.25

/mob/living/carbon/human/proc/taNobilityEstateChoices()
	var/list/choices = list()
	if(!taNobilityCanChooseLand() || !mind?.ta_nobility_virtue_picks)
		return choices
	for(var/tier in 1 to taNobilityMaxPurchasedTier())
		var/label = GLOB.ta_nobility_estate_names[tier + 1]
		var/cost = taNobilityEstateCost(tier)
		if(cost)
			label += " (-[cost] TRI)"
		choices[label] = tier
	return choices

/mob/living/carbon/human/proc/taNobilityCanChooseLand()
	if(
		!isnull(taRoleNobilityTier()) \
		|| HAS_TRAIT(src, TRAIT_OUTLAW) \
		|| HAS_TRAIT(src, TRAIT_NOBLE_UNLANDED)
	)
		return FALSE
	if(
		mind \
		&& (
			mind.has_antag_datum(/datum/antagonist/skeleton) \
			|| mind.has_antag_datum(/datum/antagonist/lich) \
			|| mind.has_antag_datum(/datum/antagonist/vampire) \
			|| mind.has_antag_datum(/datum/antagonist/vampire/lord)
		)
	)
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/taSelectNobility(tier, role_package = FALSE)
	if(!mind || !mind.ta_nobility_pending || !isnull(mind.ta_nobility_tier))
		return FALSE
	if(!HAS_TRAIT(src, TRAIT_NOBLE) || !(tier in list(1, 2, 3)))
		return FALSE
	var/role_tier = taRoleNobilityTier()
	var/cost = 0
	if(role_package)
		if(isnull(role_tier) || role_tier != tier)
			return FALSE
	else
		if(
			!taNobilityCanChooseLand() \
			|| mind.get_owned_manor() \
			|| !mind.ta_nobility_virtue_picks \
			|| tier > taNobilityMaxPurchasedTier()
		)
			return FALSE
		var/required_pq = GLOB.ta_nobility_pq_requirements[tier + 1]
		if(required_pq && taNobilityAccountPq() < required_pq)
			to_chat(
				src,
				span_warning("Для этого надела нужно [required_pq] PQ.")
			)
			return FALSE
		cost = taNobilityEstateCost(tier)
		if(cost && get_triumphs() < cost)
			to_chat(
				src,
				span_warning("Для этого надела нужно [cost] триумфов.")
			)
			return FALSE
	mind.ta_nobility_tier = tier
	mind.ta_nobility_pending = FALSE
	var/datum/manor_panel/panel = new(src)
	var/datum/manor/estate = panel.create_manor_for_user(src)
	qdel(panel)
	if(!estate && !role_package)
		mind.ta_nobility_tier = null
		mind.ta_nobility_pending = TRUE
		to_chat(src, span_warning("Не удалось оформить этот надел."))
		return FALSE
	if(cost)
		adjust_triumphs(-cost, FALSE, "Nobility estate")
	if(role_package && tier == 3)
		taRecordNobleRoleAttire()
	if(tier == 3)
		ADD_TRAIT(src, TRAIT_WELLKNOWN, "ta_nobility")
		for(var/mob/living/carbon/human/observer in GLOB.player_list)
			if(observer.mind && observer != src)
				mind.person_knows_me(observer.mind)
	check_equipment_mood_penalty()
	return TRUE

/mob/living/carbon/human/proc/taCancelNobilityClaim()
	mind.ta_nobility_pending = FALSE
	REMOVE_TRAIT(src, TRAIT_NOBLE, TRAIT_VIRTUE)
	if(HAS_TRAIT(src, TRAIT_NOBLE))
		taAssignDefaultNobility()

/mob/living/carbon/human/proc/taAssignDefaultNobility()
	mind.ta_nobility_tier = taNobilityDefaultTier()
	var/datum/advclass/subclass = get_advclass_datum()
	if(
		mind.ta_nobility_tier > 0 \
		&& !isnull(subclass?.ta_wandering_nobility_tier)
	)
		var/datum/manor_panel/panel = new(src)
		panel.create_manor_for_user(src)
		qdel(panel)

/mob/living/carbon/human/proc/taFinishNobility()
	set waitfor = FALSE
	if(!mind || mind.ta_nobility_setup_running)
		return
	if(!HAS_TRAIT(src, TRAIT_NOBLE))
		if(taSquireNobilityTitle())
			taQueueNobilityTitle(!!client)
		return
	mind.ta_nobility_setup_running = TRUE
	var/datum/mind/choosing_mind = mind
	var/client/choosing_client = client
	var/role_tier = taRoleNobilityTier()
	if(isnull(mind.ta_nobility_tier))
		if(!isnull(role_tier))
			taPrepareNobility()
			taSelectNobility(role_tier, TRUE)
		else if(!mind.ta_nobility_pending)
			taAssignDefaultNobility()
		else if(!taNobilityCanChooseLand())
			taCancelNobilityClaim()
		else if(client)
			while(
				mind == choosing_mind \
				&& choosing_mind.ta_nobility_pending \
				&& client
			)
				var/list/choices = taNobilityEstateChoices()
				if(!length(choices))
					taCancelNobilityClaim()
					break
				var/choice = tgui_input_list(
					src,
					"Насколько велик и успешен ваш надел?",
					"Надел",
					choices,
				)
				if(
					QDELETED(src) \
					|| mind != choosing_mind \
					|| choosing_mind.current != src
				)
					break
				if(!client || client != choosing_client)
					break
				if(isnull(choice))
					if(client)
						taCancelNobilityClaim()
					break
				if((choice in choices) && taSelectNobility(choices[choice]))
					break
	choosing_mind.ta_nobility_setup_running = FALSE
	if(!QDELETED(src) && mind == choosing_mind && client != choosing_client)
		if(client && mind.ta_nobility_pending)
			addtimer(CALLBACK(src, PROC_REF(taResumeNobility)), 1)
	if(!QDELETED(src) && mind == choosing_mind && !mind.ta_nobility_pending)
		taSyncNobleAppointments()
		taSyncRetinueVerbs()
		if(!isnull(mind.ta_nobility_tier) || taSquireNobilityTitle())
			taQueueNobilityTitle(!!client)

/proc/taHighNobilityText(text = "High Nobility")
	var/result = ""
	var/count = length_char(text)
	for(var/i in 1 to count)
		var/fraction = (i - 1) / max(count - 1, 1)
		var/light = 1 - abs(fraction * 2 - 1)
		var/color = rgb(
			round(190 + 65 * light),
			round(137 + 99 * light),
			round(52 + 144 * light)
		)
		result += "<font color='[color]'>[html_encode(copytext_char(text, i, \
		i + 1))]</font>"
	return "<span style='font-size:140%;font-weight:bold'>[result]</span>"

/proc/taNobilityRealmName()
	return reject_bad_name(SSticker.realm_name) || "Azure Peak"

/mob/living/carbon/human/proc/taRulerExamineText()
	if(SSticker.rulermob != src || !(mind?.assigned_role in list(
		"Grand Duke",
		"Sultan",
	)))
		return null
	var/datum/ta_noble_title/title = taFixedNobilityTitle()
	if(!title)
		return null
	return taHighNobilityText(
		"The ruler of this land, [title.territorial(titles_pref == TITLES_F)] \
		of [taNobilityRealmName()]."
	)

/mob/living/carbon/human/proc/taCourtExamineWording(territorial_title)
	var/realm = taNobilityRealmName()
	switch(mind?.assigned_role)
		if(
			"Grand Duke",
			"Sultan",
			"Prince",
			"Consort",
			"Harem Favorite",
			"Vizier",
			"Cataphract"
		)
			return "[territorial_title] of [realm]"
		if("Hand")
			if(findtext(SSticker.realm_type_short, "Kingdom") == 1)
				return "The King's Hand"
			return "The Duke's Hand"
		if("Marshal")
			return \
				"[titles_pref == TITLES_F ? "Lady" : "Lord"] Marshal of [realm]"
		if("Steward")
			return \
				"[titles_pref == TITLES_F ? "Lady" : "Lord"] Steward of [realm]"
		if("Councillor", "Suitor")
			return "[mind.assigned_role] at the Court of [realm]"
		if("Court Magician", "Sheikh", "Slave Master")
			return "[mind.assigned_role] of [realm]"
		if("Knight", "Royal Knight")
			if(advjob == "Knight Banneret")
				return "[territorial_title] of [realm]"
			return "[mind.assigned_role == "Royal \
				Knight" ? "Royal" : "Ducal"] Knight of [realm]"
	return null

/mob/living/carbon/human/proc/taNobilityExamineText()
	var/ruler_text = taRulerExamineText()
	if(ruler_text)
		return ruler_text
	if(mind?.ta_nobility_pending)
		return null
	var/datum/ta_noble_title/title = taNobilityTitle()
	if(!title)
		return null
	var/territorial_title = title.territorial(titles_pref == TITLES_F)
	if(title.tier == -1 && !mind?.get_owned_manor())
		return span_notice(html_encode(territorial_title))
	var/wording = taCourtExamineWording(territorial_title)
	var/tier = taNobilityTier()
	if(!wording)
		if(tier == 0)
			wording = "Landless [territorial_title]"
		else
			var/datum/manor/estate = mind?.get_owned_manor()
			var/estate_name = reject_bad_name(estate?.manor_name) \
				|| reject_bad_name(client?.prefs?.manor_name) \
				|| "Unnamed Estate"
			wording = "[territorial_title] of [estate_name]"
	if(tier <= 1)
		return "<span \
		style='font-size:85%;color:#c8aa67'>[html_encode(wording)]</span>"
	if(tier == 2)
		return span_notice(html_encode(wording))
	return taHighNobilityText(wording)

// The family-tree system already classifies this office as noble; make the
// trait explicit.
/datum/job/roguetown/magician/New()
	. = ..()
	job_traits = job_traits.Copy()
	job_traits |= TRAIT_NOBLE

/mob/living/carbon/human/proc/taNobleExamineLines(
	possessive,
	include_descriptors
)
	. = list()
	var/ruler_text = taRulerExamineText()
	if(SSticker.rulermob == src)
		. += ruler_text || span_notice("<b>The ruler of this land.</b>")
	else if(GLOB.lord_titles[name])
		. += span_notice( \
			"[possessive] been granted the title of \
			\"[GLOB.lord_titles[name]]\"." \
		)

	if(include_descriptors && !ruler_text)
		if(
			HAS_TRAIT(src, TRAIT_NOBLE) \
			|| HAS_TRAIT(src, TRAIT_DEFILED_NOBLE) \
			|| HAS_TRAIT(src, TRAIT_SQUIRE_REPAIR)
		)
			var/nobility_text = taNobilityExamineText()
			if(nobility_text)
				. += nobility_text

	if(include_descriptors)
		. += taNobleAppointmentExamineText()
