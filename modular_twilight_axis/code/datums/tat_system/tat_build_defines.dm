#define TAT_TRAIT_SOURCE "tat_build"

#define TAT_SKILL_COMBAT_CAP_DEFAULT 3
#define TAT_SKILL_COMBAT_CAP_TRAIT_1 4
#define TAT_SKILL_COMBAT_CAP_TRAIT_2 5
#define TAT_SKILL_NONCOMBAT_CAP 5

#define TAT_TRAIT_WARRIOR_EXPERT "tat_warrior_expert"
#define TAT_TRAIT_WARRIOR_MASTER "tat_warrior_master"
#define TAT_TRAIT_SOUNDBREAKER "tat_soundbreaker"
#define TAT_TRAIT_RONIN "tat_ronin"
#define TAT_TRAIT_RESIDENT "tat_resident"

#define TAT_TRAIT_STEEL_SUPPLIER "tat_steel_supplier"
#define TAT_TRAIT_SILVER_SUPPLIER "tat_silver_supplier"
#define TAT_TRAIT_BRONZE_SUPPLIER "tat_bronze_supplier"
#define TAT_TRAIT_LEATHER_SUPPLIER "tat_leather_supplier"
#define TAT_TRAIT_MAIL_SUPPLIER "tat_mail_supplier"
#define TAT_TRAIT_FIREARMS_SUPPLIER "tat_firearms_supplier"
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

#define TAT_BUILD_STAT_BONUS_EXTRA_STATS 3
#define TAT_BUILD_STAT_BONUS_WANTED 5

#define TAT_PARTY_LEADER_MIN_MEMBERS 2
#define TAT_PARTY_LEADER_BONUS_CON 1
#define TAT_PARTY_LEADER_BONUS_WIL 1
#define TAT_PARTY_LEADER_INVITE_RANGE 7
#define TAT_PARTY_LEADER_VERB_CATEGORY "Leadership"

#define TAT_ITEM_CATEGORY_WEAPON "weapon"
#define TAT_ITEM_CATEGORY_CLOTHING "clothing"

#define TAT_UNLOCK_TYPE_WEAPON_SUPPLY "weapon_supply"
#define TAT_UNLOCK_TYPE_ARMOR_FAMILY "armor_family"

#define TAT_SUPPLY_IRON "iron"
#define TAT_SUPPLY_BRONZE "bronze"
#define TAT_SUPPLY_SILVER "silver"
#define TAT_SUPPLY_STEEL "steel"
#define TAT_SUPPLY_FIREARMS "firearms"

#define TAT_ARMOR_CLOTH "cloth"
#define TAT_ARMOR_LEATHER "leather"
#define TAT_ARMOR_MAIL "mail"
#define TAT_ARMOR_PLATE "plate"

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

#define TAT_STAT_ENTRY(_name, _cost, _base, _min, _max) list("name" = (_name), "cost" = (_cost), "base" = (_base), "min" = (_min), "max" = (_max))
#define TAT_TRAIT_ENTRY(_name, _cost, _category, _category_name, _desc) list("name" = (_name), "cost" = (_cost), "category" = (_category), "category_name" = (_category_name), "desc" = (_desc))
#define TAT_ITEM_ENTRY(_name, _cost, _category, _unlock_type, _unlock_key, _slot_group) list("name" = (_name), "cost" = (_cost), "category" = (_category), "unlock_type" = (_unlock_type), "unlock_key" = (_unlock_key), "slot_group" = (_slot_group))

#define TAT_AVAILABLE_STATS_LIST \
	STATKEY_STR = TAT_STAT_ENTRY("Strength", 2, 10, 1, 20), \
	STATKEY_PER = TAT_STAT_ENTRY("Perception", 1, 10, 1, 20), \
	STATKEY_INT = TAT_STAT_ENTRY("Intelligence", 1, 10, 1, 20), \
	STATKEY_CON = TAT_STAT_ENTRY("Constitution", 1, 10, 1, 20), \
	STATKEY_WIL = TAT_STAT_ENTRY("Willpower", 1, 10, 1, 20), \
	STATKEY_SPD = TAT_STAT_ENTRY("Speed", 2, 10, 1, 20), \
	STATKEY_LCK = TAT_STAT_ENTRY("Fortune", 0.5, 10, 1, 20)

#define TAT_STATS_ORDER_LIST list( \
	STATKEY_STR, \
	STATKEY_PER, \
	STATKEY_INT, \
	STATKEY_CON, \
	STATKEY_WIL, \
	STATKEY_SPD, \
	STATKEY_LCK \
)

#define TAT_AVAILABLE_TRAITS_LIST \
	TAT_TRAIT_SOUNDBREAKER = TAT_TRAIT_ENTRY("Soundbreaker", 4, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Unlocks the Soundbreaker combo style."), \
	TAT_TRAIT_RONIN = TAT_TRAIT_ENTRY("Ronin", 4, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Unlocks the Ronin combo style."), \
	TAT_TRAIT_SPELLBLADE = TAT_TRAIT_ENTRY("Spellblade", 4, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants Arcyne Training and a set of weapon-binding spells."), \
	TAT_TRAIT_RESIDENT = TAT_TRAIT_ENTRY("Resident", 3, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants a Meister account and ownership of a house in the city."), \
	TAT_TRAIT_BARDIC_INSPIRATION_T1 = TAT_TRAIT_ENTRY("Bardic Inspiration I", 2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gain tier 1 bardic inspiration, audience management verbs, and a songbook."), \
	TAT_TRAIT_BARDIC_INSPIRATION_T2 = TAT_TRAIT_ENTRY("Bardic Inspiration II", 4, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Upgrades bardic inspiration to tier 2, increasing audience size and songs known."), \
	TAT_TRAIT_PARTY_LEADER = TAT_TRAIT_ENTRY("Party Leader", 3, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Can form a party through Leadership verbs. While the party has at least two willing members, gain +1 CON and +1 WIL."), \
	TAT_TRAIT_BONUS_STAT_POOL = TAT_TRAIT_ENTRY("Natural Potential", 3, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gain +3 stat points in the build pool."), \
	TAT_TRAIT_WANTED = TAT_TRAIT_ENTRY("Wanted", -2, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Gain +5 stat points in the build pool, become an Outlaw, gain Forbidden Knowledge, and receive a bounty."), \
	TAT_TRAIT_WARRIOR_EXPERT = TAT_TRAIT_ENTRY("Expert Warrior", 3, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_COMBAT_MASTERY_NAME, "Raises the combat skill cap from 3 to 4."), \
	TAT_TRAIT_WARRIOR_MASTER = TAT_TRAIT_ENTRY("Master Warrior", 5, TAT_CATEGORY_COMBAT_MASTERY, TAT_CATEGORY_COMBAT_MASTERY_NAME, "Raises the combat skill cap from 4 to 5. Requires Expert Warrior."), \
	TRAIT_DODGEEXPERT = TAT_TRAIT_ENTRY("Expert Dodger", 2, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Much better at dodging incoming strikes in light armor or with little armor. Heavy armor is too cumbersome for this style."), \
	TRAIT_PARRYEXPERT = TAT_TRAIT_ENTRY("Expert Parry", 3, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Much better at parrying incoming strikes, with a higher chance to deflect blows using a weapon."), \
	TRAIT_HEAVYARMOR = TAT_TRAIT_ENTRY("Plate Training", 3, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Can move freely in heavy armor."), \
	TRAIT_MEDIUMARMOR = TAT_TRAIT_ENTRY("Maille Training", 2, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Can move freely in medium armor."), \
	TRAIT_NOPAINSTUN = TAT_TRAIT_ENTRY("Enduring", 3, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Pain does not impair you as easily. You can endure more burns before collapsing."), \
	TRAIT_CRITICAL_RESISTANCE = TAT_TRAIT_ENTRY("Critical Resistance", 4, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Your constitution is iron-clad. You can resist the first critical wounds that would fell others, though repeated punishment will overwhelm you."), \
	TRAIT_HARDDISMEMBER = TAT_TRAIT_ENTRY("Hard Dismemberment", 2, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Your limbs are harder to dismember."), \
	TRAIT_STEELHEARTED = TAT_TRAIT_ENTRY("Steelhearted", 2, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Hardened nerves. You do not waiver from the sight of violence in battle."), \
	TRAIT_CIVILIZEDBARBARIAN = TAT_TRAIT_ENTRY("Expert Pugilist", 3, TAT_CATEGORY_DEFENSE, TAT_CATEGORY_DEFENSE_NAME, "Turns you into a living weapon: stronger unarmed strikes, broader unarmed reach, and much better parrying with bracers, knuckles, or bandages."), \
	TAT_TRAIT_BRONZE_SUPPLIER = TAT_TRAIT_ENTRY("Bronze Supplier", 2, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks bronze-tier weapons."), \
	TAT_TRAIT_SILVER_SUPPLIER = TAT_TRAIT_ENTRY("Silver Supplier", 4, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks silver-tier weapons."), \
	TAT_TRAIT_STEEL_SUPPLIER = TAT_TRAIT_ENTRY("Steel Supplier", 3, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks steel-tier weapons."), \
	TAT_TRAIT_FIREARMS_SUPPLIER = TAT_TRAIT_ENTRY("Firearms Supplier", 3, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks blackpowder weapons and supplies."), \
	TAT_TRAIT_LEATHER_SUPPLIER = TAT_TRAIT_ENTRY("Leather Supplier", 2, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks leather gear in all supported slots."), \
	TAT_TRAIT_MAIL_SUPPLIER = TAT_TRAIT_ENTRY("Mail Supplier", 2, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks mail gear in all supported slots."), \
	TAT_TRAIT_PLATE_SUPPLIER = TAT_TRAIT_ENTRY("Plate Supplier", 3, TAT_CATEGORY_SUPPLY, TAT_CATEGORY_SUPPLY_NAME, "Unlocks plate gear in all supported slots."), \
	TRAIT_DEATHSIGHT = TAT_TRAIT_ENTRY("Veiled Whispers", 2, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You can feel when someone nearby draws the Undermaiden's attention."), \
	TRAIT_INTELLECTUAL = TAT_TRAIT_ENTRY("Intellectual", 2, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You have a keen eye and can assess a person's prowess in wit and blade."), \
	TRAIT_ARCYNE = TAT_TRAIT_ENTRY("Arcyne Training", 2, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You are trained in the Arcyne arts, allowing you to wield magyck."), \
	TRAIT_JACKOFALLTRADES = TAT_TRAIT_ENTRY("Jack of All Trades", 4, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Skills cost half as much for you to raise."), \
	TRAIT_EMPATH = TAT_TRAIT_ENTRY("Empath", 2, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You can notice when people are in pain."), \
	TRAIT_NOSTINK = TAT_TRAIT_ENTRY("Dead Nose", 2, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "Your nose is numb to the smell of decay."), \
	TRAIT_NOBLE = TAT_TRAIT_ENTRY("Noble Blooded", 2, TAT_CATEGORY_ENHANCEMENT, TAT_CATEGORY_ENHANCEMENT_NAME, "You are of noble blood."), \
	TRAIT_TRAINED_SMITH = TAT_TRAIT_ENTRY("Trained Smith", 2, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You have long trained in smithing and, with more practice, can reach legendary craftsmanship."), \
	TRAIT_SMITHING_EXPERT = TAT_TRAIT_ENTRY("Expert Forgehand", 3, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with smithing and engineering. Smithing, Smelting, Engineering, Mining, Masonry and Pottery can progress to Legendary levels."), \
	TRAIT_ALCHEMY_EXPERT = TAT_TRAIT_ENTRY("Expert Alchemist", 3, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Deep, intricate knowledge of the alchemical arts. Alchemy can progress to Expert and above levels."), \
	TRAIT_MEDICINE_EXPERT = TAT_TRAIT_ENTRY("Expert Physicker", 3, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Deep, intricate knowledge of medicine. This skill can progress to Master and Legendary levels."), \
	TRAIT_HOMESTEAD_EXPERT = TAT_TRAIT_ENTRY("Expert Homesteader", 3, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with the arts of homesteading. Farming, Mining, Cooking, Fishing, Butchering, Lumberjacking, Masonry and Pottery can progress to Legendary levels; Sewing and Skincrafting to Journeyman."), \
	TRAIT_SURVIVAL_EXPERT = TAT_TRAIT_ENTRY("Expert Survivalist", 3, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with survival in the wild. Cooking, Fishing, Butchering and Skincrafting can progress to Legendary levels; Sewing to Journeyman."), \
	TRAIT_SEWING_EXPERT = TAT_TRAIT_ENTRY("Expert Clothier", 3, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "Experienced with sewing and leathercraft. Sewing, Skincrafting and Butchering can progress to Legendary levels."), \
	TRAIT_SEEDKNOW = TAT_TRAIT_ENTRY("Seed Knower", 1, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You know which seeds grow which crops."), \
	TRAIT_CAUTIOUS_FISHER = TAT_TRAIT_ENTRY("Cautious Fisher", 1, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You know the dangers of fishing and how to avoid unwanted attention from the depths."), \
	TRAIT_SQUIRE_REPAIR = TAT_TRAIT_ENTRY("Squire Knowledge", 1, TAT_CATEGORY_CRAFT, TAT_CATEGORY_CRAFT_NAME, "You can restore gear with time and polish it until it gleams like new."), \
	TRAIT_CICERONE = TAT_TRAIT_ENTRY("Cicerone", 1, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "You are well-versed in brews and spirits, and can tell them apart at a glance."), \
	TRAIT_SEEPRICES = TAT_TRAIT_ENTRY("Appraiser", 1, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "You can tell the prices of things down to the zenny."), \
	TRAIT_OUTLANDER = TAT_TRAIT_ENTRY("Outlander", -2, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "The locals see you as not of their land."), \
	TRAIT_GRAVEROBBER = TAT_TRAIT_ENTRY("Experienced Grave Robber", 2, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "Your experience with 'post-mortem artifact recovery' helps you resist Necra's curse placed on those who disturb resting places."), \
	TRAIT_PURITAN_ADVENTURER = TAT_TRAIT_ENTRY("Interrogator", 2, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "With a silver psycross, you can force the restrained to kneel before a crucifix and proclaim their true allegiance."), \
	TRAIT_DECEIVING_MEEKNESS = TAT_TRAIT_ENTRY("Deceiving Meekness", 2, TAT_CATEGORY_UTILITY, TAT_CATEGORY_UTILITY_NAME, "People think you are weak. They are mistaken. You have learned to hide your vices and true beliefs from others."), \
	TRAIT_WITCH = TAT_TRAIT_ENTRY("Witch Presence", 3, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "They fear you, but still find you useful."), \
	TRAIT_NASTY_EATER = TAT_TRAIT_ENTRY("Inhumen Digestion", 2, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You can eat bad food, and water toxic to humen does not affect you."), \
	TRAIT_GOODLOVER = TAT_TRAIT_ENTRY("Fabled Lover", 2, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "It is a lucky thing to share your bed."), \
	TRAIT_NUTCRACKER = TAT_TRAIT_ENTRY("Nutcracker", 2, TAT_CATEGORY_ODDITY, TAT_CATEGORY_ODDITY_NAME, "You love kicking idiots in the nuts."), \
	TAT_TRAIT_DIVINE_INITIATE = TAT_TRAIT_ENTRY("Divine Initiate", 3, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants miracles and devotion. Configure the miracle tier in the build UI."), \
	TAT_TRAIT_MAGE_INITIATE = TAT_TRAIT_ENTRY("Mage Initiate", 3, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants Arcyne training, mage aspect setup, and a spellbook."), \
	TAT_TRAIT_DRUID_INITIATE = TAT_TRAIT_ENTRY("Druid Initiate", 4, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Grants Dendor's druidic rites, direct druid spells, and wise tree alert."), \
	TAT_TRAIT_WITCH_INITIATE = TAT_TRAIT_ENTRY("Witch Initiate", 4, TAT_CATEGORY_CLASS_MODULE, TAT_CATEGORY_CLASS_MODULE_NAME, "Choose one witch path: Old Magick, Godsblood, or Mystagogue."), \

#define TAT_AVAILABLE_ITEMS_LIST \
	/obj/item/gun/ballistic/twilight_firearm/hunt_arquebus = TAT_ITEM_ENTRY("Hunter's Arquebus", 3, "weapon", "weapon_supply", TAT_SUPPLY_FIREARMS, "blackpowder"), \
	/obj/item/gun/ballistic/twilight_firearm/barker = TAT_ITEM_ENTRY("Barker", 2, "weapon", "weapon_supply", TAT_SUPPLY_FIREARMS, "blackpowder"), \
	/obj/item/gun/ballistic/twilight_firearm/arquebus_pistol/mortar = TAT_ITEM_ENTRY("Hand Mortar", 5, "weapon", "weapon_supply", TAT_SUPPLY_FIREARMS, "blackpowder"), \
	/obj/item/twilight_powderflask = TAT_ITEM_ENTRY("Blackpowder Flask", 1, "weapon", "weapon_supply", TAT_SUPPLY_FIREARMS, "blackpowder"), \
	/obj/item/twilight_powderflask/fyre = TAT_ITEM_ENTRY("Fyrepowder Flask", 3, "weapon", "weapon_supply", TAT_SUPPLY_FIREARMS, "blackpowder"), \
	/obj/item/twilight_powderflask/terror= TAT_ITEM_ENTRY("Terrorpowder Flask", 2, "weapon", "weapon_supply", TAT_SUPPLY_FIREARMS, "blackpowder"), \
	/obj/item/quiver/twilight_bullet/lead = TAT_ITEM_ENTRY("30 Lead Bullets", 2, "weapon", "weapon_supply", TAT_SUPPLY_FIREARMS, "blackpowder"), \
	/obj/item/quiver/twilight_bullet/lead_ten = TAT_ITEM_ENTRY("10 Lead Bullets", 1, "weapon", "weapon_supply", TAT_SUPPLY_FIREARMS, "blackpowder"), \
	/obj/item/quiver/twilight_bullet/cannonball/grapeshot = TAT_ITEM_ENTRY("20 Lead Grapeshots", 3, "weapon", "weapon_supply", TAT_SUPPLY_FIREARMS, "blackpowder"), \
	/obj/item/clothing/neck/roguetown/psicross/silver = TAT_ITEM_ENTRY("Silver Psycross", 3, "clothing", "armor_family", TAT_SUPPLY_SILVER, "wrists"),\
	/obj/item/clothing/neck/roguetown/psicross/silver/astrata = TAT_ITEM_ENTRY("Silver Astrata Cross", 3, "clothing", "armor_family", TAT_SUPPLY_SILVER, "wrists"),\
	/obj/item/clothing/neck/roguetown/psicross/silver/undivided = TAT_ITEM_ENTRY("Silver Tennite cross", 3, "clothing", "armor_family", TAT_SUPPLY_SILVER, "wrists"),\
	/obj/item/clothing/neck/roguetown/psicross/silver/necra = TAT_ITEM_ENTRY("Silver Necra Cross", 3, "clothing", "armor_family", TAT_SUPPLY_SILVER, "wrists"),\
	/obj/item/clothing/neck/roguetown/psicross/silver/noc = TAT_ITEM_ENTRY("Silver Noc Cross", 3, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "munition"), \
	/obj/item/quiver/twilight_bullet/silver = TAT_ITEM_ENTRY("10 Silver Bullets", 3, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "munition"), \
	/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = TAT_ITEM_ENTRY("Crossbow", 3, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "ranged"), \
	/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = TAT_ITEM_ENTRY("Recurve Bow", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "ranged"), \
	/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow = TAT_ITEM_ENTRY("Long Bow", 3, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "ranged"), \
	/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow = TAT_ITEM_ENTRY("Slurbow", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "ranged"), \
	/obj/item/quiver/arrows = TAT_ITEM_ENTRY("Broadhead Arrows", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "munition"), \
	/obj/item/quiver/bodkin = TAT_ITEM_ENTRY("Bodkin arrows", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "munition"), \
	/obj/item/quiver/bolt/standard = TAT_ITEM_ENTRY("Bolts", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "munition"), \
	/obj/item/quiver/bolt/pyro = TAT_ITEM_ENTRY("Pyro Bolts", 3, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "munition"), \
	/obj/item/quiver/bolt/water = TAT_ITEM_ENTRY("Water Bolts", 1, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "munition"), \
	/obj/item/quiver/bolt/light = TAT_ITEM_ENTRY("Light Bolts", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "munition"), \
	/obj/item/quiver/silver = TAT_ITEM_ENTRY("Silver Arrows", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "munition"), \
	/obj/item/quiver/bolt/silver = TAT_ITEM_ENTRY("Silver Bolts", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "munition"), \
	/obj/item/rogueweapon/eaglebeak = TAT_ITEM_ENTRY("Eagle's Beak", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/eaglebeak/lucerne = TAT_ITEM_ENTRY("Lucerne", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/shovel/silver/preblessed = TAT_ITEM_ENTRY("Silver Shovel", 3, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "polearm"), \
	/obj/item/rogueweapon/greataxe = TAT_ITEM_ENTRY("Greataxe", 3, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "axe"), \
	/obj/item/rogueweapon/greataxe/bronze = TAT_ITEM_ENTRY("Bronze Greataxe", 3, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "axe"), \
	/obj/item/rogueweapon/greataxe/silver = TAT_ITEM_ENTRY("Silver Poleaxe", 5, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "axe"), \
	/obj/item/rogueweapon/greataxe/steel = TAT_ITEM_ENTRY("Steel Greataxe", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "axe"), \
	/obj/item/rogueweapon/woodstaff/quarterstaff/silver = TAT_ITEM_ENTRY("Silver Staff", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "polearm"), \
	/obj/item/rogueweapon/greataxe/steel/doublehead = TAT_ITEM_ENTRY("Double-Headed Greataxe", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "axe"), \
	/obj/item/rogueweapon/greatsword = TAT_ITEM_ENTRY("Greatsword", 4, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "greatsword"), \
	/obj/item/rogueweapon/greatsword/grenz = TAT_ITEM_ENTRY("Steel Zweihander", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "greatsword"), \
	/obj/item/rogueweapon/greatsword/grenz/flamberge = TAT_ITEM_ENTRY("Flamberge", 5, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "greatsword"), \
	/obj/item/rogueweapon/greatsword/iron = TAT_ITEM_ENTRY("Iron Greatsword", 4, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "greatsword"), \
	/obj/item/rogueweapon/greatsword/silver = TAT_ITEM_ENTRY("Silver Greatsword", 5, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "greatsword"), \
	/obj/item/rogueweapon/greatsword/zwei = TAT_ITEM_ENTRY("Claymore", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "greatsword"), \
	/obj/item/rogueweapon/halberd = TAT_ITEM_ENTRY("Halberd", 5, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "polearm"), \
	/obj/item/rogueweapon/halberd/bardiche = TAT_ITEM_ENTRY("Bardiche", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/halberd/bardiche/scythe = TAT_ITEM_ENTRY("War Scythe", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/halberd/glaive = TAT_ITEM_ENTRY("Glaive", 5, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/huntingknife = TAT_ITEM_ENTRY("Hunting Knife", 1, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "knife"), \
	/obj/item/rogueweapon/huntingknife/bronze = TAT_ITEM_ENTRY("Bronze Knife", 1, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "knife"), \
	/obj/item/rogueweapon/huntingknife/chefknife = TAT_ITEM_ENTRY("Chef's Knife", 1, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "knife"), \
	/obj/item/rogueweapon/huntingknife/chefknife/cleaver = TAT_ITEM_ENTRY("Cleaver", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "knife"), \
	/obj/item/rogueweapon/huntingknife/combat/bronze = TAT_ITEM_ENTRY("Sydearmme", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "knife"), \
	/obj/item/rogueweapon/huntingknife/combat/iron = TAT_ITEM_ENTRY("Bauernwehr", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "knife"), \
	/obj/item/rogueweapon/huntingknife/idagger = TAT_ITEM_ENTRY("Iron Dagger", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "knife"), \
	/obj/item/rogueweapon/huntingknife/idagger/navaja = TAT_ITEM_ENTRY("Navaja", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "knife"), \
	/obj/item/rogueweapon/huntingknife/idagger/silver = TAT_ITEM_ENTRY("Silver Dagger", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "knife"), \
	/obj/item/rogueweapon/huntingknife/idagger/steel = TAT_ITEM_ENTRY("Steel Dagger", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "knife"), \
	/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = TAT_ITEM_ENTRY("Parrying Dagger", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "knife"), \
	/obj/item/rogueweapon/huntingknife/scissors = TAT_ITEM_ENTRY("Scissors", 1, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "knife"), \
	/obj/item/rogueweapon/huntingknife/scissors/steel = TAT_ITEM_ENTRY("Steel Scissors", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "knife"), \
	/obj/item/rogueweapon/katar = TAT_ITEM_ENTRY("Katar", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "knife"), \
	/obj/item/rogueweapon/katar/bronze = TAT_ITEM_ENTRY("Bronze Katar", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "knife"), \
	/obj/item/rogueweapon/katar/bronze/gladiator = TAT_ITEM_ENTRY("Bronze Gladiator Katar", 3, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "knife"), \
	/obj/item/rogueweapon/katar/punchdagger = TAT_ITEM_ENTRY("Punch Dagger", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "knife"), \
	/obj/item/rogueweapon/katar/silver = TAT_ITEM_ENTRY("Silver Katar", 3, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "knife"), \
	/obj/item/rogueweapon/mace = TAT_ITEM_ENTRY("Mace", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "blunt"), \
	/obj/item/rogueweapon/mace/bronze = TAT_ITEM_ENTRY("Bronze Mace", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "blunt"), \
	/obj/item/rogueweapon/mace/cudgel/flanged = TAT_ITEM_ENTRY("Flanged Mace", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "blunt"), \
	/obj/item/rogueweapon/mace/cudgel/flanged/silver = TAT_ITEM_ENTRY("Silver Flanged Mace", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "blunt"), \
	/obj/item/rogueweapon/mace/maul/grand = TAT_ITEM_ENTRY("Grand Maul", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "blunt"), \
	/obj/item/rogueweapon/mace/spiked = TAT_ITEM_ENTRY("Spiked Mace", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "blunt"), \
	/obj/item/rogueweapon/mace/steel = TAT_ITEM_ENTRY("Steel Mace", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "blunt"), \
	/obj/item/rogueweapon/mace/steel/morningstar = TAT_ITEM_ENTRY("Morningstar", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "blunt"), \
	/obj/item/rogueweapon/mace/steel/silver = TAT_ITEM_ENTRY("Silver Mace", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "blunt"), \
	/obj/item/rogueweapon/mace/warhammer = TAT_ITEM_ENTRY("Warhammer", 3, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "blunt"), \
	/obj/item/rogueweapon/mace/warhammer/bronze = TAT_ITEM_ENTRY("Bronze Warhammer", 3, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "blunt"), \
	/obj/item/rogueweapon/mace/warhammer/steel = TAT_ITEM_ENTRY("Steel Warhammer", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "blunt"), \
	/obj/item/rogueweapon/mace/warhammer/steel/silver = TAT_ITEM_ENTRY("Silver Warhammer", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "blunt"), \
	/obj/item/rogueweapon/flail = TAT_ITEM_ENTRY("Flail", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "blunt"), \
	/obj/item/rogueweapon/flail/alt = TAT_ITEM_ENTRY("Flail, Studded", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "blunt"), \
	/obj/item/rogueweapon/flail/bronze = TAT_ITEM_ENTRY("Bronze Flail", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "blunt"), \
	/obj/item/rogueweapon/flail/peasantwarflail = TAT_ITEM_ENTRY("Peasant War Flail", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "blunt"), \
	/obj/item/rogueweapon/flail/peasantwarflail/iron = TAT_ITEM_ENTRY("Iron Peasant War Flail", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "blunt"), \
	/obj/item/rogueweapon/flail/sflail = TAT_ITEM_ENTRY("Steel Flail", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "blunt"), \
	/obj/item/rogueweapon/flail/sflail/silver = TAT_ITEM_ENTRY("Silver Morningstar", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "blunt"), \
	/obj/item/rogueweapon/spear = TAT_ITEM_ENTRY("Spear", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "polearm"), \
	/obj/item/rogueweapon/spear/assegai = TAT_ITEM_ENTRY("Assegai", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/spear/assegai/iron = TAT_ITEM_ENTRY("Iron Assegai", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "polearm"), \
	/obj/item/rogueweapon/spear/boar = TAT_ITEM_ENTRY("Boar Spear", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/spear/bronze = TAT_ITEM_ENTRY("Bronze Spear", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "polearm"), \
	/obj/item/rogueweapon/spear/bronze/strapless = TAT_ITEM_ENTRY("Bronze Strapless Spear", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "polearm"), \
	/obj/item/rogueweapon/spear/bronze/winged = TAT_ITEM_ENTRY("Bronze Winged Spear", 3, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "polearm"), \
	/obj/item/rogueweapon/spear/bronze/winged/strapless = TAT_ITEM_ENTRY("Bronze Winged Strapless Spear", 3, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "polearm"), \
	/obj/item/rogueweapon/spear/naginata = TAT_ITEM_ENTRY("Naginata", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/spear/partizan = TAT_ITEM_ENTRY("Partizan", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/spear/short = TAT_ITEM_ENTRY("Short Spear", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/spear/silver = TAT_ITEM_ENTRY("Silver Spear", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "polearm"), \
	/obj/item/rogueweapon/spear/trident = TAT_ITEM_ENTRY("Trident", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "polearm"), \
	/obj/item/rogueweapon/stoneaxe/battle = TAT_ITEM_ENTRY("Battle Axe", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "axe"), \
	/obj/item/rogueweapon/stoneaxe/woodcut = TAT_ITEM_ENTRY("Woodcutter Axe", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "axe"), \
	/obj/item/rogueweapon/stoneaxe/woodcut/bronze = TAT_ITEM_ENTRY("Bronze Axe", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "axe"), \
	/obj/item/rogueweapon/stoneaxe/woodcut/bronzebattleaxe = TAT_ITEM_ENTRY("Bronze Battle Axe", 3, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "axe"), \
	/obj/item/rogueweapon/stoneaxe/woodcut/pick = TAT_ITEM_ENTRY("Pick Axe", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "axe"), \
	/obj/item/rogueweapon/stoneaxe/woodcut/silver = TAT_ITEM_ENTRY("Silver War Axe", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "axe"), \
	/obj/item/rogueweapon/stoneaxe/woodcut/steel = TAT_ITEM_ENTRY("Steel Axe", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "axe"), \
	/obj/item/rogueweapon/sword = TAT_ITEM_ENTRY("Iron Arming Sword", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "sword"), \
	/obj/item/rogueweapon/sword/bronze = TAT_ITEM_ENTRY("Bronze Arming Sword", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "sword"), \
	/obj/item/rogueweapon/sword/cutlass = TAT_ITEM_ENTRY("Cutlass", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/falx = TAT_ITEM_ENTRY("Falx", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/iron = TAT_ITEM_ENTRY("Iron Arming Sword", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "sword"), \
	/obj/item/rogueweapon/sword/long = TAT_ITEM_ENTRY("Longsword", 3, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "sword"), \
	/obj/item/rogueweapon/sword/long/broadsword = TAT_ITEM_ENTRY("Broadsword", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/long/broadsword/bronze = TAT_ITEM_ENTRY("Bronze Broadsword", 3, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "sword"), \
	/obj/item/rogueweapon/sword/long/broadsword/steel = TAT_ITEM_ENTRY("Steel Broadsword", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/long/exe = TAT_ITEM_ENTRY("Executioner Sword", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/long/exe/silver = TAT_ITEM_ENTRY("Silver Executioner Sword", 5, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "sword"), \
	/obj/item/rogueweapon/sword/long/greatkhopesh = TAT_ITEM_ENTRY("Great Khopesh", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/long/kriegmesser = TAT_ITEM_ENTRY("Kriegmesser", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/long/kriegmesser/silver = TAT_ITEM_ENTRY("Silver Broadsword", 5, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "sword"), \
	/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo = TAT_ITEM_ENTRY("Ssangsudo", 4, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/long/silver = TAT_ITEM_ENTRY("Silver Longsword", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "sword"), \
	/obj/item/rogueweapon/sword/rapier = TAT_ITEM_ENTRY("Rapier", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "sword"), \
	/obj/item/rogueweapon/sword/rapier/silver = TAT_ITEM_ENTRY("Silver Rapier", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "sword"), \
	/obj/item/rogueweapon/sword/saber/iron = TAT_ITEM_ENTRY("Iron Saber", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "sword"), \
	/obj/item/rogueweapon/sword/sabre = TAT_ITEM_ENTRY("Sabre", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "sword"), \
	/obj/item/rogueweapon/sword/sabre/bronzekhopesh = TAT_ITEM_ENTRY("Bronze Khopesh", 3, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "sword"), \
	/obj/item/rogueweapon/sword/sabre/mulyeog = TAT_ITEM_ENTRY("Hwando", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/short = TAT_ITEM_ENTRY("Shortsword", 3, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "sword"), \
	/obj/item/rogueweapon/sword/short/falchion = TAT_ITEM_ENTRY("Falchion", 3, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/short/gladius = TAT_ITEM_ENTRY("Gladius", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/short/iron = TAT_ITEM_ENTRY("Iron Shortsword", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "sword"), \
	/obj/item/rogueweapon/sword/short/messer = TAT_ITEM_ENTRY("Messer", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/short/messer/alt = TAT_ITEM_ENTRY("Hunting Sword", 2, "weapon", "weapon_supply", TAT_SUPPLY_STEEL, "sword"), \
	/obj/item/rogueweapon/sword/short/messer/bronze = TAT_ITEM_ENTRY("Bronze Messer", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "sword"), \
	/obj/item/rogueweapon/sword/short/messer/iron = TAT_ITEM_ENTRY("Iron Messer", 2, "weapon", "weapon_supply", TAT_SUPPLY_IRON, "sword"), \
	/obj/item/rogueweapon/sword/short/silver = TAT_ITEM_ENTRY("Silver Shortsword", 3, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "sword"), \
	/obj/item/rogueweapon/sword/silver = TAT_ITEM_ENTRY("Silver Arming Sword", 4, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "sword"), \
	/obj/item/rogueweapon/whip/bronze = TAT_ITEM_ENTRY("Bronze Whip", 2, "weapon", "weapon_supply", TAT_SUPPLY_BRONZE, "whip"), \
	/obj/item/rogueweapon/whip/silver = TAT_ITEM_ENTRY("Silver Whip", 3, "weapon", "weapon_supply", TAT_SUPPLY_SILVER, "whip"), \
	/obj/item/clothing/gloves/roguetown/knuckles = TAT_ITEM_ENTRY("Knuckles", 3, "clothing", "armor_family", TAT_SUPPLY_STEEL, "gloves"), \
	/obj/item/clothing/gloves/roguetown/knuckles/bronze = TAT_ITEM_ENTRY("Knuckles Bronze", 2, "clothing", "armor_family", TAT_SUPPLY_BRONZE, "gloves"), \
	/obj/item/clothing/gloves/roguetown/angle = TAT_ITEM_ENTRY("Heavy Leather Gloves", 1, "clothing", "armor_family", TAT_ARMOR_LEATHER, "gloves"), \
	/obj/item/clothing/gloves/roguetown/angle/grenzelgloves = TAT_ITEM_ENTRY("Grenzelhoft Gloves", 1, "clothing", "armor_family", TAT_ARMOR_LEATHER, "gloves"), \
	/obj/item/clothing/gloves/roguetown/eastgloves1 = TAT_ITEM_ENTRY("Swordsman Gloves", 1, "clothing", "armor_family", TAT_ARMOR_CLOTH, "gloves"), \
	/obj/item/clothing/gloves/roguetown/eastgloves2 = TAT_ITEM_ENTRY("Stylish Bandages", 1, "clothing", "armor_family", TAT_ARMOR_CLOTH, "gloves"), \
	/obj/item/clothing/gloves/roguetown/elven_gloves = TAT_ITEM_ENTRY("Elven Gloves", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "gloves"), \
	/obj/item/clothing/gloves/roguetown/leather = TAT_ITEM_ENTRY("Leather Gloves", 1, "clothing", "armor_family", TAT_ARMOR_CLOTH, "gloves"), \
	/obj/item/clothing/gloves/roguetown/otavan = TAT_ITEM_ENTRY("Otavan Leather Gloves", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "gloves"), \
	/obj/item/clothing/gloves/roguetown/plate = TAT_ITEM_ENTRY("Plate Gauntlets", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "gloves"), \
	/obj/item/clothing/gloves/roguetown/plate/iron = TAT_ITEM_ENTRY("Iron Plate Armor", 2, "clothing", "armor_family", TAT_ARMOR_PLATE, "gloves"), \
	/obj/item/clothing/gloves/roguetown/plate/kote = TAT_ITEM_ENTRY("Jjajeungna Gauntlets", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "gloves"), \
	/obj/item/clothing/head/roguetown/armingcap = TAT_ITEM_ENTRY("Arming cap", 1, "clothing", "armor_family", TAT_ARMOR_CLOTH, "head"), \
	/obj/item/clothing/head/roguetown/armingcap/padded = TAT_ITEM_ENTRY("Padded Arming Cap", 2, "clothing", "armor_family", TAT_ARMOR_CLOTH, "head"), \
	/obj/item/clothing/head/roguetown/helmet/bascinet = TAT_ITEM_ENTRY("Bascinet", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan = TAT_ITEM_ENTRY("Etruscan Bacinet", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/bascinet/pigface = TAT_ITEM_ENTRY("Pigface Bacinet", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull = TAT_ITEM_ENTRY("Hounskull Bacinet", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/bronze = TAT_ITEM_ENTRY("Bronze Helmet", 2, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/bronzegladiator = TAT_ITEM_ENTRY("Bronze Murmillo", 2, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/barbute = TAT_ITEM_ENTRY("Barbute", 2, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/barbute/great = TAT_ITEM_ENTRY("Great Barbute", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor = TAT_ITEM_ENTRY("Visored Barbute", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/beakhelm = TAT_ITEM_ENTRY("Beak helmet", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/bronze = TAT_ITEM_ENTRY("Bronze Barbute", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/bucket = TAT_ITEM_ENTRY("Steel Bucket Helmet", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader = TAT_ITEM_ENTRY("Sugarloaf Helmet", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron = TAT_ITEM_ENTRY("Iron Bucket Helmet", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm = TAT_ITEM_ENTRY("Elven Helm", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth = TAT_ITEM_ENTRY("Frogmouth", 4, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/kabuto = TAT_ITEM_ENTRY("Kabuto", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/psysallet = TAT_ITEM_ENTRY("Psydonic Sallet", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/heavy/volfplate = TAT_ITEM_ENTRY("Volf-face Helm", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/horned = TAT_ITEM_ENTRY("Horned Cap", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/kettle = TAT_ITEM_ENTRY("Steel Kettle", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/kettle/iron = TAT_ITEM_ENTRY("Iron Kettle", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/kettle/jingasa = TAT_ITEM_ENTRY("Jingasa", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/kettle/wide = TAT_ITEM_ENTRY("Wide Kettle", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/leather = TAT_ITEM_ENTRY("Leather Helmet", 1, "clothing", "armor_family", TAT_ARMOR_LEATHER, "head"), \
	/obj/item/clothing/head/roguetown/helmet/leather/advanced = TAT_ITEM_ENTRY("Hardened Leather Helmet", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "head"), \
	/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = TAT_ITEM_ENTRY("Volf Helmet", 1, "clothing", "armor_family", TAT_ARMOR_LEATHER, "head"), \
	/obj/item/clothing/head/roguetown/helmet/sallet = TAT_ITEM_ENTRY("Sallet", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/sallet/beastskull = TAT_ITEM_ENTRY("Beastskull", 4, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/sallet/iron = TAT_ITEM_ENTRY("Iron Sallet", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/sallet/morion = TAT_ITEM_ENTRY("Etruscan Morion", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/sallet/raneshen = TAT_ITEM_ENTRY("Kulah Khud", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/sallet/shishak = TAT_ITEM_ENTRY("Steel Shishak", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/sallet/visored = TAT_ITEM_ENTRY("Visored Sallet", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/sallet/visored/iron = TAT_ITEM_ENTRY("Visored Iron Sallet", 2, "clothing", "armor_family", TAT_ARMOR_PLATE, "head"), \
	/obj/item/clothing/head/roguetown/helmet/skullcap = TAT_ITEM_ENTRY("Skull cap", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/head/roguetown/helmet/winged = TAT_ITEM_ENTRY("Winged Cap", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "head"), \
	/obj/item/clothing/mask/rogue/facemask = TAT_ITEM_ENTRY("Iron Mask", 1, "clothing", "armor_family", TAT_ARMOR_CLOTH, "mask"), \
	/obj/item/clothing/mask/rogue/facemask/bronze = TAT_ITEM_ENTRY("Bronze Mask", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "mask"), \
	/obj/item/clothing/mask/rogue/facemask/bronze/classic = TAT_ITEM_ENTRY("Mouthless Bronze Mask", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "mask"), \
	/obj/item/clothing/mask/rogue/facemask/copper = TAT_ITEM_ENTRY("Copper", 1, "clothing", "armor_family", TAT_ARMOR_MAIL, "mask"), \
	/obj/item/clothing/mask/rogue/facemask/steel = TAT_ITEM_ENTRY("Steel Mask", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "mask"), \
	/obj/item/clothing/mask/rogue/facemask/steel/kazengun = TAT_ITEM_ENTRY("Soldier's Half-Mask", 1, "clothing", "armor_family", TAT_ARMOR_MAIL, "mask"), \
	/obj/item/clothing/mask/rogue/facemask/steel/kazengun/full = TAT_ITEM_ENTRY("Soldier's Mask", 2, "clothing", "armor_family", TAT_ARMOR_PLATE, "mask"), \
	/obj/item/clothing/mask/rogue/facemask/steel/steppesman = TAT_ITEM_ENTRY("Steppesman Mask", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "mask"), \
	/obj/item/clothing/neck/roguetown/bevor = TAT_ITEM_ENTRY("Bevor", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "neck"), \
	/obj/item/clothing/neck/roguetown/bevor/bronze = TAT_ITEM_ENTRY("Bronze Bevor", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "neck"), \
	/obj/item/clothing/neck/roguetown/bevor/iron = TAT_ITEM_ENTRY("Iron Bevor", 1, "clothing", "armor_family", TAT_ARMOR_PLATE, "neck"), \
	/obj/item/clothing/neck/roguetown/chaincoif = TAT_ITEM_ENTRY("Steel Chaincoif", 2, "clothing", "armor_family", TAT_ARMOR_PLATE, "neck"), \
	/obj/item/clothing/neck/roguetown/chaincoif/chainmantle = TAT_ITEM_ENTRY("Chainmantle", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "neck"), \
	/obj/item/clothing/neck/roguetown/chaincoif/full = TAT_ITEM_ENTRY("Chaincoif Full", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "neck"), \
	/obj/item/clothing/neck/roguetown/chaincoif/iron = TAT_ITEM_ENTRY("Iron Chaincoif", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "neck"), \
	/obj/item/clothing/neck/roguetown/coif/heavypadding = TAT_ITEM_ENTRY("Heavy Padded Coif", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "neck"), \
	/obj/item/clothing/neck/roguetown/coif/padded = TAT_ITEM_ENTRY("Padded Coif", 2, "clothing", "armor_family", TAT_ARMOR_CLOTH, "neck"), \
	/obj/item/clothing/neck/roguetown/gorget = TAT_ITEM_ENTRY("Iron Gorget", 2, "clothing", "armor_family", TAT_ARMOR_CLOTH, "neck"), \
	/obj/item/clothing/neck/roguetown/gorget/bronze = TAT_ITEM_ENTRY("Bronze Gorget", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "neck"), \
	/obj/item/clothing/neck/roguetown/gorget/copper = TAT_ITEM_ENTRY("Copper Gorget", 1, "clothing", "armor_family", TAT_ARMOR_MAIL, "neck"), \
	/obj/item/clothing/neck/roguetown/gorget/steel = TAT_ITEM_ENTRY("Steel Gorget", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "neck"), \
	/obj/item/clothing/shoes/roguetown/boots = TAT_ITEM_ENTRY("Dark Boots", 1, "clothing", "armor_family", TAT_ARMOR_CLOTH, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/armor = TAT_ITEM_ENTRY("Plated Boots", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/armor/bronze = TAT_ITEM_ENTRY("Bronze Sandals", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/armor/iron = TAT_ITEM_ENTRY("Light Plated Boots", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/elven_boots = TAT_ITEM_ENTRY("Elven Boots", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = TAT_ITEM_ENTRY("Heavy Leather Boots", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun = TAT_ITEM_ENTRY("Kazengun Armored Sandals", 1, "clothing", "armor_family", TAT_ARMOR_LEATHER, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short = TAT_ITEM_ENTRY("Short Leather Boots", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman = TAT_ITEM_ENTRY("Aavnic Riding Boots", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/otavan = TAT_ITEM_ENTRY("Otavan Leather Boots", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "shoes"), \
	/obj/item/clothing/shoes/roguetown/boots/psydonboots = TAT_ITEM_ENTRY("Psydonic Boots", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "shoes"), \
	/obj/item/clothing/shoes/roguetown/grenzelhoft = TAT_ITEM_ENTRY("Grenzelhoft Boots", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "shoes"), \
	/obj/item/clothing/shoes/roguetown/shortboots = TAT_ITEM_ENTRY("Short Boots", 1, "clothing", "armor_family", TAT_ARMOR_CLOTH, "shoes"), \
	/obj/item/clothing/suit/roguetown/armor/chainmail = TAT_ITEM_ENTRY("Steel Haubergeon", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = TAT_ITEM_ENTRY("Steel Hauberk", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft = TAT_ITEM_ENTRY("Grenzelhoftian Hip-Shirt w/hauberk", 4, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = TAT_ITEM_ENTRY("Iron Hauberk", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/chainmail/iron = TAT_ITEM_ENTRY("Iron Haubergeon", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/chainmail/light = TAT_ITEM_ENTRY("Besilked Haubergeon", 3, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather = TAT_ITEM_ENTRY("leather armor", 1, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/cuirass = TAT_ITEM_ENTRY("Leather Cuirass", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/heavy = TAT_ITEM_ENTRY("Hardened Leather Zrmor", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = TAT_ITEM_ENTRY("Hardened Leather Coat", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen = TAT_ITEM_ENTRY("Megarmach Scale Coat", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen/new_coat = TAT_ITEM_ENTRY("Raneshene Light Scale Coat", 3, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe = TAT_ITEM_ENTRY("Fur-Woven Hatanga Coat", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter = TAT_ITEM_ENTRY("Freifechter Jacket", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket = TAT_ITEM_ENTRY("Jacket", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest = TAT_ITEM_ENTRY("Drowcraft Vest(All races)", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd = TAT_ITEM_ENTRY("Shepherd Vest", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/hide = TAT_ITEM_ENTRY("Hide Armor", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/studded = TAT_ITEM_ENTRY("Studded Leather Armor", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli = TAT_ITEM_ENTRY("Cuir-bouilli armor", 4, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate = TAT_ITEM_ENTRY("Steel Half-Plate", 4, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/bronze = TAT_ITEM_ENTRY("bronze cuirass", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/bronze/light = TAT_ITEM_ENTRY("Bronze Cardiophylax", 2, "clothing", "armor_family", "suit", null), \
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass = TAT_ITEM_ENTRY("Steel Cuirass", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper = TAT_ITEM_ENTRY("Copper Cuirass", 2, "clothing", "armor_family", "suit", null), \
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer = TAT_ITEM_ENTRY("Fencer Cuirass", 4, "clothing", "armor_family", TAT_ARMOR_LEATHER, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted = TAT_ITEM_ENTRY("Fluted Cuirass", 4, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate = TAT_ITEM_ENTRY("Psydonic Cuirass", 4, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = TAT_ITEM_ENTRY("Iron Cuirass", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/elven_plate = TAT_ITEM_ENTRY("Woad Elven Plate", 4, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/fluted = TAT_ITEM_ENTRY("Fluted Half-Plate", 4, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate = TAT_ITEM_ENTRY("Psydonic Half-Plate", 4, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/full = TAT_ITEM_ENTRY("Steel Plate Armor", 4, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/full/bronze = TAT_ITEM_ENTRY("Bronze Panoplic Armor", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt = TAT_ITEM_ENTRY("Bronze Panoplic Assembly", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/full/fluted = TAT_ITEM_ENTRY("Fluted Plate", 4, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate = TAT_ITEM_ENTRY("Psydonic Plate", 5, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/full/iron = TAT_ITEM_ENTRY("Iron Plate Armor", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/full/raneshen_plated = TAT_ITEM_ENTRY("Ranesheni Rlate Armor", 4, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa = TAT_ITEM_ENTRY("Samsibsa Scaleplate", 4, "clothing", "armor_family", TAT_ARMOR_PLATE, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/iron = TAT_ITEM_ENTRY("iron half-plate", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/raneshen_scale = TAT_ITEM_ENTRY("Ranesheni Medium Lamellar Armor", 4, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/scale = TAT_ITEM_ENTRY("Scalemail", 4, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/suit/roguetown/armor/plate/scale/steppe = TAT_ITEM_ENTRY("Steel Heavy Lamellar", 4, "clothing", "armor_family", TAT_ARMOR_MAIL, "suit"), \
	/obj/item/clothing/under/roguetown/brigandinelegs = TAT_ITEM_ENTRY("Brigandine Chausses", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "under"), \
	/obj/item/clothing/under/roguetown/chainlegs = TAT_ITEM_ENTRY("Steel Chain Chausses", 3, "clothing", "armor_family", TAT_ARMOR_MAIL, "under"), \
	/obj/item/clothing/under/roguetown/chainlegs/iron = TAT_ITEM_ENTRY("Iron Chain Chausses", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "under"), \
	/obj/item/clothing/under/roguetown/chainlegs/iron/kilt = TAT_ITEM_ENTRY("Iron Chain Kilt", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "under"), \
	/obj/item/clothing/under/roguetown/chainlegs/kilt = TAT_ITEM_ENTRY("Steel Chain Kilt", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "under"), \
	/obj/item/clothing/under/roguetown/chainlegs/skirt = TAT_ITEM_ENTRY("Steel Chain Skirt", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "under"), \
	/obj/item/clothing/under/roguetown/heavy_leather_pants = TAT_ITEM_ENTRY("Heavy Leather Pants", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "under"), \
	/obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt = TAT_ITEM_ENTRY("Bronze skirt", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "under"), \
	/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants = TAT_ITEM_ENTRY("Grenzelhoftian Paumpers", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "under"), \
	/obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants = TAT_ITEM_ENTRY("Silk Tights", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "under"), \
	/obj/item/clothing/under/roguetown/heavy_leather_pants/shorts = TAT_ITEM_ENTRY("Leather Shorts", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "under"), \
	/obj/item/clothing/under/roguetown/platelegs = TAT_ITEM_ENTRY("Plate legs", 3, "clothing", "armor_family", TAT_ARMOR_PLATE, "under"), \
	/obj/item/clothing/under/roguetown/platelegs/iron = TAT_ITEM_ENTRY("Iron Plate legs", 2, "clothing", "armor_family", TAT_ARMOR_PLATE, "under"), \
	/obj/item/clothing/under/roguetown/splintlegs = TAT_ITEM_ENTRY("Chausses, Splinted", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "under"), \
	/obj/item/clothing/under/roguetown/chainlegs/gronn = TAT_ITEM_ENTRY("Gronn Byrine Chausses", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "under"), \
	/obj/item/clothing/under/roguetown/tights/sailor = TAT_ITEM_ENTRY("Sailor Pants", 1, "clothing", "armor_family", TAT_ARMOR_LEATHER, "under"), \
	/obj/item/clothing/under/roguetown/trou = TAT_ITEM_ENTRY("Work Trousers", 1, "clothing", "armor_family", TAT_ARMOR_CLOTH, "under"), \
	/obj/item/clothing/under/roguetown/trou/leather = TAT_ITEM_ENTRY("Leather Trousers", 1, "clothing", "armor_family", TAT_ARMOR_CLOTH, "under"), \
	/obj/item/clothing/under/roguetown/trou/leather/gronn = TAT_ITEM_ENTRY("Fur lined Pants", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "under"), \
	/obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen = TAT_ITEM_ENTRY("Baggy Desert Pants", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "under"), \
	/obj/item/clothing/wrists/roguetown/bracers = TAT_ITEM_ENTRY("Steel Bracers ", 2, "clothing", "armor_family", TAT_ARMOR_PLATE, "wrists"), \
	/obj/item/clothing/under/roguetown/trou/leathertights = TAT_ITEM_ENTRY("Leather tights", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "under"), \
	/obj/item/clothing/wrists/roguetown/bracers/brigandine = TAT_ITEM_ENTRY("Brigandine Rerebraces", 4, "clothing", "armor_family", TAT_ARMOR_LEATHER, "wrists"), \
	/obj/item/clothing/wrists/roguetown/bracers/bronze = TAT_ITEM_ENTRY("Bronze Bracers ", 1, "clothing", "armor_family", TAT_ARMOR_MAIL, "wrists"), \
	/obj/item/clothing/wrists/roguetown/bracers/cloth/monk = TAT_ITEM_ENTRY("Monk Wrapping", 1, "clothing", "armor_family", TAT_ARMOR_LEATHER, "wrists"), \
	/obj/item/clothing/wrists/roguetown/bracers/copper = TAT_ITEM_ENTRY("Copper Bracers", 1, "clothing", "armor_family", TAT_ARMOR_MAIL, "wrists"), \
	/obj/item/clothing/wrists/roguetown/bracers/iron = TAT_ITEM_ENTRY("Iron Bracers ", 2, "clothing", "armor_family", TAT_ARMOR_MAIL, "wrists"), \
	/obj/item/clothing/wrists/roguetown/bracers/leather = TAT_ITEM_ENTRY("Leather Bracers ", 1, "clothing", "armor_family", TAT_ARMOR_LEATHER, "wrists"), \
	/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = TAT_ITEM_ENTRY("Heavy Leather Bracers", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "wrists"), \
	/obj/item/clothing/wrists/roguetown/bracers/splint = TAT_ITEM_ENTRY("Splint Bracers", 2, "clothing", "armor_family", TAT_ARMOR_LEATHER, "wrists"), \
	/obj/item/clothing/wrists/roguetown/bracers/twilight_elven = TAT_ITEM_ENTRY("Elver Rider Bracers", 3, "clothing", "armor_family", TAT_ARMOR_LEATHER, "wrists")
