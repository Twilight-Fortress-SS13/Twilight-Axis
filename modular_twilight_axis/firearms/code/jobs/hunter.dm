/datum/advclass/twilight_hunter
	name = "Blackpowder Hunter"
	tutorial = "As gunpowder becomes more widespread accross Grimmoria, so do the Gunslingers - those who earn their living through their skill with those advanced weapons. But you are not one of 'em, you are just a wanderer with the weapon of new times. You are too young or too old to learn properly how to use effectively"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/twilight_hunter
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_blackpowderhunter.ogg'
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	class_select_category = CLASS_CAT_RANGER
	traits_applied = list(TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/twilight_hunter/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/quiver/twilight_bullet/lead
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/gun/ballistic/twilight_firearm/barker
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	head = /obj/item/clothing/head/roguetown/armingcap/padded
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/recipe_book/survival = 1, 
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/twilight_powderflask = 1,
		/obj/item/natural/bundle/fibers/full = 1
	)
