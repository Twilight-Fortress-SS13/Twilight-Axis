/datum/controller/subsystem/familytree
	var/storyteller_points_calculated = FALSE
	var/good_family_count = 0
	var/cheater_count = 0

/datum/controller/subsystem/familytree/proc/calculate_storyteller_influence()
	if(storyteller_points_calculated)
		return

	good_family_count = 0
	cheater_count = 0

	var/astrata_bonus = 0
	var/eora_bonus = 0
	var/baotha_bonus = 0
	var/psydon_bonus = 0
	var/ravox_bonus = 0
	var/noc_bonus = 0
	var/dendor_bonus = 0
	var/abyssor_bonus = 0
	var/malum_bonus = 0
	var/pestra_bonus = 0
	var/xylix_bonus = 0
	var/matthios_bonus = 0
	var/zizo_bonus = 0

	for(var/datum/heritage/house as anything in families)
		if(!house.member_nodes.len)
			continue

		if(check_house_all_wildkin(house))
			dendor_bonus += house.member_nodes.len

		var/list/married_pairs = get_married_pairs(house)
		if(!married_pairs.len)
			continue

		for(var/list/pair in married_pairs)
			var/datum/family_member/spouse_a = pair[1]
			var/datum/family_member/spouse_b = pair[2]
			if(!spouse_a?.person || !spouse_b?.person)
				continue

			var/mob/living/carbon/human/A = spouse_a.person
			var/mob/living/carbon/human/B = spouse_b.person

			var/same_race = (A.dna?.species?.type == B.dna?.species?.type)
			var/same_genitals = check_same_genitals(A, B)

			var/datum/patron/patron_a = A.patron
			var/datum/patron/patron_b = B.patron
			var/is_astrata_family = istype(patron_a, /datum/patron/divine/astrata) && istype(patron_b, /datum/patron/divine/astrata)
			var/is_eora_family = istype(patron_a, /datum/patron/divine/eora) && istype(patron_b, /datum/patron/divine/eora)
			var/has_inhumen = istype(patron_a, /datum/patron/inhumen) || istype(patron_b, /datum/patron/inhumen)

			if(same_race && !same_genitals)
				astrata_bonus += is_astrata_family ? 3 : 1
				good_family_count++

			eora_bonus += is_eora_family ? 3 : 1
			good_family_count++

			if(!same_race || same_genitals)
				baotha_bonus += has_inhumen ? 3 : 1

			if(!has_inhumen)
				psydon_bonus += 1
			else
				psydon_bonus -= 2

			if(check_member_combat_expert(A) && check_member_combat_expert(B))
				ravox_bonus += 3

			if(check_member_magic_expert(A) && check_member_magic_expert(B))
				noc_bonus += 2

			var/a_noble = HAS_TRAIT(A, TRAIT_NOBLE)
			var/b_noble = HAS_TRAIT(B, TRAIT_NOBLE)

			if(a_noble && b_noble)
				astrata_bonus += 2

			if(check_member_fisher(A) || check_member_fisher(B))
				abyssor_bonus += 2

			if(check_member_craft_expert(A) && check_member_craft_expert(B))
				malum_bonus += 2

			if(check_member_medical_expert(A) && check_member_medical_expert(B))
				pestra_bonus += 2

			if(check_member_rogue_expert(A) && check_member_rogue_expert(B))
				xylix_bonus += 2

			if((a_noble && !b_noble) || (!a_noble && b_noble))
				matthios_bonus += 2

			var/has_matthios_patron = istype(patron_a, /datum/patron/inhumen/matthios) || istype(patron_b, /datum/patron/inhumen/matthios)
			if(has_matthios_patron && (a_noble || b_noble))
				matthios_bonus -= 2

			if(istype(patron_a, /datum/patron/inhumen/zizo) && istype(patron_b, /datum/patron/inhumen/zizo))
				zizo_bonus += 2

			if(check_member_skill_expert(A, /datum/skill/magic/druidic) && check_member_skill_expert(B, /datum/skill/magic/druidic))
				dendor_bonus += 2

			if(check_member_skill_expert(A, /datum/skill/magic/blood) && check_member_skill_expert(B, /datum/skill/magic/blood))
				zizo_bonus += 2

			if(check_member_skill_expert(A, /datum/skill/magic/holy) && check_member_skill_expert(B, /datum/skill/magic/holy))
				noc_bonus += 1
				astrata_bonus += 1

	if(cheater_count > 0)
		eora_bonus -= cheater_count * 2
		astrata_bonus -= cheater_count

	apply_storyteller_bonus(/datum/storyteller/astrata, astrata_bonus)
	apply_storyteller_bonus(/datum/storyteller/eora, eora_bonus)
	apply_storyteller_bonus(/datum/storyteller/baotha, baotha_bonus)
	apply_storyteller_bonus(/datum/storyteller/psydon, psydon_bonus)
	apply_storyteller_bonus(/datum/storyteller/ravox, ravox_bonus)
	apply_storyteller_bonus(/datum/storyteller/noc, noc_bonus)
	apply_storyteller_bonus(/datum/storyteller/dendor, dendor_bonus)
	apply_storyteller_bonus(/datum/storyteller/abyssor, abyssor_bonus)
	apply_storyteller_bonus(/datum/storyteller/malum, malum_bonus)
	apply_storyteller_bonus(/datum/storyteller/pestra, pestra_bonus)
	apply_storyteller_bonus(/datum/storyteller/xylix, xylix_bonus)
	apply_storyteller_bonus(/datum/storyteller/matthios, matthios_bonus)
	apply_storyteller_bonus(/datum/storyteller/zizo, zizo_bonus)

	storyteller_points_calculated = TRUE

/datum/controller/subsystem/familytree/proc/get_married_pairs(datum/heritage/house)
	var/list/pairs = list()
	var/list/processed = list()

	for(var/datum/family_node/node as anything in house.member_nodes)
		if(!node.person || (node in processed))
			processed += node
			continue
		for(var/datum/family_edge/edge as anything in node.get_edges_of_type("spouse"))
			var/datum/family_node/other = edge.other_end(node)
			if(!other?.person || (other in processed))
				continue
			var/datum/family_member/member_a = node.person.family_member_datum
			var/datum/family_member/member_b = other.person.family_member_datum
			if(!member_a || !member_b)
				continue
			pairs += list(list(member_a, member_b))
		processed += node

	return pairs

/datum/controller/subsystem/familytree/proc/check_same_genitals(mob/living/carbon/human/A, mob/living/carbon/human/B)
	var/a_has_penis = A.getorganslot(ORGAN_SLOT_PENIS) != null
	var/b_has_penis = B.getorganslot(ORGAN_SLOT_PENIS) != null
	var/a_has_vagina = A.getorganslot(ORGAN_SLOT_VAGINA) != null
	var/b_has_vagina = B.getorganslot(ORGAN_SLOT_VAGINA) != null

	if(a_has_penis && b_has_penis && !a_has_vagina && !b_has_vagina)
		return TRUE
	if(a_has_vagina && b_has_vagina && !a_has_penis && !b_has_penis)
		return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/apply_storyteller_bonus(storyteller_type, bonus)
	if(!bonus)
		return
	var/datum/storyteller/current = SSgamemode?.current_storyteller
	if(!current || current.type != storyteller_type)
		return
	current.bonus_points += bonus

/datum/controller/subsystem/familytree/proc/register_cheater(mob/living/carbon/human/cheater)
	if(!cheater)
		return
	cheater_count++
	to_chat(cheater, span_warning("Вы опорочили Эору."))

/datum/controller/subsystem/familytree/proc/on_family_formed(datum/heritage/house)
	if(!house || storyteller_points_calculated)
		return
	recalculate_storyteller_for_house(house)

/datum/controller/subsystem/familytree/proc/recalculate_storyteller_for_house(datum/heritage/house)
	if(!house)
		return

	var/list/married_pairs = get_married_pairs(house)
	if(!married_pairs.len)
		return

	var/astrata_delta = 0
	var/eora_delta = 0
	var/baotha_delta = 0
	var/psydon_delta = 0
	var/ravox_delta = 0
	var/noc_delta = 0
	var/dendor_delta = 0
	var/abyssor_delta = 0
	var/malum_delta = 0
	var/pestra_delta = 0
	var/xylix_delta = 0
	var/matthios_delta = 0
	var/zizo_delta = 0

	if(check_house_all_wildkin(house))
		dendor_delta += house.member_nodes.len

	for(var/list/pair in married_pairs)
		var/datum/family_member/spouse_a = pair[1]
		var/datum/family_member/spouse_b = pair[2]
		if(!spouse_a?.person || !spouse_b?.person)
			continue

		var/mob/living/carbon/human/A = spouse_a.person
		var/mob/living/carbon/human/B = spouse_b.person

		var/same_race = (A.dna?.species?.type == B.dna?.species?.type)
		var/same_genitals = check_same_genitals(A, B)

		var/datum/patron/patron_a = A.patron
		var/datum/patron/patron_b = B.patron
		var/is_astrata = istype(patron_a, /datum/patron/divine/astrata) && istype(patron_b, /datum/patron/divine/astrata)
		var/is_eora = istype(patron_a, /datum/patron/divine/eora) && istype(patron_b, /datum/patron/divine/eora)
		var/has_inhumen = istype(patron_a, /datum/patron/inhumen) || istype(patron_b, /datum/patron/inhumen)

		if(same_race && !same_genitals)
			astrata_delta += is_astrata ? 3 : 1

		eora_delta += is_eora ? 3 : 1

		if(!same_race || same_genitals)
			baotha_delta += has_inhumen ? 3 : 1

		if(!has_inhumen)
			psydon_delta += 1
		else
			psydon_delta -= 2

		if(check_member_combat_expert(A) && check_member_combat_expert(B))
			ravox_delta += 3

		if(check_member_magic_expert(A) && check_member_magic_expert(B))
			noc_delta += 2

		var/a_noble = HAS_TRAIT(A, TRAIT_NOBLE)
		var/b_noble = HAS_TRAIT(B, TRAIT_NOBLE)

		if(a_noble && b_noble)
			astrata_delta += 2

		if(check_member_fisher(A) || check_member_fisher(B))
			abyssor_delta += 2

		if(check_member_craft_expert(A) && check_member_craft_expert(B))
			malum_delta += 2

		if(check_member_medical_expert(A) && check_member_medical_expert(B))
			pestra_delta += 2

		if(check_member_rogue_expert(A) && check_member_rogue_expert(B))
			xylix_delta += 2

		if((a_noble && !b_noble) || (!a_noble && b_noble))
			matthios_delta += 2

		var/has_matthios_patron = istype(patron_a, /datum/patron/inhumen/matthios) || istype(patron_b, /datum/patron/inhumen/matthios)
		if(has_matthios_patron && (a_noble || b_noble))
			matthios_delta -= 2

		if(istype(patron_a, /datum/patron/inhumen/zizo) && istype(patron_b, /datum/patron/inhumen/zizo))
			zizo_delta += 2

		if(check_member_skill_expert(A, /datum/skill/magic/druidic) && check_member_skill_expert(B, /datum/skill/magic/druidic))
			dendor_delta += 2

		if(check_member_skill_expert(A, /datum/skill/magic/blood) && check_member_skill_expert(B, /datum/skill/magic/blood))
			zizo_delta += 2

		if(check_member_skill_expert(A, /datum/skill/magic/holy) && check_member_skill_expert(B, /datum/skill/magic/holy))
			noc_delta += 1
			astrata_delta += 1

	apply_storyteller_bonus(/datum/storyteller/astrata, astrata_delta)
	apply_storyteller_bonus(/datum/storyteller/eora, eora_delta)
	apply_storyteller_bonus(/datum/storyteller/baotha, baotha_delta)
	apply_storyteller_bonus(/datum/storyteller/psydon, psydon_delta)
	apply_storyteller_bonus(/datum/storyteller/ravox, ravox_delta)
	apply_storyteller_bonus(/datum/storyteller/noc, noc_delta)
	apply_storyteller_bonus(/datum/storyteller/dendor, dendor_delta)
	apply_storyteller_bonus(/datum/storyteller/abyssor, abyssor_delta)
	apply_storyteller_bonus(/datum/storyteller/malum, malum_delta)
	apply_storyteller_bonus(/datum/storyteller/pestra, pestra_delta)
	apply_storyteller_bonus(/datum/storyteller/xylix, xylix_delta)
	apply_storyteller_bonus(/datum/storyteller/matthios, matthios_delta)
	apply_storyteller_bonus(/datum/storyteller/zizo, zizo_delta)

/datum/controller/subsystem/familytree/proc/on_intimacy_event(mob/living/carbon/human/H)
	if(!H || !H.family_datum)
		return

	var/datum/family_node/node = get_family_node(H)
	if(!node)
		return

	var/list/spouse_edges = node.get_edges_of_type("spouse")
	if(!spouse_edges.len)
		return

	for(var/datum/family_edge/edge as anything in spouse_edges)
		var/datum/family_node/other = edge.other_end(node)
		var/mob/living/carbon/human/spouse_person = other?.person
		if(!spouse_person || spouse_person == H)
			continue

		var/pair_key = make_intimacy_key(H, spouse_person)
		if(intimacy_pairs[pair_key])
			continue

		intimacy_pairs[pair_key] = TRUE
		apply_storyteller_bonus(/datum/storyteller/astrata, -1)
		apply_storyteller_bonus(/datum/storyteller/eora, -1)

/datum/controller/subsystem/familytree/proc/make_intimacy_key(mob/living/carbon/human/A, mob/living/carbon/human/B)
	var/ref_a = "\ref[A]"
	var/ref_b = "\ref[B]"
	if(ref_a > ref_b)
		return "[ref_a]-[ref_b]"
	return "[ref_b]-[ref_a]"

/datum/controller/subsystem/familytree/proc/check_member_skill_expert(mob/living/carbon/human/H, skill_type)
	if(!H || !skill_type)
		return FALSE
	return H.get_skill_level(skill_type) >= SKILL_LEVEL_EXPERT

/datum/controller/subsystem/familytree/proc/check_member_combat_expert(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	var/list/combat_skills = list(
		/datum/skill/combat/knives,
		/datum/skill/combat/swords,
		/datum/skill/combat/polearms,
		/datum/skill/combat/maces,
		/datum/skill/combat/axes,
		/datum/skill/combat/whipsflails,
		/datum/skill/combat/bows,
		/datum/skill/combat/crossbows,
		/datum/skill/combat/wrestling,
		/datum/skill/combat/unarmed,
		/datum/skill/combat/shields,
		/datum/skill/combat/slings,
		/datum/skill/combat/staves,
	)
	for(var/skill_type in combat_skills)
		if(H.get_skill_level(skill_type) >= SKILL_LEVEL_EXPERT)
			return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/check_member_magic_expert(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	var/list/magic_skills = list(
		/datum/skill/magic/holy,
		/datum/skill/magic/blood,
		/datum/skill/magic/arcane,
		/datum/skill/magic/druidic,
	)
	for(var/skill_type in magic_skills)
		if(H.get_skill_level(skill_type) >= SKILL_LEVEL_EXPERT)
			return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/check_member_craft_expert(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	var/list/craft_skills = list(
		/datum/skill/craft/weaponsmithing,
		/datum/skill/craft/armorsmithing,
		/datum/skill/craft/blacksmithing,
		/datum/skill/craft/engineering,
		/datum/skill/craft/sewing,
	)
	for(var/skill_type in craft_skills)
		if(H.get_skill_level(skill_type) >= SKILL_LEVEL_EXPERT)
			return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/check_member_medical_expert(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(H.get_skill_level(/datum/skill/misc/medicine) >= SKILL_LEVEL_EXPERT)
		return TRUE
	if(H.get_skill_level(/datum/skill/craft/alchemy) >= SKILL_LEVEL_EXPERT)
		return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/check_member_rogue_expert(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(H.get_skill_level(/datum/skill/misc/sneaking) >= SKILL_LEVEL_EXPERT)
		return TRUE
	if(H.get_skill_level(/datum/skill/misc/lockpicking) >= SKILL_LEVEL_EXPERT)
		return TRUE
	if(H.get_skill_level(/datum/skill/misc/stealing) >= SKILL_LEVEL_EXPERT)
		return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/check_member_fisher(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	return is_human_job_in_list(H, list("Fisher"))

/datum/controller/subsystem/familytree/proc/check_house_all_wildkin(datum/heritage/house)
	if(!house || !house.member_nodes.len)
		return FALSE
	for(var/datum/family_node/node as anything in house.member_nodes)
		if(!node.person)
			continue
		if(!istype(node.person.dna?.species, /datum/species/demihuman))
			return FALSE
	return TRUE
