/proc/familytree_is_clergy(datum/job/job)
	if(!job)
		return FALSE
	return SSfamilytree.is_job_of_type(job, SSfamilytree.clergy_job_types)

/datum/controller/subsystem/familytree
	var/list/clergy_job_types = list(
		/datum/job/roguetown/priest,
		/datum/job/roguetown/templar,
		/datum/job/roguetown/monk,
		/datum/job/roguetown/sexton,
		/datum/job/roguetown/keeper,
		/datum/job/roguetown/martyr,
		/datum/job/roguetown/druid,
	)

	var/list/high_clergy_job_types = list(
		/datum/job/roguetown/priest,
	)

	var/list/mid_clergy_job_types = list(
		/datum/job/roguetown/templar,
		/datum/job/roguetown/druid,
	)

#define SOCIAL_RANK_LOW 1
#define SOCIAL_RANK_MID 2
#define SOCIAL_RANK_HIGH 3

/proc/familytree_get_clergy_rank(mob/living/carbon/human/priest)
	var/datum/job/job = SSfamilytree.get_familytree_job(priest)
	if(!job)
		return SOCIAL_RANK_LOW

	if(SSfamilytree.is_job_of_type(job, SSfamilytree.high_clergy_job_types))
		return SOCIAL_RANK_HIGH
	if(SSfamilytree.is_job_of_type(job, SSfamilytree.mid_clergy_job_types))
		return SOCIAL_RANK_MID

	return SOCIAL_RANK_LOW

/proc/familytree_get_social_rank(mob/living/carbon/human/H)
	if(familytree_get_estate(H) == ESTATE_NOBLE)
		return SOCIAL_RANK_HIGH

	var/tier = familytree_get_role_tier(H)
	if(tier == ROLE_TIER_LOW)
		return SOCIAL_RANK_LOW

	return SOCIAL_RANK_MID

/proc/familytree_get_ritual_adoptive_coparent(datum/family_member/parent_member, mob/living/carbon/human/child)
	if(!parent_member || !child)
		return null
	for(var/datum/family_member/spouse_member as anything in parent_member.get_spouse_members())
		if(!spouse_member?.person || spouse_member.family != parent_member.family)
			continue
		if(!SSfamilytree.CanBeParentOf(spouse_member.person, child))
			continue
		return spouse_member
	return null

/proc/familytree_ritual_adopt(mob/living/carbon/human/parent, mob/living/carbon/human/child)
	if(!parent || !child)
		return FALSE
	if(!parent.family_datum)
		return FALSE
	if(child.family_datum == parent.family_datum)
		return FALSE

	var/datum/family_member/parent_member = parent.family_member_datum
	if(!parent_member)
		return FALSE

	var/datum/family_member/coparent_member = familytree_get_ritual_adoptive_coparent(parent_member, child)
	parent.family_datum.AddToFamily(child, parent_member, coparent_member, TRUE)
	return TRUE

/proc/familytree_vampire_bind(mob/living/carbon/human/sire, mob/living/carbon/human/progeny)
	if(!sire || !progeny)
		return FALSE

	if(!sire.family_datum)
		var/datum/heritage/new_family = new /datum/heritage(sire, null)
		sire.family_datum = new_family
		SSfamilytree.register_family(new_family)

	sire.family_datum.AddToFamily(progeny, sire.family_member_datum, null, TRUE)
	return TRUE

/datum/controller/subsystem/familytree/proc/AssignWithDesiredRole(mob/living/carbon/human/H)
	if(!H)
		return

	var/desired = H.desired_relative_role

	switch(desired)
		if(RELATIVE_SIBLING)
			AssignToHouse(H, "sibling")
		if(RELATIVE_PARENT)
			AssignToHouse(H, "parent")
		if(RELATIVE_CHILD)
			AssignToHouse(H, "child")
		if(RELATIVE_UNCLE_AUNT)
			AssignToHouse(H, "uncle_aunt")
		if(RELATIVE_SPOUSE)
			if(familytree_pref_is_create(H.familytree_pref))
				AssignNewlyWed(H)
			else
				AssignToFamily(H)
		else
			AssignToHouse(H)

/datum/controller/subsystem/familytree/proc/AssignAsSibling(mob/living/carbon/human/H)
	if(!H)
		return

	var/our_race = H.dna.species.name
	var/our_isolated = is_isolated(H)

	for(var/datum/heritage/house as anything in families)
		if(!house.housename || !house.member_nodes.len)
			continue
		if(!house_race_compatible(house, our_race, our_isolated, H))
			continue

		for(var/datum/family_member/member as anything in house.members)
			if(!member.person || !member.person.client)
				continue
			if(!CanBeSiblings(member.person.age, H.age))
				continue
			if(GetSpeciesCompatibilityFailureReason(H, member.person))
				continue
			if(!familytree_estates_compatible(H, member.person))
				continue
			if(!familytree_role_tiers_compatible(H, member.person))
				continue

			var/list/member_parents = member.get_parent_members()
			var/datum/family_member/parent1 = member_parents.len > 0 ? member_parents[1] : null
			var/datum/family_member/parent2 = member_parents.len > 1 ? member_parents[2] : null
			house.AddToFamily(H, parent1, parent2, FALSE)
			return

	ftlog("AssignAsSibling: [H.real_name] → NO suitable sibling house found")

/datum/controller/subsystem/familytree/proc/AssignAsParent(mob/living/carbon/human/H)
	if(!H)
		return

	var/our_race = H.dna.species.name
	var/our_isolated = is_isolated(H)

	for(var/datum/heritage/house as anything in families)
		if(!house.housename || !house.member_nodes.len)
			continue
		if(!house_race_compatible(house, our_race, our_isolated, H))
			continue

		for(var/datum/family_member/member as anything in house.members)
			if(!member.person || !member.person.client)
				continue
			if(!CanBeParentOf(H, member.person))
				continue
			if(!familytree_biological_parent_allowed(H, member.person, house))
				continue
			if(member.get_parent_members().len >= 2)
				continue
			var/parent_pair_allowed = TRUE
			for(var/datum/family_member/existing_parent as anything in member.get_parent_members())
				if(existing_parent?.person && !familytree_biological_parent_pair_allowed(H, existing_parent.person, member.person, house))
					parent_pair_allowed = FALSE
					break
			if(!parent_pair_allowed)
				continue
			if(GetSpeciesCompatibilityFailureReason(H, member.person))
				continue

			var/datum/family_member/new_member = house.CreateFamilyMember(H)
			if(new_member)
				member.AddParent(new_member)
				return

	ftlog("AssignAsParent: [H.real_name] → NO suitable child found")

/datum/family_curse
	var/name
	var/description
	var/curse_type
	var/severity = 1
	var/inherited = TRUE
	var/tmp/datum/weakref/cursed_by
	var/when_cursed
	var/blessing = FALSE

	var/list/curse_effects = list()


/datum/family_curse/misfortune
	name = "Family Misfortune"
	description = "Bad luck follows this bloodline"
	curse_effects = list(/datum/status_effect/misfortune)

/datum/status_effect/misfortune
	id = "family_misfortune"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/family_curse/misfortune
	effectedstats = list(STATKEY_LCK = -2)

/atom/movable/screen/alert/status_effect/family_curse/misfortune
	name = "Family Misfortune"
	desc = "Your family's curse brings ill fortune to your steps."
	icon_state = "debuff"

	var/static/list/misfortune_tips = list(
		"Dark clouds seem to follow you wherever you go...",
		"You feel the weight of your family's curse.",
		"Even simple tasks seem to go wrong more often.",
		"The fates seem to conspire against you.",
		"Your ancestors' misdeeds continue to haunt you."
	)

/atom/movable/screen/alert/status_effect/family_curse/misfortune/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(desc == initial(desc))
		desc = "[initial(desc)] [pick(misfortune_tips)]"


/datum/family_curse/hunger
	name = "Insatiable Appetite"
	description = "This bloodline is voracious in its hunger."
	curse_effects = list(/datum/status_effect/hunger)

/datum/status_effect/hunger
	id = "family_hunger"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/family_curse/hunger

/atom/movable/screen/alert/status_effect/family_curse/hunger
	name = "Insatiable Appetite"
	desc = "Your family is cursed with a hunger that is rarely sated."
	icon_state = "debuff"

	var/static/list/hunger_tips = list(
		"Your stomach growls like a caged volf...",
		"You feel the weight of your family's curse.",
		"Even the grandest feast was never enough."
	)

/atom/movable/screen/alert/status_effect/family_curse/hunger/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(desc == initial(desc))
		desc = "[initial(desc)] [pick(hunger_tips)]"


/atom/movable/screen/alert/status_effect/family_curse/Click(location, control, params)
	. = ..()
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(!user.client || !user.family_datum)
		return

	user.family_datum.OpenCursePanel(user)
