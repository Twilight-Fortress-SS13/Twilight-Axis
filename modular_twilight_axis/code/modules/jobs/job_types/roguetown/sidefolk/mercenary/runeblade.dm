/datum/advclass/mercenary/twilight_runeblade
	name = "Gronn Runeblade"
	tutorial = "Coming from the northern lands of Grimmoria, the Runeblades are masters of the Runes, holding knowledge of exotic ones, that helps them to survive in the wild and brings victory over their foes."
	allowed_sexes = list(MALE)
	allowed_races = list(/datum/species/human)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_runeblade
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 1
	cmode_music = 'modular_twilight_axis/sound/music/combat_tabaxi.ogg'
	subclass_languages = list(/datum/language/raneshi)
	traits_applied = list(TRAIT_RUNEMASTER, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_STR = 2
	)

	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE
	)
	extra_context = "This subclass is race-limited to: Human Male Only."

/datum/outfit/job/roguetown/mercenary/twilight_runeblade/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("It was a long journey to this country, but the one, who knows the magic older than bricks, that town was build from, but you finaly arrived to brind more glory to skills that you mastered in years on wild north."))
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen/new_coat
	cloak = /obj/item/clothing/cloak/twilight_desert
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/shalal
	neck = 	/obj/item/clothing/neck/roguetown/leather
	mask = /obj/item/clothing/mask/rogue/facemask/steel/miragefen_rogue
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	H.merctype = 2
	H.AddComponent(/datum/component/combo_core/runeblade, 30 SECONDS, 3, 3)
