/datum/outfit/job/roguetown/bandit/iconoclast/pre_equip(mob/living/carbon/human/H)
	..()
	var/subtype = list("Chosen of Matthios", "Golden Serpent")
	if(!H.mind)
		return

	var/subtype_choice = input(H, "Choose your path.", "TAKE UP ARMS") as anything in subtype
	H.set_blindness(0)
	if(subtype_choice != "Golden Serpent")
		return

	// Golden Serpent applies only delta over the base Iconoclast loadout.
	r_hand = null
	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	head = /obj/item/clothing/head/roguetown/headband/monk
	mask = /obj/item/clothing/mask/rogue/eyepatch
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/iconoclast
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	H.adjust_skillrank_down_to(/datum/skill/combat/staves, SKILL_LEVEL_NONE, TRUE)
	H.adjust_skillrank_down_to(/datum/skill/combat/shields, SKILL_LEVEL_NONE, TRUE)
	H.adjust_skillrank_down_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_NONE, TRUE)
	ADD_TRAIT(H, TRAIT_CYCLOPS_RIGHT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_LEGENDARY, TRUE)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_LCK, -2)
	var/static/list/safe_bodyzones = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG
	)
	for(var/obj/item/bodypart/limb in H.bodyparts)
		if(limb.body_zone in safe_bodyzones)
			continue
		limb.drop_limb()
		qdel(limb)
	var/obj/item/bodypart/l_arm/prosthetic/bronzeleft/L = new()
	L.attach_limb(H)
	// Run cleanup after class equip finishes applying base traits/skills.
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(iconoclast_finalize_golden_serpent), H, subtype_choice), 2 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(iconoclast_finalize_golden_serpent), H, subtype_choice), 6 SECONDS)

/proc/iconoclast_finalize_golden_serpent(mob/living/carbon/human/H, subtype_choice)
	if(!istype(H))
		return
	if(subtype_choice != "Golden Serpent")
		return

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, ADVENTURER_TRAIT)
	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	H.adjust_skillrank_down_to(/datum/skill/combat/staves, SKILL_LEVEL_NONE, TRUE)
	H.adjust_skillrank_down_to(/datum/skill/combat/shields, SKILL_LEVEL_NONE, TRUE)
	H.adjust_skillrank_down_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_NONE, TRUE)
