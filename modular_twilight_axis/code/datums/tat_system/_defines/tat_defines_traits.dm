#define TAT_TRAIT_WARRIOR_EXPERT "tat_warrior_expert"
#define TAT_TRAIT_WARRIOR_MASTER "tat_warrior_master"
#define TAT_TRAIT_SOUNDBREAKER "tat_soundbreaker"
#define TAT_TRAIT_RONIN "tat_ronin"
#define TAT_TRAIT_MARTIAL_MASTER "tat_martial_master"
#define TAT_TRAIT_RESIDENT "tat_resident"
#define TAT_TRAIT_MASTER_OF_WANDERING "tat_master_of_wandering"
#define TAT_TRAIT_PLIANT_RENAME "tat_pliant_rename"
#define TAT_TRAIT_SAVAGE_SKIN "tat_savage_skin"
#define TAT_TRAIT_SAVAGE_RAGE "tat_savage_rage"
#define TAT_TRAIT_BERSERKER_RAGE "tat_berserker_rage"
#define TAT_TRAIT_TRADER_LICENSE "tat_trader_license"
#define TAT_TRAIT_SADDLEBORN "tat_saddleborn"

#define TAT_TRAIT_STEEL_SUPPLIER "tat_steel_supplier"
#define TAT_TRAIT_SILVER_SUPPLIER "tat_silver_supplier"
#define TAT_TRAIT_BRONZE_SUPPLIER "tat_bronze_supplier"
#define TAT_TRAIT_LEATHER_SUPPLIER "tat_leather_supplier"
#define TAT_TRAIT_MAIL_SUPPLIER "tat_mail_supplier"
#define TAT_TRAIT_FIREARMS_SUPPLIER "tat_firearms_supplier"
#define TAT_TRAIT_ARTIFACTS_SUPPLIER "tat_artifacts_supplier"
#define TAT_TRAIT_TROPHY_BOUNTY "tat_trophy_bounty"
#define TAT_TRAIT_PLATE_SUPPLIER "tat_plate_supplier"
#define TAT_TRAIT_SPELLBLADE "tat_spellblade"

#define TAT_TRAIT_BARDIC_INSPIRATION_T1 "tat_bardic_inspiration_t1"
#define TAT_TRAIT_BARDIC_INSPIRATION_T2 "tat_bardic_inspiration_t2"
#define TAT_TRAIT_PARTY_LEADER "tat_party_leader"
#define TAT_TRAIT_BONUS_STAT_POOL "tat_bonus_stat_pool"
#define TAT_TRAIT_WANTED "tat_wanted"
#define TAT_TRAIT_HERETIC "tat_heretic"
#define TAT_TRAIT_LOOTRAT "tat_lootrat"
#define TAT_TRAIT_LOOTRAT_2 "tat_lootrat_2"

#define TAT_TRAIT_DIVINE_INITIATE "tat_divine_initiate"
#define TAT_TRAIT_MAGE_INITIATE "tat_mage_initiate"
#define TAT_TRAIT_DRUID_INITIATE "tat_druid_initiate"
#define TAT_TRAIT_WITCH_INITIATE "tat_witch_initiate"
#define TAT_TRAIT_CONTRACTOR "tat_contractor"
#define TAT_TRAIT_CONTRACTOR_ENTITY "tat_contractor_entity"

#define TAT_TRAIT_DIVINE_BOON_1 "tat_divine_boon_1"
#define TAT_TRAIT_DIVINE_BOON_2 "tat_divine_boon_2"
#define TAT_TRAIT_DIVINE_BOON_3 "tat_divine_boon_3"

#define TAT_TRAIT_MAGE_MAJOR_SLOT "tat_mage_major_slot"
#define TAT_TRAIT_MAGE_MINOR_SLOT_1 "tat_mage_minor_slot_1"
#define TAT_TRAIT_MAGE_MINOR_SLOT_2 "tat_mage_minor_slot_2"
#define TAT_TRAIT_MAGE_UTILITY_SLOT "tat_mage_utility_slot"

#define TAT_TRAIT_TRAINEE_SMITH "tat_trainee_smith"
#define TAT_TRAIT_TRAINEE_ARMORER "tat_trainee_armorer"
#define TAT_TRAIT_TRAINEE_WEAPONSMITH "tat_trainee_weaponsmith"
#define TAT_TRAIT_TRAINEE_WOODSMAN "tat_trainee_woodsman"
#define TAT_TRAIT_TRAINEE_SURVIVALIST "tat_trainee_survivalist"
#define TAT_TRAIT_TRAINEE_POACHER "tat_trainee_poacher"
#define TAT_TRAIT_TRAINEE_SKULKER "tat_trainee_skulker"
#define TAT_TRAIT_TRAINEE_VAGABOND "tat_trainee_vagabond"
#define TAT_TRAIT_TRAINEE_RIDER "tat_trainee_rider"
#define TAT_TRAIT_TRAINEE_MARINER "tat_trainee_mariner"
#define TAT_TRAIT_TRAINEE_CLOTHIER "tat_trainee_clothier"
#define TAT_TRAIT_TRAINEE_HOMESTEADER "tat_trainee_homesteader"
#define TAT_TRAIT_TRAINEE_ARTISAN "tat_trainee_artisan"
#define TAT_TRAIT_TRAINEE_CHIRURGEON "tat_trainee_chirurgeon"
#define TAT_TRAIT_TRAINEE_TROUBADOUR "tat_trainee_troubadour"

#define TAT_TRAIT_MASTER_OF_CRAFTING "tat_master_of_crafting"
#define TAT_TRAIT_STRAYING_SOUL "tat_straying_soul"
#define TAT_TRAIT_STOCKPILER "tat_stockpiler"

#define TAT_TRAIT_SKILLED_FORGEHAND "tat_skilled_forgehand"
#define TAT_TRAIT_SKILLED_ARMORER "tat_skilled_armorer"
#define TAT_TRAIT_SKILLED_WEAPONSMITH "tat_skilled_weaponsmith"
#define TAT_TRAIT_SKILLED_ARTISAN "tat_skilled_artisan"
#define TAT_TRAIT_SKILLED_MASON "tat_skilled_mason"
#define TAT_TRAIT_SKILLED_CLOTHIER "tat_skilled_clothier"
#define TAT_TRAIT_SKILLED_SURVIVALIST "tat_skilled_survivalist"
#define TAT_TRAIT_SKILLED_HOMESTEADER "tat_skilled_homesteader"
#define TAT_TRAIT_SKILLED_PHYSICKER "tat_skilled_physicker"
#define TAT_TRAIT_SKILLED_ALCHEMIST "tat_skilled_alchemist"
#define TAT_TRAIT_SKILLED_LOCKER "tat_skilled_locker"

#define TAT_TRAIT_ACCURSED "tat_trait_accursed"

#define TAT_TRAIT_SKILL_CAP_BONUS_RULES list( \
	TRAIT_SMITHING_EXPERT = list(/datum/skill/craft/blacksmithing = 6, /datum/skill/craft/smelting = 6, /datum/skill/craft/engineering = 6, /datum/skill/labor/mining = 6, /datum/skill/craft/masonry = 6, /datum/skill/craft/ceramics = 6), \
	TAT_TRAIT_SKILLED_FORGEHAND = list(/datum/skill/craft/blacksmithing = 5, /datum/skill/craft/smelting = 5, /datum/skill/craft/engineering = 5), \
	TAT_TRAIT_SKILLED_ARMORER = list(/datum/skill/craft/armorsmithing = 5, /datum/skill/craft/masonry = 5), \
	TAT_TRAIT_SKILLED_WEAPONSMITH = list(/datum/skill/craft/weaponsmithing = 5, /datum/skill/craft/engineering = 5), \
	TAT_TRAIT_SKILLED_ARTISAN = list(/datum/skill/craft/crafting = 5, /datum/skill/craft/ceramics = 5), \
	TAT_TRAIT_SKILLED_MASON = list(/datum/skill/craft/masonry = 5, /datum/skill/craft/ceramics = 5), \
	TRAIT_ALCHEMY_EXPERT = list(/datum/skill/craft/alchemy = 6), \
	TAT_TRAIT_SKILLED_ALCHEMIST = list(/datum/skill/craft/alchemy = 5), \
	TRAIT_MEDICINE_EXPERT = list(/datum/skill/misc/medicine = 6), \
	TAT_TRAIT_SKILLED_PHYSICKER = list(/datum/skill/misc/medicine = 5), \
	TAT_TRAIT_SKILLED_LOCKER = list(/datum/skill/misc/stealing = 5, /datum/skill/misc/lockpicking = 5), \
	TRAIT_HOMESTEAD_EXPERT = list(/datum/skill/labor/farming = 6, /datum/skill/labor/mining = 6, /datum/skill/craft/cooking = 6, /datum/skill/labor/fishing = 6, /datum/skill/labor/butchering = 6, /datum/skill/labor/lumberjacking = 6, /datum/skill/craft/masonry = 6, /datum/skill/craft/ceramics = 6, /datum/skill/craft/sewing = 3, /datum/skill/craft/tanning = 3), \
	TAT_TRAIT_SKILLED_HOMESTEADER = list(/datum/skill/labor/farming = 5, /datum/skill/craft/cooking = 5, /datum/skill/labor/fishing = 5), \
	TRAIT_SURVIVAL_EXPERT = list(/datum/skill/craft/cooking = 6, /datum/skill/labor/fishing = 6, /datum/skill/labor/butchering = 6, /datum/skill/craft/tanning = 6, /datum/skill/craft/sewing = 3), \
	TAT_TRAIT_SKILLED_SURVIVALIST = list(/datum/skill/labor/butchering = 5, /datum/skill/craft/traps = 5, /datum/skill/craft/tanning = 5), \
	TRAIT_SEWING_EXPERT = list(/datum/skill/craft/sewing = 6, /datum/skill/craft/tanning = 6, /datum/skill/labor/butchering = 6), \
	TAT_TRAIT_SKILLED_CLOTHIER = list(/datum/skill/craft/sewing = 5, /datum/skill/craft/tanning = 5), \
	TRAIT_SEEDKNOW = list(/datum/skill/labor/farming = 5), \
	TRAIT_CAUTIOUS_FISHER = list(/datum/skill/labor/fishing = 5), \
	TRAIT_SQUIRE_REPAIR = list(/datum/skill/craft/armorsmithing = 5, /datum/skill/craft/weaponsmithing = 5), \
	TRAIT_SELF_SUSTENANCE = list(/datum/skill/craft/crafting = 3, /datum/skill/craft/weaponsmithing = 3, /datum/skill/craft/armorsmithing = 3, /datum/skill/craft/blacksmithing = 3, /datum/skill/craft/smelting = 3, /datum/skill/craft/carpentry = 3, /datum/skill/craft/masonry = 3, /datum/skill/craft/traps = 3, /datum/skill/craft/engineering = 3, /datum/skill/craft/cooking = 3, /datum/skill/craft/sewing = 3, /datum/skill/craft/tanning = 3, /datum/skill/craft/ceramics = 3, /datum/skill/craft/alchemy = 3, /datum/skill/labor/farming = 3, /datum/skill/labor/mining = 3, /datum/skill/labor/fishing = 3, /datum/skill/labor/butchering = 3, /datum/skill/labor/lumberjacking = 3), \
	TRAIT_MASTERFUL_HUNTER = list(/datum/skill/misc/hunting = 6, /datum/skill/misc/tracking = 6, /datum/skill/labor/butchering = 6), \
	TRAIT_EXPERT_HUNTER = list(/datum/skill/misc/hunting = 5, /datum/skill/misc/tracking = 5), \
	TRAIT_FIREARMS_MARKSMAN = list(/datum/skill/combat/twilight_firearms = 4), \
	TAT_TRAIT_SADDLEBORN = list(/datum/skill/misc/riding = 6), \
)

GLOBAL_LIST_INIT(tat_trait_skill_cap_bonus_rules, TAT_TRAIT_SKILL_CAP_BONUS_RULES)

#define TAT_BUILD_STAT_BONUS_EXTRA_STATS 3
#define TAT_BUILD_STAT_BONUS_WANTED 5
#define TAT_BUILD_ITEM_BONUS_WANTED 10
#define TAT_BUILD_ITEM_BONUS_LOOTRAT 10
#define TAT_BUILD_ITEM_BONUS_LOOTRAT_2 15
#define TAT_TRAIT_PLIANT_RENAME_PQ_MINIMUM 50

#define TAT_CATEGORY_CLASS_MODULE "class_module"
#define TAT_CATEGORY_CLASS_MODULE_NAME "Class Modules"

#define TAT_CATEGORY_COMBAT_MASTERY "combat_mastery"
#define TAT_CATEGORY_COMBAT_MASTERY_NAME "Combat Mastery"

#define TAT_CATEGORY_DEFENSE "defense"
#define TAT_CATEGORY_DEFENSE_NAME "Defense"

#define TAT_CATEGORY_SUPPLY "supply"
#define TAT_CATEGORY_SUPPLY_NAME "Supply"

#define TAT_CATEGORY_ENHANCEMENT "enhancement"
#define TAT_CATEGORY_ENHANCEMENT_NAME "Enhancement"

#define TAT_CATEGORY_CRAFT "craft"
#define TAT_CATEGORY_CRAFT_NAME "Craft"

#define TAT_CATEGORY_UTILITY "utility"
#define TAT_CATEGORY_UTILITY_NAME "Utility"

#define TAT_CATEGORY_ODDITY "oddity"
#define TAT_CATEGORY_ODDITY_NAME "Oddities"

#define TAT_CATEGORY_MAJOR_FLAW "major_flaw"
#define TAT_CATEGORY_MAJOR_FLAW_NAME "Major Flaws"

#define TAT_NEGATIVE_TRAIT_CREDIT_CAP 20
#define TAT_CAPPED_NEGATIVE_TRAITS list( \
	TAT_TRAIT_HERETIC, \
	TRAIT_TECHNOPHOBE, \
	TRAIT_BAD_MOOD, \
	TRAIT_PACIFISM, \
	TRAIT_CRITICAL_WEAKNESS, \
	TRAIT_NUDIST, \
	TRAIT_INHUMEN_ANATOMY, \
	TRAIT_DISFIGURED, \
	TRAIT_SPELLCOCKBLOCK, \
	TRAIT_NOSLEEP, \
	TRAIT_NORUN, \
	TRAIT_NUDE_SLEEPER, \
	TRAIT_EASYDISMEMBER, \
	TRAIT_PERMAMUTE, \
	TRAIT_SHIRTLESS, \
	TRAIT_NODEF, \
	TRAIT_REVERSE_GUIDANCE, \
	TRAIT_LESSER_REVERSE_GUIDANCE \
)

#define TAT_CATEGORY_SKILL_DISCOUNT "skill_discount"
#define TAT_CATEGORY_SKILL_DISCOUNT_NAME "Skill Discount"
#define TAT_CATEGORY_SKILL_CONVERSION "skill_conversion"
#define TAT_CATEGORY_SKILL_CONVERSION_NAME "Skill Conversion"

#define TAT_RESIDENT_PUGILIST_DEFAULT "Dropkick - Pushback + Extra Damage"
#define TAT_TRAIT_DISCOUNT 10

#define TAT_ARMOR_SUPPLIER_CROSS_DISCOUNT 10
#define TAT_ARMOR_TRAINING_SUPPLIER_DISCOUNT 10
#define TAT_MATERIAL_SUPPLIER_CROSS_DISCOUNT 5

#define TAT_ARMOR_SUPPLIER_TRAITS list( \
	TAT_TRAIT_LEATHER_SUPPLIER, \
	TAT_TRAIT_MAIL_SUPPLIER, \
	TAT_TRAIT_PLATE_SUPPLIER \
)

#define TAT_MATERIAL_SUPPLIER_TRAITS list( \
	TAT_TRAIT_BRONZE_SUPPLIER, \
	TAT_TRAIT_SILVER_SUPPLIER, \
	TAT_TRAIT_STEEL_SUPPLIER \
)

#define TAT_ARMOR_TRAINING_SUPPLIER_DISCOUNT_RULES list( \
	TRAIT_MEDIUMARMOR = TAT_TRAIT_MAIL_SUPPLIER, \
	TRAIT_HEAVYARMOR = TAT_TRAIT_PLATE_SUPPLIER \
)
	
// TAT_TRAIT_CONTRACTOR = TAT_TRAIT_ENTRY("Contractor", 80, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Awakens the contract-bearing curse in your veins. The whole world is waiting your gifts and deals."),
#define TAT_AVAILABLE_TRAITS_LIST \
	TAT_TRAIT_SOUNDBREAKER = TAT_TRAIT_ENTRY("Soundbreaker", 20, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Unlocks the Soundbreaker combo style."), \
	TAT_TRAIT_MARTIAL_MASTER = TAT_TRAIT_ENTRY("Martial Master", 60, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Unlocks the Martial CQC combo styles. Requires Pugilist."), \
	TAT_TRAIT_RONIN = TAT_TRAIT_ENTRY("Ronin", 20, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Unlocks the Ronin combo style."), \
	TAT_TRAIT_SPELLBLADE = TAT_TRAIT_ENTRY("Spellblade", 10, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants a set of weapon-binding spells."), \
	TAT_TRAIT_RESIDENT = TAT_TRAIT_ENTRY("Resident", 10, TAT_CATEGORY_MAJOR_FLAW, TAT_CATEGORY_MAJOR_FLAW_NAME, "Grants a Meister account and ownership of a house in the city."), \
	TAT_TRAIT_TRADER_LICENSE = TAT_TRAIT_ENTRY("Merchant's Writ", 30, TAT_CATEGORY_MAJOR_FLAW, TAT_CATEGORY_MAJOR_FLAW_NAME, "Unlocks sealed trader caches in the TAT item list. Conflicts with Resident, Wanted, Outlander, and Heretic."), \
	TAT_TRAIT_BARDIC_INSPIRATION_T1 = TAT_TRAIT_ENTRY("Bardic Inspiration I", 15, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gain tier 1 bardic inspiration, audience management verbs, and a songbook."), \
	TAT_TRAIT_BARDIC_INSPIRATION_T2 = TAT_TRAIT_ENTRY("Bardic Inspiration II", 15, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Upgrades bardic inspiration to tier 2, increasing audience size and songs known."), \
	TAT_TRAIT_PARTY_LEADER = TAT_TRAIT_ENTRY("Party Leader", 30, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Improves the core Fellowship: nearby fellows gain +1 CON; while at least one fellow is nearby, the leader gains +1 CON, +1 WIL, and +0.5 Fortune per nearby fellow."), \
	TAT_TRAIT_BONUS_STAT_POOL = TAT_TRAIT_ENTRY("Natural Potential", 20, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gain +3 stat points in the build pool."), \
	TAT_TRAIT_CONTRACTOR_ENTITY = TAT_TRAIT_ENTRY("Tempress Entity", -10, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Unlocks the special Tempress entity subclass."), \
	TAT_TRAIT_WANTED = TAT_TRAIT_ENTRY("Wanted", -30, TAT_CATEGORY_MAJOR_FLAW, TAT_CATEGORY_MAJOR_FLAW_NAME, "Gain +5 stat points in the build pool, become an Outlaw, gain Forbidden Knowledge, and receive a bounty."), \
	TAT_TRAIT_TROPHY_BOUNTY = TAT_TRAIT_ENTRY("Trophy Bounty", 20, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "You can receive additional bonuses when wearing a headhook with monster heads."), \
	TAT_TRAIT_WARRIOR_EXPERT = TAT_TRAIT_ENTRY("Expert Warrior", 40, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_COMBAT_MASTERY_NAME, "Raises the combat skill cap from 3 to 4."), \
	TAT_TRAIT_WARRIOR_MASTER = TAT_TRAIT_ENTRY("Master Warrior", 30, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_COMBAT_MASTERY_NAME, "Raises the combat skill cap from 4 to 5. Requires Expert Warrior."), \
	TRAIT_DODGEEXPERT = TAT_TRAIT_ENTRY("Expert Dodger", 30, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Much better at dodging incoming strikes in light armor or with little armor. Heavy armor is too cumbersome for this style."), \
	TRAIT_PARRYEXPERT = TAT_TRAIT_ENTRY("Expert Parry", 30, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Much better at parrying incoming strikes, with a higher chance to deflect blows using a weapon."), \
	TRAIT_HEAVYARMOR = TAT_TRAIT_ENTRY("Plate Training", 30, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Can move freely in heavy armor."), \
	TRAIT_MEDIUMARMOR = TAT_TRAIT_ENTRY("Maille Training", 20, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Can move freely in medium armor."), \
	TRAIT_NOPAINSTUN = TAT_TRAIT_ENTRY("Enduring", 20, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Pain does not impair you as easily. You can endure more burns before collapsing."), \
	TAT_TRAIT_SAVAGE_SKIN = TAT_TRAIT_ENTRY("Savage Skin", 0, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Requires Enduring. Starts you with barbarian regenerating skin equipped in the armor slot."), \
	TAT_TRAIT_SAVAGE_RAGE = TAT_TRAIT_ENTRY("Savage Rage", 5, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Requires Savage Skin. Grants the Rage ability."), \
	TAT_TRAIT_BERSERKER_RAGE = TAT_TRAIT_ENTRY("Berserkers Rage", 10, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Requires Savage Skin and Heretic. Grants the Berserkers Rage ability."), \
	TRAIT_CRITICAL_RESISTANCE = TAT_TRAIT_ENTRY("Critical Resistance", 30, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Your constitution is iron-clad. You can resist the first critical wounds that would fell others, though repeated punishment will overwhelm you."), \
	TRAIT_HARDDISMEMBER = TAT_TRAIT_ENTRY("Hard Dismemberment", 20, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Your limbs are harder to dismember."), \
	TRAIT_STEELHEARTED = TAT_TRAIT_ENTRY("Steelhearted", 5, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Hardened nerves. You do not waiver from the sight of violence in battle."), \
	TRAIT_CIVILIZEDBARBARIAN = TAT_TRAIT_ENTRY("Expert Pugilist", 20, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Turns you into a living weapon: stronger unarmed strikes, broader unarmed reach, and much better parrying with bracers, knuckles, or bandages."), \
	TRAIT_FENCERDEXTERITY = TAT_TRAIT_ENTRY("Fencer's Dexterity", 10, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "I've trained my entire lyfe around the art of unarmoured fencing, affording myself unmatched speed when wearing very light armour. I'm very choosy otherwise. WARNING: YOU CAN WEAR ONLY LIGHT ARMOR"), \
	TAT_TRAIT_BRONZE_SUPPLIER = TAT_TRAIT_ENTRY("Bronze Supplier", 10, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks bronze-tier weapons."), \
	TAT_TRAIT_SILVER_SUPPLIER = TAT_TRAIT_ENTRY("Silver Supplier", 25, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks silver-tier weapons."), \
	TAT_TRAIT_STEEL_SUPPLIER = TAT_TRAIT_ENTRY("Steel Supplier", 15, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks steel-tier weapons."), \
	TAT_TRAIT_FIREARMS_SUPPLIER = TAT_TRAIT_ENTRY("Firearms Supplier", 25, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks blackpowder weapons and supplies."), \
	TAT_TRAIT_LEATHER_SUPPLIER = TAT_TRAIT_ENTRY("Leather Supplier", 10, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks leather gear in all supported slots."), \
	TAT_TRAIT_MAIL_SUPPLIER = TAT_TRAIT_ENTRY("Mail Supplier", 20, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks mail gear in all supported slots."), \
	TAT_TRAIT_PLATE_SUPPLIER = TAT_TRAIT_ENTRY("Plate Supplier", 30, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks plate gear in all supported slots."), \
	TRAIT_INTELLECTUAL = TAT_TRAIT_ENTRY("Intellectual", 20, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You have a keen eye and can assess a person's prowess in wit and blade."), \
	TAT_TRAIT_LOOTRAT = TAT_TRAIT_ENTRY("Loot Rat", 10, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_ENHANCEMENT_NAME, "Somehow in your journeys or life you collect a lot of different things and exotic treasures. Increase loot points by 10."), \
	TAT_TRAIT_LOOTRAT_2 = TAT_TRAIT_ENTRY("Enormous Rat", 20, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_ENHANCEMENT_NAME, "You work on Guild with mountains of gold or you're just a lucky dungeon mudskipper. Increase loot points by 15."), \
	TRAIT_ARCYNE = TAT_TRAIT_ENTRY("Arcyne Training", 10, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_ENHANCEMENT_NAME, "You are trained in the Arcyne arts, allowing you to wield magyck. Basis trait for magic-build classes. Gives +3 Arcane skill if there is no defensive lockout trait."), \
	TRAIT_JACKOFALLTRADES = TAT_TRAIT_ENTRY("Jack of All Trades", 15, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Skills cost half as much for you to raise."), \
	TAT_TRAIT_MASTER_OF_WANDERING = TAT_TRAIT_ENTRY("Master of Wandering", 30, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Gives +20 Misc skill points and a discount on Misc skills. Conflicts with Resident."), \
	TAT_TRAIT_PLIANT_RENAME = TAT_TRAIT_ENTRY("Pliant Class Name", 0, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Requires 50+ player quality. Lets you rename your displayed class while keeping the Pliant admin marker prefix. Resident class selection is applied first, then you may choose the current class or a matching skill title as the base, and finally use that name, your active TAT slot name, or custom input."), \
	TRAIT_EMPATH = TAT_TRAIT_ENTRY("Empath", 5, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You can notice when people are in pain."), \
	TRAIT_NOSTINK = TAT_TRAIT_ENTRY("Dead Nose", 10, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Your nose is numb to the smell of decay."), \
	TRAIT_CICERONE = TAT_TRAIT_ENTRY("Cicerone", 5, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "You are well-versed in brews and spirits, and can tell them apart at a glance."), \
	TRAIT_SEEPRICES = TAT_TRAIT_ENTRY("Appraiser", 10, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "You can tell the prices of things down to the zenny."), \
	TRAIT_OUTLANDER = TAT_TRAIT_ENTRY("Outlander", -20, TAT_CATEGORY_MAJOR_FLAW, TAT_CATEGORY_MAJOR_FLAW_NAME, "The locals see you as not of their land."), \
	TRAIT_GRAVEROBBER = TAT_TRAIT_ENTRY("Experienced Grave Robber", 20, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "Your experience with 'post-mortem artifact recovery' helps you resist Necra's curse placed on those who disturb resting places."), \
	TRAIT_PURITAN_ADVENTURER = TAT_TRAIT_ENTRY("Interrogator", 20, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "With a silver psycross, you can force the restrained to kneel before a crucifix and proclaim their true allegiance."), \
	TRAIT_DECEIVING_MEEKNESS = TAT_TRAIT_ENTRY("Deceiving Meekness", 15, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "People think you are weak. They are mistaken. You have learned to hide your vices and true beliefs from others."), \
	TRAIT_NASTY_EATER = TAT_TRAIT_ENTRY("Inhumen Digestion", 15, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You can eat bad food, and water toxic to humen does not affect you."), \
	TRAIT_GOODLOVER = TAT_TRAIT_ENTRY("Fabled Lover", 10, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "It is a lucky thing to share your bed."), \
	TRAIT_NUTCRACKER = TAT_TRAIT_ENTRY("Nutcracker", 5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You love kicking idiots in the nuts."), \
	TAT_TRAIT_DIVINE_INITIATE = TAT_TRAIT_ENTRY("Divine Initiate", 15, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants miracles and devotion. Additional divine boon traits increase miracle access."), \
	TAT_TRAIT_DIVINE_BOON_1 = TAT_TRAIT_ENTRY("Divine Boon I", 15, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Divine Initiate. Raises your miracle package by one tier."), \
	TAT_TRAIT_DIVINE_BOON_2 = TAT_TRAIT_ENTRY("Divine Boon II", 15, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Divine Initiate and Divine Boon I. Raises your miracle package by one tier."), \
	TAT_TRAIT_DIVINE_BOON_3 = TAT_TRAIT_ENTRY("Divine Boon III", 15, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Divine Initiate and Divine Boon II. Raises your miracle package by one tier."), \
	TAT_TRAIT_MAGE_INITIATE = TAT_TRAIT_ENTRY("Mage Initiate", 15, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants one minor spell, three utility spells, plus one extra utility per Arcane skill level."), \
	TAT_TRAIT_MAGE_MAJOR_SLOT = TAT_TRAIT_ENTRY("Arcane Major Slot", 15, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Mage Initiate. Grants +1 major spell slot."), \
	TAT_TRAIT_MAGE_MINOR_SLOT_1 = TAT_TRAIT_ENTRY("Arcane Minor Slot I", 10, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Mage Initiate. Grants +1 minor spell slot."), \
	TAT_TRAIT_MAGE_MINOR_SLOT_2 = TAT_TRAIT_ENTRY("Arcane Minor Slot II", 10, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Mage Initiate. Grants +1 minor spell slot."), \
	TAT_TRAIT_MAGE_UTILITY_SLOT = TAT_TRAIT_ENTRY("Arcane Utility Slot", 10, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Mage Initiate. Grants +1 utility spell slot."), \
	TAT_TRAIT_DRUID_INITIATE = TAT_TRAIT_ENTRY("Druid Initiate", 40, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants Dendor's druidic rites, direct druid spells, and wise tree alert."), \
	TAT_TRAIT_WITCH_INITIATE = TAT_TRAIT_ENTRY("Witch Initiate", 30, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants witch trait and ability to shapeshift yourself into different small creatures."), \
	TRAIT_EXPLOSIVE_SUPPLY = TAT_TRAIT_ENTRY("Explosive Supply", 10, TAT_CATEGORY_UTILITY, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants explosives gifts from your friends. Luck scaled."), \
	TAT_TRAIT_ARTIFACTS_SUPPLIER = TAT_TRAIT_ENTRY("Artifacts Bearer", 50, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "You're one of the adventurers with stories about your raids. Now, you have one of the deadliest weapons in Grimmoria. REQUIRES: Party Leader"), \
	TRAIT_FIREARMS_MARKSMAN = TAT_TRAIT_ENTRY("Firearms Training", 30, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_COMBAT_MASTERY_NAME, "Raises the combat Firearms cap from 2 to 4."), \
	TAT_TRAIT_TRAINEE_SMITH = TAT_TRAIT_ENTRY("Trainee Smith", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Blacksmithing, Smelting, and the first two levels of Maces by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_ARMORER = TAT_TRAIT_ENTRY("Trainee Armorer", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Armorsmithing, Masonry, and the first two levels of Shields by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_WEAPONSMITH = TAT_TRAIT_ENTRY("Trainee Weaponsmith", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Weaponsmithing, Engineering, and the first two levels of Swords by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_WOODSMAN = TAT_TRAIT_ENTRY("Trainee Woodsman", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Lumberjacking, Carpentry, and the first two levels of Axes by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_SURVIVALIST = TAT_TRAIT_ENTRY("Trainee Survivalist", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Butchering, Hunting, and the first two levels of Archery by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_POACHER = TAT_TRAIT_ENTRY("Trainee Poacher", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Tracking, Trapmaking, and the first two levels of Crossbows by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_SKULKER = TAT_TRAIT_ENTRY("Trainee Skulker", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Sneaking, Lockpicking, and the first two levels of Knives by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_VAGABOND = TAT_TRAIT_ENTRY("Trainee Vagabond", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Pickpocketing, Climbing, and the first two levels of Slings by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_RIDER = TAT_TRAIT_ENTRY("Trainee Rider", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Riding, Athletics, and the first two levels of Polearms by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_MARINER = TAT_TRAIT_ENTRY("Trainee Mariner", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Swimming, Fishing, and the first two levels of Staves by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_CLOTHIER = TAT_TRAIT_ENTRY("Trainee Clothier", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Sewing, Skincrafting, and the first two levels of Whips & Flails by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_HOMESTEADER = TAT_TRAIT_ENTRY("Trainee Homesteader", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Farming, Cooking, and the first two levels of Wrestling by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_ARTISAN = TAT_TRAIT_ENTRY("Trainee Artisan", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Crafting, Pottery, and the first two levels of Unarmed by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_CHIRURGEON = TAT_TRAIT_ENTRY("Trainee Chirurgeon", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Medicine, Literacy, and the first two levels of Staves by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_TROUBADOUR = TAT_TRAIT_ENTRY("Trainee Troubadour", 10, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Music, Literacy, and the first two levels of Knives by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TRAIT_BITERHELM = TAT_TRAIT_ENTRY("Curse of Twisting Metall", 10, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_COMBAT_MASTERY_NAME, "Gives cursed skill to bite through your own helmet"), \
	TAT_TRAIT_MASTER_OF_CRAFTING = TAT_TRAIT_ENTRY("Master of Handicraft", 20, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Gain extra Crafting skill-domain points."), \
	TAT_TRAIT_STOCKPILER = TAT_TRAIT_ENTRY("Stockpiler", 20, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Gain extra Gathering skill-domain points."), \
	TRAIT_SMITHING_EXPERT = TAT_TRAIT_ENTRY("Expert Forgehand", 20, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with smithing and engineering. Smithing, Smelting, Engineering, Mining, Masonry and Pottery can progress to Legendary levels."), \
	TAT_TRAIT_SKILLED_FORGEHAND = TAT_TRAIT_ENTRY("Skilled Forgehand", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Skilled with forge-work. Smithing, Smelting and Engineering can progress to Master levels."), \
	TAT_TRAIT_SKILLED_ARMORER = TAT_TRAIT_ENTRY("Skilled Armorer", 20, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Skilled with armor repair and fitting. Armorsmithing and Masonry can progress to Master levels."), \
	TAT_TRAIT_SKILLED_WEAPONSMITH = TAT_TRAIT_ENTRY("Skilled Weaponsmith", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Skilled with weapon work. Weaponsmithing and Engineering can progress to Master levels."), \
	TAT_TRAIT_SKILLED_ARTISAN = TAT_TRAIT_ENTRY("Skilled Artisan", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Skilled with general craftwork. Crafting and Pottery can progress to Master levels."), \
	TAT_TRAIT_SKILLED_MASON = TAT_TRAIT_ENTRY("Skilled Architect", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Skilled with stone and kiln work. Masonry, Woodwork and Pottery can progress to Master levels."), \
	TRAIT_ALCHEMY_EXPERT = TAT_TRAIT_ENTRY("Expert Alchemist", 20, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Deep, intricate knowledge of the alchemical arts. Alchemy can progress to Legendary levels."), \
	TAT_TRAIT_SKILLED_ALCHEMIST = TAT_TRAIT_ENTRY("Skilled Alchemist", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Skilled with alchemical work. Alchemy can progress to Master levels."), \
	TRAIT_MEDICINE_EXPERT = TAT_TRAIT_ENTRY("Expert Physicker", 20, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Deep, intricate knowledge of medicine. Medicine can progress to Legendary levels."), \
	TAT_TRAIT_SKILLED_LOCKER = TAT_TRAIT_ENTRY("Lock pocket", 20, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Hands know how to work. Increase points availabe to pick in lockpicking and pickpocketing to master levels."), \
	TAT_TRAIT_SKILLED_PHYSICKER = TAT_TRAIT_ENTRY("Skilled Physicker", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Skilled with medical practice. Medicine can progress to Master levels."), \
	TRAIT_HOMESTEAD_EXPERT = TAT_TRAIT_ENTRY("Expert Homesteader", 25, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with the arts of homesteading. Farming, Mining, Cooking, Fishing, Butchering, Lumberjacking, Masonry and Pottery can progress to Legendary levels. Sewing and Skincrafting can progress to Journeyman levels."), \
	TRAIT_SELF_SUSTENANCE = TAT_TRAIT_ENTRY("Self-Sustenance", 15, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Years of running from the law and living off the land have made you a jack of all trades. All crafting and labor skills can progress to Journeyman levels."), \
	TRAIT_SURVIVAL_EXPERT = TAT_TRAIT_ENTRY("Expert Survivalist", 20, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with survival in the wild. Cooking, Fishing, Butchering and Skincrafting can progress to Legendary levels. Sewing can progress to Journeyman levels."), \
	TAT_TRAIT_SKILLED_SURVIVALIST = TAT_TRAIT_ENTRY("Skilled Survivalist", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Skilled with survival work. Butchering, Trapmaking and Skincrafting can progress to Master levels."), \
	TRAIT_SEWING_EXPERT = TAT_TRAIT_ENTRY("Expert Clothier", 20, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with sewing and leathercraft. Sewing, Skincrafting and Butchering can progress to Legendary levels."), \
	TAT_TRAIT_SKILLED_CLOTHIER = TAT_TRAIT_ENTRY("Skilled Clothier", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Skilled with cloth and leather. Sewing and Skincrafting can progress to Master levels."), \
	TRAIT_SEEDKNOW = TAT_TRAIT_ENTRY("Seed Knower", 5, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You know which seeds grow which crops."), \
	TRAIT_CAUTIOUS_FISHER = TAT_TRAIT_ENTRY("Cautious Fisher", 5, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You know the dangers of fishing and how to avoid unwanted attention from the depths."), \
	TRAIT_SQUIRE_REPAIR = TAT_TRAIT_ENTRY("Squire Knowledge", 15, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You can restore gear with time and polish it until it gleams like new."), \
	TAT_TRAIT_SADDLEBORN = TAT_TRAIT_ENTRY("Saddleborn", 15, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You can select and mount a specific mount."), \
	TRAIT_MASTERFUL_HUNTER = TAT_TRAIT_ENTRY("Masterful Hunter", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "To hunt well is to know the land. You know watering holes, feeding grounds and bent thickets."), \
	TRAIT_EXPERT_HUNTER = TAT_TRAIT_ENTRY("Expert Hunter", 5, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "To hunt well is to know the land. You know the common signs of prey and trails."), \
	TAT_TRAIT_STRAYING_SOUL = TAT_TRAIT_ENTRY("Straying Soul", 10, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Your feet walks a lot roads. Gives you +9 points in wandering skill tree."), \
	TAT_TRAIT_HERETIC = TAT_TRAIT_ENTRY("Heretic", 0, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gain cool HERETIC mark on your face."), \
	TRAIT_RITUALIST = TAT_TRAIT_ENTRY("Ritualist", 30, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gives God's favour for thy's rituals. Adds ritual chalk to your stash."), \
	TRAIT_TECHNOPHOBE = TAT_TRAIT_ENTRY("Technophobe", -5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You cannot use Meister devices."), \
	TRAIT_BAD_MOOD = TAT_TRAIT_ENTRY("Bad Mood", -5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "All stress you receive is doubled."), \
	TRAIT_PACIFISM = TAT_TRAIT_ENTRY("Pacifist", -20, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You cannot harm living beings."), \
	TRAIT_CRITICAL_WEAKNESS = TAT_TRAIT_ENTRY("Critical Weakness", -15, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You are far more vulnerable to critical wounds."), \
	TRAIT_NUDIST = TAT_TRAIT_ENTRY("Nudist", -10, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You refuse to wear clothes."), \
	TRAIT_INHUMEN_ANATOMY = TAT_TRAIT_ENTRY("Inhumen Anatomy", -5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "Your anatomy prevents you from wearing hats and boots."), \
	TRAIT_DISFIGURED = TAT_TRAIT_ENTRY("Disfigured", 5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You are unknowned to everyone."), \
	TRAIT_SPELLCOCKBLOCK = TAT_TRAIT_ENTRY("Bewitched", -5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You cannot cast spells."), \
	TRAIT_NOSLEEP = TAT_TRAIT_ENTRY("Sleepless", -5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You cannot fall asleep without drugs or a blow to the head."), \
	TRAIT_NORUN = TAT_TRAIT_ENTRY("No Running", -10, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You cannot run."), \
	TRAIT_NUDE_SLEEPER = TAT_TRAIT_ENTRY("Nude Sleeper", -5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You can only sleep while fully naked."), \
	TRAIT_EASYDISMEMBER = TAT_TRAIT_ENTRY("Easy Dismemberment", -15, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "Your limbs are much easier to dismember."), \
	TRAIT_PERMAMUTE = TAT_TRAIT_ENTRY("Permanent Mute", -10, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You are permanently mute and cannot speak."), \
	TRAIT_NODEF = TAT_TRAIT_ENTRY("No Defense", -20, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You expose yourself completely in battle."), \
	TRAIT_REVERSE_GUIDANCE = TAT_TRAIT_ENTRY("Reverse Guidance", -10, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "Something hinders you in battle. Anti-guidance: 20%."), \
	TRAIT_LESSER_REVERSE_GUIDANCE = TAT_TRAIT_ENTRY("Lesser Reverse Guidance", -5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "Something faintly hinders you in battle. Anti-guidance: 10%."), \
	TAT_TRAIT_ACCURSED = TAT_TRAIT_ENTRY("Dendor's Curse", -5, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You're cursed by the Sleeping Volf. Now you're shapshift to lesser creachure every nite.")

#define TAT_TRAIT_STAT_POINT_RULES list( \
	TAT_TRAIT_BONUS_STAT_POOL = TAT_BUILD_STAT_BONUS_EXTRA_STATS, \
	TAT_TRAIT_WANTED = TAT_BUILD_STAT_BONUS_WANTED, \
	TAT_TRAIT_CONTRACTOR = -TAT_BASIC_STAT_POINTS \
)

#define TAT_TRAIT_ITEM_POINT_RULES list( \
	TAT_TRAIT_WANTED = TAT_BUILD_ITEM_BONUS_WANTED, \
	TAT_TRAIT_LOOTRAT = TAT_BUILD_ITEM_BONUS_LOOTRAT, \
	TAT_TRAIT_LOOTRAT_2 = TAT_BUILD_ITEM_BONUS_LOOTRAT_2, \
	TAT_TRAIT_CONTRACTOR_ENTITY = TAT_BUILD_ITEM_BONUS_LOOTRAT \
)

#define TAT_TRAIT_ITEM_UNLOCK_RULES list( \
	TAT_UNLOCK_TYPE_WEAPON_SUPPLY = list(TAT_SUPPLY_BRONZE = TAT_TRAIT_BRONZE_SUPPLIER, TAT_SUPPLY_SILVER = TAT_TRAIT_SILVER_SUPPLIER, TAT_SUPPLY_STEEL = TAT_TRAIT_STEEL_SUPPLIER, TAT_SUPPLY_FIREARMS = TAT_TRAIT_FIREARMS_SUPPLIER, TAT_SUPPLY_ARTIFACTS = TAT_TRAIT_ARTIFACTS_SUPPLIER), \
	TAT_UNLOCK_TYPE_ARMOR_FAMILY = list(TAT_ARMOR_LEATHER = TAT_TRAIT_LEATHER_SUPPLIER, TAT_ARMOR_MAIL = TAT_TRAIT_MAIL_SUPPLIER, TAT_ARMOR_PLATE = TAT_TRAIT_PLATE_SUPPLIER) \
)

#define TAT_TRAIT_PQ_LOCK_RULES list( \
	TAT_TRAIT_PLIANT_RENAME = TAT_TRAIT_PLIANT_RENAME_PQ_MINIMUM \
)

#define TAT_TRAIT_REPEATABLE_MAXIMUMS list()

#define TAT_TRAIT_SKILL_POINT_RULES list( \
	TAT_TRAIT_MASTER_OF_WANDERING = list( \
		TAT_SKILL_DOMAIN_WANDERING = 15, \
		TAT_SKILL_DOMAIN_MISC = 10 \
	), \
	TAT_TRAIT_STRAYING_SOUL = list( \
		TAT_SKILL_DOMAIN_WANDERING = 9, \
	), \
	TAT_TRAIT_MASTER_OF_CRAFTING = list( \
		TAT_SKILL_DOMAIN_CRAFTING = 25 \
	), \
	TAT_TRAIT_STOCKPILER = list( \
		TAT_SKILL_DOMAIN_GATHERING = 20 \
	), \
	TAT_TRAIT_WARRIOR_EXPERT = list( \
		TAT_SKILL_DOMAIN_COMBAT = 15 \
	), \
	TAT_TRAIT_WARRIOR_MASTER = list( \
		TAT_SKILL_DOMAIN_COMBAT = 10 \
	), \
	TAT_TRAIT_MAGE_INITIATE = list( \
		TAT_SKILL_DOMAIN_MISC = 2 \
	), \
	TAT_TRAIT_MAGE_MAJOR_SLOT = list( \
		TAT_SKILL_DOMAIN_MISC = 4 \
	), \
	TAT_TRAIT_MAGE_MINOR_SLOT_2 = list( \
		TAT_SKILL_DOMAIN_MISC = 3 \
	), \
	TAT_TRAIT_MAGE_UTILITY_SLOT = list( \
		TAT_SKILL_DOMAIN_MISC = 4 \
	), \
	TAT_TRAIT_DIVINE_BOON_1 = list( \
		TAT_SKILL_DOMAIN_MISC = 3 \
	), \
	TAT_TRAIT_DIVINE_BOON_2 = list( \
		TAT_SKILL_DOMAIN_MISC = 4 \
	), \
	TAT_TRAIT_DIVINE_BOON_3 = list( \
		TAT_SKILL_DOMAIN_MISC = 5 \
	), \
	TAT_TRAIT_DRUID_INITIATE = list( \
		TAT_SKILL_DOMAIN_MISC = 2 \
	), \
	TAT_TRAIT_BARDIC_INSPIRATION_T1 = list( \
		TAT_SKILL_DOMAIN_MISC = 4 \
	), \
	TAT_TRAIT_BARDIC_INSPIRATION_T2 = list( \
		TAT_SKILL_DOMAIN_MISC = 5 \
	), \
)

#define TAT_TRAIT_SKILL_BONUS_RULES list( \
	TRAIT_SMITHING_EXPERT = list(/datum/skill/craft/blacksmithing = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/smelting = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/engineering = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/mining = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/masonry = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/ceramics = TAT_SKILL_BASIC_BOOST), \
	TAT_TRAIT_SKILLED_FORGEHAND = list(/datum/skill/craft/blacksmithing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/smelting = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/engineering = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_SKILLED_ARMORER = list(/datum/skill/craft/armorsmithing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/masonry = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_SKILLED_WEAPONSMITH = list(/datum/skill/craft/weaponsmithing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/engineering = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_SKILLED_ARTISAN = list(/datum/skill/craft/crafting = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/ceramics = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_SKILLED_MASON = list(/datum/skill/craft/masonry = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/carpentry = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/ceramics = TAT_SKILL_DISCOUNT_BOOST), \
	TRAIT_ALCHEMY_EXPERT = list(/datum/skill/craft/alchemy = TAT_SKILL_BASIC_BOOST), \
	TAT_TRAIT_SKILLED_ALCHEMIST = list(/datum/skill/craft/alchemy = TAT_SKILL_DISCOUNT_BOOST), \
	TRAIT_MEDICINE_EXPERT = list(/datum/skill/misc/medicine = TAT_SKILL_BASIC_BOOST), \
	TAT_TRAIT_SKILLED_PHYSICKER = list(/datum/skill/misc/medicine = TAT_SKILL_DISCOUNT_BOOST), \
	TRAIT_HOMESTEAD_EXPERT = list(/datum/skill/labor/farming = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/mining = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/cooking = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/fishing = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/butchering = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/lumberjacking = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/masonry = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/ceramics = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/sewing = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/tanning = TAT_SKILL_BASIC_BOOST), \
	TAT_TRAIT_SKILLED_HOMESTEADER = list(/datum/skill/labor/farming = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/cooking = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/labor/fishing = TAT_SKILL_DISCOUNT_BOOST), \
	TRAIT_SURVIVAL_EXPERT = list(/datum/skill/craft/cooking = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/fishing = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/butchering = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/tanning = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/sewing = TAT_SKILL_BASIC_BOOST), \
	TAT_TRAIT_SKILLED_SURVIVALIST = list(/datum/skill/labor/butchering = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/traps = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/tanning = TAT_SKILL_DISCOUNT_BOOST), \
	TRAIT_SEWING_EXPERT = list(/datum/skill/craft/sewing = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/tanning = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/butchering = TAT_SKILL_BASIC_BOOST), \
	TAT_TRAIT_SKILLED_CLOTHIER = list(/datum/skill/craft/sewing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/tanning = TAT_SKILL_DISCOUNT_BOOST), \
	TRAIT_SEEDKNOW = list(/datum/skill/labor/farming = TAT_SKILL_DISCOUNT_BOOST), \
	TRAIT_CAUTIOUS_FISHER = list(/datum/skill/labor/fishing = TAT_SKILL_DISCOUNT_BOOST), \
	TRAIT_SQUIRE_REPAIR = list(/datum/skill/craft/armorsmithing = TAT_SKILL_BASIC_BOOST, /datum/skill/craft/weaponsmithing = TAT_SKILL_BASIC_BOOST), \
	TRAIT_SELF_SUSTENANCE = list(/datum/skill/craft/crafting = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/weaponsmithing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/armorsmithing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/blacksmithing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/smelting = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/carpentry = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/masonry = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/traps = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/engineering = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/cooking = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/sewing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/tanning = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/ceramics = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/alchemy = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/labor/farming = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/labor/mining = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/labor/fishing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/labor/butchering = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/labor/lumberjacking = TAT_SKILL_DISCOUNT_BOOST), \
	TRAIT_MASTERFUL_HUNTER = list(/datum/skill/misc/hunting = TAT_SKILL_BASIC_BOOST, /datum/skill/misc/tracking = TAT_SKILL_BASIC_BOOST, /datum/skill/labor/butchering = TAT_SKILL_BASIC_BOOST), \
	TRAIT_EXPERT_HUNTER = list(/datum/skill/misc/hunting = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/misc/tracking = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_SMITH = list(/datum/skill/craft/blacksmithing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/smelting = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/maces = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_ARMORER = list(/datum/skill/craft/armorsmithing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/masonry = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/shields = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_WEAPONSMITH = list(/datum/skill/craft/weaponsmithing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/engineering = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/swords = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_WOODSMAN = list(/datum/skill/labor/lumberjacking = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/carpentry = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/axes = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_SURVIVALIST = list(/datum/skill/labor/butchering = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/traps = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/bows = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_POACHER = list(/datum/skill/misc/tracking = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/traps = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/crossbows = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_SKULKER = list(/datum/skill/misc/sneaking = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/misc/lockpicking = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/knives = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_VAGABOND = list(/datum/skill/misc/stealing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/misc/climbing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/slings = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_RIDER = list(/datum/skill/misc/riding = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/misc/athletics = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/polearms = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_MARINER = list(/datum/skill/misc/swimming = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/labor/fishing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/staves = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_CLOTHIER = list(/datum/skill/craft/sewing = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/tanning = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/whipsflails = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_HOMESTEADER = list(/datum/skill/labor/farming = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/cooking = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/wrestling = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_ARTISAN = list(/datum/skill/craft/crafting = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/craft/ceramics = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/unarmed = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_CHIRURGEON = list(/datum/skill/misc/medicine = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/misc/reading = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/staves = TAT_SKILL_DISCOUNT_BOOST), \
	TAT_TRAIT_TRAINEE_TROUBADOUR = list(/datum/skill/misc/music = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/misc/reading = TAT_SKILL_DISCOUNT_BOOST, /datum/skill/combat/knives = TAT_SKILL_DISCOUNT_BOOST) \
)

#define TAT_TRAIT_SKILL_DISCOUNT_RULES list( \
	TAT_TRAIT_TRAINEE_SMITH = list(/datum/skill/craft/blacksmithing, /datum/skill/craft/smelting, /datum/skill/combat/maces), \
	TAT_TRAIT_TRAINEE_ARMORER = list(/datum/skill/craft/armorsmithing, /datum/skill/craft/masonry, /datum/skill/combat/shields), \
	TAT_TRAIT_TRAINEE_WEAPONSMITH = list(/datum/skill/craft/weaponsmithing, /datum/skill/craft/engineering, /datum/skill/combat/swords), \
	TAT_TRAIT_TRAINEE_WOODSMAN = list(/datum/skill/labor/lumberjacking, /datum/skill/craft/carpentry, /datum/skill/combat/axes), \
	TAT_TRAIT_TRAINEE_SURVIVALIST = list(/datum/skill/labor/butchering, /datum/skill/craft/traps, /datum/skill/combat/bows), \
	TAT_TRAIT_TRAINEE_POACHER = list(/datum/skill/misc/tracking, /datum/skill/craft/traps, /datum/skill/combat/crossbows), \
	TAT_TRAIT_TRAINEE_SKULKER = list(/datum/skill/misc/sneaking, /datum/skill/misc/lockpicking, /datum/skill/combat/knives), \
	TAT_TRAIT_TRAINEE_VAGABOND = list(/datum/skill/misc/stealing, /datum/skill/misc/climbing, /datum/skill/combat/slings), \
	TAT_TRAIT_TRAINEE_RIDER = list(/datum/skill/misc/riding, /datum/skill/misc/athletics, /datum/skill/combat/polearms), \
	TAT_TRAIT_TRAINEE_MARINER = list(/datum/skill/misc/swimming, /datum/skill/labor/fishing, /datum/skill/combat/staves), \
	TAT_TRAIT_TRAINEE_CLOTHIER = list(/datum/skill/craft/sewing, /datum/skill/craft/tanning, /datum/skill/combat/whipsflails), \
	TAT_TRAIT_TRAINEE_HOMESTEADER = list(/datum/skill/labor/farming, /datum/skill/craft/cooking, /datum/skill/combat/wrestling), \
	TAT_TRAIT_TRAINEE_ARTISAN = list(/datum/skill/craft/crafting, /datum/skill/craft/ceramics, /datum/skill/combat/unarmed), \
	TAT_TRAIT_TRAINEE_CHIRURGEON = list(/datum/skill/misc/medicine, /datum/skill/misc/reading, /datum/skill/combat/staves), \
	TAT_TRAIT_TRAINEE_TROUBADOUR = list(/datum/skill/misc/music, /datum/skill/misc/reading, /datum/skill/combat/knives) \
)

GLOBAL_LIST_INIT(tat_available_traits, list(TAT_AVAILABLE_TRAITS_LIST))
GLOBAL_LIST_INIT(tat_capped_negative_traits, TAT_CAPPED_NEGATIVE_TRAITS)
GLOBAL_LIST_EMPTY(tat_trait_conflict_map)
GLOBAL_LIST_EMPTY(tat_trait_requirement_map)
GLOBAL_LIST_INIT(tat_trait_stat_point_rules, TAT_TRAIT_STAT_POINT_RULES)
GLOBAL_LIST_INIT(tat_trait_item_point_rules, TAT_TRAIT_ITEM_POINT_RULES)
GLOBAL_LIST_INIT(tat_trait_item_unlock_rules, TAT_TRAIT_ITEM_UNLOCK_RULES)
GLOBAL_LIST_INIT(tat_trait_skill_point_rules, TAT_TRAIT_SKILL_POINT_RULES)
GLOBAL_LIST_INIT(tat_trait_skill_bonus_rules, TAT_TRAIT_SKILL_BONUS_RULES)
GLOBAL_LIST_INIT(tat_trait_skill_discount_rules, TAT_TRAIT_SKILL_DISCOUNT_RULES)
GLOBAL_LIST_INIT(tat_trait_pq_lock_rules, TAT_TRAIT_PQ_LOCK_RULES)
GLOBAL_LIST_INIT(tat_armor_supplier_traits, TAT_ARMOR_SUPPLIER_TRAITS)
GLOBAL_LIST_INIT(tat_material_supplier_traits, TAT_MATERIAL_SUPPLIER_TRAITS)
GLOBAL_LIST_INIT(tat_trait_armor_training_supplier_discount_rules, TAT_ARMOR_TRAINING_SUPPLIER_DISCOUNT_RULES)
GLOBAL_LIST_INIT(tat_supplier_trait_unlocks, build_tat_supplier_trait_unlocks())

/proc/build_tat_supplier_trait_unlocks()
	var/list/result = list()
	var/list/rules = TAT_TRAIT_ITEM_UNLOCK_RULES
	for(var/unlock_type in rules)
		var/list/keys = rules[unlock_type]
		if(!islist(keys))
			continue
		for(var/unlock_key in keys)
			var/trait_id = keys[unlock_key]
			if(!trait_id)
				continue
			result[trait_id] = list("unlock_type" = unlock_type, "unlock_key" = unlock_key)
	return result
