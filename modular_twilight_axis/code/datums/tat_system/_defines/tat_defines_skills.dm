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
	TAT_SKILL_DOMAIN_COMBAT = 12, \
	TAT_SKILL_DOMAIN_WANDERING = 9, \
	TAT_SKILL_DOMAIN_GATHERING = 3, \
	TAT_SKILL_DOMAIN_CRAFTING = 6, \
	TAT_SKILL_DOMAIN_MISC = 10 \
)

#define TAT_VIRTUE_CHOICE_SKILLED_BSMITH "Blacksmith Apprentice"
#define TAT_VIRTUE_CHOICE_SKILLED_TAILOR "Tailor Apprentice"
#define TAT_VIRTUE_CHOICE_SKILLED_HUNTER "Hunter Apprentice"
#define TAT_VIRTUE_CHOICE_SKILLED_PHYS "Physician Apprentice"
#define TAT_VIRTUE_CHOICE_SKILLED_FORESTER "Forester Apprentice"
#define TAT_VIRTUE_CHOICE_SKILLED_ARTIF "Artificer Apprentice"

#define TAT_VIRTUE_CHOICE_COMBAT_SWORDS "Swords Skill (JMAN)"
#define TAT_VIRTUE_CHOICE_COMBAT_SHIELDS "Shield Skill (JMAN)"
#define TAT_VIRTUE_CHOICE_COMBAT_DAGGERS "Dagger Skill (JMAN)"
#define TAT_VIRTUE_CHOICE_COMBAT_UNARMED "Unarmed Skill (JMAN)"
#define TAT_VIRTUE_CHOICE_COMBAT_SLINGS "Sling Skill (JMAN)"
#define TAT_VIRTUE_CHOICE_COMBAT_AXES "Axe Skill (JMAN)"
#define TAT_VIRTUE_CHOICE_COMBAT_WHIPS "Whip Skill (JMAN)"
#define TAT_VIRTUE_CHOICE_COMBAT_MACES "Mace Skill (JMAN)"
#define TAT_VIRTUE_CHOICE_COMBAT_POLEARMS "Polearm Skill (JMAN)"
#define TAT_VIRTUE_CHOICE_COMBAT_STAVES "Staves Skill (JMAN)"

#define TAT_VIRTUE_CHOICE_APPRENTICE_MINING "Mining Skill (+3, Up to Legendary)"
#define TAT_VIRTUE_CHOICE_APPRENTICE_LUMBERJACKING "Lumberjacking Skill (+3, Up to Legendary)"

#define TAT_VIRTUE_CHOICE_PROWLER_SNEAKING "Sneak Skill (+2, Up to Legendary)"
#define TAT_VIRTUE_CHOICE_PROWLER_LOCKPICKING "Lockpick Skill (+3, Up to Legendary)"

#define TAT_VIRTUE_SKILL_BONUS_RULES list( \
	/datum/virtue/combat/bowman = list(/datum/skill/combat/bows = 1), \
	/datum/virtue/combat/crossbowman = list(/datum/skill/combat/crossbows = 1), \
	/datum/virtue/combat/magical_potential = list(/datum/skill/magic/arcane = 1), \
	/datum/virtue/combat/devotee = list(/datum/skill/magic/holy = 1), \
	/datum/virtue/utility/skilled = list(/datum/skill/craft/crafting = 2), \
	/datum/virtue/items/arsonist = list(/datum/skill/craft/alchemy = 1, /datum/skill/craft/traps = 3), \
	/datum/virtue/utility/riding = list(/datum/skill/misc/riding = 1), \
	/datum/virtue/utility/noble = list(/datum/skill/misc/reading = 1), \
	/datum/virtue/utility/intellectual = list(/datum/skill/misc/reading = 3), \
	/datum/virtue/utility/performer = list(/datum/skill/misc/music = 4), \
	/datum/virtue/utility/granary = list(/datum/skill/craft/cooking = 3, /datum/skill/labor/fishing = 2), \
	/datum/virtue/utility/homesteader = list(/datum/skill/labor/farming = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/mining = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/cooking = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/fishing = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/butchering = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/lumberjacking = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/masonry = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/ceramics = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/sewing = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/tanning = TAT_SKILL_BASIC_BOOST), \
	/datum/virtue/utility/tracker = list(/datum/skill/misc/tracking = 3), \
	/datum/virtue/utility/bronzelimbs = list(/datum/skill/craft/engineering = 1), \
	/datum/virtue/utility/feytouched = list(/datum/skill/misc/medicine = 1, /datum/skill/craft/alchemy = 1) \
)

#define TAT_VIRTUE_SKILL_CAP_BONUS_RULES list( \
	/datum/virtue/combat/bowman = list(/datum/skill/combat/bows = 3), \
	/datum/virtue/combat/crossbowman = list(/datum/skill/combat/crossbows = 3), \
	/datum/virtue/combat/magical_potential = list(/datum/skill/magic/arcane = 1), \
	/datum/virtue/combat/devotee = list(/datum/skill/magic/holy = 1), \
	/datum/virtue/utility/performer = list(/datum/skill/misc/music = 6) \
)

#define TAT_VIRTUE_CHOICE_SKILL_BONUS_RULES list( \
	/datum/virtue/utility/skilled = list( \
		TAT_VIRTUE_CHOICE_SKILLED_BSMITH = list(/datum/skill/craft/weaponsmithing = 2, /datum/skill/craft/armorsmithing = 2, /datum/skill/craft/blacksmithing = 2, /datum/skill/craft/smelting = 2), \
		TAT_VIRTUE_CHOICE_SKILLED_TAILOR = list(/datum/skill/labor/butchering = 2, /datum/skill/craft/sewing = 3, /datum/skill/craft/tanning = 2), \
		TAT_VIRTUE_CHOICE_SKILLED_HUNTER = list(/datum/skill/craft/traps = 2, /datum/skill/misc/tracking = 2, /datum/skill/labor/butchering = 2, /datum/skill/craft/sewing = 2, /datum/skill/craft/tanning = 2, /datum/skill/misc/hunting = 2), \
		TAT_VIRTUE_CHOICE_SKILLED_PHYS = list(/datum/skill/craft/alchemy = 2, /datum/skill/misc/medicine = 2), \
		TAT_VIRTUE_CHOICE_SKILLED_FORESTER = list(/datum/skill/craft/cooking = 2, /datum/skill/misc/athletics = 2, /datum/skill/labor/farming = 2, /datum/skill/labor/fishing = 2, /datum/skill/labor/lumberjacking = 2), \
		TAT_VIRTUE_CHOICE_SKILLED_ARTIF = list(/datum/skill/craft/carpentry = 2, /datum/skill/craft/masonry = 2, /datum/skill/craft/engineering = 2, /datum/skill/craft/smelting = 2, /datum/skill/craft/ceramics = 2) \
	), \
	/datum/virtue/combat/combat_virtue = list( \
		TAT_VIRTUE_CHOICE_COMBAT_SWORDS = list(/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_COMBAT_SHIELDS = list(/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_COMBAT_DAGGERS = list(/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_COMBAT_UNARMED = list(/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_COMBAT_SLINGS = list(/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_COMBAT_AXES = list(/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_COMBAT_WHIPS = list(/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_COMBAT_MACES = list(/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_COMBAT_POLEARMS = list(/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_COMBAT_STAVES = list(/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN) \
	), \
	/datum/virtue/utility/apprentice = list( \
		TAT_VIRTUE_CHOICE_APPRENTICE_MINING = list(/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN), \
		TAT_VIRTUE_CHOICE_APPRENTICE_LUMBERJACKING = list(/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN) \
	), \
	/datum/virtue/utility/prowler = list( \
		TAT_VIRTUE_CHOICE_PROWLER_SNEAKING = list(/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE), \
		TAT_VIRTUE_CHOICE_PROWLER_LOCKPICKING = list(/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN) \
	) \
)

#define TAT_VIRTUE_CHOICE_SKILL_CAP_BONUS_RULES list( \
	/datum/virtue/utility/apprentice = list( \
		TAT_VIRTUE_CHOICE_APPRENTICE_MINING = list(/datum/skill/labor/mining = SKILL_LEVEL_LEGENDARY), \
		TAT_VIRTUE_CHOICE_APPRENTICE_LUMBERJACKING = list(/datum/skill/labor/lumberjacking = SKILL_LEVEL_LEGENDARY) \
	), \
	/datum/virtue/utility/prowler = list( \
		TAT_VIRTUE_CHOICE_PROWLER_SNEAKING = list(/datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY), \
		TAT_VIRTUE_CHOICE_PROWLER_LOCKPICKING = list(/datum/skill/misc/lockpicking = SKILL_LEVEL_LEGENDARY) \
	) \
)

GLOBAL_LIST_INIT(tat_virtue_skill_bonus_rules, TAT_VIRTUE_SKILL_BONUS_RULES)
GLOBAL_LIST_INIT(tat_virtue_skill_cap_bonus_rules, TAT_VIRTUE_SKILL_CAP_BONUS_RULES)
GLOBAL_LIST_INIT(tat_virtue_choice_skill_bonus_rules, TAT_VIRTUE_CHOICE_SKILL_BONUS_RULES)
GLOBAL_LIST_INIT(tat_virtue_choice_skill_cap_bonus_rules, TAT_VIRTUE_CHOICE_SKILL_CAP_BONUS_RULES)

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
