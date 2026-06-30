/datum/advclass/avicenna
	name = "Avicenna"
	tutorial = "«... Авиценна, древний врачеватель и мученик, учил их предков свободе и верховенству разума над традицией; такими были и его потомки, называемые в его честь - те, что продолжают его дело сквозь столетия ...»"
	
	outfit = /datum/outfit/job/roguetown/freeman/avicenna
	category_tags = list(CTAG_FREEMAN)
	traits_applied = list(TRAIT_CICERONE, TRAIT_NOSTINK, TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	maximum_possible_slots = 1
	extra_context = "Класс получает набор отравляемых кинжалов и отравленные стрелы, вместе с этим он имеет кое-какие... Особенные вещи."
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
        "Набор для ремонта одежды" =  /obj/item/repair_kit,
		"Колчан отравленных стрел" = /obj/item/quiver/poisonarrows,
        "Вино с пряностью" = /obj/item/reagent_containers/glass/bottle/rogue/spicedwine,
        "Пряность" = /obj/item/reagent_containers/powder/spice,
        "Сильный яд" = /obj/item/reagent_containers/glass/bottle/rogue/strongpoison,
        "Сильный утомляющий яд" = /obj/item/reagent_containers/glass/bottle/rogue/strongstampoison,
        "Отравленный пирог с ягодами (по рецепту любимой бабушки)" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/poison,
    )

/datum/outfit/job/roguetown/freeman/avicenna
	head = /obj/item/clothing/head/roguetown/turban/red
	mask = /obj/item/clothing/mask/rogue/spectacles/magi1138
	neck = /obj/item/clothing/neck/roguetown/psicross/pestra
	pants = /obj/item/clothing/under/roguetown/sirwal/fancy/red
	cloak = /obj/item/clothing/cloak/twilight_desert
	shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	l_hand = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	belt = /obj/item/storage/belt/rogue/leather/noblesash
	beltr = /obj/item/quiver/poisonarrows
	beltl = /obj/item/storage/magebag
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
	id = /obj/item/mattcoin
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/stampoison = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/natural/worms/leech/cheele = 1,
		/obj/item/reagent_containers/powder/black_ichor = 3,
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/rotfang = 1,
		)

/datum/outfit/job/roguetown/freeman/avicenna/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()

/datum/outfit/job/roguetown/freeman/avicenna/post_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/unique/ichor)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/unique/ichor_big)
	..()