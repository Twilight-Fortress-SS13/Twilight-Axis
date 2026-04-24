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
#define TAT_SKILL_DOMAIN_MAGIC "magic"
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

#define TAT_SKILLS_MAGIC list( \
	/datum/skill/magic/holy, \
	/datum/skill/magic/arcane, \
	/datum/skill/magic/druidic \
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
	/datum/skill/misc/medicine \
)

#define TAT_SKILLS_ALL (TAT_SKILLS_COMBAT + TAT_SKILLS_MAGIC + TAT_SKILLS_WANDERING + TAT_SKILLS_GATHERING + TAT_SKILLS_CRAFTING + TAT_SKILLS_MISC)

#define TAT_DEFAULT_SKILL_DOMAIN_POINTS list( \
	TAT_SKILL_DOMAIN_COMBAT = 12, \
	TAT_SKILL_DOMAIN_MAGIC = 0, \
	TAT_SKILL_DOMAIN_WANDERING = 12, \
	TAT_SKILL_DOMAIN_GATHERING = 3, \
	TAT_SKILL_DOMAIN_CRAFTING = 6, \
	TAT_SKILL_DOMAIN_MISC = 3 \
)

#define TAT_VIRTUE_SKILL_BONUS_RULES list( \
	/datum/virtue/combat/bowman = list(/datum/skill/combat/bows = 1), \
	/datum/virtue/combat/crossbowman = list(/datum/skill/combat/crossbows = 1) \
)

#define TAT_SKILL_RULE_ENTRY(_expert_trait, _trait_cap) list( \
	"expert_trait" = (_expert_trait), \
	"untraited_cap" = TAT_SKILL_NONCOMBAT_CAP_UNTRAITED, \
	"trait_cap" = (_trait_cap) \
)

#define TAT_SKILL_RULES list( \
	/datum/skill/craft/cooking = TAT_SKILL_RULE_ENTRY(TRAIT_HOMESTEAD_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/alchemy = TAT_SKILL_RULE_ENTRY(TRAIT_ALCHEMY_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/misc/medicine = TAT_SKILL_RULE_ENTRY(TRAIT_MEDICINE_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/sewing = TAT_SKILL_RULE_ENTRY(TRAIT_SEWING_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/labor/farming = TAT_SKILL_RULE_ENTRY(TRAIT_SEEDKNOW, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/blacksmithing = TAT_SKILL_RULE_ENTRY(TRAIT_SMITHING_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/smelting = TAT_SKILL_RULE_ENTRY(TRAIT_SMITHING_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/carpentry = TAT_SKILL_RULE_ENTRY(TRAIT_HOMESTEAD_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/masonry = TAT_SKILL_RULE_ENTRY(TRAIT_HOMESTEAD_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/crafting = TAT_SKILL_RULE_ENTRY(TRAIT_HOMESTEAD_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/labor/butchering = TAT_SKILL_RULE_ENTRY(TRAIT_SURVIVAL_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/traps = TAT_SKILL_RULE_ENTRY(TRAIT_SURVIVAL_EXPERT, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/labor/fishing = TAT_SKILL_RULE_ENTRY(TRAIT_CAUTIOUS_FISHER, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/armorsmithing = TAT_SKILL_RULE_ENTRY(TRAIT_SQUIRE_REPAIR, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/craft/weaponsmithing = TAT_SKILL_RULE_ENTRY(TRAIT_SQUIRE_REPAIR, TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM), \
	/datum/skill/combat/twilight_firearms = TAT_SKILL_RULE_ENTRY(TRAIT_FIREARMS_MARKSMAN, TAT_SKILL_NONCOMBAT_CAP_SPECTRAIT) \
)

/proc/tat_get_skill_domain(skill_type)
	if(skill_type in TAT_SKILLS_COMBAT)
		return TAT_SKILL_DOMAIN_COMBAT
	if(skill_type in TAT_SKILLS_MAGIC)
		return TAT_SKILL_DOMAIN_MAGIC
	if(skill_type in TAT_SKILLS_WANDERING)
		return TAT_SKILL_DOMAIN_WANDERING
	if(skill_type in TAT_SKILLS_GATHERING)
		return TAT_SKILL_DOMAIN_GATHERING
	if(skill_type in TAT_SKILLS_CRAFTING)
		return TAT_SKILL_DOMAIN_CRAFTING
	if(skill_type in TAT_SKILLS_MISC)
		return TAT_SKILL_DOMAIN_MISC
	return null
