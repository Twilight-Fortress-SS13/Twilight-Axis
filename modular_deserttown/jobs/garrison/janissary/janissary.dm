/datum/job/roguetown/janissary
	title = "Janissary"
	flag = JANISSARY
	department_flag = GARRISON
	faction = "Station"
	total_positions = 6
	spawn_positions = 6

	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED)
	tutorial = "Ты — член свиты Султана. Обеспечивай безопасность Султана и его подданных, защищай власть предержащих от ужасов внешнего мира и делай всё возможное, чтобы Султанат продолжал жить."
	display_order = JDO_ROYALGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/janissary
	advclass_cat_rolls = list(CTAG_JANISSARY = 20)

	give_bank_account = 22
	min_pq = 5
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_desert1.ogg'
	job_subclasses = list(
		/datum/advclass/janissary/footman,
		/datum/advclass/janissary/zephyr,
		/datum/advclass/janissary/sihrbaz,
		/datum/advclass/janissary/flagbearer
	)
	same_job_respawn_delay = 30 MINUTES

/datum/outfit/job/roguetown/janissary
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/roguetown/janissary
	shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison
	cloak = /obj/item/clothing/cloak/citywatch/janissary
