/datum/job/roguetown/blackoak
	title = "Black Oaken"
	flag = BLACKOAK
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_patrons = list(/datum/patron/divine/dendor)
	tutorial = "Civilization has stolen your lands, but it will never claim your soul. Refusing to bow to foreign kings or dilute your pure bloodline, you have embraced the harsh lyfe of a Black Oaken rebel. Hounded by the Crown's dogs, you lurk within the shadows of the old trees, striking down any outsider foolish enough to stray from the roads."
	outfit = null
	outfit_female = null
	display_order = JDO_BLACKOAK
	min_pq = 25
	max_pq = null
	forbidden_races = list(RACES_BLACKOAK)

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_BLACKOAK = 20)
	PQ_boost_divider = 10
	round_contrib_points = null

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 30 MINUTES
	virtue_restrictions = list(/datum/virtue/utility/woodwalker, /datum/charflaw/silverweakness)
	origin_requirement = /datum/virtue/origin/azuria
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_SELF_SUSTENANCE, TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_WOODWALKER, TRAIT_EXPERT_HUNTER, TRAIT_AZUREWALKER)
	job_subclasses = list(
		/datum/advclass/blackoak/warmaster,
		/datum/advclass/blackoak/guardian,
		/datum/advclass/blackoak/ranger,
		/datum/advclass/blackoak/spellblade,
		/datum/advclass/blackoak/wardancer,
		// /datum/advclass/blackoak/mage
	)
