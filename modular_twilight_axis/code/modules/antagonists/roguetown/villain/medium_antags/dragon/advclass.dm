/datum/job/roguetown/wyvern
	title = "Wyvern"
	flag = WYVERN
	antag_job = TRUE
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	tutorial = "You are an ancient wyvern, guarding a hoard of treasure. Strike deals with mortals, protect your territory, and secure a future for your brood."
	outfit = null
	outfit_female = null
	display_order = JDO_WYVERN
	show_in_credits = TRUE
	min_pq = 60
	max_pq = null

	obfuscated_job = TRUE
	advclass_cat_rolls = list(CTAG_WYVERN = 20)
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
		/datum/virtue/movement/acrobatic,
		/datum/virtue/utility/woodwalker,
		)
	vice_restrictions = list(/datum/charflaw/hunted, /datum/charflaw/targeted)
	job_subclasses = list(
		/datum/advclass/wyvern_magic,
		/datum/advclass/wyvern_miracles,
	)

/datum/job/roguetown/wyvern/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Ensure wyverns are represented in the antagonist list.
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/wyvern))
			var/datum/antagonist/new_antag = new /datum/antagonist/wyvern()
			H.mind.add_antag_datum(new_antag)
			add_verb(H, /mob/living/carbon/human/proc/wyvern_inspect_skin)

/datum/job/roguetown/wyvern/special_job_check(mob/dead/new_player/player)
	if(!wyvern_slots_open())
		return FALSE
	return ..()

/datum/job/roguetown/wyvern/special_check_latejoin(client/C)
	if(!wyvern_slots_open())
		return FALSE
	return ..()

/proc/wyvern_slots_open()
	var/admin_slot = !SSgamemode.allow_vote ? SSgamemode.admin_slots["Wyvern"] : null
	if(!isnull(admin_slot))
		return admin_slot > 0
	return (SSgamemode.current_storyteller?.wyvern_slot || 0) > 0


/proc/wyvernslot_calc()
	var/list/result = list()
	if(SSgamemode.current_storyteller?.wyvern_slot == 0)
		result["final_slots"] = 0
		return result
	if(get_active_player_count(alive_check = 1, afk_check = 1, human_check = 1) < 40)
		result["final_slots"] = 0
		return result
	var/slot_amount = SSgamemode.current_storyteller?.wyvern_slot
	result["final_slots"] = slot_amount
	return result

/proc/wyvernslot_update()
	var/datum/job/wyvern_job = SSjob.GetJob("Gnoll")
	if(!wyvern_job)
		return
	if(wyvern_job.admin_slot_override)
		return
	var/admin_slot = !SSgamemode.allow_vote ? SSgamemode.admin_slots["Gnoll"] : null
	if(!isnull(admin_slot))
		wyvern_job.total_positions = max(wyvern_job.current_positions, max(0, admin_slot))
		wyvern_job.spawn_positions = max(wyvern_job.current_positions, max(0, admin_slot))
		return
	var/list/scaling = wyvernslot_calc()
	var/slots = max(0, scaling["final_slots"])
	wyvern_job.total_positions = max(wyvern_job.current_positions, slots)
	wyvern_job.spawn_positions = max(wyvern_job.current_positions, slots)

/datum/outfit/job/roguetown/wyvern/proc/don_scales(mob/living/carbon/human/H)
	if(H.mind)
		H.set_blindness(0)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/claws/wyvern)
		H.mind.AddSpell(new /datum/action/cooldown/spell/repulse)
		H.mind.AddSpell(new /datum/action/cooldown/spell/message)
		H.AddSpell(new /obj/effect/proc_holder/spell/targeted/woundlick)
		H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/dragons_breath)
		to_chat(H, span_boldwarning("As a wyvern, you are a political entity in the duchy. \
									You are not a mindless beast who chomps peasants and abducts cows. \
									Bargain with the lesser races, strike deals with seekers of riches, \
									and ensure a mutually profitable conclusion for you and your trading partners alike. \
									You sit in the precarious spot of not being a big enough nuisance to justify the resources it would take to hunt you down. \
									Ensure you do not draw the ire of the duchy, lest they wipe you off the map, once and for all. No matter what, your hoard must grow."))
		H.regenerate_icons()
		H.dna.species.regenerate_icons()

/mob/living/carbon/human/proc/wyvern_inspect_skin()
	set name = "Inspect Scales"
	set category = "Wyvern"
	set desc = "Examine your draconic scales armor"
	if(!istype(skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/wyvern_armor))
		to_chat(src, span_warning("You don't have any scales to inspect!"))
		return
	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/wyvern_armor/DA = skin_armor
	DA.Topic(null, list("inspect" = "1"), src)

/datum/advclass/wyvern_magic
	name = "Arcyne Wyvern"
	tutorial = "You are a very intellegent and arcyne talented wyvern who has decided to make the local duchy their home. Walk the fine line between self-enrichment and being hunted down for causing too much grief.\
				Strike deals with locals who stumble upon your lair, and ensure the legacy of your brood will endure for millenia to come."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	outfit = /datum/outfit/job/roguetown/wyvern
	cmode_music = 'sound/music/combat_matthios.ogg'
	category_tags = list(CTAG_WYVERN)
	tempo_capable = TRUE
	traits_applied = list()
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_STR = 5,
		STATKEY_CON = 7,
		STATKEY_WIL = 7,
		STATKEY_INT = 3,
		STATKEY_SPD = -2,
		STATKEY_PER = 3,
		STATKEY_LCK = 3
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
	subclass_mage_aspects = list("mastery" = TRUE, "major" = 2, "minor" = 3, "utilities" = 6, "ward" = TRUE)

/datum/outfit/job/roguetown/wyvern/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/wyvern)
		H.regenerate_icons()
		H.dna.species.regenerate_icons()
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/wyvern_armor(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		don_scales(H)


/datum/advclass/wyvern_miracles
	name = "Arcyracle Wyvern"
	tutorial = "You are a very intellegent wyvern, who put it's life in serving gods and learning arcyne, and magicaly talented wyvern who has decided to make the local duchy their home. Walk the fine line between self-enrichment and being hunted down for causing too much grief.\
				Strike deals with locals who stumble upon your lair, and ensure the legacy of your brood will endure for millenia to come."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	outfit = /datum/outfit/job/roguetown/wyvern
	cmode_music = 'sound/music/combat_matthios.ogg'
	category_tags = list(CTAG_WYVERN)
	tempo_capable = TRUE
	traits_applied = list()
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_STR = 5,
		STATKEY_CON = 7,
		STATKEY_WIL = 7,
		STATKEY_INT = 3,
		STATKEY_SPD = -2,
		STATKEY_PER = 3,
		STATKEY_LCK = 3
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
	subclass_mage_aspects = list("mastery" = TRUE, "major" = 1, "minor" = 1, "utilities" = 4, "ward" = TRUE)

/datum/outfit/job/roguetown/wyvern/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/wyvern)
		H.regenerate_icons()
		H.dna.species.regenerate_icons()
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/wyvern_armor(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		don_scales(H)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, start_maxed = FALSE)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/convert_heretic)
