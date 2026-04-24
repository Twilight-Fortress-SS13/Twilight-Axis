#define BOND_SPOUSE_M "Spouse (M)"
#define BOND_SPOUSE_F "Spouse (F)"
#define BOND_ADOPTED_SON "Adopted Son"
#define BOND_ADOPTED_DAUGHTER "Adopted Daughter"
#define BOND_BROTHER "Brother"
#define BOND_SISTER "Sister"

/proc/bond_type_display(bond_type)
	switch(bond_type)
		if(BOND_SPOUSE_M)
			return "Супруг"
		if(BOND_SPOUSE_F)
			return "Супруга"
		if(BOND_ADOPTED_SON)
			return "Приёмный сын"
		if(BOND_ADOPTED_DAUGHTER)
			return "Приёмная дочь"
		if(BOND_BROTHER)
			return "Брат"
		if(BOND_SISTER)
			return "Сестра"
	return bond_type

/proc/bond_type_instrumental(bond_type)
	switch(bond_type)
		if(BOND_SPOUSE_M)
			return "супругом"
		if(BOND_SPOUSE_F)
			return "супругой"
		if(BOND_ADOPTED_SON)
			return "приёмным сыном"
		if(BOND_ADOPTED_DAUGHTER)
			return "приёмной дочерью"
		if(BOND_BROTHER)
			return "братом"
		if(BOND_SISTER)
			return "сестрой"
	return bond_type

/proc/bond_type_is_marriage(bond_type)
	return (bond_type == BOND_SPOUSE_M || bond_type == BOND_SPOUSE_F)

/proc/bond_type_is_adoption(bond_type)
	return (bond_type == BOND_ADOPTED_SON || bond_type == BOND_ADOPTED_DAUGHTER)

/proc/bond_type_is_sibling(bond_type)
	return (bond_type == BOND_BROTHER || bond_type == BOND_SISTER)

#define FAMILYTREE_BOND_RANGE 7

/mob/living/carbon/human/proc/familytree_establish_bond()
	set name = "Establish Bond"
	set category = "Cleric"
	set desc = "Засвидетельствовать перед богами семейные узы двух присутствующих."

	var/mob/living/carbon/human/priest = src
	if(!priest.mind || !priest.client)
		return

	if(!priest.devotion)
		to_chat(priest, span_warning("Лишь служитель богов может провести такой обряд."))
		return

	if(priest.stat != CONSCIOUS)
		to_chat(priest, span_warning("Вы не в состоянии провести обряд."))
		return

	SSfamilytree.ftlog("ESTABLISH_BOND cast by [priest.real_name] ([priest.ckey])")

	var/holy_level = priest.get_skill_level(/datum/skill/magic/holy)
	var/can_bypass = (holy_level >= SKILL_LEVEL_LEGENDARY)

	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in view(FAMILYTREE_BOND_RANGE, priest))
		if(H == priest || H.stat == DEAD || !H.client || !H.ckey)
			continue
		candidates += H

	if(candidates.len < 2)
		to_chat(priest, span_warning("Недостаточно людей рядом для проведения обряда."))
		return

	var/mob/living/carbon/human/person1 = tgui_input_list(priest, "Кто готов засвидетельствовать свои отношения перед богами?", "Establish Bond", candidates)
	if(!person1 || QDELETED(person1) || !(person1 in view(FAMILYTREE_BOND_RANGE, priest)))
		return

	var/list/bond_options = list(
		BOND_SPOUSE_M,
		BOND_SPOUSE_F,
		BOND_ADOPTED_SON,
		BOND_ADOPTED_DAUGHTER,
		BOND_BROTHER,
		BOND_SISTER,
	)

	var/bond_type = tgui_input_list(priest, "[person1.real_name] становится:", "Bond Type", bond_options)
	if(!bond_type)
		return

	candidates -= person1

	var/list/valid_second = list()
	for(var/mob/living/carbon/human/candidate in candidates)
		if(can_bypass)
			valid_second += candidate
			continue
		if(bond_type_is_marriage(bond_type))
			if(SSfamilytree.GetSpeciesCompatibilityFailureReason(person1, candidate))
				continue
			if(!familytree_estates_compatible(person1, candidate))
				continue
			if(!familytree_role_tiers_compatible(person1, candidate))
				continue
			if(!familytree_polygamy_compatible(person1, candidate))
				continue
		else
			if(SSfamilytree.is_isolated(person1) || SSfamilytree.is_isolated(candidate))
				if(person1.dna?.species?.type != candidate.dna?.species?.type)
					continue
		valid_second += candidate

	if(!valid_second.len)
		to_chat(priest, span_warning("Нет подходящего кандидата."))
		return

	var/mob/living/carbon/human/person2 = tgui_input_list(priest, "По отношению к кому?", "Establish Bond", valid_second)
	if(!person2 || QDELETED(person2) || !(person2 in view(FAMILYTREE_BOND_RANGE, priest)) || !(person1 in view(FAMILYTREE_BOND_RANGE, priest)))
		return

	if(bond_type_is_marriage(bond_type) && person1.spouse_mob == person2)
		to_chat(priest, span_warning("Они уже состоят в браке."))
		return

	if(!can_bypass && bond_type_is_marriage(bond_type) && !familytree_polygamy_compatible(person1, person2))
		to_chat(priest, span_warning("РЈС‡Р°СЃС‚РЅРёРєРё РЅРµ РіРѕС‚РѕРІС‹ Рє С‚Р°РєРѕРјСѓ Р±СЂР°РєСѓ."))
		return

	var/instr = bond_type_instrumental(bond_type)

	var/priest_confirm = tgui_alert(priest, "[person1.real_name] становится [instr] [person2.real_name]. Провести обряд?", "Establish Bond", list("Да", "Нет"))
	if(priest_confirm != "Да")
		return

	if(!(person1 in view(FAMILYTREE_BOND_RANGE, priest)) || !(person2 in view(FAMILYTREE_BOND_RANGE, priest)))
		to_chat(priest, span_warning("Участники разошлись."))
		return

	var/offer1 = tgui_alert(person1, "Вы становитесь [instr] [person2.real_name]. Согласны?", "Священный обряд", list("Да", "Нет"))
	if(offer1 != "Да")
		to_chat(priest, span_warning("[person1.real_name] отказался(ась)."))
		return

	var/offer2 = tgui_alert(person2, "[person1.real_name] становится вашим(ей) [instr]. Согласны?", "Священный обряд", list("Да", "Нет"))
	if(offer2 != "Да")
		to_chat(priest, span_warning("[person2.real_name] отказался(ась)."))
		return

	if(!(person1 in view(FAMILYTREE_BOND_RANGE, priest)) || !(person2 in view(FAMILYTREE_BOND_RANGE, priest)))
		to_chat(priest, span_warning("Участники разошлись."))
		return

	var/success = FALSE

	if(bond_type_is_marriage(bond_type))
		var/datum/heritage/family = person1.MarryTo(person2)
		if(family)
			success = TRUE
			SSfamilytree.on_family_formed(family)
			SSfamilytree.check_bond_divine_wrath(priest, person1, person2)

	else if(bond_type_is_adoption(bond_type))
		success = familytree_holy_adopt(person1, person2)

	else if(bond_type_is_sibling(bond_type))
		success = familytree_holy_sibling(person1, person2)

	if(!success)
		to_chat(priest, span_warning("Не удалось провести обряд."))
		return

	var/announcement = "[priest.real_name] провёл(а) обряд: [person1.real_name] теперь [instr] [person2.real_name]."
	for(var/mob/living/carbon/human/M in view(FAMILYTREE_BOND_RANGE, priest))
		to_chat(M, span_love(announcement))

#define FAMILYTREE_DIVORCE_RANGE 7

/mob/living/carbon/human/proc/familytree_dissolve_marriage()
	set name = "Dissolve Marriage"
	set category = "Cleric"
	set desc = "Расторгнуть брак двух присутствующих."

	var/mob/living/carbon/human/priest = src
	if(!priest.mind || !priest.client)
		return

	if(!priest.devotion)
		to_chat(priest, span_warning("Лишь служитель богов может провести такой обряд."))
		return

	if(priest.stat != CONSCIOUS)
		to_chat(priest, span_warning("Вы не в состоянии провести обряд."))
		return

	SSfamilytree.ftlog("DISSOLVE_MARRIAGE cast by [priest.real_name] ([priest.ckey])")

	var/list/married_people = list()
	for(var/mob/living/carbon/human/H in view(FAMILYTREE_DIVORCE_RANGE, priest))
		if(H == priest || H.stat == DEAD || !H.client || !H.ckey)
			continue
		if(H.spouse_mob && H.family_member_datum?.get_spouse_members().len)
			married_people += H

	if(!married_people.len)
		to_chat(priest, span_warning("Рядом нет людей, состоящих в браке."))
		return

	var/mob/living/carbon/human/person1 = tgui_input_list(priest, "Чей брак расторгнуть?", "Dissolve Marriage", married_people)
	if(!person1 || QDELETED(person1) || !(person1 in view(FAMILYTREE_DIVORCE_RANGE, priest)))
		return

	var/mob/living/carbon/human/person2 = person1.spouse_mob
	if(!person2 || QDELETED(person2) || !(person2 in view(FAMILYTREE_DIVORCE_RANGE, priest)))
		to_chat(priest, span_warning("Супруг(а) должен(а) быть рядом."))
		return

	var/confirm1 = tgui_alert(person1, "Согласны на расторжение брака с [person2.real_name]?", "Dissolve Marriage", list("Да", "Нет"))
	if(confirm1 != "Да")
		to_chat(priest, span_warning("[person1.real_name] не дал(а) согласие."))
		return

	var/confirm2 = tgui_alert(person2, "Согласны на расторжение брака с [person1.real_name]?", "Dissolve Marriage", list("Да", "Нет"))
	if(confirm2 != "Да")
		to_chat(priest, span_warning("[person2.real_name] не дал(а) согласие."))
		return

	if(!(person1 in view(FAMILYTREE_DIVORCE_RANGE, priest)) || !(person2 in view(FAMILYTREE_DIVORCE_RANGE, priest)))
		to_chat(priest, span_warning("Участники разошлись."))
		return

	var/datum/family_member/member1 = person1.family_member_datum
	var/datum/family_member/member2 = person2.family_member_datum

	if(member1 && member2)
		member1.RemoveSpouse(member2, TRUE)

	person1.spouse_mob = null
	person2.spouse_mob = null

	var/announcement = "[priest.real_name] расторг(ла) брак между [person1.real_name] и [person2.real_name]."
	for(var/mob/living/carbon/human/M in view(FAMILYTREE_DIVORCE_RANGE, priest))
		to_chat(M, span_warning(announcement))

/proc/familytree_holy_adopt(mob/living/carbon/human/child, mob/living/carbon/human/parent)
	if(!child || !parent)
		return FALSE

	if(!parent.family_datum)
		var/datum/heritage/new_family = new /datum/heritage(parent, null)
		parent.family_datum = new_family
		SSfamilytree.register_family(new_family)

	var/datum/family_member/parent_member = parent.family_member_datum
	if(!parent_member)
		return FALSE

	parent.family_datum.AddToFamily(child, parent_member, null, TRUE)
	return (child.family_datum != null)

/proc/familytree_holy_sibling(mob/living/carbon/human/person1, mob/living/carbon/human/person2)
	if(!person1 || !person2)
		return FALSE

	var/mob/living/carbon/human/new_sibling = person1
	var/mob/living/carbon/human/anchor_person = person2
	var/datum/heritage/target_house = person2.family_datum
	if(!target_house && person1.family_datum)
		target_house = person1.family_datum
		new_sibling = person2
		anchor_person = person1

	if(!target_house)
		target_house = new /datum/heritage(person2, null)
		person2.family_datum = target_house
		SSfamilytree.register_family(target_house)

	var/datum/family_member/existing_member = anchor_person.family_member_datum
	if(!existing_member)
		return FALSE

	var/list/existing_parents = existing_member.get_parent_members()
	var/datum/family_member/parent1 = existing_parents.len > 0 ? existing_parents[1] : null
	var/datum/family_member/parent2 = existing_parents.len > 1 ? existing_parents[2] : null
	if(!parent1)
		var/datum/family_member/phantom_parent = new /datum/family_member(null, target_house)
		phantom_parent.generation = -1
		phantom_parent.phantom = TRUE
		target_house.members += phantom_parent
		existing_member.AddParent(phantom_parent)
		parent1 = phantom_parent

	target_house.AddToFamily(new_sibling, parent1, parent2, FALSE)
	return (new_sibling.family_datum == target_house)

/datum/controller/subsystem/familytree/proc/evaluate_pair_negative_influence(mob/living/carbon/human/A, mob/living/carbon/human/B)
	var/list/harmed_patrons = list()

	var/datum/patron/patron_a = A.patron
	var/datum/patron/patron_b = B.patron
	var/has_inhumen = istype(patron_a, /datum/patron/inhumen) || istype(patron_b, /datum/patron/inhumen)

	if(has_inhumen)
		harmed_patrons += /datum/patron/old_god

	var/a_noble = HAS_TRAIT(A, TRAIT_NOBLE)
	var/b_noble = HAS_TRAIT(B, TRAIT_NOBLE)

	var/has_matthios_patron = istype(patron_a, /datum/patron/inhumen/matthios) || istype(patron_b, /datum/patron/inhumen/matthios)
	if(has_matthios_patron && (a_noble || b_noble))
		harmed_patrons += /datum/patron/inhumen/matthios

	var/same_race = (A.dna?.species?.type == B.dna?.species?.type)
	var/same_genitals = check_same_genitals(A, B)
	if(!same_race || same_genitals)
		if(!has_inhumen)
			harmed_patrons += /datum/patron/divine/astrata

	return harmed_patrons

/datum/controller/subsystem/familytree/proc/get_patron_names(list/patron_types)
	var/list/names = list()
	for(var/patron_type in patron_types)
		var/datum/patron/P = GLOB.patronlist[patron_type]
		if(P)
			names += P.name
		else
			names += "[patron_type]"
	return names

/datum/controller/subsystem/familytree/proc/check_bond_divine_wrath(mob/living/carbon/human/priest, mob/living/carbon/human/person1, mob/living/carbon/human/person2)
	if(!priest || !person1 || !person2)
		return

	if(istype(priest.patron, /datum/patron/old_god))
		return

	if(!priest.patron)
		return

	var/list/harmed = evaluate_pair_negative_influence(person1, person2)
	if(!harmed.len)
		return

	var/priest_patron_harmed = FALSE
	for(var/patron_type in harmed)
		if(istype(priest.patron, patron_type) || priest.patron.type == patron_type)
			priest_patron_harmed = TRUE
			break

	if(!priest_patron_harmed)
		return

	var/wrath_msg = span_danger("<font size='2'>Такой союз прогневил вашего покровителя [priest.patron.name]. Проклятье пало на вас!</font>")
	to_chat(priest, wrath_msg)

	for(var/mob/living/carbon/human/M in view(7, priest))
		if(M != priest)
			to_chat(M, span_warning("Тёмная тень пробежала по лицу [priest.real_name]..."))

	priest.apply_status_effect(/datum/status_effect/divine_wrath)

/datum/status_effect/divine_wrath
	id = "divine_wrath"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/divine_wrath
	effectedstats = list(STATKEY_LCK = -2)

/atom/movable/screen/alert/status_effect/divine_wrath
	name = "Divine Wrath"
	desc = "Вы провели обряд, прогневивший богов. Удача отвернулась от вас."
	icon_state = "debuff"
