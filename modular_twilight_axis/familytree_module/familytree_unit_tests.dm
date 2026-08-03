#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)

#define FT_SOURCE replacetext(__FILE__, "\\", "/")
#define FT_ASSERT(assertion, reason) if(!(assertion)) { return Fail("Assertion failed: [reason || "no reason"]", FT_SOURCE, __LINE__) }
#define FT_ASSERT_EQUAL(a, b, reason) do { var/_lhs = ##a; var/_rhs = ##b; if(_lhs != _rhs) { return Fail("Expected [isnull(_lhs) ? "null" : _lhs] == [isnull(_rhs) ? "null" : _rhs]: [reason || "no reason"]", FT_SOURCE, __LINE__) } } while(FALSE)
#define FT_ASSERT_NOTNULL(a, reason) if(isnull(a)) { return Fail("Expected non-null: [reason || "no reason"]", FT_SOURCE, __LINE__) }
#define FT_ASSERT_NULL(a, reason) if(!isnull(a)) { return Fail("Expected null: [reason || "no reason"]", FT_SOURCE, __LINE__) }

/datum/unit_test/familytree
	abstract_type = /datum/unit_test/familytree
	var/static/ft_test_serial = 0
	var/list/ft_test_houses

/datum/unit_test/familytree/proc/ft_spawn_player(family_pref = FAMILY_PARTIAL, relative_role = RELATIVE_ANY, synthetic_ckey = TRUE)
	var/turf/spot = run_loc_floor_bottom_left
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human, spot)
	if(!H)
		return null
	ft_test_serial++
	if(synthetic_ckey)
		H.ckey = "FTTEST_[ft_test_serial]"
		if(!H.mind)
			H.mind = new /datum/mind(H.ckey)
	H.familytree_pref = family_pref
	H.desired_relative_role = relative_role
	H.setspouse = ""
	return H

/datum/unit_test/familytree/proc/ft_track_house(datum/heritage/house)
	if(!house)
		return
	LAZYADD(ft_test_houses, house)

/datum/unit_test/familytree/Destroy()
	for(var/datum/heritage/house as anything in ft_test_houses)
		SSfamilytree.families -= house
	ft_test_houses = null
	return ..()

/datum/unit_test/familytree/pref_masks/Run()
	FT_ASSERT_EQUAL(familytree_pref_mask(FAMILY_NONE), FAMILYTREE_MODE_DISABLED, "FAMILY_NONE must resolve to a disabled mask")
	FT_ASSERT(!familytree_pref_enabled(FAMILY_NONE), "FAMILY_NONE must not be treated as enabled")

	var/partial_mask = familytree_pref_mask(FAMILY_PARTIAL)
	FT_ASSERT(partial_mask & FAMILYTREE_MODE_JOIN, "FAMILY_PARTIAL must include JOIN")
	FT_ASSERT(partial_mask & FAMILYTREE_MODE_CREATE, "FAMILY_PARTIAL must include CREATE")

	FT_ASSERT_EQUAL(familytree_pref_mask(FAMILY_FULL), FAMILYTREE_MODE_LEGACY_SPOUSE, "FAMILY_FULL must map to the legacy spouse mode")
	FT_ASSERT(familytree_pref_is_create(FAMILY_PARTIAL), "FAMILY_PARTIAL must count as a create-capable pref")
	FT_ASSERT(!familytree_pref_is_join_only(FAMILY_PARTIAL), "FAMILY_PARTIAL is join+create, never join-only")

/datum/unit_test/familytree/forced_role_mapping/Run()
	FT_ASSERT_EQUAL(SSfamilytree.familytree_forced_role_from_relative_role(RELATIVE_SIBLING), "sibling", "sibling role mapping drifted")
	FT_ASSERT_EQUAL(SSfamilytree.familytree_forced_role_from_relative_role(RELATIVE_PARENT), "parent", "parent role mapping drifted")
	FT_ASSERT_EQUAL(SSfamilytree.familytree_forced_role_from_relative_role(RELATIVE_CHILD), "child", "child role mapping drifted")
	FT_ASSERT_EQUAL(SSfamilytree.familytree_forced_role_from_relative_role(RELATIVE_UNCLE_AUNT), "uncle_aunt", "uncle/aunt role mapping drifted")
	FT_ASSERT_NULL(SSfamilytree.familytree_forced_role_from_relative_role(RELATIVE_ANY), "RELATIVE_ANY must not force a role")
	FT_ASSERT_NULL(SSfamilytree.familytree_forced_role_from_relative_role(RELATIVE_SPOUSE), "spouse is handled by the newlywed path, not a forced relative role")

/datum/unit_test/familytree/round_prefs_capture/Run()
	var/mob/living/carbon/human/H = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_SIBLING)
	FT_ASSERT_NOTNULL(H, "could not allocate a test human")

	FT_ASSERT(!SSfamilytree.familytree_has_round_prefs(H), "a fresh mob must not have round prefs before capture")

	var/datum/familytree_prefs/locked = SSfamilytree.familytree_get_round_prefs(H, TRUE)
	FT_ASSERT_NOTNULL(locked, "round prefs must be created on demand for a test ckey")
	FT_ASSERT(SSfamilytree.familytree_has_round_prefs(H), "round prefs must be discoverable after capture")
	FT_ASSERT_EQUAL(locked.family_pref, FAMILY_PARTIAL, "captured family pref must match the mob at capture time")
	FT_ASSERT_EQUAL(locked.desired_relative_role, RELATIVE_SIBLING, "captured relative role must match the mob at capture time")
	FT_ASSERT_EQUAL(locked.owner_ckey, H.ckey, "round prefs must remember their owner ckey")

/datum/unit_test/familytree/round_prefs_are_immutable/Run()
	var/mob/living/carbon/human/H = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_SIBLING)
	FT_ASSERT_NOTNULL(H, "could not allocate a test human")

	var/datum/familytree_prefs/locked = SSfamilytree.familytree_get_round_prefs(H, TRUE)
	FT_ASSERT_NOTNULL(locked, "round prefs must be created before the tamper check")

	H.familytree_pref = FAMILY_FULL
	H.desired_relative_role = RELATIVE_SPOUSE
	H.setspouse = "Someone Else"

	SSfamilytree.load_familytree_runtime_preferences(H, null)

	FT_ASSERT_EQUAL(H.familytree_pref, FAMILY_PARTIAL, "runtime load must restore the locked family pref, not keep tampered state")
	FT_ASSERT_EQUAL(H.desired_relative_role, RELATIVE_SIBLING, "runtime load must restore the locked relative role")
	FT_ASSERT_EQUAL(H.setspouse, "", "runtime load must restore the locked spouse target; this is the relog exploit guard")
	FT_ASSERT_EQUAL(locked.desired_relative_role, RELATIVE_SIBLING, "the datum itself must never absorb tampered mob state")

/datum/unit_test/familytree/round_prefs_survive_new_body/Run()
	var/mob/living/carbon/human/first_body = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_CHILD)
	FT_ASSERT_NOTNULL(first_body, "could not allocate the first test human")

	var/datum/familytree_prefs/locked = SSfamilytree.familytree_get_round_prefs(first_body, TRUE)
	FT_ASSERT_NOTNULL(locked, "round prefs must be created for the first body")

	var/mob/living/carbon/human/second_body = ft_spawn_player(FAMILY_NONE, RELATIVE_ANY)
	FT_ASSERT_NOTNULL(second_body, "could not allocate the second test human")
	second_body.ckey = first_body.ckey

	var/datum/familytree_prefs/resolved = SSfamilytree.familytree_get_round_prefs(second_body, FALSE)
	FT_ASSERT_EQUAL(resolved, locked, "the same ckey must resolve the same locked datum in a new body")

	resolved.apply_to(second_body)
	FT_ASSERT_EQUAL(second_body.desired_relative_role, RELATIVE_CHILD, "a new body must inherit the locked role, not its own fresh state")

/datum/unit_test/familytree/round_prefs_required_for_matching/Run()
	var/mob/living/carbon/human/H = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_ANY, synthetic_ckey = FALSE)
	FT_ASSERT_NOTNULL(H, "could not allocate a test human")
	H.ckey = null

	FT_ASSERT(!SSfamilytree.familytree_has_round_prefs(H), "a mob with no ckey must never own round prefs")
	FT_ASSERT_NULL(SSfamilytree.familytree_get_round_prefs(H, TRUE), "round prefs must not be synthesised for a mob with no player")

	SSfamilytree.AddLocal(H, FAMILY_PARTIAL)
	FT_ASSERT_NULL(H.family_datum, "AddLocal must refuse to service a mob without round prefs")

/datum/unit_test/familytree/round_prefs_setspouse_reset/Run()
	var/mob/living/carbon/human/H = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_ANY)
	FT_ASSERT_NOTNULL(H, "could not allocate a test human")
	H.setspouse = "Target Name"

	var/datum/familytree_prefs/locked = SSfamilytree.familytree_get_round_prefs(H, TRUE)
	FT_ASSERT_NOTNULL(locked, "round prefs must be created before the reset check")
	FT_ASSERT_EQUAL(locked.setspouse, "Target Name", "the locked datum must carry the spouse target")

	locked.clear_setspouse()
	locked.apply_to(H)
	FT_ASSERT_EQUAL(H.setspouse, "", "clearing the target on the datum must reach the mob, otherwise the timeout reset silently rolls back")

/datum/unit_test/familytree/log_level_defaults_to_debug/Run()
	var/was_verbose = SSfamilytree.verbose_logging
	SSfamilytree.verbose_logging = FALSE

	var/before = SSfamilytree.ftlog_counter
	SSfamilytree.ftlog("familytree unit test: this tracing line must stay silent")
	var/after_default = SSfamilytree.ftlog_counter

	SSfamilytree.ftlog("familytree unit test: this outcome line must be written", FTLOG_INFO)
	var/after_info = SSfamilytree.ftlog_counter

	SSfamilytree.verbose_logging = was_verbose

	FT_ASSERT_EQUAL(after_default, before, "ftlog() must default to DEBUG and stay silent while verbose logging is off")
	FT_ASSERT_EQUAL(after_info, before + 1, "an explicit INFO line must always be written")

/datum/unit_test/familytree/house_target_count_math/Run()
	var/target = SSfamilytree.familytree_target_player_house_count()
	FT_ASSERT(target >= 1, "the target house count must never drop below one")

	var/online = SSfamilytree.familytree_online_player_count()
	var/expected = max(1, CEILING(online / FAMILYTREE_PLAYERS_PER_TARGET_HOUSE, 1))
	FT_ASSERT_EQUAL(target, expected, "target house count must stay tied to the online population")

	var/active = SSfamilytree.familytree_active_player_house_count()
	FT_ASSERT(active >= 0, "the active house count must never be negative")

/datum/unit_test/familytree/found_house_chain/Run()
	var/mob/living/carbon/human/H = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_ANY)
	FT_ASSERT_NOTNULL(H, "could not allocate a test human")
	FT_ASSERT_NOTNULL(SSfamilytree.familytree_get_round_prefs(H, TRUE), "round prefs must exist before founding a house")

	var/datum/heritage/house = SSfamilytree.familytree_found_new_house(H, "unit test house")
	ft_track_house(house)

	FT_ASSERT_NOTNULL(house, "founding a new house must return the heritage datum")
	FT_ASSERT_EQUAL(H.family_datum, house, "the founder must be bound to the house they founded")
	FT_ASSERT_NOTNULL(house.founder, "a founded house must record its founder")
	FT_ASSERT_NOTNULL(house.house_leader, "a founded house must always have a leader")
	FT_ASSERT(house.member_nodes.len >= 1, "a founded house must contain at least the founder as a graph node")
	FT_ASSERT(house in SSfamilytree.families, "a founded house must be registered with the subsystem")
	FT_ASSERT(!H.familytree_assignment_scheduled, "founding a house must stop the assignment loop for that player")

/datum/unit_test/familytree/house_accepts_relative/Run()
	var/mob/living/carbon/human/founder = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_ANY)
	FT_ASSERT_NOTNULL(founder, "could not allocate the founder")
	FT_ASSERT_NOTNULL(SSfamilytree.familytree_get_round_prefs(founder, TRUE), "founder needs round prefs")

	var/datum/heritage/house = SSfamilytree.familytree_found_new_house(founder, "unit test house")
	ft_track_house(house)
	FT_ASSERT_NOTNULL(house, "could not found the host house")

	var/starting_members = house.member_nodes.len

	var/mob/living/carbon/human/relative = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_SIBLING)
	FT_ASSERT_NOTNULL(relative, "could not allocate the joining relative")
	FT_ASSERT_NOTNULL(SSfamilytree.familytree_get_round_prefs(relative, TRUE), "joining relative needs round prefs")

	SSfamilytree.AddPersonToHouse(house, relative, FALSE, "sibling")

	FT_ASSERT_EQUAL(relative.family_datum, house, "a person added to a house must be bound to it")
	FT_ASSERT(house.member_nodes.len > starting_members, "adding a relative must grow the house graph")
	FT_ASSERT_NOTNULL(relative.family_member_datum, "a joined person must own a family member datum")

/datum/unit_test/familytree/wake_ignores_clientless_seekers/Run()
	var/mob/living/carbon/human/founder = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_ANY)
	FT_ASSERT_NOTNULL(founder, "could not allocate the founder")
	FT_ASSERT_NOTNULL(SSfamilytree.familytree_get_round_prefs(founder, TRUE), "founder needs round prefs")

	var/datum/heritage/house = SSfamilytree.familytree_found_new_house(founder, "unit test house")
	ft_track_house(house)
	FT_ASSERT_NOTNULL(house, "could not found the host house")

	var/mob/living/carbon/human/waiter = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_ANY)
	FT_ASSERT_NOTNULL(waiter, "could not allocate the waiting seeker")
	FT_ASSERT_NOTNULL(SSfamilytree.familytree_get_round_prefs(waiter, TRUE), "waiting seeker needs round prefs")
	waiter.familytree_module_signal_bound = TRUE
	waiter.familytree_assignment_scheduled = TRUE
	waiter.familytree_wake_timerid = null
	waiter.familytree_next_wake_time = 0

	SSfamilytree.wake_waiting_relative_seekers(house)
	SSfamilytree.wake_waiting_relative_seekers(house)

	FT_ASSERT_NULL(waiter.familytree_wake_timerid, "a seeker with no live client must never be woken; the wake loop only serves real players")
	FT_ASSERT_EQUAL(waiter.familytree_next_wake_time, 0, "a skipped seeker must not have a cooldown armed either")

/datum/unit_test/familytree/wake_runner_clears_its_timer/Run()
	var/mob/living/carbon/human/seeker = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_ANY)
	FT_ASSERT_NOTNULL(seeker, "could not allocate the seeker")
	FT_ASSERT_NOTNULL(SSfamilytree.familytree_get_round_prefs(seeker, TRUE), "seeker needs round prefs")

	seeker.familytree_wake_timerid = "fake_timer_id"
	SSfamilytree.familytree_run_wake_assignment(seeker)
	FT_ASSERT_NULL(seeker.familytree_wake_timerid, "the wake runner must release its timer id so the next wake is allowed to arm one")

	var/mob/living/carbon/human/settled = ft_spawn_player(FAMILY_PARTIAL, RELATIVE_ANY)
	FT_ASSERT_NOTNULL(settled, "could not allocate the settled player")
	FT_ASSERT_NOTNULL(SSfamilytree.familytree_get_round_prefs(settled, TRUE), "settled player needs round prefs")

	var/datum/heritage/house = SSfamilytree.familytree_found_new_house(settled, "unit test house")
	ft_track_house(house)
	FT_ASSERT_NOTNULL(house, "could not found the house for the settled player")

	settled.familytree_wake_timerid = "fake_timer_id"
	settled.familytree_assignment_scheduled = TRUE
	SSfamilytree.familytree_run_wake_assignment(settled)
	FT_ASSERT_NULL(settled.familytree_wake_timerid, "the wake runner must always release its timer id")
	FT_ASSERT_EQUAL(settled.family_datum, house, "a player who already has a family must not be re-matched by a stale wake")

/datum/unit_test/familytree/dummy_is_never_tracked/Run()
	var/turf/spot = run_loc_floor_bottom_left
	var/mob/living/carbon/human/dummy/mannequin = allocate(/mob/living/carbon/human/dummy, spot)
	FT_ASSERT_NOTNULL(mannequin, "could not allocate the preview dummy")

	FT_ASSERT(!mannequin.familytree_module_signal_bound, "preview dummies must never get subsystem signals bound")
	FT_ASSERT(!SSfamilytree.familytree_has_round_prefs(mannequin), "a dummy must never own round prefs")
	FT_ASSERT_NULL(mannequin.family_datum, "a dummy must never be given a family")

	SSfamilytree.on_mob_created(null, mannequin)

	FT_ASSERT(!mannequin.familytree_module_signal_bound, "a replayed creation signal must not bind a dummy either")

/datum/unit_test/familytree/fresh_body_is_tracked/Run()
	var/turf/spot = run_loc_floor_bottom_left
	var/mob/living/carbon/human/body = allocate(/mob/living/carbon/human, spot)
	FT_ASSERT_NOTNULL(body, "could not allocate the fresh body")

	FT_ASSERT_NULL(body.ckey, "a body straight out of new() owns no ckey yet, exactly like create_character()")
	FT_ASSERT_NULL(body.mind, "a body straight out of new() owns no mind yet")
	FT_ASSERT_NULL(body.client, "a body straight out of new() owns no client yet")
	FT_ASSERT_NULL(body.job, "a body straight out of new() owns no job yet")

	FT_ASSERT(body.familytree_module_signal_bound, "COMSIG_GLOB_MOB_CREATED fires as the first line of /mob/Initialize(), so ckey/client/mind/job are all null for every player character; gating registration on them drops every single player and nothing rebinds them later")

#undef FT_SOURCE
#undef FT_ASSERT
#undef FT_ASSERT_EQUAL
#undef FT_ASSERT_NOTNULL
#undef FT_ASSERT_NULL

#endif
