/datum/antagonist/vampire/lord
	var/ta_royal_ancestor_claimed = FALSE

/datum/controller/subsystem/familytree
	var/mob/living/carbon/human/ta_pending_royal_ancestor

/mob/living/carbon/human/proc/ta_claim_royal_ancestry()
	set name = "Стать частью семьи правителя"
	set category = "Vampire"
	set src = usr

	var/datum/antagonist/vampire/lord/lord_antag = mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	if(!lord_antag)
		return

	if(lord_antag.ta_royal_ancestor_claimed)
		to_chat(src, span_warning("Моя кровь уже вплетена в корни правящего дома."))
		return

	if(SSfamilytree.ta_pending_royal_ancestor && SSfamilytree.ta_pending_royal_ancestor != src)
		to_chat(src, span_warning("Иной древний уже вписал себя в эту династию."))
		return

	lord_antag.ta_royal_ancestor_claimed = TRUE

	if(SSfamilytree.ta_insert_royal_ancestor(src))
		return

	SSfamilytree.ta_pending_royal_ancestor = src
	to_chat(src, span_notice("Правящей династии ещё нет. Когда она явится, моё имя уже будет лежать в её основании."))

/datum/controller/subsystem/familytree/proc/ta_apply_pending_royal_ancestor()
	var/mob/living/carbon/human/claimant = ta_pending_royal_ancestor
	if(!claimant || QDELETED(claimant))
		ta_pending_royal_ancestor = null
		return
	if(ta_insert_royal_ancestor(claimant))
		ta_pending_royal_ancestor = null

/datum/controller/subsystem/familytree/proc/ta_insert_royal_ancestor(mob/living/carbon/human/claimant)
	if(!istype(claimant) || QDELETED(claimant) || !ruling_family)
		return FALSE

	var/datum/family_member/monarch = GetCurrentMonarch()
	if(!monarch)
		return FALSE

	var/generations_back = rand(4, 5)
	var/datum/family_member/descendant = monarch
	var/datum/family_member/ancestor

	for(var/step in 1 to generations_back)
		var/list/parents = descendant.get_parent_members()
		if(!parents.len)
			return FALSE
		ancestor = parents[1]
		if(step == generations_back)
			break
		descendant = ancestor

	if(!ancestor?.person || ancestor.person == claimant || ancestor == descendant)
		return FALSE
	if(ancestor.person.ckey)
		return FALSE

	var/mob/living/carbon/human/displaced = ancestor.person
	var/list/ancestor_parents = ancestor.get_parent_members()

	var/datum/family_member/claim_member = ruling_family.CreateFamilyMember(claimant)
	if(!claim_member)
		return FALSE

	claim_member.generation = ancestor.generation
	for(var/datum/family_member/forebear as anything in ancestor_parents)
		if(forebear && forebear != claim_member)
			claim_member.AddParent(forebear)

	descendant.AddParent(claim_member)
	ruling_family.RemovePersonFromFamily(displaced)

	ftlog("ROYAL_ANCESTOR: [claimant.real_name] spliced into '[ruling_family.housename]' at generation [claim_member.generation], [generations_back] back from the monarch", "INFO")
	to_chat(claimant, span_notice("Правящая кровь помнит меня. Я стою у истоков этой династии, [generations_back] поколений назад."))
	return TRUE
