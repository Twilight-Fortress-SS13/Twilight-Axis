/datum/advclass/sahir_maradun
	name = "Sahir-maradun" // Что означает "разбойник-чародей", аналог хеджмага бандита, но в местных условиях.
	tutorial = "«... На самой же окраине, вдали от блеска султанских маммонов, обитают лишь те, кто отверг предопределенность - Сахи́р-мараду́ны, разбойные маги, выбравшие путь воли, а не долга ...»"
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/freeman/sahir_maradun
	category_tags = list(CTAG_FREEMAN)
	maximum_possible_slots = 1
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 2, "minor" = 3, "utilities" = 9, "ward" = TRUE)
	traits_applied = list(TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_LCK = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = 1,
	)
	age_mod = /datum/class_age_mod/court_magician
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,		
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/freeman/sahir_maradun/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
	pants = /obj/item/clothing/under/roguetown/sirwal/brown
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/agha
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	backr = /obj/item/storage/backpack/rogue/satchel
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	cloak = /obj/item/clothing/cloak/dunestalker
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/book/spellbook = 1,
					/obj/item/chalk = 1,
					)
	mask = /obj/item/clothing/mask/rogue/ragmask/red
	neck = /obj/item/clothing/neck/roguetown/coif
	head = /obj/item/clothing/head/roguetown/turban/tan
	id = /obj/item/mattcoin

	r_hand = /obj/item/rogueweapon/woodstaff/implement/grand
	if(H.age == AGE_OLD)
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/ballistic_mortar)
