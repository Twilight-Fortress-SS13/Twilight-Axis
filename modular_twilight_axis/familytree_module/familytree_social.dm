#define ESTATE_NONE 0
#define ESTATE_NOBLE 1
#define ESTATE_COMMONER 2

/proc/familytree_get_estate(mob/living/carbon/human/H)
	if(!H)
		return ESTATE_NONE

	var/datum/job/job = SSfamilytree.get_familytree_job(H)
	if(!job)
		return ESTATE_NONE

	if(SSfamilytree.is_noble_job(job))
		return ESTATE_NOBLE

	return ESTATE_COMMONER

/datum/controller/subsystem/familytree/proc/is_noble_job(datum/job/job)
	if(!job)
		return FALSE
	if(istype(job, /datum/job/roguetown/lord))
		return TRUE
	if(istype(job, /datum/job/roguetown/lady))
		return TRUE
	if(istype(job, /datum/job/roguetown/prince))
		return TRUE
	if(istype(job, /datum/job/roguetown/hand))
		return TRUE
	if(istype(job, /datum/job/roguetown/suitor))
		return TRUE
	if(istype(job, /datum/job/roguetown/seneschal))
		return TRUE
	if(istype(job, /datum/job/roguetown/councillor))
		return TRUE
	if(istype(job, /datum/job/roguetown/magician))
		return TRUE
	if(istype(job, /datum/job/roguetown/steward))
		return TRUE
	if(istype(job, /datum/job/roguetown/archivist))
		return TRUE
	if(istype(job, /datum/job/roguetown/knight))
		return TRUE
	if(istype(job, /datum/job/roguetown/marshal))
		return TRUE
	return FALSE

/proc/familytree_estates_compatible(mob/living/carbon/human/A, mob/living/carbon/human/B)
	var/estate_a = familytree_get_estate(A)
	var/estate_b = familytree_get_estate(B)

	if(estate_a == ESTATE_NONE || estate_b == ESTATE_NONE)
		return TRUE

	return estate_a == estate_b
#define ROLE_TIER_NONE 0
#define ROLE_TIER_HIGH 1
#define ROLE_TIER_LOW 2

/datum/controller/subsystem/familytree
	// Nobility and ducal family
	var/list/high_tier_nobility_types = list(
		/datum/job/roguetown/lord,
		/datum/job/roguetown/lady,
		/datum/job/roguetown/exlady,
		/datum/job/roguetown/prince,
		/datum/job/roguetown/hand,
		/datum/job/roguetown/suitor,
	)

	// Church and inquisition
	var/list/high_tier_church_types = list(
		/datum/job/roguetown/priest,
		/datum/job/roguetown/templar,
		/datum/job/roguetown/monk,
		/datum/job/roguetown/druid,
		/datum/job/roguetown/keeper,
		/datum/job/roguetown/sexton,
		/datum/job/roguetown/martyr,
		/datum/job/roguetown/inquisitor,
		/datum/job/roguetown/orthodoxist,
		/datum/job/roguetown/absolver,
	)

	// Town military and garrison
	var/list/high_tier_military_types = list(
		/datum/job/roguetown/knight,
		/datum/job/roguetown/marshal,
		/datum/job/roguetown/sergeant,
		/datum/job/roguetown/watchman,
		/datum/job/roguetown/warden,
		/datum/job/roguetown/manorguard,
	)

	// Key town professions (courtiers and administration)
	var/list/high_tier_town_types = list(
		/datum/job/roguetown/seneschal,
		/datum/job/roguetown/councillor,
		/datum/job/roguetown/magician,
		/datum/job/roguetown/guildmaster,
		/datum/job/roguetown/adventurer/courtagent,
	)

	// Criminal and outlaw roles
	var/list/low_tier_job_types = list(
		/datum/job/roguetown/wretch,
		/datum/job/roguetown/bandit,
		/datum/job/roguetown/assassin,
		/datum/job/roguetown/lunatic,
		/datum/job/roguetown/vagabond,
		/datum/job/roguetown/bathworker,
	)

	// Fallback title list for advclass-based roles without own job datums
	var/list/low_tier_job_titles = list(
		"Beggar",
		"Excommunicado",
		"Thug",
		"Doomsayer",
	)

/proc/familytree_get_role_tier(mob/living/carbon/human/H)
	if(!H)
		return ROLE_TIER_NONE

	if(SSfamilytree.is_human_job_of_type(H, SSfamilytree.high_tier_nobility_types))
		return ROLE_TIER_HIGH

	if(SSfamilytree.is_human_job_of_type(H, SSfamilytree.high_tier_church_types))
		return ROLE_TIER_HIGH

	if(SSfamilytree.is_human_job_of_type(H, SSfamilytree.high_tier_military_types))
		return ROLE_TIER_HIGH

	if(SSfamilytree.is_human_job_of_type(H, SSfamilytree.high_tier_town_types))
		return ROLE_TIER_HIGH

	if(SSfamilytree.is_human_job_of_type(H, SSfamilytree.low_tier_job_types))
		return ROLE_TIER_LOW

	if(SSfamilytree.is_human_job_in_list(H, SSfamilytree.low_tier_job_titles))
		return ROLE_TIER_LOW

	return ROLE_TIER_NONE

/proc/familytree_role_tiers_compatible(mob/living/carbon/human/A, mob/living/carbon/human/B)
	var/tier_a = familytree_get_role_tier(A)
	var/tier_b = familytree_get_role_tier(B)

	if((tier_a == ROLE_TIER_LOW && tier_b == ROLE_TIER_HIGH) || (tier_a == ROLE_TIER_HIGH && tier_b == ROLE_TIER_LOW))
		return FALSE

	if(tier_a == tier_b)
		return TRUE

	if(tier_a == ROLE_TIER_NONE && tier_b != ROLE_TIER_LOW)
		return TRUE
	if(tier_b == ROLE_TIER_NONE && tier_a != ROLE_TIER_LOW)
		return TRUE

	if(tier_a == ROLE_TIER_LOW || tier_b == ROLE_TIER_LOW)
		var/datum/heritage/house = A.family_datum || B.family_datum
		if(house && is_elite_family(house))
			return FALSE

		var/mob/living/carbon/human/leader = house?.house_leader?.person || house?.founder?.person
		if(leader && (leader == A || leader == B))
			var/leader_tier = familytree_get_role_tier(leader)
			if(leader_tier != ROLE_TIER_LOW)
				return leader.allow_low_status_marriage

		if(tier_a == ROLE_TIER_LOW && tier_b != ROLE_TIER_LOW)
			return B.allow_low_status_marriage
		if(tier_b == ROLE_TIER_LOW && tier_a != ROLE_TIER_LOW)
			return A.allow_low_status_marriage
		return TRUE

	return TRUE

/proc/is_elite_family(datum/heritage/house)
	if(!house || house.members.len < 2)
		return FALSE

	var/high_count = 0
	for(var/datum/family_member/member as anything in house.members)
		if(member.cosmetic || member.phantom)
			continue
		if(member.person && familytree_get_role_tier(member.person) == ROLE_TIER_HIGH)
			high_count++
			if(high_count >= 2)
				return TRUE
	return FALSE

/proc/familytree_first_degree_tier_compatible(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!A || !B)
		return TRUE
	var/tier_a = familytree_get_role_tier(A)
	var/tier_b = familytree_get_role_tier(B)

	if(tier_a == tier_b)
		return TRUE

	if((tier_a == ROLE_TIER_HIGH && tier_b == ROLE_TIER_LOW) || (tier_a == ROLE_TIER_LOW && tier_b == ROLE_TIER_HIGH))
		return FALSE

	if(tier_a == ROLE_TIER_NONE && tier_b == ROLE_TIER_LOW)
		return A.allow_low_status_marriage
	if(tier_b == ROLE_TIER_NONE && tier_a == ROLE_TIER_LOW)
		return B.allow_low_status_marriage

	return TRUE

/datum/preferences
	var/polygamy_mode = POLYGAMY_DISABLED

/mob/living/carbon/human
	var/polygamy_mode = POLYGAMY_DISABLED

/proc/familytree_can_have_multiple_spouses(mob/living/carbon/human/H)
	if(!H)
		return FALSE

	if(H.polygamy_mode & POLYGAMY_ALLOW_MULTIPLE)
		return TRUE

	if(familytree_lore_allows_polygyny(H))
		return TRUE
	if(familytree_lore_allows_polyandry(H))
		return TRUE

	return FALSE

/proc/familytree_can_be_additional_spouse(mob/living/carbon/human/H)
	if(!H)
		return FALSE

	if(H.polygamy_mode & POLYGAMY_ALLOW_BE_SECOND)
		return TRUE

	return FALSE

/proc/familytree_lore_allows_polygyny(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	var/datum/patron/P = H.patron
	if(istype(P, /datum/patron/inhumen/baotha))
		return TRUE
	return FALSE

/proc/familytree_lore_allows_polyandry(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(isdarkelf(H))
		return TRUE
	return FALSE

/proc/familytree_polygamy_compatible(mob/living/carbon/human/seeker, mob/living/carbon/human/target)
	if(!seeker || !target)
		return FALSE

	var/seeker_has_spouse = seeker.spouse_mob || (seeker.family_member_datum && seeker.family_member_datum.get_spouse_members().len)
	var/target_has_spouse = target.spouse_mob || (target.family_member_datum && target.family_member_datum.get_spouse_members().len)

	if(!seeker_has_spouse && !target_has_spouse)
		return TRUE

	if(seeker_has_spouse && target_has_spouse)
		return FALSE

	if(seeker_has_spouse)
		if(!familytree_can_have_multiple_spouses(seeker))
			return FALSE
		if(!familytree_can_be_additional_spouse(target))
			return FALSE
		return TRUE

	if(target_has_spouse)
		if(!familytree_can_have_multiple_spouses(target))
			return FALSE
		if(!familytree_can_be_additional_spouse(seeker))
			return FALSE
		return TRUE

	return FALSE
