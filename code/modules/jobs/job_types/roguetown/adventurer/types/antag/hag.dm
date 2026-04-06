/datum/job/roguetown/hag
	title = "Hag"
	flag = HAG
	department_flag = ANTAGONIST
	antag_job = TRUE // whoever wrote this, I'm- gghrhhah!
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_SHUNNED_UP_NO_AASIMAR
	tutorial = "You are ancient, malevolent evil. None of the known gods claim to have brought you into this world. All you know is hatred, how to sift through the grains of this land with your calloused hands, picking those who prove themselves useful."
	outfit = null
	outfit_female = null
	display_order = JDO_HAG
	show_in_credits = TRUE
	// Difficult role to play right without failRP / LRP
	min_pq = 50
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_HAG = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(
		/datum/virtue/utility/noble,
		/datum/virtue/combat/dualwielder, //Claws are too powerful, abusable
		/datum/virtue/combat/combat_virtue, //They do not need shield skills or anything in here
		/datum/virtue/utility/notable, //No resident (????) or free-money-stash gnolls
		/datum/virtue/utility/bronzelimbs, //They should feel pain in their limbs given their state
		/datum/virtue/movement/acrobatic, //This should be given to them when they are actually after a Hunted
		/datum/virtue/utility/woodwalker, //This should be given to them when they are actually after a Hunted
		/datum/virtue/combat/crossbowman,	//Absolutely not on a class like this
		/datum/virtue/combat/bowman,
		/datum/virtue/utility/feytouched
		)
	job_subclasses = list(
		/datum/advclass/hag,
	)

// TA EDIT START
/datum/job/roguetown/hag/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()

	if(ishuman(H))
		var/mob/living/carbon/human/Hu = H
		Hu.verbs += /mob/living/carbon/human/verb/hold_breath

/mob/living/carbon/human/verb/hold_breath()
	set name = "Задержать дыхание"
	set category = "Emotes"

	if(!mind || mind.assigned_role != "Hag")
		return

	toggle_hold_breath()

/mob/living/carbon/human/proc/toggle_hold_breath()
	var/is_holding = HAS_TRAIT(src, TRAIT_HOLDBREATH)

	if(is_holding)
		REMOVE_TRAIT(src, TRAIT_HOLDBREATH, "hold_breath_verb")
		visible_message(
			span_notice("[src] перестает задерживать дыхание."),
			span_notice("Ты перестаешь задерживать дыхание.")
		)
	else
		ADD_TRAIT(src, TRAIT_HOLDBREATH, "hold_breath_verb")
		visible_message(
			span_notice("[src] задерживает свое дыхание."),
			span_notice("Ты задерживаешь свое дыхание.")
		)

// TA EDIT END
