// Misc things and component changes
/obj/effect/spawner/lootdrop/hag/mothers_cache
	loot = list(
		/obj/effect/spawner/lootdrop/hag/enchanted_moss = 100
	)

/datum/advclass/hag
	traits_applied = list(TRAIT_RITUALIST, TRAIT_ALCHEMY_EXPERT,
							TRAIT_ANCIENT_HAG, TRAIT_EDIT_DESCRIPTORS,
							TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT,
							TRAIT_ZOMBIE_IMMUNE, TRAIT_NOMOOD,
							TRAIT_UNLYCKERABLE, TRAIT_BOGWALKER,
							TRAIT_NITEVISION, TRAIT_NOHUNGER,
							TRAIT_TECHNOPHOBE, TRAIT_NOPVE, TRAIT_UNCONVERTIBLE,
							TRAIT_NOWW, TRAIT_NODISMEMBER, TRAIT_DEATHSIGHT, TRAIT_SOUL_EXAMINE,
							TRAIT_NASTY_EATER, TRAIT_ANTISCRYING, TRAIT_WATERBREATHING,
							TRAIT_TOXIMMUNE, TRAIT_ZOMBIE_IMMUNE, TRAIT_LIGHT_STEP,
							TRAIT_HARDSOLE, TRAIT_BREADY, TRAIT_LONGSTRIDER,
							TRAIT_ZURCH, TRAIT_COMBAT_NONEWSKILLS, TRAIT_SEEPRICES,
							TRAIT_EXTEROCEPTION, TRAIT_EMPATH, TRAIT_HERETIC_SEER,
							TRAIT_INTELLECTUAL)

	subclass_languages = list(
		/datum/language/oldazurian,
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/celestial,
		/datum/language/raneshi,
		/datum/language/hellspeak,
		/datum/language/orcish,
		/datum/language/grenzelhoftian,
		/datum/language/otavan,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/kazengunese,
		/datum/language/lingyuese,
		/datum/language/draconic,
		/datum/language/undercommon,
		/datum/language/aavnic,
		/datum/language/gyedzenese,
		/datum/language/valorian,
		/datum/language/beast,
		/datum/language/abyssal
	)

	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 6, "ward" = FALSE)

	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/craft/traps = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/medicine = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/sewing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/cooking = SKILL_LEVEL_MASTER,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_JOURNEYMAN,
	)
