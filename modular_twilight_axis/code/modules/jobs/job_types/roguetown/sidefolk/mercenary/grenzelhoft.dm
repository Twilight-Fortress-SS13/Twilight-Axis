/datum/advclass/mercenary/grenzelhoft/crossbowman
	tutorial = "While crossbowmen see less and less use among the rank-and-file of the Grenzelhoft Emperate armies, they are still plentiful among border units that fight to bring stability and peace to the ever-unstable Feuerlands. Your skills are versitile and combine marksmanship and combat tactics with survival expertise - exactly what the Freikorps want to see in their soldiers."
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_SURVIVAL_EXPERT)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_STR = 3, //У меня нет доджей и брони, но есть мечта
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)
