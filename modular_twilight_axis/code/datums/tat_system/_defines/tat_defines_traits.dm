#define TRAIT_MASTERYOFNOTHING_POINTS 20

#define TAT_TRAIT_WARRIOR_EXPERT "tat_warrior_expert"
#define TAT_TRAIT_WARRIOR_MASTER "tat_warrior_master"
#define TAT_TRAIT_SOUNDBREAKER "tat_soundbreaker"
#define TAT_TRAIT_RONIN "tat_ronin"
#define TAT_TRAIT_RESIDENT "tat_resident"
#define TAT_TRAIT_MASTER_OF_NOTHING "tat_master_of_nothing"

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

#define TAT_TRAIT_DIVINE_INITIATE "tat_divine_initiate"
#define TAT_TRAIT_MAGE_INITIATE "tat_mage_initiate"
#define TAT_TRAIT_DRUID_INITIATE "tat_druid_initiate"
#define TAT_TRAIT_WITCH_INITIATE "tat_witch_initiate"

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

#define TAT_BUILD_STAT_BONUS_EXTRA_STATS 3
#define TAT_BUILD_STAT_BONUS_WANTED 5
#define TAT_BUILD_ITEM_BONUS_WANTED 10

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

#define TAT_CATEGORY_SKILL_DISCOUNT "skill_discount"
#define TAT_CATEGORY_SKILL_DISCOUNT_NAME "Skill Discount"

#define TAT_RESIDENT_PUGILIST_DEFAULT "Dropkick - Pushback + Extra Damage"
#define TAT_TRAIT_DISCOUNT 1

#define TAT_AVAILABLE_TRAITS_LIST \
	TAT_TRAIT_SOUNDBREAKER = TAT_TRAIT_ENTRY("Soundbreaker", 4, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Unlocks the Soundbreaker combo style."), \
	TAT_TRAIT_RONIN = TAT_TRAIT_ENTRY("Ronin", 4, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Unlocks the Ronin combo style."), \
	TAT_TRAIT_SPELLBLADE = TAT_TRAIT_ENTRY("Spellblade", 1, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants a set of weapon-binding spells."), \
	TAT_TRAIT_RESIDENT = TAT_TRAIT_ENTRY("Resident", 1, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants a Meister account and ownership of a house in the city."), \
	TAT_TRAIT_BARDIC_INSPIRATION_T1 = TAT_TRAIT_ENTRY("Bardic Inspiration I", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gain tier 1 bardic inspiration, audience management verbs, and a songbook."), \
	TAT_TRAIT_BARDIC_INSPIRATION_T2 = TAT_TRAIT_ENTRY("Bardic Inspiration II", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Upgrades bardic inspiration to tier 2, increasing audience size and songs known."), \
	TAT_TRAIT_PARTY_LEADER = TAT_TRAIT_ENTRY("Party Leader", 3, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Can form a party through Leadership verbs. While the party has at least two willing members, gain +1 CON and +1 WIL."), \
	TAT_TRAIT_BONUS_STAT_POOL = TAT_TRAIT_ENTRY("Natural Potential", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gain +3 stat points in the build pool."), \
	TAT_TRAIT_WANTED = TAT_TRAIT_ENTRY("Wanted", -2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gain +5 stat points in the build pool, become an Outlaw, gain Forbidden Knowledge, and receive a bounty."), \
	TAT_TRAIT_TROPHY_BOUNTY = TAT_TRAIT_ENTRY("Trophy Bounty", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "You can recieve additional bonuses when wearing a head hooks with monster heads."), \
	TAT_TRAIT_WARRIOR_EXPERT = TAT_TRAIT_ENTRY("Expert Warrior", 4, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_COMBAT_MASTERY_NAME, "Raises the combat skill cap from 3 to 4."), \
	TAT_TRAIT_WARRIOR_MASTER = TAT_TRAIT_ENTRY("Master Warrior", 5, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_COMBAT_MASTERY_NAME, "Raises the combat skill cap from 4 to 5. Requires Expert Warrior."), \
	TRAIT_DODGEEXPERT = TAT_TRAIT_ENTRY("Expert Dodger", 2, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Much better at dodging incoming strikes in light armor or with little armor. Heavy armor is too cumbersome for this style."), \
	TRAIT_PARRYEXPERT = TAT_TRAIT_ENTRY("Expert Parry", 3, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Much better at parrying incoming strikes, with a higher chance to deflect blows using a weapon."), \
	TRAIT_HEAVYARMOR = TAT_TRAIT_ENTRY("Plate Training", 4, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Can move freely in heavy armor."), \
	TRAIT_MEDIUMARMOR = TAT_TRAIT_ENTRY("Maille Training", 3, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Can move freely in medium armor."), \
	TRAIT_NOPAINSTUN = TAT_TRAIT_ENTRY("Enduring", 3, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Pain does not impair you as easily. You can endure more burns before collapsing."), \
	TRAIT_CRITICAL_RESISTANCE = TAT_TRAIT_ENTRY("Critical Resistance", 4, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Your constitution is iron-clad. You can resist the first critical wounds that would fell others, though repeated punishment will overwhelm you."), \
	TRAIT_HARDDISMEMBER = TAT_TRAIT_ENTRY("Hard Dismemberment", 2, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Your limbs are harder to dismember."), \
	TRAIT_STEELHEARTED = TAT_TRAIT_ENTRY("Steelhearted", 1, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Hardened nerves. You do not waiver from the sight of violence in battle."), \
	TRAIT_CIVILIZEDBARBARIAN = TAT_TRAIT_ENTRY("Expert Pugilist", 2, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Turns you into a living weapon: stronger unarmed strikes, broader unarmed reach, and much better parrying with bracers, knuckles, or bandages."), \
	TRAIT_FENCERDEXTERITY = TAT_TRAIT_ENTRY("Fencer's Dexterity", 2, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "I've trained my entire lyfe around the art of unarmoured fencing, affording myself unmatched speed when wearing very light armour. I'm very choosy otherwise."), \
	TAT_TRAIT_BRONZE_SUPPLIER = TAT_TRAIT_ENTRY("Bronze Supplier", 1, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks bronze-tier weapons."), \
	TAT_TRAIT_SILVER_SUPPLIER = TAT_TRAIT_ENTRY("Silver Supplier", 4, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks silver-tier weapons."), \
	TAT_TRAIT_STEEL_SUPPLIER = TAT_TRAIT_ENTRY("Steel Supplier", 2, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks steel-tier weapons."), \
	TAT_TRAIT_FIREARMS_SUPPLIER = TAT_TRAIT_ENTRY("Firearms Supplier", 3, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks blackpowder weapons and supplies."), \
	TAT_TRAIT_LEATHER_SUPPLIER = TAT_TRAIT_ENTRY("Leather Supplier", 2, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks leather gear in all supported slots."), \
	TAT_TRAIT_MAIL_SUPPLIER = TAT_TRAIT_ENTRY("Mail Supplier", 2, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks mail gear in all supported slots."), \
	TAT_TRAIT_PLATE_SUPPLIER = TAT_TRAIT_ENTRY("Plate Supplier", 3, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks plate gear in all supported slots."), \
	TRAIT_INTELLECTUAL = TAT_TRAIT_ENTRY("Intellectual", 2, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You have a keen eye and can assess a person's prowess in wit and blade."), \
	TRAIT_ARCYNE = TAT_TRAIT_ENTRY("Arcyne Training", 1, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_ENHANCEMENT_NAME, "You are trained in the Arcyne arts, allowing you to wield magyck. Basis trait for magic-build classes. Give +2 magic skill if there is no defense trait."), \
	TRAIT_JACKOFALLTRADES = TAT_TRAIT_ENTRY("Jack of All Trades", 2, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Skills cost half as much for you to raise."), \
	TAT_TRAIT_MASTER_OF_NOTHING = TAT_TRAIT_ENTRY("Master of nothing", 4, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Gives +20 to skill points, gives discont on non-combat skills, blocks with Resident."), \
	TRAIT_EMPATH = TAT_TRAIT_ENTRY("Empath", 1, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You can notice when people are in pain."), \
	TRAIT_NOSTINK = TAT_TRAIT_ENTRY("Dead Nose", 2, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Your nose is numb to the smell of decay."), \
	TRAIT_NOBLE = TAT_TRAIT_ENTRY("Noble Blooded", 1, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You are of noble blood."), \
	TRAIT_SMITHING_EXPERT = TAT_TRAIT_ENTRY("Expert Forgehand", 2, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with smithing and engineering. Smithing, Smelting, Engineering, Mining, Masonry and Pottery can progress to Legendary levels."), \
	TRAIT_ALCHEMY_EXPERT = TAT_TRAIT_ENTRY("Expert Alchemist", 2, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Deep, intricate knowledge of the alchemical arts. Alchemy can progress to Expert and above levels."), \
	TRAIT_MEDICINE_EXPERT = TAT_TRAIT_ENTRY("Expert Physicker", 2, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Deep, intricate knowledge of medicine. This skill can progress to Master and Legendary levels."), \
	TRAIT_HOMESTEAD_EXPERT = TAT_TRAIT_ENTRY("Expert Homesteader", 3, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with the arts of homesteading. Farming, Mining, Cooking, Fishing, Butchering, Lumberjacking, Masonry and Pottery can progress to Legendary levels; Sewing and Skincrafting to Journeyman. Unlock carpentry, massonry and crafting to higher levels."), \
	TRAIT_SURVIVAL_EXPERT = TAT_TRAIT_ENTRY("Expert Survivalist", 2, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with survival in the wild. Cooking, Fishing, Butchering and Skincrafting can progress to Legendary levels; Sewing to Journeyman."), \
	TRAIT_SEWING_EXPERT = TAT_TRAIT_ENTRY("Expert Clothier", 2, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with sewing and leathercraft. Sewing, Skincrafting and Butchering can progress to Legendary levels."), \
	TRAIT_SEEDKNOW = TAT_TRAIT_ENTRY("Seed Knower", 1, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You know which seeds grow which crops."), \
	TRAIT_CAUTIOUS_FISHER = TAT_TRAIT_ENTRY("Cautious Fisher", 1, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You know the dangers of fishing and how to avoid unwanted attention from the depths."), \
	TRAIT_SQUIRE_REPAIR = TAT_TRAIT_ENTRY("Squire Knowledge", 2, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You can restore gear with time and polish it until it gleams like new."), \
	TRAIT_CICERONE = TAT_TRAIT_ENTRY("Cicerone", 1, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "You are well-versed in brews and spirits, and can tell them apart at a glance."), \
	TRAIT_SEEPRICES = TAT_TRAIT_ENTRY("Appraiser", 1, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "You can tell the prices of things down to the zenny."), \
	TRAIT_OUTLANDER = TAT_TRAIT_ENTRY("Outlander", -2, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "The locals see you as not of their land."), \
	TRAIT_GRAVEROBBER = TAT_TRAIT_ENTRY("Experienced Grave Robber", 2, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "Your experience with 'post-mortem artifact recovery' helps you resist Necra's curse placed on those who disturb resting places."), \
	TRAIT_PURITAN_ADVENTURER = TAT_TRAIT_ENTRY("Interrogator", 2, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "With a silver psycross, you can force the restrained to kneel before a crucifix and proclaim their true allegiance."), \
	TRAIT_DECEIVING_MEEKNESS = TAT_TRAIT_ENTRY("Deceiving Meekness", 2, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "People think you are weak. They are mistaken. You have learned to hide your vices and true beliefs from others."), \
	TRAIT_NASTY_EATER = TAT_TRAIT_ENTRY("Inhumen Digestion", 2, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You can eat bad food, and water toxic to humen does not affect you."), \
	TRAIT_GOODLOVER = TAT_TRAIT_ENTRY("Fabled Lover", 2, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "It is a lucky thing to share your bed."), \
	TRAIT_NUTCRACKER = TAT_TRAIT_ENTRY("Nutcracker", 1, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You love kicking idiots in the nuts."), \
	TAT_TRAIT_DIVINE_INITIATE = TAT_TRAIT_ENTRY("Divine Initiate", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants miracles and devotion. Additional divine boon traits increase miracle access."), \
	TAT_TRAIT_DIVINE_BOON_1 = TAT_TRAIT_ENTRY("Divine Boon I", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Divine Initiate. Raises your miracle package by one tier."), \
	TAT_TRAIT_DIVINE_BOON_2 = TAT_TRAIT_ENTRY("Divine Boon II", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Divine Initiate and Divine Boon I. Raises your miracle package by one tier."), \
	TAT_TRAIT_DIVINE_BOON_3 = TAT_TRAIT_ENTRY("Divine Boon III", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Divine Initiate and Divine Boon II. Raises your miracle package by one tier."), \
	TAT_TRAIT_MAGE_INITIATE = TAT_TRAIT_ENTRY("Mage Initiate", 3, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants one minor spells, three utility spells, plus one extra utility per Arcane skill level."), \
	TAT_TRAIT_MAGE_MAJOR_SLOT = TAT_TRAIT_ENTRY("Arcane Major Slot", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Mage Initiate. Grants +1 major spell slot."), \
	TAT_TRAIT_MAGE_MINOR_SLOT_1 = TAT_TRAIT_ENTRY("Arcane Minor Slot I", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Mage Initiate. Grants +1 minor spell slot."), \
	TAT_TRAIT_MAGE_MINOR_SLOT_2 = TAT_TRAIT_ENTRY("Arcane Minor Slot II", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Mage Initiate. Grants +1 minor spell slot."), \
	TAT_TRAIT_MAGE_UTILITY_SLOT = TAT_TRAIT_ENTRY("Arcane Utility Slot", 1, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Requires Mage Initiate. Grants +1 utility spell slot."), \
	TAT_TRAIT_DRUID_INITIATE = TAT_TRAIT_ENTRY("Druid Initiate", 6, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants Dendor's druidic rites, direct druid spells, and wise tree alert."), \
	TAT_TRAIT_WITCH_INITIATE = TAT_TRAIT_ENTRY("Witch Initiate", 3, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants witch trait and ability to shapeshift yourself into different small creatures."), \
	TRAIT_EXPLOSIVE_SUPPLY = TAT_TRAIT_ENTRY("Explosive Supply", 2, TAT_CATEGORY_UTILITY, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants explosives gifts from your friends. Luck scaled."), \
	TAT_TRAIT_ARTIFACTS_SUPPLIER = TAT_TRAIT_ENTRY("Artifacts Bearer", 6, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "You're one of the adventurers with stories about your raids. Now, you have one of the deadlist weapons in Grimmoria. REQUIRES: Party Leader"), \
	TRAIT_FIREARMS_MARKSMAN = TAT_TRAIT_ENTRY("Firearms Training", 3, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_COMBAT_MASTERY_NAME, "Raises the combat Firearms cap from 3 to 4."), \
	TAT_TRAIT_TRAINEE_SMITH = TAT_TRAIT_ENTRY("Trainee Smith", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Blacksmithing, Smelting, and the first two levels of Maces by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_ARMORER = TAT_TRAIT_ENTRY("Trainee Armorer", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Armorsmithing, Masonry, and the first two levels of Shields by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_WEAPONSMITH = TAT_TRAIT_ENTRY("Trainee Weaponsmith", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Weaponsmithing, Engineering, and the first two levels of Swords by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_WOODSMAN = TAT_TRAIT_ENTRY("Trainee Woodsman", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Lumberjacking, Carpentry, and the first two levels of Axes by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_SURVIVALIST = TAT_TRAIT_ENTRY("Trainee Survivalist", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Butchering, Hunting, and the first two levels of Archery by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_POACHER = TAT_TRAIT_ENTRY("Trainee Poacher", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Tracking, Trapmaking, and the first two levels of Crossbows by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_SKULKER = TAT_TRAIT_ENTRY("Trainee Skulker", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Sneaking, Lockpicking, and the first two levels of Knives by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_VAGABOND = TAT_TRAIT_ENTRY("Trainee Vagabond", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Pickpocketing, Climbing, and the first two levels of Slings by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_RIDER = TAT_TRAIT_ENTRY("Trainee Rider", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Riding, Athletics, and the first two levels of Polearms by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_MARINER = TAT_TRAIT_ENTRY("Trainee Mariner", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Swimming, Fishing, and the first two levels of Staves by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_CLOTHIER = TAT_TRAIT_ENTRY("Trainee Clothier", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Sewing, Skincrafting, and the first two levels of Whips & Flails by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_HOMESTEADER = TAT_TRAIT_ENTRY("Trainee Homesteader", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Farming, Cooking, and the first two levels of Wrestling by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_ARTISAN = TAT_TRAIT_ENTRY("Trainee Artisan", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Crafting, Pottery, and the first two levels of Unarmed by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_CHIRURGEON = TAT_TRAIT_ENTRY("Trainee Chirurgeon", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Medicine, Literacy, and the first two levels of Staves by 1. Does not stack with Resident or other discount traits on the same skill."), \
	TAT_TRAIT_TRAINEE_TROUBADOUR = TAT_TRAIT_ENTRY("Trainee Troubadour", 1, TAT_CATEGORY_SKILL_DISCOUNT, TAT_CATEGORY_SKILL_DISCOUNT_NAME, "Reduces the cost of Music, Literacy, and the first two levels of Knives by 1. Does not stack with Resident or other discount traits on the same skill."), \

