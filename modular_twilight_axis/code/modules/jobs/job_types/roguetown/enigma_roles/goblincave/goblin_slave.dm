/datum/job/roguetown/goblin_slave
	title = "Goblin Slave"
	flag = GOBLINSLAVE
	department_flag = GOBLINCAVE
	faction = "Station"
	total_positions = 0
	spawn_positions = 0

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	tutorial = "You are a Slave — pitiful proof of the Chief's and Graggar's power in the tribe. \
				Your weakness is their trophy: you exist to grovel, serve, and endure, reminding everyone that submission is the only path to survival. \
				Every blow, every humiliation, every order is a reminder: you are broken, you are nothing, and your place is in the dirt at the feet of the strong — until they decide otherwise."
	class_categories = FALSE

	outfit = null
	outfit_female = null

	display_order = JDO_GOBLINSLAVE
	selection_color = JCOLOR_WANDERER
	show_in_credits = FALSE
	min_pq = -50
	max_pq = null

	advclass_cat_rolls = list(CTAG_GOBLINSLAVE = 10)

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = FALSE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 30 MINUTES

	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	job_subclasses = list(
		/datum/advclass/goblin_slave/slave,
	)

/datum/job/roguetown/goblin_slave/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(H))
		var/mob/living/carbon/human/human = H
		human.grant_language(/datum/language/orcish)
	
/datum/advclass/goblin_slave/slave
	name = "Slave"
	tutorial = "You are a Slave — pitiful proof of the Chief's and Graggar's power in the tribe. \
				Your weakness is their trophy: you exist to grovel, serve, and endure, reminding everyone that submission is the only path to survival. \
				Every blow, every humiliation, every order is a reminder: your will is broken, you are nothing, and your place is in the dirt at the feet of the strong — until they decide otherwise."
	outfit = /datum/outfit/job/roguetown/goblin_slave/slave
	category_tags = list(CTAG_GOBLINSLAVE)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SEEPRICES, TRAIT_SMITHING_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_HOMESTEAD_EXPERT, TRAIT_GOBLINCAVE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_LCK = 3
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/goblin_slave/slave/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("You are a goblin slave. Submit!"))
	neck = /obj/item/clothing/neck/roguetown/collar/forlorn
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/roguekey/goblinkey = 1,
		)

/proc/update_goblin_slave_slots()
	var/datum/job/goblin_slave_job = SSjob.GetJob("Goblin Slave")
	if(!goblin_slave_job)
		return

	var/player_count = length(GLOB.joined_player_list)
	var/ready_player_count = length(GLOB.ready_player_list)
	var/slots = 0

	var/current_players = (SSticker.current_state == GAME_STATE_PREGAME) ? ready_player_count : player_count

	// На 80 игроках, 4 sслота
	if(SSmapping.config.map_name == "Rockhill")
		if(current_players >= 80)
			slots = 4
	else
		slots = 0

	goblin_slave_job.total_positions = slots
	goblin_slave_job.spawn_positions = slots
