#define TAT_SKILL_COMBAT_CAP_DEFAULT 3
#define TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT 4
#define TAT_SKILL_COMBAT_CAP_TRAIT_MASTER 5
#define TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM 5
#define TAT_SKILL_NONCOMBAT_CAP_UNTRAITED 2
#define TAT_SKILL_NONCOMBAT_CAP_SPECTRAIT 4
#define TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE 6

#define TAT_SKILL_BASIC_BOOST 2

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

/// Magic skills
#define TAT_SKILLS_MAGIC list( \
	/datum/skill/magic/holy, \
	/datum/skill/magic/arcane, \
	/datum/skill/magic/druidic \
)

/// Utility / travel / field skills
#define TAT_SKILLS_WANDERING list( \
	/datum/skill/misc/athletics, \
	/datum/skill/misc/climbing, \
	/datum/skill/misc/swimming, \
	/datum/skill/misc/riding, \
	/datum/skill/misc/tracking \
)

/// Gathering / harvesting skills
#define TAT_SKILLS_GATHERING list( \
	/datum/skill/labor/farming, \
	/datum/skill/labor/mining, \
	/datum/skill/labor/fishing, \
	/datum/skill/labor/butchering, \
	/datum/skill/labor/lumberjacking, \
	/datum/skill/misc/hunting \
)

/// Crafting / production skills
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

/// Other skills
#define TAT_SKILLS_MISC list( \
	/datum/skill/misc/reading, \
	/datum/skill/misc/stealing, \
	/datum/skill/misc/sneaking, \
	/datum/skill/misc/lockpicking, \
	/datum/skill/misc/music, \
	/datum/skill/misc/medicine \
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
