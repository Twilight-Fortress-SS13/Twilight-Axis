#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)

#define AT_SOURCE replacetext(__FILE__, "\\", "/")
#define AT_ASSERT(assertion, reason) if(!(assertion)) { return Fail("Assertion failed: [reason || "no reason"]", AT_SOURCE, __LINE__) }
#define AT_ASSERT_EQUAL(a, b, reason) do { var/_lhs = ##a; var/_rhs = ##b; if(_lhs != _rhs) { return Fail("Expected [isnull(_lhs) ? "null" : _lhs] == [isnull(_rhs) ? "null" : _rhs]: [reason || "no reason"]", AT_SOURCE, __LINE__) } } while(FALSE)
#define AT_ASSERT_NULL(a, reason) if(!isnull(a)) { return Fail("Expected null: [reason || "no reason"]", AT_SOURCE, __LINE__) }

/datum/unit_test/ataman
	abstract_type = /datum/unit_test/ataman

/datum/unit_test/ataman/proc/at_turf(dx, dy)
	var/turf/origin = run_loc_floor_bottom_left
	return locate(origin.x + dx, origin.y + dy, origin.z)

/datum/unit_test/ataman/flank_angle_convention/Run()
	var/turf/centre = at_turf(0, 0)
	for(var/dx in -1 to 1)
		for(var/dy in -1 to 1)
			AT_ASSERT(at_turf(dx, dy), "the test area must have a turf at offset [dx],[dy]")
	AT_ASSERT_EQUAL(ataman_flank_angle_of(centre, at_turf(1, 0)), 0, "east of the target must read as 0 degrees")
	AT_ASSERT_EQUAL(ataman_flank_angle_of(centre, at_turf(0, 1)), 90, "north of the target must read as 90 degrees")
	AT_ASSERT_EQUAL(ataman_flank_angle_of(centre, at_turf(-1, 0)), 180, "west of the target must read as 180 degrees")
	AT_ASSERT_EQUAL(ataman_flank_angle_of(centre, at_turf(0, -1)), 270, "south of the target must read as 270 degrees")
	AT_ASSERT_EQUAL(ataman_flank_angle_of(centre, at_turf(1, 1)), 45, "north-east of the target must read as 45 degrees")
	AT_ASSERT_NULL(ataman_flank_angle_of(centre, centre), "an ally standing on the target has no angle")

/datum/unit_test/ataman/flank_angle_delta/Run()
	AT_ASSERT_EQUAL(ataman_flank_angle_delta(350, 10), 20, "angle delta must wrap across zero")
	AT_ASSERT_EQUAL(ataman_flank_angle_delta(10, 350), 20, "angle delta must be symmetric")
	AT_ASSERT_EQUAL(ataman_flank_angle_delta(0, 180), 180, "opposite angles are 180 apart")
	AT_ASSERT_EQUAL(ataman_flank_angle_delta(90, 90), 0, "identical angles have no delta")
	AT_ASSERT(ataman_flank_angle_delta(359, 1) <= ATAMAN_FLANK_ANGLE_DRIFT, "a two degree drift across zero must not force a recalculation")

/datum/unit_test/ataman/flank_widest_gap/Run()
	AT_ASSERT_NULL(ataman_flank_widest_gap(list()), "no allies means no gap to measure")

	var/list/lone = ataman_flank_widest_gap(list(0))
	AT_ASSERT_EQUAL(lone[1], 0, "a lone ally anchors the gap at its own angle")
	AT_ASSERT_EQUAL(lone[2], 360, "a lone ally leaves the whole circle open")

	var/list/stacked = ataman_flank_widest_gap(list(90, 90))
	AT_ASSERT_EQUAL(stacked[2], 360, "allies stacked on one angle also leave the whole circle open")

	var/list/spread = ataman_flank_widest_gap(list(0, 20, 100))
	AT_ASSERT_EQUAL(spread[1], 100, "the widest gap must start at the last ally before it")
	AT_ASSERT_EQUAL(spread[2], 260, "the widest gap must wrap from 100 back around to 0")

	var/list/ringed = ataman_flank_widest_gap(list(0, 45, 90, 135, 180, 225, 270, 315))
	AT_ASSERT_EQUAL(ringed[2], 45, "an evenly ringed target leaves only 45 degree gaps")

/datum/unit_test/ataman/flank_no_allies/Run()
	AT_ASSERT_NULL(ataman_flank_pick_angle(list()), "with nobody else on the target there is nothing to flank around")

/datum/unit_test/ataman/flank_single_ally/Run()
	AT_ASSERT_EQUAL(ataman_flank_pick_angle(list(0)), 180, "a lone ally to the east must send us west")
	AT_ASSERT_EQUAL(ataman_flank_pick_angle(list(90)), 270, "a lone ally to the north must send us south")
	AT_ASSERT_EQUAL(ataman_flank_pick_angle(list(270)), 90, "a lone ally to the south must send us north")

/datum/unit_test/ataman/flank_stacked_allies/Run()
	AT_ASSERT_EQUAL(ataman_flank_pick_angle(list(90, 90)), 270, "allies bunched on one angle must still send us opposite")

/datum/unit_test/ataman/flank_numeric_sort/Run()
	var/chosen = ataman_flank_pick_angle(list(0, 20, 100))
	AT_ASSERT_EQUAL(chosen, 230, "angles must be ordered numerically, not as text")
	AT_ASSERT(ataman_flank_angle_delta(chosen, 0) >= ATAMAN_FLANK_MIN_SEPARATION, "the chosen angle must clear the ally at 0")
	AT_ASSERT(ataman_flank_angle_delta(chosen, 20) >= ATAMAN_FLANK_MIN_SEPARATION, "the chosen angle must clear the ally at 20")
	AT_ASSERT(ataman_flank_angle_delta(chosen, 100) >= ATAMAN_FLANK_MIN_SEPARATION, "the chosen angle must clear the ally at 100")

/datum/unit_test/ataman/flank_opposed_pair/Run()
	var/chosen = ataman_flank_pick_angle(list(0, 180))
	AT_ASSERT(chosen == 90 || chosen == 270, "two opposed allies leave two equal gaps, both perpendicular")

/datum/unit_test/ataman/flank_surrounded/Run()
	AT_ASSERT_NULL(ataman_flank_pick_angle(list(0, 45, 90, 135, 180, 225, 270, 315)), "a fully ringed target leaves no gap worth walking to")

/datum/unit_test/ataman/flank_gap_is_widest/Run()
	var/list/allies = list(10, 30, 50, 200)
	var/chosen = ataman_flank_pick_angle(allies)
	for(var/ally_angle in allies)
		AT_ASSERT(ataman_flank_angle_delta(chosen, ally_angle) >= ATAMAN_FLANK_MIN_SEPARATION, "chosen angle [chosen] crowds the ally at [ally_angle]")

/datum/unit_test/ataman/squad_roster_tracks_living/Run()
	var/datum/ataman_squad/squad = new
	var/mob/living/carbon/human/first = allocate(/mob/living/carbon/human, at_turf(0, 0))
	var/mob/living/carbon/human/second = allocate(/mob/living/carbon/human, at_turf(1, 0))
	squad.register_member(first)
	squad.register_member(second)
	AT_ASSERT_EQUAL(length(squad.get_members()), 2, "both living bandits must count as members")
	second.death()
	AT_ASSERT_EQUAL(length(squad.get_members()), 1, "a dead bandit must stop counting as a member")
	AT_ASSERT_EQUAL(length(squad.member_refs), 2, "the corpse must stay on the roster so teardown can still reach it")
	AT_ASSERT(!QDELETED(squad), "the squad must survive while one bandit is still standing")
	qdel(squad)

/datum/unit_test/ataman/squad_registers_each_member_once/Run()
	var/datum/ataman_squad/squad = new
	var/mob/living/carbon/human/bandit = allocate(/mob/living/carbon/human, at_turf(0, 0))
	squad.register_member(bandit)
	squad.register_member(bandit)
	AT_ASSERT_EQUAL(length(squad.member_refs), 1, "registering the same bandit twice must not double up the roster")
	qdel(squad)

/datum/unit_test/ataman/squad_retires_when_gang_dies/Run()
	var/datum/ataman_squad/squad = new
	var/mob/living/carbon/human/first = allocate(/mob/living/carbon/human, at_turf(0, 0))
	var/mob/living/carbon/human/second = allocate(/mob/living/carbon/human, at_turf(1, 0))
	squad.register_member(first)
	squad.register_member(second)
	first.death()
	AT_ASSERT(!QDELETED(squad), "one survivor still means a live gang")
	second.death()
	AT_ASSERT(QDELETED(squad), "the squad must retire itself once the whole gang is down")

/datum/unit_test/ataman/squad_flank_angles_exclude_self/Run()
	var/datum/ataman_squad/squad = new
	var/turf/target_turf = at_turf(0, 0)
	var/mob/living/carbon/human/pawn = allocate(/mob/living/carbon/human, at_turf(0, 1))
	var/mob/living/carbon/human/ally = allocate(/mob/living/carbon/human, at_turf(1, 0))
	squad.register_member(pawn)
	squad.register_member(ally)
	var/list/angles = squad.get_flank_angles(pawn, target_turf)
	AT_ASSERT_EQUAL(length(angles), 1, "our own angle must never count against us")
	AT_ASSERT_EQUAL(angles[1], 0, "the ally to the east must report 0 degrees")
	AT_ASSERT_EQUAL(ataman_flank_pick_angle(angles), 180, "one ally east means we take the west side")
	qdel(squad)

/datum/unit_test/ataman/squad_flank_angles_drop_far_allies/Run()
	var/datum/ataman_squad/squad = new
	var/turf/target_turf = at_turf(0, 0)
	var/mob/living/carbon/human/pawn = allocate(/mob/living/carbon/human, at_turf(0, 1))
	var/turf/far_turf = at_turf(ATAMAN_FLANK_SCAN_RANGE + 2, 0)
	AT_ASSERT(far_turf, "the test map must be wide enough to place an ally out of scan range")
	AT_ASSERT(get_dist(far_turf, target_turf) > ATAMAN_FLANK_SCAN_RANGE, "the far turf must actually sit outside the scan range")
	var/mob/living/carbon/human/far_ally = allocate(/mob/living/carbon/human, far_turf)
	squad.register_member(pawn)
	squad.register_member(far_ally)
	AT_ASSERT_EQUAL(length(squad.get_flank_angles(pawn, target_turf)), 0, "an ally too far from the target is not holding a side")
	qdel(squad)

#undef AT_SOURCE
#undef AT_ASSERT
#undef AT_ASSERT_EQUAL
#undef AT_ASSERT_NULL

#endif
