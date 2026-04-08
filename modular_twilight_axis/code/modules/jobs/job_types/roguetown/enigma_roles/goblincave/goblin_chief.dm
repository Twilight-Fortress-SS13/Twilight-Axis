/datum/job/roguetown/goblin_chief
	title = "Goblin Chief"
	flag = GOBLINCHIEF
	department_flag = GOBLINCAVE
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_races = list(
		/datum/species/goblinp,
		/datum/species/halforc
	)
	allowed_patrons = list(/datum/patron/inhumen/graggar)
	tutorial = "You are the Chief, chosen by Graggar — the embodiment of absolute power in the tribe. \
				Your brutality is not spite; it is a sacred language proving to your tribe that weakness does not deserve to live. \
				Every day you must prove why you alone are Chief, leaving behind a fear that speaks louder than any words." 
	class_categories = FALSE

	outfit = null
	outfit_female = null

	display_order = JDO_GOBLINCHIEF
	selection_color = JCOLOR_WANDERER
	show_in_credits = FALSE
	min_pq = 20
	max_pq = null

	advclass_cat_rolls = list(CTAG_GOBLINCHIEF = 10)

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = FALSE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 30 MINUTES

	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	job_subclasses = list(
		/datum/advclass/goblin_chief/chief,
	)

/datum/job/roguetown/goblin_chief/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(H))
		var/mob/living/carbon/human/human = H
		human.grant_language(/datum/language/orcish)

/datum/advclass/goblin_chief/chief
	name = "Chief"
	tutorial = "You are the Chief, chosen by Graggar — the embodiment of absolute power in the tribe. \
				Your brutality is not spite; it is a sacred language proving to your tribe that weakness does not deserve to live. \
				Every day you must prove why you alone are Chief, leaving behind a fear that speaks louder than any words." 
	outfit = /datum/outfit/job/roguetown/goblin_chief/chief
	category_tags = list(CTAG_GOBLINCHIEF)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE, TRAIT_STRONGBITE, TRAIT_HEAVYARMOR, TRAIT_GOBLINCAVE, TRAIT_AZURENATIVE, TRAIT_LEECHIMMUNE)
	subclass_stats = list(
		STATKEY_STR = 4,
		STATKEY_INT = -2,
		STATKEY_SPD = -2,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/goblin_chief/chief/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("You are a goblin chief. Crush your enemies!"))
	H.dna.species.soundpack_m = new /datum/voicepack/male/goblincave()
	H.dna.species.soundpack_f = new /datum/voicepack/female/goblincave()
	if(!visualsOnly)
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			var/has_wild_goblin_eye_action = FALSE
			for(var/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/action in eyes.actions)
				has_wild_goblin_eye_action = TRUE
				break
			if(!has_wild_goblin_eye_action)
				var/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/action = new(eyes)
				action.Grant(H)
	H.set_blindness(-3)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/chief_announce)
	if(!H.mind)
		return

	var/weapons = list("Steel Warhammer and Shield","Steel Handclaw","Grand Maul (!!req 15str)","Discipline - Unarmed")
	var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS.") as anything in weapons
	switch(weapon_choice)
		if("Steel Warhammer and Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel
			gloves = /obj/item/clothing/gloves/roguetown/bandages
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
			backr = /obj/item/rogueweapon/shield/wood
		if("Steel Handclaw")
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
			r_hand = /obj/item/rogueweapon/handclaw/steel
			gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
		if("Grand Maul (!!req 15str)")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
			r_hand = /obj/item/rogueweapon/mace/maul/grand
			gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
		if ("Discipline - Unarmed")
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
			gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
	mask = /obj/item/clothing/mask/rogue/facemask
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	cloak = /obj/item/clothing/cloak/graggar
	if(should_wear_masc_clothes(H))
		H.dna.species.soundpack_m = new /datum/voicepack/male/goblincave()
	if(should_wear_femme_clothes(H))
		H.dna.species.soundpack_f = new /datum/voicepack/female/goblincave()
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/bronze = 1,
		/obj/item/storage/keyring/goblinchief = 1,
		)

/obj/effect/proc_holder/spell/self/chief_announce
	name = "Command Will"
	desc = "Bellow a commandment, which will be heard by all goblins in your cave - regardless of their location."
	recharge_time = 20 SECONDS

/obj/effect/proc_holder/spell/self/chief_announce/cast(list/targets, mob/user)
	if(user.stat)
		return FALSE

	var/calltext = input("Send Your Will To Your Goblins", "GOBLINS ANNOUNCE") as text|null
	if(!calltext)
		return FALSE
	calltext = copytext_char(sanitize(calltext), 1, MAX_MESSAGE_LEN)
	if(!length(calltext))
		return FALSE

	var/list/allowed_goblin_jobs = list("Goblin Chief", "Goblin Warrior", "Goblin Slave", "Goblin Shaman")

	for(var/mob/living/carbon/human/goblin in GLOB.human_list)
		if(!goblin.mind)
			continue
		if(!(goblin.job in allowed_goblin_jobs) && !(goblin.mind.assigned_role in allowed_goblin_jobs))
			continue
		to_chat(goblin, span_boldannounce("[span_purple(user.real_name)] roars out their commandment: [calltext]"))
		goblin.playsound_local(get_turf(user), 'sound/vo/mobs/troll/idle2.ogg', 70, FALSE)

	..()

/proc/update_goblin_chief_slots()
	var/datum/job/goblin_chief_job = SSjob.GetJob("Goblin Chief")
	if(!goblin_chief_job)
		return

	var/player_count = length(GLOB.joined_player_list)
	var/ready_player_count = length(GLOB.ready_player_list)
	var/slots = 0

	var/current_players = (SSticker.current_state == GAME_STATE_PREGAME) ? ready_player_count : player_count

    // На 80 игроках, 1 слот открывается
	if(SSmapping.config.map_name == "Rockhill")
		if(current_players >= 80)
			slots = 1
	else
		slots = 0

	goblin_chief_job.total_positions = slots
	goblin_chief_job.spawn_positions = slots
