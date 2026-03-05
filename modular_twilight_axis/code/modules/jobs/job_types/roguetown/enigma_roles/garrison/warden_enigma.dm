/datum/job/roguetown/overseer
	title = "Overseer"
	flag = OVERSEER
	department_flag = VANGUARD
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_VANGUARD
	allowed_races = RACES_TOLERATED_UP
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	display_order = JDO_OVERSEER
	tutorial = "Вам, как опытному солдату из свиты Его Величества, поручено наблюдать за недавно построенным Бастионом. \
				Вы подчиняетесь маршалу и его советникам, \
				и ваша задача - держать авангард в строю и следить за тем, чтобы пути в город оставались безопасными. \
				Бастион не должен пасть."
	whitelist_req = TRUE
	outfit = /datum/outfit/job/roguetown/overseer
	advclass_cat_rolls = list(CTAG_OVERSEER = 2)
	give_bank_account = TRUE
	min_pq = 10
	max_pq = null

	cmode_music = 'modular_twilight_axis/sound/music/combat/combat_vanguard.ogg'
	job_subclasses = list(
		/datum/job/roguetown/overseer,
	)

/datum/job/roguetown/overseer/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/forrestercloak/vanguard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "overseer's cloak ([index])"

/datum/advclass/overseer
	name = "Overseer"
	tutorial = "Вам, как опытному солдату из свиты Его Величества, поручено наблюдать за недавно построенным Бастионом. \
				Вы подчиняетесь маршалу и его советникам, \
				и ваша задача - держать авангард в строю и следить за тем, чтобы пути в город оставались безопасными. \
				Бастион не должен пасть."

	category_tags = list(CTAG_OVERSEER)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_WOODSMAN, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/overseer
	job_bitflag = BITFLAG_VANGUARD
	head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
	pants = /obj/item/clothing/under/roguetown/chainlegs
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/overseer
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/chain
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	backl = /obj/item/rogueweapon/shield/tower
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	cloak = /obj/item/clothing/cloak/forrestercloak/vanguard

/datum/outfit/job/roguetown/overseer/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		backpack_contents = list(/obj/item/storage/keyring/warden_enigma = 1, /obj/item/signal_hornn/green = 1, /obj/item/rogueweapon/scabbard/sheath = 1, /obj/item/rogueweapon/huntingknife/idagger/steel = 1)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
	H.verbs |= list(/mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/overseer
	name = "overseer's brigandine"
	desc = "Легкий доспех надзирателя Авангарда, выкрашенный в характерные чёрные цвета. «О, Король сиих земель, те, кто сегодня падут, чествуют тебя»."
	icon_state = "light_brigandine"
	item_state = "light_brigandine"
