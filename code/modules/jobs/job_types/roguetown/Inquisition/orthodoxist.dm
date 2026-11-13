/datum/job/roguetown/orthodoxist
	title = "Orthodoxist"
	flag = ORTHODOXIST
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 3
	spawn_positions = 3

	allowed_patrons = list(/datum/patron/old_god) //Requires your character's patron to be Psydon. This role is explicitly designed to be played by Psydonites, only, and almost everything they have - down to the equipment and statblock - is rooted in Psydonism. Do NOT make this accessable to other faiths, unless you go through the efforts of redesigning it from the ground up.
	tutorial = "Praise. Atone. Mourn. A hundred different paths across a hundred different lyves, all ending the same; with you swearing fealty to Psydon, and your admittance into the Inquisitor's retinue. Root the aberrants out from wherever they dwell, and - whether with a clenched fist or open palm - bring them back to the light."
	selection_color = JCOLOR_INQUISITION
	outfit = null
	outfit_female = null
	display_order = JDO_ORTHODOXIST
	min_pq = 10
	max_pq = null
	round_contrib_points = 2
	advclass_cat_rolls = list(CTAG_ORTHODOXIST = 20)
	wanderer_examine = FALSE
	advjob_examine = TRUE
	give_bank_account = 15
	vice_restrictions = list(/datum/charflaw/silverweakness, /datum/charflaw/wanted)
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_INQUISITION)
	job_subclasses = list(
		/datum/advclass/inq/psydoniantemplar,
		/datum/advclass/inq/disciple,
		/datum/advclass/inq/sojourner,
		/datum/advclass/inq/confessor,
		/datum/advclass/inq/chasseur
		/datum/advclass/inq/psyaltrist

	)
	same_job_respawn_delay = 30 MINUTES

/datum/advclass/inq
	tempo_capable = TRUE
