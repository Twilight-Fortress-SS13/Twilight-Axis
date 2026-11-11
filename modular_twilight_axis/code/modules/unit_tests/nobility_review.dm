/datum/unit_test/local_nobility_review

/datum/unit_test/local_nobility_review/Run()
	checkNativeQuirk()
	checkInterruptedSetup()
	checkManorAccess()
	checkDomesticStress()

/datum/unit_test/local_nobility_review/proc/checkDomesticStress()
	var/mob/living/carbon/human/nobility_fixture/owner = allocate(
		/mob/living/carbon/human/nobility_fixture,
	)
	owner.prepareFixture("Stress Review")
	TEST_ASSERT(owner.taSelectNobility(2), "The fixture is a wealthy noble")
	allocated += owner.mind.get_owned_manor()
	var/datum/stressevent/hungry/hunger = new
	allocated += hunger
	TEST_ASSERT_EQUAL(hunger.get_stress(owner), 3.75, \
		"The modular override preserves the domestic multiplier")
	ADD_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_GENERIC)
	TEST_ASSERT_EQUAL(hunger.get_stress(owner), 7.5, \
		"Bad Mood still applies exactly once")
	ADD_TRAIT(owner, TRAIT_EORAN_SERENE, TRAIT_GENERIC)
	TEST_ASSERT_EQUAL(hunger.get_stress(owner), -7.5, \
		"Eoran Serene still reverses the complete stress value")
	ADD_TRAIT(owner, TRAIT_NOMOOD, TRAIT_GENERIC)
	TEST_ASSERT_EQUAL(hunger.get_stress(owner), 0, \
		"The parent calculation still respects No Mood")

/datum/unit_test/local_nobility_review/proc/checkNativeQuirk()
	var/list/role_tiers = list("Knight" = 2, "Hand" = 3, "Prince" = 3)
	for(var/role in role_tiers)
		var/mob/living/carbon/human/nobility_fixture/owner = allocate(
			/mob/living/carbon/human/nobility_fixture,
		)
		owner.mind_initialize()
		owner.job = role
		owner.mind.assigned_role = role
		ADD_TRAIT(owner, TRAIT_NOBLE, JOB_TRAIT)
		var/datum/quirk/noble/quirk = new
		apply_quirk(owner, quirk)
		qdel(quirk)
		TEST_ASSERT(!HAS_TRAIT(owner, TRAIT_NOBLE_UNLANDED), \
			"[role]'s native estate takes priority over Unlanded Noble")
		var/original_triumphs = owner.get_triumphs()
		owner.taFinishNobility()
		var/datum/manor/estate = owner.mind.get_owned_manor()
		TEST_ASSERT(estate, "[role] receives a native estate")
		TEST_ASSERT_EQUAL(owner.mind.ta_nobility_tier, role_tiers[role], \
			"[role] retains its native tier")
		TEST_ASSERT_EQUAL(owner.get_triumphs(), original_triumphs, \
			"A native estate does not charge triumphs")
		if(estate)
			allocated += estate

	var/mob/living/carbon/human/nobility_fixture/landless = allocate(
		/mob/living/carbon/human/nobility_fixture,
	)
	landless.prepareFixture("Landless Review", TRUE)
	landless.taFinishNobility()
	TEST_ASSERT(HAS_TRAIT(landless, TRAIT_NOBLE_UNLANDED), \
		"Unlanded Noble still applies outside native noble roles")
	TEST_ASSERT_EQUAL(landless.mind.ta_nobility_tier, 0, \
		"An ordinary Unlanded Noble remains T0")
	TEST_ASSERT(!landless.mind.get_owned_manor(), \
		"An ordinary Unlanded Noble has no estate")

/datum/unit_test/local_nobility_review/proc/checkInterruptedSetup()
	var/mob/living/carbon/human/nobility_fixture/owner = allocate(
		/mob/living/carbon/human/nobility_fixture,
	)
	owner.prepareFixture("Interrupted Review")
	var/items_before = length(owner.mind.special_items)
	owner.taFinishNobility()
	TEST_ASSERT(owner.mind.ta_nobility_pending, \
		"Setup without a connected client preserves the estate choice")
	TEST_ASSERT(!owner.mind.ta_nobility_setup_running, \
		"Disconnected setup releases the running guard")
	TEST_ASSERT(!owner.mind.get_owned_manor(), \
		"Interrupted setup does not create an estate before a choice")
	TEST_ASSERT(owner.taSelectNobility(2), \
		"The preserved choice can still be completed")
	var/datum/manor/estate = owner.mind.get_owned_manor()
	if(estate)
		allocated += estate
	var/triumphs_after = owner.get_triumphs()
	owner.taFinishNobility()
	owner.taResumeNobility()
	TEST_ASSERT_EQUAL(owner.mind.get_owned_manor(), estate, \
		"Resumption cannot create a second estate")
	TEST_ASSERT_EQUAL(owner.get_triumphs(), triumphs_after, \
		"Resumption cannot charge twice")
	TEST_ASSERT_EQUAL(owner.mind.ta_nobility_virtue_picks, 1, \
		"Resumption does not reapply Nobility")
	TEST_ASSERT_EQUAL(length(owner.mind.special_items), items_before, \
		"Resumption does not reissue heirlooms")
	owner.taFinishNobilityTitle()
	var/title_before = owner.mind.ta_nobility_title_id
	owner.mind.ta_nobility_title_resume = TRUE
	owner.taFinishNobilityTitle(TRUE)
	TEST_ASSERT(owner.mind.ta_nobility_title_resume, \
		"An interrupted title remains resumable while disconnected")
	TEST_ASSERT_EQUAL(owner.mind.ta_nobility_title_id, title_before, \
		"An interrupted title retains the working default")
	owner.mind.ta_nobility_title_resume = FALSE

	// Queue while connected, then model losing the client before the callback.
	owner.mind.ta_nobility_title_id = null
	owner.taQueueNobilityTitle(TRUE)
	owner.taFinishNobilityTitle()
	TEST_ASSERT(owner.mind.ta_nobility_title_resume, \
		"Disconnect before the title callback preserves the queued choice")
	TEST_ASSERT_NULL(owner.mind.ta_nobility_title_id, \
		"A queued interactive choice cannot silently become a default title")
	owner.mind.ta_nobility_title_resume = FALSE

/datum/unit_test/local_nobility_review/proc/checkManorAccess()
	var/mob/living/carbon/human/nobility_fixture/owner = allocate(
		/mob/living/carbon/human/nobility_fixture,
	)
	owner.prepareFixture("Access Review")
	TEST_ASSERT(owner.taSelectNobility(1), "Access fixture has an estate")
	var/datum/manor/estate = owner.mind.get_owned_manor()
	if(!estate)
		return
	allocated += estate
	TEST_ASSERT(taCanManageManor(owner, estate), \
		"A conscious owner can manage their estate")
	TEST_ASSERT(estate.setWarehouseSale(owner, "raw", 50), \
		"A conscious owner can change the sale share")
	owner.forceMove(run_loc_floor_top_right)
	TEST_ASSERT(taCanManageManor(owner, estate), \
		"Estate management does not acquire a new HERMES distance rule")
	var/list/states = list(UNCONSCIOUS, DEAD)
	for(var/state in states)
		owner.set_stat(state)
		TEST_ASSERT(!taCanManageManor(owner, estate), \
			"An unconscious or dead owner cannot manage an estate")
		TEST_ASSERT(!estate.setWarehouseSale(owner, "raw", 100), \
			"An unconscious or dead owner cannot change stock policy")
		TEST_ASSERT_EQUAL(estate.warehouse_raw_sale, 50, \
			"Rejected management leaves the stock policy unchanged")
	owner.set_stat(CONSCIOUS)
	owner.SetStun(5 SECONDS)
	TEST_ASSERT(!taCanManageManor(owner, estate), \
		"A stunned owner cannot manage an estate")
	owner.SetStun(0)
	TEST_ASSERT(taCanManageManor(owner, estate), \
		"Management becomes available after recovery")
	var/mob/living/carbon/human/stranger = allocate(
		/mob/living/carbon/human,
	)
	stranger.mind_initialize()
	TEST_ASSERT(!taCanManageManor(stranger, estate), \
		"A conscious stranger cannot manage another person's estate")
	owner.mind.current = null
	TEST_ASSERT(!taCanManageManor(owner, estate), \
		"An abandoned body cannot manage its former owner's estate")
	owner.mind.current = owner
