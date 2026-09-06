/mob/living/carbon/human
	var/tmp/ta_is_golden_serpent = FALSE

/datum/advclass/iconoclast
	traits_applied = list(
		TRAIT_CIVILIZEDBARBARIAN,
		TRAIT_RITUALIST,
	)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 1,
		STATKEY_WIL = 3,
		STATKEY_LCK = 2,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/advclass/iconoclast/post_equip(mob/living/carbon/human/human)
	. = ..()

	if(human.ta_is_golden_serpent)
		ADD_TRAIT(human, TRAIT_CYCLOPS_RIGHT, ADVENTURER_TRAIT)
		ADD_TRAIT(human, TRAIT_IGNOREDAMAGESLOWDOWN, ADVENTURER_TRAIT)
		ADD_TRAIT(human, TRAIT_NOPAINSTUN, ADVENTURER_TRAIT)
		human.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_LEGENDARY, TRUE)
		human.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_LEGENDARY, TRUE)
		human.change_stat(STATKEY_CON, 2)
		human.change_stat(STATKEY_LCK, -2)
		return

	ADD_TRAIT(human, TRAIT_HEAVYARMOR, ADVENTURER_TRAIT)
	human.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
	human.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	human.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_EXPERT, TRUE)
	human.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
	human.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)

/datum/outfit/job/roguetown/bandit/iconoclast/pre_equip(mob/living/carbon/human/human)
	..()

	if(!istype(human.patron, /datum/patron/inhumen/matthios))
		to_chat(human, span_warning("Matthios embraces me.. I must uphold his creed. I am his light in the darkness."))
		human.set_patron(/datum/patron/inhumen/matthios)

	neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/mattcoin
	backpack_contents = list(
		/obj/item/needle/thorn = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/ritechalk = 1,
	)

	var/subtype_choice = "Chosen of Matthios"
	if(human.mind)
		var/list/subtype_choices = list("Chosen of Matthios", "Golden Serpent")
		subtype_choice = input(human, "Choose your path.", "TAKE UP ARMS") as anything in subtype_choices

	human.ta_is_golden_serpent = subtype_choice == "Golden Serpent"
	human.set_blindness(0)

	if(human.ta_is_golden_serpent)
		r_hand = null
		head = /obj/item/clothing/head/roguetown/headband/monk
		mask = /obj/item/clothing/mask/rogue/eyepatch
		wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
		gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
		armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/iconoclast
		shirt = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
		shoes = /obj/item/clothing/shoes/roguetown/sandals

		var/static/list/safe_bodyzones = list(
			BODY_ZONE_HEAD,
			BODY_ZONE_CHEST,
			BODY_ZONE_R_ARM,
			BODY_ZONE_L_LEG,
			BODY_ZONE_R_LEG,
		)
		for(var/obj/item/bodypart/limb in human.bodyparts)
			if(limb.body_zone in safe_bodyzones)
				continue
			limb.drop_limb()
			qdel(limb)

		var/obj/item/bodypart/l_arm/prosthetic/bronzeleft/left_arm = new()
		left_arm.attach_limb(human)
	else
		r_hand = /obj/item/rogueweapon/woodstaff
		head = /obj/item/clothing/head/roguetown/roguehood
		cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
		armor = /obj/item/clothing/suit/roguetown/armor/plate
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
		beltr = /obj/item/rogueweapon/katar
		shoes = /obj/item/clothing/shoes/roguetown/shortboots

	var/datum/devotion/matthios_devotion = new /datum/devotion(human, human.patron)
	matthios_devotion.grant_miracles(human, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)
	human.mind?.AddSpell(new /datum/action/cooldown/spell/matthios/raze)
