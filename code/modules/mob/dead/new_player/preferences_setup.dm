
// TA EDIT START
/datum/preferences/proc/reset_current_character()
	if(!path)
		return

	var/savefile/S = new /savefile(path)
	if(S)
		S.cd = "/"
		S.dir -= "character[loaded_slot]"

	set_new_race(new /datum/species/human/northern())
	virtue_origin = new pref_species.origin_default
	virtue = new /datum/virtue/none
	virtuetwo = new /datum/virtue/none
	statpack = new /datum/statpack/wildcard/fated
	race_bonus = null
	origin = "Default"

	charflaws = list()
	var/list/cf_choices = list()
	for(var/i = 1 to MAX_VICES)
		cf_choices.Add(i)
	var/num_vices = pick(cf_choices)
	var/list/available = GLOB.character_flaws.Copy()
	for(var/key in available)
		if(available[key] == /datum/charflaw/noflaw)
			available.Remove(key)
			break
	for(var/j = 1 to num_vices)
		if(!available.len)
			break
		var/sel = pick(available)
		var/flaw_type = available[sel]
		available.Remove(sel)
		var/datum/charflaw/cf = new flaw_type()
		charflaws.Add(cf)
	if(!charflaws.len)
		var/datum/charflaw/no_flaw = new /datum/charflaw/noflaw()
		charflaws.Add(no_flaw)

	selected_patron = GLOB.patronlist[default_patron]
	combat_music = GLOB.cmode_tracks_by_type[default_cmusic_type]
	custom_cmode_enabled = FALSE
	custom_cmode_name = null
	custom_cmode_file = null

	job_preferences = list()
	job_subprefs = list()
	job_characters = list()
	job_subclass_preferences = list()
	job_subclass_strict = list()
	all_quirks = list()
	topjob = null

	have_manor = TRUE
	manor_name = ""
	manor_type = "manor"

	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	flavortext = null
	flavortext_cached = null
	nsfwflavortext = null
	nsfwflavortext_cached = null
	ooc_notes = null
	ooc_notes_cached = null
	ooc_extra = null
	ooc_extra_img = null
	ooc_extra_img_link = null
	nsfw_ooc_extra_img = null
	nsfw_ooc_extra_img_link = null
	erpprefs = null
	erpprefs_cached = null
	rumour = null
	noble_gossip = null
	averse_chosen_faction = "Inquisition"
	song_artist = null
	song_title = null
	img_gallery = list()
	nsfw_img_gallery = list()

	headshot_link = null
	lich_headshot_link = null
	vampire_headshot_link = null
	werewolf_headshot_link = null

	familiar_prefs = new /datum/familiar_prefs(src)
	selected_loadout_items = list()
	customizer_entries = list()
	body_markings = list()
	descriptor_entries = list()
	custom_descriptors = list()

	pronouns = HE_HIM
	titles_pref = TITLES_M
	clothes_pref = CLOTHES_M
	voice_pack = "Default"
	voice_type = VOICE_TYPE_MASC
	voice_color = "a0a0a0"
	voice_pitch = 1
	char_accent = "No accent"
	nickname = "Please Change Me"
	highlight_color = "#FF0000"
	dnr_pref = FALSE
	qsr_pref = FALSE

	random_character(null, FALSE, TRUE)
	save_character()

	// TA EDIT END
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/random_character(gender_override, antag_override = FALSE, ft_reset = TRUE)
	if(!pref_species)
		random_species()
	real_name = pref_species.random_name(gender,1)
	if(gender_override)
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	age = AGE_ADULT
	var/list/skins = pref_species.get_skin_list()
	skin_tone = skins[pick(skins)]
	eye_color = random_eye_color()
	if(ft_reset)
		flavortext = null
		nsfwflavortext = null
		ooc_extra_img = null
		ooc_extra_img_link = null
		nsfw_ooc_extra_img = null
		nsfw_ooc_extra_img_link = null
		erpprefs = null
		ooc_notes = null
		ooc_extra = null
		song_title = null
		song_artist = null
		headshot_link = null
		img_gallery = null
		nsfw_img_gallery = null
	features = pref_species.get_random_features()
	body_markings = pref_species.get_random_body_markings(features)
	accessory = "Nothing"
	reset_all_customizer_accessory_colors()
	randomize_all_customizer_accessories()

/datum/preferences/proc/random_species()
	var/random_species_type = GLOB.species_list[pick(get_selectable_species())]
	pref_species = new random_species_type
	if(randomise[RANDOM_NAME])
		real_name = pref_species.random_name(gender,1)
	set_new_race(new random_species_type)

/datum/preferences/proc/update_preview_icon()
	set waitfor = 0
	if(!parent)
		return
	if(parent.is_new_player())
		return
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	copy_to(mannequin, 1, TRUE, TRUE)

	mannequin.rebuild_obscured_flags()
	parent.show_character_previews(new /mutable_appearance(mannequin))
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)

/datum/preferences/proc/spec_check(mob/user)
	if(!istype(pref_species))
		return FALSE
	if(!(pref_species.name in get_selectable_species()))
		return FALSE
	if(!pref_species.check_roundstart_eligible())
		return FALSE
	if(user && (pref_species.patreon_req > user.patreonlevel()))
		return FALSE
	return TRUE

/mob/proc/patreonlevel()
	if(client)
		return client.patreonlevel()
