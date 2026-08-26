/datum/ducal_court
	var/obj/structure/roguemachine/titan/throat
	var/list/usurpation_rite_options_cache
	var/mob/living/carbon/human/usurpation_rite_options_cache_user
	var/usurpation_rite_options_cache_expires = 0

/datum/ducal_court/proc/get_throat()
	if(QDELETED(throat))
		throat = null
		for(var/obj/structure/roguemachine/titan/T in world)
			if(QDELETED(T))
				continue
			throat = T
			break
	return throat

/datum/ducal_court/proc/get_court_locale()
	switch(SSmapping.config?.map_name)
		if("Rockhill")
			return "kingdom"
		if("Desert Town")
			return "sultanate"
	return "duchy"

/datum/ducal_court/proc/user_has_crown(mob/living/carbon/human/user)
	return istype(user?.head, /obj/item/clothing/head/roguetown/crown/serpcrown)

/datum/ducal_court/proc/user_has_ducal_authority(mob/living/carbon/human/user)
	return SSticker.rulermob == user || SSticker.regentmob == user

/datum/ducal_court/proc/user_has_lord_job(mob/living/carbon/human/user)
	if(!user?.job)
		return FALSE
	return istype(SSjob.GetJob(user.job), /datum/job/roguetown/lord)

/datum/ducal_court/proc/user_near_throne(mob/living/carbon/human/user)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	return throne && get_dist(user, throne) <= RITE_ASSENT_RANGE

/datum/ducal_court/proc/user_seated_on_throne(mob/user)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	return throne && (user in throne.buckled_mobs)

/datum/ducal_court/proc/get_usurpation_rite_types()
	var/static/list/available_rites = list(
		/datum/usurpation_rite/solar_succession,
		/datum/usurpation_rite/lunar_ascension,
		/datum/usurpation_rite/martial_supercession,
		/datum/usurpation_rite/golden_accord,
		/datum/usurpation_rite/sacred_supercession,
		/datum/usurpation_rite/progressive_dominion,
		/datum/usurpation_rite/popular_acclaim,
		/datum/usurpation_rite/psydonian_tribunal,
	)
	return available_rites

/datum/ducal_court/proc/get_usurpation_rite_prototypes()
	var/static/list/rite_prototypes
	if(!rite_prototypes)
		rite_prototypes = list()
		for(var/rite_type in get_usurpation_rite_types())
			rite_prototypes[rite_type] = new rite_type()
	return rite_prototypes

/datum/ducal_court/proc/get_usurpation_rite_options(mob/living/carbon/human/user, use_cache = TRUE)
	if(use_cache && usurpation_rite_options_cache && usurpation_rite_options_cache_user == user && world.time < usurpation_rite_options_cache_expires)
		return usurpation_rite_options_cache

	var/list/all_rites = list()
	var/any_eligible = FALSE
	var/list/rite_prototypes = get_usurpation_rite_prototypes()
	for(var/rite_type in get_usurpation_rite_types())
		var/datum/usurpation_rite/rite_prototype = rite_prototypes[rite_type]
		if(!rite_prototype)
			continue
		var/can_use = rite_prototype.can_invoke(user)
		if(can_use)
			any_eligible = TRUE
		all_rites += list(list(
			"name" = rite_prototype.name,
			"desc" = rite_prototype.desc,
			"explanation" = rite_prototype.explanation,
			"type_path" = "[rite_type]",
			"eligible" = can_use,
		))

	var/list/options = list(
		"rites" = all_rites,
		"any_eligible" = any_eligible,
	)
	if(use_cache)
		usurpation_rite_options_cache = options
		usurpation_rite_options_cache_user = user
		usurpation_rite_options_cache_expires = world.time + 1 SECONDS
	return options

/datum/ducal_court/proc/has_available_usurpation_rite(mob/living/carbon/human/user)
	var/list/rite_options = get_usurpation_rite_options(user)
	return rite_options["any_eligible"]

/datum/ducal_court/proc/court_mob_name(mob/person, fallback = null)
	if(!person)
		return fallback
	return person.real_name || person.name || fallback

/datum/ducal_court/proc/get_court_colors()
	return list(
		"primary" = GLOB.lordprimary || "#007fff",
		"secondary" = GLOB.lordsecondary || "#ffffff",
		"fallback" = !(GLOB.lordprimary && GLOB.lordsecondary),
	)

/datum/ducal_court/proc/get_rite_assent_total(datum/usurpation_rite/rite)
	var/datum/usurpation_rite/solar_succession/solar = rite
	if(istype(solar))
		return solar.get_assent_total()
	var/datum/usurpation_rite/sacred_supercession/sacred = rite
	if(istype(sacred))
		return sacred.get_assent_total()
	var/datum/usurpation_rite/popular_acclaim/acclaim = rite
	if(istype(acclaim))
		return acclaim.get_assent_total()
	return length(rite.assenters)

/datum/ducal_court/proc/get_rite_required_assents(datum/usurpation_rite/rite)
	var/datum/usurpation_rite/solar_succession/solar = rite
	if(istype(solar))
		return solar.get_required_assents()
	var/static/list/required_by_type = list(
		/datum/usurpation_rite/lunar_ascension = LUNAR_REQUIRED_MAGES,
		/datum/usurpation_rite/martial_supercession = MARTIAL_REQUIRED_ASSENTS,
		/datum/usurpation_rite/golden_accord = GOLDEN_REQUIRED_ASSENTS,
		/datum/usurpation_rite/sacred_supercession = BISHOPRIC_REQUIRED_ASSENTS,
		/datum/usurpation_rite/progressive_dominion = DOMINION_REQUIRED_ASSENTS,
		/datum/usurpation_rite/popular_acclaim = ACCLAIM_REQUIRED_ASSENTS,
		/datum/usurpation_rite/psydonian_tribunal = TRIBUNAL_REQUIRED_ASSENTS,
	)
	return required_by_type[rite.type] || 0

/datum/ducal_court/proc/get_throne_rite_data()
	var/list/rite_data = list(
		"active" = FALSE,
		"name" = "None",
		"stage" = "none",
		"stage_label" = "None",
		"status" = "No active succession.",
		"claimant" = null,
		"contester" = null,
		"supporters" = 0,
		"supporters_required" = 0,
		"time_remaining_seconds" = null,
	)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	var/datum/usurpation_rite/rite = throne?.active_rite
	if(!rite)
		return rite_data

	var/stage = "none"
	var/stage_label = "None"
	var/time_remaining_seconds
	switch(rite.stage)
		if(RITE_STAGE_GATHERING)
			stage = "gathering"
			stage_label = "Gathering"
			time_remaining_seconds = max(round((RITE_GATHERING_DURATION - (world.time - rite.started_at)) / (1 SECONDS)), 0)
		if(RITE_STAGE_CONTESTING)
			stage = "contesting"
			stage_label = rite.contester ? "Contesting - Paused" : "Contesting"
			if(rite.contester)
				time_remaining_seconds = max(round(rite.contest_time_remaining / (1 SECONDS)), 0)
			else
				var/elapsed = world.time - rite.contest_started_at
				time_remaining_seconds = max(round((rite.contest_time_remaining - elapsed) / (1 SECONDS)), 0)
		if(RITE_STAGE_COMPLETE)
			stage = "resolution"
			stage_label = "Resolution"

	rite_data["active"] = TRUE
	rite_data["name"] = rite.name
	rite_data["stage"] = stage
	rite_data["stage_label"] = stage_label
	rite_data["status"] = rite.get_status_text() || "A claim is active."
	rite_data["claimant"] = rite.invoker?.real_name
	rite_data["contester"] = rite.contester?.real_name
	rite_data["supporters"] = get_rite_assent_total(rite)
	rite_data["supporters_required"] = get_rite_required_assents(rite)
	rite_data["time_remaining_seconds"] = time_remaining_seconds
	return rite_data

/datum/ducal_court/proc/get_rebellion_status()
	for(var/datum/team/prebels/rebels in GLOB.antagonist_teams)
		if(rebels.rite_won)
			return "won"
		if(rebels.rebellion_declared)
			return "declared"
	return null

/datum/ducal_court/proc/get_court_status_cards(mob/living/carbon/human/user, list/rite_data)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	var/occupied = length(throne?.buckled_mobs)
	var/mob/occupant = occupied ? throne.buckled_mobs[1] : null
	var/mob/ruler = SSticker.rulermob
	var/mob/regent = SSticker.regentmob
	if(!islist(rite_data))
		rite_data = get_throne_rite_data()
	var/rebellion = get_rebellion_status()
	var/stability = "Stable"
	var/stability_detail = "No open revolt in the realm."
	if(rebellion == "won")
		stability_detail = "The people have seized the throne."
	else if(rebellion == "declared")
		stability_detail = "The commonfolk are in open revolt."
	if(rite_data["stage"] == "gathering")
		stability = "Claim Gathering"
	else if(rite_data["stage"] == "contesting")
		stability = "Contested"
	else if(rebellion == "won")
		stability = "Rebel Victory"
	else if(rebellion == "declared")
		stability = "Open Rebellion"

	return list(
		list(
			"id" = "throne_status",
			"label" = "Throne Status",
			"value" = occupied ? "Occupied" : "Empty",
			"detail" = occupied ? court_mob_name(occupant, "Unknown occupant") : "No one is seated.",
			"tone" = occupied ? "good" : "neutral",
		),
		list(
			"id" = "crown_required",
			"label" = "Crown Authority",
			"value" = user_has_crown(user) ? "Crown Worn" : "Crown Missing",
			"detail" = user_has_crown(user) ? "Ducal commands are unlocked by the crown." : "Most commands require the crown.",
			"tone" = user_has_crown(user) ? "good" : "bad",
		),
		list(
			"id" = "active_rite",
			"label" = "Active Rite",
			"value" = rite_data["stage_label"],
			"detail" = rite_data["name"],
			"tone" = rite_data["active"] ? "warning" : "good",
		),
		list(
			"id" = "realm_stability",
			"label" = "Realm Stability",
			"value" = stability,
			"detail" = stability_detail,
			"tone" = rebellion ? "bad" : (rite_data["active"] ? "warning" : "good"),
		),
		list(
			"id" = "current_ruler",
			"label" = "Current Ruler",
			"value" = court_mob_name(ruler, "None"),
			"detail" = regent ? "Regent: [court_mob_name(regent)]" : "No active regent.",
			"tone" = ruler ? "good" : "warning",
		),
	)

/datum/ducal_court/proc/court_action_data(mob/living/carbon/human/user, id, label, desc, list/requirements)
	var/blocker = court_action_blocker(user, id)
	return list(
		"id" = id,
		"label" = label,
		"desc" = desc,
		"requirements" = requirements || list(),
		"enabled" = !blocker,
		"disabled_reason" = blocker,
	)

/datum/ducal_court/proc/get_court_actions(mob/living/carbon/human/user)
	return list(
		"main" = list(
			court_action_data(user, "make_announcement", "Make Announcement", "Broadcast a realm-wide message.", list("Crown", "Broadcast Ready")),
			court_action_data(user, "revise_charter", "Revise Charter", "Open the charter ledger.", list("Crown", "Ruler/Regent")),
			court_action_data(user, "issue_decree", "Issue Decree", "Proclaim a ducal decree.", list("Crown", "Ruler/Regent", "Broadcast Ready")),
			court_action_data(user, "set_laws", "Set Laws", "Rewrite the laws of the land.", list("Crown", "Ruler/Regent", "Broadcast Ready")),
			court_action_data(user, "set_taxes", "Set Taxes", "Adjust levies and poll taxes.", list("Crown", "Ruler/Regent")),
			court_action_data(user, "declare_outlaw", "Declare Outlaw", "Outlaw or pardon a named subject.", list("Crown", "Ruling Office", "Broadcast Ready")),
		),
		"tools" = list(
			court_action_data(user, "change_colors", "Change Colors", "Change the realm's colors.", list("Crown", "Ruler/Regent")),
			court_action_data(user, "summon_crown", "Summon Crown", "Retrieve the crown if law permits.", list("Throat")),
			court_action_data(user, "summon_key", "Summon Key", "Retrieve the ruler's key.", list("Crown")),
			court_action_data(user, "restore_charter", "Restore Charter", "Open charters to restore suspended writs.", list("Crown", "Ruler/Regent")),
			court_action_data(user, "purge_laws", "Purge Laws", "Remove every current law.", list("Crown", "Ruler/Regent", "Broadcast Ready")),
			court_action_data(user, "purge_decrees", "Purge Decrees", "Remove every decree.", list("Crown", "Ruler/Regent", "Broadcast Ready")),
			court_action_data(user, "become_regent", "Become Regent", "Claim regency when the ruler is absent.", list("Crown", "Noble Blood", "Regency Office")),
		),
		"rites" = list(
			court_action_data(user, "ascend", "I Ascend", "Invoke a rite of succession.", list("Eligible Rite")),
			court_action_data(user, "assent", "I Assent", "Support an active claim near the throne.", list("Active Gathering", "Near Throne")),
			court_action_data(user, "abdicate", "I Abdicate", "Yield the throne and skip to contestation.", list("Ruler/Regent", "Near Throne")),
			court_action_data(user, "stop_ascent", "Stop Ascent", "Sit on the throne to halt succession.", list("Contesting", "Seated")),
		),
	)

/datum/ducal_court/ui_state(mob/user)
	return GLOB.throne_seated_state

/datum/ducal_court/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DucalCourt", "Двор")
		ui.open()

/datum/ducal_court/ui_data(mob/user)
	var/list/data = list()
	var/list/rite_data = get_throne_rite_data()
	data["court_locale"] = get_court_locale()
	data["realm_type"] = SSticker.realm_type || "Realm"
	data["realm_name"] = SSticker.realm_name || "Realm"
	var/mob/ruler = SSticker.rulermob
	var/mob/regent = SSticker.regentmob
	data["ruler"] = court_mob_name(ruler)
	data["regent"] = court_mob_name(regent)
	data["realm_colors"] = get_court_colors()
	data["rite"] = rite_data
	data["law_count"] = islist(GLOB.laws_of_the_land) ? length(GLOB.laws_of_the_land) : 0
	data["decree_count"] = islist(GLOB.lord_decrees) ? length(GLOB.lord_decrees) : 0
	if(!ishuman(user))
		data["viewer_status"] = "Observer"
		data["status_cards"] = list()
		data["main_actions"] = list()
		data["tool_actions"] = list()
		data["rite_actions"] = list()
		return data
	var/mob/living/carbon/human/H = user
	var/list/actions = get_court_actions(H)
	data["viewer_status"] = user_has_ducal_authority(H) ? "Ducal Authority" : (user_has_crown(H) ? "Crown Bearer" : "Subject")
	data["status_cards"] = get_court_status_cards(H, rite_data)
	data["main_actions"] = actions["main"]
	data["tool_actions"] = actions["tools"]
	data["rite_actions"] = actions["rites"]
	return data
