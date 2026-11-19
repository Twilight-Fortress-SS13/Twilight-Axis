/datum/job/roguetown/dragon
	title = "Dragon"
	flag = DRAGON
	antag_job = TRUE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	tutorial = "You are an ancient dragon, guarding a hoard of treasure. Strike deals with mortals, protect your territory, and secure a future for your brood."
	outfit = null
	outfit_female = null
	display_order = JDO_DRAGON
	show_in_credits = TRUE
	min_pq = 60
	max_pq = null

	obfuscated_job = TRUE
	advclass_cat_rolls = list(CTAG_DRAGON = 20)
	PQ_boost_divider = 10
	round_contrib_points = 4

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	quirk_restrictions = list(/datum/quirk/noble) // Matthios hates nobles.
	virtue_restrictions = list(
		/datum/virtue/utility/noble,
		/datum/virtue/combat/dualwielder, //Claws are too powerful, abusable
		/datum/virtue/combat/combat_virtue, //They do not need shield skills or anything in here
		/datum/virtue/utility/notable, //No resident (????) or free-money-stash gnolls
		/datum/virtue/utility/bronzelimbs, //They should feel pain in their limbs given their state
		/datum/virtue/movement/acrobatic, //This should be given to them when they are actually after a Hunted
		/datum/virtue/utility/woodwalker, //This should be given to them when they are actually after a Hunted
		)
	vice_restrictions = list(/datum/charflaw/hunted, /datum/charflaw/targeted)
	job_subclasses = list(
		/datum/advclass/dragon,
	)
	has_subprefs = FALSE // only one subclass

/datum/job/roguetown/dragon/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Ensure dragons are represented in the antagonist list.
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/dragon))
			var/datum/antagonist/new_antag = new /datum/antagonist/dragon()
			H.mind.add_antag_datum(new_antag)
			add_verb(H, /mob/living/carbon/human/proc/dragon_inspect_skin)

/datum/outfit/job/roguetown/dragon/proc/don_scales(mob/living/carbon/human/H)
	if(H.mind)
		H.set_blindness(0)
		H.regenerate_icons()
		H.dna.species.regenerate_icons(H)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/claws/dragon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/message)
		H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/dragons_breath)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/fireball)
		H.mind.AddSpell(new /datum/action/cooldown/spell/fire_curtain)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/fireball/barrage)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		H.mind.AddSpell(new /datum/action/cooldown/spell/ultio)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/smoke_burst)
		to_chat(H, span_boldwarning("As a dragon, you are a political entity in the duchy. \
									You are not a mindless beast who chomps peasants and abducts cows. \
									Bargain with the lesser races, strike deals with seekers of riches, \
									and ensure a mutually profitable conclusion for you and your trading partners alike. \
									You sit in the precarious spot of not being a big enough nuisance to justify the resources it would take to hunt you down. \
									Ensure you do not draw the ire of the duchy, lest they wipe you off the map, once and for all. No matter what, your hoard must grow."))

/mob/living/carbon/human/proc/dragon_inspect_skin()
	set name = "Inspect Scales"
	set category = "Dragon"
	set desc = "Examine your draconic scales armor"
	if(!istype(skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/dragon_armor))
		to_chat(src, span_warning("You don't have any scales to inspect!"))
		return
	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/dragon_armor/DA = skin_armor
	DA.Topic(null, list("inspect" = "1"), src)

/datum/advclass/dragon
	name = "Dragon"
	tutorial = "You are a dragon who has decided to make the local duchy their home. Walk the fine line between self-enrichment and being hunted down for causing too much grief.\
				Strike deals with locals who stumble upon your lair, and ensure the legacy of your brood will endure for millenia to come."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	outfit = /datum/outfit/job/roguetown/dragon
	cmode_music = 'sound/music/combat_matthios.ogg'
	category_tags = list(CTAG_DRAGON)
	tempo_capable = TRUE
	traits_applied = list()
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_STR = 5,
		STATKEY_CON = 5,
		STATKEY_WIL = 5,
		STATKEY_SPD = -2,
		STATKEY_INT = 5,
		STATKEY_PER = 5,
		STATKEY_LCK = 5
	)
	// Great wrestlers and butchers. Okay swimmers and climbers. Not very good at anything else.
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/dragon/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/dragon)
		H.regenerate_icons()
		H.dna.species.regenerate_icons(H)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/dragon_armor(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		don_scales(H)
