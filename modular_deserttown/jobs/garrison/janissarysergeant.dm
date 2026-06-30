/datum/job/roguetown/janissarysergeant
	title = "Janissary Sergeant"
	flag = JANISSARYSERGEANT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "Ты — один из самых опытных воинов Султанской гвардии, ведущий янычар в поддержании порядка и борьбе с угрозами, \
        которые еще не достигли внимания Дворца. \
        Следи за теми, кто находится под твоим командованием, и заполняй пробелы, которые оставляют после себя Фарисы. \
        Повинуйся приказам своего Мушира и Султана."
	display_order = JDO_ROYALSERGEANT
	round_contrib_points = 3

	outfit = /datum/outfit/job/roguetown/janissarysergeant
	advclass_cat_rolls = list(CTAG_JANISSARYSERGEANT = 20)

	give_bank_account = 50
	min_pq = 8
	max_pq = null
	cmode_music = 'sound/music/combat_desert1.ogg'
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	job_subclasses = list(
		/datum/advclass/janissarysergeant/janissarysergeant
	)
	same_job_respawn_delay = 30 MINUTES

/datum/outfit/job/roguetown/janissarysergeant
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/roguetown/janissarysergeant
	neck = /obj/item/clothing/neck/roguetown/bevor
	head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/catcloak/jancap
	id = /obj/item/scomstone/garrison

/datum/advclass/janissarysergeant/janissarysergeant
	name = "Sergeant"
	tutorial = "You are the most experienced of the SULTAN's Soldiery, leading the Janissary in maintaining order and attending to threats and crimes below the PALACE's attention. \
				See to those under your command and fill in the gaps CATAPHRACTS leave in their wake. Obey the orders of your Marshal and the SULTAN."
	outfit = /datum/outfit/job/roguetown/janissarysergeant/janissarysergeant

	category_tags = list(CTAG_JANISSARYSERGEANT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/janissarysergeant/janissarysergeant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/guard)
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/sergeant = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Rhomphaia","Whip & Shield","Glaive","Sabre & Crossbow")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Rhomphaia")
				backl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long/rhomphaia
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("Whip & Shield")
				beltr = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower
			if("Glaive")
				r_hand = /obj/item/rogueweapon/halberd/glaive
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("Sabre & Crossbow")
				beltr = /obj/item/quiver/bolt
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				r_hand = /obj/item/rogueweapon/sword/sabre
				beltl = /obj/item/rogueweapon/scabbard/sword
/datum/job/roguetown/janissarysergeant/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
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
/obj/item/clothing/cloak/catcloak/jancap
	name = "janissary sergeant's cloak"
	desc = "A most handsome cloak, of royal red, denoting the authority of a leader."
