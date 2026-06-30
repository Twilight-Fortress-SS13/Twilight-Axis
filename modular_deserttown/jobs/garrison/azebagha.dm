/datum/job/roguetown/azebagha
	title = "Azeb Agha"
	flag = AZEBAGHA
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	tutorial = "Как опытный воин султанского корпуса азебов, ты получил приказ принять командование над нововозведенным фронтиром. \
                Ты держишь ответ перед султанской династией и их благородными шейхами, \
                а твоя задача - держать в узде молодых азебов и обеспечивать безопасность караванных путей к сердцу града. \
                Граница не должна пасть."
	display_order = JDO_SERGEANT
	round_contrib_points = 3

	outfit = /datum/outfit/job/roguetown/azebagha
	advclass_cat_rolls = list(CTAG_AZEBAGHA = 20)

	give_bank_account = 50
	min_pq = 10
	max_pq = null
	cmode_music = 'sound/music/combat_hornofthebeast.ogg'
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR, TRAIT_FIREARMS_MARKSMAN, TRAIT_SLAVE)
	job_subclasses = list(
		/datum/advclass/azebagha/azebagha
	)
	same_job_respawn_delay = 30 MINUTES

/datum/outfit/job/roguetown/azebagha
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/azebagha/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/dunestalker))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "Azeb Agha Cloak ([index])"

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/azebagha
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/agha
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	cloak = /obj/item/clothing/cloak/dunestalker
	neck = /obj/item/clothing/neck/roguetown/bevor
	shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	id = /obj/item/scomstone/garrison

/datum/advclass/azebagha/azebagha
	name = "Sergeant-at-Arms"
	tutorial = "An experienced soldier of the Sultan's Azeb Corp you have been tasked with overseeing the newly constructed border. \
				You report to the Royal Family and their Councillors, \
				and your job is to keep the younger Janissaries in line and to ensure the routes to the city remain safe.\
				The Border must not fall."
	outfit = /datum/outfit/job/roguetown/azebagha/azebagha

	category_tags = list(CTAG_AZEBAGHA)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = 1,
		STATKEY_PER = 2, 
		STATKEY_CON = 2, 
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,	
		/datum/skill/misc/riding = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,	
	)

/datum/outfit/job/roguetown/azebagha/azebagha/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/azeb)
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/azebagha = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/signal_horn = 1
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/primary = list("Scimitar","Shotel","Whip","Warden Axe")
		var/primary_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in primary
		var/secondary = list("Glaive","Javelins and Shield","Blackhorn Longbow")
		var/secondary_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in secondary
		H.set_blindness(0)
		switch(primary_choice)
			if("Scimitar")		
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
			if("Shotel")		
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long/shotel
			if("Whip")	
				beltl = /obj/item/rogueweapon/whip/antique
			if("Warden Axe")	
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick

		switch(secondary_choice)
			if("Glaive")			
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				l_hand = /obj/item/rogueweapon/halberd/glaive
			if("Javelins and Shield")	
				beltr = /obj/item/quiver/javelin/steel
				backl = /obj/item/rogueweapon/shield/iron/zybantine
			if("Blackhorn Longbow")
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
