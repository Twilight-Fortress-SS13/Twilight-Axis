/datum/job/roguetown/cult/skeleton
	title = "Skeleton cultist"
	flag = SKELETON
	department_flag = SLOP
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null //no pq
	max_pq = null
	announce_latejoin = FALSE
	
	advclass_cat_rolls = list(CTAG_NSKELETON = 20)

	tutorial = "You are a resurrected skeleton, summoned by the cult of Zizo itself. Obey the cultists and Her believers without question."

	outfit = /datum/outfit/job/roguetown/cult/skeleton/zizoid
	show_in_credits = FALSE
	give_bank_account = FALSE
	hidden_job = TRUE

/datum/outfit/job/roguetown/cult/skeleton/pre_equip(mob/living/carbon/human/H)
	..()

	H.set_patron(/datum/patron/inhumen/zizo)

	H.possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/weak)
	H.swap_rmb_intent(num=1)

	var/datum/antagonist/new_antag = new /datum/antagonist/skeleton()
	H.mind.add_antag_datum(new_antag)

	H.grant_language(/datum/language/undead)

	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/undead

/datum/job/roguetown/cult/skeleton/zizoid/after_spawn(mob/living/L, mob/M, latejoin = FALSE)
	..()

	var/mob/living/carbon/human/H = L
	H.advsetup = TRUE
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")


/*
NECRO SKELETONS
*/


/datum/outfit/job/roguetown/cult/skeleton/zizoid
	wrists = /obj/item/clothing/wrists/roguetown/bracers/zizo
	armor =  /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	pants = /obj/item/clothing/under/roguetown/platelegs/zizo
	head = /obj/item/clothing/head/roguetown/helmet/skullcap/cult
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo
	neck = /obj/item/clothing/neck/roguetown/bevor/zizo
	gloves = /obj/item/clothing/gloves/roguetown/plate/zizo

/datum/advclass/cult/skeleton/zizoid/raider
	name = "Cult skeleton raider"
	tutorial = "You are a resurrected skeleton, summoned by the cult of Zizo itself. Obey the cultists and Her believers without question."
	outfit = /datum/outfit/job/roguetown/cult/skeleton/zizoid/raider

	category_tags = list(CTAG_NSKELETON)
	subclass_skills = list(
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/cult/skeleton/zizoid/raider/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = rand(9, 13)
	H.STAWIL = rand(8, 12)
	H.STACON = rand(8, 13)
	H.STAINT = rand(1, 3)
	H.STAPER = rand(10, 12)
	H.STALUC = rand(8, 12)

	shirt = prob(50) ? /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy : /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	r_hand = /obj/item/rogueweapon/sword/long/zizo

	H.energy = H.max_energy
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
