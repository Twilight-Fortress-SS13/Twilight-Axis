#define TAT_SKILL_COMBAT_CAP_DEFAULT 3
#define TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT 4
#define TAT_SKILL_COMBAT_CAP_TRAIT_MASTER 5

#define TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM 5
#define TAT_SKILL_NONCOMBAT_CAP_UNTRAITED 2
#define TAT_SKILL_NONCOMBAT_CAP_SPECTRAIT 4
#define TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE 6

#define TAT_SKILL_BASIC_BOOST 2
#define TAT_SKILL_DISCOUNT_BOOST 1

#define TAT_COMBAT_EXPERT_SKILL_LIMIT 2
#define TAT_COMBAT_MASTER_SKILL_LIMIT 1

#define TAT_SKILL_DOMAIN_COMBAT "combat"
#define TAT_SKILL_DOMAIN_WANDERING "wandering"
#define TAT_SKILL_DOMAIN_GATHERING "gathering"
#define TAT_SKILL_DOMAIN_CRAFTING "crafting"
#define TAT_SKILL_DOMAIN_MISC "misc"

#define TAT_SKILLS_COMBAT list( \
	/datum/skill/combat/knives, \
	/datum/skill/combat/swords, \
	/datum/skill/combat/polearms, \
	/datum/skill/combat/maces, \
	/datum/skill/combat/axes, \
	/datum/skill/combat/whipsflails, \
	/datum/skill/combat/bows, \
	/datum/skill/combat/crossbows, \
	/datum/skill/combat/wrestling, \
	/datum/skill/combat/unarmed, \
	/datum/skill/combat/shields, \
	/datum/skill/combat/slings, \
	/datum/skill/combat/staves, \
	/datum/skill/combat/twilight_firearms \
)

#define TAT_SKILLS_WANDERING list( \
	/datum/skill/misc/athletics, \
	/datum/skill/misc/climbing, \
	/datum/skill/misc/swimming, \
	/datum/skill/misc/riding, \
	/datum/skill/misc/tracking \
)

#define TAT_SKILLS_GATHERING list( \
	/datum/skill/labor/farming, \
	/datum/skill/labor/mining, \
	/datum/skill/labor/fishing, \
	/datum/skill/labor/butchering, \
	/datum/skill/labor/lumberjacking, \
	/datum/skill/misc/hunting \
)

#define TAT_SKILLS_CRAFTING list( \
	/datum/skill/craft/crafting, \
	/datum/skill/craft/weaponsmithing, \
	/datum/skill/craft/armorsmithing, \
	/datum/skill/craft/blacksmithing, \
	/datum/skill/craft/smelting, \
	/datum/skill/craft/carpentry, \
	/datum/skill/craft/masonry, \
	/datum/skill/craft/traps, \
	/datum/skill/craft/engineering, \
	/datum/skill/craft/cooking, \
	/datum/skill/craft/sewing, \
	/datum/skill/craft/tanning, \
	/datum/skill/craft/ceramics, \
	/datum/skill/craft/alchemy \
)

#define TAT_SKILLS_MISC list( \
	/datum/skill/misc/reading, \
	/datum/skill/misc/stealing, \
	/datum/skill/misc/sneaking, \
	/datum/skill/misc/lockpicking, \
	/datum/skill/misc/music, \
	/datum/skill/misc/medicine, \
	/datum/skill/magic/holy, \
	/datum/skill/magic/arcane, \
	/datum/skill/magic/druidic \
)

#define TAT_SKILLS_ALL (TAT_SKILLS_COMBAT + TAT_SKILLS_WANDERING + TAT_SKILLS_GATHERING + TAT_SKILLS_CRAFTING + TAT_SKILLS_MISC)

#define TAT_DEFAULT_SKILL_DOMAIN_POINTS list( \
	TAT_SKILL_DOMAIN_COMBAT = 9, \
	TAT_SKILL_DOMAIN_WANDERING = 9, \
	TAT_SKILL_DOMAIN_GATHERING = 3, \
	TAT_SKILL_DOMAIN_CRAFTING = 6, \
	TAT_SKILL_DOMAIN_MISC = 3 \
)

#define TAT_VIRTUE_SKILL_BONUS_RULES list( \
	/datum/virtue/combat/bowman = list(/datum/skill/combat/bows = 1), \
	/datum/virtue/combat/crossbowman = list(/datum/skill/combat/crossbows = 1), \
	/datum/virtue/utility/homesteader = list(/datum/skill/labor/farming = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/mining = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/cooking = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/fishing = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/butchering = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/lumberjacking = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/masonry = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/ceramics = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/sewing = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/tanning = TAT_SKILL_BASIC_BOOST) \
)

#define TAT_TRAIT_SKILL_CAP_BONUS_RULES list( \
	TRAIT_SMITHING_EXPERT = list(/datum/skill/craft/blacksmithing = 4, /datum/skill/craft/smelting = 4, /datum/skill/craft/engineering = 4, /datum/skill/labor/mining = 4, /datum/skill/craft/masonry = 4, /datum/skill/craft/ceramics = 4), \
	TAT_TRAIT_SKILLED_FORGEHAND = list(/datum/skill/craft/blacksmithing = 3, /datum/skill/craft/smelting = 3, /datum/skill/craft/engineering = 3), \
	TAT_TRAIT_SKILLED_ARMORER = list(/datum/skill/craft/armorsmithing = 3, /datum/skill/craft/masonry = 3), \
	TAT_TRAIT_SKILLED_WEAPONSMITH = list(/datum/skill/craft/weaponsmithing = 3, /datum/skill/craft/engineering = 3), \
	TAT_TRAIT_SKILLED_ARTISAN = list(/datum/skill/craft/crafting = 3, /datum/skill/craft/ceramics = 3), \
	TAT_TRAIT_SKILLED_MASON = list(/datum/skill/craft/masonry = 3, /datum/skill/craft/ceramics = 3), \
	TRAIT_ALCHEMY_EXPERT = list(/datum/skill/craft/alchemy = 4), \
	TAT_TRAIT_SKILLED_ALCHEMIST = list(/datum/skill/craft/alchemy = 3), \
	TRAIT_MEDICINE_EXPERT = list(/datum/skill/misc/medicine = 4), \
	TAT_TRAIT_SKILLED_PHYSICKER = list(/datum/skill/misc/medicine = 3), \
	TRAIT_HOMESTEAD_EXPERT = list(/datum/skill/labor/farming = 4, /datum/skill/labor/mining = 4, /datum/skill/craft/cooking = 4, /datum/skill/labor/fishing = 4, /datum/skill/labor/butchering = 4, /datum/skill/labor/lumberjacking = 4, /datum/skill/craft/masonry = 4, /datum/skill/craft/ceramics = 4, /datum/skill/craft/sewing = 1, /datum/skill/craft/tanning = 1), \
	TAT_TRAIT_SKILLED_HOMESTEADER = list(/datum/skill/labor/farming = 3, /datum/skill/craft/cooking = 3, /datum/skill/labor/fishing = 3), \
	TRAIT_SURVIVAL_EXPERT = list(/datum/skill/craft/cooking = 4, /datum/skill/labor/fishing = 4, /datum/skill/labor/butchering = 4, /datum/skill/craft/tanning = 4, /datum/skill/craft/sewing = 1), \
	TAT_TRAIT_SKILLED_SURVIVALIST = list(/datum/skill/labor/butchering = 3, /datum/skill/craft/traps = 3, /datum/skill/craft/tanning = 3), \
	TRAIT_SEWING_EXPERT = list(/datum/skill/craft/sewing = 4, /datum/skill/craft/tanning = 4, /datum/skill/labor/butchering = 4), \
	TAT_TRAIT_SKILLED_CLOTHIER = list(/datum/skill/craft/sewing = 3, /datum/skill/craft/tanning = 3), \
	TRAIT_SEEDKNOW = list(/datum/skill/labor/farming = 3), \
	TRAIT_CAUTIOUS_FISHER = list(/datum/skill/labor/fishing = 3), \
	TRAIT_SQUIRE_REPAIR = list(/datum/skill/craft/armorsmithing = 3, /datum/skill/craft/weaponsmithing = 3), \
	TRAIT_SELF_SUSTENANCE = list(/datum/skill/craft/crafting = 1, /datum/skill/craft/weaponsmithing = 1, /datum/skill/craft/armorsmithing = 1, /datum/skill/craft/blacksmithing = 1, /datum/skill/craft/smelting = 1, /datum/skill/craft/carpentry = 1, /datum/skill/craft/masonry = 1, /datum/skill/craft/traps = 1, /datum/skill/craft/engineering = 1, /datum/skill/craft/cooking = 1, /datum/skill/craft/sewing = 1, /datum/skill/craft/tanning = 1, /datum/skill/craft/ceramics = 1, /datum/skill/craft/alchemy = 1, /datum/skill/labor/farming = 1, /datum/skill/labor/mining = 1, /datum/skill/labor/fishing = 1, /datum/skill/labor/butchering = 1, /datum/skill/labor/lumberjacking = 1), \
	TRAIT_MASTERFUL_HUNTER = list(/datum/skill/misc/hunting = 4, /datum/skill/misc/tracking = 4, /datum/skill/labor/butchering = 4), \
	TRAIT_EXPERT_HUNTER = list(/datum/skill/misc/hunting = 3, /datum/skill/misc/tracking = 3), \
	TRAIT_FIREARMS_MARKSMAN = list(/datum/skill/combat/twilight_firearms = 2) \
)

#define TAT_SKILL_CAP_RULES list( \
	/datum/skill/craft/cooking = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/craft/alchemy = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_ALCHEMY_EXPERT = 3) \
	), \
	/datum/skill/misc/medicine = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_MEDICINE_EXPERT = 3) \
	), \
	/datum/skill/craft/sewing = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_SEWING_EXPERT = 3) \
	), \
	/datum/skill/labor/farming = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_SEEDKNOW = 3, TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/craft/blacksmithing = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_HOMESTEAD_EXPERT = 3, TRAIT_SMITHING_EXPERT = 4) \
	), \
	/datum/skill/craft/smelting = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_SMITHING_EXPERT = 4) \
	), \
	/datum/skill/craft/carpentry = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/craft/masonry = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/craft/crafting = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/labor/mining = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/labor/lumberjacking = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/craft/ceramics = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/labor/butchering = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_SURVIVAL_EXPERT = 3, TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/craft/traps = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_SURVIVAL_EXPERT = 3) \
	), \
	/datum/skill/labor/fishing = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_CAUTIOUS_FISHER = 3, TRAIT_HOMESTEAD_EXPERT = 3) \
	), \
	/datum/skill/craft/armorsmithing = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_SQUIRE_REPAIR = 3, TRAIT_SMITHING_EXPERT = 4) \
	), \
	/datum/skill/craft/weaponsmithing = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_SQUIRE_REPAIR = 3, TRAIT_SMITHING_EXPERT = 4) \
	), \
	/datum/skill/combat/twilight_firearms = TAT_SKILL_CAP_RULE_ENTRY( \
		TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
		list(TRAIT_FIREARMS_MARKSMAN = 2) \
	) \
)

/proc/tat_get_skill_domain(skill_type)
	if(skill_type in TAT_SKILLS_COMBAT)
		return TAT_SKILL_DOMAIN_COMBAT
	if(skill_type in TAT_SKILLS_WANDERING)
		return TAT_SKILL_DOMAIN_WANDERING
	if(skill_type in TAT_SKILLS_GATHERING)
		return TAT_SKILL_DOMAIN_GATHERING
	if(skill_type in TAT_SKILLS_CRAFTING)
		return TAT_SKILL_DOMAIN_CRAFTING
	if(skill_type in TAT_SKILLS_MISC)
		return TAT_SKILL_DOMAIN_MISC
	return null
