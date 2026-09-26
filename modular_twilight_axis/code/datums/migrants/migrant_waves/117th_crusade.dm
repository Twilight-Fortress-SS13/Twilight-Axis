#define CTAG_CRUSADER "crusader"
#define CTAG_CRUSADE_CAPTAIN "crusade_captain"
#define CTAG_CRUSADE_CLERIC "crusade_cleric"
#define CTAG_CRUSADE_PALADIN "crusade_paladin"

/datum/migrant_wave/crusade
	name = "The 117th Holy Crusade"
	track = MIGRANT_TRACK_SPECIAL
	weight = 6
	min_round_time = 40 MINUTES
	min_pop = 45
	max_spawns = 1
	triumph_threshold = 100
	triumph_weight_multiplier = 4
	required_roles = list(
		/datum/migrant_role/crusade_captain = 1
	)
	optional_roles = list(
		/datum/migrant_role/crusade_cleric = 1,
		/datum/migrant_role/crusade_paladin = 2,
		/datum/migrant_role/crusader = 2,
	)
	greet_text = "Divine Order sweeps trough the lands, claiming the land for the one true faith! Your order came from the Valoria to bring Astratan radiant light, and a little fortune for yourself."

/datum/migrant_role/crusader
	name = "117th Crusader"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	greet_text = "Crusader of the true faith, your order came from Valoria on a crusade to bring divine order in this sun-forsaken lands. For the glory of astrata!"
	advclass_cat_rolls = list(CTAG_CRUSADER = 20)

/datum/migrant_role/crusade_captain
	name = "117th Crusade Captain"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	greet_text = "Crusade Leader of the true faith, your order came from Valoria on a crusade to bring divine order in this sun-forsaken lands. For the glory of astrata!"
	advclass_cat_rolls = list(CTAG_CRUSADE_CAPTAIN = 20)

/datum/migrant_role/crusade_cleric
	name = "117th Crusade Cleric"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	greet_text = "Zealous believer of the true faith, your order came from Valoria on a crusade to bring divine order in this sun-forsaken lands. For the glory of astrata!"
	advclass_cat_rolls = list(CTAG_CRUSADE_CLERIC = 20)

/datum/migrant_role/crusade_paladin
	name = "117th Crusade Paladin"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	greet_text = "Stallwart warrior of the true faith, your order came from Valoria on a crusade to bring divine order in this sun-forsaken lands. For the glory of astrata!"
	advclass_cat_rolls = list(CTAG_CRUSADE_PALADIN = 20)

/datum/advclass/crusade
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	category_tags = list(CTAG_DISABLED)
	min_pq = 0
	traits_applied = list(TRAIT_STEELHEARTED)
	subclass_languages = list(/datum/language/valorian)
	origin_limits = list(/datum/virtue/origin/valorian)

/datum/advclass/crusade/crusader_captain
	name = "Crusader Captain"
	tutorial = "Crusade Leader of the true faith, you came from Valoria on a crusade to bring divine order in this forsaken lands. For the glory of astrata!"
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/roguetown/crusader/captain
	cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	min_pq = 40
	category_tags = list(CTAG_CRUSADER)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_SPD = -1,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)

	subclass_stashed_items = list(
	"Armor Plates" =	/obj/item/repair_kit/metal
	)

/datum/outfit/job/roguetown/crusader/captain/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/divine/astrata)))	//astratan crusade
		to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
		H.set_patron(/datum/patron/divine/astrata)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm/cleric
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver/astrata
	cloak = /obj/item/clothing/cloak/templar/astratancleric
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/plate
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/platelegs
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

/datum/advclass/crusade/crusader_cleric
	name = "Crusader Cleric"
	tutorial = "Cleric of the true faith, you came from Valoria on a crusade to bring divine order in this forsaken lands. For the glory of astrata!"
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/roguetown/crusader/cleric
	cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_RITUALIST)
	min_pq = 30
	category_tags = list(CTAG_CRUSADE_CLERIC)

	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
	)

	subclass_stashed_items = list(
	"Armor Plates" =	/obj/item/repair_kit/metal
	)

/datum/outfit/job/roguetown/crusader/cleric/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
	head = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/templar/astratancleric
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	beltr = /obj/item/storage/belt/rogue/surgery_bag/full
	r_hand = /obj/item/rogueweapon/sword
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/cloak/tabard/crusader/astrata
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 3,
		/obj/item/needle/pestra = 1,
		/obj/item/ritechalk = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_4)	//Capped to T3 miracles.

// Old loadout, heavy armor, T2, but worse stats.

/datum/advclass/crusade/crusader_paladin
	name = "Crusader Paladin"
	tutorial = "Paladin of the true faith, you came from Valoria on a crusade to bring divine order in this forsaken lands. For the glory of astrata!"
	maximum_possible_slots = 2
	outfit = /datum/outfit/job/roguetown/crusader/paladin
	cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_BADTRAINER)
	min_pq = 30
	category_tags = list(CTAG_CRUSADE_PALADIN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

	subclass_stashed_items = list(
	"Armor Plates" =	/obj/item/repair_kit/metal
	)

/datum/outfit/job/roguetown/crusader/paladin/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/divine/astrata)))	//astratan crusade
		to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
		H.set_patron(/datum/patron/divine/astrata)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/templar/astratancleric
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/plate
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/platelegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/mace/steel/holyseemace/sunburst
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

// Footman. Heavy armor essentially old loadout. Loses T2, but gets heavy armor.

/datum/advclass/crusade/crusader_footman
	name = "Crusader Footman"
	tutorial = "Heavily-armoured warrior of the true faith, you came from Valoria on a crusade to bring divine order in this forsaken lands. For the glory of astrata!"
	outfit = /datum/outfit/job/roguetown/crusader/footman
	cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	min_pq = 20
	category_tags = list(CTAG_CRUSADER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

	subclass_stashed_items = list(
	"Armor Plates" =	/obj/item/repair_kit/metal
	)

/datum/outfit/job/roguetown/crusader/footman/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/divine/astrata)))	//astratan crusade
		to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
		H.set_patron(/datum/patron/divine/astrata)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/templar/astratancleric
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/short
	l_hand = /obj/item/rogueweapon/spear/boar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_0)	//Capped to T0 miracles.

/datum/advclass/crusade/crusader_marksman
	name = "Crusader Marksman"
	tutorial = "Sureshot of the true faith, you came from Valoria on a crusade to bring divine order in this forsaken lands. For the glory of astrata!"
	outfit = /datum/outfit/job/roguetown/crusader/marksman
	cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	min_pq = 20
	category_tags = list(CTAG_CRUSADER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

	subclass_stashed_items = list(
	"Armor Plates" =	/obj/item/repair_kit/metal
	)

/datum/outfit/job/roguetown/crusader/marksman/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/divine/astrata)))	//astratan crusade
		to_chat(H, span_warning("Astrata, the Absolute Order of the lands embraces me; We shall take what is rightfully ours, For she wills it."))
		H.set_patron(/datum/patron/divine/astrata)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/templar/astratancleric
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/short
	beltl = /obj/item/quiver/bolt/standard
	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_0)	//Capped to T0 miracles.

#undef CTAG_CRUSADER
#undef CTAG_CRUSADE_CAPTAIN
#undef CTAG_CRUSADE_CLERIC
