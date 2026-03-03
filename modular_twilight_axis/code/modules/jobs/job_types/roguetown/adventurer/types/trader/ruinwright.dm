/datum/advclass/trader/ruinwright
	name = "Grim Ruinwright"
	tutorial = "When markets burned and cities fell, you did not. You trade in salvage, rebuild from rot, and survive where others starve. Hope is a luxury. Skill is currency."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/homesteader
	age_mod = /datum/class_age_mod/ruinwright
	traits_applied = list(TRAIT_JACKOFALLTRADES,
		TRAIT_ALCHEMY_EXPERT,
		TRAIT_SMITHING_EXPERT,
		TRAIT_SEWING_EXPERT,
		TRAIT_SURVIVAL_EXPERT,
		TRAIT_HOMESTEAD_EXPERT // No medicine but they get the full package
	)
	category_tags = list(CTAG_TRADER)
	class_select_category = CLASS_CAT_TRADER
	adaptive_name = TRUE
	subclass_stats = list(
		STATKEY_INT = 3,	//This guy's here to grind = baby.
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,

		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,

		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,

		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
	)
	maximum_possible_slots = 3 // Should not fill, just a hack to make it shows what types of traders are in round

/datum/job/roguetown/trader/New()
	. = ..()
	job_subclasses |= list(/datum/advclass/trader/ruinwright)

/datum/class_age_mod/ruinwright/apply_age_mod(mob/living/carbon/human/H)
	if(!H)
		return

	var/list/age_skill_list = list(
		/datum/skill/misc/music,
		/datum/skill/misc/reading,
		/datum/skill/misc/medicine,
		/datum/skill/craft/sewing,
		/datum/skill/craft/ceramics,

		/datum/skill/craft/crafting,
		/datum/skill/craft/carpentry,
		/datum/skill/craft/masonry,
		/datum/skill/craft/tanning,
		/datum/skill/craft/cooking,

		/datum/skill/labor/lumberjacking,
		/datum/skill/labor/fishing,
		/datum/skill/labor/butchering
	)

	switch(H.age)

		if(AGE_MIDDLEAGED)
			for(var/skill_type in age_skill_list)
				H.adjust_skillrank(skill_type, 1, TRUE)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_STR, -1)
			to_chat(H, span_notice("Years of hard trade have sharpened your mind."))
			to_chat(H, span_danger("But the road has begun to wear your body down."))

		if(AGE_OLD)
			for(var/skill_type in age_skill_list)
				H.adjust_skillrank_up_to(skill_type, SKILL_LEVEL_EXPERT, TRUE)

			H.change_stat(STATKEY_STR, -1)
			H.change_stat(STATKEY_SPD, -1)
			to_chat(H, span_notice("Decades among ruins have made you cunning beyond skilled."))
			to_chat(H, span_danger("But time takes its toll on flesh and sinew."))



