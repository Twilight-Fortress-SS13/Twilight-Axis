/datum/unit_test/local_nobility
	var/checks = 0

/datum/unit_test/local_nobility/proc/check(condition, label)
	checks++
	if(!condition)
		Fail(label, __FILE__, __LINE__)

/datum/unit_test/local_nobility/Run()
	var/mob/living/carbon/human/nobility_fixture/viewer = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	viewer.mind_initialize()
	check(
		viewer.taAppliedNobilityTier() == -1,
		"Ordinary characters do not receive noble lifestyle rules"
	)
	var/list/fixture_names = list(
		"Owen Landless",
		"Edmund Small",
		"Roland Wealthy",
		"Reinard Great"
	)
	var/list/sizes = list("none", "small", "medium", "big")
	var/mob/living/carbon/human/nobility_fixture/landless
	for(var/tier = 0 to 3)
		var/mob/living/carbon/human/nobility_fixture/H = allocate(
			/mob/living/carbon/human/nobility_fixture
		)
		H.prepareFixture(fixture_names[tier + 1], tier == 0)
		var/datum/manor_panel/panel = new(H)
		allocated += panel
		check(
			H.mind.ta_nobility_pending == (tier > 0),
			"Only the Nobility virtue queues an estate choice"
		)
		check(
			H.taAppliedNobilityTier() == -1,
			"No lifestyle rules while awaiting a choice"
		)
		check(!H.mind.get_owned_manor(), "No manor before choice")
		check(
			!panel.create_manor_for_user(H),
			"HERMES cannot bypass pending selection"
		)
		check(
			!SStreasury.noble_incomes[H],
			"No legacy additional estate payment"
		)
		var/triumphs_before = H.get_triumphs()
		if(tier > 0)
			check(H.taSelectNobility(tier), "Tier [tier] accepted")
		else
			H.taFinishNobility()
		check(
			H.get_triumphs() == triumphs_before - max(0, (tier - 1) * 20),
			"Tier [tier] charges its one-pick price"
		)
		check(
			H.taAppliedNobilityTier() == tier,
			"Lifestyle follows the applied tier"
		)
		check(!H.mind.ta_nobility_pending, "Choice completed")
		var/datum/manor/M = H.mind.get_owned_manor()
		if(tier == 0)
			landless = H
			check(!M, "Landless has no manor")
			check(
				!panel.create_manor_for_user(H),
				"Landless cannot create manor through HERMES"
			)
		else
			check(
				M && M.manor_size == sizes[tier + 1],
				"Tier [tier] creates correct manor"
			)
			check(
				panel.create_manor_for_user(H) == M,
				"Panel reuses existing manor"
			)
		check(!H.taSelectNobility(tier), "Repeated choice rejected")
		check(
			!H.taPrepareNobility(),
			"Reapplication cannot queue another choice"
		)
		var/label = H.taNobilityExamineText()
		viewer.mind.i_know_person(H)
		var/list/description = H.examine(viewer)
		check(
			label in description,
			"Rank label appears in actual examine output"
		)
		if(tier <= 1)
			check(
				findtext(label, tier == 0 ? "Landless Knight" : "Lord of") \
				&& findtext(label, "85%"),
				"Small gold label"
			)
		else if(tier == 2)
			check(findtext(label, "Baron of"), "Normal noble label")
		else
			check(
				findtext(label, "140%") && findtext(label, "<font color="),
				"Large gradient label"
			)
	var/mob/living/carbon/human/nobility_fixture/poor = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	poor.prepareFixture("Low PQ")
	poor.test_pq = 0
	check(
		length(poor.taNobilityEstateChoices()) == 3 \
		&& !("Нет надела" in poor.taNobilityEstateChoices()),
		"The menu displays all purchasable tiers and omits the landless option"
	)
	poor.test_pq = 24.9
	check(
		!poor.taSelectNobility(2),
		"PQ below 25 cannot choose a wealthy estate"
	)
	check(
		!poor.mind.get_owned_manor() && poor.mind.ta_nobility_pending,
		"Failed PQ check leaves the choice available and creates no manor"
	)
	check(!poor.taSelectNobility(5), "Invalid tier rejected")
	check(!poor.taSelectNobility(3, TRUE), "Cannot forge a free role package")
	poor.test_pq = 0
	poor.manor_treasury_retention = 35
	check(
		poor.taSelectNobility(1),
		"Small estate remains available at zero PQ"
	)
	var/mob/living/carbon/human/nobility_fixture/wealthy = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	wealthy.prepareFixture("Wealthy threshold")
	wealthy.test_pq = 49.9
	check(
		!wealthy.taSelectNobility(3),
		"PQ below 50 cannot choose a great estate"
	)
	wealthy.test_pq = 25
	check(
		length(wealthy.taNobilityEstateChoices()) == 3,
		"PQ does not alter the displayed tier options"
	)
	check(wealthy.taSelectNobility(2), "Wealthy estate accepts exactly 25 PQ")
	var/mob/living/carbon/human/nobility_fixture/great = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	great.prepareFixture("Great threshold")
	check(
		length(great.taNobilityEstateChoices()) == 3,
		"PQ 50 sees the same three estate choices"
	)
	check(great.taSelectNobility(3), "Great estate accepts exactly 50 PQ")
	var/mob/living/carbon/human/nobility_fixture/squire = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	squire.prepareFixture("Erik Ash")
	squire.job = "Squire"
	squire.mind.assigned_role = "Squire"
	squire.mind.ta_nobility_origin_type = /datum/virtue/origin/grenzelhoft
	ADD_TRAIT(squire, TRAIT_SQUIRE, JOB_TRAIT)
	var/datum/virtue/utility/noble/second_virtue = new
	second_virtue.unlisted = TRUE
	apply_virtue(squire, second_virtue)
	qdel(second_virtue)
	check(
		squire.mind.ta_nobility_virtue_picks == 2 \
		&& squire.taNobilityEstateCost(2) == 0 \
		&& squire.taNobilityEstateCost(3) == 20,
		"The second virtue discounts both upper tiers"
	)
	check(
		length(squire.taNobilityEstateChoices()) == 1 \
		&& !squire.taSelectNobility(2),
		"A court squire cannot buy a rank above T1"
	)
	check(
		squire.taSelectNobility(1) \
		&& squire.taNobilityEstateMultiplier() == 1,
		"A city role without a native estate gets the standard small estate"
	)
	var/datum/manor/squire_estate = squire.mind.get_owned_manor()
	check(
		squire_estate.total_workers == 11 \
		&& squire_estate.get_assigned_workers() <= squire_estate.total_workers,
		"Purchased T1 has the standard population and no overassignment"
	)
	squire.taFinishNobilityTitle()
	check(
		findtext(squire.real_name, "Knappe ") == 1 \
		&& length(squire.taNobilityTitleOptions()) == 1,
		"An estate holder with the squire trait has the single forced \
		cultural title"
	)
	checkCityEstateBonus()
	checkWanderingNobility()
	checkLifestyle(landless, poor, wealthy, great)
	var/mob/living/carbon/human/nobility_fixture/foreign = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	foreign.prepareFixture("Иностранный дворянин")
	ADD_TRAIT(foreign, TRAIT_OUTLANDER, "local_test")
	foreign.check_manor_pref = FALSE
	check(
		foreign.taSelectNobility(2),
		"Explicit estate choice overrides old disabled preference"
	)
	check(
		foreign.mind.get_owned_manor()?.manor_size == "medium",
		"Foreign origin does not override selected size"
	)
	checkEstateTreasury(poor, foreign)
	checkEstatePopulationIncome(foreign)
	checkEstateWarehouse(poor, foreign)
	checkEstateIndustry(poor, foreign)
	checkManorProductionChains(poor)
	checkEstateNews()
	for(var/role in list("Councillor", "Hand"))
		var/mob/living/carbon/human/nobility_fixture/court = allocate(
			/mob/living/carbon/human/nobility_fixture
		)
		court.prepareFixture(role)
		court.job = role
		court.mind.assigned_role = role
		court.test_pq = 0
		check(
			!court.taSelectNobility(3),
			"Role cannot choose a second package"
		)
		court.taFinishNobility()
		check(
			court.mind.ta_nobility_tier == (role == "Hand" ? 3 : 2),
			"Role package correct tier"
		)
		check(
			court.mind.get_owned_manor() != null,
			"Role package creates estate"
		)
		if(role == "Hand")
			check(
				!court.has_stress_event(
					/datum/stressevent/ta_noble_improper_attire
				),
				"A fixed T3 role can wear its original issued set"
			)
	var/mob/living/carbon/human/nobility_fixture/royal = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	royal.prepareFixture("Принц")
	royal.job = "Prince"
	royal.mind.assigned_role = "Prince"
	royal.test_pq = 0
	royal.taFinishNobility()
	check(
		royal.taNobilityTier() == 3,
		"Royal family classified as high aristocracy"
	)
	var/mob/living/carbon/human/nobility_fixture/wanderer = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	wanderer.prepareFixture("Lawrence Vale")
	wanderer.job = "Adventurer"
	wanderer.mind.assigned_role = "Adventurer"
	var/list/cultures = list(
		"azuria",
		"enigma",
		"heartfelt",
		"grenzelhoft",
		"valoria",
		"otava",
		"etrusca",
		"hammerhold",
		"gronn",
		"zybantu",
		"raneshen",
		"naledi",
		"kazengun",
		"gyedzai",
		"jeoseon",
		"aavnr"
	)
	var/list/origins = list(
		/datum/virtue/origin/azuria,
		/datum/virtue/origin/enigma,
		/datum/virtue/origin/heartfelt,
		/datum/virtue/origin/grenzelhoft,
		/datum/virtue/origin/valorian,
		/datum/virtue/origin/otava,
		/datum/virtue/origin/etrusca,
		/datum/virtue/origin/hammerhold,
		/datum/virtue/origin/gronn,
		/datum/virtue/origin/zybantian,
		/datum/virtue/origin/raneshen,
		/datum/virtue/origin/naledi,
		/datum/virtue/origin/kazengun,
		/datum/virtue/origin/gyedzenese,
		/datum/virtue/origin/lingyue,
		/datum/virtue/origin/avar
	)
	for(var/i in 1 to length(cultures))
		wanderer.mind.ta_nobility_origin_type = origins[i]
		check(
			wanderer.taNobilityCulture() == cultures[i],
			"Exact cultural origin [cultures[i]]"
		)
		for(var/tier = 0 to 3)
			wanderer.mind.ta_nobility_tier = tier
			wanderer.mind.ta_nobility_pending = FALSE
			var/list/options = wanderer.taNobilityTitleOptions()
			check(
				length(options) > 0,
				"Culture [cultures[i]] has options at T[tier]"
			)
			var/invalid = 0
			for(var/id in GLOB.ta_noble_titles)
				var/datum/ta_noble_title/title = GLOB.ta_noble_titles[id]
				var/eligible = title.culture == cultures[i] \
				&& title.tier <= tier \
				&& title.tier >= max(0, tier - 1)
				if(!!options[id] != eligible)
					invalid++
			check(
				invalid == 0,
				"Culture [cultures[i]] T[tier] cannot forge another rank or \
				culture"
			)
	wanderer.mind.ta_nobility_origin_type = /datum/virtue/origin/azuria
	wanderer.mind.ta_nobility_tier = 2
	check(
		!wanderer.taSelectNobilityTitle("azuria/0/Ser"),
		"T2 cannot select a T0 knight"
	)
	check(
		!wanderer.taSelectNobilityTitle("grenzelhoft/2/Freiherr"),
		"Foreign title rejected"
	)
	check(
		!wanderer.taSelectNobilityTitle("azuria/3/Duke"),
		"Higher title rejected"
	)
	check(
		wanderer.taSelectNobilityTitle("azuria/1/Lord"),
		"Exactly one step down allowed"
	)
	check(
		wanderer.real_name == "Lord Lawrence Vale",
		"Honorific added without changing personal name"
	)
	wanderer.titles_pref = TITLES_F
	check(
		wanderer.taSelectNobilityTitle("azuria/2/Baron"),
		"Feminine title selectable"
	)
	check(
		wanderer.real_name == "Baroness Lawrence Vale",
		"Replacing a title does not stack prefixes"
	)
	check(
		wanderer.dna.real_name == wanderer.real_name \
		&& wanderer.mind.name == wanderer.real_name,
		"Mind and DNA use the same titled name"
	)
	wanderer.mind.ta_nobility_origin_type = /datum/virtue/origin/lingyue
	check(
		wanderer.taNobilityCulture() == "jeoseon",
		"Jeoseon not collapsed into the shared Kazengun origin name"
	)
	wanderer.mind.ta_nobility_origin_type = \
		/datum/virtue/origin/racial/crimson_lands
	check(
		wanderer.taNobilityCulture() == "zybantu",
		"Crimson Lands use the approved neighbouring pool"
	)
	for(
		var/origin in list(
			/datum/virtue/origin/racial/ancient,
			/datum/virtue/origin/racial/lirvas,
			/datum/virtue/origin/unknown
		)
	)
		wanderer.mind.ta_nobility_origin_type = origin
		check(
			wanderer.taNobilityCulture() == "azuria",
			"Fallback origin uses Azurian titles"
		)
	var/old_realm_name = SSticker.realm_name
	var/old_realm_type = SSticker.realm_type_short
	var/mob/old_ruler = SSticker.rulermob
	SSticker.realm_name = "Test Realm"
	SSticker.realm_type_short = "Duchy"
	var/list/court_labels = list(
		"Hand" = "The Duke's Hand",
		"Marshal" = "Lord Marshal of Test Realm",
		"Steward" = "Lord Steward of Test Realm",
		"Councillor" = "Councillor at the Court of Test Realm",
		"Court Magician" = "Court Magician of Test Realm",
		"Prince" = "Prince of Test Realm",
		"Knight" = "Ducal Knight of Test Realm",
		"Royal Knight" = "Royal Knight of Test Realm",
	)
	var/regex/tags = regex(@"<[^>]*>", "g")
	for(
		var/role in list(
			"Hand",
			"Marshal",
			"Steward",
			"Councillor",
			"Court Magician",
			"Prince",
			"Knight",
			"Royal Knight"
		)
	)
		var/mob/living/carbon/human/nobility_fixture/court = allocate(
			/mob/living/carbon/human/nobility_fixture
		)
		court.mind_initialize()
		court.real_name = "Arthur Vale"
		court.name = court.real_name
		court.job = role
		court.mind.assigned_role = role
		court.test_pq = 0
		ADD_TRAIT(court, TRAIT_NOBLE, JOB_TRAIT)
		var/datum/virtue/utility/noble/virtue = new
		allocated += virtue
		virtue.unlisted = TRUE
		virtue.picked_choices = list("Golden Signet Ring")
		apply_virtue(court, virtue)
		check(
			court.mind.special_items["Golden Signet Ring"] \
				== /obj/item/clothing/ring/signet/triumph,
			"[role] retains chosen lobby heirloom"
		)
		check(
			!court.mind.ta_nobility_pending,
			"[role] does not queue an estate purchase"
		)
		court.taFinishNobility()
		check(
			!court.mind.ta_nobility_pending \
			&& court.taAppliedNobilityTier() >= 2,
			"[role] receives its fixed package at zero PQ"
		)
		check(
			court.mind.get_owned_manor() != null,
			"[role] receives its manor, including the royal family"
		)
		court.taFinishNobilityTitle()
		var/expected = "court/2/Lord"
		if(role in list("Hand", "Marshal", "Steward"))
			expected = "court/3/High Lord"
		else if(role == "Prince")
			expected = "court/3/Prince"
		else if(role in list("Knight", "Royal Knight"))
			expected = "court/2/Ser"
		check(
			court.mind.ta_nobility_title_id == expected,
			"[role] gets the approved fixed title"
		)
		var/list/fixed_options = court.taNobilityTitleOptions()
		check(
			length(fixed_options) == 1 && fixed_options[expected],
			"[role] cannot select a cultural or different rank title"
		)
		var/datum/manor/existing = court.mind.get_owned_manor()
		if(existing)
			existing.manor_name = "Private Estate"
		viewer.mind.i_know_person(court)
		var/list/description = court.examine(viewer)
		var/label = court.taNobilityExamineText()
		check(
			(label in description) \
			&& html_decode(tags.Replace(label, "")) == court_labels[role],
			"[role] examine describes the office and realm instead of the \
			private holding"
		)
		if(role == "Hand")
			SSticker.realm_type_short = "Kingdom"
			check(
				html_decode(
					tags.Replace(court.taNobilityExamineText(), "")
				) == "The King's Hand",
				"A kingdom's Hand title is short and identifies the ruler"
			)
			SSticker.realm_type_short = "Duchy"
		apply_virtue(court, virtue)
		court.taFinishNobility()
		check(
			court.mind.get_owned_manor() == existing,
			"[role] reapplication never duplicates an estate"
		)
		if(role == "Knight")
			court.advjob = "Knight Banneret"
			court.mind.ta_nobility_tier = 3
			check(
				court.taFixedNobilityTitle().id == "court/3/Ser",
				"Banneret is a T3 knight exception"
			)
			check(
				findtext(court.taNobilityExamineText(), "140%"),
				"Banneret keeps high-aristocracy formatting"
			)
	var/mob/living/carbon/human/nobility_fixture/duke = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	duke.prepareFixture("Arthur Vale")
	duke.job = "Grand Duke"
	duke.mind.assigned_role = "Grand Duke"
	duke.taFinishNobility()
	duke.taFinishNobilityTitle()
	SSticker.rulermob = duke
	viewer.mind.i_know_person(duke)
	var/list/duke_examine = duke.examine(viewer)
	var/ruler_label = duke.taRulerExamineText()
	var/ruler_lines = 0
	for(var/line in duke_examine)
		if(
			findtext(
				html_decode(tags.Replace(line, "")),
				"The ruler of this land"
			)
		)
			ruler_lines++
	check(
		ruler_lines == 1 \
		&& (ruler_label in duke_examine) \
		&& html_decode(
			tags.Replace(ruler_label, "")
		) == "The ruler of this land, Grand Duke of Test Realm.",
		"Actual Duke has one combined ruler and realm line"
	)
	SSticker.rulermob = viewer
	var/list/other_ruler_examine = viewer.examine(viewer)
	check(
		span_notice("<b>The ruler of this land.</b>") in other_ruler_examine,
		"An exceptional ruler without a fixed court title keeps the ruler \
		marker"
	)
	SSticker.rulermob = old_ruler
	SSticker.realm_name = old_realm_name
	SSticker.realm_type_short = old_realm_type
	var/datum/job/mage_job = SSjob.GetJob("Court Magician")
	check(
		TRAIT_NOBLE in mage_job.job_traits,
		"Court Magician receives actual job nobility"
	)
	for(var/tier = 0 to 3)
		var/mob/living/carbon/human/nobility_fixture/H = allocate(
			/mob/living/carbon/human/nobility_fixture
		)
		H.prepareFixture("Arthur Vale", tier == 0)
		H.job = "Adventurer"
		H.mind.assigned_role = "Adventurer"
		H.mind.ta_nobility_origin_type = /datum/virtue/origin/grenzelhoft
		if(tier)
			check(
				H.taSelectNobility(tier),
				"Prompt regression T[tier] estate accepted"
			)
		else
			H.taFinishNobility()
		H.taFinishNobilityTitle()
		check(
			H.mind.ta_nobility_title_id && H.real_name != "Arthur Vale",
			"Prompt regression T[tier] gets a default prefix without client \
			input"
		)
		var/titled_name = H.real_name
		var/datum/manor/estate = H.mind.get_owned_manor()
		H.taFinishNobilityTitle(TRUE)
		check(
			H.real_name == titled_name && !H.mind.ta_nobility_title_pending,
			"Prompt regression T[tier] reentry leaves no pending input or \
			duplicate prefix"
		)
		check(
			H.mind.get_owned_manor() == estate,
			"Prompt regression T[tier] reentry keeps the manor"
		)
		var/list/description = H.examine(viewer)
		check(
			H.taNobilityExamineText() in description,
			"Prompt regression T[tier] final title remains examinable"
		)

/datum/unit_test/local_nobility/proc/checkCityEstateBonus()
	var/datum/manor/base_estate
	for(var/picks in 0 to 2)
		var/mob/living/carbon/human/nobility_fixture/court = allocate(
			/mob/living/carbon/human/nobility_fixture
		)
		court.prepareFixture("Native Estate")
		court.job = "Councillor"
		court.mind.assigned_role = "Councillor"
		court.mind.ta_nobility_pending = FALSE
		court.mind.ta_nobility_virtue_picks = 0
		for(var/index in 1 to picks)
			var/datum/virtue/utility/noble/virtue = new
			virtue.unlisted = TRUE
			apply_virtue(court, virtue)
			qdel(virtue)
		var/multiplier = 1 + picks * 0.25
		check(
			court.taNobilityEstateMultiplier() == multiplier,
			"A native estate receives 25 percent per Nobility pick"
		)
		check(
			!court.mind.ta_nobility_pending \
			&& !length(court.taNobilityEstateChoices()),
			"Nobility never queues a rank choice for a native estate"
		)
		court.taFinishNobility()
		var/datum/manor/estate = court.mind.get_owned_manor()
		check(
			estate?.manor_size == "medium",
			"Nobility preserves the court role's estate tier"
		)
		if(!estate)
			continue
		if(!picks)
			base_estate = estate
			continue
		if(!base_estate)
			continue
		check(
			estate.total_workers == ceil(
				base_estate.total_workers * multiplier
			),
			"The bonus scales the total population"
		)
		check(
			estate.industry_artisans == ceil(
				base_estate.industry_artisans * multiplier
			),
			"The bonus scales the artisan pool"
		)
		check(
			length(estate.workstations) == length(base_estate.workstations),
			"The bonus preserves the site's production lanes"
		)
		for(
			var/index in 1 to min(
				length(estate.workstations),
				length(base_estate.workstations)
			)
		)
			var/datum/workstation/actual = estate.workstations[index]
			var/datum/workstation/baseline = base_estate.workstations[index]
			check(
				actual.workstation_size == ceil(
					baseline.workstation_size * multiplier
				),
				"The bonus scales workstation capacity"
			)

/datum/unit_test/local_nobility/proc/checkWanderingNobility()
	for(
		var/class_type in list(
			/datum/advclass/noble,
			/datum/advclass/noble/knighte
		)
	)
		var/mob/living/carbon/human/nobility_fixture/wanderer = allocate(
			/mob/living/carbon/human/nobility_fixture
		)
		wanderer.prepareFixture("Wandering Noble")
		wanderer.job = "Adventurer"
		wanderer.mind.assigned_role = "Adventurer"
		wanderer.mind.picked_advclass = new class_type
		allocated += wanderer.mind.picked_advclass
		wanderer.mind.ta_nobility_origin_type = /datum/virtue/origin/grenzelhoft
		ADD_TRAIT(wanderer, TRAIT_NOBLE, JOB_TRAIT)
		var/is_knight = class_type == /datum/advclass/noble/knighte
		var/base_tier = is_knight ? 0 : 1
		check(
			wanderer.taNobilityMaxPurchasedTier() == base_tier + 1,
			"Wandering noble can improve by one tier"
		)
		check(
			length(wanderer.taNobilityEstateChoices()) == base_tier + 1,
			"Wandering noble sees only eligible estates"
		)
		check(
			!wanderer.taSelectNobility(base_tier + 2),
			"Wandering noble cannot buy a higher estate"
		)
		wanderer.taCancelNobilityClaim()
		check(
			wanderer.taAppliedNobilityTier() == base_tier,
			"Declining Nobility keeps the subclass's inherent rank"
		)
		var/datum/manor/estate = wanderer.mind.get_owned_manor()
		if(is_knight)
			check(!estate, "Knight Errant starts with no estate")
		else
			check(
				estate?.manor_size == "small",
				"Aristocrat starts with a small estate"
			)
		check(
			wanderer.taSelectNobilityTitle(
				is_knight ? "grenzelhoft/0/Ritter" : "grenzelhoft/1/Junker"
			),
			"The title uses the wandering noble's culture"
		)
		check(
			!wanderer.taSelectNobilityTitle("azuria/0/Ser"),
			"The wandering noble cannot pick a foreign title"
		)
		if(is_knight)
			var/datum/virtue/utility/noble/virtue = new
			virtue.unlisted = TRUE
			wanderer.mind.ta_nobility_tier = null
			wanderer.mind.ta_nobility_virtue_picks = 0
			apply_virtue(wanderer, virtue)
			qdel(virtue)
			check(
				wanderer.taSelectNobility(1),
				"Knight Errant with Nobility may claim a small estate"
			)

/datum/unit_test/local_nobility/proc/checkLifestyle(
	mob/living/carbon/human/landless,
	mob/living/carbon/human/small,
	mob/living/carbon/human/wealthy,
	mob/living/carbon/human/great
)
	if(
		!landless.wear_shirt \
		|| !small.wear_shirt \
		|| !great.wear_shirt \
		|| !great.wear_pants
	)
		check(FALSE, "Lifestyle fixtures start dressed")
		return
	landless.wear_shirt.item_quality = ITEM_QUALITY_LOOTED
	small.wear_shirt.item_quality = ITEM_QUALITY_LOOTED
	landless.check_equipment_mood_penalty()
	small.check_equipment_mood_penalty()
	check(
		!landless.has_stress_event(
			/datum/stressevent/unlanded_noble_shitty_equipment
		),
		"T0 can wear looted gear"
	)
	check(
		small.has_stress_event(
			/datum/stressevent/unlanded_noble_shitty_equipment
		),
		"T1 reacts to looted gear"
	)
	small.wear_shirt.item_quality = ITEM_QUALITY_STANDARD
	small.check_equipment_mood_penalty()
	check(
		!small.has_stress_event(
			/datum/stressevent/unlanded_noble_shitty_equipment
		),
		"Replacing looted gear clears the penalty"
	)

	var/datum/stressevent/hungry/hunger = new
	allocated += hunger
	check(
		hunger.get_stress(landless) == 3 \
		&& hunger.get_stress(small) == 3 \
		&& hunger.get_stress(wealthy) == 3.75 \
		&& hunger.get_stress(great) == 3.75,
		"Only T2 and T3 receive the 25% household stress increase"
	)
	var/datum/stressevent/bleeding/wound = new
	allocated += wound
	check(
		wound.get_stress(small) == wound.get_stress(wealthy),
		"Household stress does not amplify wounds"
	)

	wealthy.apply_status_effect(/datum/status_effect/fire_handler/wet_stacks, 4)
	wealthy.taUpdateNobleWetness()
	check(
		wealthy.has_stress_event(/datum/stressevent/ta_noble_wet),
		"T2 feels uncomfortable while wet"
	)
	wealthy.remove_status_effect(/datum/status_effect/fire_handler/wet_stacks)
	wealthy.taUpdateNobleWetness()
	check(
		!wealthy.has_stress_event(/datum/stressevent/ta_noble_wet),
		"Drying off clears the wetness penalty"
	)

	var/obj/item/reagent_containers/glass/cup/wooden/mug = allocate(
		/obj/item/reagent_containers/glass/cup/wooden
	)
	var/obj/item/reagent_containers/glass/cup/silver/goblet = allocate(
		/obj/item/reagent_containers/glass/cup/silver
	)
	mug.reagents.add_reagent(/datum/reagent/water, 5)
	goblet.reagents.add_reagent(/datum/reagent/water, 5)
	var/list/nobles = list(landless, small, wealthy, great)
	for(var/tier = 0 to 3)
		var/mob/living/carbon/human/noble = nobles[tier + 1]
		noble.taCheckNobleDining(goblet)
		check(
			!noble.has_stress_event(
				/datum/stressevent/ta_noble_plain_tableware
			),
			"T[tier] can drink from a silver goblet without tableware stress"
		)
		noble.taCheckNobleDining(mug)
		check(
			noble.has_stress_event(
				/datum/stressevent/ta_noble_plain_tableware
			) == (tier >= 2),
			"T[tier] gets wooden mug stress only if T2 or higher"
		)
	var/datum/stressevent/ta_noble_plain_tableware/tableware_penalty
	tableware_penalty = wealthy.get_stress_event(
		/datum/stressevent/ta_noble_plain_tableware
	)
	check(
		tableware_penalty?.get_stress(wealthy) == 1 \
		&& tableware_penalty.timer == 2 MINUTES,
		"Plain tableware adds one stress for two minutes"
	)
	var/penalty_started = world.time - 30 SECONDS
	if(tableware_penalty)
		tableware_penalty.time_added = penalty_started
	wealthy.taCheckNobleDining(goblet)
	check(
		wealthy.get_stress_event(
			/datum/stressevent/ta_noble_plain_tableware
		) == tableware_penalty \
		&& tableware_penalty?.time_added == penalty_started,
		"A silver goblet neither clears nor refreshes the existing tableware \
		penalty"
	)
	wealthy.taCheckNobleDining(mug)
	check(
		wealthy.get_stress_event(
			/datum/stressevent/ta_noble_plain_tableware
		) == tableware_penalty \
		&& tableware_penalty?.time_added > penalty_started \
		&& tableware_penalty.stacks == 1,
		"Another wooden mug sip refreshes the same penalty without stacking"
	)
	wealthy.remove_stress(/datum/stressevent/ta_noble_plain_tableware)
	mug.reagents.clear_reagents()
	mug.reagents.add_reagent(/datum/reagent/medicine/salglu_solution, 5)
	wealthy.taCheckNobleDining(mug)
	check(
		!wealthy.has_stress_event(/datum/stressevent/ta_noble_plain_tableware),
		"A primarily medicinal drink skips tableware rules"
	)

	var/obj/item/reagent_containers/glass/bowl/meal = allocate(
		/obj/item/reagent_containers/glass/bowl
	)
	meal.reagents.add_reagent(/datum/reagent/consumable/soup/veggie, 5)
	for(var/tier = 0 to 3)
		var/mob/living/carbon/human/noble = nobles[tier + 1]
		noble.taCheckNobleDining(meal)
		check(
			noble.has_stress_event(
				/datum/stressevent/noble_bad_manners
			) == (tier >= 2),
			"T[tier] minds drinking soup straight from a bowl only if T2 or \
			higher"
		)
		check(
			noble.has_stress_event(
				/datum/stressevent/noble_ate_without_table
			) == (tier >= 2),
			"T[tier] minds eating soup away from a table only if T2 or higher"
		)
	allocate(/obj/structure/table, get_step(get_turf(wealthy), EAST))
	wealthy.taCheckNobleDining(meal, served_with_spoon = TRUE)
	check(
		!wealthy.has_stress_event(/datum/stressevent/noble_bad_manners) \
		&& !wealthy.has_stress_event(
			/datum/stressevent/noble_ate_without_table
		),
		"A spoon and nearby table clear both manners penalties"
	)

	for(var/tier = 0 to 3)
		var/mob/living/carbon/human/noble = nobles[tier + 1]
		noble.check_equipment_mood_penalty()
		check(
			noble.has_stress_event(
				/datum/stressevent/ta_noble_improper_attire
			) == (tier == 3),
			"T[tier] gets the ordinary outfit penalty only at T3"
		)
	var/datum/stressevent/poor_outfit = great.get_stress_event(
		/datum/stressevent/ta_noble_improper_attire
	)
	check(
		poor_outfit?.get_stress(great) == 1,
		"An ordinary T3 outfit adds one stress"
	)
	var/obj/item/clothing/ring/gold/ring = allocate(
		/obj/item/clothing/ring/gold,
		great
	)
	ring.item_quality = ITEM_QUALITY_STANDARD
	great.check_equipment_mood_penalty()
	check(
		great.has_stress_event(/datum/stressevent/ta_noble_improper_attire),
		"An unworn luxury item does not count"
	)
	great.equip_to_slot(ring, SLOT_RING, TRUE)
	great.check_equipment_mood_penalty()
	check(
		!great.has_stress_event(/datum/stressevent/ta_noble_improper_attire),
		"One visible luxury piece satisfies the dress requirement"
	)
	great.transferItemToLoc(great.wear_shirt, get_turf(great), TRUE)
	var/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic/tunic = allocate(
		/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic,
		great
	)
	tunic.item_quality = ITEM_QUALITY_STANDARD
	great.equip_to_slot(tunic, SLOT_SHIRT, TRUE)
	great.check_equipment_mood_penalty()
	var/datum/stressevent/fine_outfit = great.get_stress_event(
		/datum/stressevent/ta_noble_representative_attire
	)
	check(
		fine_outfit?.get_stress(great) == -1,
		"Silk and worn gold jewelry remove one stress at T3"
	)
	great.transferItemToLoc(tunic, get_turf(great), TRUE)
	great.check_equipment_mood_penalty()
	check(
		great.has_stress_event(/datum/stressevent/ta_noble_improper_attire) \
		&& !great.has_stress_event(
			/datum/stressevent/ta_noble_representative_attire
		),
		"Uncovering the torso clears the bonus even with worn jewelry"
	)

/datum/unit_test/local_nobility/proc/checkEstateTreasury(
	mob/living/carbon/human/resident,
	mob/living/carbon/human/foreign
)
	var/datum/manor/local_estate = resident.mind.get_owned_manor()
	var/datum/manor/foreign_estate = foreign.mind.get_owned_manor()
	if(!local_estate || !foreign_estate)
		check(FALSE, "Both treasury fixtures have an estate")
		return
	check(
		!local_estate.virtue_origin && foreign_estate.virtue_origin,
		"Treasury fixtures exercise domestic and foreign routes"
	)
	check(
		local_estate.treasury_retention == 35 \
		&& foreign_estate.treasury_retention == 0,
		"New estates use the character setting and default to zero retention"
	)
	var/resident_role = resident.mind.assigned_role
	var/foreign_role = foreign.mind.assigned_role
	var/foreign_origin = foreign.mind.ta_nobility_origin_type
	foreign.mind.assigned_role = "Adventurer"
	foreign.mind.ta_nobility_origin_type = /datum/virtue/origin/kazengun
	check(
		local_estate.paysEstateToAccount(resident) \
		&& !foreign_estate.paysEstateToAccount(foreign),
		"City roles use Meister and adventuring nobles use mail"
	)
	resident.mind.assigned_role = "Councillor"
	check(
		local_estate.paysEstateToAccount(resident),
		"Court nobles use Meister"
	)
	local_estate.treasury_retention = 100
	foreign_estate.treasury_retention = 100
	SStreasury.create_bank_account(resident, 5, FALSE)
	SStreasury.create_bank_account(foreign, 5, FALSE)
	var/datum/fund/resident_account = SStreasury.get_account(resident)
	var/datum/fund/foreign_account = SStreasury.get_account(foreign)
	if(!resident_account || !foreign_account)
		check(FALSE, "Both treasury fixtures have a personal account")
		return
	var/original_day = GLOB.dayspassed
	var/previous_levy = SStreasury.get_tax_rate(TAX_CATEGORY_ESTATE_LEVY)
	var/previous_tariff = SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF)
	var/datum/decree/great_writ = SStreasury.get_decree(DECREE_GREAT_WRIT)
	var/writ_was_active = great_writ?.active
	if(great_writ)
		great_writ.active = FALSE
	SStreasury.set_tax_rate(TAX_CATEGORY_ESTATE_LEVY, 0.15)
	SStreasury.set_tax_rate(TAX_CATEGORY_IMPORT_TARIFF, 0.15)
	GLOB.dayspassed++
	var/list/local_workstations = local_estate.workstations
	var/list/foreign_workstations = foreign_estate.workstations
	var/local_patron = local_estate.patron
	var/foreign_patron = foreign_estate.patron
	var/list/estate_populations = list()
	for(
		var/datum/manor/estate as anything in list(local_estate, foreign_estate)
	)
		estate_populations[estate] = list(
			estate.total_workers,
			estate.industry_peasants,
			estate.industry_artisans
		)
		estate.total_workers = 0
		estate.industry_peasants = 0
		estate.industry_artisans = 0
		var/datum/workstation/trade/market = new
		allocated += market
		// The base stockpile type has no trade good, so only the fixed
		// market income contributes.
		market.produce = list(/datum/roguestock/stockpile)
		market.workers_employed = 5
		market.production_modifier = 2
		estate.workstations = list(market)
		estate.patron = /datum/patron/divine/astrata
	check(
		!local_estate.produce_resources(foreign, FALSE, TRUE),
		"Another owner cannot process the estate's cycle"
	)
	var/list/local_report = local_estate.produce_resources(
		resident,
		FALSE,
		TRUE
	)
	var/list/foreign_report = foreign_estate.produce_resources(
		foreign,
		FALSE,
		TRUE
	)
	check(
		local_report?["gross"] == 20 \
		&& local_report?["estate_levy"] == 3 \
		&& !local_report?["import_tariff"] \
		&& local_report?["money"] == 17,
		"Local settlement applies the estate levy only"
	)
	check(
		foreign_report?["gross"] == 20 \
		&& foreign_report?["estate_levy"] == 3 \
		&& foreign_report?["import_tariff"] == 2 \
		&& foreign_report?["money"] == 15,
		"Foreign settlement also applies import tariff"
	)
	check(
		local_estate.estate_treasury?.balance == 17 \
		&& foreign_estate.estate_treasury?.balance == 15,
		"Net proceeds stay in distinct estate funds"
	)
	check(
		resident_account.balance == 5 && foreign_account.balance == 5,
		"Settling production does not credit or charge personal accounts"
	)
	var/list/resident_mail = resident.mind.manor_packages
	var/list/foreign_mail = foreign.mind.manor_packages
	check(
		length(resident_mail) == 1 && istype(resident_mail[1], /obj/item/paper),
		"Local production queues one HERMES report on paper"
	)
	check(
		length(foreign_mail) == 1 && istype(foreign_mail[1], /obj/item/paper),
		"Foreign production queues a paper report instead of a coin package"
	)
	var/obj/item/paper/court_letter
	if(length(resident_mail))
		court_letter = resident_mail[1]
	check(
		court_letter \
		&& findtext(court_letter.info, "Моему лорду, [resident.real_name]") \
		&& !findtext(court_letter.info, "HERMES"),
		"The report uses a Russian title and keeps the letter in character"
	)
	check(
		findtext(
			court_letter?.info,
			"[get_ic_date_short_as_string(GLOB.dayspassed)]</i>"
		),
		"The report header contains a date without the production phase"
	)
	var/obj/item/paper/foreign_letter
	if(length(foreign_mail))
		foreign_letter = foreign_mail[1]
	check(
		foreign_letter && findtext(foreign_letter.mailer, "гокэнин ") == 1,
		"The steward of a T2 Kazengun noble uses that culture's T1 title"
	)
	local_estate.produce_resources(resident, FALSE, TRUE)
	foreign_estate.produce_resources(foreign, FALSE, TRUE)
	check(
		local_estate.estate_treasury?.balance == 17 \
		&& foreign_estate.estate_treasury?.balance == 15,
		"Reprocessing the same dusk does not credit either estate twice"
	)
	check(
		length(resident_mail) == 1 && length(foreign_mail) == 1,
		"Reprocessing the same dusk does not send either report twice"
	)

	var/revision = local_estate.estate_withdrawal_revision
	check(
		!local_estate.withdrawEstateMoney(foreign, 5, revision),
		"A different owner cannot withdraw estate funds"
	)
	check(
		!local_estate.withdrawEstateMoney(resident, 18, revision),
		"The owner cannot overdraw estate funds"
	)
	check(
		!local_estate.withdrawEstateMoney(resident, 0, revision),
		"Zero withdrawal is rejected"
	)
	check(
		!local_estate.withdrawEstateMoney(resident, -1, revision),
		"Negative withdrawal is rejected"
	)
	check(
		!local_estate.withdrawEstateMoney(resident, 1.5, revision),
		"Fractional withdrawal is rejected"
	)
	check(
		local_estate.estate_treasury?.balance == 17 \
		&& resident_account.balance == 5 \
		&& foreign_account.balance == 5,
		"Rejected requests leave both sides unchanged"
	)
	check(
		local_estate.withdrawEstateMoney(resident, 5, revision),
		"The owner can transfer a partial balance"
	)
	check(
		local_estate.estate_treasury?.balance == 12 \
		&& resident_account.balance == 10,
		"A withdrawal debits the estate and credits the owner equally"
	)
	check(
		!local_estate.withdrawEstateMoney(resident, 5, revision),
		"A replay with a stale withdrawal revision is rejected despite \
		available funds"
	)
	check(
		local_estate.withdrawEstateMoney(
			resident,
			12,
			local_estate.estate_withdrawal_revision
		),
		"The owner can withdraw the exact remaining balance"
	)
	check(
		local_estate.estate_treasury?.balance == 0 \
		&& resident_account.balance == 22 \
		&& foreign_account.balance == 5,
		"No extra charge or payment accompanies the owner's withdrawals"
	)

	GLOB.dayspassed++
	foreign_estate.produce_resources(foreign, FALSE, TRUE)
	check(
		foreign_estate.estate_treasury?.balance == 30,
		"Foreign tax rounding is settled independently for each shipment"
	)
	local_estate.patron = /datum/patron/inhumen/zizo
	local_estate.produce_resources(resident, TRUE, FALSE)
	check(
		local_estate.estate_treasury?.balance == 17,
		"Zizo earns at dawn on the next day"
	)
	local_estate.produce_resources(resident, FALSE, TRUE)
	check(
		local_estate.estate_treasury?.balance == 34,
		"Zizo also earns at dusk on the same day"
	)
	local_estate.produce_resources(resident, TRUE, FALSE)
	local_estate.produce_resources(resident, FALSE, TRUE)
	check(
		local_estate.estate_treasury?.balance == 34,
		"Replaying either Zizo phase does not pay again"
	)

	if(great_writ)
		great_writ.active = TRUE
		GLOB.dayspassed++
		var/list/exempt_report = foreign_estate.produce_resources(
			foreign,
			FALSE,
			TRUE
		)
		check(
			exempt_report?["estate_levy"] == 3 \
			&& exempt_report?["import_tariff"] == 0 \
			&& exempt_report?["money"] == 17,
			"The Great Writ exempts a noble from import tariff but not \
			estate levy"
		)
		great_writ.active = writ_was_active

	GLOB.dayspassed++
	local_estate.patron = /datum/patron/divine/astrata
	local_estate.treasury_retention = 50
	foreign_estate.treasury_retention = 0
	var/previous_local_treasury = local_estate.estate_treasury.balance
	var/previous_foreign_treasury = foreign_estate.estate_treasury.balance
	var/previous_personal_balance = resident_account.balance
	var/foreign_mail_count = length(foreign_mail)
	local_report = local_estate.produce_resources(resident, FALSE, TRUE)
	foreign_report = foreign_estate.produce_resources(foreign, FALSE, TRUE)
	check(
		local_report?["payout"] == 9 \
		&& local_estate.estate_treasury.balance == previous_local_treasury + 8 \
		&& resident_account.balance == previous_personal_balance + 9,
		"Court income automatically divides between treasury and Meister"
	)
	var/obj/item/manor_delivery/automatic_delivery
	if(length(foreign_mail))
		automatic_delivery = foreign_mail[length(foreign_mail)]
	check(
		length(foreign_mail) == foreign_mail_count + 1 \
		&& istype(automatic_delivery),
		"Default foreign income arrives in the same package as the report"
	)
	if(istype(automatic_delivery))
		var/obj/item/paper/earlier_report = foreign_mail[1]
		check(
			automatic_delivery.manor_income == foreign_report?["money"] \
			&& automatic_delivery.manor_note \
			&& foreign_estate.estate_treasury.balance \
				== previous_foreign_treasury \
			&& foreign_account.balance == 5,
			"Zero retention mails all net income without touching either \
			balance"
		)
		check(
			earlier_report?.mailer \
			&& earlier_report.mailer == automatic_delivery.manor_note?.mailer,
			"Estate letters keep the same sender between cycles"
		)
	GLOB.dayspassed++
	local_report = local_estate.produce_resources(resident, FALSE, TRUE)
	check(
		local_report?["payout"] == 8 \
		&& local_estate.estate_treasury.balance == previous_local_treasury + \
			17 \
		&& resident_account.balance == previous_personal_balance + 17,
		"Fractional retention carries over so consecutive payments honor the \
		chosen percentage"
	)

	foreign_mail_count = length(foreign_mail)
	revision = foreign_estate.estate_withdrawal_revision
	check(
		foreign_estate.withdrawEstateMoney(foreign, 5, revision),
		"Non-court owners can request a postal withdrawal"
	)
	check(
		foreign_estate.estate_treasury.balance == previous_foreign_treasury - \
			5 \
		&& length(foreign_mail) == foreign_mail_count \
		&& foreign_account.balance == 5,
		"Postal withdrawals reserve funds without immediately delivering or \
		crediting them"
	)
	check(
		!foreign_estate.withdrawEstateMoney(foreign, 5, revision) \
		&& foreign_estate.estate_treasury.balance \
			== previous_foreign_treasury - 5,
		"Replaying a postal request does not reserve a second payment"
	)
	var/obj/item/manor_delivery/delayed_delivery
	delayed_delivery = foreign_estate.makeEstateWithdrawalMail(
		foreign,
		5
	)
	allocated += delayed_delivery
	check(
		delayed_delivery?.manor_income == 5 && delayed_delivery.manor_note,
		"A manual postal payment encloses the requested amount and a letter"
	)
	delayed_delivery?.deliverToEstateOwner(foreign.mind)
	delayed_delivery?.deliverToEstateOwner(foreign.mind)
	check(
		length(foreign_mail) == foreign_mail_count + 1 \
		&& foreign_mail[length(foreign_mail)] == delayed_delivery,
		"The timed delivery callback delivers the package only once"
	)
	foreign_mail -= delayed_delivery

	resident.mind.assigned_role = resident_role
	foreign.mind.assigned_role = foreign_role
	foreign.mind.ta_nobility_origin_type = foreign_origin
	local_estate.workstations = local_workstations
	foreign_estate.workstations = foreign_workstations
	local_estate.patron = local_patron
	foreign_estate.patron = foreign_patron
	for(var/datum/manor/estate as anything in estate_populations)
		var/list/population = estate_populations[estate]
		estate.total_workers = population[1]
		estate.industry_peasants = population[2]
		estate.industry_artisans = population[3]
	GLOB.dayspassed = original_day
	SStreasury.set_tax_rate(TAX_CATEGORY_ESTATE_LEVY, previous_levy)
	SStreasury.set_tax_rate(TAX_CATEGORY_IMPORT_TARIFF, previous_tariff)

/datum/unit_test/local_nobility/proc/checkEstatePopulationIncome(
	mob/living/carbon/human/owner
)
	var/datum/manor/previous_manor = owner.mind.get_owned_manor()
	if(!previous_manor?.virtue_origin)
		check(FALSE, "The population income fixture needs a foreign estate")
		return
	var/original_day = GLOB.dayspassed
	var/datum/manor/estate = new
	var/datum/workstation/field/field = new
	allocated += list(estate, field)
	estate.workstations = list(field)
	estate.industry_active = TRUE
	estate.industry_peasants = 2
	estate.industry_artisans = 1
	estate.total_workers = 3
	estate.workers_limit = 10
	estate.virtue_origin = previous_manor.virtue_origin
	estate.patron = /datum/patron/inhumen/zizo
	estate.treasury_retention = 100
	owner.mind.set_owned_manor(estate)
	GLOB.dayspassed++

	var/list/mail = owner.mind.manor_packages
	var/mail_count = length(mail)
	var/list/dawn_report = estate.produce_resources(owner, TRUE, FALSE)
	var/population_income = dawn_report?["population_income"]
	check(
		population_income >= 5 \
		&& population_income <= 25 \
		&& dawn_report?["gross"] == population_income,
		"Two peasants and one artisan pay within their combined daily ranges \
		even without assigned jobs"
	)
	check(
		!dawn_report?["import_tariff"] \
		&& estate.estate_treasury?.balance == dawn_report?["money"],
		"Foreign population income goes to the estate fund without import \
		tariffs"
	)
	var/obj/item/paper/letter
	if(length(mail) > mail_count)
		letter = mail[mail_count + 1]
	check(
		istype(letter) \
		&& findtext(
			letter.info,
			"С жителей имения собрал [population_income] маммон."
		),
		"The report identifies residents as the source of the passive income"
	)
	var/list/dusk_report = estate.produce_resources(owner, FALSE, TRUE)
	check(
		islist(dusk_report) \
		&& !dusk_report["population_income"] \
		&& estate.estate_treasury?.balance == dawn_report?["money"],
		"Zizo's second production cycle cannot collect population income twice"
	)

	GLOB.dayspassed++
	estate.patron = /datum/patron/inhumen/graggar
	dusk_report = estate.produce_resources(owner, FALSE, TRUE)
	population_income = dusk_report?["population_income"]
	check(
		population_income >= 5 \
		&& population_income <= 25 \
		&& estate.total_workers == 3 \
		&& estate.industry_peasants == 2,
		"The next dae collects income again without Graggar increasing the \
		population"
	)
	owner.mind.set_owned_manor(previous_manor)
	GLOB.dayspassed = original_day

/datum/unit_test/local_nobility/proc/checkEstateWarehouse(
	mob/living/carbon/human/owner,
	mob/living/carbon/human/other
)
	var/datum/manor/previous_manor = owner.mind.get_owned_manor()
	var/datum/manor/estate = new
	allocated += estate
	owner.mind.set_owned_manor(estate)

	check(
		estate.warehouse_raw_sale == 100 \
		&& estate.warehouse_processed_sale == 100 \
		&& !length(estate.warehouse_stock),
		"A new estate starts with an empty warehouse and sells the whole \
		harvest"
	)
	check(
		!estate.setWarehouseSale(other, "raw", 50) \
		&& !estate.setWarehouseSale(owner, "raw", -1) \
		&& !estate.setWarehouseSale(owner, "raw", 101) \
		&& !estate.setWarehouseSale(owner, "processed", 12.5) \
		&& !estate.setWarehouseSale(owner, "finished", 100),
		"Warehouse sales require the owner, a supported stage and a whole \
		percentage"
	)
	check(
		estate.setWarehouseSale(owner, "raw", 50) \
		&& !estate.storeWarehouseShare(TRADE_GOOD_IRON_INGOT, 2),
		"Changing raw sales leaves processed sales untouched"
	)
	check(
		estate.setWarehouseSale(owner, "processed", 0) \
		&& estate.storeWarehouseShare(TRADE_GOOD_IRON_INGOT, 2) == 2 \
		&& estate.warehouse_raw_sale == 50,
		"Processed ingots can all be stored without changing the raw sale \
		percentage"
	)
	check(
		!estate.storeWarehouseShare(TRADE_GOOD_GRAIN, 1) \
		&& !estate.storeWarehouseShare(TRADE_GOOD_IRON_ORE, 1),
		"Fractional retention is tracked separately for each commodity"
	)
	check(
		estate.storeWarehouseShare(TRADE_GOOD_GRAIN, 1) == 1 \
		&& estate.warehouse_stock[TRADE_GOOD_GRAIN] == 1 \
		&& !estate.warehouse_stock[TRADE_GOOD_IRON_ORE],
		"Two one-unit harvests retain one unit without transferring a \
		remainder to another good"
	)

	var/datum/workstation/field/field = new
	allocated += field
	field.produce = list(/datum/roguestock/stockpile/grain)
	field.workers_employed = 5
	estate.workstations = list(field)
	var/datum/roguestock/stockpile/grain
	grain = SSeconomy.find_stockpile_by_trade_good(TRADE_GOOD_GRAIN)
	var/previous_grain = grain?.stockpile_amount
	var/original_day = GLOB.dayspassed
	var/revision = estate.warehouse_revision
	estate.setWarehouseSale(owner, "raw", 0)
	var/list/report = estate.produce_resources(owner, FALSE, TRUE)
	var/list/products = report?["products"]
	var/list/stored = report?["stored_products"]
	var/harvest = products?[/datum/roguestock/stockpile/grain] || 0
	check(
		islist(report) \
		&& report["gross"] == report["population_income"] \
		&& (stored?[/datum/roguestock/stockpile/grain] || 0) == harvest \
		&& estate.warehouse_stock[TRADE_GOOD_GRAIN] == 1 + harvest \
		&& grain?.stockpile_amount == previous_grain,
		"Full retention stores the harvest and produces neither sale income \
		nor Crown stock"
	)
	check(
		estate.warehouse_revision == revision + (harvest ? 1 : 0),
		"A production cycle updates the stock revision once"
	)
	check(
		!estate.produce_resources(owner, FALSE, TRUE) \
		&& estate.warehouse_stock[TRADE_GOOD_GRAIN] == 1 + harvest,
		"A repeated cycle cannot deposit the harvest again"
	)

	GLOB.dayspassed++
	estate.setWarehouseSale(owner, "raw", 100)
	report = estate.produce_resources(owner, FALSE, TRUE)
	products = report?["products"]
	check(
		estate.warehouse_stock[TRADE_GOOD_GRAIN] == 1 + harvest \
		&& grain?.stockpile_amount == previous_grain + (
			products?[/datum/roguestock/stockpile/grain] || 0
		),
		"Selling the whole harvest leaves the warehouse alone and preserves \
		deliveries to the Crown"
	)
	GLOB.dayspassed = original_day
	if(grain)
		grain.stockpile_amount = previous_grain

	estate.warehouse_stock = list(
		TRADE_GOOD_GRAIN = 25,
		TRADE_GOOD_IRON_ORE = 4
	)
	revision = estate.warehouse_revision
	var/list/requested = list(TRADE_GOOD_GRAIN = 3, TRADE_GOOD_IRON_ORE = 2)
	check(
		!estate.requestWarehouseShipment(other, requested, revision) \
		&& !estate.requestWarehouseShipment(owner, requested, revision + 1),
		"Only the owner can ship from the current warehouse revision"
	)
	check(
		!estate.requestWarehouseShipment(
			owner,
			list(TRADE_GOOD_GRAIN = 3, TRADE_GOOD_IRON_ORE = 5),
			revision
		) \
		&& estate.warehouse_stock[TRADE_GOOD_GRAIN] == 25,
		"An unavailable product rejects the whole order without partial debits"
	)
	check(
		!estate.requestWarehouseShipment(
			owner,
			list(TRADE_GOOD_GRAIN = 1.5),
			revision
		) \
		&& !estate.requestWarehouseShipment(
			owner,
			list(TRADE_GOOD_GRAIN = 23, TRADE_GOOD_IRON_ORE = 2),
			revision
		),
		"Fractional quantities and oversized mixed shipments are rejected"
	)
	var/mail_count = length(owner.mind.manor_packages)
	check(
		estate.requestWarehouseShipment(owner, requested, revision),
		"The owner can request a mixed shipment from available stock"
	)
	check(
		estate.warehouse_stock[TRADE_GOOD_GRAIN] == 22 \
		&& estate.warehouse_stock[TRADE_GOOD_IRON_ORE] == 2 \
		&& length(owner.mind.manor_packages) == mail_count,
		"Shipping reserves the exact amounts and does not deliver instantly"
	)
	check(
		!estate.requestWarehouseShipment(owner, requested, revision),
		"Replaying a shipment request with the old revision fails"
	)

	check(
		estate.warehouseTravelMultiplier(1, 3) == 0.5 \
		&& estate.warehouseTravelMultiplier(24, 24) == 2 \
		&& estate.warehouseTravelMultiplier(1, 120) == 2,
		"Light shipments travel faster and either bulk or value can double \
		travel time"
	)
	var/obj/item/parcel/manor_shipment/shipment = new
	allocated += shipment
	var/estate_name = "Greyford & West"
	var/list/items = list(
		/obj/item/reagent_containers/food/snacks/grown/wheat = 2,
		/obj/item/rogueore/iron = 1,
		/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_wine \
			= 1
	)
	check(
		shipment.sendToOwner(owner.mind, items, estate_name) \
		&& length(shipment.contained_items) == 4 \
		&& shipment.preserves_contents \
		&& shipment.invisibility == initial(shipment.invisibility),
		"A mixed parcel materializes the chosen goods, preserves produce and \
		is visible"
	)
	for(var/obj/item/product as anything in shipment.contained_items)
		var/list/description = product.examine(owner)
		var/marked = !!findtext(description.Join(), html_encode(estate_name))
		check(
			marked == !istype(product, /obj/item/reagent_containers/food),
			"An estate hallmark identifies equipment and bottles but is \
			absent from food"
		)
	check(
		shipment.icon_state == "ration_large" \
		&& findtext(shipment.desc, html_encode(owner.real_name)),
		"The mixed parcel uses the large delivery sprite and shows the \
		recipient's name"
	)
	check(
		shipment.can_open(owner, TRUE) && !shipment.can_open(null, TRUE),
		"Only a living recipient can open the seal"
	)
	var/other_name = other.real_name
	other.real_name = owner.real_name
	check(
		!shipment.can_open(other, TRUE) \
		&& shipment.attack_self(other) == FALSE \
		&& length(shipment.contained_items) == 4,
		"Another character cannot open or consume the parcel even with the \
		same name"
	)
	other.real_name = other_name
	var/datum/ta_retainer_contract/service = new(owner.mind, other.mind)
	check(
		shipment.can_open(other, TRUE),
		"An active retainer can open a sealed delivery addressed to their \
		employer"
	)
	qdel(service)
	check(
		!shipment.can_open(other, TRUE),
		"Ending service revokes permission to open the former employer's \
		parcels"
	)
	check(
		!shipment.sendToOwner(owner.mind, items) \
		&& length(owner.mind.manor_packages) == mail_count + 1 \
		&& (shipment in owner.mind.manor_packages),
		"The shipment callback queues the parcel only once"
	)
	owner.mind.manor_packages -= shipment
	var/obj/item/parcel/manor_shipment/small_shipment = new
	allocated += small_shipment
	check(
		small_shipment.sendToOwner(
			owner.mind,
			list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
		) \
		&& small_shipment.icon_state == "ration_small",
		"A single light item uses the small delivery sprite"
	)
	owner.mind.manor_packages -= small_shipment
	owner.mind.set_owned_manor(previous_manor)

/datum/unit_test/local_nobility/proc/workshopOrderId(
	list/catalogue,
	recipe_type
)
	for(var/id in catalogue)
		var/list/recipe = catalogue[id]
		if(recipe["recipe_type"] == recipe_type)
			return id
	return "missing_recipe"

/datum/unit_test/local_nobility/proc/workshopPointCost(list/catalogue, id)
	var/list/recipe = catalogue[id]
	return recipe?["cost"]

/datum/unit_test/local_nobility/proc/workshopTestOrder(first_id, second_id)
	var/list/requested = list()
	requested[first_id] = 1
	if(second_id)
		requested[second_id] = 1
	return requested

/datum/unit_test/local_nobility/proc/checkEstateIndustry(
	mob/living/carbon/human/owner,
	mob/living/carbon/human/other
)
	var/list/naledi_mine = list(
		"resource_unlocks" = list("mining" = list(TRADE_GOOD_GOLD_ORE))
	)
	var/list/local_gold = taSanitizeManorIndustryProfile(
		"small",
		naledi_mine,
		"mining_settlement",
		/datum/virtue/origin/naledi
	)
	var/list/foreign_gold = taSanitizeManorIndustryProfile(
		"small",
		naledi_mine,
		"mining_settlement",
		/datum/virtue/origin/azuria
	)
	var/list/local_unlocks = local_gold["resource_unlocks"]
	var/list/foreign_unlocks = foreign_gold["resource_unlocks"]
	check(
		(TRADE_GOOD_GOLD_ORE in local_unlocks["mining"]) \
		&& !length(foreign_unlocks["mining"]),
		"A small estate can buy gold mining only at the Naledi price"
	)
	var/list/overspent = taSanitizeManorIndustryProfile(
		"small",
		list(
			"expand_mine" = TRUE,
			"unlock_steel" = TRUE,
			"metal" = "steel",
			"finishers" = 8
		)
	)
	check(
		overspent["expand_mine"] \
		&& !overspent["unlock_steel"] \
		&& overspent["smeltery_metal"] == "iron" \
		&& overspent["forge_metal"] == "iron",
		"Small mining profiles cannot exceed the improvement budget"
	)
	var/list/forge_expansion = taSanitizeManorIndustryProfile(
		"small",
		list(
			"artisans" = 99,
			"miners" = 99,
			"finishers" = 3,
			"expand_forge" = TRUE
		)
	)
	check(
		forge_expansion["artisans"] == 5 \
		&& forge_expansion["miners"] == 0 \
		&& forge_expansion["finishers"] == 2,
		"Artisans use three peasant places each and a forge expansion allows \
		one additional worker"
	)
	var/list/legacy = taSanitizeManorIndustryProfile(
		"small",
		list("artisans" = 3, "smelting" = TRUE, "finishing" = FALSE)
	)
	check(
		legacy["smelters"] == 3 && legacy["finishers"] == 0,
		"Old mining preferences preserve the initial choice of artisan jobs"
	)
	var/datum/manor/single_artisan = new
	allocated += single_artisan
	single_artisan.industry_active = TRUE
	single_artisan.industry_artisans = 1
	single_artisan.industry_smeltery = new
	single_artisan.industry_smeltery.workers_employed = 1
	single_artisan.industry_forge = new
	allocated += list(
		single_artisan.industry_smeltery,
		single_artisan.industry_forge
	)
	var/list/single_result = single_artisan.processIndustryHarvest(3)
	check(
		single_result?["ingot_surplus"] == 3 && !single_artisan.industry_points,
		"One artisan can smelt a batch but cannot also turn that batch into \
		points in the same cycle"
	)
	check(
		!single_artisan.industryAllowsMetal("steel"),
		"Steel is unavailable without the upgrade"
	)
	var/previous_role = owner.mind.assigned_role
	owner.mind.assigned_role = "Adventurer"
	var/list/previous_profiles = owner.manor_industry_profiles
	var/previous_type = owner.manor_type_pref
	var/datum/manor/previous_manor = owner.mind.get_owned_manor()
	owner.manor_type_pref = "mining_settlement"
	owner.manor_industry_profiles = list(
		"small" = list(
			"artisans" = 3,
			"miners" = 0,
			"smelters" = 2,
			"finishers" = 1,
			"unlock_steel" = TRUE,
			"metal" = "steel"
		)
	)
	var/datum/manor/estate = new
	allocated += estate
	owner.mind.set_owned_manor(estate)
	estate.manor_type = "mining_settlement"
	estate.on_creation(owner)
	check(
		estate.industry_active \
		&& estate.total_workers == 9 \
		&& estate.industry_peasants == 6 \
		&& estate.industry_artisans == 3 \
		&& estate.getAssignedArtisans() == 3 \
		&& estate.industry_smeltery.workers_employed == 2 \
		&& estate.industry_forge.workers_employed == 1 \
		&& estate.industry_forge.workstation_size == 1,
		"The chosen land size receives two workstations sharing one artisan \
		pool"
	)
	check(
		(/datum/roguestock/stockpile/copper in estate.industry_mine.produce) \
		&& (/datum/roguestock/stockpile/iron in estate.industry_mine.produce),
		"The mining profile retains the normal mix of raw materials"
	)
	var/list/mining_goods = estate.getIndustryMiningGoods()
	check(
		length(mining_goods) == 6 \
		&& mining_goods[TRADE_GOOD_STONE] \
		&& mining_goods[TRADE_GOOD_CLAY] \
		&& isnull(estate.industry_mining_priority),
		"The mine offers every local resource and starts with no priority"
	)
	check(
		!estate.setIndustryMiningPriority(owner, TRADE_GOOD_GRAIN) \
		&& !estate.setIndustryMiningPriority(other, TRADE_GOOD_IRON_ORE),
		"An unrelated good and a request from another character cannot \
		change the mining priority"
	)
	check(
		estate.setIndustryMiningPriority(owner, TRADE_GOOD_COAL) \
		&& estate.industry_mining_priority == TRADE_GOOD_COAL \
		&& estate.setIndustryMiningPriority(owner, null) \
		&& isnull(estate.industry_mining_priority),
		"The owner can select an offered trade good and restore neutral mining"
	)
	estate.patron = /datum/patron/divine/astrata
	estate.warehouse_stock[TRADE_GOOD_IRON_ORE] = 5
	estate.setWarehouseSale(owner, "raw", 0)
	estate.setWarehouseSale(owner, "processed", 0)
	var/old_warehouse_revision = estate.warehouse_revision
	check(
		islist(estate.produce_resources(owner, FALSE, TRUE)),
		"The scheduled estate cycle runs the mining profile"
	)
	var/list/report = estate.getIndustryPanelData()
	check(
		report?["smeltery_metal"] == "steel" \
		&& report?["forge_metal"] == "steel" \
		&& report?["last_ore"] == 0 \
		&& report?["last_ingots"] == 5 \
		&& !estate.warehouse_stock[TRADE_GOOD_IRON_INGOT],
		"The legacy steel setting controls both stages without a duplicate \
		iron output"
	)
	check(
		report?["last_forged_ingots"] == 3 \
		&& report?["last_points"] == 6 \
		&& estate.industry_points == 6 \
		&& estate.warehouse_stock[TRADE_GOOD_STEEL_INGOT] == 2 \
		&& !estate.warehouse_stock[TRADE_GOOD_IRON_ORE],
		"Three forged steel ingots generate six points and the remaining two \
		ingots reach the warehouse"
	)
	check(
		estate.warehouse_revision > old_warehouse_revision \
		&& !estate.produce_resources(owner, FALSE, TRUE),
		"Processing changes the stock revision and cannot settle twice in \
		one daë"
	)
	var/list/catalogue = estate.getEstateWorkshopCatalogue()
	var/steel_greatsword = workshopOrderId(
		catalogue,
		/datum/anvil_recipe/weapons/steel/greatsword
	)
	var/steel_sword = workshopOrderId(
		catalogue,
		/datum/anvil_recipe/weapons/steel/sword
	)
	var/iron_sword = workshopOrderId(
		catalogue,
		/datum/anvil_recipe/weapons/iron/sword
	)
	check(
		workshopPointCost(catalogue, steel_greatsword) == 6 \
		&& workshopPointCost(catalogue, steel_sword) == 2 \
		&& workshopPointCost(catalogue, iron_sword) == 1,
		"Orders use actual ingot counts at two points per steel ingot and \
		one point per iron ingot"
	)

	var/revision = report?["revision"]
	var/mail_count = length(owner.mind.manor_packages)
	check(
		!estate.requestIndustryOrder(
			other,
			workshopTestOrder(steel_greatsword),
			revision
		),
		"Another character cannot use the estate balance"
	)
	check(
		!estate.requestIndustryOrder(
			owner,
			workshopTestOrder(steel_greatsword, steel_sword),
			revision
		) \
		&& estate.industry_points == 6,
		"A cart over the points budget is rejected without a partial debit"
	)
	check(
		estate.requestIndustryOrder(
			owner,
			workshopTestOrder(steel_greatsword),
			revision
		),
		"Six points can order a greatsword without three physical steel \
		ingots in the warehouse"
	)
	check(
		!estate.industry_points \
		&& estate.warehouse_stock[TRADE_GOOD_STEEL_INGOT] == 2 \
		&& length(owner.mind.manor_packages) == mail_count \
		&& !estate.requestIndustryOrder(
			owner,
			workshopTestOrder(steel_sword),
			revision
		),
		"A delayed shipment spends only points and cannot repeat"
	)
	check(
		estate.setIndustryMetal(owner, "smeltery", "iron") \
		&& !estate.setIndustryMetal(other, "forge", "iron"),
		"Only the owner can change the settings of each stage independently"
	)
	estate.industry_last_day = null
	var/list/mixed_result = estate.processIndustryHarvest(2)
	check(
		mixed_result?["ingot_surplus"] == 2 \
		&& estate.industry_points == 4 \
		&& !estate.warehouse_stock[TRADE_GOOD_STEEL_INGOT],
		"The forge doubles the points from stored steel without consuming \
		freshly smelted iron"
	)
	check(
		!estate.requestIndustryOrder(
			owner,
			workshopTestOrder(steel_sword),
			revision
		) \
		&& estate.industry_points == 4,
		"A replay from an old revision fails even after the point balance is \
		replenished"
	)
	check(
		estate.setIndustryMetal(owner, "forge", "iron") \
		&& estate.industry_points == 4,
		"Changing ingots preserves the common balance"
	)
	check(
		estate.requestIndustryOrder(
			owner,
			workshopTestOrder(steel_sword, iron_sword),
			estate.industry_revision
		) \
		&& estate.industry_points == 1,
		"A three-point mixed order can be funded entirely by steel production"
	)
	estate.industry_last_day = null
	estate.warehouse_stock[TRADE_GOOD_IRON_INGOT] = 3
	estate.processIndustryHarvest(0)
	check(
		estate.industry_points == 4 \
		&& !estate.warehouse_stock[TRADE_GOOD_IRON_INGOT],
		"Three iron ingots add three points to the same balance"
	)

	var/kriegmesser = workshopOrderId(
		getManorWorkshopRecipes(),
		/datum/anvil_recipe/weapons/steel/kriegmesser
	)
	check(
		kriegmesser != "missing_recipe",
		"The actual Kriegmesser recipe is registered"
	)
	estate.industry_origin_type = /datum/virtue/origin/azuria
	estate.industry_order_catalogue = null
	catalogue = estate.getEstateWorkshopCatalogue()
	check(
		!catalogue[kriegmesser] \
		&& catalogue[steel_sword] \
		&& !estate.requestIndustryOrder(
			owner,
			workshopTestOrder(kriegmesser),
			estate.industry_revision
		) \
		&& estate.industry_points == 4,
		"An unrelated origin cannot order a restricted recipe by supplying \
		its ID"
	)
	estate.industry_origin_type = /datum/virtue/origin/grenzelhoft
	estate.industry_order_catalogue = null
	catalogue = estate.getEstateWorkshopCatalogue()
	check(
		workshopPointCost(catalogue, kriegmesser) == 4 \
		&& catalogue[steel_sword],
		"Grenzelhoft receives its two-ingot Kriegmesser as well as ordinary \
		recipes"
	)
	check(
		estate.requestIndustryOrder(
			owner,
			workshopTestOrder(kriegmesser),
			estate.industry_revision
		) \
		&& !estate.industry_points,
		"The matching origin can order regional gear for the exact points cost"
	)

	var/list/ready_plan = list(
		"artisans" = 1,
		"finishers" = 1,
		"smeltery_metal" = "leatherwork",
		"forge_metal" = "leatherwork",
		"resource_unlocks" = list("trade" = list(TRADE_GOOD_CURED_LEATHER)),
	)
	owner.manor_industry_profiles = list("small" = ready_plan)
	var/datum/manor/ready_goods_estate = new
	allocated += ready_goods_estate
	owner.mind.set_owned_manor(ready_goods_estate)
	ready_goods_estate.manor_type = "mining_settlement"
	ready_goods_estate.on_creation(owner)
	var/list/direct_leather = (
		ready_goods_estate.industry_materials?["raw_[TRADE_GOOD_CURED_LEATHER]"]
	)
	check(
		direct_leather?["direct"] \
		&& ready_goods_estate.industry_smeltery_metal == "iron" \
		&& ready_goods_estate.industry_forge_metal == "iron",
		"Ready leather is known as a recipe input but cannot fund a forge"
	)
	check(
		!ready_goods_estate.setIndustryMetal(owner, "smeltery", "leatherwork") \
		&& !ready_goods_estate.setIndustryMetal(
			owner,
			"forge",
			"raw_[TRADE_GOOD_CURED_LEATHER]"
		),
		"Non-metals cannot be selected for either smithing stage"
	)
	var/list/smith_materials = taManorProfileMaterials(
		"mining_settlement",
		"smith",
		null,
		TRUE
	)
	var/non_metal_refining = FALSE
	for(var/material in smith_materials)
		var/list/smith_recipe = smith_materials[material]
		if(
			taManorIsRefiningMaterial(smith_materials, material) \
			&& !taManorCanFundWorkshop("smith", smith_recipe)
		)
			non_metal_refining = TRUE
			break
	check(
		!non_metal_refining,
		"Even with every resource available, the smeltery only refines metals"
	)
	var/list/ready_goods = list(TRADE_GOOD_CURED_LEATHER = 2)
	var/list/ready_settlement = ready_goods_estate.processManorProduction(
		ready_goods
	)
	check(
		islist(ready_settlement) \
		&& ready_goods[TRADE_GOOD_CURED_LEATHER] == 2 \
		&& !ready_goods_estate.industry_points,
		"The forge neither spends ready leather nor earns points for it"
	)
	var/list/ready_catalogue
	ready_catalogue = ready_goods_estate.getEstateWorkshopCatalogue()
	var/list/locked_sword = ready_catalogue[steel_sword]
	ready_goods_estate.industry_points = 10
	check(
		locked_sword?["locked"] \
		&& !ready_goods_estate.requestIndustryOrder(
			owner,
			workshopTestOrder(steel_sword),
			ready_goods_estate.industry_revision
		) \
		&& ready_goods_estate.industry_points == 10,
		"A steel recipe is visible before the upgrade and cannot be bought \
		with spare points"
	)

	owner.manor_industry_profiles = previous_profiles
	owner.manor_type_pref = previous_type
	owner.mind.set_owned_manor(previous_manor)
	owner.mind.assigned_role = previous_role

/datum/unit_test/local_nobility/proc/checkManorProductionChains(
	mob/living/carbon/human/owner
)
	var/list/batches = list(
		"manor_bread" = 4,
		"manor_jack_wine_regular" = 3,
		"manor_jack_wine" = 2,
		"manor_jack_wine_delectable" = 1,
		"manor_plum_wine_regular" = 3,
		"manor_plum_wine" = 2,
		"manor_plum_wine_delectable" = 1,
	)
	var/list/catalogue = getManorAdditionalCatalogue()
	var/list/old_bakery = taSanitizeManorIndustryProfile(
		"small",
		list(
			"processing_material" = "apple_pastry",
			"workshop_material" = "plum_pastry"
		),
		"manor"
	)
	check(
		old_bakery["processing_material"] == "flour" \
		&& old_bakery["workshop_material"] == "flour",
		"Old bakery plans fall back to flour"
	)
	for(var/id in batches)
		var/list/entry = catalogue[id]
		var/list/manifest = entry ? getManorRecipeManifest(entry) : null
		var/item_type = entry?["item_type"]
		check(
			manifest?[item_type] == batches[id],
			"An order of [id] contains the listed number of physical items"
		)
	var/previous_role = owner.mind.assigned_role
	owner.mind.assigned_role = "Adventurer"
	var/list/previous_profiles = owner.manor_industry_profiles
	var/previous_type = owner.manor_type_pref
	var/datum/manor/previous_manor = owner.mind.get_owned_manor()
	var/list/migrated = taSanitizeManorIndustryProfiles(
		list("small" = list("miners" = 1))
	)
	var/list/mining_profiles = migrated["mining_settlement"]
	var/list/migrated_small = mining_profiles?["small"]
	check(
		migrated_small?["miners"] == 1 && !migrated["manor"],
		"Existing mining plans migrate to their own type without creating \
		plans for others"
	)
	var/steel_sword = workshopOrderId(
		getManorWorkshopRecipes(),
		/datum/anvil_recipe/weapons/steel/sword
	)

	for(var/type_id in taManorTypeNames())
		var/list/lanes = getManorProductionLanes(type_id)
		for(var/lane_id in lanes)
			if(lane_id == "smith")
				continue
			var/list/lane = lanes[lane_id]
			var/list/materials = lane["materials"]
			var/list/plan = list(
				"specialization" = lane_id,
				"artisans" = 2,
				"processing_workers" = 1,
				"workshop_workers" = 1
			)
			owner.manor_type_pref = type_id
			owner.manor_industry_profiles = list()
			owner.manor_industry_profiles[type_id] = list("small" = plan)
			var/datum/manor/estate = new
			allocated += estate
			owner.mind.set_owned_manor(estate)
			estate.on_creation(owner)
			check(
				estate.industry_specialization == lane_id \
				&& estate.getAssignedArtisans() == 2 \
				&& estate.get_assigned_workers() <= estate.total_workers,
				"Production lane [lane_id] has both workstations and a valid \
				population"
			)
			if(lane_id == "fine_food")
				var/list/flour = estate.industry_materials["flour"]
				var/list/flour_inputs = flour?["inputs"]
				check(
					estate.industry_processing.material == "flour" \
					&& length(materials) == 1 \
					&& length(flour_inputs) == 1 \
					&& flour_inputs[TRADE_GOOD_GRAIN] == 1,
					"The mill refines one grain into flour without extra \
					ingredients"
				)
				var/list/bakery = estate.getEstateWorkshopCatalogue()
				var/has_tartlet = FALSE
				for(var/id in bakery)
					var/list/entry = bakery[id]
					if(
						ispath(
							entry["item_type"],
							/obj/item/reagent_containers/food/snacks/rogue/dot_tart
						)
					)
						has_tartlet = TRUE
						break
				check(
					!has_tartlet,
					"Neither curated nor generated tartlets are offered by \
					the bakery"
				)
				var/apple_pie = workshopOrderId(
					bakery,
					/datum/food_recipe/pie/apple
				)
				var/list/pie = bakery[apple_pie]
				check(
					pie && pie["material"] == "flour" && !pie["locked"],
					"A manor with grain and apples can order the finished \
					pie without butter or pre-made dough"
				)
			if(lane_id == "tailoring")
				estate.industry_workshop.workers_employed = 0
				var/list/one_hide = list(TRADE_GOOD_HIDE = 1)
				var/list/tanning = estate.processManorProduction(one_hide)
				check(
					!one_hide[TRADE_GOOD_HIDE] \
					&& tanning?["refined_good"] == TRADE_GOOD_CURED_LEATHER \
					&& tanning?["refined_units"] == 4,
					"The tannery turns one hide into four pieces of cured \
					leather"
				)
				estate.industry_workshop.workers_employed = 1
			for(var/material in materials)
				var/list/recipe = estate.industry_materials?[material]
				if(!recipe)
					continue
				var/list/inputs = recipe["inputs"]
				var/list/fresh_goods = list()
				for(var/good_id in inputs)
					fresh_goods[good_id] = inputs[good_id] * 2
					check(
						!!GLOB.trade_goods[good_id] \
						&& !!SSeconomy.find_stockpile_by_trade_good(good_id),
						"[material] has a real input [good_id]"
					)
				var/refined_good = recipe["refined_good"]
				check(
					!!GLOB.trade_goods[refined_good] \
					&& !!SSeconomy.find_stockpile_by_trade_good(refined_good),
					"[material] has a physical intermediate"
				)
				check(
					estate.setProductionMaterial(
						owner,
						"processing",
						material
					) \
					&& estate.setProductionMaterial(
						owner,
						"workshop",
						material
					),
					"Both stages can choose [material] independently"
				)
				estate.industry_last_day = null
				var/prior_credit = (
					estate.industry_points * SELLPRICE_IRON_INGOT \
					+ estate.industry_point_remainder
				)
				var/list/settlement = estate.processManorProduction(
					fresh_goods
				)
				var/new_credit = (
					estate.industry_points * SELLPRICE_IRON_INGOT \
					+ estate.industry_point_remainder
				)
				var/is_leather = lane_id == "tailoring" \
				&& material == "leatherwork"
				var/expected_consumed = is_leather ? 3 : 2
				var/expected_surplus = is_leather ? 5 : 0
				check(
					islist(settlement) \
					&& settlement["refined_units"] == expected_surplus \
					&& new_credit - prior_credit == expected_consumed \
						* taManorMaterialValue(recipe) \
					&& estate.industry_last_production["consumed"] \
						== expected_consumed,
					"[material] credits the exact workshop consumption and \
					leaves any surplus"
				)
			var/list/panel = estate.getIndustryPanelData()
			var/list/recipes = panel["recipes"]
			check(
				length(recipes) > 0 \
				&& !estate.requestIndustryOrder(
					owner,
					workshopTestOrder(steel_sword),
					estate.industry_revision
				),
				"Production lane [lane_id] exposes a catalogue and rejects \
				unrelated orders"
			)
			if(lane_id == "jewelry")
				estate.industry_points = 100
				check(
					!estate.requestIndustryOrder(
						owner,
						list("manor_porcelain_set" = 3),
						estate.industry_revision
					) \
					&& estate.industry_points == 100,
					"Shipment limit counts all physical pieces in porcelain \
					sets"
				)

	owner.manor_industry_profiles = previous_profiles
	owner.manor_type_pref = previous_type
	owner.mind.set_owned_manor(previous_manor)
	owner.mind.assigned_role = previous_role

/datum/unit_test/local_nobility/proc/checkEstateNews()
	var/list/saved_queues = GLOB.ta_estate_news_remaining
	GLOB.ta_estate_news_remaining = list()
	var/datum/manor/first = new
	var/datum/manor/second = new
	allocated += list(first, second)

	var/list/common_news = GLOB.ta_estate_common_news
	var/list/seen = list()
	for(var/index in 1 to length(common_news))
		var/datum/manor/estate = index % 2 ? first : second
		var/news = estate.pickEstateNews("test_unknown_culture")
		check(
			(news in common_news) && !(news in seen),
			"The common pool does not repeat across different manors before \
			exhaustion"
		)
		seen += news
	var/previous_news = first.last_estate_news
	check(
		first.pickEstateNews("test_unknown_culture") != previous_news,
		"Refilling the common pool avoids an immediate repeat"
	)

	GLOB.ta_estate_news_remaining["common"] = list(common_news[1])
	first.last_estate_news = common_news[1]
	check(
		first.pickEstateNews("test_unknown_culture") != common_news[1],
		"A blocked last story is kept for a different recipient"
	)
	check(
		length(GLOB.ta_estate_news_remaining["common"]) == 1,
		"The fallback does not consume another recipient's unclaimed news"
	)

	first.last_estate_news = null
	second.last_estate_news = null
	var/list/raneshen_news = GLOB.ta_estate_cultural_news["raneshen"]
	var/first_dispatch = first.pickEstateNews("raneshen")
	var/second_dispatch = second.pickEstateNews("raneshen")
	check(
		(first_dispatch in raneshen_news) \
		&& (second_dispatch in raneshen_news) \
		&& first_dispatch != second_dispatch,
		"Different estates first get distinct stories from their own culture"
	)
	first.last_estate_news = null
	check(
		first.pickEstateNews("kazengun") \
			in GLOB.ta_estate_cultural_news["kazengun"],
		"Kazengun receives its own pool of local stories"
	)

	GLOB.ta_estate_news_remaining = saved_queues
