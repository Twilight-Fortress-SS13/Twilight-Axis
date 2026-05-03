// Contractor true-form ERP training bridge.
// This intentionally replaces the old Temptress training hook when Temptress is removed.
// Only /datum/component/contractor/entity can teach through ERP links.

GLOBAL_LIST_INIT(contractor_erp_training_map, list(
	/datum/skill/labor/farming = list("action" = /datum/erp_action/other/hands/milking_breasts, "passive" = "contractor"),
	/datum/skill/labor/mining = list("action" = /datum/erp_action/other/mouth/rimming, "passive" = "contractor"),
	/datum/skill/labor/fishing = list("action" = /datum/erp_action/other/hands/finger_oral, "passive" = "contractor"),
	/datum/skill/labor/butchering = list("action" = /datum/erp_action/other/body/grinding, "passive" = "contractor"),
	/datum/skill/labor/lumberjacking = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "contractor"),

	/datum/skill/magic/holy = list("action" = /datum/erp_action/other/mouth/cunnilingus, "passive" = "contractor"),
	/datum/skill/magic/arcane = list("action" = /datum/erp_action/other/mouth/breast_feed, "passive" = "contractor"),

	/datum/skill/misc/climbing = list("action" = /datum/erp_action/other/body/rubbing, "passive" = "actor"),
	/datum/skill/misc/reading = list("action" = /datum/erp_action/other/vagina/force_face, "passive" = "actor"),
	/datum/skill/misc/stealing = list("action" = /datum/erp_action/other/vagina/face, "passive" = "actor"),
	/datum/skill/misc/sneaking = list("action" = /datum/erp_action/other/hands/force_crotch, "passive" = "actor"),
	/datum/skill/misc/lockpicking = list("action" = /datum/erp_action/other/hands/tease_vagina, "passive" = "contractor"),
	/datum/skill/misc/riding = list("action" = /datum/erp_action/other/anus/force_face, "passive" = "contractor"),
	/datum/skill/misc/medicine = list("action" = /datum/erp_action/other/mouth/finger_lick, "passive" = "actor"),
	/datum/skill/misc/tracking = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "contractor"),

	/datum/skill/craft/crafting = list("action" = /datum/erp_action/other/breasts/breast_feed, "passive" = "actor"),
	/datum/skill/craft/weaponsmithing = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "actor"),
	/datum/skill/craft/armorsmithing = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "actor"),
	/datum/skill/craft/blacksmithing = list("action" = /datum/erp_action/other/anus/butt, "passive" = "contractor"),
	/datum/skill/craft/smelting = list("action" = /datum/erp_action/other/penis/rubbing, "passive" = "actor"),
	/datum/skill/craft/carpentry = list("action" = /datum/erp_action/other/vagina/rubbing, "passive" = "actor"),
	/datum/skill/craft/masonry = list("action" = /datum/erp_action/other/anus/rubbing, "passive" = "actor"),
	/datum/skill/craft/traps = list("action" = /datum/erp_action/other/anus/face, "passive" = "actor"),
	/datum/skill/craft/engineering = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "contractor"),
	/datum/skill/craft/cooking = list("action" = /datum/erp_action/other/mouth/kiss, "passive" = "contractor"),
	/datum/skill/craft/sewing = list("action" = /datum/erp_action/other/hands/rubbing, "passive" = "contractor"),
	/datum/skill/craft/tanning = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "actor"),
	/datum/skill/craft/ceramics = list("action" = /datum/erp_action/other/hands/breasts_play, "passive" = "contractor"),
	/datum/skill/craft/alchemy = list("action" = /datum/erp_action/other/hands/milking_penis, "passive" = "contractor"),

	/datum/skill/combat/knives = list("action" = /datum/erp_action/other/penis/masturbation, "passive" = "actor"),
	/datum/skill/combat/swords = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "contractor"),
	/datum/skill/combat/polearms = list("action" = /datum/erp_action/other/hands/toy_vaginal, "passive" = "contractor"),
	/datum/skill/combat/maces = list("action" = /datum/erp_action/other/legs/footjob, "passive" = "contractor"),
	/datum/skill/combat/axes = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "contractor"),
	/datum/skill/combat/whipsflails = list("action" = /datum/erp_action/other/hands/tease_testicles, "passive" = "contractor"),
	/datum/skill/combat/wrestling = list("action" = /datum/erp_action/other/hands/finger_anal, "passive" = "contractor"),
	/datum/skill/combat/unarmed = list("action" = /datum/erp_action/other/hands/finger_vaginal, "passive" = "contractor"),
	/datum/skill/combat/shields = list("action" = /datum/erp_action/other/breasts/teasing, "passive" = "actor"),
	/datum/skill/combat/staves = list("action" = /datum/erp_action/other/legs/teasing, "passive" = "actor")
))

GLOBAL_LIST_INIT(contractor_erp_combat_skills, list(
	/datum/skill/combat/knives,
	/datum/skill/combat/swords,
	/datum/skill/combat/polearms,
	/datum/skill/combat/maces,
	/datum/skill/combat/axes,
	/datum/skill/combat/whipsflails,
	/datum/skill/combat/wrestling,
	/datum/skill/combat/unarmed,
	/datum/skill/combat/shields,
	/datum/skill/combat/staves
))

/proc/contractor_erp_get_training_entry(datum/erp_action/A, expected_passive)
	if(!A || !expected_passive)
		return null

	var/action_type = A.type

	for(var/skill_type as anything in GLOB.contractor_erp_training_map)
		var/list/entry = GLOB.contractor_erp_training_map[skill_type]
		if(!islist(entry))
			continue

		if(entry["action"] != action_type)
			continue

		if(entry["passive"] != expected_passive)
			continue

		return list("skill" = skill_type, "passive" = entry["passive"])

	return null

/datum/erp_scene_effects/proc/apply_training(list/active_links)
	if(!controller)
		return

	var/list/teacher_succubi = list()

	var/datum/component/contractor/SC = controller.owner?.physical?.GetComponent(/datum/component/contractor)
	if(SC && SC.can_contractor_train_erp() && SC.owner)
		teacher_succubi += SC.owner

	SC = controller.active_partner?.physical?.GetComponent(/datum/component/contractor)
	if(SC && SC.can_contractor_train_erp() && SC.owner)
		if(!(SC.owner in teacher_succubi))
			teacher_succubi += SC.owner

	if(!length(teacher_succubi))
		return

	for(var/mob/living/contractor_mob as anything in teacher_succubi)
		if(!contractor_mob)
			continue

		for(var/datum/erp_sex_link/L in active_links)
			if(!L || QDELETED(L) || !L.is_valid())
				continue

			var/datum/erp_actor/active = L.actor_active
			var/datum/erp_actor/passive = L.actor_passive
			if(!active || !passive)
				continue

			var/mob/living/m_active = active.get_effect_mob()
			var/mob/living/m_passive = passive.get_effect_mob()
			if(!m_active || !m_passive)
				continue

			var/expected_passive = null
			var/mob/living/receiver = null

			if(m_active == contractor_mob)
				expected_passive = "actor"
				receiver = m_passive
			else if(m_passive == contractor_mob)
				expected_passive = "contractor"
				receiver = m_active
			else
				continue

			if(!receiver?.mind)
				continue

			var/list/entry = contractor_erp_get_training_entry(L.action, expected_passive)
			if(!entry)
				continue

			var/skill_type = entry["skill"]
			if(!skill_type)
				continue

			if(skill_type in GLOB.contractor_erp_combat_skills)
				if(L.force < SEX_FORCE_HIGH)
					continue

			receiver.mind.add_sleep_experience(skill_type, CONTRACTOR_ENTITY_ERP_TRAINING_XP, FALSE)
