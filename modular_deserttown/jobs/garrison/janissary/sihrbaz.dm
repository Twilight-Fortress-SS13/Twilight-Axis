/datum/advclass/janissary/sihrbaz
	name = "Janissary Sihrbaz"
	tutorial = "Вы - живое орудие Султаната, боевой маг, чья арканная сила закована в жесткие тиски воинской дисциплины. \
        В отличие от бесславных Сахир-марадунов, скрывающихся в песках фронтира, вы принесли священную присягу Султану и обучались убивать строем. \
        В ваших руках классическая аркана превратилась в безупречное, пугающее искусство войны: вы способны выжигать целые фланги противника, \
        нерушимым щитом удерживать рубежи Султаната и насылать разрушительные магические залпы, сокрушающие вражеские порядки. \
        Пусть враги трепещут перед вашей мощью, ведь вы - боевой маг."
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/roguetown/janissary/sihrbaz
	category_tags = list(CTAG_JANISSARY)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
	)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_ARCYNE)
	subclass_mage_aspects = list("mastery" = TRUE, "major" = 1, "minor" = 3, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/janissary/sihrbaz/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross/noc
	pants = /obj/item/clothing/under/roguetown/sirwal/fancy/red
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/red
	head = /obj/item/clothing/head/roguetown/turban/red
	r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
	l_hand = /obj/item/rogueweapon/woodstaff/implement/grand
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	backpack_contents = list(
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/storage/keyring/manatarms,
		/obj/item/book/spellbook = 1,
		/obj/item/chalk = 1,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/ballistic_mortar)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mindlink)
		H.mind.AddSpell(new /datum/action/cooldown/spell/message)
		H.verbs |= /mob/proc/haltyell
