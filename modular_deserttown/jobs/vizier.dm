/datum/job/roguetown/vizier
	title = "Vizier"
	flag = VIZIER
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	outfit = /datum/outfit/job/roguetown/vizier
	advclass_cat_rolls = list(CTAG_VIZIER = 20)
	display_order = JDO_HAND
	tutorial = "Вы - один из самых могущественных мужей во всём Султанате. \
        Вы так долго правили тайной стражей и служил наперсником правящей династии, что превратились в живую сокровищницу интриг, и вы пользуетесь этим с пугающей хваткой. \
        В ваших руках сходятся как чужие секреты, так и султанская казна - вы лично ведаете всеми расходами и маммонами государства. \
        Пусть никто не забывает, в чье ухо вы шепчете. Этими губами вы погубили больше людей, чем любой мастер клинка за всю свою жизнь."
	whitelist_req = TRUE
	give_bank_account = 44
	noble_income = 22
	min_pq = 17
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_desert2.ogg'
	job_traits = list(TRAIT_NOBLE, TRAIT_SEEPRICES)
	job_subclasses = list(
		/datum/advclass/vizier/dtblademaster,
		/datum/advclass/vizier/dtspymaster,
		/datum/advclass/vizier/dtadvisor
	)
	peopleiknow = list("Court Agent", "Enslaved kafir")
	peopleknowme = list("Court Agent", "Enslaved kafir")
	same_job_respawn_delay = 30 MINUTES

/datum/outfit/job/roguetown/vizier
	backr = /obj/item/storage/backpack/rogue/satchel/short
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/steel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/hand
	id = /obj/item/scomstone/garrison/hand

/datum/job/roguetown/vizier/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/index = findtext(H.real_name, " ")
		if(index)
			index = copytext(H.real_name, 1,index)
		if(!index)
			index = H.real_name
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Wazir"
		if(H.gender == FEMALE)
			honorary = "Wazira"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"
		GLOB.court_spymaster += H.real_name
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/agent)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
		H.verbs |= /datum/job/roguetown/vizier/proc/remember_agents
		H.verbs |= /mob/living/carbon/human/proc/adjust_taxes_vizier
		
		var/obj/item/recipe_book/treasury_primer/primer = new(H)
		H.equip_to_slot_or_del(primer, ITEM_SLOT_BACKPACK)
		SStreasury.grant_savings(ECONOMIC_RICH, H)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/client/player = H.client
		if(!player && M)
			player = M.client
		if(player?.prefs)
			if(SSmapping.config.map_name == "Desert Town")
				if(!istype(player.prefs.virtue_origin, /datum/virtue/origin/raneshen) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/naledi) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/zybantian))
					var/list/new_origins = list("Raneshen" = /datum/virtue/origin/raneshen, 
					"Naledi" = /datum/virtue/origin/naledi,
					"Zybantu" = /datum/virtue/origin/zybantian)
					var/new_origin
					var/choice = input(player, "Your origins are not compatible with the Sultanate. Where do you hail from?", "ANCESTRY") as anything in new_origins
					if(choice)
						new_origin = new_origins[choice]
					else
						to_chat(player, span_notice("No choice detected. Picking a random compatible origin."))
						new_origin = pick(/datum/virtue/origin/raneshen, /datum/virtue/origin/naledi, /datum/virtue/origin/zybantian)
					var/datum/virtue/origin/applied_origin = new new_origin()
					player.prefs.virtue_origin = applied_origin
					apply_virtue(H, applied_origin)

	addtimer(CALLBACK(src, PROC_REF(know_agents), L), 5 SECONDS)

///////////
//CLASSES//
///////////

//Blademaster Hand start
/datum/advclass/vizier/dtblademaster
	name = "Blademaster"
	tutorial = "Вы так долго служили мастером клинка и стратегом при Султанском дворе, \
        что превратились в живое воплощение армии Султаната, и вы пользуетесь этим с пугающей хваткой. \
        Пусть никто не забывает, в чье ухо вы шепчете, направляя гнев правящей династии. \
        В ваших руках сталь превратилась в абсолютный закон - этими клинками вы погубили больше людей, чем любой мастер шпионажа уничтожил своими интригами за всю историю Султаната."
	outfit = /datum/outfit/job/roguetown/vizier/blademaster

	category_tags = list(CTAG_VIZIER)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_HEAVYARMOR, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 1,
		STATKEY_STR = 3,
		STATKEY_LCK = 1,
		STATKEY_CON = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6, "ward" = FALSE) // Возможно, я сделаю его спеллблейдом несколько позже.
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
	)
//Blademaster Hand start
/datum/outfit/job/roguetown/vizier/blademaster/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/sword/sabre/dec
	beltr = /obj/item/rogueweapon/scabbard/sword
	head = /obj/item/clothing/head/roguetown/turban/fancypurple
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/lord = 1,
		/obj/item/roguekey/skeleton = 1,
	)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		H.change_stat(STATKEY_LCK, 2)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mindlink)
		H.mind.AddSpell(new /datum/action/cooldown/spell/message)

//Spymaster start
/datum/advclass/vizier/dtspymaster
	name = "Spymaster"
	tutorial = "Вы - один из самых могущественных мужей во всём Султанате. \
        Вы так долго правили тайной стражей и служил наперсником правящей династии, что превратились в живую сокровищницу интриг, и вы пользуетесь этим с пугающей хваткой. \
        В ваших руках сходятся как чужие секреты, так и султанская казна - вы лично ведаете всеми расходами и маммонами государства. \
        Пусть никто не забывает, в чье ухо вы шепчете. Этими губами вы погубили больше людей, чем любой мастер клинка за всю свою жизнь."
	extra_context = "Персонаж получает трейты 'Perfect Tracker' и 'Keen Ears' если выбрать этот подкласс."
	outfit = /datum/outfit/job/roguetown/vizier/spymaster

	category_tags = list(CTAG_VIZIER)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_KEENEARS, TRAIT_DODGEEXPERT, TRAIT_PERFECT_TRACKER, TRAIT_ARCYNE, TRAIT_MAGEARMOR)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
		STATKEY_STR = -1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
	)

//Spymaster start
/datum/outfit/job/roguetown/vizier/spymaster/pre_equip(mob/living/carbon/human/H)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/lord = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/roguekey/skeleton = 1,
	)
	if(H.dna.species.type in NON_DWARVEN_RACE_TYPES)
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/shadowrobe
		cloak = /obj/item/clothing/cloak/half/shadowcloak
		gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
		mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask
		pants = /obj/item/clothing/under/roguetown/trou/shadowpants
	else
		cloak = /obj/item/clothing/cloak/raincloak/mortus
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		backr = /obj/item/storage/backpack/rogue/satchel/black
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
		pants = /obj/item/clothing/under/roguetown/tights/black
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/stealing, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 6, TRUE)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mindlink)
		H.mind.AddSpell(new /datum/action/cooldown/spell/message)

//Advisor Start
/datum/advclass/vizier/dtadvisor
	name = "Advisor"
	tutorial = "Вы так долго исполняли роль ученого и советника при Султанском дворе, \
        что превратились в живую сокровищницу древних знаний и магии, и вы пользуетесь этим с пугающей хваткой. \
        Пусть ни один человек во всем Султанате никогда не забывает, в чье ухо вы шепчете, направляя помыслы правящей династии. \
        Ваши мудрые советы стали щитом для государства - этим тихим шепотом вы спасли больше жизней, чем могли бы уберечь \
        приказы любого мушира или самые изощренные заговоры мастеров шпионажа за всю историю Султаната."
	outfit = /datum/outfit/job/roguetown/vizier/advisor

	category_tags = list(CTAG_VIZIER)
	traits_applied = list(TRAIT_ALCHEMY_EXPERT, TRAIT_ARCYNE, TRAIT_MAGEARMOR)
	subclass_stats = list(
		STATKEY_INT = 5,
		STATKEY_PER = 3,
		STATKEY_WIL = 1,
		STATKEY_LCK = 2,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 2, "minor" = 2, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
	)

//Advisor start.
/datum/outfit/job/roguetown/vizier/advisor/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/sword/rapier/dec
	beltr = /obj/item/rogueweapon/sword/rapier/hand
	beltl = /obj/item/rogueweapon/scabbard/sheath/courtphysician/hand
	head = /obj/item/clothing/head/roguetown/turban/fancypurple
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hand/advisor
	pants = /obj/item/clothing/under/roguetown/tights/black
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_f
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_m
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/lord = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/roguekey/skeleton = 1,
		/obj/item/book/spellbook = 1,
	)
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1) 
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mindlink)
		H.mind.AddSpell(new /datum/action/cooldown/spell/message)


////////////////////
///SPELLS & VERBS///
////////////////////

/datum/job/roguetown/vizier/proc/know_agents(mob/living/carbon/human/H)
	if(!GLOB.court_agents.len)
		to_chat(H, span_boldnotice("You begun the week with no agents."))
	else
		to_chat(H, span_boldnotice("We begun the week with these agents:"))
		for(var/name in GLOB.court_agents)
			to_chat(H, span_greentext(name))

/datum/job/roguetown/vizier/proc/remember_agents()
	set name = "Remember Agents"
	set category = "Voice of Command"

	to_chat(usr, span_boldnotice("I have these agents present:"))
	for(var/name in GLOB.court_agents)
		to_chat(usr, span_greentext(name))
	return

GLOBAL_VAR_INIT(vizier_tax_cooldown, -50000)
/mob/living/carbon/human/proc/adjust_taxes_vizier()
	set name = "Adjust Taxes"
	set category = "Stewardry"
	if(stat)
		return
	var/lord = find_lord()
	if(lord)
		to_chat(src, span_warning("You cannot adjust taxes while the [SSticker.rulertype] is present in the realm. Ask your sultan."))
		return
	if(world.time < GLOB.vizier_tax_cooldown + 600 SECONDS)
		to_chat(src, span_warning("You must wait [round((GLOB.vizier_tax_cooldown + 600 SECONDS - world.time)/600, 0.1)] minutes before adjusting taxes again! Think of the realm."))
		return FALSE
	GLOB.vizier_tax_cooldown = world.time
	var/datum/taxsetter/taxsetter = new("The Diligent Vizier Intervenes", "The Greedy Vizier Imposes")
	taxsetter.ui_interact(src)
