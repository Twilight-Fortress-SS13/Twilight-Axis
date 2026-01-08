/datum/outfit/job/roguetown/inquisitor/inspector/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.adjust_skillrank(/datum/skill/combat/twilight_firearms, 3, TRUE)
	belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt/runelock
	beltr = /obj/item/quiver/twilight_bullet/runed
	backl = null

/datum/advclass/inquisitor/blackpowder
	name = "Blackpowder Vanguard"
	tutorial = "A truly rare specimen among the ranks of the Inquisition - an agent of the Blackpowder Order now serving as an Ordinator, hunting down Psydon's many enemies, set upon this task by Marshal Inquisitionis himself. There are many mistakes a heretic can commit over their lifespan, but when facing a Blackpowder Vanguard, their final error tends to be the fact that they brought a sword to a gunfight."
	outfit = /datum/outfit/job/roguetown/inquisitor/blackpowder
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_blackpowder.ogg'
	category_tags = list(CTAG_INQUISITION)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_MEDIUMARMOR,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_FIREARMS_MARKSMAN,
		TRAIT_PURITAN
		)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 4,
		STATKEY_CON = 2,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass gets different skillsets depending on the chosen relic - a stealth-focused agent with the Umbra, an assassin's firearm, or a combat-focused sharpshooter with the Doomsdae, a runelock rifle."

/datum/outfit/job/roguetown/inquisitor/blackpowder/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Capped to T1 miracles.
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	neck = /obj/item/clothing/neck/roguetown/leather/blackpowder
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	cloak = /obj/item/clothing/cloak/tabard/psydontabard
	head = /obj/item/clothing/head/roguetown/inqhat
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/storage/keyring/puritan = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger,
		/obj/item/grapplinghook = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/paper/inqslip/arrival/inq = 1
		)

/datum/outfit/job/roguetown/inquisitor/blackpowder/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Doomsdae (Runelock Rifle)", "Umbra (Assassin's Firearm)")
	var/weapon_choice = input(H,"CHOOSE YOUR RELIQUARY PIECE.", "WIELD THEM IN HIS NAME.") as anything in weapons
	switch(weapon_choice)
		if("Doomsdae (Runelock Rifle)")
			H.equip_to_slot_or_del(new /obj/item/storage/belt/rogue/leather/steel/tasset, SLOT_BELT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/twilight_bullet/blessed, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/rifle(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/psyrapier(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE)
		if("Umbra (Assassin's Firearm)")
			H.equip_to_slot_or_del(new /obj/item/storage/belt/rogue/leather/twilight_holsterbelt, SLOT_BELT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/twilight_bullet/silver, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.put_in_hands(new /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol/umbra(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/psyrapier(H), TRUE)
			var/obj/item/belt = H.get_item_by_slot(SLOT_BELT)
			var/quivers = list("Holy Fyrepowder", "Thunderpowder")
			var/ammochoice = input(H,"CHOOSE YOUR MUNITIONS.", "LAY WASTE TO THE HERETICS.") as anything in quivers
			switch(ammochoice)
				if("Holy Fyrepowder")
					var/obj/item/powderflask = new /obj/item/twilight_powderflask/holyfyre(H)
					if(!SEND_SIGNAL(belt, COMSIG_TRY_STORAGE_INSERT, powderflask, null, TRUE, TRUE))
						addtimer(CALLBACK(PROC_REF(move_storage), powderflask, H.loc), 3 SECONDS)
				if("Thunderpowder")
					var/obj/item/powderflask = new /obj/item/twilight_powderflask/thunder(H)
					if(!SEND_SIGNAL(belt, COMSIG_TRY_STORAGE_INSERT, powderflask, null, TRUE, TRUE))
						addtimer(CALLBACK(PROC_REF(move_storage), powderflask, H.loc), 3 SECONDS)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 5, TRUE)
			ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, TRAIT_GENERIC)
