#ifdef FAMILYTREE_DEBUG_LOGGING

GLOBAL_LIST_INIT(ftdebug_first_names, list(
	"Aldric", "Brenna", "Cedric", "Darina", "Edric", "Fiona",
	"Gareth", "Hilda", "Ingvar", "Jessa", "Keldan", "Lyra",
	"Morten", "Nessa", "Oskar", "Petra", "Ragnar", "Sigrid",
	"Torvald", "Ursula", "Viktor", "Wanda", "Yorick", "Zara",
	"Bjorn", "Cordelia", "Dmitri", "Elara", "Fenris", "Greta",
	"Halvard", "Isolde", "Jarek", "Katla", "Leif", "Magna",
	))

GLOBAL_LIST_INIT(ftdebug_last_names, list(
	"Ashford", "Blackwood", "Coldwell", "Dunmore", "Elkhart",
	"Frostborn", "Greymane", "Hawthorne", "Ironside", "Jarvik",
	"Kestrel", "Longmire", "Moorgate", "Northcott", "Oakfield",
	"Pinewall", "Quarrystone", "Ravencrest", "Stormwind", "Thornwall",
	))

GLOBAL_LIST_INIT(ftdebug_species_pool, list(
	/datum/species/human/northern,
	/datum/species/elf/wood,
	/datum/species/elf/dark,
	/datum/species/dwarf,
	/datum/species/tieberian,
	/datum/species/halforc,
	/datum/species/human/halfelf,
	))

GLOBAL_LIST_INIT(ftdebug_isolated_species_pool, list(
	/datum/species/gnoll,
	/datum/species/goblin,
	))

GLOBAL_LIST_INIT(ftdebug_age_pool, list(
	AGE_ADULT,
	AGE_ADULT,
	AGE_ADULT,
	AGE_MIDDLEAGED,
	AGE_MIDDLEAGED,
	AGE_OLD,
	))

#define FTDBG_SCENARIO_RANDOM     "random"
#define FTDBG_SCENARIO_LIFECYCLE  "lifecycle"
#define FTDBG_SCENARIO_ROYAL      "royal"
#define FTDBG_SCENARIO_FAVORITE   "favorite"
#define FTDBG_SCENARIO_ROLES      "desired_roles"
#define FTDBG_SCENARIO_ISOLATED   "isolated"
#define FTDBG_SCENARIO_EDGE       "edge_cases"
#define FTDBG_SCENARIO_STRESS     "stress"
#define FTDBG_SCENARIO_ELITE      "elite_family_control"

/datum/controller/subsystem/familytree
	var/list/debug_entities = list()
	var/debug_session_id = 0

/datum/controller/subsystem/familytree/proc/ftdebug_gen_name()
	var/first = pick(GLOB.ftdebug_first_names)
	var/last = pick(GLOB.ftdebug_last_names)
	return "[first] [last]"

/datum/controller/subsystem/familytree/proc/ftdebug_spawn_entity(turf/spawn_loc, apply_ckey = TRUE)
	if(!spawn_loc)
		spawn_loc = get_turf(locate(1,1,1))

	var/mob/living/carbon/human/H = new(spawn_loc)
	var/debug_name = ftdebug_gen_name()
	H.real_name = debug_name
	H.name = debug_name

	if(apply_ckey)
		H.ckey = "FTDEBUG_[debug_session_id]_[debug_entities.len + 1]"
		ftdebug_ensure_mind(H, H.ckey)

	debug_entities += H
	return H

/datum/controller/subsystem/familytree/proc/ftdebug_ensure_mind(mob/living/carbon/human/H, key_override = null)
	if(!H)
		return null
	var/mind_key = key_override || H.ckey || H.key
	if(!mind_key)
		mind_key = "FTDEBUG_[debug_session_id]_[debug_entities.Find(H) || (debug_entities.len + 1)]"
	if(!H.ckey)
		H.ckey = mind_key
	if(!H.mind)
		H.mind = new /datum/mind(mind_key)
	else
		H.mind.key = mind_key
	if(SSticker && !(H.mind in SSticker.minds))
		SSticker.minds += H.mind
	if(!H.mind.name)
		H.mind.name = H.real_name
	H.mind.current = H
	return H.mind

/datum/controller/subsystem/familytree/proc/ftdebug_cleanup_mind(mob/living/carbon/human/H)
	if(!H?.mind)
		return
	var/datum/mind/M = H.mind
	if(M.current == H)
		M.current = null
	H.mind = null
	if(SSticker)
		SSticker.minds -= M
	qdel(M)

/datum/controller/subsystem/familytree/proc/ftdebug_create_house_for(mob/living/carbon/human/H, house_name = null)
	if(!H)
		return null
	if(H.family_datum)
		return H.family_datum
	ftdebug_ensure_mind(H, H.ckey || H.key)
	var/datum/heritage/house = new /datum/heritage(H, house_name)
	if(!(house in families))
		families += house
	house.closed = FALSE
	house.SelectReplacementHouseHead()
	if(house.founder)
		house.founder.generation = 0
	if(!house.house_leader)
		house.house_leader = house.founder
	stop_tracking_human(H, "debug direct house")
	ftlog("DBGSIM: direct-created house '[house.housename || "no name"]' for [H.real_name]", FTLOG_INFO)
	return house

/datum/controller/subsystem/familytree/proc/ftdebug_apply_random_props(mob/living/carbon/human/H, species_type = null)
	if(!H)
		return

	if(!species_type)
		species_type = pick(GLOB.ftdebug_species_pool)
	var/datum/species/new_species = new species_type()
	H.set_species(new_species, TRUE)

	H.age = pick(GLOB.ftdebug_age_pool)
	H.gender = pick(MALE, FEMALE)
	H.pronouns = H.gender == MALE ? HE_HIM : SHE_HER

	H.familytree_pref = pick(FAMILY_PARTIAL, FAMILY_NEWLYWED, FAMILY_FULL, FAMILY_FULL)
	H.gender_choice_pref = pick(ANY_GENDER, SAME_GENDER, DIFFERENT_GENDER, ANY_GENDER)
	H.desired_relative_role = pick(RELATIVE_ANY, RELATIVE_ANY, RELATIVE_SIBLING, RELATIVE_SPOUSE, RELATIVE_CHILD)
	H.allow_low_status_marriage = prob(30)
	H.setspouse = ""
	H.polygamy_mode = prob(10) ? POLYGAMY_ALLOW_BOTH : POLYGAMY_DISABLED

/datum/controller/subsystem/familytree/proc/ftdebug_set_job(mob/living/carbon/human/H, job_type)
	if(!H || !job_type)
		return
	var/datum/job/J = find_job_by_type(job_type)
	if(!J)
		return
	ftdebug_ensure_mind(H, H.ckey || H.key)
	H.mind.assigned_role = J
	H.job = J.title

/datum/controller/subsystem/familytree/proc/ftdebug_result_string(mob/living/carbon/human/H)
	if(!H)
		return "null"
	var/result = ""
	if(H.family_datum)
		result += "family=[H.family_datum.housename](m=[H.family_datum.members.len])"
	else
		result += "no_family"
	if(H.spouse_mob)
		result += " spouse=[H.spouse_mob.real_name]"
	if(H in viable_spouses)
		result += " IN_VIABLE"
	if(H.familytree_assignment_scheduled)
		result += " PENDING"
	if(H.familytree_module_signal_bound)
		result += " SIGBOUND"
	return result

// =============================================
//  SCENARIO: RANDOM (basic assignment paths)
// =============================================
/datum/controller/subsystem/familytree/proc/ftdebug_scenario_random(turf/spawn_loc, count = 10)
	ftlog("DBGSIM [FTDBG_SCENARIO_RANDOM]: spawning [count] random entities", FTLOG_INFO)
	var/list/results = list()

	for(var/i = 1 to count)
		var/mob/living/carbon/human/H = ftdebug_spawn_entity(spawn_loc)
		ftdebug_apply_random_props(H)
		ftlog("DBGSIM SPAWN: [H.real_name] spec=[H.dna?.species?.type] age=[H.age] g=[H.gender] pref=[H.familytree_pref] gpref=[H.gender_choice_pref] role=[H.desired_relative_role]", FTLOG_DEBUG)

		var/unsubscribe_reason = get_familytree_unsubscribe_reason(H)
		if(unsubscribe_reason)
			results += "[H.real_name]: BLOCKED unsub=[unsubscribe_reason]"
			continue

		switch(H.familytree_pref)
			if(FAMILY_PARTIAL)
				AssignToHouse(H)
			if(FAMILY_NEWLYWED)
				AssignNewlyWed(H)
			if(FAMILY_FULL)
				AssignToFamily(H)

		results += "[H.real_name]: [ftdebug_result_string(H)]"

	return results

// =============================================
//  SCENARIO: LIFECYCLE (signal flow)
// =============================================
/datum/controller/subsystem/familytree/proc/ftdebug_scenario_lifecycle(turf/spawn_loc)
	ftlog("DBGSIM [FTDBG_SCENARIO_LIFECYCLE]: testing signal lifecycle", FTLOG_INFO)
	var/list/results = list()

	var/mob/living/carbon/human/H1 = ftdebug_spawn_entity(spawn_loc, FALSE)
	ftdebug_apply_random_props(H1)
	H1.familytree_pref = FAMILY_PARTIAL
	register_human(H1)
	results += "1a. [H1.real_name] spawned NO ckey, signals bound=[H1.familytree_module_signal_bound]"

	var/unsub1 = get_familytree_unsubscribe_reason(H1)
	results += "1b. unsub_reason with no ckey+no client = [unsub1 || "null (CORRECT)"]"

	on_human_job_received(H1, "Wretch")
	results += "1c. after job_received: sigbound=[H1.familytree_module_signal_bound] (should be TRUE - not unsubbed)"

	H1.ckey = "FTDEBUG_[debug_session_id]_LC1"
	on_human_login(H1)
	results += "1d. after login with ckey: sigbound=[H1.familytree_module_signal_bound] [ftdebug_result_string(H1)]"

	var/mob/living/carbon/human/H2 = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(H2)
	H2.familytree_pref = FAMILY_NEWLYWED
	register_human(H2)
	on_human_login(H2)
	results += "2a. [H2.real_name] normal login: [ftdebug_result_string(H2)]"

	on_human_death(H2)
	results += "2b. after death: in_viable=[H2 in viable_spouses] scheduled=[H2.familytree_assignment_scheduled]"

	on_human_revive(H2)
	results += "2c. after revive: sigbound=[H2.familytree_module_signal_bound]"

	on_human_logout(H2)
	results += "2d. after logout: in_viable=[H2 in viable_spouses]"

	var/mob/living/carbon/human/H3 = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(H3)
	H3.familytree_pref = FAMILY_NONE
	ftdebug_set_job(H3, /datum/job/roguetown/wretch)
	register_human(H3)
	try_queue_assignment(H3)
	results += "3. FAMILY_NONE+job: sigbound=[H3.familytree_module_signal_bound] (should be FALSE - unsubbed)"

	return results

// =============================================
//  SCENARIO: ROYAL (royal family flow)
// =============================================
/datum/controller/subsystem/familytree/proc/ftdebug_scenario_royal(turf/spawn_loc)
	ftlog("DBGSIM [FTDBG_SCENARIO_ROYAL]: testing royal assignment paths", FTLOG_INFO)
	var/list/results = list()

	var/mob/living/carbon/human/monarch = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(monarch, /datum/species/human/northern)
	monarch.age = AGE_MIDDLEAGED
	monarch.familytree_pref = FAMILY_FULL
	ftdebug_set_job(monarch, /datum/job/roguetown/lord)
	var/royal_status = get_royal_status(monarch)
	results += "1. Monarch [monarch.real_name]: royal_status=[royal_status] delay=[get_royal_delay(monarch)]"

	var/mob/living/carbon/human/consort = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(consort, /datum/species/human/northern)
	consort.gender = FEMALE
	consort.pronouns = SHE_HER
	consort.age = AGE_MIDDLEAGED
	consort.familytree_pref = FAMILY_FULL
	ftdebug_set_job(consort, /datum/job/roguetown/lady)
	var/consort_status = get_royal_status(consort)
	results += "2. Consort [consort.real_name]: royal_status=[consort_status] delay=[get_royal_delay(consort)]"

	var/mob/living/carbon/human/prince = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(prince, /datum/species/human/northern)
	prince.age = AGE_ADULT
	prince.familytree_pref = FAMILY_PARTIAL
	ftdebug_set_job(prince, /datum/job/roguetown/prince)
	var/prince_status = get_royal_status(prince)
	results += "3. Prince [prince.real_name]: royal_status=[prince_status]"

	var/mob/living/carbon/human/hand = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(hand, /datum/species/human/northern)
	hand.age = AGE_OLD
	hand.familytree_pref = FAMILY_PARTIAL
	ftdebug_set_job(hand, /datum/job/roguetown/hand)
	var/hand_status = get_royal_status(hand)
	results += "4. Hand [hand.real_name]: royal_status=[hand_status]"

	var/mob/living/carbon/human/suitor = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(suitor, /datum/species/human/northern)
	suitor.familytree_pref = FAMILY_FULL
	ftdebug_set_job(suitor, /datum/job/roguetown/suitor)
	var/is_suitor = is_royal_suitor_job(get_familytree_job(suitor))
	results += "5. Suitor [suitor.real_name]: is_suitor=[is_suitor] (should bypass familytree)"

	run_royal_assignment(monarch, royal_status)
	results += "6. Monarch after royal assign: [ftdebug_result_string(monarch)]"

	run_royal_assignment(consort, consort_status)
	results += "7. Consort after royal assign: [ftdebug_result_string(consort)]"

	run_royal_assignment(prince, prince_status)
	results += "8. Prince after royal assign: [ftdebug_result_string(prince)]"

	run_royal_assignment(hand, hand_status)
	results += "9. Hand after royal assign: [ftdebug_result_string(hand)]"

	return results

// =============================================
//  SCENARIO: FAVORITE (setspouse matching)
// =============================================
/datum/controller/subsystem/familytree/proc/ftdebug_scenario_favorite(turf/spawn_loc)
	ftlog("DBGSIM [FTDBG_SCENARIO_FAVORITE]: testing setspouse/favorite flows", FTLOG_INFO)
	var/list/results = list()

	var/mob/living/carbon/human/A = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(A, /datum/species/human/northern)
	A.familytree_pref = FAMILY_FULL
	A.gender = MALE
	A.pronouns = HE_HIM
	A.gender_choice_pref = DIFFERENT_GENDER

	var/mob/living/carbon/human/B = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(B, /datum/species/human/northern)
	B.familytree_pref = FAMILY_FULL
	B.gender = FEMALE
	B.pronouns = SHE_HER
	B.gender_choice_pref = DIFFERENT_GENDER

	A.setspouse = B.real_name
	B.setspouse = A.real_name
	results += "1. Mutual: [A.real_name] <-> [B.real_name]"

	var/fav_result_a = TryAssignToFavorite(A, FAMILY_FULL)
	results += "2. A.TryFavorite=[fav_result_a] [ftdebug_result_string(A)]"
	results += "3. B after A's assign: [ftdebug_result_string(B)]"

	var/mob/living/carbon/human/C = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(C, /datum/species/human/northern)
	C.familytree_pref = FAMILY_NEWLYWED
	C.gender = MALE
	C.pronouns = HE_HIM
	C.gender_choice_pref = DIFFERENT_GENDER

	var/mob/living/carbon/human/D = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(D, /datum/species/human/northern)
	D.familytree_pref = FAMILY_NEWLYWED
	D.gender = FEMALE
	D.pronouns = SHE_HER
	D.gender_choice_pref = ANY_GENDER

	C.setspouse = D.real_name
	D.setspouse = ""
	results += "4. One-sided: [C.real_name] -> [D.real_name] (D has no setspouse)"

	viable_spouses += D
	var/fav_result_c = TryAssignToFavorite(C, FAMILY_NEWLYWED)
	results += "5. C.TryFavorite=[fav_result_c] [ftdebug_result_string(C)]"

	var/mob/living/carbon/human/E = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(E, /datum/species/human/northern)
	E.familytree_pref = FAMILY_FULL
	E.gender = FEMALE
	E.pronouns = SHE_HER

	var/mob/living/carbon/human/F = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(F, /datum/species/human/northern)
	F.familytree_pref = FAMILY_PARTIAL
	F.gender = MALE
	F.pronouns = HE_HIM
	F.age = AGE_MIDDLEAGED
	ftdebug_create_house_for(F)
	results += "6. F in house: [ftdebug_result_string(F)]"

	E.setspouse = F.real_name
	var/fav_result_e = TryAssignToFavorite(E, FAMILY_FULL)
	results += "7. E -> F (already in family): result=[fav_result_e] [ftdebug_result_string(E)]"

	return results

// =============================================
//  SCENARIO: DESIRED ROLES (all role paths)
// =============================================
/datum/controller/subsystem/familytree/proc/ftdebug_scenario_desired_roles(turf/spawn_loc)
	ftlog("DBGSIM [FTDBG_SCENARIO_ROLES]: testing desired relative role paths", FTLOG_INFO)
	var/list/results = list()

	var/mob/living/carbon/human/founder = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(founder, /datum/species/human/northern)
	founder.age = AGE_OLD
	founder.familytree_pref = FAMILY_PARTIAL
	ftdebug_create_house_for(founder)
	results += "0. Founder: [ftdebug_result_string(founder)]"

	var/mob/living/carbon/human/sib = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(sib, /datum/species/human/northern)
	sib.age = AGE_OLD
	sib.familytree_pref = FAMILY_PARTIAL
	sib.desired_relative_role = RELATIVE_SIBLING
	AssignWithDesiredRole(sib)
	results += "1. SIBLING: [ftdebug_result_string(sib)] (same house as founder=[sib.family_datum == founder.family_datum])"

	var/mob/living/carbon/human/child = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(child, /datum/species/human/northern)
	child.age = AGE_ADULT
	child.familytree_pref = FAMILY_PARTIAL
	child.desired_relative_role = RELATIVE_CHILD
	AssignWithDesiredRole(child)
	var/has_parents = child.family_member_datum ? child.family_member_datum.get_parent_members().len : 0
	results += "2. CHILD: [ftdebug_result_string(child)] parents=[has_parents]"

	var/mob/living/carbon/human/parent = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(parent, /datum/species/human/northern)
	parent.age = AGE_OLD
	parent.familytree_pref = FAMILY_PARTIAL
	parent.desired_relative_role = RELATIVE_PARENT
	AssignWithDesiredRole(parent)
	results += "3. PARENT: [ftdebug_result_string(parent)]"

	var/mob/living/carbon/human/uncle = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(uncle, /datum/species/human/northern)
	uncle.age = AGE_OLD
	uncle.familytree_pref = FAMILY_PARTIAL
	uncle.desired_relative_role = RELATIVE_UNCLE_AUNT
	AssignAuntUncle(uncle)
	results += "4. UNCLE/AUNT: [ftdebug_result_string(uncle)]"

	var/mob/living/carbon/human/spouse_seeker = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(spouse_seeker, /datum/species/human/northern)
	spouse_seeker.age = AGE_ADULT
	spouse_seeker.familytree_pref = FAMILY_NEWLYWED
	spouse_seeker.desired_relative_role = RELATIVE_SPOUSE
	spouse_seeker.gender_choice_pref = ANY_GENDER

	var/mob/living/carbon/human/spouse_target = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(spouse_target, /datum/species/human/northern)
	spouse_target.age = AGE_ADULT
	spouse_target.familytree_pref = FAMILY_NEWLYWED
	spouse_target.gender_choice_pref = ANY_GENDER
	viable_spouses += spouse_target

	AssignWithDesiredRole(spouse_seeker)
	results += "5. SPOUSE: [ftdebug_result_string(spouse_seeker)]"

	return results

// =============================================
//  SCENARIO: ISOLATED SPECIES (gnoll/goblin)
// =============================================
/datum/controller/subsystem/familytree/proc/ftdebug_scenario_isolated(turf/spawn_loc)
	ftlog("DBGSIM [FTDBG_SCENARIO_ISOLATED]: testing isolated + sterile + banned", FTLOG_INFO)
	var/list/results = list()

	var/mob/living/carbon/human/gnoll1 = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(gnoll1, /datum/species/gnoll)
	gnoll1.familytree_pref = FAMILY_PARTIAL
	results += "1. Gnoll1 isolated=[is_isolated(gnoll1)]"

	var/mob/living/carbon/human/gnoll2 = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(gnoll2, /datum/species/gnoll)
	gnoll2.familytree_pref = FAMILY_PARTIAL
	ftdebug_create_house_for(gnoll1)
	AssignToHouse(gnoll2)
	results += "2. Gnoll1: [ftdebug_result_string(gnoll1)]"
	results += "3. Gnoll2: [ftdebug_result_string(gnoll2)] same_house=[gnoll1.family_datum == gnoll2.family_datum]"

	var/mob/living/carbon/human/human_vs_gnoll = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(human_vs_gnoll, /datum/species/human/northern)
	human_vs_gnoll.familytree_pref = FAMILY_NEWLYWED
	human_vs_gnoll.gender_choice_pref = ANY_GENDER
	viable_spouses += gnoll1
	viable_spouses += human_vs_gnoll
	AssignNewlyWed(human_vs_gnoll)
	var/cross_matched = human_vs_gnoll.spouse_mob == gnoll1
	results += "4. Human+Gnoll cross-match: [cross_matched] (should be FALSE)"

	var/mob/living/carbon/human/construct_mob = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(construct_mob, /datum/species/construct)
	var/sterile = is_sterile_species(construct_mob)
	var/valid = is_valid_familytree_species(construct_mob)
	results += "5. Construct: sterile=[sterile] valid_species=[valid]"

	var/mob/living/carbon/human/banned = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(banned, /datum/species/human/northern)
	if(!banned.mind)
		banned.mind = new /datum/mind(banned.ckey)
		banned.mind.current = banned
	banned.mind.add_antag_datum(/datum/antagonist/zombie)
	var/is_banned = is_banned_antag(banned)
	var/unsub_reason = get_familytree_unsubscribe_reason(banned)
	results += "6. Zombie: banned=[is_banned] unsub=[unsub_reason]"

	var/mob/living/carbon/human/goblin_antag = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(goblin_antag, /datum/species/goblin)
	if(!goblin_antag.mind)
		goblin_antag.mind = new /datum/mind(goblin_antag.ckey)
		goblin_antag.mind.current = goblin_antag
	goblin_antag.mind.special_role = "Goblin Raider"
	var/gob_isolated = is_isolated(goblin_antag)
	results += "7. Antag Goblin: isolated=[gob_isolated] (should be TRUE)"

	var/mob/living/carbon/human/goblin_civ = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(goblin_civ, /datum/species/goblin)
	var/gob_civ_isolated = is_isolated(goblin_civ)
	results += "8. Civilian Goblin: isolated=[gob_civ_isolated] (should be FALSE)"

	return results

// =============================================
//  SCENARIO: EDGE CASES
// =============================================
/datum/controller/subsystem/familytree/proc/ftdebug_scenario_edge(turf/spawn_loc)
	ftlog("DBGSIM [FTDBG_SCENARIO_EDGE]: testing edge cases", FTLOG_INFO)
	var/list/results = list()

	var/mob/living/carbon/human/none_mob = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(none_mob, /datum/species/human/northern)
	none_mob.familytree_pref = FAMILY_NONE
	ftdebug_set_job(none_mob, /datum/job/roguetown/wretch)
	register_human(none_mob)
	try_queue_assignment(none_mob)
	results += "1. FAMILY_NONE: sigbound=[none_mob.familytree_module_signal_bound] (should be FALSE)"

	var/mob/living/carbon/human/virgin = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(virgin, /datum/species/human/northern)
	virgin.familytree_pref = FAMILY_FULL
	virgin.virginity = TRUE
	var/pre_family = virgin.family_datum
	run_local_assignment(virgin, FAMILY_FULL)
	results += "2. Virginity gate: pre=[pre_family] post=[virgin.family_datum] (should block FAMILY_FULL)"

	var/mob/living/carbon/human/dup1 = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(dup1, /datum/species/human/northern)
	dup1.familytree_pref = FAMILY_NEWLYWED
	dup1.gender_choice_pref = ANY_GENDER
	viable_spouses += dup1
	var/pre_viable = viable_spouses.len
	try_queue_assignment(dup1)
	results += "3. Already in viable: pre_count=[pre_viable] post_count=[viable_spouses.len] scheduled=[dup1.familytree_assignment_scheduled] (should schedule recheck)"

	var/mob/living/carbon/human/sched = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(sched, /datum/species/human/northern)
	sched.familytree_pref = FAMILY_PARTIAL
	sched.familytree_assignment_scheduled = TRUE
	var/pre_sched = sched.familytree_assignment_scheduled
	try_queue_assignment(sched)
	results += "4. Already scheduled: scheduled=[pre_sched] -> [sched.familytree_assignment_scheduled] (should skip)"

	var/mob/living/carbon/human/already_fam = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(already_fam, /datum/species/human/northern)
	already_fam.familytree_pref = FAMILY_PARTIAL
	ftdebug_create_house_for(already_fam)
	var/fam_before = already_fam.family_datum
	register_human(already_fam)
	try_queue_assignment(already_fam)
	results += "5. Already has family: stopped=[!already_fam.familytree_module_signal_bound] family_same=[fam_before == already_fam.family_datum]"

	var/mob/living/carbon/human/poly_hub = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(poly_hub, /datum/species/human/northern)
	poly_hub.polygamy_mode = POLYGAMY_ALLOW_MULTIPLE
	poly_hub.gender = MALE
	poly_hub.pronouns = HE_HIM
	poly_hub.familytree_pref = FAMILY_NEWLYWED
	poly_hub.gender_choice_pref = ANY_GENDER

	var/mob/living/carbon/human/spouse1 = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(spouse1, /datum/species/human/northern)
	spouse1.gender = FEMALE
	spouse1.pronouns = SHE_HER
	spouse1.familytree_pref = FAMILY_NEWLYWED
	spouse1.gender_choice_pref = ANY_GENDER

	poly_hub.MarryTo(spouse1)
	results += "6a. Polygamy hub married: [ftdebug_result_string(poly_hub)]"

	var/mob/living/carbon/human/spouse2 = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(spouse2, /datum/species/human/northern)
	spouse2.gender = FEMALE
	spouse2.pronouns = SHE_HER
	spouse2.polygamy_mode = POLYGAMY_ALLOW_BE_SECOND

	var/compat = familytree_polygamy_compatible(poly_hub, spouse2)
	results += "6b. Polygamy compat hub+spouse2: [compat] (should be TRUE)"

	var/mob/living/carbon/human/no_poly = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(no_poly, /datum/species/human/northern)
	no_poly.polygamy_mode = POLYGAMY_DISABLED
	var/no_compat = familytree_polygamy_compatible(poly_hub, no_poly)
	results += "6c. Polygamy compat hub+nopoly: [no_compat] (should be FALSE)"

	var/mob/living/carbon/human/noble = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(noble, /datum/species/human/northern)
	ftdebug_set_job(noble, /datum/job/roguetown/knight)
	var/noble_estate = familytree_get_estate(noble)
	var/noble_tier = familytree_get_role_tier(noble)

	var/mob/living/carbon/human/wretch = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(wretch, /datum/species/human/northern)
	ftdebug_set_job(wretch, /datum/job/roguetown/wretch)
	var/wretch_estate = familytree_get_estate(wretch)
	var/wretch_tier = familytree_get_role_tier(wretch)

	var/estate_compat = familytree_estates_compatible(noble, wretch)
	var/tier_compat = familytree_role_tiers_compatible(noble, wretch)
	results += "7a. Knight: estate=[noble_estate] tier=[noble_tier]"
	results += "7b. Wretch: estate=[wretch_estate] tier=[wretch_tier]"
	results += "7c. Knight+Wretch: estate_compat=[estate_compat] tier_compat=[tier_compat] (both should be FALSE)"

	wretch.allow_low_status_marriage = TRUE
	var/tier_compat_allow = familytree_role_tiers_compatible(noble, wretch)
	results += "7d. Knight+Wretch with allow_low: tier_compat=[tier_compat_allow]"

	var/mob/living/carbon/human/elf = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(elf, /datum/species/elf/dark)
	elf.gender = MALE
	elf.pronouns = HE_HIM
	var/mob/living/carbon/human/human = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(human, /datum/species/human/northern)
	human.gender = FEMALE
	human.pronouns = SHE_HER
	var/species_compat = GetSpeciesCompatibilityFailureReason(elf, human)
	results += "8. Cross-species default: elf+human failure=[species_compat || "none"]"

	var/mob/living/carbon/human/same1 = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(same1, /datum/species/human/northern)
	same1.gender = MALE
	same1.pronouns = HE_HIM
	same1.gender_choice_pref = SAME_GENDER
	var/mob/living/carbon/human/same2 = ftdebug_spawn_entity(spawn_loc)
	ftdebug_apply_random_props(same2, /datum/species/human/northern)
	same2.gender = MALE
	same2.pronouns = HE_HIM
	same2.gender_choice_pref = SAME_GENDER
	var/pronoun_ok = pronouns_compatible(same1, same2)
	results += "9a. Same gender pref (M+M, SAME): compat=[pronoun_ok] (TRUE)"

	same2.gender_choice_pref = DIFFERENT_GENDER
	var/pronoun_fail = pronouns_compatible(same1, same2)
	results += "9b. Mixed pref (SAME+DIFF, M+M): compat=[pronoun_fail] (FALSE)"

	return results

// =============================================
//  SCENARIO: STRESS (high volume)
// =============================================
/datum/controller/subsystem/familytree/proc/ftdebug_scenario_stress(turf/spawn_loc, count = 50)
	ftlog("DBGSIM [FTDBG_SCENARIO_STRESS]: stress test with [count] entities", FTLOG_INFO)
	var/list/results = list()
	var/list/batch = list()

	for(var/i = 1 to count)
		var/mob/living/carbon/human/H = ftdebug_spawn_entity(spawn_loc)
		if(prob(15))
			ftdebug_apply_random_props(H, pick(GLOB.ftdebug_isolated_species_pool))
		else
			ftdebug_apply_random_props(H)
		batch += H

	var/assigned = 0
	var/married = 0
	var/house_partial = 0
	var/newlywed = 0
	var/full_fam = 0
	var/blocked = 0

	for(var/mob/living/carbon/human/H as anything in batch)
		var/unsub = get_familytree_unsubscribe_reason(H)
		if(unsub)
			blocked++
			continue

		switch(H.familytree_pref)
			if(FAMILY_PARTIAL)
				AssignToHouse(H)
				house_partial++
			if(FAMILY_NEWLYWED)
				if(!(H in viable_spouses))
					viable_spouses += H
				newlywed++
			if(FAMILY_FULL)
				AssignToFamily(H)
				full_fam++

		if(H.family_datum)
			assigned++

	for(var/mob/living/carbon/human/S as anything in viable_spouses)
		if(S.spouse_mob)
			continue
		for(var/mob/living/carbon/human/T as anything in viable_spouses)
			if(T == S || T.spouse_mob)
				continue
			if(!pronouns_compatible(S, T))
				continue
			var/species_fail = GetSpeciesCompatibilityFailureReason(S, T)
			if(species_fail)
				continue
			if(!familytree_estates_compatible(S, T))
				continue
			if(!familytree_role_tiers_compatible(S, T))
				continue
			S.spouse_mob = T
			T.spouse_mob = S
			viable_spouses -= S
			viable_spouses -= T
			married++
			ftlog("DBGSIM MARRIED: [S.real_name] + [T.real_name]")
			break

	var/list/house_sizes = list()
	for(var/datum/heritage/house as anything in families)
		if(house.members.len)
			house_sizes += "[house.housename || "unnamed"]=[house.members.len]"

	results += "SPAWNED: [count]"
	results += "PATHS: partial=[house_partial] newlywed=[newlywed] full=[full_fam] blocked=[blocked]"
	results += "OUTCOME: assigned=[assigned] married=[married] orphaned=[count - assigned - blocked]"
	results += "HOUSES: [house_sizes.Join(", ")]"
	results += "VIABLE_SPOUSES: [viable_spouses.len]"

	return results

// =============================================
//  MASTER SCENARIO RUNNER + ADMIN VERB
// =============================================
/datum/controller/subsystem/familytree/proc/ftdebug_run_scenario(mob/user, scenario = FTDBG_SCENARIO_RANDOM, count = 10)
	debug_session_id++
	ftlog("========== DBGSIM SESSION #[debug_session_id] scenario=[scenario] ==========", FTLOG_INFO)
	ftlog_state("DBGSIM_PRE")

	var/turf/spawn_loc = get_turf(user) || get_turf(locate(1,1,1))
	var/list/results

	switch(scenario)
		if(FTDBG_SCENARIO_RANDOM)
			results = ftdebug_scenario_random(spawn_loc, count)
		if(FTDBG_SCENARIO_LIFECYCLE)
			results = ftdebug_scenario_lifecycle(spawn_loc)
		if(FTDBG_SCENARIO_ROYAL)
			results = ftdebug_scenario_royal(spawn_loc)
		if(FTDBG_SCENARIO_FAVORITE)
			results = ftdebug_scenario_favorite(spawn_loc)
		if(FTDBG_SCENARIO_ROLES)
			results = ftdebug_scenario_desired_roles(spawn_loc)
		if(FTDBG_SCENARIO_ISOLATED)
			results = ftdebug_scenario_isolated(spawn_loc)
		if(FTDBG_SCENARIO_EDGE)
			results = ftdebug_scenario_edge(spawn_loc)
		if(FTDBG_SCENARIO_STRESS)
			results = ftdebug_scenario_stress(spawn_loc, count)
		if(FTDBG_SCENARIO_ELITE)
			results = ftdebug_scenario_elite_family_control(spawn_loc)
		else
			results = list("Unknown scenario: [scenario]")

	ftlog_state("DBGSIM_POST")
	ftlog("========== DBGSIM SESSION #[debug_session_id] DONE ==========", FTLOG_INFO)

	return list(
		"session" = debug_session_id,
		"scenario" = scenario,
		"results" = results,
		"entity_count" = debug_entities.len,
		"families" = families.len,
		"viable" = viable_spouses.len,
		"errors" = ftlog_error_count,
		"warns" = ftlog_warn_count,
	)

/datum/controller/subsystem/familytree/proc/ftdebug_cleanup()
	ftlog("DBGSIM CLEANUP: removing [debug_entities.len] debug entities", FTLOG_INFO)
	var/cleaned = 0
	for(var/mob/living/carbon/human/H as anything in debug_entities)
		if(QDELETED(H))
			continue
		if(H.family_datum)
			var/datum/heritage/house = H.family_datum
			house.RemovePersonFromFamily(H, TRUE)
		if(H.spouse_mob)
			var/mob/living/carbon/human/spouse = H.spouse_mob
			if(!QDELETED(spouse))
				spouse.spouse_mob = null
			H.spouse_mob = null
		viable_spouses -= H
		stop_tracking_human(H, "debug cleanup")
		ftdebug_cleanup_mind(H)
		qdel(H)
		cleaned++
	debug_entities.Cut()
	ftlog("DBGSIM CLEANUP DONE: [cleaned] entities removed", FTLOG_INFO)
	ftlog_state("DBGSIM_POSTCLEAN")
	return cleaned

/datum/controller/subsystem/familytree/proc/ftdebug_report_html(list/sim_data)
	var/list/out = list()
	out += {"<html><head><style>
		body { font-family: Consolas, monospace; font-size: 13px; background: #1a1a2e; color: #e0e0e0; padding: 10px; }
		h3 { color: #e94560; margin-bottom: 5px; }
		.ok { color: #0f0; } .warn { color: #ff0; } .err { color: #f00; }
		.stat { color: #00d2ff; } .line { border-bottom: 1px solid #333; padding: 2px 0; }
		hr { border-color: #333; }
		</style></head><body>"}
	out += "<h3>FamilyTree Debug: [sim_data["scenario"]] (session #[sim_data["session"]])</h3>"
	out += "<span class='stat'>Entities: [sim_data["entity_count"]] | Families: [sim_data["families"]] | Viable: [sim_data["viable"]]</span><br>"

	var/err_class = sim_data["errors"] > 0 ? "err" : "ok"
	var/warn_class = sim_data["warns"] > 0 ? "warn" : "ok"
	out += "<span class='[err_class]'>Errors: [sim_data["errors"]]</span> | <span class='[warn_class]'>Warns: [sim_data["warns"]]</span>"
	out += "<hr>"

	for(var/line in sim_data["results"])
		out += "<div class='line'>[line]</div>"

	out += "</body></html>"
	return out.Join("")

#endif

/client/proc/familytree_debug_panel()
	set name = "FamilyTree Debug"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

#ifdef FAMILYTREE_DEBUG_LOGGING
	var/list/options = list(
		"Random (10 entities)",
		"Random (custom count)",
		"Lifecycle (signal flow)",
		"Royal (royal family)",
		"Favorite (setspouse)",
		"Desired Roles (all paths)",
		"Isolated + Banned species",
		"Edge Cases (all guards)",
		"Stress Test (50)",
		"Stress Test (custom)",
		"---",
		"Run ALL scenarios",
		"Dump system state",
		"Cleanup debug entities",
		"Log stats",
		"Elite Family Control (new logic)",
	)

	var/choice = tgui_input_list(mob, "FamilyTree Debug Panel", "FT Debug", options)
	if(!choice || choice == "---")
		return

	switch(choice)
		if("Random (10 entities)")
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_RANDOM, 10)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Random (custom count)")
			var/count = tgui_input_number(mob, "How many entities?", "FT Debug", 10, 100, 1)
			if(!count)
				return
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_RANDOM, count)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Lifecycle (signal flow)")
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_LIFECYCLE)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Royal (royal family)")
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_ROYAL)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Favorite (setspouse)")
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_FAVORITE)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Desired Roles (all paths)")
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_ROLES)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Isolated + Banned species")
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_ISOLATED)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Edge Cases (all guards)")
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_EDGE)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x700")

		if("Stress Test (50)")
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_STRESS, 50)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Stress Test (custom)")
			var/count = tgui_input_number(mob, "How many entities?", "FT Debug", 50, 200, 10)
			if(!count)
				return
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_STRESS, count)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Elite Family Control (new logic)")
			var/list/data = SSfamilytree.ftdebug_run_scenario(mob, FTDBG_SCENARIO_ELITE)
			mob << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=700x600")

		if("Run ALL scenarios")
			var/list/all_html = list()
			var/list/scenario_list = list(
				FTDBG_SCENARIO_LIFECYCLE,
				FTDBG_SCENARIO_ROYAL,
				FTDBG_SCENARIO_FAVORITE,
				FTDBG_SCENARIO_ROLES,
				FTDBG_SCENARIO_ISOLATED,
				FTDBG_SCENARIO_EDGE,
				FTDBG_SCENARIO_RANDOM,
				FTDBG_SCENARIO_STRESS,
				FTDBG_SCENARIO_ELITE,
			)
			for(var/sc in scenario_list)
				SSfamilytree.ftdebug_cleanup()
				var/list/data = SSfamilytree.ftdebug_run_scenario(mob, sc, 20)
				all_html += SSfamilytree.ftdebug_report_html(data)
				all_html += "<hr style='border: 2px solid #e94560;'>"
			mob << browse(all_html.Join(""), "window=ftdebug;size=800x900")

		if("Dump system state")
			SSfamilytree.ftlog_state("ADMIN_DUMP")
			to_chat(mob, span_notice("FamilyTree state dumped to log."))

		if("Cleanup debug entities")
			var/cleaned = SSfamilytree.ftdebug_cleanup()
			to_chat(mob, span_notice("Cleaned up [cleaned] debug entities."))

		if("Log stats")
			var/html = {"<html><body style='font-family:Consolas;background:#1a1a2e;color:#e0e0e0;padding:10px;'>
				<h3 style='color:#e94560;'>FamilyTree Log Stats</h3>
				<b>Total messages:</b> [SSfamilytree.ftlog_counter]<br>
				<b>Errors:</b> <span style='color:#f00;'>[SSfamilytree.ftlog_error_count]</span><br>
				<b>Warnings:</b> <span style='color:#ff0;'>[SSfamilytree.ftlog_warn_count]</span><br>
				<b>Families:</b> [SSfamilytree.families.len]<br>
				<b>Viable spouses:</b> [SSfamilytree.viable_spouses.len]<br>
				<b>Debug entities:</b> [SSfamilytree.debug_entities.len]<br>
				<b>Sessions run:</b> [SSfamilytree.debug_session_id]<br>
				</body></html>"}
			mob << browse(html, "window=ftdebug;size=400x300")

#else
	to_chat(mob, span_warning("FamilyTree debugging is disabled. Define FAMILYTREE_DEBUG_LOGGING in familytree_module_config.dm"))

#endif

#ifdef FAMILYTREE_DEBUG_LOGGING

/datum/emote/living/familytree_debug
	key = "ftdebug"
	key_third_person = "ftdebug"
	message = "runs FamilyTree tests"

/datum/emote/living/familytree_debug/run_emote(mob/living/user, params)
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	SSfamilytree.ftdebug_cleanup()
	var/list/data = SSfamilytree.ftdebug_run_scenario(user, FTDBG_SCENARIO_STRESS, 20)
	user << browse(SSfamilytree.ftdebug_report_html(data), "window=ftdebug;size=800x900")
	return TRUE

/datum/emote/living/familytree_spawn_npc
	key = "ftspawn"
	key_third_person = "ftspawn"
	message = "spawns FamilyTree NPCs"

/datum/emote/living/familytree_spawn_npc/run_emote(mob/living/user, params)
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	var/count = 5
	var/to_house = FALSE
	if(params)
		var/params_lower = lowertext(params)
		to_house = findtext(params_lower, "house") || findtext(params_lower, "family")
		for(var/part in splittext(params, " "))
			var/parsed = text2num(part)
			if(parsed)
				count = clamp(parsed, 1, 30)
				break
	var/turf/spawn_loc = get_turf(user)
	var/added = 0
	if(to_house)
		var/mob/living/carbon/human/H_user = user
		for(var/i = 1 to count)
			var/result = SSfamilytree.ftpop_add_house_member(H_user)
			if(istype(result, /mob/living/carbon/human))
				added++
		to_chat(user, span_notice("FT: Spawned [added] NPCs into your house."))
		return TRUE
	for(var/i = 1 to count)
		var/mob/living/carbon/human/H = SSfamilytree.ftdebug_spawn_entity(spawn_loc)
		SSfamilytree.ftdebug_apply_random_props(H)
		H.familytree_pref = FAMILY_NEWLYWED
		if(!(H in SSfamilytree.viable_spouses))
			SSfamilytree.viable_spouses += H
		added++
		SSfamilytree.ftlog("FTSPAWN: [H.real_name] added to viable_spouses ([H.dna?.species?.name] [H.gender == MALE ? "M" : "F"])")
	to_chat(user, span_notice("FT: Spawned [added] NPCs into viable_spouses pool (total: [SSfamilytree.viable_spouses.len])"))
	return TRUE

#endif

#ifdef FAMILYTREE_DEBUG_LOGGING

/datum/controller/subsystem/familytree/proc/ftdebug_scenario_elite_family_control(turf/spawn_loc)
	ftlog("=== DBGSIM ELITE_FAMILY_CONTROL START ===", FTLOG_INFO)
	var/list/results = list()

	var/mob/living/carbon/human/knight1 = ftdebug_spawn_entity(spawn_loc)
	knight1.real_name = "Sir Knight1"
	knight1.name = knight1.real_name
	knight1.familytree_pref = FAMILY_NEWLYWED
	knight1.allow_low_status_marriage = 1
	knight1.allow_relatives_in_family = 1
	ftdebug_ensure_mind(knight1, knight1.ckey || "debug_knight1")
	knight1.mind.name = knight1.real_name
	ftdebug_set_job(knight1, /datum/job/roguetown/knight)

	var/mob/living/carbon/human/knight2 = ftdebug_spawn_entity(spawn_loc)
	knight2.real_name = "Sir Knight2"
	knight2.name = knight2.real_name
	knight2.familytree_pref = FAMILY_NEWLYWED
	knight2.allow_low_status_marriage = 1
	knight2.allow_relatives_in_family = 1
	ftdebug_ensure_mind(knight2, knight2.ckey || "debug_knight2")
	knight2.mind.name = knight2.real_name
	ftdebug_set_job(knight2, /datum/job/roguetown/knight)

	var/mob/living/carbon/human/wretch = ftdebug_spawn_entity(spawn_loc)
	wretch.real_name = "Wretch Low"
	wretch.name = wretch.real_name
	wretch.familytree_pref = FAMILY_PARTIAL
	wretch.allow_low_status_marriage = 1
	ftdebug_ensure_mind(wretch, wretch.ckey || "debug_wretch")
	wretch.mind.name = wretch.real_name
	ftdebug_set_job(wretch, /datum/job/roguetown/wretch)

	results += "Created: Knight1, Knight2, Wretch (low-tier)"

	knight1.MarryTo(knight2)
	var/datum/heritage/house = knight1.family_datum
	results += "Knights married. Is elite family = " + (is_elite_family(house) ? "YES" : "NO")

	AssignToHouse(wretch)
	results += "Wretch tried to join elite family. Blocked = " + (wretch.family_datum != house ? "YES (correct)" : "NO (BAD)")

	results += "Knight1 allow_relatives_in_family = " + (knight1.allow_relatives_in_family ? "1" : "0")

	ftlog("=== DBGSIM ELITE_FAMILY_CONTROL END ===", FTLOG_INFO)
	ftlog("Results: " + results.Join(" | "), FTLOG_INFO)

	return results

#endif
