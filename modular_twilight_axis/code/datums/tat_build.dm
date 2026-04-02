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
#define TAT_TRAIT_PLATE_SUPPLIER "tat_plate_supplier"
#define TAT_TRAIT_SPELLBLADE "tat_spellblade"

/datum/tat_build
	var/list/available_stats = list()
	var/list/available_skills = list()
	var/list/available_traits = list()
	var/list/available_items = list()

	var/points_stats = 4
	var/points_skills = 30
	var/points_traits = 10
	var/points_items = 15

	var/list/stats = list()
	var/list/skills = list()
	var/list/traits = list()
	var/list/items = list()

	var/dirty = FALSE

/datum/tat_build/New()
	. = ..()
	init_available_stats()
	init_available_skills()
	init_available_traits()
	init_available_items()
	reset_build()

/datum/tat_build/proc/init_available_stats()
	available_stats = list(
		STATKEY_STR = list("name" = "Strength", "cost" = 2, "base" = 10, "min" = 1, "max" = 20),
		STATKEY_PER = list("name" = "Perception", "cost" = 2, "base" = 10, "min" = 1, "max" = 20),
		STATKEY_INT = list("name" = "Intelligence", "cost" = 2, "base" = 10, "min" = 1, "max" = 20),
		STATKEY_CON = list("name" = "Constitution", "cost" = 2, "base" = 10, "min" = 1, "max" = 20),
		STATKEY_WIL = list("name" = "Willpower", "cost" = 2, "base" = 10, "min" = 1, "max" = 20),
		STATKEY_SPD = list("name" = "Speed", "cost" = 2, "base" = 10, "min" = 1, "max" = 20),
		STATKEY_LCK = list("name" = "Fortune", "cost" = 2, "base" = 10, "min" = 1, "max" = 20),
	)

/datum/tat_build/proc/init_available_skills()
	available_skills = list()

	for(var/path in subtypesof(/datum/skill))
		if(path == /datum/skill)
			continue

		var/datum/skill/skill = new path
		if(initial(skill.abstract_type) == path)
			qdel(skill)
			continue

		available_skills[path] = list(
			"name" = initial(skill.name),
			"desc" = initial(skill.desc),
			"category" = "[initial(skill.abstract_type)]",
			"is_combat" = ispath(path, /datum/skill/combat),
		)
		qdel(skill)

/datum/tat_build/proc/make_trait_entry(name, cost, category, desc = null)
	return list(
		"name" = name,
		"cost" = cost,
		"category" = category,
		"category_name" = get_trait_category_name(category),
		"desc" = desc,
	)

/datum/tat_build/proc/get_trait_category_name(category)
	switch(category)
		if("class_module")
			return "Class Modules"
		if("combat_mastery")
			return "Combat Mastery"
		if("defense")
			return "Defense"
		if("supply")
			return "Supply"
		if("enhancement")
			return "Enhancement"
		if("craft")
			return "Craft"
		if("utility")
			return "Utility"
		if("oddity")
			return "Oddities"
	return "Other"

/datum/tat_build/proc/init_available_traits()
	available_traits = list(
		TAT_TRAIT_SOUNDBREAKER = make_trait_entry("Soundbreaker", 4, "class_module"),
		TAT_TRAIT_RONIN = make_trait_entry("Ronin", 4, "class_module"),
		TAT_TRAIT_SPELLBLADE = make_trait_entry("Spellblade", 4, "class_module"),
		TAT_TRAIT_RESIDENT = make_trait_entry("Resident", 3, "class_module"),

		TAT_TRAIT_WARRIOR_EXPERT = make_trait_entry("Expert Warrior", 3, "combat_mastery"),
		TAT_TRAIT_WARRIOR_MASTER = make_trait_entry("Master Warrior", 4, "combat_mastery"),

		TRAIT_DODGEEXPERT = make_trait_entry("Expert Dodger", 3, "defense"),
		TRAIT_PARRYEXPERT = make_trait_entry("Expert Parry", 3, "defense"),
		TRAIT_HEAVYARMOR = make_trait_entry("Plate Training", 2, "defense"),
		TRAIT_MEDIUMARMOR = make_trait_entry("Maille Training", 2, "defense"),
		TRAIT_NOPAINSTUN = make_trait_entry("Enduring", 2, "defense"),
		TRAIT_CRITICAL_RESISTANCE = make_trait_entry("Critical Resistance", 3, "defense"),
		TRAIT_HARDDISMEMBER = make_trait_entry("Hard Dismemberment", 2, "defense"),
		TRAIT_BLOOD_RESISTANCE = make_trait_entry("Thick Blooded", 2, "defense"),
		TRAIT_STEELHEARTED = make_trait_entry("Steelhearted", 2, "defense"),
		TRAIT_CIVILIZEDBARBARIAN = make_trait_entry("Expert Pugilist", 3, "defense"),

		TAT_TRAIT_BRONZE_SUPPLIER = make_trait_entry("Bronze Supplier", 1, "supply", "Unlocks bronze-tier weapons."),
		TAT_TRAIT_SILVER_SUPPLIER = make_trait_entry("Silver Supplier", 2, "supply", "Unlocks silver-tier weapons."),
		TAT_TRAIT_STEEL_SUPPLIER = make_trait_entry("Steel Supplier", 2, "supply", "Unlocks steel-tier and advanced non-iron weapons."),
		TAT_TRAIT_LEATHER_SUPPLIER = make_trait_entry("Leather Supplier", 1, "supply", "Unlocks leather gear in all supported slots."),
		TAT_TRAIT_MAIL_SUPPLIER = make_trait_entry("Mail Supplier", 2, "supply", "Unlocks mail gear in all supported slots."),
		TAT_TRAIT_PLATE_SUPPLIER = make_trait_entry("Plate Supplier", 3, "supply", "Unlocks plate gear in all supported slots."),

		TRAIT_KEENEARS = make_trait_entry("Keen Ears", 1, "enhancement"),
		TRAIT_DARKVISION = make_trait_entry("Darksight", 2, "enhancement"),
		TRAIT_DEATHSIGHT = make_trait_entry("Veiled Whispers", 2, "enhancement"),
		TRAIT_INTELLECTUAL = make_trait_entry("Intellectual", 2, "enhancement"),
		TRAIT_ARCYNE = make_trait_entry("Arcyne Training", 2, "enhancement"),
		TRAIT_JACKOFALLTRADES = make_trait_entry("Jack of All Trades", 4, "enhancement"),
		TRAIT_EMPATH = make_trait_entry("Empath", 2, "enhancement"),
		TRAIT_NOSTINK = make_trait_entry("Dead Nose", 2, "enhancement"),
		TRAIT_NOBLE = make_trait_entry("Noble Blooded", 2, "enhancement"),

		TRAIT_TRAINED_SMITH = make_trait_entry("Trained Smith", 2, "craft"),
		TRAIT_SMITHING_EXPERT = make_trait_entry("Expert Forgehand", 3, "craft"),
		TRAIT_ALCHEMY_EXPERT = make_trait_entry("Expert Alchemist", 3, "craft"),
		TRAIT_MEDICINE_EXPERT = make_trait_entry("Expert Physicker", 3, "craft"),
		TRAIT_HOMESTEAD_EXPERT = make_trait_entry("Expert Homesteader", 3, "craft"),
		TRAIT_SURVIVAL_EXPERT = make_trait_entry("Expert Survivalist", 3, "craft"),
		TRAIT_SEWING_EXPERT = make_trait_entry("Expert Clothier", 3, "craft"),
		TRAIT_SEEDKNOW = make_trait_entry("Seed Knower", 1, "craft"),
		TRAIT_CAUTIOUS_FISHER = make_trait_entry("Cautious Fisher", 1, "craft"),
		TRAIT_SQUIRE_REPAIR = make_trait_entry("Squire Knowledge", 1, "craft"),

		TRAIT_CICERONE = make_trait_entry("Cicerone", 1, "utility"),
		TRAIT_SEEPRICES = make_trait_entry("Appraiser", 1, "utility"),
		TRAIT_MARRIAGE_CAPABLE = make_trait_entry("Marriage Capable", 1, "utility"),
		TRAIT_OUTLANDER = make_trait_entry("Outlander", 2, "utility"),
		TRAIT_GRAVEROBBER = make_trait_entry("Experienced Grave Robber", 2, "utility"),
		TRAIT_PURITAN_ADVENTURER = make_trait_entry("Interrogator", 2, "utility"),
		TRAIT_DECEIVING_MEEKNESS = make_trait_entry("Deceiving Meekness", 2, "utility"),

		TRAIT_PSYCHOSIS = make_trait_entry("Psychosis", 2, "oddity"),
		TRAIT_WITCH = make_trait_entry("They fear me, but I am useful to them", 3, "oddity"),
		TRAIT_NASTY_EATER = make_trait_entry("Inhumen Digestion", 2, "oddity"),
		TRAIT_GOODLOVER = make_trait_entry("Fabled Lover", 2, "oddity"),
		TRAIT_NUTCRACKER = make_trait_entry("Nutcracker", 2, "oddity"),
	)

/datum/tat_build/proc/make_item_entry(name, cost, category, unlock_type, unlock_key, slot_group = null)
	return list(
		"name" = name,
		"cost" = cost,
		"category" = category,
		"unlock_type" = unlock_type,
		"unlock_key" = unlock_key,
		"slot_group" = slot_group,
	)

/datum/tat_build/proc/init_available_items()
	available_items = list(
		// Weapons
		/obj/item/rogueweapon/eaglebeak = make_item_entry("Eaglebeak", 3, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/eaglebeak/lucerne = make_item_entry("Lucerne", 4, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/greataxe = make_item_entry("Greataxe", 3, "weapon", "weapon_supply", "iron", "axe"),
		/obj/item/rogueweapon/greataxe/bronze = make_item_entry("Bronze Greataxe", 3, "weapon", "weapon_supply", "bronze", "axe"),
		/obj/item/rogueweapon/greataxe/silver = make_item_entry("Silver Greataxe", 4, "weapon", "weapon_supply", "silver", "axe"),
		/obj/item/rogueweapon/greataxe/steel = make_item_entry("Steel Greataxe", 4, "weapon", "weapon_supply", "steel", "axe"),
		/obj/item/rogueweapon/greataxe/steel/doublehead = make_item_entry("Double-Headed Greataxe", 5, "weapon", "weapon_supply", "steel", "axe"),
		/obj/item/rogueweapon/greatsword = make_item_entry("Greatsword", 4, "weapon", "weapon_supply", "iron", "greatsword"),
		/obj/item/rogueweapon/greatsword/grenz = make_item_entry("Grenz", 4, "weapon", "weapon_supply", "steel", "greatsword"),
		/obj/item/rogueweapon/greatsword/grenz/flamberge = make_item_entry("Flamberge", 5, "weapon", "weapon_supply", "steel", "greatsword"),
		/obj/item/rogueweapon/greatsword/iron = make_item_entry("Iron Greatsword", 4, "weapon", "weapon_supply", "iron", "greatsword"),
		/obj/item/rogueweapon/greatsword/silver = make_item_entry("Silver Greatsword", 5, "weapon", "weapon_supply", "silver", "greatsword"),
		/obj/item/rogueweapon/greatsword/zwei = make_item_entry("Zweihander", 5, "weapon", "weapon_supply", "steel", "greatsword"),
		/obj/item/rogueweapon/halberd = make_item_entry("Halberd", 4, "weapon", "weapon_supply", "iron", "polearm"),
		/obj/item/rogueweapon/halberd/bardiche = make_item_entry("Bardiche", 4, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/halberd/bardiche/scythe = make_item_entry("War Scythe", 4, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/halberd/glaive = make_item_entry("Glaive", 4, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/huntingknife = make_item_entry("Knife", 1, "weapon", "weapon_supply", "iron", "knife"),
		/obj/item/rogueweapon/huntingknife/bronze = make_item_entry("Bronze Knife", 1, "weapon", "weapon_supply", "bronze", "knife"),
		/obj/item/rogueweapon/huntingknife/chefknife = make_item_entry("Chef Knife", 1, "weapon", "weapon_supply", "iron", "knife"),
		/obj/item/rogueweapon/huntingknife/chefknife/cleaver = make_item_entry("Cleaver", 2, "weapon", "weapon_supply", "steel", "knife"),
		/obj/item/rogueweapon/huntingknife/combat/bronze = make_item_entry("Bronze Combat Knife", 2, "weapon", "weapon_supply", "bronze", "knife"),
		/obj/item/rogueweapon/huntingknife/combat/iron = make_item_entry("Iron Combat Knife", 2, "weapon", "weapon_supply", "iron", "knife"),
		/obj/item/rogueweapon/huntingknife/idagger = make_item_entry("Dagger", 2, "weapon", "weapon_supply", "iron", "knife"),
		/obj/item/rogueweapon/huntingknife/idagger/navaja = make_item_entry("Navaja", 2, "weapon", "weapon_supply", "steel", "knife"),
		/obj/item/rogueweapon/huntingknife/idagger/silver = make_item_entry("Silver Dagger", 3, "weapon", "weapon_supply", "silver", "knife"),
		/obj/item/rogueweapon/huntingknife/idagger/steel = make_item_entry("Steel Dagger", 3, "weapon", "weapon_supply", "steel", "knife"),
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = make_item_entry("Corroded Dirk", 2, "weapon", "weapon_supply", "steel", "knife"),
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = make_item_entry("Parrying Dagger", 3, "weapon", "weapon_supply", "steel", "knife"),
		/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = make_item_entry("Rondel Dagger", 3, "weapon", "weapon_supply", "steel", "knife"),
		/obj/item/rogueweapon/huntingknife/scissors = make_item_entry("Scissors", 1, "weapon", "weapon_supply", "iron", "knife"),
		/obj/item/rogueweapon/huntingknife/scissors/steel = make_item_entry("Steel Scissors", 2, "weapon", "weapon_supply", "steel", "knife"),
		/obj/item/rogueweapon/katar = make_item_entry("Katar", 2, "weapon", "weapon_supply", "iron", "knife"),
		/obj/item/rogueweapon/katar/bronze = make_item_entry("Bronze Katar", 2, "weapon", "weapon_supply", "bronze", "knife"),
		/obj/item/rogueweapon/katar/bronze/gladiator = make_item_entry("Bronze Gladiator Katar", 3, "weapon", "weapon_supply", "bronze", "knife"),
		/obj/item/rogueweapon/katar/punchdagger = make_item_entry("Punch Dagger", 2, "weapon", "weapon_supply", "steel", "knife"),
		/obj/item/rogueweapon/katar/silver = make_item_entry("Silver Katar", 3, "weapon", "weapon_supply", "silver", "knife"),
		/obj/item/rogueweapon/mace = make_item_entry("Mace", 2, "weapon", "weapon_supply", "iron", "blunt"),
		/obj/item/rogueweapon/mace/bronze = make_item_entry("Bronze Mace", 2, "weapon", "weapon_supply", "bronze", "blunt"),
		/obj/item/rogueweapon/mace/cudgel/flanged = make_item_entry("Flanged Mace", 3, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/mace/cudgel/flanged/silver = make_item_entry("Silver Flanged Mace", 4, "weapon", "weapon_supply", "silver", "blunt"),
		/obj/item/rogueweapon/mace/maul = make_item_entry("Maul", 3, "weapon", "weapon_supply", "iron", "blunt"),
		/obj/item/rogueweapon/mace/maul/grand = make_item_entry("Grand Maul", 4, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/mace/maul/spiked = make_item_entry("Spiked Maul", 4, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/mace/maul/steel = make_item_entry("Steel Maul", 4, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/mace/spiked = make_item_entry("Spiked Mace", 3, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/mace/steel = make_item_entry("Steel Mace", 3, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/mace/steel/morningstar = make_item_entry("Morningstar", 4, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/mace/steel/silver = make_item_entry("Silver Mace", 4, "weapon", "weapon_supply", "silver", "blunt"),
		/obj/item/rogueweapon/mace/warhammer = make_item_entry("Warhammer", 3, "weapon", "weapon_supply", "iron", "blunt"),
		/obj/item/rogueweapon/mace/warhammer/bronze = make_item_entry("Bronze Warhammer", 3, "weapon", "weapon_supply", "bronze", "blunt"),
		/obj/item/rogueweapon/mace/warhammer/steel = make_item_entry("Steel Warhammer", 4, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/mace/warhammer/steel/silver = make_item_entry("Silver Warhammer", 5, "weapon", "weapon_supply", "silver", "blunt"),
		/obj/item/rogueweapon/flail = make_item_entry("Flail", 2, "weapon", "weapon_supply", "iron", "blunt"),
		/obj/item/rogueweapon/flail/alt = make_item_entry("Flail Alt", 2, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/flail/bronze = make_item_entry("Bronze Flail", 2, "weapon", "weapon_supply", "bronze", "blunt"),
		/obj/item/rogueweapon/flail/peasantwarflail = make_item_entry("Peasant War Flail", 2, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/flail/peasantwarflail/iron = make_item_entry("Iron Peasant War Flail", 2, "weapon", "weapon_supply", "iron", "blunt"),
		/obj/item/rogueweapon/flail/sflail = make_item_entry("Steel Flail", 3, "weapon", "weapon_supply", "steel", "blunt"),
		/obj/item/rogueweapon/flail/sflail/silver = make_item_entry("Silver Flail", 4, "weapon", "weapon_supply", "silver", "blunt"),
		/obj/item/rogueweapon/spear = make_item_entry("Spear", 2, "weapon", "weapon_supply", "iron", "polearm"),
		/obj/item/rogueweapon/spear/assegai = make_item_entry("Assegai", 2, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/spear/assegai/iron = make_item_entry("Iron Assegai", 2, "weapon", "weapon_supply", "iron", "polearm"),
		/obj/item/rogueweapon/spear/boar = make_item_entry("Boar Spear", 3, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/spear/boar/frei = make_item_entry("Frei Pike", 3, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/spear/boar/frei/pike = make_item_entry("Pike", 3, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/spear/bronze = make_item_entry("Bronze Spear", 2, "weapon", "weapon_supply", "bronze", "polearm"),
		/obj/item/rogueweapon/spear/bronze/strapless = make_item_entry("Bronze Strapless Spear", 2, "weapon", "weapon_supply", "bronze", "polearm"),
		/obj/item/rogueweapon/spear/bronze/winged = make_item_entry("Bronze Winged Spear", 3, "weapon", "weapon_supply", "bronze", "polearm"),
		/obj/item/rogueweapon/spear/bronze/winged/strapless = make_item_entry("Bronze Winged Strapless Spear", 3, "weapon", "weapon_supply", "bronze", "polearm"),
		/obj/item/rogueweapon/spear/lance = make_item_entry("Lance", 4, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/spear/naginata = make_item_entry("Naginata", 4, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/spear/partizan = make_item_entry("Partizan", 4, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/spear/short = make_item_entry("Short Spear", 2, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/spear/silver = make_item_entry("Silver Spear", 3, "weapon", "weapon_supply", "silver", "polearm"),
		/obj/item/rogueweapon/spear/trident = make_item_entry("Trident", 4, "weapon", "weapon_supply", "steel", "polearm"),
		/obj/item/rogueweapon/stoneaxe/battle = make_item_entry("Battle Axe", 2, "weapon", "weapon_supply", "steel", "axe"),
		/obj/item/rogueweapon/stoneaxe/woodcut = make_item_entry("Woodcutter Axe", 2, "weapon", "weapon_supply", "iron", "axe"),
		/obj/item/rogueweapon/stoneaxe/woodcut/bronze = make_item_entry("Bronze Axe", 2, "weapon", "weapon_supply", "bronze", "axe"),
		/obj/item/rogueweapon/stoneaxe/woodcut/bronzebattleaxe = make_item_entry("Bronze Battle Axe", 3, "weapon", "weapon_supply", "bronze", "axe"),
		/obj/item/rogueweapon/stoneaxe/woodcut/pick = make_item_entry("Pick Axe", 2, "weapon", "weapon_supply", "steel", "axe"),
		/obj/item/rogueweapon/stoneaxe/woodcut/silver = make_item_entry("Silver Axe", 3, "weapon", "weapon_supply", "silver", "axe"),
		/obj/item/rogueweapon/stoneaxe/woodcut/steel = make_item_entry("Steel Axe", 3, "weapon", "weapon_supply", "steel", "axe"),
		/obj/item/rogueweapon/sword = make_item_entry("Arming Sword", 2, "weapon", "weapon_supply", "iron", "sword"),
		/obj/item/rogueweapon/sword/bronze = make_item_entry("Bronze Arming Sword", 2, "weapon", "weapon_supply", "bronze", "sword"),
		/obj/item/rogueweapon/sword/cutlass = make_item_entry("Cutlass", 3, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/falx = make_item_entry("Falx", 3, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/iron = make_item_entry("Iron Arming Sword", 2, "weapon", "weapon_supply", "iron", "sword"),
		/obj/item/rogueweapon/sword/long = make_item_entry("Longsword", 3, "weapon", "weapon_supply", "iron", "sword"),
		/obj/item/rogueweapon/sword/long/broadsword = make_item_entry("Broadsword", 3, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/long/broadsword/bronze = make_item_entry("Bronze Broadsword", 3, "weapon", "weapon_supply", "bronze", "sword"),
		/obj/item/rogueweapon/sword/long/broadsword/steel = make_item_entry("Steel Broadsword", 4, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/long/exe = make_item_entry("Executioner Sword", 4, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/long/exe/silver = make_item_entry("Silver Executioner Sword", 5, "weapon", "weapon_supply", "silver", "sword"),
		/obj/item/rogueweapon/sword/long/greatkhopesh = make_item_entry("Great Khopesh", 4, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/long/kriegmesser = make_item_entry("Kriegmesser", 4, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/long/kriegmesser/silver = make_item_entry("Silver Kriegmesser", 5, "weapon", "weapon_supply", "silver", "sword"),
		/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo = make_item_entry("Ssangsudo", 4, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/long/rhomphaia = make_item_entry("Rhomphaia", 4, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/long/silver = make_item_entry("Silver Longsword", 4, "weapon", "weapon_supply", "silver", "sword"),
		/obj/item/rogueweapon/sword/rapier = make_item_entry("Rapier", 2, "weapon", "weapon_supply", "iron", "sword"),
		/obj/item/rogueweapon/sword/rapier/silver = make_item_entry("Silver Rapier", 3, "weapon", "weapon_supply", "silver", "sword"),
		/obj/item/rogueweapon/sword/saber/iron = make_item_entry("Iron Saber", 2, "weapon", "weapon_supply", "iron", "sword"),
		/obj/item/rogueweapon/sword/sabre = make_item_entry("Sabre", 2, "weapon", "weapon_supply", "iron", "sword"),
		/obj/item/rogueweapon/sword/sabre/bronzekhopesh = make_item_entry("Bronze Khopesh", 3, "weapon", "weapon_supply", "bronze", "sword"),
		/obj/item/rogueweapon/sword/sabre/mulyeog = make_item_entry("Hwando", 3, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/short = make_item_entry("Shortsword", 2, "weapon", "weapon_supply", "iron", "sword"),
		/obj/item/rogueweapon/sword/short/falchion = make_item_entry("Falchion", 3, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/short/gladius = make_item_entry("Gladius", 2, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/short/iron = make_item_entry("Iron Shortsword", 2, "weapon", "weapon_supply", "iron", "sword"),
		/obj/item/rogueweapon/sword/short/messer = make_item_entry("Messer", 2, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/short/messer/alt = make_item_entry("Alt Messer", 2, "weapon", "weapon_supply", "steel", "sword"),
		/obj/item/rogueweapon/sword/short/messer/bronze = make_item_entry("Bronze Messer", 2, "weapon", "weapon_supply", "bronze", "sword"),
		/obj/item/rogueweapon/sword/short/messer/iron = make_item_entry("Iron Messer", 2, "weapon", "weapon_supply", "iron", "sword"),
		/obj/item/rogueweapon/sword/short/silver = make_item_entry("Silver Shortsword", 3, "weapon", "weapon_supply", "silver", "sword"),
		/obj/item/rogueweapon/sword/silver = make_item_entry("Silver Arming Sword", 3, "weapon", "weapon_supply", "silver", "sword"),
		/obj/item/rogueweapon/whip/bronze = make_item_entry("Bronze Whip", 2, "weapon", "weapon_supply", "bronze", "whip"),
		/obj/item/rogueweapon/whip/silver = make_item_entry("Silver Whip", 3, "weapon", "weapon_supply", "silver", "whip"),

		// Clothing (auto-generated first-pass filtered pool)
		/obj/item/clothing/cloak/apron = make_item_entry("Apron", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/apron/brown = make_item_entry("Apron Brown", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/apron/waist = make_item_entry("Apron Waist", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/apron/waist/brown = make_item_entry("Waist Brown", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/bandolier = make_item_entry("Bandolier", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/black_cloak = make_item_entry("Black Cloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/cape = make_item_entry("Cape", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/cape/fur = make_item_entry("Fur", 2, "clothing", "armor_family", "leather", "cloak"),
		/obj/item/clothing/cloak/cape/hood = make_item_entry("Cape Hood", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/cape/purple = make_item_entry("Cape Purple", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/cape/red = make_item_entry("Cape Red", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/cape/rogue = make_item_entry("Cape Rogue", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/chasuble = make_item_entry("Chasuble", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/cotehardie = make_item_entry("Cotehardie", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/darkcloak = make_item_entry("Darkcloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/duelcape = make_item_entry("Duelcape", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/eastcloak1 = make_item_entry("Eastcloak1", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/eastcloak2 = make_item_entry("Eastcloak2", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/forrestercloak = make_item_entry("Forrestercloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/forrestercloak/snow = make_item_entry("Snow", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/graggar = make_item_entry("Graggar", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/half = make_item_entry("Half", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/half/brown = make_item_entry("Half Brown", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/half/orange = make_item_entry("Orange", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/half/red = make_item_entry("Half Red", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/half/rider = make_item_entry("Rider", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/half/rider/red = make_item_entry("Rider Red", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/half/shadowcloak = make_item_entry("Shadowcloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/half/vet = make_item_entry("Vet", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/heartfelt = make_item_entry("Heartfelt", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/hierophant = make_item_entry("Hierophant", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/kazengun = make_item_entry("Kazengun", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/lordcloak = make_item_entry("Lordcloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/lordcloak/ladycloak = make_item_entry("Ladycloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/matron = make_item_entry("Matron", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/ordinatorcape = make_item_entry("Ordinatorcape", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/ordinatorcape/lirvas = make_item_entry("Lirvas", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/poncho = make_item_entry("Poncho", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/poncho/fancycoat = make_item_entry("Fancycoat", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/psyaltrist = make_item_entry("Psyaltrist", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/raincloak = make_item_entry("Raincloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/raincloak/blue = make_item_entry("Blue", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/raincloak/brown = make_item_entry("Raincloak Brown", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/raincloak/furcloak = make_item_entry("Furcloak", 2, "clothing", "armor_family", "leather", "cloak"),
		/obj/item/clothing/cloak/raincloak/furcloak/black = make_item_entry("Furcloak Black", 2, "clothing", "armor_family", "leather", "cloak"),
		/obj/item/clothing/cloak/raincloak/furcloak/brown = make_item_entry("Furcloak Brown", 2, "clothing", "armor_family", "leather", "cloak"),
		/obj/item/clothing/cloak/raincloak/furcloak/darkgreen = make_item_entry("Darkgreen", 2, "clothing", "armor_family", "leather", "cloak"),
		/obj/item/clothing/cloak/raincloak/furcloak/woad = make_item_entry("Woad", 2, "clothing", "armor_family", "leather", "cloak"),
		/obj/item/clothing/cloak/raincloak/green = make_item_entry("Green", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/raincloak/mortus = make_item_entry("Mortus", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/raincloak/purple = make_item_entry("Raincloak Purple", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/raincloak/red = make_item_entry("Raincloak Red", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/scaledcloak = make_item_entry("Scaledcloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/sheriff = make_item_entry("Sheriff", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/stole = make_item_entry("Stole", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/stole/purple = make_item_entry("Stole Purple", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/stole/red = make_item_entry("Stole Red", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/templar/pestra = make_item_entry("Pestra", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/templar/pestran = make_item_entry("Pestran", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/templar/undivided = make_item_entry("Undivided", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/thief_cloak = make_item_entry("Thief Cloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/thief_cloak/yoruku = make_item_entry("Yoruku", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/tribal = make_item_entry("Tribal", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/twilight_cape = make_item_entry("Twilight Cape", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/twilight_elven = make_item_entry("Twilight Elven", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/twilight_elven/short = make_item_entry("Short", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/twilight_scarf = make_item_entry("Twilight Scarf", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/undivided = make_item_entry("Undivided", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/volfmantle = make_item_entry("Volfmantle", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/wardencloak = make_item_entry("Wardencloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/cloak/wickercloak = make_item_entry("Wickercloak", 1, "clothing", "armor_family", "cloth", "cloak"),
		/obj/item/clothing/gloves/roguetown = make_item_entry("Roguetown", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/angle = make_item_entry("Angle", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/angle/grenzelgloves = make_item_entry("Grenzelgloves", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/bandages = make_item_entry("Bandages", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/chain = make_item_entry("Chain", 2, "clothing", "armor_family", "mail", "gloves"),
		/obj/item/clothing/gloves/roguetown/chain/iron = make_item_entry("Chain Iron", 2, "clothing", "armor_family", "mail", "gloves"),
		/obj/item/clothing/gloves/roguetown/courtphysician = make_item_entry("Courtphysician", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/courtphysician/female = make_item_entry("Female", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/eastgloves1 = make_item_entry("Eastgloves1", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/eastgloves2 = make_item_entry("Eastgloves2", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/elven_gloves = make_item_entry("Elven Gloves", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/fingerless = make_item_entry("Fingerless", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves = make_item_entry("Shadowgloves", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock = make_item_entry("Elflock", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/fingerless_leather = make_item_entry("Fingerless Leather", 1, "clothing", "armor_family", "leather", "gloves"),
		/obj/item/clothing/gloves/roguetown/knuckles = make_item_entry("Knuckles", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/knuckles/ancient = make_item_entry("Ancient", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/knuckles/bronze = make_item_entry("Knuckles Bronze", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/knuckles/decrepit = make_item_entry("Decrepit", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/knuckles/eora = make_item_entry("Eora", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/leather = make_item_entry("Roguetown Leather", 1, "clothing", "armor_family", "leather", "gloves"),
		/obj/item/clothing/gloves/roguetown/leather/black = make_item_entry("Leather Black", 1, "clothing", "armor_family", "leather", "gloves"),
		/obj/item/clothing/gloves/roguetown/otavan = make_item_entry("Otavan", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/otavan/inqgloves = make_item_entry("Inqgloves", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/otavan/psygloves = make_item_entry("Psygloves", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate = make_item_entry("Roguetown Plate", 1, "clothing", "armor_family", "cloth", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate/blacksteel = make_item_entry("Blacksteel", 3, "clothing", "armor_family", "plate", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate/blacksteel/modern = make_item_entry("Modern", 3, "clothing", "armor_family", "plate", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate/blkknight = make_item_entry("Blkknight", 3, "clothing", "armor_family", "plate", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate/graggar = make_item_entry("Graggar", 3, "clothing", "armor_family", "plate", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate/iron = make_item_entry("Plate Iron", 3, "clothing", "armor_family", "plate", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate/kote = make_item_entry("Kote", 3, "clothing", "armor_family", "plate", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate/matthios = make_item_entry("Matthios", 3, "clothing", "armor_family", "plate", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate/shadowgauntlets = make_item_entry("Shadowgauntlets", 3, "clothing", "armor_family", "plate", "gloves"),
		/obj/item/clothing/gloves/roguetown/plate/zizo = make_item_entry("Zizo", 3, "clothing", "armor_family", "plate", "gloves"),
		/obj/item/clothing/head/hooded/rainhood = make_item_entry("Rainhood", 1, "clothing", "armor_family", "cloth", "head"),
		/obj/item/clothing/head/hooded/rainhood/furhood = make_item_entry("Furhood", 1, "clothing", "armor_family", "leather", "head"),
		/obj/item/clothing/head/roguetown/armingcap = make_item_entry("Armingcap", 1, "clothing", "armor_family", "cloth", "head"),
		/obj/item/clothing/head/roguetown/armingcap/padded = make_item_entry("Padded", 1, "clothing", "armor_family", "cloth", "head"),
		/obj/item/clothing/head/roguetown/cap = make_item_entry("Cap", 1, "clothing", "armor_family", "cloth", "head"),
		/obj/item/clothing/head/roguetown/cap/dwarf = make_item_entry("Dwarf", 1, "clothing", "armor_family", "cloth", "head"),
		/obj/item/clothing/head/roguetown/helmet = make_item_entry("Helmet", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/bandana = make_item_entry("Bandana", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/bascinet = make_item_entry("Bascinet", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan = make_item_entry("Etruscan", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/grenzelhoft = make_item_entry("Grenzelhoft", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/grenzelhoft/triumph = make_item_entry("Triumph", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface = make_item_entry("Pigface", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull = make_item_entry("Hounskull", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/bronze = make_item_entry("Helmet Bronze", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/bronzegladiator = make_item_entry("Bronzegladiator", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/coppercap = make_item_entry("Coppercap", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/elvenbarbute = make_item_entry("Elvenbarbute", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak = make_item_entry("Blackoak", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged = make_item_entry("Winged", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak = make_item_entry("Blackoak", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/goblin = make_item_entry("Goblin", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy = make_item_entry("Helmet Heavy", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/barbute = make_item_entry("Barbute", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/barbute/great = make_item_entry("Great", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor = make_item_entry("Visor", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/beakhelm = make_item_entry("Beakhelm", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/bronze = make_item_entry("Heavy Bronze", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket = make_item_entry("Bucket", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader = make_item_entry("Crusader", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron = make_item_entry("Bucket Iron", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm = make_item_entry("Elven Helm", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth = make_item_entry("Frogmouth", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/kabuto = make_item_entry("Kabuto", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm = make_item_entry("Ordinatorhelm", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/plume = make_item_entry("Plume", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/psysallet = make_item_entry("Psysallet", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/sheriff = make_item_entry("Sheriff", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/volfplate = make_item_entry("Volfplate", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker = make_item_entry("Berserker", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/puritan = make_item_entry("Puritan", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/heavy/zizo = make_item_entry("Zizo", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/horned = make_item_entry("Horned", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/kettle = make_item_entry("Kettle", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/kettle/iron = make_item_entry("Kettle Iron", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/kettle/jingasa = make_item_entry("Jingasa", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/kettle/wide = make_item_entry("Wide", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/leather = make_item_entry("Helmet Leather", 1, "clothing", "armor_family", "leather", "head"),
		/obj/item/clothing/head/roguetown/helmet/leather/advanced = make_item_entry("Advanced", 1, "clothing", "armor_family", "leather", "head"),
		/obj/item/clothing/head/roguetown/helmet/leather/chapeau = make_item_entry("Chapeau", 1, "clothing", "armor_family", "leather", "head"),
		/obj/item/clothing/head/roguetown/helmet/leather/goblin = make_item_entry("Goblin", 1, "clothing", "armor_family", "leather", "head"),
		/obj/item/clothing/head/roguetown/helmet/leather/saiga = make_item_entry("Saiga", 1, "clothing", "armor_family", "leather", "head"),
		/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood = make_item_entry("Shaman Hood", 1, "clothing", "armor_family", "leather", "head"),
		/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = make_item_entry("Volfhelm", 1, "clothing", "armor_family", "leather", "head"),
		/obj/item/clothing/head/roguetown/helmet/otavan = make_item_entry("Otavan", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet = make_item_entry("Sallet", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/beastskull = make_item_entry("Beastskull", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/grenzelhoft = make_item_entry("Grenzelhoft", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/grenzelhoft/triumph = make_item_entry("Triumph", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/iron = make_item_entry("Sallet Iron", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/morion = make_item_entry("Morion", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/raneshen = make_item_entry("Raneshen", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/shishak = make_item_entry("Shishak", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/visored = make_item_entry("Visored", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/visored/grenzelhoft = make_item_entry("Grenzelhoft", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/visored/iron = make_item_entry("Visored Iron", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/warden = make_item_entry("Warden", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/bear = make_item_entry("Bear", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/goat = make_item_entry("Goat", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/rat = make_item_entry("Rat", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf = make_item_entry("Wolf", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/wretch = make_item_entry("Wretch", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/skullcap = make_item_entry("Skullcap", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/tricorn = make_item_entry("Tricorn", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/tricorn/lucky = make_item_entry("Lucky", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/tricorn/skull = make_item_entry("Skull", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/head/roguetown/helmet/winged = make_item_entry("Winged", 3, "clothing", "armor_family", "plate", "head"),
		/obj/item/clothing/mask/rogue/duelmask = make_item_entry("Duelmask", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask = make_item_entry("Facemask", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/bronze = make_item_entry("Facemask Bronze", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/bronze/anthro = make_item_entry("Anthro", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/bronze/classic = make_item_entry("Classic", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/bronze/classic/anthro = make_item_entry("Anthro", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/copper = make_item_entry("Copper", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/shadowfacemask = make_item_entry("Shadowfacemask", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/steel = make_item_entry("Facemask Steel", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/steel/confessor = make_item_entry("Confessor", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed = make_item_entry("Lensed", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/steel/kazengun = make_item_entry("Kazengun", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/steel/kazengun/full = make_item_entry("Kazengun Full", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/steel/psythorns = make_item_entry("Psythorns", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/steel/steppesman = make_item_entry("Steppesman", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro = make_item_entry("Anthro", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/yoruku_kitsune = make_item_entry("Yoruku Kitsune", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/mask/rogue/facemask/yoruku_oni = make_item_entry("Yoruku Oni", 1, "clothing", "armor_family", "cloth", "mask"),
		/obj/item/clothing/neck/roguetown/bevor = make_item_entry("Bevor", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/bevor/bronze = make_item_entry("Bevor Bronze", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/bevor/iron = make_item_entry("Bevor Iron", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/bevor/zizo = make_item_entry("Zizo", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/chaincoif = make_item_entry("Chaincoif", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/chaincoif/chainmantle = make_item_entry("Chainmantle", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/chaincoif/chainmantle/matthios = make_item_entry("Matthios", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/chaincoif/full = make_item_entry("Chaincoif Full", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/chaincoif/full/black = make_item_entry("Full Black", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/chaincoif/iron = make_item_entry("Chaincoif Iron", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy = make_item_entry("Aalloy", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/chaincoif/paalloy = make_item_entry("Paalloy", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/coif = make_item_entry("Coif", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/coif/heavypadding = make_item_entry("Heavypadding", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/coif/padded = make_item_entry("Padded", 2, "clothing", "armor_family", "mail", "neck"),
		/obj/item/clothing/neck/roguetown/gorget = make_item_entry("Gorget", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/aalloy = make_item_entry("Aalloy", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/bronze = make_item_entry("Gorget Bronze", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/copper = make_item_entry("Copper", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/cursed_collar = make_item_entry("Cursed Collar", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/forlorncollar = make_item_entry("Forlorncollar", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/gold = make_item_entry("Gold", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/gold/king = make_item_entry("King", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/paalloy = make_item_entry("Paalloy", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/steel = make_item_entry("Gorget Steel", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/steel/graggar = make_item_entry("Graggar", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/gorget/steel/kazengun = make_item_entry("Kazengun", 3, "clothing", "armor_family", "plate", "neck"),
		/obj/item/clothing/neck/roguetown/leather = make_item_entry("Roguetown Leather", 1, "clothing", "armor_family", "leather", "neck"),
		/obj/item/clothing/shoes/roguetown = make_item_entry("Roguetown", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/anklets = make_item_entry("Anklets", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots = make_item_entry("Boots", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/armor = make_item_entry("Armor", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/armor/blkknight = make_item_entry("Blkknight", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/armor/bronze = make_item_entry("Armor Bronze", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/armor/iron = make_item_entry("Armor Iron", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/armor/zizo = make_item_entry("Zizo", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/clothlinedanklets = make_item_entry("Clothlinedanklets", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/elven_boots = make_item_entry("Elven Boots", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/furlinedanklets = make_item_entry("Furlinedanklets", 1, "clothing", "armor_family", "leather", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/furlinedboots = make_item_entry("Furlinedboots", 1, "clothing", "armor_family", "leather", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/hammerhold_boots = make_item_entry("Hammerhold Boots", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/leather = make_item_entry("Boots Leather", 1, "clothing", "armor_family", "leather", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = make_item_entry("Reinforced", 1, "clothing", "armor_family", "leather", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun = make_item_entry("Kazengun", 1, "clothing", "armor_family", "leather", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short = make_item_entry("Short", 1, "clothing", "armor_family", "leather", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/nobleboot = make_item_entry("Nobleboot", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman = make_item_entry("Steppesman", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/otavan = make_item_entry("Otavan", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/otavan/inqboots = make_item_entry("Inqboots", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/boots/psydonboots = make_item_entry("Psydonboots", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/gladiator = make_item_entry("Gladiator", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/grenzelhoft = make_item_entry("Grenzelhoft", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/hammerhold_shoes = make_item_entry("Hammerhold Shoes", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/horseshoes = make_item_entry("Horseshoes", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/horseshoes/silver = make_item_entry("Horseshoes Silver", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/horseshoes/steel = make_item_entry("Horseshoes Steel", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/jester = make_item_entry("Jester", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/ridingboots = make_item_entry("Ridingboots", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/sandals = make_item_entry("Sandals", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/shalal = make_item_entry("Shalal", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/shortboots = make_item_entry("Shortboots", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/simpleshoes = make_item_entry("Simpleshoes", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/simpleshoes/buckle = make_item_entry("Buckle", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/simpleshoes/lord = make_item_entry("Lord", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/shoes/roguetown/simpleshoes/white = make_item_entry("White", 1, "clothing", "armor_family", "cloth", "shoes"),
		/obj/item/clothing/suit/roguetown/armor/armordress = make_item_entry("Armordress", 1, "clothing", "armor_family", "cloth", "suit"),
		/obj/item/clothing/suit/roguetown/armor/armordress/alt = make_item_entry("Alt", 1, "clothing", "armor_family", "cloth", "suit"),
		/obj/item/clothing/suit/roguetown/armor/armordress/winterdress = make_item_entry("Winterdress", 1, "clothing", "armor_family", "cloth", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail = make_item_entry("Chainmail", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/bikini = make_item_entry("Bikini", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = make_item_entry("Hauberk", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar = make_item_entry("Graggar", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft = make_item_entry("Grenzelhoft", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy = make_item_entry("Hauberk Heavy", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = make_item_entry("Hauberk Iron", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy = make_item_entry("Iron Heavy", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate = make_item_entry("Ornate", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo = make_item_entry("Zizo", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron = make_item_entry("Chainmail Iron", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/light = make_item_entry("Chainmail Light", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/chainmail/light/fencer = make_item_entry("Fencer", 3, "clothing", "armor_family", "mail", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather = make_item_entry("Armor Leather", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/bikini = make_item_entry("Bikini", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/cuirass = make_item_entry("Cuirass", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/goblin = make_item_entry("Goblin", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy = make_item_entry("Leather Heavy", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = make_item_entry("Coat", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor = make_item_entry("Confessor", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/gravecoat = make_item_entry("Gravecoat", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen = make_item_entry("Raneshen", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen/new_coat = make_item_entry("New Coat", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe = make_item_entry("Steppe", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter = make_item_entry("Freifechter", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket = make_item_entry("Jacket", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/courtphysician = make_item_entry("Courtphysician", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/courtphysician/female = make_item_entry("Female", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest = make_item_entry("Shadowvest", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest/drowraider = make_item_entry("Drowraider", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd = make_item_entry("Shepherd", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/tailcoat = make_item_entry("Tailcoat", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/hide = make_item_entry("Hide", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini = make_item_entry("Bikini", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/hide/goblin = make_item_entry("Goblin", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket = make_item_entry("Artijacket", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/handjacket = make_item_entry("Handjacket", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/studded = make_item_entry("Studded", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini = make_item_entry("Bikini", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli = make_item_entry("Cuirbouilli", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist = make_item_entry("Psyaltrist", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/studded/warden = make_item_entry("Warden", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded = make_item_entry("Upgraded", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/trophyfur = make_item_entry("Trophyfur", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/vest = make_item_entry("Vest", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/vest/black = make_item_entry("Vest Black", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/vest/hand = make_item_entry("Hand", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor = make_item_entry("Sailor", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman = make_item_entry("Nightman", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/vest/white = make_item_entry("White", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket = make_item_entry("Winterjacket", 2, "clothing", "armor_family", "leather", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate = make_item_entry("Armor Plate", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/bikini = make_item_entry("Bikini", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/blkknight = make_item_entry("Blkknight", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/bronze = make_item_entry("Plate Bronze", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/bronze/light = make_item_entry("Bronze Light", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass = make_item_entry("Cuirass", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper = make_item_entry("Copper", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer = make_item_entry("Fencer", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/elven = make_item_entry("Elven", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/twilight_elven = make_item_entry("Twilight Elven", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted = make_item_entry("Fluted", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate = make_item_entry("Ornate", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = make_item_entry("Cuirass Iron", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/goblin = make_item_entry("Goblin", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy = make_item_entry("Legacy", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/elven_plate = make_item_entry("Elven Plate", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/fluted = make_item_entry("Fluted", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar = make_item_entry("Graggar", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate = make_item_entry("Ornate", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate = make_item_entry("Shadowplate", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full = make_item_entry("Plate Full", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/bikini = make_item_entry("Bikini", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/bronze = make_item_entry("Full Bronze", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt = make_item_entry("Alt", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted = make_item_entry("Fluted", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy = make_item_entry("Legacy", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate = make_item_entry("Ornate", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/ordinator = make_item_entry("Ordinator", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/iron = make_item_entry("Full Iron", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/legacy = make_item_entry("Legacy", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/raneshen_plated = make_item_entry("Raneshen Plated", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa = make_item_entry("Samsibsa", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/full/zizo = make_item_entry("Zizo", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/iron = make_item_entry("Plate Iron", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/legacy = make_item_entry("Legacy", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/otavan = make_item_entry("Otavan", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/raneshen_scale = make_item_entry("Raneshen Scale", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/scale = make_item_entry("Scale", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat = make_item_entry("Inqcoat", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored = make_item_entry("Armored", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/scale/marshal = make_item_entry("Marshal", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/scale/steppe = make_item_entry("Steppe", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/scale/townguard = make_item_entry("Townguard", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/scale/townguard/sheriff = make_item_entry("Sheriff", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/silver = make_item_entry("Plate Silver", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/suit/roguetown/armor/plate/vampire = make_item_entry("Vampire", 4, "clothing", "armor_family", "plate", "suit"),
		/obj/item/clothing/under/roguetown = make_item_entry("Roguetown", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/brayette = make_item_entry("Brayette", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/brigandinelegs = make_item_entry("Brigandinelegs", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/chainlegs = make_item_entry("Chainlegs", 3, "clothing", "armor_family", "mail", "under"),
		/obj/item/clothing/under/roguetown/chainlegs/iron = make_item_entry("Chainlegs Iron", 3, "clothing", "armor_family", "mail", "under"),
		/obj/item/clothing/under/roguetown/chainlegs/iron/kilt = make_item_entry("Kilt", 3, "clothing", "armor_family", "mail", "under"),
		/obj/item/clothing/under/roguetown/chainlegs/kilt = make_item_entry("Kilt", 3, "clothing", "armor_family", "mail", "under"),
		/obj/item/clothing/under/roguetown/chainlegs/skirt = make_item_entry("Skirt", 3, "clothing", "armor_family", "mail", "under"),
		/obj/item/clothing/under/roguetown/heavy_leather_pants = make_item_entry("Heavy Leather Pants", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt = make_item_entry("Bronzeskirt", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants = make_item_entry("Grenzelpants", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants = make_item_entry("Shadowpants", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/drowraider = make_item_entry("Drowraider", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/heavy_leather_pants/shorts = make_item_entry("Shorts", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/loincloth = make_item_entry("Loincloth", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/loincloth/brown = make_item_entry("Loincloth Brown", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/loincloth/deprived = make_item_entry("Deprived", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/loincloth/pink = make_item_entry("Pink", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/platelegs = make_item_entry("Platelegs", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/platelegs/blacksteel = make_item_entry("Blacksteel", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/platelegs/blacksteel/modern = make_item_entry("Modern", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/platelegs/blkknight = make_item_entry("Blkknight", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/platelegs/graggar = make_item_entry("Graggar", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/platelegs/iron = make_item_entry("Platelegs Iron", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/platelegs/iron/gronn = make_item_entry("Gronn", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/platelegs/skirt = make_item_entry("Skirt", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/platelegs/zizo = make_item_entry("Zizo", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/skirt = make_item_entry("Skirt", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/skirt/black = make_item_entry("Skirt Black", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/skirt/blue = make_item_entry("Blue", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/skirt/brown = make_item_entry("Skirt Brown", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/skirt/desert = make_item_entry("Desert", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/skirt/green = make_item_entry("Green", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/skirt/random = make_item_entry("Random", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/skirt/red = make_item_entry("Skirt Red", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/splintlegs = make_item_entry("Splintlegs", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/splintlegs/gronn = make_item_entry("Gronn", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights = make_item_entry("Tights", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/black = make_item_entry("Tights Black", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/explorerpants = make_item_entry("Explorerpants", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/formalfancy = make_item_entry("Formalfancy", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/green = make_item_entry("Green", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/jester = make_item_entry("Jester", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/lord = make_item_entry("Lord", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/puritan = make_item_entry("Puritan", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/purple = make_item_entry("Tights Purple", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/red = make_item_entry("Tights Red", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/sailor = make_item_entry("Sailor", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/shorts = make_item_entry("Shorts", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/vagrant = make_item_entry("Vagrant", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/tights/vagrant/l = make_item_entry("L", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/trou = make_item_entry("Trou", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/trou/apothecary = make_item_entry("Apothecary", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/trou/artipants = make_item_entry("Artipants", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/trou/beltpants = make_item_entry("Beltpants", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/trou/leather = make_item_entry("Trou Leather", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/trou/leather/eastern = make_item_entry("Eastern", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/trou/leather/gronn = make_item_entry("Gronn", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/trou/leather/hakama = make_item_entry("Hakama", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/trou/leather/mourning = make_item_entry("Mourning", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/trou/leather/pontifex = make_item_entry("Pontifex", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen = make_item_entry("Raneshen", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/trou/leathertights = make_item_entry("Leathertights", 2, "clothing", "armor_family", "leather", "under"),
		/obj/item/clothing/under/roguetown/trou/shadowpants = make_item_entry("Shadowpants", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/under/roguetown/webs = make_item_entry("Webs", 1, "clothing", "armor_family", "cloth", "under"),
		/obj/item/clothing/wrists/roguetown/allwrappings = make_item_entry("Allwrappings", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/allwrappings/scarlet = make_item_entry("Scarlet", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers = make_item_entry("Bracers", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/brigandine = make_item_entry("Brigandine", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/bronze = make_item_entry("Bracers Bronze", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/cloth = make_item_entry("Bracers Cloth", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator = make_item_entry("Gladiator", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/cloth/monk = make_item_entry("Monk", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/copper = make_item_entry("Copper", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/hand = make_item_entry("Hand", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/iron = make_item_entry("Bracers Iron", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/jackchain = make_item_entry("Jackchain", 2, "clothing", "armor_family", "mail", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/leather = make_item_entry("Bracers Leather", 1, "clothing", "armor_family", "leather", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = make_item_entry("Leather Heavy", 1, "clothing", "armor_family", "leather", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/lirvas = make_item_entry("Lirvas", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/psythorns = make_item_entry("Psythorns", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/splint = make_item_entry("Splint", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/twilight_elven = make_item_entry("Twilight Elven", 1, "clothing", "armor_family", "cloth", "wrists"),
		/obj/item/clothing/wrists/roguetown/bracers/zizo = make_item_entry("Zizo", 1, "clothing", "armor_family", "cloth", "wrists"),
	)

/datum/tat_build/proc/get_stat_entry(stat_id)
	if(!(stat_id in available_stats))
		return null
	return available_stats[stat_id]

/datum/tat_build/proc/get_stat_base(stat_id)
	var/list/entry = get_stat_entry(stat_id)
	if(!islist(entry))
		return 10
	return isnum(entry["base"]) ? entry["base"] : 10

/datum/tat_build/proc/get_stat_min(stat_id)
	var/list/entry = get_stat_entry(stat_id)
	if(!islist(entry))
		return 1
	return isnum(entry["min"]) ? entry["min"] : 1

/datum/tat_build/proc/get_stat_max(stat_id)
	var/list/entry = get_stat_entry(stat_id)
	if(!islist(entry))
		return 20
	return isnum(entry["max"]) ? entry["max"] : 20

/datum/tat_build/proc/get_stat_cost(stat_id)
	var/list/entry = get_stat_entry(stat_id)
	if(!islist(entry))
		return 0
	return isnum(entry["cost"]) ? entry["cost"] : 0

/datum/tat_build/proc/get_stat_value(stat_id)
	if(stat_id in stats)
		return stats[stat_id]
	return get_stat_base(stat_id)

/datum/tat_build/proc/get_skill_entry(skill_type)
	if(!ispath(skill_type) || !(skill_type in available_skills))
		return null
	return available_skills[skill_type]

/datum/tat_build/proc/get_skill_value(skill_type)
	if(skill_type in skills)
		return skills[skill_type]
	return 0

/datum/tat_build/proc/get_trait_entry(trait_id)
	if(!(trait_id in available_traits))
		return null
	return available_traits[trait_id]

/datum/tat_build/proc/get_trait_cost(trait_id)
	var/list/entry = get_trait_entry(trait_id)
	if(!islist(entry))
		return 0
	return isnum(entry["cost"]) ? entry["cost"] : 0

/datum/tat_build/proc/get_item_entry(item_path)
	if(!ispath(item_path) || !(item_path in available_items))
		return null
	return available_items[item_path]

/datum/tat_build/proc/get_item_cost(item_path)
	var/list/entry = get_item_entry(item_path)
	if(!islist(entry))
		return 0
	return isnum(entry["cost"]) ? entry["cost"] : 0

/datum/tat_build/proc/get_stat_point_delta_for_value(stat_id, value)
	var/base = get_stat_base(stat_id)
	var/cost = get_stat_cost(stat_id)
	return (value - base) * cost

/datum/tat_build/proc/get_total_stat_point_delta()
	var/total = 0
	for(var/stat_id in available_stats)
		total += get_stat_point_delta_for_value(stat_id, get_stat_value(stat_id))
	return total

/datum/tat_build/proc/get_remaining_stat_points()
	return points_stats - get_total_stat_point_delta()

/datum/tat_build/proc/get_skill_next_cost(skill_type)
	var/current = get_skill_value(skill_type)
	return current + 1

/datum/tat_build/proc/get_skill_total_cost_for_level(level)
	if(!isnum(level) || level <= 0)
		return 0
	var/total = 0
	for(var/i in 1 to level)
		total += i
	return total

/datum/tat_build/proc/get_spent_skill_points()
	var/total = 0
	for(var/skill_type in skills)
		var/level = skills[skill_type]
		if(!isnum(level) || level <= 0)
			continue
		total += get_skill_total_cost_for_level(level)
	return total

/datum/tat_build/proc/get_remaining_skill_points()
	return points_skills - get_spent_skill_points()

/datum/tat_build/proc/get_spent_trait_points()
	var/total = 0
	for(var/trait_id in traits)
		total += get_trait_cost(trait_id)
	return total

/datum/tat_build/proc/get_remaining_trait_points()
	return points_traits - get_spent_trait_points()

/datum/tat_build/proc/get_spent_item_points()
	var/total = 0
	for(var/item_path in items)
		var/amount = items[item_path]
		if(!isnum(amount) || amount <= 0)
			continue
		total += get_item_cost(item_path) * amount
	return total

/datum/tat_build/proc/get_remaining_item_points()
	return points_items - get_spent_item_points()

/datum/tat_build/proc/get_combat_skill_cap()
	var/cap = TAT_SKILL_COMBAT_CAP_DEFAULT
	if(TAT_TRAIT_WARRIOR_EXPERT in traits)
		cap = max(cap, TAT_SKILL_COMBAT_CAP_TRAIT_1)
	if(TAT_TRAIT_WARRIOR_MASTER in traits)
		cap = max(cap, TAT_SKILL_COMBAT_CAP_TRAIT_2)
	return cap

/datum/tat_build/proc/get_skill_cap(skill_type)
	if(ispath(skill_type, /datum/skill/combat))
		return get_combat_skill_cap()
	return TAT_SKILL_NONCOMBAT_CAP

/datum/tat_build/proc/can_use_weapon_supply_type(supply_type)
	switch(supply_type)
		if("iron")
			return TRUE
		if("bronze")
			return (TAT_TRAIT_BRONZE_SUPPLIER in traits)
		if("silver")
			return (TAT_TRAIT_SILVER_SUPPLIER in traits)
		if("steel")
			return (TAT_TRAIT_STEEL_SUPPLIER in traits)
	return FALSE

/datum/tat_build/proc/can_use_armor_family(armor_family)
	switch(armor_family)
		if("cloth")
			return TRUE
		if("leather")
			return (TAT_TRAIT_LEATHER_SUPPLIER in traits)
		if("mail")
			return (TAT_TRAIT_MAIL_SUPPLIER in traits)
		if("plate")
			return (TAT_TRAIT_PLATE_SUPPLIER in traits)
	return FALSE

/datum/tat_build/proc/can_use_item_entry(list/entry)
	if(!islist(entry))
		return FALSE
	var/unlock_type = entry["unlock_type"]
	var/unlock_key = entry["unlock_key"]
	switch(unlock_type)
		if("weapon_supply")
			return can_use_weapon_supply_type(unlock_key)
		if("armor_family")
			return can_use_armor_family(unlock_key)
	return FALSE

/datum/tat_build/proc/build_ui_stats()
	var/list/result = list()
	for(var/stat_id in available_stats)
		result[stat_id] = get_stat_value(stat_id)
	return result

/datum/tat_build/proc/build_ui_skills()
	var/list/result = list()
	for(var/skill_type in available_skills)
		var/list/entry = available_skills[skill_type]
		result["[skill_type]"] = list(
			"name" = entry["name"],
			"desc" = entry["desc"],
			"level" = get_skill_value(skill_type),
			"cap" = get_skill_cap(skill_type),
			"next_cost" = get_skill_next_cost(skill_type),
			"is_combat" = !!entry["is_combat"],
			"category" = entry["category"],
		)
	return result

/datum/tat_build/proc/build_ui_traits()
	var/list/result = list()
	for(var/trait_id in available_traits)
		var/list/entry = available_traits[trait_id]
		result[trait_id] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"category" = entry["category"],
			"category_name" = entry["category_name"],
			"desc" = entry["desc"],
			"selected" = (trait_id in traits),
		)
	return result

/datum/tat_build/proc/build_ui_items()
	var/list/result = list()
	for(var/item_path in available_items)
		var/list/entry = available_items[item_path]
		var/unlocked = can_use_item_entry(entry)
		result["[item_path]"] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"category" = entry["category"],
			"unlock_type" = entry["unlock_type"],
			"unlock_key" = entry["unlock_key"],
			"slot_group" = entry["slot_group"],
			"amount" = (items[item_path] || 0),
			"unlocked" = unlocked,
		)
	return result

/datum/tat_build/proc/set_stat_value(stat_id, value)
	if(!(stat_id in available_stats))
		return FALSE
	value = round(value)
	value = clamp(value, get_stat_min(stat_id), get_stat_max(stat_id))
	if(value == get_stat_base(stat_id))
		stats -= stat_id
	else
		stats[stat_id] = value
	return TRUE

/datum/tat_build/proc/remove_items_by_unlock(unlock_type, unlock_key)
	for(var/item_path in items.Copy())
		var/list/entry = get_item_entry(item_path)
		if(!islist(entry))
			continue
		if(entry["unlock_type"] == unlock_type && entry["unlock_key"] == unlock_key)
			items -= item_path

/datum/tat_build/proc/has_invalid_trait_dependencies()
	if((TAT_TRAIT_WARRIOR_MASTER in traits) && !(TAT_TRAIT_WARRIOR_EXPERT in traits))
		return TRUE
	return FALSE

/datum/tat_build/proc/has_invalid_supply_items()
	for(var/item_path in items)
		var/list/entry = get_item_entry(item_path)
		if(!islist(entry) || !can_use_item_entry(entry))
			return TRUE
	return FALSE

/datum/tat_build/proc/is_budget_valid()
	if(get_remaining_stat_points() < 0) return FALSE
	if(get_remaining_skill_points() < 0) return FALSE
	if(get_remaining_trait_points() < 0) return FALSE
	if(get_remaining_item_points() < 0) return FALSE
	return TRUE

/datum/tat_build/proc/sanitize_stats()
	for(var/stat_id in available_stats)
		set_stat_value(stat_id, get_stat_value(stat_id))
	while(get_remaining_stat_points() < 0)
		var/changed = FALSE
		for(var/stat_id in available_stats)
			var/current = get_stat_value(stat_id)
			var/base = get_stat_base(stat_id)
			if(current > base)
				set_stat_value(stat_id, current - 1)
				changed = TRUE
				if(get_remaining_stat_points() >= 0)
					break
		if(!changed)
			break

/datum/tat_build/proc/sanitize_traits()
	var/list/cleaned = list()
	for(var/trait_id in traits)
		if(trait_id in available_traits)
			cleaned += trait_id
	traits = cleaned

	if((TAT_TRAIT_WARRIOR_MASTER in traits) && !(TAT_TRAIT_WARRIOR_EXPERT in traits))
		traits -= TAT_TRAIT_WARRIOR_MASTER

	while(get_remaining_trait_points() < 0)
		var/changed = FALSE
		for(var/trait_id in traits.Copy())
			if(trait_id == TAT_TRAIT_WARRIOR_EXPERT && (TAT_TRAIT_WARRIOR_MASTER in traits))
				continue
			traits -= trait_id
			changed = TRUE
			if(get_remaining_trait_points() >= 0)
				break
		if(!changed)
			break

	if(!(TAT_TRAIT_BRONZE_SUPPLIER in traits))
		remove_items_by_unlock("weapon_supply", "bronze")
	if(!(TAT_TRAIT_SILVER_SUPPLIER in traits))
		remove_items_by_unlock("weapon_supply", "silver")
	if(!(TAT_TRAIT_STEEL_SUPPLIER in traits))
		remove_items_by_unlock("weapon_supply", "steel")
	if(!(TAT_TRAIT_LEATHER_SUPPLIER in traits))
		remove_items_by_unlock("armor_family", "leather")
	if(!(TAT_TRAIT_MAIL_SUPPLIER in traits))
		remove_items_by_unlock("armor_family", "mail")
	if(!(TAT_TRAIT_PLATE_SUPPLIER in traits))
		remove_items_by_unlock("armor_family", "plate")

/datum/tat_build/proc/sanitize_skills()
	for(var/skill_type in skills.Copy())
		if(!(skill_type in available_skills))
			skills -= skill_type
			continue
		var/value = round(skills[skill_type])
		value = clamp(value, 0, get_skill_cap(skill_type))
		if(value > 0)
			skills[skill_type] = value
		else
			skills -= skill_type

	while(get_remaining_skill_points() < 0)
		var/changed = FALSE
		for(var/skill_type in skills.Copy())
			var/current = get_skill_value(skill_type)
			if(current <= 0) continue
			if(current > 1)
				skills[skill_type] = current - 1
			else
				skills -= skill_type
			changed = TRUE
			if(get_remaining_skill_points() >= 0)
				break
		if(!changed)
			break

/datum/tat_build/proc/sanitize_items()
	for(var/item_path in items.Copy())
		if(!(item_path in available_items))
			items -= item_path
			continue
		var/value = round(items[item_path])
		if(value <= 0)
			items -= item_path
			continue
		var/list/entry = available_items[item_path]
		if(!can_use_item_entry(entry))
			items -= item_path
			continue
		items[item_path] = value

	while(get_remaining_item_points() < 0)
		var/changed = FALSE
		for(var/item_path in items.Copy())
			var/current = items[item_path]
			if(current > 1)
				items[item_path] = current - 1
			else
				items -= item_path
			changed = TRUE
			if(get_remaining_item_points() >= 0)
				break
		if(!changed)
			break

/datum/tat_build/proc/sanitize_build()
	sanitize_traits()
	sanitize_skills()
	sanitize_items()
	sanitize_stats()
	sanitize_traits()
	sanitize_skills()
	sanitize_items()
	sanitize_stats()

/datum/tat_build/proc/reset_build()
	reset_stats()
	reset_skills()
	reset_traits()
	reset_items()
	dirty = TRUE

/datum/tat_build/proc/reset_stats()
	stats = list()
	dirty = TRUE

/datum/tat_build/proc/reset_skills()
	skills = list()
	dirty = TRUE

/datum/tat_build/proc/reset_traits()
	traits = list()
	dirty = TRUE

/datum/tat_build/proc/reset_items()
	items = list()
	dirty = TRUE

/datum/tat_build/proc/add_stat(id, amount = 1)
	if(!id || !isnum(amount) || !(id in available_stats))
		return FALSE
	amount = round(amount)
	if(amount <= 0) return FALSE
	var/current = get_stat_value(id)
	var/new_value = current + amount
	if(new_value > get_stat_max(id)) return FALSE
	var/old_delta = get_stat_point_delta_for_value(id, current)
	var/new_delta = get_stat_point_delta_for_value(id, new_value)
	if(get_remaining_stat_points() < (new_delta - old_delta))
		return FALSE
	set_stat_value(id, new_value)
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_stat(id, amount = 1)
	if(!id || !isnum(amount) || !(id in available_stats))
		return FALSE
	amount = round(amount)
	if(amount <= 0) return FALSE
	var/current = get_stat_value(id)
	var/new_value = current - amount
	if(new_value < get_stat_min(id)) return FALSE
	set_stat_value(id, new_value)
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/add_skill(skill_type, amount = 1)
	if(!ispath(skill_type) || !isnum(amount) || !(skill_type in available_skills))
		return FALSE
	amount = round(amount)
	if(amount <= 0) return FALSE
	var/current = get_skill_value(skill_type)
	var/new_value = current + amount
	if(new_value > get_skill_cap(skill_type)) return FALSE
	var/cost = 0
	for(var/i in 1 to amount)
		cost += current + i
	if(get_remaining_skill_points() < cost) return FALSE
	skills[skill_type] = new_value
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_skill(skill_type, amount = 1)
	if(!ispath(skill_type) || !isnum(amount) || !(skill_type in available_skills))
		return FALSE
	amount = round(amount)
	if(amount <= 0) return FALSE
	var/current = get_skill_value(skill_type)
	if(current <= 0) return FALSE
	var/new_value = max(0, current - amount)
	if(new_value > 0)
		skills[skill_type] = new_value
	else
		skills -= skill_type
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/add_trait(trait_id)
	if(!trait_id || !(trait_id in available_traits) || trait_id in traits)
		return FALSE
	if(trait_id == TAT_TRAIT_WARRIOR_MASTER && !(TAT_TRAIT_WARRIOR_EXPERT in traits))
		return FALSE
	if(get_remaining_trait_points() < get_trait_cost(trait_id))
		return FALSE
	traits += trait_id
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_trait(trait_id)
	if(!trait_id || !(trait_id in traits))
		return FALSE
	if(trait_id == TAT_TRAIT_WARRIOR_EXPERT && (TAT_TRAIT_WARRIOR_MASTER in traits))
		return FALSE
	traits -= trait_id

	if(!(TAT_TRAIT_BRONZE_SUPPLIER in traits))
		remove_items_by_unlock("weapon_supply", "bronze")
	if(!(TAT_TRAIT_SILVER_SUPPLIER in traits))
		remove_items_by_unlock("weapon_supply", "silver")
	if(!(TAT_TRAIT_STEEL_SUPPLIER in traits))
		remove_items_by_unlock("weapon_supply", "steel")
	if(!(TAT_TRAIT_LEATHER_SUPPLIER in traits))
		remove_items_by_unlock("armor_family", "leather")
	if(!(TAT_TRAIT_MAIL_SUPPLIER in traits))
		remove_items_by_unlock("armor_family", "mail")
	if(!(TAT_TRAIT_PLATE_SUPPLIER in traits))
		remove_items_by_unlock("armor_family", "plate")

	for(var/skill_type in skills.Copy())
		var/cap = get_skill_cap(skill_type)
		if(get_skill_value(skill_type) > cap)
			if(cap > 0)
				skills[skill_type] = cap
			else
				skills -= skill_type
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/add_item(path, amount = 1)
	if(!ispath(path) || !isnum(amount) || !(path in available_items))
		return FALSE
	amount = round(amount)
	if(amount <= 0) return FALSE
	var/list/entry = available_items[path]
	if(!can_use_item_entry(entry)) return FALSE
	var/cost = get_item_cost(path) * amount
	if(get_remaining_item_points() < cost) return FALSE
	items[path] = (items[path] || 0) + amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_item(path, amount = 1)
	if(!ispath(path) || !isnum(amount) || !(path in items))
		return FALSE
	amount = round(amount)
	if(amount <= 0) return FALSE
	var/current = items[path] - amount
	if(current > 0)
		items[path] = current
	else
		items -= path
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/validate_for_save()
	sanitize_build()
	return !has_invalid_trait_dependencies() && !has_invalid_supply_items() && is_budget_valid()

/datum/tat_build/proc/can_save()
	return validate_for_save()

/datum/tat_build/proc/export_to_list()
	return list(
		"stats" = stats.Copy(),
		"skills" = skills.Copy(),
		"traits" = traits.Copy(),
		"items" = items.Copy(),
	)

/datum/tat_build/proc/load_from_list(list/L)
	reset_build()
	if(!islist(L))
		dirty = FALSE
		return

	var/list/_stats = L["stats"]
	var/list/_skills = L["skills"]
	var/list/_traits = L["traits"]
	var/list/_items = L["items"]

	if(islist(_stats))
		for(var/stat_id in available_stats)
			if(isnum(_stats[stat_id]))
				set_stat_value(stat_id, _stats[stat_id])

	if(islist(_traits))
		for(var/trait_id in _traits)
			if(trait_id in available_traits && !(trait_id in traits))
				traits += trait_id

	if(islist(_skills))
		for(var/skill_type in _skills)
			if(ispath(skill_type) && isnum(_skills[skill_type]) && (skill_type in available_skills))
				var/value = round(_skills[skill_type])
				if(value > 0)
					skills[skill_type] = value

	if(islist(_items))
		for(var/item_path in _items)
			if(ispath(item_path) && isnum(_items[item_path]) && (item_path in available_items))
				var/value = round(_items[item_path])
				if(value > 0)
					items[item_path] = value

	sanitize_build()
	dirty = FALSE

/datum/tat_build/proc/apply_stats(mob/living/carbon/human/H)
	if(!H) return
	for(var/stat_id in available_stats)
		var/base = get_stat_base(stat_id)
		var/value = get_stat_value(stat_id)
		var/diff = value - base
		if(diff)
			H.change_stat(stat_id, diff)

/datum/tat_build/proc/apply_skills(mob/living/carbon/human/H)
	if(!H) return
	for(var/skill_type in skills)
		var/level = skills[skill_type]
		if(level > 0)
			H.adjust_skillrank(skill_type, level, TRUE)

/datum/tat_build/proc/apply_traits(mob/living/carbon/human/H)
	if(!H) return
	for(var/trait_id in traits)
		switch(trait_id)
			if(TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_WARRIOR_MASTER, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_RONIN, TAT_TRAIT_RESIDENT, TAT_TRAIT_STEEL_SUPPLIER, TAT_TRAIT_SILVER_SUPPLIER, TAT_TRAIT_BRONZE_SUPPLIER, TAT_TRAIT_LEATHER_SUPPLIER, TAT_TRAIT_MAIL_SUPPLIER, TAT_TRAIT_PLATE_SUPPLIER, TAT_TRAIT_SPELLBLADE)
				continue
			else
				ADD_TRAIT(H, trait_id, TAT_TRAIT_SOURCE)

	if(TAT_TRAIT_RESIDENT in traits)
		ADD_TRAIT(H, TRAIT_RESIDENT, TAT_TRAIT_SOURCE)

	if(TAT_TRAIT_SPELLBLADE in traits)
		ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	if(TAT_TRAIT_SOUNDBREAKER in traits)
		H.LoadComponent(/datum/component/combo_core/soundbreaker)
	if(TAT_TRAIT_RONIN in traits)
		H.LoadComponent(/datum/component/combo_core/ronin)

/datum/tat_build/proc/apply_items(mob/living/carbon/human/H)
	if(!H) return
	var/turf/T = get_turf(H)
	for(var/path in items)
		var/amount = items[path]
		for(var/i in 1 to amount)
			new path(T)

/datum/tat_build/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H) return
	sanitize_build()
	apply_stats(H)
	apply_skills(H)
	apply_traits(H)
	apply_items(H)

/datum/tat_build/ui_state(mob/user)
	return GLOB.always_state

/datum/tat_build/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TATBuild")
		ui.open()

/datum/tat_build/ui_static_data(mob/user)
	return list()

/datum/tat_build/ui_data(mob/user)
	return list(
		"stats" = build_ui_stats(),
		"skills" = build_ui_skills(),
		"traits" = traits.Copy(),
		"trait_entries" = build_ui_traits(),
		"items" = build_ui_items(),
		"available_stats" = available_stats,
		"available_skills" = build_ui_skills(),
		"available_traits" = build_ui_traits(),
		"available_items" = build_ui_items(),
		"points_stats" = points_stats,
		"points_stats_remaining" = get_remaining_stat_points(),
		"points_skills" = points_skills,
		"points_skills_remaining" = get_remaining_skill_points(),
		"points_traits" = points_traits,
		"points_traits_remaining" = get_remaining_trait_points(),
		"points_items" = points_items,
		"points_items_remaining" = get_remaining_item_points(),
		"can_save" = can_save(),
		"dirty" = dirty,
	)

/datum/tat_build/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("add_stat") return add_stat(params["id"], text2num(params["amount"]) || 1)
		if("remove_stat") return remove_stat(params["id"], text2num(params["amount"]) || 1)
		if("add_skill") return add_skill(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("remove_skill") return remove_skill(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("add_trait") return add_trait(params["id"])
		if("remove_trait") return remove_trait(params["id"])
		if("add_item") return add_item(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("remove_item") return remove_item(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("reset_all")
			reset_build()
			return TRUE
		if("reset_stats")
			reset_stats()
			return TRUE
		if("reset_skills")
			reset_skills()
			return TRUE
		if("reset_traits")
			reset_traits()
			return TRUE
		if("reset_items")
			reset_items()
			return TRUE
		if("save")
			if(!can_save())
				return FALSE
			dirty = FALSE
			return TRUE
	return FALSE

#undef TAT_TRAIT_SOURCE

/datum/preferences/proc/sanitize_tat_build(list/tat_data)
	if(!tat_build)
		tat_build = new()

	if(!islist(tat_data))
		tat_build.reset_build()
		tat_build.dirty = FALSE
		return

	tat_build.load_from_list(tat_data)
	tat_build.dirty = FALSE
