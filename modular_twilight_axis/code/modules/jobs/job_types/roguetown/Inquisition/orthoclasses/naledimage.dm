/datum/advclass/naledimage
	name = "Naledian Psydon Mage"
	tutorial = "The Neledian mage, who had studied the arcana from a young age, also studied the teachings of the church. After long and meticulous preparation, the secrets of the elements were revealed to him — secrets he was destined to take with him to the grave."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/naledimage
	category_tags = list(CTAG_ORTHODOXIST)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	traits_applied = list(
		TRAIT_PSYDONITE,
		TRAIT_ARCYNE_T3,
		TRAIT_MAGEARMOR,
		TRAIT_INTELLECTUAL, 
		TRAIT_NALEDI,
		TRAIT_ALCHEMY_EXPERT,
	)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_STR = -1,
	)
	subclass_spellpoints = 21
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy,
		"Psydon Gift" = /obj/item/hourglass/temporal
	)

	extra_context = "As one of the best magicians, you managed to take your favorite watch with you."

/datum/outfit/job/roguetown/naledimage
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/naledimage/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(!H)
		return

	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/pointfex
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	head = /obj/item/clothing/head/roguetown/roguehood/psydon
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/clothing/ring/signet/silver
	backl = /obj/item/rogueweapon/woodstaff/naledi
	backpack_contents = list(
		/obj/item/roguekey/inquisitionmanor,
		/obj/item/rogueweapon/huntingknife,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/paper/inqslip/arrival/ortho,
		/obj/item/book/spellbook
	)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_MASTER, TRUE)
		H?.mind.adjust_spellpoints(12)
