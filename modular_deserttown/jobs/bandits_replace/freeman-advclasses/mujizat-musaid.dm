/datum/advclass/mujizat_musaid //Support Cleric, Heavy armor, unarmed, miracles.
	name = "Mujizat-Musaid"
	tutorial = "«... Среди них был пророк - тот, что предвещал Посланника, который освободит их народ от оков рабства ...»"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/freeman/mujizat_musaid
	category_tags = list(CTAG_FREEMAN)
	maximum_possible_slots = 1 // We only want one of these.
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_RITUALIST, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 4,// LETS WRASSLE
		STATKEY_WIL = 4,// This is our Go Big stat, we want lots of stamina for miracles and WRASSLIN.
		STATKEY_LCK = 2,//We have a total of +12 in stats. 
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,  // Unarmed if we want to kick ass for the lord(you do, this is what you SHOULD DO!!)
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
        /datum/skill/misc/tracking = SKILL_LEVEL_MASTER,        
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, // We can substitute for a sawbones, but aren't as good and dont have access to surgical tools
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER, //We are the True Mathlete
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
	)
	cmode_music = 'sound/music/Iconoclast.ogg'

/datum/outfit/job/roguetown/freeman/mujizat_musaid/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/matthios)))	//This is the only class that forces Matthios. Needed for miracles + limited slot.
		to_chat(H, span_warning("Matthios embraces me.. I must uphold his creed. I am his light in the darkness."))
		H.set_patron(/datum/patron/inhumen/matthios)
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash/brown
	pants = /obj/item/clothing/under/roguetown/sirwal/brown
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/ritechalk = 1,
					)
	id = /obj/item/mattcoin
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	if(H.mind)
		r_hand = /obj/item/rogueweapon/woodstaff
		head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/raneshi_hmamluk
		armor = /obj/item/clothing/suit/roguetown/armor/plate/full/raneshen_plated
		beltr = /obj/item/rogueweapon/katar
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
		shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
		cloak = /obj/item/clothing/cloak/dunestalker
		neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
		H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
