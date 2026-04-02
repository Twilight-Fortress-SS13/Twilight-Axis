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

		var/datum/skill/S = new path
		if(initial(S.abstract_type) == path)
			qdel(S)
			continue

		available_skills[path] = list(
			"name" = initial(S.name),
			"desc" = initial(S.desc),
			"category" = "[initial(S.abstract_type)]",
			"is_combat" = ispath(path, /datum/skill/combat),
		)
		qdel(S)

/datum/tat_build/proc/init_available_traits()
	available_traits = list(
		TRAIT_NOSTINK = list("name" = "Dead Nose", "cost" = 2),
		TRAIT_PSYCHOSIS = list("name" = "Psychosis", "cost" = 2),
		TRAIT_EMPATH = list("name" = "Empath", "cost" = 2),
		TRAIT_OUTLANDER = list("name" = "Outlander", "cost" = 2),
		TRAIT_DECEIVING_MEEKNESS = list("name" = "Deceiving Meekness", "cost" = 2),
		TRAIT_GOODLOVER = list("name" = "Fabled Lover", "cost" = 2),
		TRAIT_NUTCRACKER = list("name" = "Nutcracker", "cost" = 2),
		TRAIT_STEELHEARTED = list("name" = "Steelhearted", "cost" = 2),
		TRAIT_MARRIAGE_CAPABLE = list("name" = "Marriage Capable", "cost" = 1),
		TRAIT_NASTY_EATER = list("name" = "Inhumen Digestion", "cost" = 2),
		TRAIT_CAUTIOUS_FISHER = list("name" = "Cautious Fisher", "cost" = 1),
		TRAIT_WITCH = list("name" = "They fear me, but I am useful to them", "cost" = 3),
		TRAIT_DEATHSIGHT = list("name" = "Veiled Whispers", "cost" = 2),

		TRAIT_NOBLE = list("name" = "Noble Blooded", "cost" = 2),
		TRAIT_INTELLECTUAL = list("name" = "Intellectual", "cost" = 2),
		TRAIT_PURITAN_ADVENTURER = list("name" = "Interrogator", "cost" = 2),
		TRAIT_SEEDKNOW = list("name" = "Seed Knower", "cost" = 1),
		TRAIT_HOMESTEAD_EXPERT = list("name" = "Expert Homesteader", "cost" = 3),
		TRAIT_SURVIVAL_EXPERT = list("name" = "Expert Survivalist", "cost" = 3),
		TRAIT_SEWING_EXPERT = list("name" = "Expert Clothier", "cost" = 3),
		TRAIT_CICERONE = list("name" = "Cicerone", "cost" = 1),
		TRAIT_KEENEARS = list("name" = "Keen Ears", "cost" = 1),
		TRAIT_SEEPRICES = list("name" = "Appraiser", "cost" = 1),

		TRAIT_DARKVISION = list("name" = "Darksight", "cost" = 2),
		TRAIT_JACKOFALLTRADES = list("name" = "Jack of All Trades", "cost" = 4),
		TRAIT_TRAINED_SMITH = list("name" = "Trained Smith", "cost" = 2),
		TRAIT_SMITHING_EXPERT = list("name" = "Expert Forgehand", "cost" = 3),

		TRAIT_GRAVEROBBER = list("name" = "Experienced Grave Robber", "cost" = 2),
		TRAIT_FENCERDEXTERITY = list("name" = "Fencer's Dexterity", "cost" = 3),
		TRAIT_ALCHEMY_EXPERT = list("name" = "Expert Alchemist", "cost" = 3),
		TRAIT_MEDICINE_EXPERT = list("name" = "Expert Physicker", "cost" = 3),

		TRAIT_DODGEEXPERT = list("name" = "Expert Dodger", "cost" = 3),
		TRAIT_PARRYEXPERT = list("name" = "Expert Parry", "cost" = 3),

		TRAIT_HEAVYARMOR = list("name" = "Plate Training", "cost" = 2),
		TRAIT_MEDIUMARMOR = list("name" = "Maille Training", "cost" = 2),

		TRAIT_SQUIRE_REPAIR = list("name" = "Squire Knowledge", "cost" = 1),
		TRAIT_BLOOD_RESISTANCE = list("name" = "Thick Blooded", "cost" = 2),

		TRAIT_CIVILIZEDBARBARIAN = list("name" = "Expert Pugilist", "cost" = 3),
		TRAIT_NOPAINSTUN = list("name" = "Enduring", "cost" = 2),
		TRAIT_CRITICAL_RESISTANCE = list("name" = "Critical Resistance", "cost" = 3),
		TRAIT_HARDDISMEMBER = list("name" = "Hard Dismemberment", "cost" = 2),
		TRAIT_ARCYNE = list("name" = "Arcyne Training", "cost" = 2),
		TRAIT_EXPLOSIVE_SUPPLY = list("name" = "Explosive Supply", "cost" = 2),

		TAT_TRAIT_SOUNDBREAKER = list("name" = "Soundbreaker", "cost" = 4),
		TAT_TRAIT_RONIN = list("name" = "Ronin", "cost" = 4),
		TAT_TRAIT_WARRIOR_EXPERT = list("name" = "Expert Warrior", "cost" = 3),
		TAT_TRAIT_WARRIOR_MASTER = list("name" = "Master Warrior", "cost" = 4),
		TAT_TRAIT_RESIDENT = list("name" = "Resident", "cost" = 3),

		TAT_TRAIT_STEEL_SUPPLIER = list("name" = "Steel Supplier", "cost" = 2),
		TAT_TRAIT_SILVER_SUPPLIER = list("name" = "Silver Supplier", "cost" = 2),
		TAT_TRAIT_BRONZE_SUPPLIER = list("name" = "Bronze Supplier", "cost" = 1),
		TAT_TRAIT_SPELLBLADE = list("name" = "Spellblade", "cost" = 4),
	)

/datum/tat_build/proc/init_available_items()
	available_items = list(
		// IRON BASE
		/obj/item/rogueweapon/sword/iron = list("name" = "Iron Arming Sword", "cost" = 2, "material" = "iron"),
		/obj/item/rogueweapon/sword/short = list("name" = "Shortsword", "cost" = 2, "material" = "iron"),
		/obj/item/rogueweapon/mace = list("name" = "Mace", "cost" = 2, "material" = "iron"),
		/obj/item/rogueweapon/spear = list("name" = "Spear", "cost" = 2, "material" = "iron"),
		/obj/item/rogueweapon/huntingknife = list("name" = "Knife", "cost" = 1, "material" = "iron"),
		/obj/item/rogueweapon/shield/wood = list("name" = "Wooden Shield", "cost" = 1, "material" = "iron"),
		/obj/item/rogueweapon/sword/rapier = list("name" = "Rapier", "cost" = 2, "material" = "iron"),
		/obj/item/rogueweapon/sword/sabre = list("name" = "Sabre", "cost" = 2, "material" = "iron"),
		/obj/item/rogueweapon/sword/long = list("name" = "Longsword", "cost" = 3, "material" = "iron"),
		/obj/item/rogueweapon/sword/sabre/mulyeog = list("name" = "Hwando", "cost" = 3, "material" = "iron"),
		/obj/item/rogueweapon/spear/spellblade = list("name" = "Dory", "cost" = 2, "material" = "iron"),
		/obj/item/rogueweapon/spear/naginata = list("name" = "Naginata", "cost" = 3, "material" = "iron"),
		/obj/item/rogueweapon/mace/warhammer = list("name" = "Warhammer", "cost" = 3, "material" = "iron"),

		// BRONZE
		/obj/item/rogueweapon/katar/bronze = list("name" = "Bronze Katar", "cost" = 2, "material" = "bronze"),
		/obj/item/clothing/gloves/roguetown/knuckles/bronze = list("name" = "Bronze Knuckledusters", "cost" = 2, "material" = "bronze"),

		// STEEL
		/obj/item/rogueweapon/huntingknife/idagger/steel = list("name" = "Steel Dagger", "cost" = 3, "material" = "steel")
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

/datum/tat_build/proc/get_spent_stat_points()
	var/total = 0
	for(var/stat_id in available_stats)
		var/current = get_stat_value(stat_id)
		var/base = get_stat_base(stat_id)
		var/diff = current - base
		if(diff > 0)
			total += diff * get_stat_cost(stat_id)
	return total

/datum/tat_build/proc/get_remaining_stat_points()
	return points_stats - get_spent_stat_points()

/datum/tat_build/proc/build_ui_stats()
	var/list/result = list()
	for(var/stat_id in available_stats)
		result[stat_id] = get_stat_value(stat_id)
	return result

/datum/tat_build/proc/get_skill_entry(skill_type)
	if(!ispath(skill_type))
		return null
	if(!(skill_type in available_skills))
		return null
	return available_skills[skill_type]

/datum/tat_build/proc/get_skill_value(skill_type)
	if(skill_type in skills)
		return skills[skill_type]
	return 0

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
		)

	return result

/datum/tat_build/proc/get_trait_cost(trait_id)
	if(!(trait_id in available_traits))
		return 0
	var/list/entry = available_traits[trait_id]
	return isnum(entry["cost"]) ? entry["cost"] : 0

/datum/tat_build/proc/get_spent_trait_points()
	var/total = 0
	for(var/trait_id in traits)
		total += get_trait_cost(trait_id)
	return total

/datum/tat_build/proc/get_remaining_trait_points()
	return points_traits - get_spent_trait_points()

/datum/tat_build/proc/get_item_entry(item_path)
	if(!ispath(item_path))
		return null
	if(!(item_path in available_items))
		return null
	return available_items[item_path]

/datum/tat_build/proc/get_item_cost(item_path)
	var/list/entry = get_item_entry(item_path)
	if(!islist(entry))
		return 0
	return isnum(entry["cost"]) ? entry["cost"] : 0

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

/datum/tat_build/proc/can_use_material(material)
	switch(material)
		if("iron")
			return TRUE
		if("bronze")
			return (TAT_TRAIT_BRONZE_SUPPLIER in traits)
		if("steel")
			return (TAT_TRAIT_STEEL_SUPPLIER in traits)
		if("silver")
			return (TAT_TRAIT_SILVER_SUPPLIER in traits)
	return FALSE

/datum/tat_build/proc/build_ui_items()
	var/list/result = list()

	for(var/item_path in available_items)
		var/list/entry = available_items[item_path]
		var/material = entry["material"]
		var/unlocked = can_use_material(material)

		result["[item_path]"] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"material" = material,
			"amount" = (items[item_path] || 0),
			"unlocked" = unlocked,
		)

	return result

/datum/tat_build/proc/reset_build()
	reset_stats()
	reset_skills()
	reset_traits()
	reset_items()
	dirty = TRUE

/datum/tat_build/proc/reset_stats()
	stats = list()
	for(var/stat_id in available_stats)
		stats[stat_id] = get_stat_base(stat_id)
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
	if(!id || !isnum(amount))
		return FALSE
	if(!(id in available_stats))
		return FALSE

	amount = round(amount)
	if(amount <= 0)
		return FALSE

	var/current = get_stat_value(id)
	var/max_value = get_stat_max(id)
	var/cost = get_stat_cost(id) * amount

	if(current + amount > max_value)
		return FALSE
	if(get_remaining_stat_points() < cost)
		return FALSE

	stats[id] = current + amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_stat(id, amount = 1)
	if(!id || !isnum(amount))
		return FALSE
	if(!(id in available_stats))
		return FALSE

	amount = round(amount)
	if(amount <= 0)
		return FALSE

	var/current = get_stat_value(id)
	var/min_value = get_stat_min(id)

	if(current - amount < min_value)
		return FALSE

	stats[id] = current - amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/add_skill(skill_type, amount = 1)
	if(!ispath(skill_type) || !isnum(amount))
		return FALSE
	if(!(skill_type in available_skills))
		return FALSE

	amount = round(amount)
	if(amount <= 0)
		return FALSE

	var/current = get_skill_value(skill_type)
	var/cap = get_skill_cap(skill_type)

	if(current + amount > cap)
		return FALSE

	var/cost = 0
	for(var/i in 1 to amount)
		cost += current + i

	if(get_remaining_skill_points() < cost)
		return FALSE

	skills[skill_type] = current + amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_skill(skill_type, amount = 1)
	if(!ispath(skill_type) || !isnum(amount))
		return FALSE
	if(!(skill_type in available_skills))
		return FALSE

	amount = round(amount)
	if(amount <= 0)
		return FALSE

	var/current = get_skill_value(skill_type)
	if(current <= 0)
		return FALSE

	var/new_value = max(0, current - amount)

	if(new_value > 0)
		skills[skill_type] = new_value
	else
		skills -= skill_type

	dirty = TRUE
	return TRUE

/datum/tat_build/proc/add_trait(trait_id)
	if(!trait_id)
		return FALSE
	if(!(trait_id in available_traits))
		return FALSE
	if(trait_id in traits)
		return FALSE

	if(trait_id == TAT_TRAIT_WARRIOR_MASTER && !(TAT_TRAIT_WARRIOR_EXPERT in traits))
		return FALSE

	var/cost = get_trait_cost(trait_id)
	if(get_remaining_trait_points() < cost)
		return FALSE

	traits += trait_id
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_trait(trait_id)
	if(!trait_id)
		return FALSE
	if(!(trait_id in traits))
		return FALSE

	if(trait_id == TAT_TRAIT_WARRIOR_EXPERT && (TAT_TRAIT_WARRIOR_MASTER in traits))
		return FALSE

	traits -= trait_id

	if(!(TAT_TRAIT_BRONZE_SUPPLIER in traits))
		remove_items_by_material("bronze")
	if(!(TAT_TRAIT_STEEL_SUPPLIER in traits))
		remove_items_by_material("steel")
	if(!(TAT_TRAIT_SILVER_SUPPLIER in traits))
		remove_items_by_material("silver")

	for(var/skill_type in skills.Copy())
		if(get_skill_value(skill_type) > get_skill_cap(skill_type))
			skills[skill_type] = get_skill_cap(skill_type)

	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_items_by_material(material)
	for(var/item_path in items.Copy())
		var/list/entry = get_item_entry(item_path)
		if(!islist(entry))
			continue
		if(entry["material"] == material)
			items -= item_path

/datum/tat_build/proc/add_item(path, amount = 1)
	if(!ispath(path) || !isnum(amount))
		return FALSE
	if(!(path in available_items))
		return FALSE

	amount = round(amount)
	if(amount <= 0)
		return FALSE

	var/list/entry = available_items[path]
	var/material = entry["material"]

	if(!can_use_material(material))
		return FALSE

	var/cost = get_item_cost(path) * amount
	if(get_remaining_item_points() < cost)
		return FALSE

	items[path] = (items[path] || 0) + amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_item(path, amount = 1)
	if(!ispath(path) || !isnum(amount))
		return FALSE
	if(!(path in items))
		return FALSE

	amount = round(amount)
	if(amount <= 0)
		return FALSE

	var/current = items[path]
	current -= amount

	if(current > 0)
		items[path] = current
	else
		items -= path

	dirty = TRUE
	return TRUE

/datum/tat_build/proc/apply_stats(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/stat_id in available_stats)
		var/base = get_stat_base(stat_id)
		var/value = get_stat_value(stat_id)
		var/diff = value - base
		if(diff)
			H.change_stat(stat_id, diff)

/datum/tat_build/proc/apply_skills(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/skill_type in skills)
		var/level = skills[skill_type]
		if(level > 0)
			H.adjust_skillrank(skill_type, level, TRUE)

/datum/tat_build/proc/apply_traits(mob/living/carbon/human/H)
	if(!H)
		return

	for(var/trait_id in traits)
		switch(trait_id)
			if(TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_WARRIOR_MASTER, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_RONIN, TAT_TRAIT_RESIDENT, TAT_TRAIT_STEEL_SUPPLIER, TAT_TRAIT_SILVER_SUPPLIER, TAT_TRAIT_BRONZE_SUPPLIER, TAT_TRAIT_SPELLBLADE)
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
		if(H.LoadComponent(/datum/component/combo_core/soundbreaker))
			; // компонент загрузится сам, если поддерживается кодовой базой

	if(TAT_TRAIT_RONIN in traits)
		if(H.LoadComponent(/datum/component/combo_core/ronin))
			; // аналогично, если уже реализовано в проекте

/datum/tat_build/proc/apply_items(mob/living/carbon/human/H)
	if(!H)
		return
	var/turf/T = get_turf(H)
	for(var/path in items)
		var/amount = items[path]
		for(var/i in 1 to amount)
			new path(T)

/datum/tat_build/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return
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
	return list(
		"available_stats" = available_stats,
		"available_skills" = build_ui_skills(),
		"available_traits" = available_traits,
		"available_items" = build_ui_items(),
	)

/datum/tat_build/ui_data(mob/user)
	return list(
		"stats" = build_ui_stats(),
		"skills" = build_ui_skills(),
		"traits" = traits.Copy(),
		"items" = build_ui_items(),
		"points_stats" = points_stats,
		"points_stats_remaining" = get_remaining_stat_points(),
		"points_skills" = points_skills,
		"points_skills_remaining" = get_remaining_skill_points(),
		"points_traits" = points_traits,
		"points_traits_remaining" = get_remaining_trait_points(),
		"points_items" = points_items,
		"points_items_remaining" = get_remaining_item_points(),
		"dirty" = dirty,
	)

/datum/tat_build/ui_act(action, list/params)
	. = ..()
	switch(action)
		if("add_stat")
			add_stat(params["id"], text2num(params["amount"]))
		if("remove_stat")
			remove_stat(params["id"], text2num(params["amount"]) || 1)

		if("add_skill")
			add_skill(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("remove_skill")
			remove_skill(text2path(params["path"]), text2num(params["amount"]) || 1)

		if("add_trait")
			add_trait(params["id"])
		if("remove_trait")
			remove_trait(params["id"])

		if("add_item")
			add_item(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("remove_item")
			remove_item(text2path(params["path"]), text2num(params["amount"]) || 1)

		if("reset_all")
			reset_build()
		if("reset_stats")
			reset_stats()
		if("reset_skills")
			reset_skills()
		if("reset_traits")
			reset_traits()
		if("reset_items")
			reset_items()

	return TRUE

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
				var/value = round(_stats[stat_id])
				value = clamp(value, get_stat_min(stat_id), get_stat_max(stat_id))
				stats[stat_id] = value

	if(islist(_traits))
		for(var/trait_id in _traits)
			if(available_traits[trait_id])
				if(!(trait_id in traits))
					traits += trait_id

	if(islist(_skills))
		for(var/skill_type in _skills)
			if(ispath(skill_type) && isnum(_skills[skill_type]) && (skill_type in available_skills))
				var/value = round(_skills[skill_type])
				value = clamp(value, 0, get_skill_cap(skill_type))
				if(value > 0)
					skills[skill_type] = value

	if(islist(_items))
		for(var/item_path in _items)
			if(ispath(item_path) && isnum(_items[item_path]) && (item_path in available_items))
				var/list/entry = available_items[item_path]
				if(can_use_material(entry["material"]))
					var/value = round(_items[item_path])
					if(value > 0)
						items[item_path] = value

	dirty = FALSE

/datum/tat_build/proc/export_to_list()
	return list(
		"stats" = stats.Copy(),
		"skills" = skills.Copy(),
		"traits" = traits.Copy(),
		"items" = items.Copy(),
	)

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
