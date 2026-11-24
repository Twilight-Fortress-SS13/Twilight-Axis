#define VAMPIRE_CHOOSE_CLAN_ALERT_CATEGORY "vampire_choose_clan"

/atom/movable/screen/alert/vampire_choose_clan
	name = "Выбор клана"
	desc = "Выберите клан вампиров, когда будете готовы. Нажмите, чтобы открыть меню."
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "bat_transform"
	alert_group = ALERT_BUFF
	plane = ABOVE_HUD_PLANE
	layer = ABOVE_HUD_LAYER

/atom/movable/screen/alert/vampire_choose_clan/Click(location, control, params)
	var/mob/living/carbon/human/user = usr
	if(!istype(user) || !user.client)
		return
	if(user.alerts[VAMPIRE_CHOOSE_CLAN_ALERT_CATEGORY] != src)
		return
	user.vampire_choose_clan_verb()

/mob/living/carbon/human/proc/vampire_show_choose_clan_button()
	if(!client || !hud_used)
		return FALSE
	var/atom/movable/screen/alert/vampire_choose_clan/alert = throw_alert(VAMPIRE_CHOOSE_CLAN_ALERT_CATEGORY, /atom/movable/screen/alert/vampire_choose_clan)
	if(!istype(alert))
		return FALSE
	alert.transform = alert.transform.Scale(1.8, 1.8)
	alert.add_filter("vampire_clan_glow", 2, list("type" = "outline", "size" = 1, "color" = "#8b1a3a"))
	animate(alert, alpha = 150, time = 8 SECONDS, loop = -1, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
	animate(alpha = 255, time = 8 SECONDS, easing = SINE_EASING)
	return TRUE

/mob/living/carbon/human/proc/vampire_clear_choose_clan_button()
	if(alerts && alerts[VAMPIRE_CHOOSE_CLAN_ALERT_CATEGORY])
		clear_alert(VAMPIRE_CHOOSE_CLAN_ALERT_CATEGORY)

/atom/movable/screen/alert/vampire_choose_clan/proc/update_timeout_bar(ticks_left, ticks_total)
	if(ticks_left <= 0)
		if(istype(maptext_holder))
			maptext_holder.maptext = null
		return
	if(!istype(maptext_holder))
		maptext_holder = new(src)
		maptext_holder.x = -6
		maptext_holder.y = -10
		maptext_holder.color = "#e0a0b0"
		vis_contents.Add(maptext_holder)
	var/bar = ""
	for(var/i in 1 to ticks_total)
		bar += (i <= ticks_left) ? "▰" : "▱"
	maptext_holder.maptext = MAPTEXT(bar)

/mob/living/carbon/human/proc/vampire_update_choose_clan_timeout_bar(ticks_left, ticks_total)
	var/atom/movable/screen/alert/vampire_choose_clan/alert = alerts?[VAMPIRE_CHOOSE_CLAN_ALERT_CATEGORY]
	if(istype(alert))
		alert.update_timeout_bar(ticks_left, ticks_total)

/datum/antagonist/vampire
	var/datum/vampire_clan_selection_menu/clan_menu

/datum/antagonist/vampire/Destroy()
	QDEL_NULL(clan_menu)
	return ..()

/datum/antagonist/vampire/proc/pause_clan_choice_timeout()
	return

/datum/antagonist/vampire/proc/resume_clan_choice_timeout()
	return

/datum/antagonist/vampire/show_clan_selection(mob/living/carbon/human/vampdude)
	if(!vampdude || clan_selected)
		return
	if(clan_menu)
		clan_menu.ui_interact(vampdude)
		return
	if((vampdude.job == "Wretch" || vampdude.job == "Vagabond") && vampdude.get_vampire_generation() <= GENERATION_NEONATE)
		var/wretch_name = tgui_input_text(vampdude, "Нареки свою линию крови каитиффов.", "Имя клана", encode = FALSE)
		create_custom_clan(vampdude, wretch_name)
		return
	. = ..()
	if(clan_menu && !SStgui.get_open_ui(vampdude, clan_menu))
		QDEL_NULL(clan_menu)
	if(QDELETED(src) || QDELETED(vampdude) || clan_selected)
		return
	add_verb(vampdude, /mob/living/carbon/human/proc/vampire_choose_clan_verb)
	vampdude.vampire_show_choose_clan_button()

/datum/antagonist/vampire/finalize_clan_selection(mob/living/carbon/human/vampdude, clan_type)
	if(clan_selected || QDELETED(src) || QDELETED(vampdude) || owner?.current != vampdude)
		return
	clan_selected = TRUE
	default_clan = clan_type || /datum/clan/crimson_fang
	vampdude.set_clan(default_clan)
	after_gain()

/datum/antagonist/vampire/after_gain()
	. = ..()
	var/mob/living/carbon/human/vampdude = owner?.current
	if(!istype(vampdude))
		return
	remove_verb(vampdude, /mob/living/carbon/human/proc/vampire_choose_clan_verb)
	vampdude.vampire_clear_choose_clan_button()
	var/datum/component/vampire_disguise/disguise_comp = vampdude.GetComponent(/datum/component/vampire_disguise)
	disguise_comp?.apply_disguise(vampdude)

/mob/living/carbon/human/proc/vampire_choose_clan_verb()
	set name = "Choose Clan"
	set category = "RoleUnique.Vampire"

	var/datum/antagonist/vampire/vamp_antag = mind?.has_antag_datum(/datum/antagonist/vampire)
	if(!vamp_antag)
		to_chat(src, span_warning("I have no clan to choose."))
		return
	if(vamp_antag.clan_selected)
		to_chat(src, span_warning("I have already sworn myself to a clan."))
		return
	vamp_antag.show_clan_selection(src)

/datum/vampire_clan_selection_menu/New(datum/antagonist/vampire/source_antag, mob/living/carbon/human/source_user)
	. = ..()
	antag?.clan_menu = src

/datum/vampire_clan_selection_menu/Destroy()
	SStgui.close_uis(src)
	if(antag?.clan_menu == src)
		antag.clan_menu = null
	return ..()

/datum/vampire_clan_selection_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VampireClanSelection", "Выбор клана")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/vampire_clan_selection_menu/ui_close(mob/user)
	if(QDELETED(src))
		return
	var/datum/antagonist/vampire/source_antag = antag
	qdel(src)
	source_antag?.resume_clan_choice_timeout()

/datum/vampire_clan_selection_menu/ui_data(mob/user)
	return list()

/datum/vampire_clan_selection_menu/ui_static_data(mob/user)
	var/list/data = list()
	var/list/clans = list()
	var/list/covens_by_id = list()
	for(var/datum/clan/clan_type as anything in subtypesof(/datum/clan))
		if(initial(clan_type.selectable_by_vampires))
			UNTYPED_LIST_ADD(clans, clan_entry(clan_type, covens_by_id))

	var/list/custom_entry = clan_entry(/datum/clan/custom, covens_by_id)
	custom_entry["id"] = "custom"
	custom_entry["isCustom"] = TRUE
	UNTYPED_LIST_ADD(clans, custom_entry)

	var/list/covens = list()
	for(var/coven_id in covens_by_id)
		UNTYPED_LIST_ADD(covens, covens_by_id[coven_id])

	data["clans"] = clans
	data["covens"] = covens
	data["defaultClanId"] = "[selected_clan_type]"
	data["maxNameLength"] = MAX_NAME_LEN
	return data

/datum/vampire_clan_selection_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(action != "confirm_clan" && action != "dismiss")
		return FALSE
	. = ..()
	if(.)
		return
	if(QDELETED(src) || QDELETED(antag) || QDELETED(vampdude) || ui.user != vampdude)
		return

	if(action == "dismiss")
		SStgui.close_uis(src)
		return TRUE

	var/datum/antagonist/vampire/source_antag = antag
	var/mob/living/carbon/human/source_user = vampdude
	var/clan_id = params["clan_id"]
	if(clan_id == "custom")
		SStgui.close_uis(src)
		source_antag.create_custom_clan(source_user, params["custom_name"])
		return TRUE

	var/clan_type = istext(clan_id) ? text2path(clan_id) : null
	if(!is_valid_selectable_clan(clan_type))
		return
	SStgui.close_uis(src)
	source_antag.finalize_clan_selection(source_user, clan_type)
	return TRUE

/datum/vampire_clan_selection_menu/is_valid_selectable_clan(clan_type)
	if(!ispath(clan_type, /datum/clan))
		return FALSE
	var/datum/clan/clan = clan_type
	return initial(clan.selectable_by_vampires)

/datum/vampire_clan_selection_menu/proc/clan_entry(clan_type, list/covens_by_id)
	var/datum/clan/clan = new clan_type()
	var/list/text = ta_vampire_clan_text(clan_type) || list()

	var/covens_to_select = clan.covens_to_select
	if(istype(clan, /datum/clan/custom))
		covens_to_select = ta_custom_clan_coven_count(vampdude?.get_vampire_generation(), covens_to_select)

	var/list/coven_ids = list()
	for(var/coven_type in clan.clane_covens)
		var/coven_id = "[coven_type]"
		coven_ids += coven_id
		if(!covens_by_id[coven_id])
			covens_by_id[coven_id] = coven_to_ui(coven_type)

	var/datum/clan_leader/leader = new clan.leader()
	var/list/lord_forms = list()
	for(var/spell_type in leader.lord_spells)
		UNTYPED_LIST_ADD(lord_forms, lord_form_label(spell_type))

	. = list(
		"id" = "[clan_type]",
		"name" = text["name"] || clan.name,
		"tagline" = text["tagline"] || "",
		"desc" = text["desc"] || clan.desc,
		"curse" = text["curse"] || clan.curse,
		"downside" = text["downside"] || clan.get_downside_string(),
		"bloodPreference" = text["bloodPreference"] || clan.get_blood_preference_string(),
		"isCustom" = FALSE,
		"covensToSelect" = covens_to_select,
		"covenIds" = coven_ids,
		"clanTraits" = get_unique_clan_traits(clan),
		"lordTitle" = text["lordTitle"] || leader.lord_title,
		"lordForms" = lord_forms,
		"lordTraits" = get_unique_lord_traits(leader),
		"vitaeBonus" = leader.vitae_bonus,
	)
	qdel(leader)
	qdel(clan)

/datum/vampire_clan_selection_menu/coven_to_ui(datum/coven/coven_type)
	var/list/text = ta_vampire_ui_text(coven_type)
	var/ascended_type = initial(coven_type.ta_ascended_power_type)
	var/list/power_types = subtypesof(initial(coven_type.power_type))
	var/list/powers = list()
	for(var/level in 1 to initial(coven_type.max_level))
		for(var/datum/coven_power/power_type as anything in power_types)
			if(initial(power_type.level) != level || (ascended_type && ispath(power_type, ascended_type)))
				continue
			UNTYPED_LIST_ADD(powers, power_to_ui(power_type))
	return list(
		"id" = "[coven_type]",
		"name" = text ? text[1] : initial(coven_type.name),
		"desc" = text ? text[2] : initial(coven_type.desc),
		"powers" = powers,
	)

/datum/vampire_clan_selection_menu/power_to_ui(datum/coven_power/power_type)
	var/list/text = ta_vampire_ui_text(power_type)
	return list(
		"name" = text ? text[1] : initial(power_type.name),
		"desc" = text ? text[2] : initial(power_type.desc),
		"level" = initial(power_type.level),
		"vitaeCost" = initial(power_type.vitae_cost),
	)

/datum/vampire_clan_selection_menu/lord_form_label(obj/effect/proc_holder/spell/spell_type)
	var/list/text = ta_vampire_ui_text(spell_type)
	return list(
		"name" = text ? text[1] : initial(spell_type.name),
		"desc" = text ? text[2] : initial(spell_type.desc),
	)

/datum/vampire_clan_selection_menu/trait_label(trait)
	var/list/text = ta_vampire_trait_text(trait)
	return text ? list("name" = text[1], "desc" = text[2]) : null

#undef VAMPIRE_CHOOSE_CLAN_ALERT_CATEGORY
