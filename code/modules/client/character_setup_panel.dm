/datum/character_setup_panel
	var/datum/preferences/prefs
	var/active_customizer_type
	var/customizer_filter = ""
	var/customizer_window_start = 1
	var/customizer_window_size = 8
	var/active_job_slot_title = null
	var/mob/last_user
	var/list/cached_active_customizer_payload
	var/cached_active_customizer_payload_key = null
	var/active_customizer_payload_generation = 1
	var/list/cached_slot_summaries
	var/list/cached_body_marking_catalog
	var/cached_body_marking_catalog_key = null
	var/list/cached_job_slot_choices
	var/cached_job_slot_choices_key = null
	var/datum/character_setup_jobs_panel/jobs_panel
	var/customizer_catalog_generation = 1
	var/list/cached_visible_customizer_types
	var/cached_visible_customizer_types_key = null
	var/list/cached_customizer_summary_payload
	var/cached_customizer_summary_payload_key = null
	var/list/cached_genital_customizer_payload
	var/cached_genital_customizer_payload_key = null
	var/list/cached_body_context_customizer_payload
	var/cached_body_context_customizer_payload_key = null
	var/cached_primary_hair_payload = null
	var/cached_primary_hair_payload_key = null
	var/last_primary_hair_custom_mask_version = null
	var/cached_facial_hair_payload = null
	var/cached_facial_hair_payload_key = null
	var/queued_ui_update = FALSE
	var/queued_ui_update_generation = 0
	var/queued_preview_refresh = FALSE
	var/queued_customizer_catalog_refresh = FALSE
	var/queued_active_customizer_refresh = FALSE
	var/queued_slot_summary_refresh = FALSE
	var/queued_jobs_refresh = FALSE
	var/job_catalog_in_static_data = FALSE
	var/processing_tgui_action = FALSE
	var/preview_refresh_generation = 0
	var/preview_refresh_requested = FALSE
	var/preview_refresh_worker_running = FALSE
	var/preview_visible = FALSE
	var/character_preview_map_id
	var/character_preview_grid_size = 3
	var/character_preview_grid_overridden = FALSE
	var/character_preview_direction = SOUTH
	var/character_preview_floor = "harem"
	var/atom/movable/screen/character_setup_preview/character_preview

/datum/character_setup_panel/New(datum/preferences/prefs_owner)
	prefs = prefs_owner
	character_preview_map_id = "character_setup_preview_[copytext(md5("[REF(src)]"), 1, 9)]"
	return ..()

/datum/character_setup_panel/Destroy()
	if(prefs)
		prefs.character_setup_tgui_active = FALSE
	preview_visible = FALSE
	preview_refresh_generation++
	preview_refresh_requested = FALSE
	QDEL_NULL(character_preview)
	QDEL_NULL(jobs_panel)
	prefs = null
	last_user = null
	character_preview_map_id = null
	return ..()

/datum/character_setup_panel/ui_state(mob/user)
	return GLOB.new_player_state

/datum/character_setup_panel/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/character_setup_hair_icons),
		get_asset_datum(/datum/asset/spritesheet_batched/character_setup_marking_icons),
		get_asset_datum(/datum/asset/spritesheet_batched/character_setup_culinary_icons),
		get_asset_datum(/datum/asset/spritesheet_batched/loadout_icons)
	)

/datum/character_setup_panel/ui_static_data(mob/user)
	var/list/loadout_catalog = list()
	if(prefs?.loadoutpanel)
		loadout_catalog = prefs.loadoutpanel.ui_static_data(user)

	var/list/job_catalog = list()
	if(prefs)
		job_catalog = prefs.character_setup_job_catalog(user)
	job_catalog_in_static_data = length(job_catalog) > 0

	var/list/voice_type_choices = list()
	for(var/voice_name in GLOB.voice_types_list)
		voice_type_choices += "[voice_name]"

	return list(
		"hair_option_catalog" = get_hair_option_catalog(),
		"culinary_option_catalog" = list(
			"cuisine" = build_culinary_axis_options_payload(GLOB.culinary_cuisines),
			"dish" = build_culinary_axis_options_payload(GLOB.culinary_dishes),
			"drink" = build_culinary_axis_options_payload(GLOB.culinary_drinks)
		),
		"loadout_catalog" = loadout_catalog,
		"job_catalog" = job_catalog,
		"max_save_slots" = prefs?.max_save_slots || 0,
		"voice_type_choices" = voice_type_choices,
		"keybinding_catalog" = build_keybinding_catalog(),
		"preference_limits" = list(
			voice_pitch_min = MIN_VOICE_PITCH,
			voice_pitch_max = MAX_VOICE_PITCH,
			body_size_min = round(BODY_SIZE_MIN * 100 + 0.5),
			body_size_max = round(BODY_SIZE_MAX * 100 + 0.5),
			vice_limit = MAX_VICES
		),
		"preview_floor_options" = list(
			list(id = "harem", name = "Арлекинская"),
			list(id = "cobblerock", name = "Каменная"),
			list(id = "dirt_road", name = "Земляная")
		),
		"context_selector_catalog" = build_static_context_selector_catalog()
	)

/datum/character_setup_panel/proc/get_jobs_panel()
	if(!jobs_panel)
		jobs_panel = new /datum/character_setup_jobs_panel(prefs, src)
	return jobs_panel

/datum/character_setup_panel/proc/ensure_character_preview()
	if(character_preview)
		return character_preview
	if(!SSatoms || SSatoms.initialized != INITIALIZATION_INNEW_REGULAR)
		return null
	character_preview = new(prefs, character_preview_map_id)
	character_preview.current_direction = character_preview_direction
	character_preview.grid_size_overridden = character_preview_grid_overridden
	character_preview.set_grid_size(character_preview_grid_size)
	character_preview.set_floor(character_preview_floor)
	return character_preview

/datum/character_setup_panel/proc/build_character_preview_payload()
	return list(
		map_id = character_preview_map_id,
		grid_size = character_preview?.grid_size || character_preview_grid_size
	)

/datum/character_setup_panel/proc/update_character_preview_payload()
	if(preview_visible)
		SStgui.update_uis(src)

/datum/character_setup_panel/proc/invalidate_character_preview()
	preview_refresh_requested = TRUE

/datum/character_setup_panel/proc/queue_preview_refresh(delay = 1, invalidate_cache = FALSE)
	if(!preview_visible || !prefs || !last_user?.client)
		return

	if(invalidate_cache)
		invalidate_character_preview()
	else
		preview_refresh_requested = TRUE

	if(preview_refresh_worker_running)
		return

	preview_refresh_worker_running = TRUE
	var/current_refresh_generation = preview_refresh_generation
	spawn(delay)
		while(preview_refresh_requested && preview_visible && current_refresh_generation == preview_refresh_generation)
			preview_refresh_requested = FALSE
			render_character_preview(current_refresh_generation)
			if(preview_refresh_requested && preview_visible && current_refresh_generation == preview_refresh_generation)
				sleep(1)

		preview_refresh_worker_running = FALSE
		if(preview_refresh_requested && preview_visible)
			queue_preview_refresh(1)

/datum/character_setup_panel/proc/render_character_preview(expected_refresh_generation)
	if(!preview_visible || expected_refresh_generation != preview_refresh_generation || !prefs || !last_user?.client)
		return
	var/atom/movable/screen/character_setup_preview/preview = ensure_character_preview()
	if(!preview)
		preview_refresh_requested = TRUE
		return
	preview.display_to(last_user.client)
	var/previous_grid_size = preview.grid_size
	if(!preview.update_body())
		preview_refresh_requested = TRUE
		return
	character_preview_grid_size = preview.grid_size
	if(previous_grid_size != preview.grid_size)
		update_character_preview_payload()

/datum/character_setup_panel/proc/rotate_character_preview(turn_direction)
	if(turn_direction == "left")
		character_preview_direction = turn(character_preview_direction, 90)
	else if(turn_direction == "right")
		character_preview_direction = turn(character_preview_direction, -90)
	else
		return
	var/atom/movable/screen/character_setup_preview/preview = ensure_character_preview()
	if(preview)
		preview.current_direction = character_preview_direction
		if(preview.body)
			preview.body.dir = character_preview_direction
		preview.dir = character_preview_direction

/datum/character_setup_panel/proc/cycle_character_preview_grid()
	character_preview_grid_overridden = TRUE
	character_preview_grid_size = character_preview_grid_size >= 4 ? 2 : character_preview_grid_size + 1
	var/atom/movable/screen/character_setup_preview/preview = ensure_character_preview()
	if(preview)
		preview.grid_size_overridden = TRUE
		preview.set_grid_size(character_preview_grid_size)
	update_character_preview_payload()

/datum/character_setup_panel/proc/set_character_preview_floor(new_floor)
	switch(new_floor)
		if("harem", "cobblerock", "dirt_road")
			character_preview_floor = new_floor
		else
			return FALSE
	var/atom/movable/screen/character_setup_preview/preview = ensure_character_preview()
	if(preview)
		preview.set_floor(character_preview_floor)
	return TRUE

/datum/character_setup_panel/proc/sync_character_preview_control(mob/user)
	if(!preview_visible || !user?.client)
		return
	last_user = user
	var/atom/movable/screen/character_setup_preview/preview = ensure_character_preview()
	if(!preview)
		queue_preview_refresh(1, TRUE)
		return
	preview.set_floor(character_preview_floor)
	preview.grid_size_overridden = character_preview_grid_overridden
	preview.set_grid_size(character_preview_grid_size)
	preview.current_direction = character_preview_direction
	if(!preview.body && !preview.update_body())
		queue_preview_refresh(1, TRUE)
		return
	preview.display_to(user.client, TRUE)

/datum/character_setup_panel/proc/prepare_preferences_state(preference = null)
	if(!prefs)
		return

	var/full_validation = isnull(preference) || preference == "open" || preference == "changeslot" || preference == "undo"
	var/static/list/customizer_validation_preferences = list("gender", "species", "subspecies", "customizer", "markings", "body", "taur_type", "taur_color")
	var/customizer_validation = full_validation || (preference in customizer_validation_preferences)
	if(customizer_validation)
		prefs.validate_customizer_entries()
		prefs.validate_body_markings()

	if(full_validation || preference == "descriptors" || preference == "species" || preference == "subspecies")
		if(hascall(prefs, "validate_descriptors"))
			call(prefs, "validate_descriptors")()

	if(full_validation || preference == "culinary")
		if(hascall(prefs, "sanitize_culinary_preferences"))
			call(prefs, "sanitize_culinary_preferences")()

	if(full_validation || preference == "familiar")
		var/datum/familiar_prefs/fam = prefs.familiar_prefs
		if(fam)
			if(!fam.familiar_names)
				fam.New(prefs)
			if(!fam.familiar_flavortext || !istype(fam.familiar_flavortext))
				fam.instantiate_examine_prefs()
			for(var/planar_origin in list("fae", "infernal", "elemental", "void"))
				var/list/planar_list = GLOB.planar_lists[planar_origin]
				if(!islist(planar_list))
					continue
				var/current_species = fam.familiar_species[planar_origin]
				var/current_species_valid = FALSE
				var/only_species
				var/species_count = 0
				for(var/species_name in planar_list)
					var/species_type = planar_list[species_name]
					species_count++
					only_species = species_type
					if(species_type == current_species)
						current_species_valid = TRUE
				if(!current_species_valid)
					fam.familiar_species[planar_origin] = species_count == 1 ? only_species : null

	if(full_validation || preference == "species" || preference == "subspecies" || preference == "race_bonus_select")
		var/race_bonus_available = prefs.pref_species && length(prefs.pref_species.custom_selection)
		if(!race_bonus_available || (prefs.race_bonus && !(prefs.race_bonus in prefs.pref_species.custom_selection)))
			prefs.race_bonus = null

	if(full_validation || preference == "preset_bounty")
		if(prefs.preset_bounty_severity_key && !GLOB.wretch_severities[prefs.preset_bounty_severity_key])
			prefs.preset_bounty_severity_key = null
		if(prefs.preset_bounty_severity_b_key && !GLOB.bandit_severities[prefs.preset_bounty_severity_b_key])
			prefs.preset_bounty_severity_b_key = null
		if(prefs.preset_bounty_severity_v_key && !GLOB.vagabond_severities[prefs.preset_bounty_severity_v_key])
			prefs.preset_bounty_severity_v_key = null
		if(prefs.preset_bounty_poster_key && !GLOB.bounty_posters[prefs.preset_bounty_poster_key])
			prefs.preset_bounty_poster_key = null

	if(full_validation || customizer_validation)
		var/current_custom_hair_version = get_primary_hair_custom_mask_version()
		if(isnull(last_primary_hair_custom_mask_version))
			last_primary_hair_custom_mask_version = current_custom_hair_version
		else if(current_custom_hair_version != last_primary_hair_custom_mask_version)
			last_primary_hair_custom_mask_version = current_custom_hair_version
			cached_primary_hair_payload = null
			cached_primary_hair_payload_key = null
			invalidate_active_customizer_payload()
			queue_preview_refresh(1, TRUE)

/datum/character_setup_panel/ui_interact(mob/user, datum/tgui/ui)
	last_user = user
	if(!ui)
		prepare_preferences_state("open")
		ensure_active_customizer()
	prefs.character_setup_tgui_active = TRUE
	prefs.handle_loadout_size(user)
	prefs.clean_loadout(user)
	preview_visible = TRUE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterSetup")
		ui.set_autoupdate(FALSE)
		ui.open()
	queue_preview_refresh(2)

/datum/character_setup_panel/ui_close(mob/user)
	. = ..()
	if(prefs)
		prefs.character_setup_tgui_active = FALSE
	preview_visible = FALSE
	preview_refresh_generation++
	preview_refresh_requested = FALSE
	character_preview?.hide_from_client()

/datum/character_setup_panel/proc/refresh_from_legacy()
	if(!prefs || !last_user?.client || processing_tgui_action)
		return
	prepare_preferences_state()
	invalidate_customizer_catalog_payload()
	ensure_active_customizer()
	invalidate_active_customizer_payload()
	cached_slot_summaries = null
	invalidate_jobs_payload_cache()
	queue_preview_refresh(1, TRUE)
	SStgui.update_uis(src)
	if(jobs_panel)
		SStgui.update_uis(jobs_panel)

/datum/character_setup_panel/proc/character_setup_plaintext(value)
	if(isnull(value))
		return ""
	var/text = "[value]"
	var/start = findtext(text, "<")
	while(start)
		var/finish = findtext(text, ">", start)
		if(!finish)
			break
		text = "[copytext(text, 1, start)][copytext(text, finish + 1)]"
		start = findtext(text, "<")
	text = replacetext(text, "&nbsp;", " ")
	text = replacetext(text, "&amp;", "&")
	text = replacetext(text, "&lt;", "<")
	text = replacetext(text, "&gt;", ">")
	return trim(text)

/datum/character_setup_panel/proc/manor_type_display_name(manor_type)
	switch(manor_type)
		if("manor")
			return "Manor"
		if("hunter_mansion")
			return "Hunter Mansion"
		if("village")
			return "Village"
		if("fisher_hamlet")
			return "Fisher Hamlet"
		if("mining_settlement")
			return "Mining Settlement"
	return "Manor"

/datum/character_setup_panel/proc/invalidate_active_customizer_payload()
	active_customizer_payload_generation++
	cached_active_customizer_payload = null
	cached_active_customizer_payload_key = null

/datum/character_setup_panel/proc/invalidate_customizer_catalog_payload()
	customizer_catalog_generation++
	cached_visible_customizer_types = null
	cached_visible_customizer_types_key = null
	cached_customizer_summary_payload = null
	cached_customizer_summary_payload_key = null
	cached_genital_customizer_payload = null
	cached_genital_customizer_payload_key = null
	cached_body_context_customizer_payload = null
	cached_body_context_customizer_payload_key = null
	cached_primary_hair_payload = null
	cached_primary_hair_payload_key = null
	cached_facial_hair_payload = null
	cached_facial_hair_payload_key = null
	invalidate_active_customizer_payload()

/datum/character_setup_panel/proc/invalidate_jobs_payload_cache()
	cached_job_slot_choices = null
	cached_job_slot_choices_key = null

/datum/character_setup_panel/proc/queue_ui_update(refresh_preview = FALSE, refresh_customizer_catalog = FALSE, refresh_active_customizer = FALSE, refresh_slot_summaries = FALSE, refresh_jobs = FALSE)
	if(refresh_preview)
		queued_preview_refresh = TRUE
	if(refresh_customizer_catalog)
		queued_customizer_catalog_refresh = TRUE
	if(refresh_active_customizer)
		queued_active_customizer_refresh = TRUE
	if(refresh_slot_summaries)
		queued_slot_summary_refresh = TRUE
	if(refresh_jobs)
		queued_jobs_refresh = TRUE

	queued_ui_update_generation++
	var/current_generation = queued_ui_update_generation
	queued_ui_update = TRUE
	spawn(2)
		if(!queued_ui_update)
			return
		if(current_generation != queued_ui_update_generation)
			return
		flush_queued_ui_update()

/datum/character_setup_panel/proc/flush_queued_ui_update()
	var/refresh_preview = queued_preview_refresh
	var/refresh_customizer_catalog = queued_customizer_catalog_refresh
	var/refresh_active_customizer = queued_active_customizer_refresh
	var/refresh_slot_summaries = queued_slot_summary_refresh
	var/refresh_jobs = queued_jobs_refresh

	queued_ui_update = FALSE
	queued_preview_refresh = FALSE
	queued_customizer_catalog_refresh = FALSE
	queued_active_customizer_refresh = FALSE
	queued_slot_summary_refresh = FALSE
	queued_jobs_refresh = FALSE

	if(refresh_customizer_catalog)
		invalidate_customizer_catalog_payload()
		ensure_active_customizer()
	else if(refresh_active_customizer)
		invalidate_active_customizer_payload()

	if(refresh_slot_summaries)
		cached_slot_summaries = null

	if(refresh_preview)
		queue_preview_refresh(2, TRUE)

	if(refresh_jobs)
		invalidate_jobs_payload_cache()

	SStgui.update_uis(src)
	if(jobs_panel && refresh_jobs)
		SStgui.update_uis(jobs_panel)


/datum/character_setup_panel/ui_data(mob/user)
	var/list/data = list()
	if(!prefs || !user)
		return data

	data["character_preview"] = build_character_preview_payload()

	data["slot_summaries"] = build_slot_summaries()

	var/datum/faith/selected_faith
	if(prefs.selected_patron)
		selected_faith = GLOB.faithlist[prefs.selected_patron.associated_faith]

	var/list/vices = list()
	for(var/datum/charflaw/cf as anything in prefs.charflaws)
		vices += "[cf]"

	var/extra_language_name = "None"
	if(ispath(prefs.extra_language, /datum/language))
		var/datum/language/extra_language_type = prefs.extra_language
		extra_language_name = initial(extra_language_type.name)

	data["loaded_slot"] = prefs.loaded_slot
	var/player_quality_html = get_playerquality(user.ckey, text = TRUE)
	data["player_quality"] = character_setup_plaintext(player_quality_html)
	data["player_quality_color"] = null
	var/color_start = findtext(player_quality_html, "color:")
	if(color_start)
		color_start += length("color:")
		var/color_end = findtext(player_quality_html, ";", color_start)
		if(color_end)
			data["player_quality_color"] = trim(copytext(player_quality_html, color_start, color_end))
	var/triumphs_value = user.get_triumphs()
	if(isnull(triumphs_value) || triumphs_value == "")
		triumphs_value = 0
	data["triumphs"] = triumphs_value
	data["loadout_count"] = prefs.selected_loadout_items ? prefs.selected_loadout_items.len : 0
	if(prefs.loadoutpanel)
		data["loadout_state"] = prefs.loadoutpanel.ui_data(user)
	data["species_warning"] = prefs.spec_check(user) ? null : "У выбранной расы или подрасы есть ограничение для раундстарта."
	data["identity"] = list(
		real_name = prefs.real_name,
		nickname = prefs.nickname,
		pronouns = "[prefs.pronouns]",
		titles = "[prefs.titles_pref]",
		clothes = "[prefs.clothes_pref]",
		voice_type = "[prefs.voice_type]",
		voice_pack = "[prefs.voice_pack]",
		accent = prefs.char_accent,
		voice_color = prefs.voice_color,
		voice_pitch = prefs.voice_pitch,
		highlight_color = prefs.highlight_color,
		dnr_pref = prefs.dnr_pref,
		combat_music = prefs.combat_music ? (prefs.combat_music.shortname ? prefs.combat_music.shortname : prefs.combat_music.name) : "Default",
		domhand = (prefs.domhand == 1) ? "Left-handed" : "Right-handed",
		defiant = prefs.defiant
	)
	var/list/species_taur_list = prefs.pref_species ? prefs.pref_species.get_taur_list() : null
	var/race_bonus_available = prefs.pref_species && length(prefs.pref_species.custom_selection)
	var/race_bonus_display = prefs.race_bonus ? prefs.race_bonus : "None"
	var/mutant_colors_available = prefs.pref_species && ((MUTCOLORS in prefs.pref_species.species_traits) || (MUTCOLORS_PARTSONLY in prefs.pref_species.species_traits))
	var/mutant_color_1 = prefs.features["mcolor"]
	var/mutant_color_2 = prefs.features["mcolor2"]
	var/mutant_color_3 = prefs.features["mcolor3"]
	mutant_color_1 = mutant_color_1 ? "#[mutant_color_1]" : "#FFFFFF"
	mutant_color_2 = mutant_color_2 ? "#[mutant_color_2]" : "#FFFFFF"
	mutant_color_3 = mutant_color_3 ? "#[mutant_color_3]" : "#FFFFFF"
	var/datum/customizer_entry/organ/eyes/eyes_entry = prefs.get_customizer_entry_of_type(/datum/customizer_entry/organ/eyes)
	var/eye_color = eyes_entry ? eyes_entry.eye_color : prefs.get_eye_color()
	var/eye_second_color = eyes_entry ? eyes_entry.second_color : eye_color
	if(!eye_second_color)
		eye_second_color = eye_color
	var/eye_heterochromia = eyes_entry?.heterochromia ? TRUE : FALSE
	var/eye_heterochromia_available = FALSE
	if(eyes_entry)
		var/datum/customizer_choice/organ/eyes/eyes_choice = CUSTOMIZER_CHOICE(eyes_entry.customizer_choice_type)
		eye_heterochromia_available = eyes_choice?.allows_heterochromia ? TRUE : FALSE
	data["appearance"] = list(
		species = prefs.pref_species ? prefs.pref_species.base_name : "None",
		subspecies = prefs.pref_species ? prefs.pref_species.sub_name : "None",
		origin = "[prefs.virtue_origin]",
		statpack = prefs.statpack ? prefs.statpack.name : "None",
		faith = selected_faith ? selected_faith.name : "None",
		patron = prefs.selected_patron ? prefs.selected_patron.name : "None",
		extra_language = extra_language_name,
		gender_label = pronoun_gender_label(prefs.pronouns, prefs.gender),
		body_is_feminine = (prefs.gender == FEMALE),
		age = prefs.age,
		hair_color = prefs.get_hair_color(),
		eye_color = eye_color,
		eye_second_color = eye_second_color,
		eye_heterochromia = eye_heterochromia,
		eye_heterochromia_available = eye_heterochromia_available,
		skin_tone = prefs.skin_tone,
		skin_tone_wording = prefs.pref_species?.skin_tone_wording || "Skin Tone",
		uses_skin_tones = prefs.pref_species?.use_skintones ? TRUE : FALSE,
		update_mutant_colors = prefs.update_mutant_colors ? TRUE : FALSE,
		mutant_colors_available = mutant_colors_available,
		mutant_color_1 = mutant_color_1,
		mutant_color_2 = mutant_color_2,
		mutant_color_3 = mutant_color_3,
		body_size = round((prefs.features["body_size"] || 1) * 100 + 0.5),
		taur_type = taur_label(prefs.taur_type),
		taur_color = prefs.taur_color,
		taur_available = LAZYLEN(species_taur_list) ? TRUE : FALSE,
		statpack_virtuous = prefs.statpack?.virtuous ? TRUE : FALSE,
		race_bonus = race_bonus_display,
		race_bonus_available = race_bonus_available,
		averse_faction = prefs.averse_chosen_faction
	)
	data["virtues"] = list(
		virtue = prefs.virtue ? prefs.virtue.name : "None",
		virtue_two = prefs.virtuetwo ? prefs.virtuetwo.name : "None",
		vices = vices
	)
	var/descriptor_count = LAZYLEN(prefs.descriptor_entries) + LAZYLEN(prefs.custom_descriptors)
	var/culinary_count = (prefs.favorite_cuisine ? 1 : 0) + (prefs.favorite_dish ? 1 : 0) + (prefs.favorite_drink ? 1 : 0)
	var/list/sfw_gallery = list()
	if(islist(prefs.img_gallery))
		for(var/entry in prefs.img_gallery)
			sfw_gallery += "[entry]"
	var/list/nsfw_gallery = list()
	if(islist(prefs.nsfw_img_gallery))
		for(var/entry in prefs.nsfw_img_gallery)
			nsfw_gallery += "[entry]"
	data["roleplay"] = list(
		flavortext = prefs.flavortext ? prefs.flavortext : "",
		ooc_notes = prefs.ooc_notes ? prefs.ooc_notes : "",
		rumour = prefs.rumour ? prefs.rumour : "",
		noble_gossip = prefs.noble_gossip ? prefs.noble_gossip : "",
		headshot_link = prefs.headshot_link ? prefs.headshot_link : "",
		lich_headshot_link = prefs.lich_headshot_link ? prefs.lich_headshot_link : "",
		vampire_headshot_link = prefs.vampire_headshot_link ? prefs.vampire_headshot_link : "",
		nsfwflavortext = prefs.nsfwflavortext ? prefs.nsfwflavortext : "",
		erpprefs = prefs.erpprefs ? prefs.erpprefs : "",
		descriptor_count = descriptor_count,
		culinary_count = culinary_count,
		sfw_gallery_count = LAZYLEN(prefs.img_gallery),
		nsfw_gallery_count = LAZYLEN(prefs.nsfw_img_gallery),
		sfw_gallery = sfw_gallery,
		nsfw_gallery = nsfw_gallery,
		music_url = prefs.ooc_extra ? prefs.ooc_extra : "",
		song_artist = prefs.song_artist ? prefs.song_artist : "",
		song_title = prefs.song_title ? prefs.song_title : "",
		have_manor = prefs.have_manor,
		manor_name = prefs.manor_name ? prefs.manor_name : "Unknown Manor",
		manor_type = manor_type_display_name(prefs.manor_type)
	)
	data["context_selectors"] = build_context_selectors_payload()
	data["vice_catalog"] = build_vice_catalog(user)
	data["selected_vices"] = build_selected_vice_ids()
	data["descriptor_editor"] = build_descriptor_editor_payload()
	data["culinary_editor"] = build_culinary_editor_payload()
	data["familiar_editor"] = build_familiar_editor_payload()
	data["origin_choices"] = build_origin_choices()
	data["antag_roles"] = build_antag_role_entries(user)
	data["villain_settings"] = list(
		lich_headshot_link = prefs.lich_headshot_link ? prefs.lich_headshot_link : "",
		vampire_headshot_link = prefs.vampire_headshot_link ? prefs.vampire_headshot_link : "",
		qsr_pref = prefs.qsr_pref,
		vampire_skin = prefs.vampire_skin,
		vampire_eyes = prefs.vampire_eyes,
		vampire_hair = prefs.vampire_hair,
		vampire_ears = prefs.vampire_ears,
		storyteller_enabled = !prefs.no_storyteller_events,
		preset_bounty_enabled = prefs.preset_bounty_enabled,
		preset_bounty_poster = GLOB.bounty_posters[prefs.preset_bounty_poster_key] || "None",
		preset_bounty_wretch_severity = GLOB.wretch_severities[prefs.preset_bounty_severity_key] || "None",
		preset_bounty_bandit_severity = GLOB.bandit_severities[prefs.preset_bounty_severity_b_key] || "None",
		preset_bounty_vagabond_severity = GLOB.vagabond_severities[prefs.preset_bounty_severity_v_key] || "None",
		preset_bounty_crime = prefs.preset_bounty_crime ? prefs.preset_bounty_crime : "None"
	)
	var/list/all_tgui_themes = get_tgui_themes()
	var/is_admin_user = FALSE
	if(user?.ckey && (GLOB.admin_datums[user.ckey] || GLOB.deadmins[user.ckey]))
		is_admin_user = TRUE
	var/examine_theme_name = "None (Use Viewer's)"
	if(prefs.examine_theme)
		examine_theme_name = all_tgui_themes[prefs.examine_theme] || prefs.examine_theme
	data["system_settings"] = list(
		preview_floor = character_preview_floor,
		preview_floor_name = character_setup_preview_floor_label(character_preview_floor),
		tgui_theme = prefs.tgui_theme,
		tgui_theme_name = all_tgui_themes[prefs.tgui_theme] || prefs.tgui_theme || "Default",
		parchment_skin_name = prefs.get_parchment_skin_display_name(),
		statbrowser_theme_name = prefs.get_statbrowser_theme_display_name(),
		examine_theme_name = examine_theme_name,
		tgui_lock = prefs.tgui_lock,
		ambientocclusion = prefs.ambientocclusion,
		windowflashing = prefs.windowflashing,
		clientfps = prefs.clientfps,
		auto_fit_viewport = prefs.auto_fit_viewport,
		widescreenpref = prefs.widescreenpref,
		chat_on_map = prefs.chat_on_map,
		see_chat_non_mob = prefs.see_chat_non_mob,
		buttons_locked = prefs.buttons_locked,
		anonymize = prefs.anonymize,
		masked_examine = prefs.masked_examine,
		full_examine = prefs.full_examine,
		mute_animal_emotes = prefs.mute_animal_emotes,
		no_examine_blocks = prefs.no_examine_blocks,
		no_autopunctuate = prefs.no_autopunctuate,
		no_language_fonts = prefs.no_language_fonts,
		no_language_icon = prefs.no_language_icon,
		no_redflash = prefs.no_redflash,
		is_admin = is_admin_user,
		play_admin_midis = !!(prefs.toggles & SOUND_MIDI),
		hear_adminhelps = !!(prefs.toggles & SOUND_ADMINHELP),
		asaycolor = prefs.asaycolor,
		can_edit_asaycolor = CONFIG_GET(flag/allow_admin_asaycolor),
		deadmin_always = !!(prefs.toggles & DEADMIN_ALWAYS),
		deadmin_antag = !!(prefs.toggles & DEADMIN_ANTAGONIST),
		deadmin_head = !!(prefs.toggles & DEADMIN_POSITION_HEAD),
		schizo_voice = !!(prefs.toggles & SCHIZO_VOICE),
		can_use_donor_visuals = ta_is_donor_visual_ckey(user.ckey),
		donor_ooc_color = prefs.donor_ooc_color,
		donor_ooc_icon = prefs.donor_ooc_icon,
		donor_examine_icon = prefs.donor_examine_icon,
		deadmin_always_forced = CONFIG_GET(flag/auto_deadmin_players),
		deadmin_antag_forced = CONFIG_GET(flag/auto_deadmin_antagonists),
		deadmin_head_forced = CONFIG_GET(flag/auto_deadmin_heads)
	)

	var/list/body_marking_summary = list()
	for(var/zone in GLOB.marking_zones)
		var/list/zone_markings = prefs.body_markings[zone]
		var/list/names = list()
		if(zone_markings)
			for(var/name in zone_markings)
				names += "[name]"
		body_marking_summary += list(list(
			zone = "[zone]",
			label = zone_label(zone),
			count = zone_markings ? zone_markings.len : 0,
			names = names
		))
	data["body_markings"] = body_marking_summary
	data["body_marking_catalog"] = build_body_marking_catalog()
	data["customizer_summaries"] = build_customizer_summary_payload(user)
	data["genital_customizers"] = build_genital_customizer_payload()
	data["body_context_customizers"] = build_body_context_customizer_payload()
	data["hair_customizer"] = build_primary_hair_payload()
	data["facial_hair_customizer"] = build_facial_hair_payload()

	data["active_customizer"] = build_active_customizer_payload(user)

	data["keybind_mode"] = prefs.hotkeys ? "Hotkey" : "Classic"
	data["keybinding_values"] = build_keybinding_values()

	var/datum/character_setup_jobs_panel/job_panel = get_jobs_panel()
	job_panel.last_user = user
	var/list/job_data = job_panel.main_ui_data(user)
	for(var/key in job_data)
		data[key] = job_data[key]

	return data

/datum/character_setup_panel/proc/build_slot_summaries()
	if(!cached_slot_summaries)
		cached_slot_summaries = list()
		var/savefile/S
		if(prefs.path)
			S = new /savefile(prefs.path)
		for(var/i = 1 to prefs.max_save_slots)
			var/name = null
			var/occupied_class = null
			var/is_empty = TRUE
			if(S)
				S.cd = "/character[i]"
				S["real_name"] >> name
				S["topjob"] >> occupied_class
			if(name)
				is_empty = FALSE
			else
				name = "Слот [i]"
			cached_slot_summaries += list(list(
				index = i,
				name = name,
				occupied_class = occupied_class,
				empty = is_empty
			))

	var/list/output = list()
	for(var/list/slot_entry as anything in cached_slot_summaries)
		var/index = slot_entry["index"]
		var/is_current = (index == prefs.loaded_slot)
		var/name = slot_entry["name"]
		var/occupied_class = slot_entry["occupied_class"]
		var/is_empty = slot_entry["empty"]
		if(is_current && prefs.real_name)
			name = prefs.real_name
			occupied_class = prefs.topjob
			is_empty = FALSE
		output += list(list(
			index = index,
			name = name,
			occupied_class = occupied_class,
			current = is_current,
			empty = is_empty
		))
	return output

/datum/character_setup_panel/proc/get_visible_customizer_types()
	if(cached_visible_customizer_types_key == customizer_catalog_generation && cached_visible_customizer_types)
		return cached_visible_customizer_types

	var/list/output = list()
	if(!prefs || !prefs.pref_species)
		cached_visible_customizer_types = output
		cached_visible_customizer_types_key = customizer_catalog_generation
		return output

	var/list/customizers = prefs.pref_species.customizers
	if(!customizers)
		cached_visible_customizer_types = output
		cached_visible_customizer_types_key = customizer_catalog_generation
		return output

	for(var/customizer_type as anything in customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer || !customizer.is_allowed(prefs))
			continue
		var/customizer_name = lowertext(customizer.name)
		if(customizer_name == "eyes" || customizer_name == "eye")
			continue
		var/datum/customizer_entry/entry = prefs.get_customizer_entry_for_customizer_type(customizer_type)
		if(!entry)
			continue
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/option_count = choice && choice.sprite_accessories ? choice.sprite_accessories.len : 0
		var/is_hair = istype(entry, /datum/customizer_entry/hair)
		var/has_accessory_colors = choice && choice.allows_accessory_color_customization
		var/can_change_choice = customizer.customizer_choices && length(customizer.customizer_choices) > 1
		if(option_count <= 1 && !is_hair && !has_accessory_colors && !can_change_choice)
			continue
		output += list(customizer_type)
	cached_visible_customizer_types = output
	cached_visible_customizer_types_key = customizer_catalog_generation
	return output

/datum/character_setup_panel/proc/ensure_active_customizer()
	var/list/visible_customizers = get_visible_customizer_types()
	if(!visible_customizers.len)
		active_customizer_type = null
		return
	if(!(active_customizer_type in visible_customizers))
		active_customizer_type = visible_customizers[1]
		customizer_window_start = 1
		customizer_filter = ""

/datum/character_setup_panel/proc/build_customizer_summary_payload(mob/user)
	if(cached_customizer_summary_payload_key == customizer_catalog_generation && cached_customizer_summary_payload)
		return cached_customizer_summary_payload
	var/list/output = list()
	var/list/visible_customizers = get_visible_customizer_types()
	for(var/customizer_type as anything in visible_customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		var/datum/customizer_entry/entry = prefs.get_customizer_entry_for_customizer_type(customizer_type)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/sprite_accessory/current_accessory = entry && entry.accessory_type ? SPRITE_ACCESSORY(entry.accessory_type) : null
		var/current_group = customizer_group(customizer)
		if(current_group != "body")
			continue
		var/current_icon = current_accessory ? current_accessory.icon : null
		var/current_icon_state = current_accessory ? current_accessory.icon_state : null
		output += list(list(
			id = "[customizer_type]",
			name = translate_customizer_name(customizer.name),
			disabled = entry.disabled,
			choice_name = choice ? choice.name : "Нет",
			option_count = choice && choice.sprite_accessories ? choice.sprite_accessories.len : 0,
			current_accessory_name = current_accessory ? current_accessory.name : "Нет",
			group = current_group,
			icon = current_icon,
			icon_state = current_icon_state
		))
	cached_customizer_summary_payload = output
	cached_customizer_summary_payload_key = customizer_catalog_generation
	return output

/datum/character_setup_panel/proc/build_genital_customizer_payload()
	if(cached_genital_customizer_payload_key == customizer_catalog_generation && cached_genital_customizer_payload)
		return cached_genital_customizer_payload
	var/list/output = list()
	if(!prefs || !prefs.pref_species)
		return output

	var/list/customizers = prefs.pref_species.customizers
	if(!customizers)
		return output

	for(var/customizer_type as anything in customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer)
			continue
		if(customizer_group(customizer) != "simple")
			continue

		var/list/payload = build_simple_customizer_payload(customizer_type)
		if(payload)
			output += list(payload)
	cached_genital_customizer_payload = output
	cached_genital_customizer_payload_key = customizer_catalog_generation
	return output

/datum/character_setup_panel/proc/ensure_customizer_entry(customizer_type)
	if(!customizer_type || !prefs)
		return null
	var/datum/customizer_entry/existing = prefs.get_customizer_entry_for_customizer_type(customizer_type)
	if(existing)
		return existing
	var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
	if(!customizer || !customizer.customizer_choices || !length(customizer.customizer_choices))
		return null
	var/choice_type = customizer.customizer_choices[1]
	var/datum/customizer_entry/new_entry = customizer.create_customizer_entry(prefs, choice_type)
	if(new_entry)
		prefs.customizer_entries += new_entry
	return new_entry

/datum/character_setup_panel/proc/customizer_size_candidates_for_name(customizer_name)
	var/list/candidates = list("feature_size", "genital_size", "size")
	var/lower_name = lowertext("[customizer_name]")
	if(findtext(lower_name, "penis") || findtext(lower_name, "член") || findtext(lower_name, "cock"))
		candidates = list("penis_size", "cock_size", "member_size", "length", "genital_size", "feature_size", "size") + candidates
	else if(findtext(lower_name, "vagina") || findtext(lower_name, "влаг"))
		candidates = list("vagina_size", "depth", "genital_size", "feature_size", "size") + candidates
	else if(findtext(lower_name, "testicle") || findtext(lower_name, "яич") || findtext(lower_name, "ball"))
		candidates = list("testicles_size", "testicle_size", "balls_size", "ball_size", "genital_size", "feature_size", "size") + candidates
	else if(findtext(lower_name, "breast") || findtext(lower_name, "груд") || findtext(lower_name, "boob"))
		candidates = list("breasts_size", "breast_size", "chest_size", "cup_size", "genital_size", "feature_size", "size") + candidates
	return candidates

/datum/character_setup_panel/proc/get_customizer_size_info(datum/customizer_entry/entry, customizer_name)
	if(!entry)
		return null
	var/list/candidates = customizer_size_candidates_for_name(customizer_name)
	for(var/var_name in candidates)
		if(hasvar(entry, var_name))
			var/current_value = entry.vars[var_name]
			if(!isnull(current_value) && "[current_value]" != "")
				return list(
					var_name = "[var_name]",
					label = "Размер",
					value = current_value,
					is_numeric = isnum(current_value)
				)
	for(var/var_name in entry.vars)
		var/lower_var_name = lowertext("[var_name]")
		if(!(findtext(lower_var_name, "size") || findtext(lower_var_name, "length") || findtext(lower_var_name, "girth") || findtext(lower_var_name, "diameter")))
			continue
		if(lower_var_name in list("icon_size", "window_size", "customizer_window_size"))
			continue
		var/current_value = entry.vars[var_name]
		if(isnull(current_value) || "[current_value]" == "")
			continue
		return list(
			var_name = "[var_name]",
			label = "Размер",
			value = current_value,
			is_numeric = isnum(current_value)
		)
	return null

/datum/character_setup_panel/proc/is_three_step_genital_customizer(customizer_name, customizer_type = null)
	var/search_text = lowertext("[customizer_name] [customizer_type]")
	if(findtext(search_text, "penis") || findtext(search_text, "член") || findtext(search_text, "cock"))
		return TRUE
	if(findtext(search_text, "vagina") || findtext(search_text, "влаг"))
		return TRUE
	if(findtext(search_text, "testicle") || findtext(search_text, "яич") || findtext(search_text, "ball"))
		return TRUE
	if(findtext(search_text, "breast") || findtext(search_text, "груд") || findtext(search_text, "boob"))
		return TRUE
	return FALSE

/datum/character_setup_panel/proc/get_three_step_size_choice_id(current_value)
	if(isnull(current_value))
		return "medium"
	if(isnum(current_value))
		var/num_value = text2num("[current_value]")
		if(num_value <= 1)
			return "small"
		if(num_value >= 3)
			return "large"
		return "medium"
	var/text_value = lowertext("[current_value]")
	if(findtext(text_value, "small") || findtext(text_value, "tiny") || findtext(text_value, "little") || findtext(text_value, "мал"))
		return "small"
	if(findtext(text_value, "large") || findtext(text_value, "huge") || findtext(text_value, "big") || findtext(text_value, "бол"))
		return "large"
	return "medium"

/datum/character_setup_panel/proc/build_three_step_size_options(current_value)
	var/current_id = get_three_step_size_choice_id(current_value)
	return list(
		make_selector_option("small", "Маленький", null, null, current_id == "small"),
		make_selector_option("medium", "Средний", null, null, current_id == "medium"),
		make_selector_option("large", "Большой", null, null, current_id == "large")
	)

/datum/character_setup_panel/proc/three_step_size_value_from_choice(current_value, choice_id)
	if(choice_id == "small")
		if(isnum(current_value))
			return 1
		return "Small"
	if(choice_id == "large")
		if(isnum(current_value))
			return 3
		return "Large"
	if(isnum(current_value))
		return 2
	return "Medium"


/datum/character_setup_panel/proc/build_accessory_color_payload(datum/customizer_choice/choice, datum/customizer_entry/entry)
	if(!choice || !entry || entry.disabled || !entry.accessory_type || !choice.allows_accessory_color_customization)
		return null
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.accessory_type)
	if(!accessory || accessory.color_disabled || accessory.color_keys <= 0)
		return null
	var/list/color_values = color_string_to_list(entry.accessory_colors)
	if(color_values.len != accessory.color_keys)
		choice.reset_accessory_colors(prefs, entry)
		color_values = color_string_to_list(entry.accessory_colors)
	if(color_values.len != accessory.color_keys)
		return null
	var/list/color_labels = list()
	for(var/index in 1 to accessory.color_keys)
		var/named_index = (accessory.color_keys == 1) ? accessory.color_key_name : accessory.color_key_names[index]
		if(!named_index)
			named_index = "Цвет [index]"
		color_labels += named_index
	return list(
		"labels" = color_labels,
		"values" = color_values
	)

/datum/character_setup_panel/proc/build_simple_customizer_payload(customizer_type)
	var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
	var/datum/customizer_entry/entry = ensure_customizer_entry(customizer_type)
	if(!customizer || !entry)
		return null

	var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	var/datum/sprite_accessory/current_accessory = (!entry.disabled && entry.accessory_type) ? SPRITE_ACCESSORY(entry.accessory_type) : null

	var/list/options = list()
	if(choice && choice.sprite_accessories)
		for(var/accessory_type as anything in choice.sprite_accessories)
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
			if(!accessory)
				continue
			options += list(list(
				id = "[accessory_type]",
				name = accessory.name,
				icon = accessory.icon,
				icon_state = accessory.icon_state
			))

	var/list/choice_groups = list()
	if(customizer.customizer_choices)
		for(var/choice_type as anything in customizer.customizer_choices)
			var/datum/customizer_choice/iter_choice = CUSTOMIZER_CHOICE(choice_type)
			if(!iter_choice)
				continue
			choice_groups += list(list(
				id = "[choice_type]",
				name = iter_choice.name,
				current = (choice_type == entry.customizer_choice_type)
			))

	var/translated_name = translate_customizer_name(customizer.name)
	var/list/payload = list(
		id = "[customizer_type]",
		name = translated_name,
		disabled = entry.disabled,
		allows_disabling = customizer.allows_disabling,
		can_change_choice = length(customizer.customizer_choices) > 1,
		choice_name = choice ? choice.name : "Нет",
		choice_groups = choice_groups,
		current_accessory_name = current_accessory ? current_accessory.name : "None",
		selected_accessory_id = current_accessory ? "[entry.accessory_type]" : "__none__",
		option_count = options.len,
		options = options,
		allows_accessory_color_customization = choice ? choice.allows_accessory_color_customization : FALSE,
		group = "simple"
	)

	var/list/size_info = get_customizer_size_info(entry, translated_name)
	if(size_info)
		payload["size_label"] = size_info["label"]
		payload["size_value"] = size_info["value"]
		payload["size_var_name"] = size_info["var_name"]
		payload["size_is_numeric"] = !!size_info["is_numeric"]
		if(is_three_step_genital_customizer(translated_name, customizer_type))
			payload["size_options"] = build_three_step_size_options(size_info["value"])
			payload["size_selected_id"] = get_three_step_size_choice_id(size_info["value"])

	var/list/color_payload = build_accessory_color_payload(choice, entry)
	if(color_payload)
		payload["accessory_color_labels"] = color_payload["labels"]
		payload["accessory_color_values"] = color_payload["values"]

	return payload

/datum/character_setup_panel/proc/should_use_context_menu_customizer(datum/customizer/customizer)
	if(!customizer)
		return FALSE
	if(customizer_group(customizer) != "body")
		return FALSE
	var/name = translate_customizer_name(customizer.name)
	if(name in list("Волосы", "Волосы на лице", "Глаза"))
		return FALSE
	return TRUE

/datum/character_setup_panel/proc/build_context_customizer_payload(customizer_type)
	var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
	var/datum/customizer_entry/entry = ensure_customizer_entry(customizer_type)
	if(!customizer || !entry)
		return null

	var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	var/datum/sprite_accessory/current_accessory = (!entry.disabled && entry.accessory_type) ? SPRITE_ACCESSORY(entry.accessory_type) : null

	var/list/options = list()
	if(choice && choice.sprite_accessories)
		for(var/accessory_type as anything in choice.sprite_accessories)
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
			if(!accessory)
				continue
			options += list(list(
				id = "[accessory_type]",
				name = accessory.name,
				icon = accessory.icon,
				icon_state = accessory.icon_state
			))

	var/list/choice_groups = list()
	if(customizer.customizer_choices)
		for(var/choice_type as anything in customizer.customizer_choices)
			var/datum/customizer_choice/iter_choice = CUSTOMIZER_CHOICE(choice_type)
			if(!iter_choice)
				continue
			choice_groups += list(list(
				id = "[choice_type]",
				name = iter_choice.name,
				current = (choice_type == entry.customizer_choice_type)
			))

	var/list/payload = list(
		id = "[customizer_type]",
		name = translate_customizer_name(customizer.name),
		disabled = entry.disabled,
		allows_disabling = customizer.allows_disabling,
		can_change_choice = length(customizer.customizer_choices) > 1,
		choice_name = choice ? choice.name : "Нет",
		choice_groups = choice_groups,
		current_accessory_name = current_accessory ? current_accessory.name : "None",
		selected_accessory_id = current_accessory ? "[entry.accessory_type]" : "__none__",
		option_count = options.len,
		options = options,
		allows_accessory_color_customization = choice ? choice.allows_accessory_color_customization : FALSE,
		group = "simple"
	)

	var/list/color_payload = build_accessory_color_payload(choice, entry)
	if(color_payload)
		payload["accessory_color_labels"] = color_payload["labels"]
		payload["accessory_color_values"] = color_payload["values"]

	return payload

/datum/character_setup_panel/proc/build_body_context_customizer_payload()
	if(cached_body_context_customizer_payload_key == customizer_catalog_generation && cached_body_context_customizer_payload)
		return cached_body_context_customizer_payload
	var/list/output = list()
	if(!prefs || !prefs.pref_species)
		cached_body_context_customizer_payload = output
		cached_body_context_customizer_payload_key = customizer_catalog_generation
		return output
	var/list/customizers = prefs.pref_species.customizers
	if(!customizers)
		cached_body_context_customizer_payload = output
		cached_body_context_customizer_payload_key = customizer_catalog_generation
		return output
	for(var/customizer_type as anything in customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer)
			continue
		if(!should_use_context_menu_customizer(customizer))
			continue
		var/list/payload = build_context_customizer_payload(customizer_type)
		if(payload)
			output += list(payload)
	cached_body_context_customizer_payload = output
	cached_body_context_customizer_payload_key = customizer_catalog_generation
	return output

/datum/character_setup_panel/proc/get_primary_hair_custom_mask_version()
	var/list/visible_customizers = get_visible_customizer_types()
	for(var/customizer_type as anything in visible_customizers)
		var/datum/customizer_entry/entry = prefs.get_customizer_entry_for_customizer_type(customizer_type)
		if(!istype(entry, /datum/customizer_entry/hair))
			continue
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		if(!istype(choice, /datum/customizer_choice/bodypart_feature/hair/head))
			continue
		var/version = entry.vars["custom_mask_version"]
		return isnum(version) ? version : text2num("[version]")
	return 0

/datum/character_setup_panel/proc/hair_entry_has_custom_style(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return FALSE
	var/list/color_masks = hair_entry.vars["colormasks"]
	if(islist(color_masks) && color_masks.len)
		return TRUE
	return !!hair_entry.vars["maskjson"]

/datum/character_setup_panel/proc/build_primary_hair_payload()
	if(cached_primary_hair_payload_key == customizer_catalog_generation && !isnull(cached_primary_hair_payload))
		return cached_primary_hair_payload
	var/list/visible_customizers = get_visible_customizer_types()
	for(var/customizer_type as anything in visible_customizers)
		var/datum/customizer_entry/entry = prefs.get_customizer_entry_for_customizer_type(customizer_type)
		if(istype(entry, /datum/customizer_entry/hair))
			var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
			var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
			var/datum/sprite_accessory/current_accessory = entry.accessory_type ? SPRITE_ACCESSORY(entry.accessory_type) : null
			var/datum/customizer_entry/hair/hair_entry = entry
			var/list/payload = list(
				id = "[customizer_type]",
				name = translate_customizer_name(customizer ? customizer.name : "Hair"),
				current_accessory_name = current_accessory ? current_accessory.name : "Нет",
				choice_name = choice ? choice.name : "Нет",
				hair_color = hair_entry.hair_color,
				natural_gradient = hair_gradient_label(hair_entry.natural_gradient),
				natural_color = hair_entry.natural_color,
				dye_gradient = hair_gradient_label(hair_entry.dye_gradient),
				dye_color = hair_entry.dye_color
			)
			cached_primary_hair_payload = payload
			cached_primary_hair_payload_key = customizer_catalog_generation
			return payload
	cached_primary_hair_payload = null
	cached_primary_hair_payload_key = customizer_catalog_generation
	return null

/datum/character_setup_panel/proc/build_facial_hair_payload()
	if(cached_facial_hair_payload_key == customizer_catalog_generation && !isnull(cached_facial_hair_payload))
		return cached_facial_hair_payload
	var/list/visible_customizers = get_visible_customizer_types()
	for(var/customizer_type as anything in visible_customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer || translate_customizer_name(customizer.name) != "Волосы на лице")
			continue
		var/datum/customizer_entry/entry = prefs.get_customizer_entry_for_customizer_type(customizer_type)
		if(!istype(entry, /datum/customizer_entry/hair))
			continue
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/sprite_accessory/current_accessory = entry.accessory_type ? SPRITE_ACCESSORY(entry.accessory_type) : null
		var/datum/customizer_entry/hair/hair_entry = entry
		var/option_count = 0
		if(choice?.sprite_accessories)
			for(var/accessory_type as anything in choice.sprite_accessories)
				var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
				if(!accessory || lowertext(accessory.name) in list("shaved", "none", "нет"))
					continue
				option_count += 1
		var/list/payload = list(
			id = "[customizer_type]",
			name = translate_customizer_name(customizer.name),
			current_accessory_name = current_accessory ? current_accessory.name : "Нет",
			choice_name = choice ? choice.name : "Нет",
			option_count = option_count,
			hair_color = hair_entry.hair_color,
			natural_gradient = hair_gradient_label(hair_entry.natural_gradient),
			natural_color = hair_entry.natural_color,
			dye_gradient = hair_gradient_label(hair_entry.dye_gradient),
			dye_color = hair_entry.dye_color
		)
		cached_facial_hair_payload = payload
		cached_facial_hair_payload_key = customizer_catalog_generation
		return payload
	cached_facial_hair_payload = null
	cached_facial_hair_payload_key = customizer_catalog_generation
	return null

/datum/character_setup_panel/proc/get_hair_option_payload(datum/customizer_choice/choice)
	var/static/list/hair_options_by_choice = list()
	if(!choice)
		return list()
	var/cache_key = "[choice.type]"
	if(cache_key in hair_options_by_choice)
		return hair_options_by_choice[cache_key]
	var/list/options = list()
	for(var/accessory_type as anything in choice.sprite_accessories)
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
		if(!accessory)
			continue
		var/icon_class_name = null
		if(accessory.icon && !isnull(accessory.icon_state))
			icon_class_name = "character_setup_hair_icons64x64 [sanitize_css_class_name("[accessory_type]")]"
		options += list(list(
			id = "[accessory_type]",
			name = accessory.name,
			icon_class_name = icon_class_name
		))
	hair_options_by_choice[cache_key] = options
	return options

/datum/character_setup_panel/proc/get_hair_option_catalog()
	var/static/list/hair_option_catalog
	if(hair_option_catalog)
		return hair_option_catalog
	hair_option_catalog = list()
	for(var/choice_type as anything in subtypesof(/datum/customizer_choice))
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(choice_type)
		if(!choice || !ispath(choice.customizer_entry_type, /datum/customizer_entry/hair))
			continue
		hair_option_catalog["[choice.type]"] = get_hair_option_payload(choice)
	return hair_option_catalog

/datum/character_setup_panel/proc/build_active_customizer_payload(mob/user)
	ensure_active_customizer()
	if(!active_customizer_type)
		return null

	var/payload_cache_key = "[active_customizer_payload_generation]|[active_customizer_type]|[customizer_filter]|[customizer_window_start]|[customizer_window_size]"
	if(payload_cache_key == cached_active_customizer_payload_key && cached_active_customizer_payload)
		return cached_active_customizer_payload

	var/datum/customizer/customizer = CUSTOMIZER(active_customizer_type)
	var/datum/customizer_entry/entry = ensure_customizer_entry(active_customizer_type)
	if(!customizer || !entry)
		return null

	var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	var/datum/sprite_accessory/current_accessory = entry.accessory_type ? SPRITE_ACCESSORY(entry.accessory_type) : null
	var/current_group = customizer_group(customizer)
	var/is_hair_entry = istype(entry, /datum/customizer_entry/hair)

	var/list/all_options = list()
	if(is_hair_entry)
		all_options = get_hair_option_payload(choice)
	else if(choice && choice.sprite_accessories)
		for(var/accessory_type as anything in choice.sprite_accessories)
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
			if(!accessory)
				continue
			all_options += list(list(
				id = "[accessory_type]",
				name = accessory.name,
				icon = accessory.icon,
				icon_state = accessory.icon_state
			))

	var/list/filtered_options = list()
	var/filter_text = lowertext(customizer_filter)
	if(is_hair_entry && !length(filter_text))
		filtered_options = all_options
	else
		for(var/list/option in all_options)
			var/option_name = lowertext("[option["name"]]")
			if(!length(filter_text) || findtext(option_name, filter_text))
				filtered_options += list(option)

	var/list/choice_groups = list()
	if(customizer.customizer_choices)
		for(var/choice_type as anything in customizer.customizer_choices)
			var/datum/customizer_choice/iter_choice = CUSTOMIZER_CHOICE(choice_type)
			if(!iter_choice)
				continue
			choice_groups += list(list(
				id = "[choice_type]",
				name = iter_choice.name,
				current = (choice_type == entry.customizer_choice_type)
			))

	var/list/visible_options = list()
	var/window_start = max(1, customizer_window_start)
	if(filtered_options.len < window_start)
		window_start = max(1, filtered_options.len - customizer_window_size + 1)
	var/window_end = min(filtered_options.len, window_start + customizer_window_size - 1)
	if(filtered_options.len)
		if(is_hair_entry)
			visible_options = filtered_options
		else if(current_group == "simple")
			for(var/list/option in filtered_options)
				visible_options += list(option.Copy())
		else
			for(var/i in window_start to window_end)
				var/list/option = filtered_options[i]
				visible_options += list(option.Copy())

	var/list/payload = list(
		id = "[active_customizer_type]",
		name = translate_customizer_name(customizer.name),
		disabled = entry.disabled,
		allows_disabling = customizer.allows_disabling,
		can_change_choice = length(customizer.customizer_choices) > 1,
		choice_id = choice ? "[choice.type]" : null,
		choice_name = choice ? choice.name : "Нет",
		choice_groups = choice_groups,
		current_accessory_name = current_accessory ? current_accessory.name : "Нет",
		selected_accessory_id = entry.accessory_type ? "[entry.accessory_type]" : null,
		option_count = all_options.len,
		total_filtered = filtered_options.len,
		window_start = window_start,
		window_size = is_hair_entry ? max(visible_options.len, 1) : customizer_window_size,
		search_query = customizer_filter,
		options = is_hair_entry ? list() : visible_options,
		allows_accessory_color_customization = choice ? choice.allows_accessory_color_customization : FALSE,
		group = current_group
	)

	var/list/color_payload = build_accessory_color_payload(choice, entry)
	if(color_payload)
		payload["accessory_color_labels"] = color_payload["labels"]
		payload["accessory_color_values"] = color_payload["values"]

	if(is_hair_entry)
		var/datum/customizer_entry/hair/hair_entry = entry
		var/datum/customizer_choice/bodypart_feature/hair/hair_choice = choice
		var/custom_hair_available = istype(hair_choice, /datum/customizer_choice/bodypart_feature/hair/head) && hair_choice.custom_hair_color && hascall(prefs, "open_hair_editor")
		payload["is_hair"] = TRUE
		payload["hair_color"] = hair_entry.hair_color
		payload["natural_gradient"] = hair_gradient_label(hair_entry.natural_gradient)
		payload["natural_color"] = hair_entry.natural_color
		payload["dye_gradient"] = hair_gradient_label(hair_entry.dye_gradient)
		payload["dye_color"] = hair_entry.dye_color
		payload["custom_hair_available"] = custom_hair_available
		payload["custom_hair_applied"] = custom_hair_available && hair_entry_has_custom_style(hair_entry)

	cached_active_customizer_payload_key = payload_cache_key
	cached_active_customizer_payload = payload
	return payload

/datum/character_setup_panel/proc/build_job_slot_choices_cache_key(job_title)
	if(!prefs || !job_title)
		return null
	var/list/key_parts = list()
	key_parts += "job=[job_title]"
	key_parts += "loaded=[prefs.loaded_slot]"
	key_parts += "species=[prefs.pref_species]"
	key_parts += "gender=[prefs.gender]"
	key_parts += "age=[prefs.age]"
	key_parts += "statpack=[prefs.statpack]"
	key_parts += "titles=[prefs.titles_pref]"
	key_parts += "jobchars=[list2params(prefs.job_characters)]"
	return jointext(key_parts, "&")

/datum/character_setup_panel/proc/build_job_slot_choices(job_title)
	var/list/output = list()
	if(!prefs || !job_title)
		return output
	var/cache_key = build_job_slot_choices_cache_key(job_title)
	if(cache_key == cached_job_slot_choices_key && islist(cached_job_slot_choices))
		return cached_job_slot_choices
	var/datum/job/J = SSjob ? SSjob.GetJob(job_title) : null
	if(!J)
		return output
	if(!prefs.path || !fexists(prefs.path))
		output += list(list(id = "default", label = "Активный слот", current = !prefs.job_characters[job_title]))
		cached_job_slot_choices = output
		cached_job_slot_choices_key = cache_key
		return output

	output += list(list(id = "default", label = "Активный слот", current = !prefs.job_characters[job_title]))
	var/savefile/S = new /savefile(prefs.path)
	var/datum/preferences/dummy_pref = new(prefs.parent)
	for(var/i = 1 to prefs.max_save_slots)
		if(i % 5 == 0)
			CHECK_TICK
		dummy_pref.fast_scan_for_job(S, i)
		if(J.validate_prefs_for_job(dummy_pref))
			var/label = "Слот [i] - [dummy_pref.real_name] ([dummy_pref.pref_species.name])"
			output += list(list(id = "[i]", label = label, current = (prefs.job_characters[job_title] == i)))
	qdel(dummy_pref)
	cached_job_slot_choices = output
	cached_job_slot_choices_key = cache_key
	return output


/datum/character_setup_panel/proc/build_antag_role_entries(mob/user)
	var/list/output = list()
	if(!user || !user.client)
		return output

	var/global_antag_ban = is_banned_from(user.ckey, ROLE_SYNDICATE)
	if(global_antag_ban)
		prefs.be_special = list()

	for(var/role_id in GLOB.special_roles_rogue)
		var/disabled_reason = null
		if(global_antag_ban || is_banned_from(user.ckey, role_id))
			disabled_reason = "BANNED"
		else
			var/days_remaining = null
			if(ispath(GLOB.special_roles_rogue[role_id]) && CONFIG_GET(flag/use_age_restriction_for_jobs))
				days_remaining = get_remaining_days(user.client)
			if(days_remaining)
				disabled_reason = "IN [days_remaining] DAYS"

		output += list(list(
			id = "[role_id]",
			name = capitalize("[role_id]"),
			enabled = (role_id in prefs.be_special),
			disabled_reason = disabled_reason
		))
	return output

/datum/character_setup_panel/proc/build_keybinding_catalog()
	var/list/grouped = list()
	for(var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		if(!kb)
			continue
		var/category_name = "[kb.category]"
		if(!grouped[category_name])
			grouped[category_name] = list()
		grouped[category_name] += list(list(
			id = "[kb.name]",
			label = kb.full_name ? kb.full_name : kb.name
		))

	var/list/output = list()
	for(var/category_name in grouped)
		output += list(list(
			name = category_name,
			bindings = grouped[category_name]
		))
	return output

/datum/character_setup_panel/proc/build_keybinding_values()
	var/list/output = list()
	for(var/key in prefs.key_bindings)
		for(var/kb_name in prefs.key_bindings[key])
			if(!islist(output[kb_name]))
				output[kb_name] = list()
			var/list/bind_keys = output[kb_name]
			bind_keys += key
	return output

/datum/character_setup_panel/proc/build_origin_choices()
	var/list/output = list()
	for(var/path as anything in GLOB.virtues)
		var/datum/virtue/V = GLOB.virtues[path]
		if(!V.name)
			continue
		if(!istype(V, /datum/virtue/origin))
			continue
		if(V.restricted == TRUE)
			if((prefs.pref_species.type in V.races))
				continue
		if(istype(V, /datum/virtue/origin/racial))
			if(!(prefs.pref_species.type in V.races))
				continue
		var/description = ""
		if(V.origin_desc)
			description = "[V.origin_desc]"
		else if(V.desc)
			description = "[V.desc]"
		output += list(list(
			id = "[path]",
			name = V.name,
			description = description,
			current = (V.name == prefs.virtue_origin.name)
		))
	return output


/datum/character_setup_panel/proc/make_selector_option(id, name, description = null, meta = null, current = FALSE, group = null, icon = null, icon_state = null)
	var/list/output = list(
		id = "[id]",
		name = "[name]"
	)
	if(!isnull(description) && length("[description]"))
		output["description"] = "[description]"
	if(!isnull(meta) && length("[meta]"))
		output["meta"] = "[meta]"
	if(current)
		output["current"] = TRUE
	if(!isnull(group) && length("[group]"))
		output["group"] = "[group]"
	if(!isnull(icon))
		output["icon"] = icon
	if(!isnull(icon_state))
		output["icon_state"] = icon_state
	return output

/datum/character_setup_panel/proc/build_static_context_selector_catalog()
	var/list/voice_pack_options = list()
	for(var/voice_pack_name in GLOB.voice_packs_list)
		voice_pack_options += list(make_selector_option(voice_pack_name, voice_pack_name))

	var/list/accent_options = list()
	for(var/accent_name in GLOB.character_accents)
		accent_options += list(make_selector_option(accent_name, accent_name))

	var/list/faith_options = list()
	for(var/path as anything in GLOB.preference_faiths)
		var/datum/faith/faith = GLOB.faithlist[path]
		if(!faith?.name)
			continue
		faith_options += list(make_selector_option("[path]", faith.name))

	var/list/age_options = list()
	if(prefs?.pref_species)
		for(var/age_option in prefs.pref_species.possible_ages)
			age_options += list(make_selector_option("[age_option]", "[age_option]"))

	var/list/skin_tone_options = list()
	var/list/skin_list = prefs?.pref_species?.get_skin_list()
	if(islist(skin_list))
		for(var/skin_name in skin_list)
			skin_tone_options += list(make_selector_option("[skin_name]", "[skin_name]"))

	var/static/list/selectable_languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/orcish,
		/datum/language/hellspeak,
		/datum/language/draconic,
		/datum/language/raneshi,
		/datum/language/grenzelhoftian,
		/datum/language/kazengunese,
		/datum/language/lingyuese,
		/datum/language/gyedzenese,
		/datum/language/valorian,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/otavan,
		/datum/language/aavnic,
	)
	var/list/language_options = list(make_selector_option("None", "None"))
	if(prefs?.pref_species)
		for(var/language_type in selectable_languages)
			if(language_type in prefs.pref_species.languages)
				continue
			var/datum/language/language = new language_type()
			var/lang_desc = language?.desc ? "[language.desc]" : null
			language_options += list(make_selector_option("[language_type]", language.name, lang_desc))
			qdel(language)

	var/list/taur_options = list(make_selector_option("None", "None"))
	if(prefs?.pref_species)
		for(var/obj/item/bodypart/taur/taur_type as anything in prefs.pref_species.get_taur_list())
			taur_options += list(make_selector_option("[taur_type]", taur_label(taur_type)))

	return list(
		"voicepack" = list(
			title = "Голосовой пак",
			options = voice_pack_options
		),
		"char_accent" = list(
			title = "Акцент",
			options = accent_options
		),
		"faith" = list(
			title = "Вера",
			options = faith_options
		),
		"age" = list(
			title = "Возраст",
			options = age_options
		),
		"skin_tone" = list(
			title = "Цвет кожи",
			options = skin_tone_options
		),
		"extra_language" = list(
			title = "Дополнительный язык",
			options = language_options
		),
		"taur_type" = list(
			title = "Таур-тело",
			options = taur_options
		)
	)

/datum/character_setup_panel/proc/build_context_selectors_payload()
	var/list/output = list()

	var/list/age_options = list()
	if(prefs.pref_species)
		for(var/age_option in prefs.pref_species.possible_ages)
			age_options += list(make_selector_option("[age_option]", "[age_option]", null, null, prefs.age == age_option))
	output["age"] = list(
		current = "[prefs.age]",
		options = age_options
	)

	var/list/skin_tone_options = list()
	var/list/skin_list = prefs.pref_species?.get_skin_list()
	var/current_skin_label = prefs.skin_tone ? "[prefs.skin_tone]" : "Не задан"
	if(islist(skin_list))
		for(var/skin_name in skin_list)
			var/skin_value = skin_list[skin_name]
			if(skin_value == prefs.skin_tone)
				current_skin_label = "[skin_name]"
			skin_tone_options += list(make_selector_option("[skin_name]", "[skin_name]", null, null, skin_value == prefs.skin_tone))
	output["skin_tone"] = list(
		current = current_skin_label,
		options = skin_tone_options
	)

	output["voicepack"] = list(
		current = prefs.voice_pack ? "[prefs.voice_pack]" : "Default"
	)

	output["char_accent"] = list(
		current = prefs.char_accent ? "[prefs.char_accent]" : "No accent"
	)

	var/current_language_name = "None"
	if(ispath(prefs.extra_language, /datum/language))
		var/datum/language/current_language_type = prefs.extra_language
		current_language_name = initial(current_language_type.name)
	output["extra_language"] = list(
		current = current_language_name
	)

	output["taur_type"] = list(
		current = taur_label(prefs.taur_type)
	)

	var/list/faith_options = list()
	var/datum/faith/selected_faith = prefs.selected_patron ? GLOB.faithlist[prefs.selected_patron.associated_faith] : null
	for(var/path as anything in GLOB.preference_faiths)
		var/datum/faith/faith = GLOB.faithlist[path]
		if(!faith?.name)
			continue
		faith_options += list(make_selector_option("[path]", faith.name, null, null, selected_faith == faith))
	output["faith"] = list(
		current = selected_faith ? selected_faith.name : "None",
		options = faith_options
	)

	var/current_faith = prefs.selected_patron ? prefs.selected_patron.associated_faith : initial(prefs.default_patron.associated_faith)
	var/list/patron_options = list()
	for(var/path as anything in GLOB.patrons_by_faith[current_faith])
		var/datum/patron/patron = GLOB.patronlist[path]
		if(!patron?.name)
			continue
		patron_options += list(make_selector_option("[path]", patron.name, null, null, prefs.selected_patron == patron))
	output["patron"] = list(
		title = "Покровитель",
		current = prefs.selected_patron ? prefs.selected_patron.name : "None",
		options = patron_options
	)

	output["virtue_primary"] = list(
		title = "Особенность",
		current = prefs.virtue ? prefs.virtue.name : "None",
		options = build_virtue_options_payload(TRUE)
	)
	output["virtue_secondary"] = list(
		title = "Вторая особенность",
		current = prefs.virtuetwo ? prefs.virtuetwo.name : "None",
		options = build_virtue_options_payload(FALSE)
	)

	return output

/datum/character_setup_panel/proc/build_virtue_options_payload(primary = TRUE)
	var/list/output = list()
	for(var/path as anything in GLOB.virtues)
		var/datum/virtue/V = GLOB.virtues[path]
		if(!V?.name)
			continue
		if((V.name == prefs.virtue?.name || V.name == prefs.virtuetwo?.name) && !istype(V, /datum/virtue/none))
			if(!V.stackable)
				continue
		if(istype(V, /datum/virtue/origin))
			continue
		if(V.unlisted)
			continue
		if(istype(V, /datum/virtue/heretic) && !istype(prefs.selected_patron, /datum/patron/inhumen))
			continue
		if(V.restricted == TRUE)
			if((prefs.pref_species.type in V.races))
				continue
		if(primary && V.virtuous_only && !prefs.statpack.virtuous)
			continue
		output += list(make_selector_option("[path]", V.name, V.desc, null, primary ? (prefs.virtue?.type == path) : (prefs.virtuetwo?.type == path)))
	return output

/datum/character_setup_panel/proc/charflaw_requirement_meta(flaw_type)
	if(flaw_type == /datum/charflaw/lawless)
		return "Min PQ: [/datum/charflaw/lawless::required_pq] • Только для приключенческих ролей"
	if(flaw_type == /datum/charflaw/gefheretic)
		return "Min PQ: [/datum/charflaw/gefheretic::required_pq] • Только для приключенческих ролей"
	return null

/datum/character_setup_panel/proc/charflaw_restriction_reason(mob/user, flaw_type)
	var/required_pq = null
	if(flaw_type == /datum/charflaw/lawless)
		required_pq = /datum/charflaw/lawless::required_pq
	else if(flaw_type == /datum/charflaw/gefheretic)
		required_pq = /datum/charflaw/gefheretic::required_pq
	else
		return null

	#ifdef USES_PQ
	var/player_quality = user?.ckey ? get_playerquality(user.ckey) : null
	if(isnull(player_quality) || player_quality < required_pq)
		return "Требуется PQ [required_pq]."
	#endif

	var/datum/job/last_job = null
	if(prefs.lastclass && SSjob)
		last_job = SSjob.GetJob(prefs.lastclass)
	if(last_job?.vice_restrictions && (flaw_type in last_job.vice_restrictions))
		return "Недоступно для [last_job.title]. Только для приключенческих ролей."

	return null

/datum/character_setup_panel/proc/build_vice_catalog(mob/user)
	var/list/output = list()
	for(var/key in GLOB.character_flaws)
		var/flaw_type = GLOB.character_flaws[key]
		if(flaw_type == /datum/charflaw/noflaw)
			continue
		var/datum/charflaw/flaw_preview = new flaw_type()
		var/flaw_name = flaw_preview?.name ? flaw_preview.name : "[key]"
		var/description = null
		if(flaw_preview?.desc)
			description = flaw_preview.desc
		qdel(flaw_preview)
		output += list(list(
			id = "[flaw_type]",
			name = flaw_name,
			description = description,
			meta = charflaw_requirement_meta(flaw_type),
			disabled_reason = charflaw_restriction_reason(user, flaw_type)
		))
	return output

/datum/character_setup_panel/proc/build_selected_vice_ids()
	var/list/output = list()
	for(var/datum/charflaw/cf as anything in prefs.charflaws)
		if(istype(cf, /datum/charflaw/noflaw))
			continue
		output += "[cf.type]"
	return output

/datum/character_setup_panel/proc/build_descriptor_editor_payload()
	var/list/output = list(
		entries = list(),
		custom_entries = list()
	)
	for(var/choice_type in prefs.pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		if(!choice)
			continue
		var/datum/descriptor_entry/entry = null
		if(hascall(prefs, "get_descriptor_entry_for_choice"))
			entry = call(prefs, "get_descriptor_entry_for_choice")(choice_type)
		var/datum/mob_descriptor/current_descriptor = entry ? MOB_DESCRIPTOR(entry.descriptor_type) : null
		var/list/options = list()
		for(var/desc_type in choice.descriptors)
			var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
			if(!descriptor)
				continue
			options += list(make_selector_option("[desc_type]", descriptor.name, null, null, entry?.descriptor_type == desc_type))
		output["entries"] += list(list(
			id = "[choice_type]",
			name = choice.name,
			value = current_descriptor ? current_descriptor.name : "None",
			options = options
		))

	var/static/list/translation = CUSTOM_PREFIX_TRANSLATION_LIST
	var/static/list/input_list = CUSTOM_PREFIX_INPUT_LIST
	var/list/prefix_options = list()
	for(var/prefix_name in input_list)
		prefix_options += list(make_selector_option("[input_list[prefix_name]]", prefix_name))
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		var/visible = FALSE
		if(i == 1)
			if(hascall(prefs, "has_descriptor_type_in_entries"))
				visible = call(prefs, "has_descriptor_type_in_entries")(/datum/mob_descriptor/prominent/custom/one)
		else if(i == 2)
			if(hascall(prefs, "has_descriptor_type_in_entries"))
				visible = call(prefs, "has_descriptor_type_in_entries")(/datum/mob_descriptor/prominent/custom/two)
		var/datum/custom_descriptor_entry/custom_entry = length(prefs.custom_descriptors) >= i ? prefs.custom_descriptors[i] : null
		output["custom_entries"] += list(list(
			index = i,
			visible = visible,
			prefix_id = custom_entry ? "[custom_entry.prefix_type]" : "[CUSTOM_PREFIX_HAS_A]",
			prefix_label = custom_entry ? translation["[custom_entry.prefix_type]"] : translation["[CUSTOM_PREFIX_HAS_A]"],
			content = custom_entry?.content_text ? "[custom_entry.content_text]" : "",
			prefix_options = prefix_options
		))
	return output

/datum/character_setup_panel/proc/build_culinary_axis_options_payload(list/options)
	var/list/output = list(make_selector_option("0", "Нет"))
	for(var/label in options)
		output += list(make_selector_option("[options[label]]", "[label]"))
	return output

/datum/character_setup_panel/proc/build_culinary_editor_payload()
	return list(
		entries = list(
			list(key = "cuisine", label = "Любимая кухня", value = culinary_flag_name(GLOB.culinary_cuisines, prefs.favorite_cuisine)),
			list(key = "dish", label = "Любимый тип блюда", value = culinary_flag_name(GLOB.culinary_dishes, prefs.favorite_dish)),
			list(key = "drink", label = "Любимый тип напитка", value = culinary_flag_name(GLOB.culinary_drinks, prefs.favorite_drink))
		)
	)

/datum/character_setup_panel/proc/build_familiar_editor_payload()
	var/datum/familiar_prefs/fam = prefs.familiar_prefs
	if(!fam)
		return list(
			entries = list(),
			pronoun_options = list()
		)
	var/list/pronoun_display = list(
		"[HE_HIM]" = "he/him",
		"[SHE_HER]" = "she/her",
		"[THEY_THEM]" = "they/them",
		"[IT_ITS]" = "it/its"
	)
	var/list/pronoun_options = list(
		make_selector_option("[HE_HIM]", "he/him"),
		make_selector_option("[SHE_HER]", "she/her"),
		make_selector_option("[THEY_THEM]", "they/them"),
		make_selector_option("[IT_ITS]", "it/its")
	)
	var/list/pretty_plane_names = list(
		"fae" = "Fae",
		"infernal" = "Infernal",
		"elemental" = "Elemental",
		"void" = "Void"
	)
	var/list/entries = list()
	for(var/planar_origin in list("fae", "infernal", "elemental", "void"))
		var/list/planar_list = GLOB.planar_lists[planar_origin]
		var/current_species = fam.familiar_species[planar_origin]
		var/effective_species = current_species
		var/current_species_name = "None selected"
		var/list/species_options = list()
		if(planar_list)
			var/only_species_name
			var/only_species_type
			var/species_count = 0
			for(var/species_name in planar_list)
				species_count++
				if(species_count == 1)
					only_species_name = species_name
					only_species_type = planar_list[species_name]
			if(!effective_species && species_count == 1)
				effective_species = only_species_type
				current_species_name = only_species_name
			for(var/species_name in planar_list)
				var/species_type = planar_list[species_name]
				if(species_type == effective_species)
					current_species_name = species_name
				var/species_desc = GLOB.familiar_lore_blurbs[species_type]
				species_options += list(make_selector_option("[species_type]", species_name, species_desc, null, species_type == effective_species))
		var/current_pronouns = fam.familiar_pronouns[planar_origin]
		var/current_pronouns_name = pronoun_display["[current_pronouns]"]
		if(!current_pronouns_name)
			current_pronouns_name = "they/them"
		entries += list(list(
			planar_origin = planar_origin,
			plane_name = pretty_plane_names[planar_origin],
			familiar_name = fam.familiar_names[planar_origin] ? fam.familiar_names[planar_origin] : "",
			familiar_pronouns = current_pronouns_name,
			familiar_headshot_link = fam.familiar_headshot_link[planar_origin] ? fam.familiar_headshot_link[planar_origin] : "",
			familiar_flavortext = fam.familiar_flavortext[planar_origin] ? fam.familiar_flavortext[planar_origin] : "",
			familiar_ooc_notes = fam.familiar_ooc_notes[planar_origin] ? fam.familiar_ooc_notes[planar_origin] : "",
			familiar_ooc_extra_link = fam.familiar_ooc_extra_link[planar_origin] ? fam.familiar_ooc_extra_link[planar_origin] : "",
			familiar_specie = current_species_name,
			lore_blurb = effective_species ? (GLOB.familiar_lore_blurbs[effective_species] || "") : "",
			species_options = species_options
		))
	return list(
		entries = entries,
		pronoun_options = pronoun_options
	)
/datum/character_setup_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/previous_species_type = prefs?.pref_species?.type
	var/was_processing_tgui_action = processing_tgui_action
	processing_tgui_action = TRUE
	var/result = handle_ui_action(action, params, ui, state)
	processing_tgui_action = was_processing_tgui_action
	if(previous_species_type != prefs?.pref_species?.type)
		ui.send_full_update()
		return FALSE
	return result

/datum/character_setup_panel/proc/handle_ui_action(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user
	if(!prefs || !user)
		return FALSE

	switch(action)
		if("link")
			var/list/href_list = list()
			for(var/key in params)
				href_list[key] = "[params[key]]"
			if(href_list["preference"] == "eyes" || href_list["preference"] == "domhand")
				handle_edit_preference(user, href_list["preference"])
				return TRUE
			prefs.process_link(user, href_list)
			var/static/list/save_after_link_preferences = list(
				"tgui_theme",
				"parchment_skin",
				"statbrowser_theme",
				"clientfps",
				"tgui_lock",
				"action_buttons",
				"ambientocclusion",
				"widescreenpref",
				"auto_fit_viewport",
				"winflash",
				"chat_on_map",
				"see_chat_non_mob",
				"examine_theme",
				"hear_midis",
				"hear_adminhelps",
				"asaycolor",
				"toggle_deadmin_always",
				"toggle_deadmin_antag",
				"toggle_deadmin_head",
				"storyteller",
				"schizo_voice",
				"be_defiant"
			)
			if(href_list["preference"] in save_after_link_preferences)
				prefs.save_preferences()
			if(href_list["preference"] == "job")
				invalidate_jobs_payload_cache()
				if(jobs_panel)
					SStgui.update_uis(jobs_panel)
			else
				prepare_update_after_action(user, href_list["preference"])
			return TRUE

		if("sync_preview_control")
			sync_character_preview_control(user)
			return FALSE

		if("rotate_preview")
			last_user = user
			rotate_character_preview(params["direction"])
			return FALSE

		if("cycle_preview_grid")
			last_user = user
			cycle_character_preview_grid()
			return FALSE

		if("set_preview_floor")
			last_user = user
			set_character_preview_floor("[params["floor"]]")
			return FALSE

		if("edit_preference")
			handle_edit_preference(user, params["preference"])
			return TRUE

		if("randomize_name")
			prefs.real_name = prefs.pref_species.random_name(prefs.gender, 1)
			prepare_update_after_action(user, "name")
			return TRUE

		if("manage_charflaws")
			handle_manage_charflaws(user)
			return TRUE

		if("add_charflaw")
			var/flaw_type = text2path(params["flaw"])
			if(flaw_type)
				handle_add_charflaw(user, flaw_type)
			return TRUE

		if("remove_charflaw")
			var/index = text2num(params["index"])
			if(index && index >= 1 && index <= prefs.charflaws.len)
				var/datum/charflaw/cf_to_remove = prefs.charflaws[index]
				prefs.charflaws.Remove(cf_to_remove)
				if(!prefs.charflaws.len)
					var/datum/charflaw/no_flaw = new /datum/charflaw/noflaw()
					prefs.charflaws.Add(no_flaw)
				prepare_update_after_action(user, "charflaw")
			return TRUE

		if("remove_charflaw_type")
			var/flaw_type = text2path(params["flaw"])
			if(flaw_type)
				handle_remove_charflaw(user, flaw_type)
			return TRUE

		if("set_customizer_size_choice")
			var/customizer_type = text2path(params["customizer"])
			var/var_name = "[params["var_name"]]"
			var/choice_id = "[params["value"]]"
			if(customizer_type && var_name && choice_id)
				var/datum/customizer_entry/entry = ensure_customizer_entry(customizer_type)
				if(entry && hasvar(entry, var_name))
					var/current_value = entry.vars[var_name]
					entry.vars[var_name] = three_step_size_value_from_choice(current_value, choice_id)
					prepare_update_after_action(user, "customizer")
			return TRUE

		if("set_voice_pitch_value")
			var/new_voice_pitch = text2num(params["value"])
			if(!isnull(new_voice_pitch))
				prefs.voice_pitch = clamp(new_voice_pitch, MIN_VOICE_PITCH, MAX_VOICE_PITCH)
				prepare_update_after_action(user, "voice_pitch", TRUE)
			return FALSE

		if("set_body_size_value")
			var/new_body_size = text2num(params["value"])
			if(!isnull(new_body_size))
				prefs.features["body_size"] = clamp(new_body_size * 0.01, BODY_SIZE_MIN, BODY_SIZE_MAX)
				prepare_update_after_action(user, "body_size", TRUE)
			return FALSE

		if("set_context_preference")
			handle_set_context_preference(user, params["kind"], params["value"])
			return TRUE

		if("set_descriptor_choice")
			var/choice_type = text2path(params["choice"])
			var/descriptor_type = text2path(params["descriptor"])
			if(choice_type && descriptor_type)
				handle_set_descriptor_choice(user, choice_type, descriptor_type)
			return TRUE

		if("set_custom_descriptor_prefix")
			var/custom_index = text2num(params["index"])
			var/prefix_type = text2num(params["prefix"])
			if(custom_index)
				handle_set_custom_descriptor_prefix(user, custom_index, prefix_type)
			return TRUE

		if("set_custom_descriptor_content")
			var/custom_index = text2num(params["index"])
			if(custom_index)
				handle_set_custom_descriptor_content(user, custom_index, params["value"])
			return TRUE

		if("set_culinary_axis")
			handle_set_culinary_axis(user, params["axis"], params["value"])
			return TRUE

		if("reset_culinary_preferences")
			prefs.favorite_cuisine = NONE
			prefs.favorite_dish = NONE
			prefs.favorite_drink = NONE
			prepare_update_after_action(user, "culinary")
			return TRUE

		if("set_familiar_name")
			handle_set_familiar_name(user, params["planar_origin"], params["value"])
			return TRUE

		if("set_familiar_pronouns")
			handle_set_familiar_pronouns(user, params["planar_origin"], text2num(params["value"]))
			return TRUE

		if("set_familiar_specie")
			handle_set_familiar_specie(user, params["planar_origin"], text2path(params["value"]))
			return TRUE

		if("set_familiar_headshot")
			handle_set_familiar_headshot(user, params["planar_origin"], params["value"])
			return TRUE

		if("set_familiar_flavortext")
			handle_set_familiar_flavortext(user, params["planar_origin"], params["value"])
			return TRUE

		if("set_familiar_ooc_notes")
			handle_set_familiar_ooc_notes(user, params["planar_origin"], params["value"])
			return TRUE

		if("set_familiar_ooc_extra")
			handle_set_familiar_ooc_extra(user, params["planar_origin"], params["value"])
			return TRUE

		if("pulse_familiar")
			handle_familiar_pulse(user)
			return TRUE

		if("loadout_add", "loadout_remove", "loadout_clear", "loadout_pick_color", "loadout_clear_colors", "loadout_boosty")
			var/static/list/loadout_action_map = list(
				"loadout_add" = "add",
				"loadout_remove" = "remove",
				"loadout_clear" = "clear",
				"loadout_pick_color" = "pick_color",
				"loadout_clear_colors" = "clear_colors",
				"loadout_boosty" = "boosty"
			)
			if(prefs.loadoutpanel)
				prefs.loadoutpanel.handle_action(user, loadout_action_map[action], params)
			return TRUE

		if("open_markings")
			if(hascall(prefs, "ShowMarkings"))
				prefs.ShowMarkings(user)
			return TRUE

		if("remove_body_marking")
			prefs.handle_body_markings_topic(user, list(
				"preference" = "remove_marking",
				"key" = "[params["zone"]]",
				"name" = "[params["name"]]"
			))
			prepare_update_after_action(user, "markings")
			return TRUE

		if("clear_body_marking_zone")
			var/zone = params["zone"]
			if(zone && prefs.body_markings[zone])
				prefs.body_markings -= zone
				prepare_update_after_action(user, "markings")
			return TRUE

		if("add_body_marking")
			var/zone = params["zone"]
			var/name = params["name"]
			if(!zone || !name || !(zone in GLOB.marking_zones) || !prefs.pref_species)
				return TRUE
			var/list/possible_markings = marking_list_of_zone_for_species(zone, prefs.pref_species)
			if(!(name in possible_markings))
				return TRUE
			if(!prefs.body_markings[zone])
				prefs.body_markings[zone] = list()
			var/list/zone_markings = prefs.body_markings[zone]
			if(name in zone_markings)
				return TRUE
			if(zone_markings.len >= MAXIMUM_MARKINGS_PER_LIMB)
				return TRUE
			var/datum/body_marking/marking = GLOB.body_markings[name]
			if(!marking)
				return TRUE
			zone_markings[marking.name] = marking.get_default_color(prefs.features, prefs.pref_species)
			prepare_update_after_action(user, "markings")
			return TRUE

		if("apply_gender_preset")
			apply_gender_preset(params["preset"])
			prepare_update_after_action(user, "gender")
			return TRUE

		if("set_gender_body_type")
			var/requested_gender = params["gender"]
			var/target_gender = (requested_gender == "feminine") ? FEMALE : MALE
			if(prefs.gender != target_gender)
				prefs.gender = target_gender
				prefs.genderize_customizer_entries()
				prepare_update_after_action(user, "gender")
			return TRUE

		if("set_voice_identity")
			var/requested_voice = params["voice_type"]
			if(requested_voice && (requested_voice in GLOB.voice_types_list))
				prefs.voice_type = requested_voice
			return TRUE

		if("open_jobs_window")
			var/datum/character_setup_jobs_panel/jobs_window_panel = get_jobs_panel()
			jobs_window_panel.ui_interact(user)
			return FALSE

		if("save_setup")
			prefs.save_preferences()
			prefs.save_character()
			cached_slot_summaries = null
			to_chat(user, span_notice("ПЕРСОНАЖ СОХРАНЁН."))
			return TRUE

		if("undo_setup")
			prefs.load_preferences()
			prefs.load_character()
			active_job_slot_title = null
			cached_slot_summaries = null
			cached_job_slot_choices = null
			cached_job_slot_choices_key = null
			prepare_update_after_action(user, "undo")
			to_chat(user, span_notice("ИЗМЕНЕНИЯ ОТМЕНЕНЫ."))
			return TRUE

		if("done_setup")
			prefs.process_link(user, list("preference" = "finished"))
			if(jobs_panel)
				SStgui.close_uis(jobs_panel)
			ui.close(can_be_suspended = FALSE)
			return FALSE

		if("load_slot")
			var/slot = text2num(params["slot"])
			if(slot >= 1 && slot <= prefs.max_save_slots)
				if(!prefs.load_character(slot))
					prefs.random_character(null, FALSE, FALSE)
				active_job_slot_title = null
				cached_slot_summaries = null
				prepare_update_after_action(user, "changeslot")
			return TRUE

		if("select_origin")
			var/origin_type = text2path(params["origin"])
			if(origin_type && GLOB.virtues[origin_type])
				var/datum/virtue/virtue_chosen = GLOB.virtues[origin_type]
				prefs.virtue_origin = virtue_chosen
				to_chat(user, prefs.process_virtue_text(virtue_chosen))
				prepare_update_after_action(user, "origin")
			return TRUE

		if("refresh_jobs")
			invalidate_jobs_payload_cache()
			if(jobs_panel)
				SStgui.update_uis(jobs_panel)
			return TRUE

		if("open_job_slot", "assign_job_slot", "open_job_details", "close_job_details")
			var/datum/character_setup_jobs_panel/job_action_panel = get_jobs_panel()
			job_action_panel.last_user = user
			job_action_panel.processing_owner_action = TRUE
			var/job_action_changed = job_action_panel.handle_ui_action(action, params, ui, state)
			job_action_panel.processing_owner_action = FALSE
			return job_action_changed

		if("select_customizer")
			var/customizer_type = text2path(params["customizer"])
			if(customizer_type)
				active_customizer_type = customizer_type
				customizer_filter = ""
				customizer_window_start = 1
				invalidate_active_customizer_payload()
			return TRUE

		if("set_customizer_filter")
			var/search_value = params["value"]
			customizer_filter = lowertext("[search_value]")
			customizer_window_start = 1
			queue_ui_update(FALSE, FALSE, TRUE)
			return FALSE

		if("set_customizer_window")
			customizer_window_start = max(1, text2num(params["start"]))
			queue_ui_update(FALSE, FALSE, TRUE)
			return FALSE

		if("set_customizer_accessory")
			var/customizer_type = text2path(params["customizer"])
			var/accessory_type = text2path(params["accessory"])
			if(customizer_type && accessory_type)
				var/datum/customizer_entry/entry = ensure_customizer_entry(customizer_type)
				if(entry)
					var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
					if(choice && choice.sprite_accessories && (accessory_type in choice.sprite_accessories))
						entry.disabled = FALSE
						choice.set_accessory_type(prefs, accessory_type, entry)
						prepare_update_after_action(user, "customizer")
			return TRUE

		if("set_customizer_none")
			var/customizer_type = text2path(params["customizer"])
			if(customizer_type)
				var/datum/customizer_entry/entry = ensure_customizer_entry(customizer_type)
				if(entry)
					entry.disabled = TRUE
					entry.accessory_type = null
					if(hasvar(entry, "accessory_colors"))
						entry:accessory_colors = null
					prepare_update_after_action(user, "customizer")
			return TRUE

		if("toggle_customizer")
			handle_shared_customizer_action(user, action, params)
			return TRUE

		if("set_customizer_choice")
			var/customizer_type = text2path(params["customizer"])
			var/choice_type = text2path(params["choice"])
			if(customizer_type && choice_type)
				var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
				if(customizer && (choice_type in customizer.customizer_choices))
					var/datum/customizer_entry/old_entry = prefs.get_customizer_entry_for_customizer_type(customizer_type)
					var/was_disabled = old_entry ? old_entry.disabled : customizer.default_disabled
					if(old_entry)
						prefs.customizer_entries -= old_entry
					var/datum/customizer_entry/new_entry = customizer.create_customizer_entry(prefs, choice_type)
					if(new_entry)
						new_entry.disabled = params["enable"] ? FALSE : was_disabled
						prefs.customizer_entries += new_entry
					active_customizer_type = customizer_type
					customizer_filter = ""
					customizer_window_start = 1
					prepare_update_after_action(user, "customizer")
			return TRUE

		if("reset_customizer_colors")
			var/customizer_type = text2path(params["customizer"])
			if(customizer_type)
				var/datum/customizer_entry/entry = ensure_customizer_entry(customizer_type)
				if(entry)
					var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
					if(choice)
						if(istype(entry, /datum/customizer_entry/hair))
							var/datum/customizer_entry/hair/hair_entry = entry
							hair_entry.hair_color = initial(hair_entry.hair_color)
							hair_entry.natural_color = initial(hair_entry.natural_color)
							hair_entry.dye_color = initial(hair_entry.dye_color)
							hair_entry.natural_gradient = initial(hair_entry.natural_gradient)
							hair_entry.dye_gradient = initial(hair_entry.dye_gradient)
						choice.reset_accessory_colors(prefs, entry)
						prepare_update_after_action(user, "customizer")
			return TRUE

		if("edit_accessory_color")
			handle_shared_customizer_action(user, action, params)
			return TRUE

		if("edit_customizer_size")
			var/customizer_type = text2path(params["customizer"])
			var/var_name = "[params["var_name"]]"
			if(customizer_type && var_name)
				var/datum/customizer_entry/entry = ensure_customizer_entry(customizer_type)
				if(entry && hasvar(entry, var_name))
					var/current_value = entry.vars[var_name]
					if(isnum(current_value))
						var/new_numeric_value = tgui_input_number(user, "Введите размер.", "Настройка персонажа", current_value)
						if(!isnull(new_numeric_value))
							entry.vars[var_name] = new_numeric_value
							prepare_update_after_action(user, "customizer")
					else
						var/new_text_value = tgui_input_text(user, "Введите значение размера.", "Настройка персонажа", "[current_value]", encode = FALSE)
						if(!isnull(new_text_value))
							entry.vars[var_name] = new_text_value
							prepare_update_after_action(user, "customizer")
			return TRUE
		if("open_custom_hair_editor", "clear_custom_hair", "set_hair_color", "set_natural_gradient", "set_natural_color", "set_dye_gradient", "set_dye_color")
			handle_shared_customizer_action(user, action, params)
			return TRUE

		if("open_descriptors")
			if(hascall(prefs, "show_descriptors_ui"))
				call(prefs, "show_descriptors_ui")(user)
			return TRUE

		if("open_culinary")
			if(hascall(prefs, "show_culinary_ui"))
				call(prefs, "show_culinary_ui")(user)
			return TRUE

		if("open_familiar_prefs")
			if(prefs.familiar_prefs)
				prefs.familiar_prefs.fam_show_ui()
			return TRUE

		if("manage_gallery")
			handle_manage_gallery(user, text2num(params["nsfw"]))
			return TRUE

		if("remove_gallery_image")
			handle_remove_gallery_image(user, text2num(params["nsfw"]), text2num(params["index"]))
			return TRUE

		if("toggle_system_pref")
			handle_toggle_system_pref(user, params["pref"])
			return TRUE

		if("edit_villain_color")
			handle_edit_villain_color(user, params["pref"])
			return TRUE

		if("clear_villain_color")
			handle_clear_villain_color(user, params["pref"])
			return TRUE

		if("set_keybinding")
			handle_set_keybinding(user, params)
			return TRUE

		if("reset_keybindings")
			handle_reset_keybindings(user)
			return TRUE

	return TRUE


/datum/character_setup_panel/proc/handle_shared_customizer_action(mob/user, action, list/params)
	var/customizer_task
	switch(action)
		if("toggle_customizer")
			customizer_task = "toggle_missing"
		if("edit_accessory_color")
			customizer_task = "acc_color"
		if("open_custom_hair_editor")
			customizer_task = "custom_hair_editor"
		if("clear_custom_hair")
			customizer_task = "custom_hair_clear"
		if("set_hair_color")
			customizer_task = "hair_color"
		if("set_natural_gradient")
			customizer_task = "natural_gradient"
		if("set_natural_color")
			customizer_task = "natural_gradient_color"
		if("set_dye_gradient")
			customizer_task = "dye_gradient"
		if("set_dye_color")
			customizer_task = "dye_gradient_color"
	if(!customizer_task)
		return FALSE
	var/customizer_type = text2path(params["customizer"])
	if(!customizer_type)
		return FALSE
	var/list/href_list = list(
		"task" = "change_customizer",
		"customizer" = "[customizer_type]",
		"customizer_task" = customizer_task
	)
	if(action == "edit_accessory_color")
		var/color_index = text2num(params["index"])
		if(color_index <= 0)
			return FALSE
		href_list["color_index"] = "[color_index]"
	prefs.handle_customizer_topic(user, href_list)
	if(action == "clear_custom_hair" && hascall(prefs, "clear_hair_cache"))
		call(prefs, "clear_hair_cache")(customizer_type)
	prepare_update_after_action(user, "customizer")
	return TRUE


/datum/character_setup_panel/proc/handle_toggle_system_pref(mob/user, pref)
	var/changed = FALSE
	switch(pref)
		if("anonymize")
			prefs.anonymize = !prefs.anonymize
			changed = TRUE

		if("masked_examine")
			prefs.masked_examine = !prefs.masked_examine
			changed = TRUE

		if("full_examine")
			prefs.full_examine = !prefs.full_examine
			changed = TRUE

		if("mute_animal_emotes")
			prefs.mute_animal_emotes = !prefs.mute_animal_emotes
			changed = TRUE

		if("no_examine_blocks")
			prefs.no_examine_blocks = !prefs.no_examine_blocks
			changed = TRUE

		if("no_autopunctuate")
			prefs.no_autopunctuate = !prefs.no_autopunctuate
			changed = TRUE

		if("no_language_fonts")
			prefs.no_language_fonts = !prefs.no_language_fonts
			changed = TRUE

		if("no_language_icon")
			prefs.no_language_icon = !prefs.no_language_icon
			changed = TRUE

		if("no_redflash")
			prefs.no_redflash = !prefs.no_redflash
			changed = TRUE

		if("qsr_pref")
			prefs.qsr_pref = !prefs.qsr_pref
			changed = TRUE

	if(changed)
		prefs.save_preferences()

/datum/character_setup_panel/proc/handle_edit_villain_color(mob/user, pref)
	var/current_color = null
	switch(pref)
		if("vampire_skin")
			current_color = prefs.vampire_skin
		if("vampire_eyes")
			current_color = prefs.vampire_eyes
		if("vampire_hair")
			current_color = prefs.vampire_hair
		if("vampire_ears")
			current_color = prefs.vampire_ears

	var/new_color = color_pick_sanitized(user, "Выберите цвет.", "Настройки антагониста", current_color ? current_color : "#FFFFFF")
	if(!new_color)
		return

	switch(pref)
		if("vampire_skin")
			prefs.vampire_skin = sanitize_hexcolor(new_color)
		if("vampire_eyes")
			prefs.vampire_eyes = sanitize_hexcolor(new_color)
		if("vampire_hair")
			prefs.vampire_hair = sanitize_hexcolor(new_color)
		if("vampire_ears")
			prefs.vampire_ears = sanitize_hexcolor(new_color)
		else
			return

	prefs.save_preferences()

/datum/character_setup_panel/proc/handle_clear_villain_color(user, pref)
	switch(pref)
		if("vampire_skin")
			prefs.vampire_skin = null
		if("vampire_eyes")
			prefs.vampire_eyes = null
		if("vampire_hair")
			prefs.vampire_hair = null
		if("vampire_ears")
			prefs.vampire_ears = null
		else
			return
	prefs.save_preferences()

/datum/character_setup_panel/proc/handle_set_keybinding(mob/user, list/params)
	var/kb_name = params["keybinding"]
	if(!kb_name)
		return

	var/clear_key = text2num(params["clear_key"])
	var/old_key = params["old_key"]

	if(clear_key)
		if(old_key && prefs.key_bindings[old_key])
			prefs.key_bindings[old_key] -= kb_name
			if(!length(prefs.key_bindings[old_key]))
				prefs.key_bindings -= old_key
		if(user.client)
			user.client.update_movement_keys()
		prefs.save_preferences()
		return

	var/new_key = uppertext("[params["key"]]")
	var/AltMod = text2num(params["alt"]) ? "Alt" : ""
	var/CtrlMod = text2num(params["ctrl"]) ? "Ctrl" : ""
	var/ShiftMod = text2num(params["shift"]) ? "Shift" : ""
	var/numpad = text2num(params["numpad"]) ? "Numpad" : ""

	if(GLOB._kbMap[new_key])
		new_key = GLOB._kbMap[new_key]

	var/full_key
	switch(new_key)
		if("Alt")
			full_key = "[new_key][CtrlMod][ShiftMod]"
		if("Ctrl")
			full_key = "[AltMod][new_key][ShiftMod]"
		if("Shift")
			full_key = "[AltMod][CtrlMod][new_key]"
		else
			full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"

	if(old_key && prefs.key_bindings[old_key])
		prefs.key_bindings[old_key] -= kb_name
		if(!length(prefs.key_bindings[old_key]))
			prefs.key_bindings -= old_key

	prefs.key_bindings[full_key] += list(kb_name)
	prefs.key_bindings[full_key] = sortList(prefs.key_bindings[full_key])

	if(user.client)
		user.client.update_movement_keys()
	prefs.save_preferences()

/datum/character_setup_panel/proc/handle_reset_keybindings(mob/user)
	var/choice = tgalert(user, "Какие значения по умолчанию применить?", "Сброс клавиш", "Hotkey", "Classic", "Cancel")
	if(choice == "Cancel" || !choice)
		return

	prefs.hotkeys = (choice == "Hotkey")
	prefs.key_bindings = prefs.hotkeys ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)

	if(user.client)
		user.client.update_movement_keys()
	prefs.save_preferences()

/datum/character_setup_panel/proc/find_customizer_type_by_display_name(display_name)
	if(!prefs?.pref_species?.customizers)
		return null
	for(var/customizer_type as anything in prefs.pref_species.customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer)
			continue
		if(translate_customizer_name(customizer.name) == display_name)
			return customizer_type
	return null

/datum/character_setup_panel/proc/default_voice_type_for_gender(gender)
	var/needle = (gender == FEMALE) ? "fem" : "masc"
	for(var/voice_name in GLOB.voice_types_list)
		if(findtext(lowertext("[voice_name]"), needle))
			return voice_name
	return prefs.voice_type

/datum/character_setup_panel/proc/apply_gender_preset(preset)
	var/target_gender = (preset == "feminine") ? FEMALE : MALE
	prefs.gender = target_gender
	prefs.pronouns = (target_gender == FEMALE) ? SHE_HER : HE_HIM
	prefs.titles_pref = (target_gender == FEMALE) ? TITLES_F : TITLES_M
	prefs.clothes_pref = (target_gender == FEMALE) ? CLOTHES_F : CLOTHES_M
	prefs.genderize_customizer_entries()
	prefs.voice_type = default_voice_type_for_gender(target_gender)
	prefs.ResetJobs()

	var/breasts_type = find_customizer_type_by_display_name("Грудь")
	var/vagina_type = find_customizer_type_by_display_name("Влагалище")
	var/penis_type = find_customizer_type_by_display_name("Пенис")
	var/testicles_type = find_customizer_type_by_display_name("Яички")

	if(breasts_type)
		var/datum/customizer_entry/breasts_entry = ensure_customizer_entry(breasts_type)
		if(breasts_entry)
			breasts_entry.disabled = (target_gender == MALE)
	if(vagina_type)
		var/datum/customizer_entry/vagina_entry = ensure_customizer_entry(vagina_type)
		if(vagina_entry)
			vagina_entry.disabled = (target_gender == MALE)
	if(penis_type)
		var/datum/customizer_entry/penis_entry = ensure_customizer_entry(penis_type)
		if(penis_entry)
			penis_entry.disabled = (target_gender == FEMALE)
	if(testicles_type)
		var/datum/customizer_entry/testicles_entry = ensure_customizer_entry(testicles_type)
		if(testicles_entry)
			testicles_entry.disabled = (target_gender == FEMALE)

/datum/character_setup_panel/proc/handle_edit_preference(mob/user, preference)
	var/changed = FALSE
	var/update_key = preference
	switch(preference)
		if("voicetype")
			var/voicetype_input = tgui_input_list(user, "Выберите тип голоса.", "Тип голоса", GLOB.voice_types_list)
			if(voicetype_input)
				prefs.voice_type = voicetype_input
				changed = TRUE

		if("domhand")
			prefs.domhand = prefs.domhand == 1 ? 2 : 1
			changed = TRUE

		if("voicepack")
			var/voicepack_input = tgui_input_list(user, "Выберите голосовой пак.", "Голосовой пак", GLOB.voice_packs_list)
			if(voicepack_input)
				prefs.voice_pack = voicepack_input
				changed = TRUE

		if("eyes")
			var/datum/customizer_entry/organ/eyes/eyes_entry = prefs.get_customizer_entry_of_type(/datum/customizer_entry/organ/eyes)
			if(eyes_entry)
				var/previous_eye_color = eyes_entry.eye_color
				prefs.handle_customizer_topic(user, list(
					"customizer" = "[eyes_entry.customizer_type]",
					"customizer_task" = "eye_color"
				))
				if(eyes_entry.eye_color != previous_eye_color)
					changed = TRUE
					update_key = "customizer"

		if("eye_heterochromia")
			var/datum/customizer_entry/organ/eyes/eyes_entry = prefs.get_customizer_entry_of_type(/datum/customizer_entry/organ/eyes)
			if(eyes_entry)
				var/previous_heterochromia = eyes_entry.heterochromia
				prefs.handle_customizer_topic(user, list(
					"customizer" = "[eyes_entry.customizer_type]",
					"customizer_task" = "heterochromia"
				))
				if(eyes_entry.heterochromia != previous_heterochromia)
					changed = TRUE
					update_key = "customizer"

		if("eye_second_color")
			var/datum/customizer_entry/organ/eyes/eyes_entry = prefs.get_customizer_entry_of_type(/datum/customizer_entry/organ/eyes)
			if(eyes_entry)
				var/previous_second_color = eyes_entry.second_color
				prefs.handle_customizer_topic(user, list(
					"customizer" = "[eyes_entry.customizer_type]",
					"customizer_task" = "second_eye_color"
				))
				if(eyes_entry.second_color != previous_second_color)
					changed = TRUE
					update_key = "customizer"

		if("species")
			var/list/base_species = list()
			for(var/A in GLOB.roundstart_races)
				var/datum/species/race = GLOB.species_list[A]
				race = new race()
				if(!user.client)
					continue
				if(race.patreon_req > user.client.patreonlevel())
					continue
				if(race.is_subrace == TRUE)
					continue
				base_species[race.base_name] = race
			base_species = sortList(base_species)
			var/current_base = prefs.pref_species ? prefs.pref_species.base_name : null
			var/base_result = tgui_input_list(user, "Выберите расу.", "Раса", base_species, current_base)
			if(base_result)
				var/list/subspecies = list()
				for(var/A in GLOB.roundstart_races)
					var/datum/species/subrace = GLOB.species_list[A]
					subrace = new subrace()
					if(!user.client)
						continue
					if(subrace.patreon_req > user.client.patreonlevel())
						continue
					if(subrace.base_name != base_result)
						continue
					subspecies[subrace.sub_name] = subrace
				var/current_sub = (prefs.pref_species && prefs.pref_species.base_name == base_result) ? prefs.pref_species.sub_name : null
				var/sub_result = null
				if(length(subspecies) == 1)
					for(var/only_key in subspecies)
						sub_result = only_key
				else
					sub_result = tgui_input_list(user, "Выберите подрасу.", "Подраса", sortList(subspecies), current_sub)
				if(sub_result)
					var/datum/species/race_chosen = subspecies[sub_result]
					prefs.set_new_race(race_chosen, user)
					changed = TRUE
					update_key = "subspecies"

		if("subspecies")
			var/list/species = list()
			for(var/A in GLOB.roundstart_races)
				var/datum/species/race = GLOB.species_list[A]
				race = new race()
				if(user.client)
					if(race.base_name != prefs.pref_species.base_name)
						continue
					if(race.sub_name == prefs.pref_species.sub_name)
						continue
				else
					continue
				species[race.sub_name] += race
			var/result = tgui_input_list(user, "Выберите подрасу.", "Подраса", species)
			if(result)
				var/datum/species/subrace_chosen = species[result]
				prefs.set_new_race(subrace_chosen, user)
				changed = TRUE
				update_key = "subspecies"

		if("gender")
			var/pickedGender = MALE
			if(prefs.gender == MALE)
				pickedGender = FEMALE
			if(pickedGender && pickedGender != prefs.gender)
				prefs.gender = pickedGender
				prefs.genderize_customizer_entries()
				changed = TRUE

		if("age")
			var/new_age = tgui_input_list(user, "Выберите возраст персонажа.", "Возраст", prefs.pref_species.possible_ages)
			if(new_age)
				prefs.age = new_age
				var/list/hairs
				if((prefs.age == AGE_OLD) && (OLDGREY in prefs.pref_species.species_traits))
					hairs = prefs.pref_species.get_oldhc_list()
				else
					hairs = prefs.pref_species.get_hairc_list()
				prefs.hair_color = hairs[pick(hairs)]
				prefs.facial_hair_color = prefs.hair_color
				show_age_description(user)
				prefs.ResetJobs()
				changed = TRUE

		if("faith")
			var/list/faiths_named = list()
			for(var/path as anything in GLOB.preference_faiths)
				var/datum/faith/faith = GLOB.faithlist[path]
				if(!faith.name)
					continue
				faiths_named[faith.name] = faith
			var/faith_input = tgui_input_list(user, "Выберите веру.", "Вера", faiths_named)
			if(faith_input)
				var/datum/faith/faith = faiths_named[faith_input]
				prefs.selected_patron = GLOB.patronlist[faith.godhead] || GLOB.patronlist[pick(GLOB.patrons_by_faith[faith_input])]
				changed = TRUE

		if("patron")
			var/list/patrons_named = list()
			var/current_faith = prefs.selected_patron ? prefs.selected_patron.associated_faith : initial(prefs.default_patron.associated_faith)
			for(var/path as anything in GLOB.patrons_by_faith[current_faith])
				var/datum/patron/patron = GLOB.patronlist[path]
				if(!patron.name)
					continue
				patrons_named[patron.name] = patron
			var/god_input = tgui_input_list(user, "Выберите покровителя.", "Покровитель", patrons_named)
			if(god_input)
				prefs.selected_patron = patrons_named[god_input]
				changed = TRUE

		if("extra_language")
			var/static/list/selectable_languages = list(
				/datum/language/elvish,
				/datum/language/dwarvish,
				/datum/language/orcish,
				/datum/language/hellspeak,
				/datum/language/draconic,
				/datum/language/raneshi,
				/datum/language/grenzelhoftian,
				/datum/language/kazengunese,
				/datum/language/lingyuese,
				/datum/language/gyedzenese,
				/datum/language/valorian,
				/datum/language/etruscan,
				/datum/language/gronnic,
				/datum/language/otavan,
				/datum/language/aavnic,
			)
			var/list/choices = list("None")
			for(var/language in selectable_languages)
				if(language in prefs.pref_species.languages)
					continue
				var/datum/language/a_language = new language()
				choices[a_language.name] = language
			var/chosen_language = tgui_input_list(user, "Выберите дополнительный язык.", "Язык", choices)
			if(chosen_language)
				if(chosen_language == "None")
					prefs.extra_language = "None"
				else
					prefs.extra_language = choices[chosen_language]
				changed = TRUE

		if("taur_type")
			var/list/species_taur_list = prefs.pref_species.get_taur_list()
			if(!LAZYLEN(species_taur_list))
				prefs.taur_type = null
				to_chat(user, span_bad("Для этой расы нет доступных таур-тел."))
				return
			var/list/taur_selection = list("None")
			for(var/obj/item/bodypart/taur/tt as anything in prefs.pref_species.get_taur_list())
				taur_selection[tt::name] = tt
			var/new_taur_type = tgui_input_list(user, "Выберите тип таур-тела.", "Таур", taur_selection)
			if(new_taur_type)
				if(new_taur_type == "None")
					prefs.taur_type = null
				else
					prefs.taur_type = taur_selection[new_taur_type]
				changed = TRUE

		if("virtue")
			var/list/virtue_choices = list()
			for (var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if (!V.name)
					continue
				if ((V.name == prefs.virtue.name || V.name == prefs.virtuetwo.name) && !istype(V, /datum/virtue/none))
					if(!V.stackable)
						continue
				if (istype(V, /datum/virtue/origin))
					continue
				if(V.unlisted)
					continue
				if (istype(V, /datum/virtue/heretic) && !istype(prefs.selected_patron, /datum/patron/inhumen))
					continue
				if (V.restricted == TRUE)
					if((prefs.pref_species.type in V.races))
						continue
				if(V.virtuous_only && !prefs.statpack.virtuous)
					continue
				virtue_choices[V.name] = V
			virtue_choices = sort_list(virtue_choices)
			var/result = tgui_input_list(user, "Выберите добродетель.", "Добродетель", virtue_choices)
			if(result)
				var/datum/virtue/virtue_chosen = virtue_choices[result]
				prefs.virtue = new virtue_chosen.type
				changed = TRUE

		if("virtuetwo")
			var/list/virtue_choices = list()
			for (var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if (!V.name)
					continue
				if ((V.name == prefs.virtue.name || V.name == prefs.virtuetwo.name) && !istype(V, /datum/virtue/none))
					if(!V.stackable)
						continue
				if (istype(V, /datum/virtue/origin))
					continue
				if(V.unlisted)
					continue
				if (istype(V, /datum/virtue/heretic) && !istype(prefs.selected_patron, /datum/patron/inhumen))
					continue
				if (V.restricted == TRUE)
					if((prefs.pref_species.type in V.races))
						continue
				virtue_choices[V.name] = V
			virtue_choices = sort_list(virtue_choices)
			var/result = tgui_input_list(user, "Выберите вторую добродетель.", "Вторая добродетель", virtue_choices)
			if(result)
				var/datum/virtue/virtue_chosen = virtue_choices[result]
				prefs.virtuetwo = new virtue_chosen.type
				changed = TRUE

		if("char_accent")
			var/selectedaccent = tgui_input_list(user, "Выберите акцент персонажа.", "Акцент", GLOB.character_accents)
			if(selectedaccent)
				prefs.char_accent = selectedaccent
				changed = TRUE

		if("voice_pitch")
			var/new_voice_pitch = tgui_input_number(user, "Выберите высоту голоса ([MIN_VOICE_PITCH] to [MAX_VOICE_PITCH], lower is deeper):", "Voice Pitch", prefs.voice_pitch, 1.35, 0.8, round_value = FALSE)
			if(!isnull(new_voice_pitch))
				if(new_voice_pitch < MIN_VOICE_PITCH || new_voice_pitch > MAX_VOICE_PITCH)
					to_chat(user, span_warning("Значение должно быть между [MIN_VOICE_PITCH] и [MAX_VOICE_PITCH]."))
				else
					prefs.voice_pitch = new_voice_pitch
					changed = TRUE

		if("body_size")
			var/current_body_size = (prefs.features["body_size"] || 1) * 100
			var/new_body_size = tgui_input_number(user, "Choose your desired sprite size:\n([BODY_SIZE_MIN*100]%-[BODY_SIZE_MAX*100]%), Warning: May make your character look distorted", "Character Preference", current_body_size)
			if(!isnull(new_body_size))
				new_body_size = clamp(new_body_size * 0.01, BODY_SIZE_MIN, BODY_SIZE_MAX)
				prefs.features["body_size"] = new_body_size
				changed = TRUE
				update_key = "body"

		if("s_tone")
			var/list/listy = prefs.pref_species.get_skin_list()
			var/new_s_tone = tgui_input_list(user, "Choose your character's skin tone:", "SKINTONE", listy)
			if(new_s_tone)
				prefs.skin_tone = listy[new_s_tone]
				prefs.features["mcolor"] = sanitize_hexcolor(prefs.skin_tone)
				if(hascall(prefs, "try_update_mutant_colors"))
					call(prefs, "try_update_mutant_colors")()
				changed = TRUE
				update_key = "body"

	if(changed)
		prepare_update_after_action(user, update_key)

/datum/character_setup_panel/proc/handle_add_charflaw(mob/user, flaw_type)
	var/restriction_reason = charflaw_restriction_reason(user, flaw_type)
	if(restriction_reason)
		to_chat(user, span_warning(restriction_reason))
		return
	for(var/datum/charflaw/_existing in prefs.charflaws)
		if(istype(_existing, /datum/charflaw/noflaw))
			prefs.charflaws.Remove(_existing)
			break
	if(prefs.charflaws.len >= MAX_VICES)
		to_chat(user, span_warning("Нельзя выбрать больше пороков."))
		return
	for(var/datum/charflaw/cf as anything in prefs.charflaws)
		if(cf.type == flaw_type && !istype(cf, /datum/charflaw/randflaw))
			to_chat(user, span_warning("Этот порок уже выбран."))
			return
	var/datum/charflaw/new_flaw = new flaw_type()
	prefs.charflaws.Add(new_flaw)
	prepare_update_after_action(user, "charflaw")

/datum/character_setup_panel/proc/handle_remove_charflaw(mob/user, flaw_type)
	for(var/datum/charflaw/cf as anything in prefs.charflaws)
		if(istype(cf, /datum/charflaw/noflaw))
			continue
		if(cf.type != flaw_type)
			continue
		prefs.charflaws.Remove(cf)
		break
	var/has_real_flaws = FALSE
	for(var/datum/charflaw/cf as anything in prefs.charflaws)
		if(!istype(cf, /datum/charflaw/noflaw))
			has_real_flaws = TRUE
			break
	if(!has_real_flaws)
		prefs.charflaws.Cut()
		prefs.charflaws.Add(new /datum/charflaw/noflaw())
	prepare_update_after_action(user, "charflaw")

/datum/character_setup_panel/proc/can_select_virtue(virtue_type, primary = TRUE)
	var/datum/virtue/V = GLOB.virtues[virtue_type]
	if(!V?.name)
		return FALSE
	if((V.name == prefs.virtue?.name || V.name == prefs.virtuetwo?.name) && !istype(V, /datum/virtue/none))
		if(!V.stackable)
			return FALSE
	if(istype(V, /datum/virtue/origin))
		return FALSE
	if(V.unlisted)
		return FALSE
	if(istype(V, /datum/virtue/heretic) && !istype(prefs.selected_patron, /datum/patron/inhumen))
		return FALSE
	if(V.restricted == TRUE)
		if((prefs.pref_species.type in V.races))
			return FALSE
	if(primary && V.virtuous_only && !prefs.statpack.virtuous)
		return FALSE
	return TRUE

/datum/character_setup_panel/proc/show_age_description(mob/user)
	var/age_info = ""
	switch(prefs.age)
		if(AGE_ADULT)
			age_info = "You preside in your 'prime', whatever this may be, and gain no bonus nor endure any penalty for your time spent alive.<br><br>"
			age_info += span_honeyyellow("No modifiers")
		if(AGE_MIDDLEAGED)
			age_info = "Muscles ache and joints begin to slow as Aeon's grasp begins to settle upon your shoulders.<br><br>"
			age_info += span_honeyyellow("-1 SPD, +1 WIL, +1 FOR")
		if(AGE_OLD)
			age_info = "In a place as lethal as PSYDONIA, the elderly are all but marvels... or beneficiaries of the habitually privileged.<br><br>"
			age_info += span_honeyyellow("-1 STR, -2 SPE, -1 PER, -2 CON, +2 INT, +1 FOR")
	if(length(age_info))
		var/age_fieldsetblock = fieldset_block(span_big("<b>[span_bignotice(prefs.age)]</b>"), age_info, "agedesc_block")
		to_chat(user, age_fieldsetblock)

/datum/character_setup_panel/proc/handle_set_context_preference(mob/user, kind, value)
	if(!kind)
		return
	switch(kind)
		if("age")
			if(value in prefs.pref_species.possible_ages)
				prefs.age = value
				var/list/hairs
				if((prefs.age == AGE_OLD) && (OLDGREY in prefs.pref_species.species_traits))
					hairs = prefs.pref_species.get_oldhc_list()
				else
					hairs = prefs.pref_species.get_hairc_list()
				prefs.hair_color = hairs[pick(hairs)]
				prefs.facial_hair_color = prefs.hair_color
				show_age_description(user)
				prefs.ResetJobs()
				prepare_update_after_action(user, "age")
		if("voicepack")
			if(value in GLOB.voice_packs_list)
				prefs.voice_pack = value
				prepare_update_after_action(user, "voicepack")
		if("char_accent")
			if(value in GLOB.character_accents)
				prefs.char_accent = value
				prepare_update_after_action(user, "char_accent")
		if("extra_language")
			if(value == "None")
				prefs.extra_language = "None"
				prepare_update_after_action(user, "extra_language")
			else
				var/language_type = text2path(value)
				if(language_type && ispath(language_type, /datum/language))
					prefs.extra_language = language_type
					prepare_update_after_action(user, "extra_language")
		if("taur_type")
			if(value == "None")
				prefs.taur_type = null
				prepare_update_after_action(user, "taur_type")
			else
				var/taur_type = text2path(value)
				if(taur_type && (taur_type in prefs.pref_species.get_taur_list()))
					prefs.taur_type = taur_type
					prepare_update_after_action(user, "taur_type")
		if("skin_tone")
			var/list/skin_list = prefs.pref_species?.get_skin_list()
			if(islist(skin_list) && !isnull(skin_list[value]))
				prefs.skin_tone = skin_list[value]
				prefs.features["mcolor"] = sanitize_hexcolor(prefs.skin_tone)
				if(hascall(prefs, "try_update_mutant_colors"))
					call(prefs, "try_update_mutant_colors")()
				prepare_update_after_action(user, "body")
		if("statpack")
			var/statpack_type = text2path(value)
			if(statpack_type && GLOB.statpacks[statpack_type])
				prefs.statpack = GLOB.statpacks[statpack_type]
				prepare_update_after_action(user, "statpack")
		if("faith")
			var/faith_type = text2path(value)
			if(faith_type && (faith_type in GLOB.preference_faiths))
				var/datum/faith/faith = GLOB.faithlist[faith_type]
				if(faith)
					var/pantheon_info = "[faith.desc]<br><br>"
					pantheon_info += span_redtext("Последователи: " + faith.worshippers)
					var/pantheon_name = faith.translated_name ? faith.translated_name : faith.name
					var/pantheon_fieldsetblock = fieldset_block(span_big("<b>[span_bignotice(pantheon_name)]</b>"), pantheon_info, "faithdesc_block")
					to_chat(user, pantheon_fieldsetblock)
					prefs.selected_patron = GLOB.patronlist[faith.godhead] || GLOB.patronlist[pick(GLOB.patrons_by_faith[faith.name])]
					prepare_update_after_action(user, "faith")
		if("patron")
			var/patron_type = text2path(value)
			if(patron_type && GLOB.patronlist[patron_type])
				prefs.selected_patron = GLOB.patronlist[patron_type]
				var/patron_info = ""
				patron_info += span_honeyyellow("Домены: [prefs.selected_patron.domain]<br><br>")
				patron_info += "[prefs.selected_patron.desc]<br><br>"
				patron_info += span_redtext("Последователи: [prefs.selected_patron.worshippers]")
				var/patron_name = prefs.selected_patron.translated_name ? prefs.selected_patron.translated_name : prefs.selected_patron.name
				var/patron_fieldsetblock = fieldset_block(span_big("<b>[span_bignotice(patron_name)]</b>"), patron_info, "patrondesc_block")
				to_chat(user, patron_fieldsetblock)
				prepare_update_after_action(user, "patron")
		if("virtue_primary")
			var/virtue_type = text2path(value)
			if(virtue_type && can_select_virtue(virtue_type, TRUE))
				prefs.virtue = new virtue_type
				prepare_update_after_action(user, "virtue")
		if("virtue_secondary")
			var/virtue_type = text2path(value)
			if(virtue_type && can_select_virtue(virtue_type, FALSE))
				prefs.virtuetwo = new virtue_type
				prepare_update_after_action(user, "virtuetwo")

/datum/character_setup_panel/proc/handle_set_descriptor_choice(mob/user, choice_type, descriptor_type)
	if(!(choice_type in prefs.pref_species.descriptor_choices))
		return
	var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
	if(!choice || !(descriptor_type in choice.descriptors))
		return
	var/datum/descriptor_entry/entry = null
	if(hascall(prefs, "get_descriptor_entry_for_choice"))
		entry = call(prefs, "get_descriptor_entry_for_choice")(choice_type)
	if(!entry)
		return
	entry.descriptor_type = descriptor_type
	prepare_update_after_action(user, "descriptors")

/datum/character_setup_panel/proc/handle_set_custom_descriptor_prefix(mob/user, index, prefix_type)
	if(index < 1 || index > CUSTOM_DESCRIPTOR_AMOUNT)
		return
	if(length(prefs.custom_descriptors) < index)
		return
	var/datum/custom_descriptor_entry/custom_entry = prefs.custom_descriptors[index]
	custom_entry.prefix_type = sanitize_integer(prefix_type, 1, CUSTOM_PREFIX_AMOUNT, CUSTOM_PREFIX_HAS_A)
	prepare_update_after_action(user, "descriptors")

/datum/character_setup_panel/proc/handle_set_custom_descriptor_content(mob/user, index, value)
	if(index < 1 || index > CUSTOM_DESCRIPTOR_AMOUNT)
		return
	if(length(prefs.custom_descriptors) < index)
		return
	var/datum/custom_descriptor_entry/custom_entry = prefs.custom_descriptors[index]
	custom_entry.content_text = STRIP_HTML_SIMPLE(lowertext("[value]"), CUSTOM_DESCRIPTOR_TEXT_LENGTH)
	prepare_update_after_action(user, "descriptors")

/datum/character_setup_panel/proc/handle_set_culinary_axis(mob/user, axis, value)
	if(!hascall(prefs, "set_culinary_axis"))
		return
	call(prefs, "set_culinary_axis")(axis, text2num(value))
	prepare_update_after_action(user, "culinary")

/datum/character_setup_panel/proc/is_valid_familiar_origin(planar_origin)
	var/static/list/familiar_origins = list("fae", "infernal", "elemental", "void")
	return planar_origin in familiar_origins

/datum/character_setup_panel/proc/handle_set_familiar_name(mob/user, planar_origin, value)
	var/datum/familiar_prefs/fam = prefs.familiar_prefs
	if(!fam || !is_valid_familiar_origin(planar_origin))
		return
	var/name_value = trim("[value]")
	if(!length(name_value))
		fam.familiar_names[planar_origin] = null
		prepare_update_after_action(user, "familiar")
		return
	var/new_name = reject_bad_name(name_value)
	if(!new_name)
		to_chat(user, span_warning("Некорректное имя фамильяра."))
		return
	fam.familiar_names[planar_origin] = new_name
	prepare_update_after_action(user, "familiar")

/datum/character_setup_panel/proc/handle_set_familiar_pronouns(mob/user, planar_origin, value)
	var/datum/familiar_prefs/fam = prefs.familiar_prefs
	if(!fam || !is_valid_familiar_origin(planar_origin))
		return
	if(!(value in list(HE_HIM, SHE_HER, THEY_THEM, IT_ITS)))
		return
	fam.familiar_pronouns[planar_origin] = value
	prepare_update_after_action(user, "familiar")

/datum/character_setup_panel/proc/handle_set_familiar_specie(mob/user, planar_origin, species_type)
	var/datum/familiar_prefs/fam = prefs.familiar_prefs
	if(!fam || !is_valid_familiar_origin(planar_origin) || !species_type)
		return
	var/list/planar_list = GLOB.planar_lists[planar_origin]
	if(!planar_list)
		return
	for(var/species_name in planar_list)
		if(planar_list[species_name] == species_type)
			fam.familiar_species[planar_origin] = species_type
			prepare_update_after_action(user, "familiar")
			return

/datum/character_setup_panel/proc/handle_set_familiar_headshot(mob/user, planar_origin, value)
	var/datum/familiar_prefs/fam = prefs.familiar_prefs
	if(!fam || !is_valid_familiar_origin(planar_origin))
		return
	var/link = trim("[value]")
	if(!length(link))
		fam.familiar_headshot_link[planar_origin] = null
		prepare_update_after_action(user, "familiar")
		return
	if(!valid_headshot_link(user, link))
		to_chat(user, span_warning("Ссылка на портрет фамильяра не прошла проверку."))
		return
	fam.familiar_headshot_link[planar_origin] = link
	prepare_update_after_action(user, "familiar")

/datum/character_setup_panel/proc/handle_set_familiar_flavortext(mob/user, planar_origin, value)
	var/datum/familiar_prefs/fam = prefs.familiar_prefs
	if(!fam || !is_valid_familiar_origin(planar_origin))
		return
	var/text_value = "[value]"
	if(!length(text_value))
		fam.familiar_flavortext[planar_origin] = null
		fam.familiar_flavortext_display[planar_origin] = null
	else
		fam.familiar_flavortext[planar_origin] = text_value
		var/ft = html_encode(parsemarkdown_basic(text_value))
		ft = replacetext(ft, "\n", "<BR>")
		fam.familiar_flavortext_display[planar_origin] = ft
	prepare_update_after_action(user, "familiar")

/datum/character_setup_panel/proc/handle_set_familiar_ooc_notes(mob/user, planar_origin, value)
	var/datum/familiar_prefs/fam = prefs.familiar_prefs
	if(!fam || !is_valid_familiar_origin(planar_origin))
		return
	var/text_value = "[value]"
	if(!length(text_value))
		fam.familiar_ooc_notes[planar_origin] = null
		fam.familiar_ooc_notes_display[planar_origin] = null
	else
		fam.familiar_ooc_notes[planar_origin] = text_value
		var/ooc = html_encode(parsemarkdown_basic(text_value))
		ooc = replacetext(ooc, "\n", "<BR>")
		fam.familiar_ooc_notes_display[planar_origin] = ooc
	prepare_update_after_action(user, "familiar")

/datum/character_setup_panel/proc/handle_set_familiar_ooc_extra(mob/user, planar_origin, value)
	var/datum/familiar_prefs/fam = prefs.familiar_prefs
	if(!fam || !is_valid_familiar_origin(planar_origin))
		return
	var/link = trim("[value]")
	if(!length(link))
		fam.familiar_ooc_extra[planar_origin] = null
		fam.familiar_ooc_extra_link[planar_origin] = null
		prepare_update_after_action(user, "familiar")
		return
	var/static/list/valid_ext = list("jpg", "jpeg", "png", "gif", "mp4", "mp3")
	if(!valid_headshot_link(user, link, FALSE, valid_ext))
		to_chat(user, span_warning("Ссылка для OOC Extra фамильяра не прошла проверку."))
		return
	fam.familiar_ooc_extra_link[planar_origin] = link
	var/list/link_parts = splittext(link, ".")
	var/ext = lowertext(link_parts[length(link_parts)])
	switch(ext)
		if("jpg", "jpeg", "png", "gif")
			fam.familiar_ooc_extra[planar_origin] = "<div align='center'><br><img src='[link]'/></div>"
		if("mp4")
			fam.familiar_ooc_extra[planar_origin] = "<div align='center'><br><video width='288' height='288' controls><source src='[link]' type='video/mp4'></video></div>"
		if("mp3")
			fam.familiar_ooc_extra[planar_origin] = "<div align='center'><br><audio controls><source src='[link]' type='audio/mp3'>Your browser does not support the audio element.</audio></div>"
	prepare_update_after_action(user, "familiar")

/datum/character_setup_panel/proc/handle_familiar_pulse(mob/user)
	var/datum/familiar_prefs/fam = prefs.familiar_prefs
	if(!fam || !user?.ckey)
		return
	if(user.ckey in GLOB.familiar_advertised)
		to_chat(user, span_info("Вы уже недавно отправляли импульс. Подождите перед повторной отправкой."))
		return
	for(var/mob/living/carbon/human/advertisee in GLOB.alive_mob_list)
		if(!advertisee.client)
			continue
		if(HAS_TRAIT(advertisee, TRAIT_ARCYNE))
			to_chat(advertisee, span_info("The leylines pulse beneath your feet... a new familiar strains against the veil, seeking to be summoned!"))
	to_chat(user, span_notice("Все живые носители арканы уведомлены. Новый импульс можно отправить через 10 минут."))
	GLOB.familiar_advertised += user.ckey
	addtimer(CALLBACK(fam, TYPE_PROC_REF(/datum/familiar_prefs, remove_ckey), user.ckey), 10 MINUTES)
/datum/character_setup_panel/proc/handle_manage_charflaws(mob/user)
	for(var/datum/charflaw/_existing in prefs.charflaws)
		if(istype(_existing, /datum/charflaw/noflaw))
			prefs.charflaws.Remove(_existing)
			break
	if(prefs.charflaws.len >= MAX_VICES)
		to_chat(user, span_warning("Нельзя выбрать больше пороков."))
		return
	var/list/cf_list = GLOB.character_flaws.Copy()
	for(var/key in cf_list)
		if(cf_list[key] == /datum/charflaw/noflaw)
			cf_list.Remove(key)
			break
	for(var/datum/charflaw/cf in prefs.charflaws)
		for(var/key in cf_list)
			if(cf_list[key] == cf.type && !istype(cf, /datum/charflaw/randflaw))
				cf_list.Remove(key)
				break
	var/result = tgui_input_list(user, "Выберите порок.", "Пороки", cf_list)
	if(result)
		result = cf_list[result]
		handle_add_charflaw(user, result)

/datum/character_setup_panel/proc/handle_manage_gallery(mob/user, nsfw = FALSE)
	var/list/current_gallery = nsfw ? prefs.nsfw_img_gallery : prefs.img_gallery
	if(!islist(current_gallery))
		current_gallery = list()
	var/gallery_name = nsfw ? "NSFW Image Gallery" : "Image Gallery"
	var/list/choices = list()
	if(length(current_gallery) < 3)
		choices += "Добавить"
	if(length(current_gallery))
		choices += "Очистить"
	choices += "Отмена"
	var/choice = tgui_alert(user, "Управление [gallery_name]. Сейчас изображений: [length(current_gallery)]/3.", gallery_name, choices)
	if(choice == "Добавить")
		prefs.process_link(user, list(
			"preference" = nsfw ? "nsfw_img_gallery" : "img_gallery",
			"task" = "input"
		))
		prepare_update_after_action(user, nsfw ? "nsfw_img_gallery" : "img_gallery")
		return
	if(choice == "Очистить")
		prefs.process_link(user, list(
			"preference" = nsfw ? "clear_nsfw_gallery" : "clear_gallery",
			"task" = "input"
		))
		prepare_update_after_action(user, nsfw ? "nsfw_img_gallery" : "img_gallery")

/datum/character_setup_panel/proc/handle_remove_gallery_image(mob/user, nsfw = FALSE, index = 0)
	var/list/current_gallery = nsfw ? prefs.nsfw_img_gallery : prefs.img_gallery
	if(!islist(current_gallery) || index < 1 || index > length(current_gallery))
		return
	var/gallery_name = nsfw ? "NSFW Image Gallery" : "Image Gallery"
	var/image_link = current_gallery[index]
	var/confirm = tgui_alert(user, "Удалить это изображение из [gallery_name]?\n[image_link]", gallery_name, list("Да", "Нет"))
	if(confirm != "Да")
		return
	current_gallery.Cut(index, index + 1)
	if(nsfw)
		prefs.nsfw_img_gallery = current_gallery
	else
		prefs.img_gallery = current_gallery
	prepare_update_after_action(user, nsfw ? "nsfw_img_gallery" : "img_gallery")

/datum/character_setup_panel/proc/prepare_update_after_action(mob/user, preference, queue_update = FALSE)
	prepare_preferences_state(preference)
	if(preference == "gender")
		prefs.genderize_customizer_entries()

	var/static/list/visual_updates = list(
		"gender",
		"species",
		"subspecies",
		"customizer",
		"markings",
		"race_bonus_select",
		"body",
		"changeslot",
		"taur_type",
		"taur_color",
		"clothespref",
		"eyes",
		"s_tone",
		"body_size",
		"undo"
	)
	var/static/list/catalog_updates = list(
		"gender",
		"species",
		"subspecies",
		"customizer",
		"markings",
		"body",
		"changeslot",
		"taur_type",
		"taur_color",
		"clothespref",
		"undo"
	)
	var/static/list/job_updates = list(
		"gender",
		"species",
		"subspecies",
		"age",
		"statpack",
		"pronouns",
		"titles",
		"changeslot",
		"undo"
	)
	var/static/list/slot_summary_updates = list(
		"name",
		"changeslot",
		"undo"
	)

	var/refresh_preview = (preference in visual_updates)
	var/refresh_customizer_catalog = (preference in catalog_updates)
	var/refresh_slot_summaries = (preference in slot_summary_updates)
	var/refresh_jobs = (preference in job_updates)

	if(queue_update)
		queue_ui_update(refresh_preview, refresh_customizer_catalog, FALSE, refresh_slot_summaries, refresh_jobs)
		return

	if(refresh_customizer_catalog)
		invalidate_customizer_catalog_payload()
		ensure_active_customizer()
		invalidate_active_customizer_payload()

	if(refresh_slot_summaries)
		cached_slot_summaries = null

	if(refresh_preview)
		queue_preview_refresh(2, TRUE)

	if(refresh_jobs)
		invalidate_jobs_payload_cache()
		if(jobs_panel)
			SStgui.update_uis(jobs_panel)

/datum/character_setup_panel/proc/customizer_group(datum/customizer/customizer)
	if(!customizer)
		return "body"
	var/customizer_name = lowertext(customizer.name)
	if(findtext(customizer_name, "penis") || findtext(customizer_name, "член") || findtext(customizer_name, "testicle") || findtext(customizer_name, "яич") || findtext(customizer_name, "vagina") || findtext(customizer_name, "влаг") || findtext(customizer_name, "breast") || findtext(customizer_name, "груд") || findtext(customizer_name, "piercing") || findtext(customizer_name, "пирс"))
		return "simple"
	return "body"

/datum/character_setup_panel/proc/translate_customizer_name(name)
	switch(name)
		if("Hair")
			return "Волосы"
		if("Facial Hair")
			return "Волосы на лице"
		if("Ears")
			return "Уши"
		if("Eyes")
			return "Глаза"
		if("Accessory")
			return "Аксессуар"
		if("Face Detail")
			return "Детали лица"
		if("Underwear")
			return "Нижнее бельё"
		if("Legwear")
			return "Носки и чулки"
		if("Piercing")
			return "Пирсинг"
		if("Horns")
			return "Рога"
		if("Tail")
			return "Хвост"
		if("Testicles")
			return "Яички"
		if("Penis")
			return "Пенис"
		if("Vagina")
			return "Влагалище"
		if("Breasts")
			return "Грудь"
		if("Wings")
			return "Крылья"
		if("Headwing")
			return "Крылья (голова)"
		if("Fluff")
			return "Мех"
		if("Snout")
			return "Морда"
		if("Hood")
			return "Капюшон"
		if("Frills")
			return "Шейный воротник"
		if("Soul")
			return "Душа"
		if("Tusks")
			return "Клыки"
		if("Fluvian Fluff")
			return "Флювианский мех"
		if("Antennas")
			return "Усики"
		if("Fluvian Wings")
			return "Флювианские крылья"
	return name

/datum/character_setup_panel/proc/build_body_marking_catalog()
	var/static/list/shared_body_marking_catalog_by_key = list()
	var/species_cache_key = (prefs && prefs.pref_species) ? "[prefs.pref_species.type]" : "none"
	var/cache_key = species_cache_key
	if(cached_body_marking_catalog && cached_body_marking_catalog_key == cache_key)
		return cached_body_marking_catalog
	if(shared_body_marking_catalog_by_key[cache_key])
		cached_body_marking_catalog_key = cache_key
		cached_body_marking_catalog = shared_body_marking_catalog_by_key[cache_key]
		return cached_body_marking_catalog

	var/list/output = list()
	var/list/zones = list(
		BODY_ZONE_HEAD = "Голова",
		BODY_ZONE_CHEST = "Грудь",
		BODY_ZONE_L_ARM = "Левая рука",
		BODY_ZONE_R_ARM = "Правая рука",
		BODY_ZONE_PRECISE_L_HAND = "Левая кисть",
		BODY_ZONE_PRECISE_R_HAND = "Правая кисть",
		BODY_ZONE_L_LEG = "Левая нога",
		BODY_ZONE_R_LEG = "Правая нога"
	)

	for(var/zone in zones)
		var/list/options = list()
		var/list/possible_markings = (prefs && prefs.pref_species) ? marking_list_of_zone_for_species(zone, prefs.pref_species) : null
		for(var/marking_name in possible_markings)
			var/datum/body_marking/marking = GLOB.body_markings[marking_name]
			if(!marking)
				continue
			var/icon_id = sanitize_css_class_name("[marking.type]")
			options += list(list(
				name = marking.name,
				icon = marking.icon,
				icon_state = marking.icon_state,
				icon_class_name = "character_setup_marking_icons64x64 [icon_id]"
			))

		if(options.len)
			output += list(list(
				zone = "[zone]",
				label = zones[zone],
				options = options
			))

	cached_body_marking_catalog_key = cache_key
	cached_body_marking_catalog = output
	shared_body_marking_catalog_by_key[cache_key] = output
	return output

/datum/character_setup_panel/proc/zone_label(zone)
	switch(zone)
		if(BODY_ZONE_R_ARM)
			return "Правая рука"
		if(BODY_ZONE_L_ARM)
			return "Левая рука"
		if(BODY_ZONE_HEAD)
			return "Голова"
		if(BODY_ZONE_CHEST)
			return "Грудь"
		if(BODY_ZONE_R_LEG)
			return "Правая нога"
		if(BODY_ZONE_L_LEG)
			return "Левая нога"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "Правая кисть"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "Левая кисть"
	return "Неизвестно"

/datum/character_setup_panel/proc/gender_label(gender)
	switch(gender)
		if(MALE)
			return "Мужчина"
		if(FEMALE)
			return "Женщина"
	return "Неопределённый"

/datum/character_setup_panel/proc/pronoun_gender_label(pronouns, gender)
	if(pronouns == SHE_HER)
		return "Женщина"
	if(pronouns == HE_HIM)
		return "Мужчина"

	var/pronouns_text = lowertext("[pronouns]")
	if(findtext(pronouns_text, "they") || findtext(pronouns_text, "them") || findtext(pronouns_text, "it/its") || findtext(pronouns_text, "it") || findtext(pronouns_text, "они"))
		return "Неопределённый"
	if(findtext(pronouns_text, "she") || findtext(pronouns_text, "her") || findtext(pronouns_text, "она"))
		return "Женщина"
	if(findtext(pronouns_text, "he") || findtext(pronouns_text, "him") || findtext(pronouns_text, "он"))
		return "Мужчина"

	return gender_label(gender)

/datum/character_setup_panel/proc/taur_label(taur_type)
	var/obj/item/bodypart/taur/T = taur_type
	return ispath(T) ? T::name : "Нет"

/datum/character_setup_panel/proc/hair_gradient_label(gradient_type)
	if(!gradient_type)
		return "Нет"
	var/datum/hair_gradient/gradient = HAIR_GRADIENT(gradient_type)
	return gradient ? gradient.name : "Нет"

/mob/dead/new_player/proc/retry_player_panel()
	if(!client?.prefs)
		return
	var/datum/character_setup_panel/panel = client.prefs.character_setup_panel
	if(panel && SStgui.get_open_ui(src, panel))
		return
	new_player_panel()
