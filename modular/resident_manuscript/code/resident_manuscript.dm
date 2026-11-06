/datum/resident_manuscript_map_profile
	var/list/map_names
	var/enabled = TRUE
	var/realm_key = "azuria"
	var/issued_place = "Герцогство Азурия"
	var/uses_azuria_titles = FALSE
	var/uses_rockhill_titles = FALSE
	var/uses_resident_tavern_spawn = FALSE
	var/uses_dun_world_tavern_filter = FALSE

/datum/resident_manuscript_map_profile/azuria
	map_names = list("Dun World", "Dun_world")
	uses_azuria_titles = TRUE
	uses_resident_tavern_spawn = TRUE
	uses_dun_world_tavern_filter = TRUE

/datum/resident_manuscript_map_profile/rockhill
	map_names = list("Rockhill")
	realm_key = "rockhill"
	issued_place = "Королевство Энигмы, Рокхилл"
	uses_azuria_titles = FALSE
	uses_rockhill_titles = TRUE
	uses_resident_tavern_spawn = TRUE

/datum/resident_manuscript_map_profile/desert_town
	map_names = list("Desert Town")
	enabled = FALSE
	realm_key = "desert_town"
	issued_place = "Пустынный город"
	uses_azuria_titles = FALSE

/proc/get_resident_manuscript_map_profile(map_name)
	var/static/list/profiles_by_map
	var/static/datum/resident_manuscript_map_profile/default_profile
	if(isnull(map_name))
		map_name = SSmapping.config?.map_name
	if(!profiles_by_map)
		profiles_by_map = list()
		for(var/profile_type in subtypesof(/datum/resident_manuscript_map_profile))
			var/datum/resident_manuscript_map_profile/profile = new profile_type
			for(var/profile_map_name in profile.map_names)
				profiles_by_map[profile_map_name] = profile
		default_profile = new /datum/resident_manuscript_map_profile
	return profiles_by_map[map_name] || default_profile

/proc/resident_manuscript_uses_rockhill_titles()
	var/datum/resident_manuscript_map_profile/map_profile = get_resident_manuscript_map_profile()
	return map_profile.uses_rockhill_titles

/proc/resident_manuscript_uses_azuria_titles()
	var/datum/resident_manuscript_map_profile/map_profile = get_resident_manuscript_map_profile()
	return map_profile.uses_azuria_titles

/proc/resident_manuscript_uses_resident_tavern_spawn()
	var/datum/resident_manuscript_map_profile/map_profile = get_resident_manuscript_map_profile()
	return map_profile.uses_resident_tavern_spawn

/proc/resident_manuscript_uses_dun_world_tavern_filter()
	var/datum/resident_manuscript_map_profile/map_profile = get_resident_manuscript_map_profile()
	return map_profile.uses_dun_world_tavern_filter

/proc/resident_manuscripts_enabled()
	var/datum/resident_manuscript_map_profile/map_profile = get_resident_manuscript_map_profile()
	if(!map_profile.enabled)
		// TO DO - нужно дописать для карты отдельные параметры, так как контент карты и культура сильно отличаются от Dun World
		return FALSE
	return TRUE

/proc/resident_manuscript_is_barred_from_residence(mob/living/carbon/human/user)
	if(!ishuman(user))
		return TRUE
	if(HAS_TRAIT(user, TRAIT_OUTLAW) || HAS_TRAIT(user, TRAIT_HERESIARCH) || HAS_TRAIT(user, TRAIT_EXCOMMUNICATED))
		return TRUE
	if((user.name in GLOB.outlawed_players) || (user.real_name in GLOB.outlawed_players))
		return TRUE
	if((user.name in GLOB.excommunicated_players) || (user.real_name in GLOB.excommunicated_players))
		return TRUE
	return FALSE

/proc/give_roundstart_manuscript(mob/living/carbon/human/recipient, manuscript_type)
	if(!resident_manuscripts_enabled())
		return FALSE
	if(!ishuman(recipient) || !recipient.mind)
		return FALSE
	if(resident_manuscript_is_barred_from_residence(recipient))
		return FALSE
	if(!ispath(manuscript_type, /obj/item/book/granter/resident_manuscript))
		return FALSE
	if(!recipient.mind.special_items)
		recipient.mind.special_items = list()
	for(var/existing_key in recipient.mind.special_items)
		var/existing_path = recipient.mind.special_items[existing_key]
		if(ispath(existing_path, /obj/item/book/granter/resident_manuscript))
			return FALSE
	recipient.mind.special_items[RESIDENT_MANUSCRIPT_SPECIAL_ITEM_NAME] = manuscript_type
	return TRUE

/proc/grant_roundstart_resident_manuscript(mob/living/carbon/human/recipient, manuscript_type = /obj/item/book/granter/resident_manuscript/roundstart)
	if(!ishuman(recipient) || !recipient.mind)
		return FALSE
	if(!HAS_TRAIT(recipient, TRAIT_RESIDENT))
		return FALSE
	return give_roundstart_manuscript(recipient, manuscript_type)

/proc/grant_roundstart_faction_manuscript(mob/living/carbon/human/recipient)
	var/manuscript_type = get_default_manuscript_type_for_job(recipient)
	if(!manuscript_type)
		return FALSE
	return give_roundstart_manuscript(recipient, manuscript_type)

/proc/get_resident_manuscript_issued_place()
	var/datum/resident_manuscript_map_profile/map_profile = get_resident_manuscript_map_profile()
	return map_profile.issued_place

/proc/get_resident_manuscript_realm_key()
	var/datum/resident_manuscript_map_profile/map_profile = get_resident_manuscript_map_profile()
	return map_profile.realm_key

/proc/resident_manuscript_defect_keys()
	return list(
		"ink_blot",
		"seal_smudge",
		"owner_wobble",
		"ragged_edge",
		"uncertain_hand",
		"stale_smell",
		"misaligned_initial",
		"fresh_pricking",
		"cut_gilding",
		"rethreaded_cord",
		"reheated_wax",
		"blue_halo",
		"corrected_date",
		"heretical_marginalia",
	)

/proc/resident_manuscript_validation_note_keys()
	return list(
		"steady_seals",
		"proper_ruling",
		"matched_hand",
		"deep_wax",
		"proper_rite",
	)

/obj/item/book/granter/resident_manuscript
	name = "Грамота жителя"
	desc = "Тонкая грамота на плотной бумаге, подтверждающая законное проживание под властью Короны."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "contractsigned"
	oneuse = FALSE
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	pages_to_mastery = 0
	var/document_profile_id = "resident"
	var/tmp/datum/resident_document_profile/document_profile
	var/owner_character_key
	var/owner_name
	var/owner_age
	var/owner_status_key = RESIDENT_MANUSCRIPT_STATUS_COMMONER
	var/expiry_date
	var/issued_place
	var/realm_key
	var/is_bound = FALSE
	var/is_fake = FALSE
	var/undetectable_fake = FALSE
	var/authority_validated = FALSE
	var/auto_stamp_seals = TRUE
	var/auto_bind_on_equip = TRUE
	var/requires_feather_to_bind = FALSE
	var/expiry_year_bonus_min = 10
	var/expiry_year_bonus_max = 15
	var/list/seals
	var/list/defect_note_keys
	var/list/detection_attempts
	var/list/detection_results
	var/list/detection_note_keys

/obj/item/book/granter/resident_manuscript/Initialize()
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return .
	if(!resident_manuscripts_enabled())
		return INITIALIZE_HINT_QDEL
	document_profile = get_resident_document_profile(document_profile_id)
	if(document_profile?.display_name)
		name = document_profile.display_name
	issued_place = get_resident_manuscript_issued_place()
	realm_key = get_resident_manuscript_realm_key()
	expiry_date = compute_expiry_date()
	initialize_seals()
	defect_note_keys = list()
	detection_attempts = list()
	detection_results = list()
	detection_note_keys = list()
	if(auto_stamp_seals && is_bound)
		stamp_default_seals()

/obj/item/book/granter/resident_manuscript/proc/get_profile_seal_keys()
	if(document_profile && document_profile.allowed_seals)
		return document_profile.allowed_seals
	return list()

/obj/item/book/granter/resident_manuscript/proc/initialize_seals()
	seals = list()
	for(var/seal_key in get_profile_seal_keys())
		seals[seal_key] = null

/obj/item/book/granter/resident_manuscript/proc/compute_expiry_date()
	var/round_id = text2num(GLOB.round_id) || 0
	var/days_since_epoch = (round_id * CALENDAR_DAYS_IN_WEEK) + (GLOB.dayspassed - 1)
	if(GLOB.date_override_enabled)
		days_since_epoch += GLOB.date_override_offset
	var/day_of_year = MODULUS(days_since_epoch, CALENDAR_DAYS_IN_YEAR) + 1
	var/current_month = FLOOR((day_of_year - 1) / CALENDAR_DAYS_IN_MONTH, 1) + 1
	var/current_day = MODULUS((day_of_year - 1), CALENDAR_DAYS_IN_MONTH) + 1
	var/new_day = current_day
	var/new_month = current_month
	var/new_year = CALENDAR_EPOCH_YEAR
	while(new_day > CALENDAR_DAYS_IN_MONTH)
		new_day -= CALENDAR_DAYS_IN_MONTH
		new_month += 1
	if(new_month > CALENDAR_MONTHS_PER_YEAR)
		new_year += FLOOR((new_month - 1) / CALENDAR_MONTHS_PER_YEAR, 1)
		new_month = ((new_month - 1) % CALENDAR_MONTHS_PER_YEAR) + 1
	if(expiry_year_bonus_max > 0)
		new_year += rand(expiry_year_bonus_min, expiry_year_bonus_max)
	return "[new_day] [get_month_number_to_text(new_month)] [new_year]"

/obj/item/book/granter/resident_manuscript/proc/get_detection_character_key(mob/living/carbon/human/user)
	if(!ishuman(user))
		return null
	if(user.mobid)
		return "[user.mobid]"
	return user.real_name || user.name

/obj/item/book/granter/resident_manuscript/proc/status_key_for(mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_NOBLE))
		return RESIDENT_MANUSCRIPT_STATUS_NOBLE
	var/job_title = target.job || target.mind?.assigned_role
	if(job_title && ((job_title in GLOB.noble_positions) || (job_title in GLOB.retinue_positions) || (job_title in GLOB.courtier_positions)))
		return RESIDENT_MANUSCRIPT_STATUS_NOBLE
	return RESIDENT_MANUSCRIPT_STATUS_COMMONER

/obj/item/book/granter/resident_manuscript/proc/bind_to_holder(mob/living/carbon/human/target)
	if(is_bound || !ishuman(target))
		return FALSE
	owner_character_key = get_detection_character_key(target)
	owner_name = target.real_name
	owner_age = target.age
	owner_status_key = status_key_for(target)
	is_bound = TRUE
	if(document_profile?.display_name)
		name = document_profile.display_name
	else
		name = "Грамота жителя"
	icon_state = "contractsigned"
	if(auto_stamp_seals)
		stamp_default_seals()
	else
		handle_post_bind_low_level_seal()
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/handle_post_bind_low_level_seal()
	if(is_fake)
		return
	if(document_profile_id != "commoner")
		return
	if(seals?["elder"])
		return
	stamp_seal("elder", null, FALSE)

/obj/item/book/granter/resident_manuscript/proc/is_owner_viewer(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	var/detection_key = get_detection_character_key(user)
	if(owner_character_key && detection_key && detection_key == owner_character_key)
		return TRUE
	if(is_fake && owner_name)
		var/real_name = user.real_name || ""
		var/user_name = user.name || ""
		if(owner_name == real_name || owner_name == user_name || owner_name == html_encode(real_name) || owner_name == html_encode(user_name))
			return TRUE
	return FALSE

/obj/item/book/granter/resident_manuscript/proc/sanitize_manuscript_field(value, max_length, fallback)
	var/text_value = ""
	if(!isnull(value))
		text_value = "[value]"
	text_value = trim(html_encode(text_value), PREVENT_CHARACTER_TRIM_LOSS(max_length))
	return length(text_value) ? text_value : fallback

/obj/item/book/granter/resident_manuscript/proc/normalize_status_key(value)
	if(value == RESIDENT_MANUSCRIPT_STATUS_NOBLE)
		return RESIDENT_MANUSCRIPT_STATUS_NOBLE
	return RESIDENT_MANUSCRIPT_STATUS_COMMONER

/obj/item/book/granter/resident_manuscript/proc/normalize_age_key(value)
	if(value == AGE_MIDDLEAGED)
		return AGE_MIDDLEAGED
	if(value == AGE_OLD)
		return AGE_OLD
	return AGE_ADULT

/obj/item/book/granter/resident_manuscript/proc/get_seal_rule(seal_key)
	var/rule_type = get_resident_manuscript_seal_rules()[seal_key]
	if(!rule_type)
		return null
	return new rule_type

/obj/item/book/granter/resident_manuscript/proc/get_seal_key_for_user(mob/living/carbon/human/user)
	if(!ishuman(user))
		return null
	for(var/seal_key in get_profile_seal_keys())
		var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
		if(!rule)
			continue
		var/can_stamp = rule.can_stamp(user) && rule.can_apply_to_status(owner_status_key)
		qdel(rule)
		if(can_stamp)
			return seal_key
	return null

/obj/item/book/granter/resident_manuscript/proc/get_seal_priority(seal_key)
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return 0
	var/priority = rule.priority
	qdel(rule)
	return priority

/obj/item/book/granter/resident_manuscript/proc/can_apply_seal_to_status(seal_key, status_key)
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return FALSE
	var/result = rule.can_apply_to_status(status_key)
	qdel(rule)
	return result

/obj/item/book/granter/resident_manuscript/proc/get_sorted_seal_keys()
	var/list/profile_keys = get_profile_seal_keys()
	if(!LAZYLEN(profile_keys))
		return list()
	var/list/keys_with_priority = list()
	for(var/seal_key in profile_keys)
		keys_with_priority[seal_key] = get_seal_priority(seal_key)
	sortTim(keys_with_priority, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)
	var/list/sorted = list()
	for(var/seal_key in keys_with_priority)
		sorted += seal_key
	return sorted

/obj/item/book/granter/resident_manuscript/proc/get_dominant_seal_key()
	if(!seals)
		return null
	var/best
	var/best_priority = -1
	for(var/seal_key in seals)
		var/list/entry = seals[seal_key]
		if(!entry || entry["suspicious"])
			continue
		var/p = get_seal_priority(seal_key)
		if(p > best_priority)
			best = seal_key
			best_priority = p
	return best

/obj/item/book/granter/resident_manuscript/proc/stamp_seal(seal_key, mob/living/carbon/human/stamper, suspicious = FALSE)
	if(!seals || !(seal_key in seals) || seals[seal_key])
		return FALSE
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return FALSE
	seals[seal_key] = list(
		"stamper" = suspicious ? null : rule.get_stamper(),
		"time" = world.time,
		"suspicious" = suspicious,
	)
	qdel(rule)
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/stamp_default_seals()
	if(!document_profile)
		return
	for(var/seal_key in document_profile.get_default_seal_keys(owner_status_key))
		if(!seals[seal_key])
			stamp_seal(seal_key, null, FALSE)

/obj/item/book/granter/resident_manuscript/proc/generate_fake_seals()
	var/list/available_seals = list()
	for(var/seal_key in get_profile_seal_keys())
		available_seals += seal_key
		if(prob(70))
			stamp_seal(seal_key, null, TRUE)
	if(!has_any_seal() && length(available_seals))
		stamp_seal(pick(available_seals), null, TRUE)

/obj/item/book/granter/resident_manuscript/proc/has_any_seal()
	if(!seals)
		return FALSE
	for(var/seal_key in seals)
		if(seals[seal_key])
			return TRUE
	return FALSE

/obj/item/book/granter/resident_manuscript/proc/seal_entry(seal_key, mob/user, dominant_key)
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return null
	var/list/entry = seals?[seal_key]
	var/is_dominant = dominant_key && dominant_key == seal_key
	var/dominant_priority = dominant_key ? get_seal_priority(dominant_key) : 0
	var/is_replaced = dominant_key && rule.priority < dominant_priority
	var/is_visible = entry && !is_replaced
	var/list/result = list(
		"key" = seal_key,
		"label" = rule.get_title(),
		"stamped" = entry ? TRUE : FALSE,
		"stamper" = entry ? entry["stamper"] : "",
		"visible" = is_visible ? TRUE : FALSE,
		"suspicious" = entry ? entry["suspicious"] : FALSE,
		"priority" = rule.priority,
		"dominant" = is_dominant ? TRUE : FALSE,
	)
	qdel(rule)
	return result

/obj/item/book/granter/resident_manuscript/proc/get_seals_for_ui(mob/user)
	var/dominant_key = get_dominant_seal_key()
	var/list/result = list()
	for(var/seal_key in get_sorted_seal_keys())
		var/list/entry = seal_entry(seal_key, user, dominant_key)
		if(entry)
			result += list(entry)
	return result

/obj/item/book/granter/resident_manuscript/proc/generate_defect_note_keys()
	var/list/available_defects = resident_manuscript_defect_keys()
	var/list/generated_defects = list()
	var/defect_count = rand(RESIDENT_MANUSCRIPT_MIN_DEFECTS, RESIDENT_MANUSCRIPT_MAX_DEFECTS)
	while(length(generated_defects) < defect_count && length(available_defects))
		var/selected_defect = pick(available_defects)
		generated_defects += selected_defect
		available_defects -= selected_defect
	return generated_defects

/obj/item/book/granter/resident_manuscript/proc/ensure_defect_note_keys()
	if(length(defect_note_keys) >= RESIDENT_MANUSCRIPT_MIN_DEFECTS)
		return
	defect_note_keys = generate_defect_note_keys()

/obj/item/book/granter/resident_manuscript/proc/can_edit_fake_manuscript(mob/living/carbon/human/user)
	return ishuman(user) && is_fake && !is_bound

/obj/item/book/granter/resident_manuscript/proc/can_write_master_forgery(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	return HAS_TRAIT(user, TRAIT_GOODWRITER) || user.get_true_stat(STATKEY_INT) >= 17

/obj/item/book/granter/resident_manuscript/proc/can_bind_from_ui(mob/living/carbon/human/user)
	return ishuman(user) && !is_bound && !is_fake && !requires_feather_to_bind

/obj/item/book/granter/resident_manuscript/proc/can_stamp_manuscript(mob/living/carbon/human/user)
	if(!ishuman(user) || !is_bound)
		return FALSE
	var/seal_key = get_seal_key_for_user(user)
	if(seal_key && !seals?[seal_key])
		return TRUE
	return FALSE

/obj/item/book/granter/resident_manuscript/proc/is_barred_from_residence(mob/living/carbon/human/user)
	return resident_manuscript_is_barred_from_residence(user)

/obj/item/book/granter/resident_manuscript/proc/can_claim_residence(mob/living/carbon/human/user)
	if(!ishuman(user) || !owner_character_key || is_fake)
		return FALSE
	if(!document_profile?.grants_residence_claim)
		return FALSE
	if(get_detection_character_key(user) != owner_character_key)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_RESIDENT) || is_barred_from_residence(user))
		return FALSE
	var/needs_seal = TRUE
	if(!document_profile.requires_seal_for_claim)
		needs_seal = FALSE
	if(needs_seal && !has_any_seal())
		return FALSE
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/is_ruling_authority(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	var/datum/job/job = SSjob.GetJob(user.mind?.assigned_role)
	return istype(job, /datum/job/roguetown/lord) || istype(job, /datum/job/roguetown/hand)

/obj/item/book/granter/resident_manuscript/proc/can_inspect_manuscript(mob/living/carbon/human/user)
	if(!ishuman(user) || !is_bound || is_owner_viewer(user))
		return FALSE
	var/detection_key = get_detection_character_key(user)
	if(!detection_key || LAZYACCESS(detection_attempts, detection_key))
		return FALSE
	if(authority_validated)
		return FALSE
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/save_fake_manuscript(mob/living/carbon/human/user, list/params)
	if(!can_edit_fake_manuscript(user))
		return FALSE
	if(!params)
		params = list()
	owner_character_key = null
	owner_name = sanitize_manuscript_field(params["owner_name"], MAX_NAME_LEN, "Неизвестный")
	owner_age = normalize_age_key(params["owner_age"])
	owner_status_key = normalize_status_key(params["owner_status_key"])
	is_bound = TRUE
	if(document_profile?.display_name)
		name = document_profile.display_name
	else
		name = "Грамота жителя"
	icon_state = "contractsigned"
	undetectable_fake = can_write_master_forgery(user)
	authority_validated = FALSE
	detection_attempts = list()
	detection_results = list()
	detection_note_keys = list()
	playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
	to_chat(user, span_notice("Вы завершаете подозрительную грамоту."))
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/claim_residence(mob/living/carbon/human/user)
	if(!can_claim_residence(user))
		return FALSE
	ADD_TRAIT(user, TRAIT_RESIDENT, TRAIT_GENERIC)
	to_chat(user, span_notice("Печати достаточны: вас признают жителем этих земель."))
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/handle_stamp(mob/living/carbon/human/user)
	if(!can_stamp_manuscript(user))
		return FALSE
	var/seal_key = get_seal_key_for_user(user)
	if(!stamp_seal(seal_key, user, FALSE))
		return FALSE
	playsound(user, 'sound/items/write.ogg', 50, TRUE, -2)
	to_chat(user, span_notice("Вы вдавливаете свою печать в грамоту."))
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/log_detection_attempt(mob/living/carbon/human/user, result, method = "unknown", roll_success, chance)
	var/log_ckey = user.ckey || user.key || "нет ckey"
	var/character_name = user.real_name || user.name || "Неизвестно"
	var/scroll_owner_name = owner_name || "Не закреплена"
	var/roll_success_text = isnull(roll_success) ? "n/a" : "[roll_success]"
	var/chance_text = isnull(chance) ? "n/a" : "[chance]"
	var/log_line = "RESIDENT MANUSCRIPT CHECK: document=[REF(src)] inspector_ckey=[log_ckey] inspector_name=[character_name] method=[method] roll_success=[roll_success_text] chance=[chance_text] shown_result=[result] fake=[is_fake] master_fake=[undetectable_fake] authority_validated=[authority_validated] scroll_owner=[scroll_owner_name]"
	log_game(log_line)
	log_admin(log_line)

/obj/item/book/granter/resident_manuscript/proc/record_detection_result(mob/living/carbon/human/user, detection_key, result, method = "unknown", roll_success, chance)
	LAZYSET(detection_results, detection_key, result)
	log_detection_attempt(user, result, method, roll_success, chance)
	if(result == RESIDENT_MANUSCRIPT_VERIFICATION_FAKE)
		to_chat(user, span_warning("Вы замечаете признаки подделки в грамоте."))
	else
		var/note_key = pick(resident_manuscript_validation_note_keys())
		LAZYSET(detection_note_keys, detection_key, note_key)

/obj/item/book/granter/resident_manuscript/proc/handle_authority_detection(mob/living/carbon/human/user, detection_key)
	LAZYSET(detection_attempts, detection_key, TRUE)
	var/result = RESIDENT_MANUSCRIPT_VERIFICATION_REAL
	var/roll_success = TRUE
	if(is_fake)
		var/detected_fake = user.get_true_stat(STATKEY_INT) > 10 || prob(25)
		roll_success = detected_fake
		if(detected_fake)
			ensure_defect_note_keys()
			result = RESIDENT_MANUSCRIPT_VERIFICATION_FAKE
		else
			authority_validated = TRUE
	record_detection_result(user, detection_key, result, "authority", roll_success)
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/handle_detection(mob/living/carbon/human/user)
	if(!can_inspect_manuscript(user))
		return FALSE
	var/detection_key = get_detection_character_key(user)
	if(is_ruling_authority(user))
		return handle_authority_detection(user, detection_key)
	LAZYSET(detection_attempts, detection_key, TRUE)
	var/result = RESIDENT_MANUSCRIPT_VERIFICATION_UNKNOWN
	var/chance = 5
	chance += max(user.get_true_stat(STATKEY_INT) - 10, 0) * 4
	chance += max(user.get_true_stat(STATKEY_PER) - 10, 0) * 3
	chance += user.get_skill_level(/datum/skill/misc/reading) * 10
	if(HAS_TRAIT(user, TRAIT_INTELLECTUAL))
		chance += 15
	chance = clamp(chance, 5, 95)
	var/roll_success = prob(chance)
	if(roll_success)
		if(is_fake && !undetectable_fake)
			ensure_defect_note_keys()
			result = RESIDENT_MANUSCRIPT_VERIFICATION_FAKE
		else
			result = RESIDENT_MANUSCRIPT_VERIFICATION_REAL
	else if(!is_fake)
		result = RESIDENT_MANUSCRIPT_VERIFICATION_REAL
	record_detection_result(user, detection_key, result, "normal", roll_success, chance)
	return TRUE

/obj/item/book/granter/resident_manuscript/examine(mob/user)
	. = ..()
	if(is_bound && owner_name)
		. += span_info("Грамота выдана на имя [owner_name].")
	else
		. += span_info("Грамота еще не закреплена за владельцем.")

/obj/item/book/granter/resident_manuscript/attack_self(mob/living/user)
	ui_interact(user)

/obj/item/book/granter/resident_manuscript/equipped(mob/living/user, slot)
	. = ..()
	if(!auto_bind_on_equip || is_bound || !ishuman(user))
		return
	bind_to_holder(user)

/obj/item/book/granter/resident_manuscript/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/natural/feather) && ishuman(user))
		if(handle_feather_use(user))
			return
	return ..()

/obj/item/book/granter/resident_manuscript/proc/handle_feather_use(mob/living/carbon/human/user)
	if(!is_bound)
		if(is_fake)
			ui_interact(user)
			return TRUE
		if(bind_to_holder(user))
			to_chat(user, span_notice("Вы заполняете грамоту и закрепляете ее за своим именем."))
			playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
			return TRUE
	if(handle_stamp(user))
		return TRUE
	to_chat(user, span_warning("Вы не можете добавить в эту грамоту ничего надлежащего."))
	return TRUE

/obj/item/book/granter/resident_manuscript/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/book/granter/resident_manuscript/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResidentManuscript", "Грамота жителя")
		ui.open()

/obj/item/book/granter/resident_manuscript/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/human_user
	if(ishuman(user))
		human_user = user
	var/detection_key = human_user ? get_detection_character_key(human_user) : null
	var/is_owner_viewing = human_user ? is_owner_viewer(human_user) : FALSE
	var/can_edit_fake = human_user ? can_edit_fake_manuscript(human_user) : FALSE
	var/seal_key = human_user ? get_seal_key_for_user(human_user) : null
	var/can_stamp = FALSE
	if(human_user && is_bound && seal_key && !seals?[seal_key])
		can_stamp = TRUE
	var/can_inspect = human_user ? can_inspect_manuscript(human_user) : FALSE
	var/can_claim = human_user ? can_claim_residence(human_user) : FALSE
	var/can_bind = human_user ? can_bind_from_ui(human_user) : FALSE
	var/list/verification = list(
		"done" = FALSE,
		"result" = RESIDENT_MANUSCRIPT_VERIFICATION_NONE,
		"note_key" = null,
		"defect_note_key" = null,
		"defect_note_keys" = list(),
	)
	if(detection_key && LAZYACCESS(detection_attempts, detection_key))
		var/result = LAZYACCESS(detection_results, detection_key) || RESIDENT_MANUSCRIPT_VERIFICATION_UNKNOWN
		verification["done"] = TRUE
		verification["result"] = result
		if(result == RESIDENT_MANUSCRIPT_VERIFICATION_FAKE)
			verification["defect_note_keys"] = defect_note_keys || list()
			verification["defect_note_key"] = length(defect_note_keys) ? defect_note_keys[1] : null
		else
			verification["note_key"] = LAZYACCESS(detection_note_keys, detection_key)
	data["owner"] = list(
		"name" = owner_name,
		"age" = owner_age,
		"status" = owner_status_key,
		"status_key" = owner_status_key,
	)
	data["issued_place"] = issued_place
	data["realm_key"] = realm_key
	data["expiry_date"] = expiry_date
	data["is_bound"] = is_bound
	data["is_fake"] = is_fake
	data["is_blank"] = requires_feather_to_bind && !is_bound
	data["is_owner"] = is_owner_viewing
	data["profile"] = list(
		"id" = document_profile?.id || "resident",
		"display_name" = document_profile?.get_display_name(),
		"subtitle" = document_profile?.get_subtitle(),
		"description" = document_profile?.get_description(),
	)
	var/sorted_seals = get_seals_for_ui(user)
	var/list/dominant_entry
	for(var/list/entry as anything in sorted_seals)
		if(entry["dominant"])
			dominant_entry = entry
			break
	data["seals"] = sorted_seals
	data["dominant_seal"] = dominant_entry
	data["verification"] = verification
	data["permissions"] = list(
		"can_edit" = can_edit_fake,
		"can_stamp" = can_stamp,
		"can_inspect" = can_inspect,
		"can_claim" = can_claim,
		"can_bind" = can_bind,
		"stamp_key" = seal_key,
	)
	return data

/obj/item/book/granter/resident_manuscript/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(ui?.user))
		return FALSE
	var/mob/living/carbon/human/human_user = ui.user
	switch(action)
		if("save_fake")
			return save_fake_manuscript(human_user, params)
		if("inspect")
			return handle_detection(human_user)
		if("stamp")
			return handle_stamp(human_user)
		if("claim_residence")
			return claim_residence(human_user)
		if("bind")
			return bind_to_holder(human_user)
	return FALSE

/obj/item/book/granter/resident_manuscript/blank
	name = "Чистая грамота жителя"
	desc = "Чистая грамота жителя. Заполните ее пером, затем принесите надлежащим властям для печатей."
	icon_state = "contractunsigned"
	auto_stamp_seals = FALSE
	auto_bind_on_equip = FALSE
	requires_feather_to_bind = TRUE

/obj/item/book/granter/resident_manuscript/fake
	name = "Подозрительная грамота жителя"
	desc = "Грамота жителя, происхождение которой лучше не обсуждать."
	auto_stamp_seals = FALSE
	auto_bind_on_equip = FALSE
	is_fake = TRUE

/obj/item/book/granter/resident_manuscript/fake/Initialize()
	. = ..()
	generate_fake_seals()
	if(prob(RESIDENT_MANUSCRIPT_FAKE_DEFECT_CHANCE))
		ensure_defect_note_keys()

/obj/item/book/granter/resident_manuscript/roundstart

/obj/item/book/granter/resident_manuscript/imperial
	desc = "Имперская грамота покровительства, скрепленная контрасигнацией канцелярии."
	document_profile_id = "imperial"

/obj/item/book/granter/resident_manuscript/blank/imperial
	desc = "Чистая имперская грамота покровительства. Заготовка для канцелярского заполнения и заверения."
	document_profile_id = "imperial"

/obj/item/book/granter/resident_manuscript/fake/imperial
	desc = "Имперская грамота покровительства, происхождение которой лучше не обсуждать."
	document_profile_id = "imperial"

/obj/item/book/granter/resident_manuscript/enigma_crown
	desc = "Коронная грамота Энигмы, удостоверяющая королевские полномочия предъявителя на Рокхилле."
	document_profile_id = "enigma_crown"

/obj/item/book/granter/resident_manuscript/blank/enigma_crown
	desc = "Чистая коронная грамота Энигмы. Заполните ее пером, затем принесите за печатью королевского двора."
	document_profile_id = "enigma_crown"

/obj/item/book/granter/resident_manuscript/fake/enigma_crown
	desc = "Коронная грамота Энигмы, происхождение которой лучше не обсуждать."
	document_profile_id = "enigma_crown"

/obj/item/book/granter/resident_manuscript/valorian_church
	desc = "Валорийская грамота Святого Престола, признающая церковный сан предъявителя на Рокхилле."
	document_profile_id = "valorian_church"

/obj/item/book/granter/resident_manuscript/blank/valorian_church
	desc = "Чистая валорийская грамота Святого Престола. Заполните ее пером, затем принесите за церковной печатью."
	document_profile_id = "valorian_church"

/obj/item/book/granter/resident_manuscript/fake/valorian_church
	desc = "Валорийская грамота Святого Престола, происхождение которой лучше не обсуждать."
	document_profile_id = "valorian_church"

/obj/item/book/granter/resident_manuscript/grenzelhoft_mission
	desc = "Имперское командировочное удостоверение, признающее предъявителя частью направленного отряда."
	document_profile_id = "grenzelhoft_mission"

/obj/item/book/granter/resident_manuscript/blank/grenzelhoft_mission
	desc = "Чистое имперское командировочное удостоверение. Заготовка для канцелярского заполнения и заверения."
	document_profile_id = "grenzelhoft_mission"

/obj/item/book/granter/resident_manuscript/fake/grenzelhoft_mission
	desc = "Имперское командировочное удостоверение, происхождение которого лучше не обсуждать."
	document_profile_id = "grenzelhoft_mission"

/obj/item/book/granter/resident_manuscript/heartfelt_identity
	desc = "Хартфельтское удостоверение личности, заверяющее имя и положение предъявителя."
	document_profile_id = "heartfelt_identity"

/obj/item/book/granter/resident_manuscript/blank/heartfelt_identity
	desc = "Чистое хартфельтское удостоверение личности. Заготовка для канцелярского заполнения и заверения."
	document_profile_id = "heartfelt_identity"

/obj/item/book/granter/resident_manuscript/fake/heartfelt_identity
	desc = "Хартфельтское удостоверение личности, происхождение которого лучше не обсуждать."
	document_profile_id = "heartfelt_identity"

/obj/item/book/granter/resident_manuscript/heartfelt_noble
	desc = "Свидетельство о дворянстве, заверяющее благородное положение предъявителя."
	document_profile_id = "heartfelt_noble"

/obj/item/book/granter/resident_manuscript/blank/heartfelt_noble
	desc = "Чистое свидетельство о дворянстве. Заготовка для канцелярского заполнения и заверения."
	document_profile_id = "heartfelt_noble"

/obj/item/book/granter/resident_manuscript/fake/heartfelt_noble
	desc = "Свидетельство о дворянстве, происхождение которого лучше не обсуждать."
	document_profile_id = "heartfelt_noble"

/obj/item/book/granter/resident_manuscript/guards
	desc = "Гарнизонная грамота, удостоверяющая службу предъявителя в городском гарнизоне."
	document_profile_id = "guards"

/obj/item/book/granter/resident_manuscript/blank/guards
	desc = "Чистая гарнизонная грамота. Заполните ее пером, затем принесите надлежащим властям для печатей."
	document_profile_id = "guards"

/obj/item/book/granter/resident_manuscript/fake/guards
	desc = "Гарнизонная грамота, происхождение которой лучше не обсуждать."
	document_profile_id = "guards"

/obj/item/book/granter/resident_manuscript/church
	desc = "Церковная грамота Десятеричной Церкви, признающая предъявителя верным чадом веры."
	document_profile_id = "church"

/obj/item/book/granter/resident_manuscript/blank/church
	desc = "Чистая церковная грамота. Заполните ее пером, затем принесите за печатью епископа."
	document_profile_id = "church"

/obj/item/book/granter/resident_manuscript/fake/church
	desc = "Церковная грамота, происхождение которой лучше не обсуждать."
	document_profile_id = "church"

/obj/item/book/granter/resident_manuscript/craftsmen
	desc = "Хартия ремесленной гильдии, признающая положение предъявителя среди мастеров города."
	document_profile_id = "craftsmen"

/obj/item/book/granter/resident_manuscript/blank/craftsmen
	desc = "Чистая хартия ремесленной гильдии. Заполните ее пером, затем принесите надлежащим властям для печатей."
	document_profile_id = "craftsmen"

/obj/item/book/granter/resident_manuscript/fake/craftsmen
	desc = "Гильдейская хартия, происхождение которой лучше не обсуждать."
	document_profile_id = "craftsmen"

/obj/item/book/granter/resident_manuscript/commoner
	desc = "Помятая грамота горожанина на дешевой тряпичной бумаге, достаточная лишь для простого положения."
	document_profile_id = "commoner"

/obj/item/book/granter/resident_manuscript/blank/commoner
	desc = "Дешевая чистая грамота горожанина, тонкая на сгиб и шершавая на кляксы."
	document_profile_id = "commoner"

/obj/item/book/granter/resident_manuscript/fake/commoner
	desc = "Пятнистая грамота горожанина с плохой бумагой и подозрительно свежими чернилами."
	document_profile_id = "commoner"

/obj/item/book/granter/resident_manuscript/mercenary
	desc = "Пурпурный наемный контракт, признающий предъявителя вольным клинком достойного положения."
	document_profile_id = "mercenary"

/obj/item/book/granter/resident_manuscript/blank/mercenary
	desc = "Чистый наемный контракт. Заполните его пером, затем принесите надлежащим властям для печатей."
	document_profile_id = "mercenary"

/obj/item/book/granter/resident_manuscript/fake/mercenary
	desc = "Наемный контракт, происхождение которого лучше не обсуждать."
	document_profile_id = "mercenary"

/obj/item/book/granter/resident_manuscript/otava
	desc = "Серебряно-золотой эдикт Отавы, дающий предъявителю власть в делах истины и веры."
	document_profile_id = "otava"

/obj/item/book/granter/resident_manuscript/blank/otava
	desc = "Чистый эдикт Отавы. Заполните его пером, затем принесите за печатью инквизитора."
	document_profile_id = "otava"

/obj/item/book/granter/resident_manuscript/fake/otava
	desc = "Эдикт Отавы, происхождение которого лучше не обсуждать."
	document_profile_id = "otava"

/obj/item/book/granter/resident_manuscript/retinue
	desc = "Грамота дворцовой службы, указывающая на личную присягу и место предъявителя при дворе."
	document_profile_id = "retinue"

/obj/item/book/granter/resident_manuscript/blank/retinue
	desc = "Чистая грамота дворцовой службы. Заполните ее пером, затем принесите за печатью двора."
	document_profile_id = "retinue"

/obj/item/book/granter/resident_manuscript/fake/retinue
	desc = "Грамота дворцовой службы, происхождение которой лучше не обсуждать."
	document_profile_id = "retinue"

/obj/item/book/granter/resident_manuscript/merchant
	desc = "Валорийское торговое разрешение, признающее положение предъявителя в торговле и договорах."
	document_profile_id = "merchant"

/obj/item/book/granter/resident_manuscript/blank/merchant
	desc = "Чистое валорийское торговое разрешение. Заполните его пером, затем принесите за гильдейской печатью."
	document_profile_id = "merchant"

/obj/item/book/granter/resident_manuscript/fake/merchant
	desc = "Валорийское торговое разрешение, происхождение которого лучше не обсуждать."
	document_profile_id = "merchant"

/obj/item/book/granter/resident_manuscript/mages
	desc = "Патент гильдии магов, признающий предъявителя дозволенным практиком под властью Короны."
	document_profile_id = "mages"

/obj/item/book/granter/resident_manuscript/blank/mages
	desc = "Чистый патент гильдии магов. Заполните его пером, затем принесите за печатью придворного мага."
	document_profile_id = "mages"

/obj/item/book/granter/resident_manuscript/fake/mages
	desc = "Патент гильдии магов, происхождение которого лучше не обсуждать."
	document_profile_id = "mages"
