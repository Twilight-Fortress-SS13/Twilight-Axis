/datum/advclass/wretch/warlock
	name = "Warlock"
	tutorial = "You are a wretched spellcaster who binds cursed flame and killing frost into one profane art. \
	Your sorcery grows stronger as you remain within one elemental path, yet its true power blooms when you turn that gathered force against the opposite school. \
	Between fire, frost, and the unnatural union of both, you become a walking blight upon the world."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	maximum_possible_slots = 2
	category_tags = list(CTAG_WRETCH)
	class_select_category = CLASS_CAT_MAGE

	traits_applied = list(
		TRAIT_NOSTINK,
		TRAIT_OUTDOORSMAN
	)

	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE
	)

	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_CON = -1,
		STATKEY_STR = -2
	)

	outfit = /datum/outfit/job/roguetown/wretch/warlock


/datum/outfit/job/roguetown/wretch/warlock/pre_equip(mob/living/carbon/human/H)
	..()

	head = /obj/item/clothing/head/roguetown/wizhat
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern

	backpack_contents = list(
		/obj/item/recipe_book/survival = 1,
	)

	to_chat(H, span_warning("You are a Warlock — a wielder of cursed flame and killing frost."))
	to_chat(H, span_notice("You gather power through one school, then consume it through the other in bursts of unnatural magic."))

	if(H.mind)
		H.AddComponent(/datum/component/spell_proc/warlock)
