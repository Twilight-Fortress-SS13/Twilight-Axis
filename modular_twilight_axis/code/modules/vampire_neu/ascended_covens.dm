#define TA_ASCENDED_COVEN_FILTER "ta_ascended_coven"
#define TA_ASCENDED_COVEN_TRAIT "ta_ascended_coven"
#define TA_ASCENDED_COVEN_LIGHT "#ffe27a"
#define TA_DEMONIC_CONVERSION_VERB /mob/living/carbon/human/proc/ta_drink_ascended_lord_blood
#define TA_DEMONIC_EMBRACE_STASIS_TIME 5 SECONDS
#define TA_DEMONIC_EMBRACE_FILTER "ta_demonic_embrace_darkness"
#define TA_DEMONIC_EMBRACE_COLOR "#37114d"
#define TA_OMNIPOTENCE_DAMAGE 50
#define TA_OMNIPOTENCE_MIN_ARMOR_DAMAGE 100
#define TA_OMNIPOTENCE_LAUNCH_DISTANCE 10
#define TA_OMNIPOTENCE_COLLISION_PUSH_DISTANCE 3
#define TA_OMNIPOTENCE_BLOOD_TRAIL_AMOUNT 10
#define TA_OMNIPOTENCE_FLIGHT_FILTER "ta_omnipotence_flight_glow"
#define TA_OMNIPOTENCE_FLIGHT_COLOR "#F0E68C"
#define TA_OMNIPOTENCE_FLIGHT_OVERLAY_TIME 2 SECONDS
#define TA_ASCENDED_POISON_CLOUD_RADIUS 4
#define TA_ASCENDED_POISON_STAMINA_DRAIN 50
#define TA_ASCENDED_POISON_TOX_DAMAGE 10

/datum/antagonist/vampire/lord
	var/datum/coven/ta_ascended_coven
//	var/list/ta_bloodheal_rebirth_covens
//	var/list/ta_bloodheal_spent_rebirth_covens

/datum/coven
	var/ta_ascended = FALSE
	var/ta_ascended_power_type
	var/datum/coven_power/ta_ascended_power
	var/datum/action/ta_ascended_coven/ta_ascended_action
	var/tmp/ta_old_light_outer_range
	var/tmp/ta_old_light_inner_range
	var/tmp/ta_old_light_power
	var/tmp/ta_old_light_color
	var/tmp/ta_old_light_on

/mob/living/carbon/human
//	var/tmp/ta_auspex_full_vision = FALSE
	var/datum/weakref/ta_demonic_sire_ref
	var/tmp/ta_demonic_embrace_active = FALSE
	var/datum/coven_power/celerity/ascended_afterpass/ta_afterpass_power

/datum/coven_power
	var/tmp/ta_ascended_vitae_drain_timer

/datum/coven_power/proc/ta_start_ascended_vitae_drain(atom/target)
	ta_stop_ascended_vitae_drain()
	ta_ascended_vitae_drain_timer = addtimer(CALLBACK(src, PROC_REF(ta_ascended_vitae_drain), target), 1 SECONDS, TIMER_STOPPABLE)

/datum/coven_power/proc/ta_stop_ascended_vitae_drain()
	if(!ta_ascended_vitae_drain_timer)
		return
	deltimer(ta_ascended_vitae_drain_timer)
	ta_ascended_vitae_drain_timer = null

/datum/coven_power/proc/ta_ascended_vitae_drain(atom/target)
	ta_ascended_vitae_drain_timer = null
	if(!active || !owner)
		return
	if(!spend_resources())
		to_chat(owner, span_warning("You do not have enough Vitae to keep [src] active."))
		try_deactivate(target, TRUE)
		return
	on_refresh(target)
	ta_start_ascended_vitae_drain(target)

/*
/datum/coven/bloodheal
	ta_ascended_power_type = /datum/coven_power/bloodheal/ascended_rebirth
*/

/datum/coven/potence
	ta_ascended_power_type = /datum/coven_power/potence/ascended_omnipotence

/datum/coven/celerity
	ta_ascended_power_type = /datum/coven_power/celerity/ascended_afterpass

/datum/coven/demonic
	ta_ascended_power_type = /datum/coven_power/demonic/ascended_embrace

/*
/datum/coven/fae_trickery
	ta_ascended_power_type = /datum/coven_power/fae_trickery/ascended_portal

/datum/coven/siren
	ta_ascended_power_type = /datum/coven_power/siren/ascended_chorus
*/

/datum/coven/obfuscate
	ta_ascended_power_type = /datum/coven_power/obfuscate/ascended_vanish

/*
/datum/coven/auspex
	ta_ascended_power_type = /datum/coven_power/auspex/ascended_watch
*/

/datum/coven/eora
	ta_ascended_power_type = /datum/coven_power/eora/ascended_serenity

/datum/coven/quietus
	ta_ascended_power_type = /datum/coven_power/quietus/ascended_poison_cloud

/*
/datum/coven/bloodheal/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)
*/

/datum/coven/potence/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)

/datum/coven/celerity/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)

/datum/coven/demonic/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)

/*
/datum/coven/fae_trickery/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)

/datum/coven/siren/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)
*/

/datum/coven/obfuscate/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)

/*
/datum/coven/auspex/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)
*/

/datum/coven/eora/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)

/datum/coven/quietus/New(level)
	. = ..()
	ta_rebuild_without_ascended_power(level)

/datum/coven/proc/ta_rebuild_without_ascended_power(level)
	if(ta_filter_ascended_power_type() && level)
		initialize_powers_for_level(level)

/datum/coven/proc/ta_filter_ascended_power_type()
	if(!ta_ascended_power_type || !length(all_powers))
		return FALSE
	var/filtered = FALSE
	var/list/powers_list = all_powers
	for(var/power_type in powers_list.Copy())
		if(ispath(power_type, ta_ascended_power_type))
			powers_list -= power_type
			filtered = TRUE
	return filtered

/datum/coven/Destroy()
	ta_unascend()
	QDEL_NULL(ta_ascended_action)
	QDEL_NULL(ta_ascended_power)
	QDEL_LIST(known_powers)
	return ..()

/datum/coven/proc/ta_ascend(mob/living/carbon/human/lord_body)
	if(ta_ascended || !owner || owner != lord_body || !ta_ascended_power_type)
		return FALSE

	ta_ascended = TRUE
	ta_apply_ascended_look(lord_body)

	if(level < max_level)
		for(var/datum/coven_power/old_power as anything in known_powers)
			if(old_power.active)
				old_power.try_deactivate(direct = TRUE)
		set_level(max_level)
		for(var/datum/coven_power/power as anything in known_powers)
			power.set_owner(owner)
			power.post_gain()

	var/datum/coven_power/ascended_power = ta_get_or_create_ascended_power()
	if(ascended_power)
		ta_grant_ascended_action(lord_body, ascended_power)

	coven_action?.build_all_button_icons(force = TRUE)
	return TRUE

/datum/coven/proc/ta_unascend()
	if(!ta_ascended)
		return
	ta_ascended = FALSE
	if(owner)
		owner.remove_filter(TA_ASCENDED_COVEN_FILTER)
		owner.set_light(ta_old_light_outer_range, ta_old_light_inner_range, ta_old_light_power, l_color = ta_old_light_color, l_on = ta_old_light_on)
		if(ta_ascended_action)
			ta_ascended_action.Remove(owner)
	if(ta_ascended_power?.active)
		ta_ascended_power.try_deactivate(direct = TRUE)
	coven_action?.build_all_button_icons(force = TRUE)

/datum/coven/proc/ta_get_or_create_ascended_power()
	if(!ta_ascended_power_type || !owner)
		return null

	for(var/datum/coven_power/power as anything in known_powers)
		if(power.type != ta_ascended_power_type)
			continue
		var/was_current_power = (current_power == power)
		if(power.active)
			power.try_deactivate(direct = TRUE)
		known_powers -= power
		if(was_current_power)
			current_power = null
		qdel(power)

	if(length(known_powers))
		level_casting = clamp(level_casting, 1, length(known_powers))
		if(!current_power)
			current_power = known_powers[level_casting]
	else
		level_casting = 1
		current_power = null

	if(!ta_ascended_power)
		ta_ascended_power = new ta_ascended_power_type(src)
		ta_ascended_power.set_owner(owner)
		ta_ascended_power.post_gain()
	else
		ta_ascended_power.discipline = src
		ta_ascended_power.set_owner(owner)
	return ta_ascended_power

/datum/coven/proc/ta_grant_ascended_action(mob/living/carbon/human/lord_body, datum/coven_power/ascended_power)
	if(!lord_body || !ascended_power)
		return
	if(!ta_ascended_action)
		ta_ascended_action = new /datum/action/ta_ascended_coven(src, ascended_power)
	else
		ta_ascended_action.coven = src
		ta_ascended_action.power = ascended_power
	if(ta_ascended_action.owner != lord_body)
		ta_ascended_action.Grant(lord_body)
	ta_ascended_action.build_all_button_icons(force = TRUE)

/datum/coven/proc/ta_apply_ascended_look(mob/living/carbon/human/lord_body)
	if(!lord_body)
		return
	ta_old_light_outer_range = lord_body.light_outer_range
	ta_old_light_inner_range = lord_body.light_inner_range
	ta_old_light_power = lord_body.light_power
	ta_old_light_color = lord_body.light_color
	ta_old_light_on = lord_body.light_on
	lord_body.add_filter(TA_ASCENDED_COVEN_FILTER, 2, list("type" = "outline", "color" = TA_ASCENDED_COVEN_LIGHT, "alpha" = 200, "size" = 2))
	lord_body.set_light(4, 2, 2, l_color = TA_ASCENDED_COVEN_LIGHT)

/datum/action/ta_ascended_coven
	check_flags = NONE
	background_icon = 'icons/mob/actions/vampspells.dmi'
	background_icon_state = "spell"
	button_icon = 'icons/mob/actions/vampspells.dmi'
	button_icon_state = "coven"
	overlay_icon = 'icons/mob/actions/vampspells.dmi'
	overlay_icon_state = "5"

	var/datum/coven/coven
	var/datum/coven_power/power
	var/targeting = FALSE

/datum/action/ta_ascended_coven/New(datum/coven/new_coven, datum/coven_power/new_power)
	coven = new_coven
	power = new_power
	return ..(new_coven)

/datum/action/ta_ascended_coven/Remove(mob/remove_from)
	end_targeting()
	return ..()

/datum/action/ta_ascended_coven/IsAvailable()
	return power?.can_activate_untargeted()

/datum/action/ta_ascended_coven/Trigger(trigger_flags)
	if(targeting)
		end_targeting()
		return FALSE

	. = ..()
	if(!.)
		return FALSE

	build_all_button_icons()

	if(!power || !isliving(owner))
		return FALSE

	if(power.active)
		if(power.cancelable || power.toggled)
			ta_manual_deactivate()
		else
			to_chat(owner, span_warning("[power] is already active!"))
	else
		if(power.target_type == NONE)
			power.try_activate()
		else
			begin_targeting()

	build_all_button_icons()
	return TRUE

/datum/action/ta_ascended_coven/proc/ta_manual_deactivate()
	if(istype(power, /datum/coven_power/potence/ascended_omnipotence))
		var/datum/coven_power/potence/ascended_omnipotence/omnipotence = power
		omnipotence.ta_cancel_prepared_strike()
	else
		power.try_deactivate(direct = TRUE, alert = TRUE)

/datum/action/ta_ascended_coven/update_button_name(atom/movable/screen/movable/action_button/button, force)
	. = ..()
	if(power)
		name = power.name
		desc = replacetext(power.desc, "\nRight click to switch this coven's level, alt right click to cycle backwards.", "")
		button.name = name
		button.desc = desc

/datum/action/ta_ascended_coven/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force)
	if(coven)
		button_icon_state = coven.icon_state
	else
		button_icon_state = initial(button_icon_state)
	. = ..()
	current_button.add_filter(TA_ASCENDED_COVEN_FILTER, 2, list("type" = "outline", "color" = TA_ASCENDED_COVEN_LIGHT, "alpha" = 220, "size" = 1))

/datum/action/ta_ascended_coven/apply_button_overlay(atom/movable/screen/movable/action_button/current_button, force)
	overlay_icon_state = "5"
	if(!overlay_icon || !overlay_icon_state || (current_button.active_overlay_icon_state == overlay_icon_state && !force))
		return
	current_button.cut_overlay(current_button.button_overlay)
	current_button.button_overlay = mutable_appearance(icon = overlay_icon, icon_state = overlay_icon_state)
	current_button.button_overlay.color = TA_ASCENDED_COVEN_LIGHT
	current_button.add_overlay(current_button.button_overlay)
	current_button.active_overlay_icon_state = overlay_icon_state

/datum/action/ta_ascended_coven/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return targeting || power?.active

/datum/action/ta_ascended_coven/proc/end_targeting()
	var/client/client = owner?.client
	if(!client || !targeting)
		return
	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	targeting = FALSE
	client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
	build_all_button_icons()

/datum/action/ta_ascended_coven/proc/handle_click(mob/source, atom/target, params)
	SIGNAL_HANDLER
	var/list/modifiers = params2list(params)
	if(!targeting || LAZYACCESS(modifiers, RIGHT_CLICK))
		end_targeting()
		return COMSIG_MOB_CANCEL_CLICKON
	INVOKE_ASYNC(src, PROC_REF(ta_async_target_activate), target)
	end_targeting()
	return COMSIG_MOB_CANCEL_CLICKON

/datum/action/ta_ascended_coven/proc/ta_async_target_activate(atom/target)
	if(!owner || !power)
		return
	if(power?.try_activate(target))
		build_all_button_icons()

/datum/action/ta_ascended_coven/proc/begin_targeting()
	var/client/client = owner?.client
	if(!client || targeting || !power)
		return
	if(!power.can_activate_untargeted(TRUE))
		return
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(handle_click))
	targeting = TRUE
	build_all_button_icons()

/datum/action/coven/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force)
	. = ..()
	if(coven?.ta_ascended)
		current_button.add_filter(TA_ASCENDED_COVEN_FILTER, 2, list("type" = "outline", "color" = TA_ASCENDED_COVEN_LIGHT, "alpha" = 220, "size" = 1))
	else
		current_button.remove_filter(TA_ASCENDED_COVEN_FILTER)

/datum/action/coven/apply_button_overlay(atom/movable/screen/movable/action_button/current_button, force)
	if(coven?.ta_ascended)
		overlay_icon_state = "[min(coven.level_casting, coven.max_level)]"
		SEND_SIGNAL(src, COMSIG_ACTION_OVERLAY_APPLY, current_button, force)
		if(!overlay_icon || !overlay_icon_state || (current_button.active_overlay_icon_state == overlay_icon_state && !force))
			return
		current_button.cut_overlay(current_button.button_overlay)
		current_button.button_overlay = mutable_appearance(icon = overlay_icon, icon_state = overlay_icon_state)
		current_button.button_overlay.color = TA_ASCENDED_COVEN_LIGHT
		current_button.add_overlay(current_button.button_overlay)
		current_button.active_overlay_icon_state = overlay_icon_state
		return
	return ..()

/datum/vampire_project/power_growth_4/on_complete()
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(!lord || lord.ascended)
			continue

		var/mob/living/carbon/human/lord_body = user
		if(!istype(lord_body))
			continue

		for(var/S in MOBSTATS)
			lord_body.change_stat(S, 2)
		lord_body.maxbloodpool += 1000
		to_chat(user, span_danger("I AM ANCIENT, I AM THE LAND. EVEN THE SUN BOWS TO ME."))
		lord.ascended = TRUE

		if(lord_body.clan_position)
			var/list/all_subordinates = lord_body.clan_position.get_all_subordinates()
			for(var/datum/clan_hierarchy_node/subordinate as anything in all_subordinates)
				var/mob/living/carbon/human/subordinate_body = subordinate.assigned_member
				if(!istype(subordinate_body))
					continue
				subordinate_body.maxbloodpool += 1000
				for(var/S in MOBSTATS)
					subordinate_body.change_stat(S, 2)

		bloodpool.available_project_types -= /datum/vampire_project/power_growth_4
		if(lord.ta_can_choose_ascended_coven(lord_body))
			INVOKE_ASYNC(lord, TYPE_PROC_REF(/datum/antagonist/vampire/lord, ta_offer_ascended_coven), lord_body)
		break

/datum/antagonist/vampire/lord/proc/ta_can_choose_ascended_coven(mob/living/carbon/human/lord_body, silent = FALSE)
	if(ta_ascended_coven)
		return FALSE
	if(!istype(lord_body) || !lord_body.mind || !lord_body.covens?.len)
		return FALSE
	if(owner?.current != lord_body)
		return FALSE
	if(!ascended)
		if(!silent)
			to_chat(lord_body, span_warning("I must complete the fourth evolution before raising a coven above the others."))
		return FALSE
	if(generation < GENERATION_METHUSELAH)
		if(!silent)
			to_chat(lord_body, span_warning("Only a Methuselah may raise a coven above the others."))
		return FALSE
	return TRUE

/datum/antagonist/vampire/lord/proc/ta_offer_ascended_coven(mob/living/carbon/human/lord_body)
	if(!ta_can_choose_ascended_coven(lord_body))
		return

	var/list/choices = list()
	for(var/coven_name in lord_body.covens)
		var/datum/coven/coven = lord_body.covens[coven_name]
		if(!istype(coven) || coven.ta_ascended || !coven.ta_ascended_power_type)
			continue
		choices["[coven.name]"] = coven

	if(!length(choices))
		to_chat(lord_body, span_warning("There are no covens left to ascend."))
		return

	var/chosen = input(lord_body, "Choose one coven to ascend.", "Coven Ascension") as null|anything in choices
	var/datum/coven/selected_coven = choices[chosen]
	if(!selected_coven)
		lord_body.verbs |= /mob/living/carbon/human/proc/ta_choose_ascended_coven
		to_chat(lord_body, span_notice("The rite waits. Use Choose Ascended Coven when you are ready."))
		return

	if(selected_coven.ta_ascend(lord_body))
		ta_ascended_coven = selected_coven
		lord_body.verbs -= /mob/living/carbon/human/proc/ta_choose_ascended_coven
		to_chat(lord_body, span_boldannounce("Your [selected_coven.name] has been raised above all other covens."))

/mob/living/carbon/human/proc/ta_choose_ascended_coven()
	set name = "Choose Ascended Coven"
	set category = "Vampire"

	var/datum/antagonist/vampire/lord/lord = mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	if(!lord || lord.ta_ascended_coven)
		verbs -= /mob/living/carbon/human/proc/ta_choose_ascended_coven
		return
	lord.ta_offer_ascended_coven(src)

/mob/living/carbon/human/proc/ta_get_coven_by_type(coven_type)
	if(!length(covens))
		return null
	for(var/coven_name in covens)
		var/datum/coven/coven = covens[coven_name]
		if(istype(coven) && coven.type == coven_type)
			return coven
	return null

/mob/living/proc/ta_is_vampire()
	return mind?.has_antag_datum(/datum/antagonist/vampire)

/datum/component/ta_ascended_demonic_embrace
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/marked_victims

/datum/component/ta_ascended_demonic_embrace/Initialize()
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	marked_victims = list()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_global_mob_death))

/datum/component/ta_ascended_demonic_embrace/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	if(length(marked_victims))
		for(var/mob/living/carbon/human/victim as anything in marked_victims.Copy())
			ta_forget_victim(victim)
		marked_victims.Cut()
	marked_victims = null
	return ..()

/datum/component/ta_ascended_demonic_embrace/proc/ta_is_active_demonic_lord(mob/living/carbon/human/lord_body)
	if(!istype(lord_body) || QDELETED(lord_body))
		return FALSE
	var/datum/antagonist/vampire/lord/lord = lord_body.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	return lord && istype(lord.ta_ascended_coven, /datum/coven/demonic)

/datum/component/ta_ascended_demonic_embrace/proc/on_global_mob_death(datum/source, mob/dead_mob, gibbed)
	SIGNAL_HANDLER
	if(gibbed || !ishuman(dead_mob))
		return

	var/mob/living/carbon/human/lord_body = parent
	if(!ta_is_active_demonic_lord(lord_body))
		return

	var/mob/living/carbon/human/victim = dead_mob
	if(!victim.mind || victim.ta_is_vampire())
		return

	ta_mark_victim(victim)

/datum/component/ta_ascended_demonic_embrace/proc/ta_mark_victim(mob/living/carbon/human/victim)
	if(!istype(victim) || QDELETED(victim) || marked_victims[victim])
		return
	marked_victims[victim] = TRUE
	RegisterSignal(victim, COMSIG_LIVING_REVIVE, PROC_REF(on_marked_victim_revive))
	RegisterSignal(victim, COMSIG_QDELETING, PROC_REF(on_marked_victim_qdel))

/datum/component/ta_ascended_demonic_embrace/proc/ta_forget_victim(mob/living/carbon/human/victim)
	if(!istype(victim) || !marked_victims || !marked_victims[victim])
		return
	UnregisterSignal(victim, list(COMSIG_LIVING_REVIVE, COMSIG_QDELETING))
	marked_victims -= victim

/datum/component/ta_ascended_demonic_embrace/proc/on_marked_victim_qdel(mob/living/carbon/human/victim)
	SIGNAL_HANDLER
	ta_forget_victim(victim)

/datum/component/ta_ascended_demonic_embrace/proc/on_marked_victim_revive(mob/living/carbon/human/victim, full_heal, admin_revive)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(ta_finish_marked_victim_revive), WEAKREF(victim)), 1)

/datum/component/ta_ascended_demonic_embrace/proc/ta_finish_marked_victim_revive(datum/weakref/victim_ref)
	var/mob/living/carbon/human/victim = victim_ref?.resolve()
	if(!istype(victim))
		return
	ta_forget_victim(victim)
	if(victim.stat == DEAD || !victim.mind || victim.ta_is_vampire())
		return
	var/mob/living/carbon/human/lord_body = parent
	if(!ta_is_active_demonic_lord(lord_body))
		return
	victim.ta_begin_demonic_resurrection_embrace(lord_body)

/mob/living/carbon/human/proc/ta_begin_demonic_resurrection_embrace(mob/living/carbon/human/lord_body)
	if(ta_demonic_embrace_active || stat == DEAD || !mind || mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(!istype(lord_body))
		return FALSE
	var/datum/antagonist/vampire/lord/lord = lord_body.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	if(!lord || !istype(lord.ta_ascended_coven, /datum/coven/demonic))
		return FALSE

	ta_demonic_embrace_active = TRUE
	Paralyze(TA_DEMONIC_EMBRACE_STASIS_TIME, ignore_canstun = TRUE)
	Immobilize(TA_DEMONIC_EMBRACE_STASIS_TIME, ignore_canstun = TRUE)
	add_filter(TA_DEMONIC_EMBRACE_FILTER, 2, list("type" = "outline", "color" = TA_DEMONIC_EMBRACE_COLOR, "alpha" = 210, "size" = 2))
	visible_message(span_danger("Dark energy gathers around [src], freezing [p_them()] in place."))
	to_chat(src, span_userdanger("The resurrecting darkness floods your veins and refuses to let go."))
	addtimer(CALLBACK(src, PROC_REF(ta_finish_demonic_resurrection_embrace), WEAKREF(lord_body)), TA_DEMONIC_EMBRACE_STASIS_TIME)
	return TRUE

/mob/living/carbon/human/proc/ta_finish_demonic_resurrection_embrace(datum/weakref/lord_ref)
	remove_filter(TA_DEMONIC_EMBRACE_FILTER)
	ta_demonic_embrace_active = FALSE
	if(stat == DEAD || !mind || mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE

	var/mob/living/carbon/human/lord_body = lord_ref?.resolve()
	if(!istype(lord_body))
		return FALSE
	var/datum/antagonist/vampire/lord/lord = lord_body.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	if(!lord || !istype(lord.ta_ascended_coven, /datum/coven/demonic))
		return FALSE

	return ta_make_demonic_vampire(lord_body)

/mob/living/carbon/human/proc/ta_make_demonic_vampire(mob/living/carbon/human/lord_body)
	if(!mind || mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(!istype(lord_body))
		return FALSE
	var/datum/antagonist/vampire/lord/lord = lord_body.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	if(!lord || !istype(lord.ta_ascended_coven, /datum/coven/demonic))
		return FALSE
	remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
	mind?.remove_antag_datum(/datum/antagonist/zombie)
	if(client)
		client.verbs.Remove(GLOB.ghost_verbs)
	var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = lord_body.clan, forced_clan = TRUE, generation = max(lord.generation - 1, GENERATION_THINBLOOD))
	mind.add_antag_datum(new_antag)
	lord.register_thrall(new_antag)
	ta_demonic_sire_ref = WEAKREF(lord_body)
	verbs |= TA_DEMONIC_CONVERSION_VERB
	adjust_bloodpool(VAMP_CONVERT_BLOOD_GAIN)
	visible_message(span_red("[src] rises with the bloodline of [lord_body]'s clan burning inside."))
	to_chat(src, span_danger("The Lord's infernal blood takes root in you. Only that same blood can free you."))
	return TRUE

/mob/living/carbon/human/proc/ta_drink_ascended_lord_blood()
	set name = "Drink Lord's Blood"
	set category = "Vampire"

	if(!mind?.has_antag_datum(/datum/antagonist/vampire))
		verbs -= TA_DEMONIC_CONVERSION_VERB
		return

	var/mob/living/carbon/human/lord_body = ta_demonic_sire_ref?.resolve()
	if(!istype(lord_body) || get_dist(src, lord_body) > 1)
		to_chat(src, span_warning("The Lord whose blood cursed you must be beside you."))
		return

	var/datum/antagonist/vampire/lord/lord = lord_body.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	if(!lord || !istype(lord.ta_ascended_coven, /datum/coven/demonic))
		to_chat(src, span_warning("That blood no longer carries the infernal covenant."))
		return
	if(lord_body.bloodpool < 500)
		to_chat(src, span_warning("[lord_body] does not have enough Vitae to purge the curse."))
		return

	lord_body.adjust_bloodpool(-500)
	mind.remove_antag_datum(/datum/antagonist/vampire)
	ta_demonic_sire_ref = null
	verbs -= TA_DEMONIC_CONVERSION_VERB
	to_chat(src, span_notice("The Lord's blood burns the infernal Embrace out of you."))

/*
/datum/coven_power/bloodheal/ascended_rebirth
	name = "Dynastic Rebirth"
	desc = "Passive: each death resurrects you with the perfected powers of another vampire house. Each used house is consumed from the rebirth list."
	level = 6
	check_flags = NONE
	vitae_cost = 0
	toggled = FALSE

/datum/coven_power/bloodheal/ascended_rebirth/post_gain()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))

/datum/coven_power/bloodheal/ascended_rebirth/Destroy()
	if(owner)
		UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	return ..()

/datum/coven_power/bloodheal/ascended_rebirth/on_owner_qdel()
	SIGNAL_HANDLER
	if(owner)
		UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	return ..()

/datum/coven_power/bloodheal/ascended_rebirth/can_activate_untargeted(alert = FALSE)
	return FALSE

/datum/coven_power/bloodheal/ascended_rebirth/on_owner_death(mob/living/source, gibbed)
	SIGNAL_HANDLER
	if(gibbed)
		return
	var/datum/antagonist/vampire/lord/lord = owner?.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	if(!lord || lord.ta_ascended_coven != discipline)
		return
	addtimer(CALLBACK(src, PROC_REF(perform_rebirth)), 2 SECONDS)

/datum/coven_power/bloodheal/ascended_rebirth/proc/perform_rebirth()
	if(!owner || QDELETED(owner) || owner.stat != DEAD)
		return
	var/datum/antagonist/vampire/lord/lord = owner.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	if(!lord)
		return

	var/list/available_clans = ta_get_available_rebirth_clans(lord)
	if(!length(available_clans))
		to_chat(owner, span_userdanger("No unused vampire houses remain. The rebirth fails."))
		return

	var/chosen_clan = pick(available_clans)

	if(!owner.revive(full_heal = TRUE))
		return
	lord.ta_bloodheal_rebirth_covens -= chosen_clan
	LAZYADD(lord.ta_bloodheal_spent_rebirth_covens, chosen_clan)
	owner.remove_CC()
	owner.set_bloodpool(owner.maxbloodpool)
	ta_grant_clan_covens(chosen_clan)
	owner.visible_message(span_danger("[owner]'s corpse drinks the rite's light and rises again."), span_userdanger("Death rejects you. A stolen house blooms in your blood."))

/datum/coven_power/bloodheal/ascended_rebirth/proc/ta_get_available_rebirth_clans(datum/antagonist/vampire/lord/lord)
	if(!length(lord.ta_bloodheal_rebirth_covens))
		lord.ta_bloodheal_rebirth_covens = list()
		for(var/clan_type in subtypesof(/datum/clan))
			var/datum/clan/test_clan = new clan_type()
			if(test_clan.selectable_by_vampires && length(test_clan.clane_covens))
				lord.ta_bloodheal_rebirth_covens += clan_type
			qdel(test_clan)

	var/list/available = lord.ta_bloodheal_rebirth_covens.Copy()
	if(owner?.clan)
		available -= owner.clan.type
	if(length(lord.ta_bloodheal_spent_rebirth_covens))
		available -= lord.ta_bloodheal_spent_rebirth_covens
	return available

/datum/coven_power/bloodheal/ascended_rebirth/proc/ta_grant_clan_covens(clan_type)
	var/datum/clan/rebirth_clan = new clan_type()
	for(var/coven_type in rebirth_clan.clane_covens)
		var/needs_post_gain = FALSE
		var/datum/coven/coven = owner.ta_get_coven_by_type(coven_type)
		if(!coven)
			owner.give_coven(coven_type)
			coven = owner.ta_get_coven_by_type(coven_type)
			needs_post_gain = TRUE
		if(!coven)
			continue
		if(coven.level < coven.max_level)
			coven.set_level(coven.max_level)
			needs_post_gain = TRUE
		for(var/datum/coven_power/power as anything in coven.known_powers)
			power.set_owner(owner)
			if(needs_post_gain)
				power.post_gain()
		coven.coven_action?.build_all_button_icons(force = TRUE)
	to_chat(owner, span_boldnotice("You inherit the mastered powers of [rebirth_clan.name]."))
	qdel(rebirth_clan)
*/

/datum/coven_power/potence/ascended_omnipotence
	name = "Omnipotence"
	desc = "Prepare a divine bare-fisted strike. The strike spends Vitae only when it lands, then throws victims away, fractures bone, and scatters nearby bodies."
	level = 6
	vitae_cost = 1000
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_FREE_HAND
	toggled = TRUE
	duration_override = TRUE
	cooldown_override = TRUE
	duration_length = 0
	cooldown_length = 25 SECONDS
	hostile = TRUE
	violates_masquerade = TRUE

/datum/coven_power/potence/ascended_omnipotence/try_activate(atom/target)
	if(can_activate(target, TRUE))
		activate(target)
		return TRUE
	return FALSE

/datum/coven_power/potence/ascended_omnipotence/activate(atom/target)
	..()
	RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_unarmed_attack))

/datum/coven_power/potence/ascended_omnipotence/deactivate(atom/target, direct)
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	return ..()

/datum/coven_power/potence/ascended_omnipotence/do_caster_notification(target)
	to_chat(owner, span_userdanger("Я подготовил божественный удар."))

/datum/coven_power/potence/ascended_omnipotence/proc/on_unarmed_attack(mob/living/carbon/human/source, mob/living/carbon/human/attacker, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	SIGNAL_HANDLER
	if(!active || attacker != owner || !istype(target) || target == owner)
		return
	if(!istype(owner.used_intent, INTENT_HARM))
		return
	if(!spend_resources())
		to_chat(owner, span_warning("Мне не хватает [vitae_cost] витэ, чтобы выпустить божественный удар."))
		ta_cancel_prepared_strike(show_message = FALSE)
		return
	INVOKE_ASYNC(src, PROC_REF(ta_omnipotence_impact), target)
	ta_finish_prepared_strike()

/datum/coven_power/potence/ascended_omnipotence/proc/ta_cancel_prepared_strike(show_message = TRUE)
	if(!active)
		return
	if(show_message)
		to_chat(owner, span_notice("Я больше не готов использовать божественный удар."))
	deactivate(null, TRUE)
	discipline?.ta_ascended_action?.build_all_button_icons(force = TRUE)

/datum/coven_power/potence/ascended_omnipotence/proc/ta_finish_prepared_strike()
	deactivate(null, TRUE)
	deltimer(cooldown_timer)
	do_cooldown()
	owner?.update_action_buttons()
	discipline?.ta_ascended_action?.build_all_button_icons(force = TRUE)

/datum/coven_power/potence/ascended_omnipotence/proc/ta_omnipotence_impact(mob/living/carbon/human/primary_target)
	if(!owner || !istype(primary_target) || QDELETED(primary_target) || primary_target.stat == DEAD)
		return
	var/zone = ta_pick_omnipotence_zone()
	var/list/armor_integrity = ta_capture_omnipotence_armor(primary_target, zone)
	primary_target.run_armor_check(zone, "blunt", damage = TA_OMNIPOTENCE_DAMAGE, blade_dulling = BCLASS_BLUNT, intdamfactor = BLUNT_DEFAULT_INT_DAMAGEFACTOR)
	primary_target.apply_damage(TA_OMNIPOTENCE_DAMAGE, BRUTE, zone, forced = TRUE)
	ta_finish_omnipotence_armor_damage(armor_integrity)
	ta_break_omnipotence_armor(primary_target, zone)
	var/obj/item/bodypart/limb = primary_target.get_bodypart(zone)
	var/fracture_type = ta_get_omnipotence_fracture(zone)
	limb?.add_wound(fracture_type, crit_message = TRUE)
	primary_target.Knockdown(4 SECONDS)
	primary_target.visible_message(span_danger("[owner]'s fist sends [primary_target] flying with a bone-splitting crack!"))
	playsound(get_turf(primary_target), pick('sound/combat/hits/blunt/genblunt (1).ogg', 'sound/combat/hits/blunt/genblunt (2).ogg', 'sound/combat/hits/blunt/genblunt (3).ogg'), 80, TRUE)

	ta_launch_omnipotence_target(primary_target)

/datum/coven_power/potence/ascended_omnipotence/proc/ta_pick_omnipotence_zone()
	return pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

/datum/coven_power/potence/ascended_omnipotence/proc/ta_get_omnipotence_fracture(zone)
	switch(check_zone(zone))
		if(BODY_ZONE_HEAD)
			return /datum/wound/fracture/head
		if(BODY_ZONE_CHEST)
			return /datum/wound/fracture/chest
	return /datum/wound/fracture

/datum/coven_power/potence/ascended_omnipotence/proc/ta_apply_omnipotence_push_damage(mob/living/target, force_break_armor = FALSE)
	if(!target || QDELETED(target) || target.stat == DEAD)
		return
	var/zone = ta_pick_omnipotence_zone()
	var/list/armor_integrity = ta_capture_omnipotence_armor(target, zone)
	var/armor_block = target.run_armor_check(zone, "blunt", damage = TA_OMNIPOTENCE_DAMAGE, blade_dulling = BCLASS_BLUNT, intdamfactor = BLUNT_DEFAULT_INT_DAMAGEFACTOR)
	var/damage_dealt = target.apply_damage(TA_OMNIPOTENCE_DAMAGE, BRUTE, zone, armor_block)
	ta_finish_omnipotence_armor_damage(armor_integrity)
	if(force_break_armor)
		ta_break_omnipotence_armor(target, zone)
	if(!damage_dealt)
		return
	var/wound_damage = max(TA_OMNIPOTENCE_DAMAGE - armor_block, 0)
	if(!wound_damage)
		return
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/affecting = carbon_target.get_bodypart(check_zone(zone))
		affecting?.bodypart_attacked_by(BCLASS_BLUNT, wound_damage, owner, zone, crit_message = TRUE, armor = armor_block)
	else
		target.simple_woundcritroll(BCLASS_BLUNT, wound_damage, owner, zone, crit_message = TRUE)

/datum/coven_power/potence/ascended_omnipotence/proc/ta_capture_omnipotence_armor(mob/living/target, zone)
	if(!ishuman(target))
		return null
	var/mob/living/carbon/human/human_target = target
	var/list/layers = human_target.get_best_worn_armor_layered(zone, "blunt")
	if(!length(layers))
		return null
	var/list/armor_integrity = list()
	for(var/obj/item/clothing/armor_piece as anything in layers)
		if(!armor_piece.max_integrity || armor_piece.obj_integrity <= 0)
			continue
		armor_integrity[armor_piece] = armor_piece.obj_integrity
	layers.Cut()
	return armor_integrity

/datum/coven_power/potence/ascended_omnipotence/proc/ta_finish_omnipotence_armor_damage(list/armor_integrity)
	if(!length(armor_integrity))
		return
	for(var/obj/item/clothing/armor_piece as anything in armor_integrity)
		if(QDELETED(armor_piece) || !armor_piece.max_integrity)
			continue
		var/old_integrity = armor_integrity[armor_piece]
		var/integrity_lost = max(old_integrity - armor_piece.obj_integrity, 0)
		if(integrity_lost >= TA_OMNIPOTENCE_MIN_ARMOR_DAMAGE || armor_piece.obj_integrity <= 0)
			continue
		armor_piece.take_damage(TA_OMNIPOTENCE_MIN_ARMOR_DAMAGE - integrity_lost, BRUTE, "blunt", sound_effect = FALSE, armor_penetration = 100)

/datum/coven_power/potence/ascended_omnipotence/proc/ta_break_omnipotence_armor(mob/living/target, zone)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/human_target = target
	var/list/layers = human_target.get_best_worn_armor_layered(zone, "blunt")
	if(!length(layers))
		return
	for(var/obj/item/clothing/armor_piece as anything in layers)
		if(QDELETED(armor_piece) || !armor_piece.max_integrity || armor_piece.obj_integrity <= 0)
			continue
		armor_piece.take_damage(max(armor_piece.obj_integrity, armor_piece.max_integrity), BRUTE, "blunt", sound_effect = FALSE, armor_penetration = 100)
	layers.Cut()

/datum/coven_power/potence/ascended_omnipotence/proc/ta_launch_omnipotence_target(mob/living/carbon/human/primary_target)
	if(!owner || !istype(primary_target) || QDELETED(primary_target))
		return
	var/turf/current_turf = get_turf(primary_target)
	var/launch_dir = get_dir(get_turf(owner), current_turf)
	if(!launch_dir)
		launch_dir = owner.dir
	if(!current_turf || !launch_dir)
		return

	var/list/launch_path = list()
	ta_leave_omnipotence_blood(primary_target, current_turf)
	for(var/i in 1 to TA_OMNIPOTENCE_LAUNCH_DISTANCE)
		var/turf/next_turf = get_step(current_turf, launch_dir)
		if(!ta_can_omnipotence_launch_into(primary_target, next_turf))
			break
		launch_path += next_turf
		current_turf = next_turf

	var/list/scattered_targets = list()
	for(var/turf/path_turf as anything in launch_path)
		ta_scatter_omnipotence_path(path_turf, launch_dir, primary_target, scattered_targets)
		ta_leave_omnipotence_blood(primary_target, path_turf)

	if(!length(launch_path))
		return
	var/turf/final_turf = launch_path[length(launch_path)]
	ta_apply_omnipotence_flight_overlay(primary_target)
	primary_target.safe_throw_at(final_turf, length(launch_path), 1, owner, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/coven_power/potence/ascended_omnipotence/proc/ta_can_omnipotence_launch_into(mob/living/launched, turf/target_turf)
	if(!istype(target_turf) || !isopenturf(target_turf))
		return FALSE
	if(!target_turf.CanPass(launched, target_turf))
		return FALSE
	for(var/atom/movable/thing as anything in target_turf)
		if(thing == launched || thing == launched.loc)
			continue
		if(isliving(thing))
			continue
		if(!thing.Cross(launched))
			return FALSE
	return TRUE

/datum/coven_power/potence/ascended_omnipotence/proc/ta_scatter_omnipotence_path(turf/path_turf, launch_dir, mob/living/primary_target, list/scattered_targets)
	if(!path_turf || !launch_dir)
		return
	for(var/mob/living/pushed in path_turf)
		if(pushed == owner || pushed == primary_target || pushed.stat == DEAD)
			continue
		var/pushed_ref = REF(pushed)
		if(scattered_targets[pushed_ref])
			continue
		scattered_targets[pushed_ref] = TRUE
		ta_apply_omnipotence_push_damage(pushed, force_break_armor = TRUE)
		var/turf/throw_target = get_ranged_target_turf(pushed, launch_dir, TA_OMNIPOTENCE_COLLISION_PUSH_DISTANCE)
		pushed.safe_throw_at(throw_target, TA_OMNIPOTENCE_COLLISION_PUSH_DISTANCE, 1, owner, force = MOVE_FORCE_EXTREMELY_STRONG)
		pushed.Knockdown(2 SECONDS)

/datum/coven_power/potence/ascended_omnipotence/proc/ta_leave_omnipotence_blood(mob/living/target, turf/blood_turf)
	if(!target || QDELETED(target) || !blood_turf || !target.get_blood_id() || !target.get_bleed_rate())
		return
	if(istype(blood_turf, /turf/open/water))
		target.add_drip_floor(blood_turf, TA_OMNIPOTENCE_BLOOD_TRAIL_AMOUNT)
		return
	var/obj/effect/decal/cleanable/blood/puddle/puddle = locate() in blood_turf
	if(puddle)
		puddle.blood_vol += TA_OMNIPOTENCE_BLOOD_TRAIL_AMOUNT
	else
		puddle = new(blood_turf)
	puddle.add_blood_DNA(target.return_blood_DNA())
	puddle.update_icon()

/datum/coven_power/potence/ascended_omnipotence/proc/ta_apply_omnipotence_flight_overlay(mob/living/target)
	if(!target || QDELETED(target))
		return
	var/datum/component/after_image/flight_after_image
	if(!target.GetComponent(/datum/component/after_image))
		flight_after_image = target.AddComponent(/datum/component/after_image)
	if(!target.get_filter(TA_OMNIPOTENCE_FLIGHT_FILTER))
		target.add_filter(TA_OMNIPOTENCE_FLIGHT_FILTER, 2, list("type" = "outline", "color" = TA_OMNIPOTENCE_FLIGHT_COLOR, "alpha" = 25, "size" = 1))
	addtimer(CALLBACK(src, PROC_REF(ta_clear_omnipotence_flight_overlay), WEAKREF(target), flight_after_image), TA_OMNIPOTENCE_FLIGHT_OVERLAY_TIME, TIMER_STOPPABLE)

/datum/coven_power/potence/ascended_omnipotence/proc/ta_clear_omnipotence_flight_overlay(datum/weakref/target_ref, datum/component/after_image/flight_after_image)
	var/mob/living/target = target_ref?.resolve()
	if(target && !QDELETED(target))
		target.remove_filter(TA_OMNIPOTENCE_FLIGHT_FILTER)
	if(flight_after_image && !QDELETED(flight_after_image))
		qdel(flight_after_image)

/datum/coven_power/celerity/ascended_afterpass
	name = "Redline Passage"
	desc = "Move through bodies while active. Each living creature you phase through is struck by the passing blur. Drains 400 Vitae each second."
	level = 6
	vitae_cost = 400
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_override = TRUE
	cooldown_length = 45 SECONDS
	multiplicative_slowdown = -0.45
	hostile = TRUE
	violates_masquerade = TRUE
	var/old_pass_flags
	var/list/phased_hits = list()

/datum/coven_power/celerity/ascended_afterpass/activate(atom/target)
	. = ..()
	if(!.)
		return
	old_pass_flags = owner.pass_flags & PASSMOB
	owner.pass_flags |= PASSMOB
	phased_hits = list()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_moved))
	owner.ta_afterpass_power = src
	ta_start_ascended_vitae_drain(target)

/datum/coven_power/celerity/ascended_afterpass/deactivate(atom/target, direct)
	ta_stop_ascended_vitae_drain()
	if(owner)
		if(old_pass_flags)
			owner.pass_flags |= PASSMOB
		else
			owner.pass_flags &= ~PASSMOB
		if(owner.ta_afterpass_power == src)
			owner.ta_afterpass_power = null
		UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	phased_hits = list()
	return ..()

/datum/coven_power/celerity/ascended_afterpass/Destroy()
	ta_stop_ascended_vitae_drain()
	if(owner?.ta_afterpass_power == src)
		owner.ta_afterpass_power = null
	return ..()

/datum/coven_power/celerity/ascended_afterpass/proc/on_owner_moved(atom/movable/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER
	if(!active || !owner)
		return
	for(var/mob/living/victim in get_turf(owner))
		INVOKE_ASYNC(src, PROC_REF(ta_afterpass_attack), victim)

/datum/coven_power/celerity/ascended_afterpass/proc/ta_afterpass_attack(mob/living/victim)
	if(!active || !owner || !istype(victim) || QDELETED(victim) || victim == owner || victim.stat == DEAD)
		return FALSE
	if(phased_hits[REF(victim)] && phased_hits[REF(victim)] > world.time)
		return FALSE
	if(!owner.used_intent)
		return FALSE

	phased_hits[REF(victim)] = world.time + 2 SECONDS
	owner.face_atom(victim)
	var/obj/item/active_weapon = owner.get_active_held_item()
	var/old_used_hand = owner.used_hand
	owner.used_hand = owner.active_hand_index
	owner.resolveAdjacentClick(victim, active_weapon, null)
	owner.used_hand = old_used_hand
	victim.visible_message(span_danger("[owner] passes through [victim] in a red blur."))
	return TRUE

/datum/coven_power/celerity/ascended_afterpass/proc/ta_try_afterpass_bump(atom/bumped)
	if(!active || !owner || !isliving(bumped))
		return FALSE
	var/mob/living/victim = bumped
	if(victim == owner || victim.stat == DEAD)
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(ta_afterpass_attack), victim)

	var/turf/owner_turf = get_turf(owner)
	var/turf/victim_turf = get_turf(victim)
	var/pass_dir = get_dir(owner_turf, victim_turf)
	if(!pass_dir)
		return TRUE

	var/turf/pass_turf = get_step(victim_turf, pass_dir)
	if(ta_can_afterpass_into(pass_turf))
		owner.forceMove(pass_turf)
	else if(ta_can_afterpass_into(victim_turf))
		owner.forceMove(victim_turf)
	return TRUE

/datum/coven_power/celerity/ascended_afterpass/proc/ta_can_afterpass_into(turf/target_turf)
	if(!istype(target_turf) || !isopenturf(target_turf))
		return FALSE
	if(!target_turf.CanPass(owner, target_turf))
		return FALSE
	for(var/atom/movable/thing as anything in target_turf)
		if(thing == owner || thing == owner.loc)
			continue
		if(!thing.Cross(owner))
			return FALSE
	return TRUE

/mob/living/carbon/human/Bump(atom/A)
	if(ta_afterpass_power?.ta_try_afterpass_bump(A))
		return
	return ..()

/datum/coven_power/demonic/ascended_embrace
	name = "Infernal Embrace"
	desc = "Passive: dead humans who return to life are seized by dark stasis and rise in the ascended Lord's clan. Drinking the Lord's blood can cure this Embrace."
	level = 6
	check_flags = NONE
	vitae_cost = 0

/datum/coven_power/demonic/ascended_embrace/post_gain()
	. = ..()
	owner?.AddComponent(/datum/component/ta_ascended_demonic_embrace)

/datum/coven_power/demonic/ascended_embrace/Destroy()
	if(owner)
		qdel(owner.GetComponent(/datum/component/ta_ascended_demonic_embrace))
	return ..()

/datum/coven_power/demonic/ascended_embrace/on_owner_qdel()
	if(owner)
		qdel(owner.GetComponent(/datum/component/ta_ascended_demonic_embrace))
	return ..()

/datum/coven_power/demonic/ascended_embrace/can_activate_untargeted(alert = FALSE)
	. = ..()
	return FALSE

/*
/datum/coven_power/fae_trickery/ascended_portal
	name = "Unseelie Gate"
	desc = "Open a fixed fae portal that spills fae creatures into the world."
	level = 6
	vitae_cost = 250
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 6
	cooldown_length = 2 MINUTES
	hostile = TRUE
	violates_masquerade = TRUE

/datum/coven_power/fae_trickery/ascended_portal/activate(turf/target)
	. = ..()
	if(!target)
		return
	new /obj/structure/vampire/portal/ta_fae(target, owner)

/obj/structure/vampire/portal/ta_fae
	name = "Unseelie Gate"
	desc = "A stable wound into a hostile fae hollow."
	icon_state = "portal"
	density = FALSE
	var/datum/weakref/lord_ref
	var/spawn_count = 0
	var/max_spawns = 8

/obj/structure/vampire/portal/ta_fae/Initialize(mapload, mob/living/carbon/human/lord_body)
	. = ..()
	lord_ref = WEAKREF(lord_body)
	set_light(4, 2, 3, l_color = LIGHT_COLOR_LAVENDER)
	addtimer(CALLBACK(src, PROC_REF(spawn_fae)), 5 SECONDS)

/obj/structure/vampire/portal/ta_fae/Crossed(atom/movable/AM)
	return

/obj/structure/vampire/portal/ta_fae/delete()
	if(spawn_count < max_spawns)
		addtimer(CALLBACK(src, PROC_REF(delete)), 12 SECONDS)
		return
	return ..()

/obj/structure/vampire/portal/ta_fae/proc/spawn_fae()
	if(QDELETED(src) || spawn_count >= max_spawns)
		return
	var/static/list/fae_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad,
	)
	var/fae_type = pick(fae_types)
	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/fae = new fae_type(get_turf(src))
	var/mob/living/carbon/human/lord_body = lord_ref?.resolve()
	if(istype(lord_body))
		fae.faction |= lord_body.faction
	spawn_count++
	visible_message(span_warning("[src] spits out [fae]."))
	addtimer(CALLBACK(src, PROC_REF(spawn_fae)), 12 SECONDS)
*/

/*
/datum/coven_power/siren/ascended_chorus
	name = "Drowning Chorus"
	desc = "Transfix every non-vampire in a wide area. The cooldown is long."
	level = 6
	vitae_cost = 260
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	cooldown_length = 3 MINUTES
	hostile = TRUE
	violates_masquerade = TRUE

/datum/coven_power/siren/ascended_chorus/activate(atom/target)
	. = ..()
	for(var/mob/living/listener in viewers(6, owner))
		if(listener == owner || listener.stat == DEAD || listener.ta_is_vampire())
			continue
		listener.Stun(5 SECONDS)
		listener.Immobilize(5 SECONDS)
		listener.Knockdown(3 SECONDS)
		to_chat(listener, span_userdanger("The Lord's voice pins your soul in place."))
	owner.visible_message(span_danger("[owner]'s voice expands into a paralyzing chorus."))
*/

/datum/coven_power/obfuscate/ascended_vanish
	name = "Perfect Obfuscation"
	desc = "Remain invisible while active even during combat. Drains 200 Vitae each second."
	level = 6
	vitae_cost = 200
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_override = TRUE
	cooldown_length = 20 SECONDS
	cancelable = TRUE
	var/old_alpha

/datum/coven_power/obfuscate/ascended_vanish/activate(atom/target)
	. = ..()
	if(!.)
		return
	old_alpha = owner.alpha
	ta_refresh_perfect_obfuscation()
	ta_start_ascended_vitae_drain(target)
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, TA_ASCENDED_COVEN_TRAIT)
	to_chat(owner, span_notice("You fall completely outside of mortal attention."))

/datum/coven_power/obfuscate/ascended_vanish/deactivate(atom/target, direct)
	ta_stop_ascended_vitae_drain()
	if(owner)
		owner.mob_timers[MT_INVISIBILITY] = 0
		owner.alpha = isnull(old_alpha) ? 255 : old_alpha
		REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, TA_ASCENDED_COVEN_TRAIT)
	return ..()

/datum/coven_power/obfuscate/ascended_vanish/Destroy()
	ta_stop_ascended_vitae_drain()
	return ..()

/datum/coven_power/obfuscate/ascended_vanish/on_refresh(atom/target)
	ta_refresh_perfect_obfuscation()

/datum/coven_power/obfuscate/ascended_vanish/proc/ta_refresh_perfect_obfuscation()
	if(!owner)
		return
	owner.mob_timers[MT_INVISIBILITY] = world.time + 2 SECONDS
	owner.alpha = 0

/*
/datum/coven_power/auspex/ascended_watch
	name = "All-Angle Vigil"
	desc = "Passive: gain full-circle vision and supernatural dodging."
	level = 6
	check_flags = NONE
	vitae_cost = 0

/datum/coven_power/auspex/ascended_watch/post_gain()
	. = ..()
	ta_apply_watch()

/datum/coven_power/auspex/ascended_watch/Destroy()
	ta_remove_watch()
	return ..()

/datum/coven_power/auspex/ascended_watch/on_owner_qdel()
	SIGNAL_HANDLER
	ta_remove_watch()
	return ..()

/datum/coven_power/auspex/ascended_watch/can_activate_untargeted(alert = FALSE)
	return FALSE

/datum/coven_power/auspex/ascended_watch/proc/ta_apply_watch()
	if(!owner)
		return
	owner.ta_auspex_full_vision = TRUE
	owner.viewcone_override = TRUE
	owner.hide_cone()
	owner.update_fov_angles()
	ADD_TRAIT(owner, TRAIT_DODGEEXPERT, TA_ASCENDED_COVEN_TRAIT)
	ADD_TRAIT(owner, TRAIT_DODGE_NO_MOVE, TA_ASCENDED_COVEN_TRAIT)

/datum/coven_power/auspex/ascended_watch/proc/ta_remove_watch()
	if(!owner)
		return
	owner.ta_auspex_full_vision = FALSE
	owner.viewcone_override = FALSE
	owner.update_fov_angles()
	REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, TA_ASCENDED_COVEN_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_DODGE_NO_MOVE, TA_ASCENDED_COVEN_TRAIT)

/mob/update_fov_angles()
	. = ..()
	if(ishuman(src))
		var/mob/living/carbon/human/human = src
		if(human.ta_auspex_full_vision)
			fovangle = 0
			hud_used?.fov?.alpha = 0
			hud_used?.fov_blocker?.alpha = 0
*/

/datum/coven_power/eora/ascended_serenity
	name = "Serenity of the Beloved"
	desc = "Pacify everyone who can see you."
	level = 6
	vitae_cost = 160
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SEE
	toggled = TRUE
	duration_length = 10 SECONDS
	cooldown_length = 50 SECONDS

/datum/coven_power/eora/ascended_serenity/activate(atom/target)
	. = ..()
	ta_pacify_viewers()
	owner.visible_message(span_love("[owner]'s presence softens the will to harm."))

/datum/coven_power/eora/ascended_serenity/on_refresh(atom/target)
	ta_pacify_viewers()

/datum/coven_power/eora/ascended_serenity/proc/ta_pacify_viewers()
	for(var/mob/living/viewer in viewers(7, owner))
		if(viewer == owner || viewer.stat == DEAD)
			continue
		if(!is_A_facing_B(viewer, owner))
			continue
		viewer.apply_status_effect(/datum/status_effect/pacify, 8 SECONDS)
		to_chat(viewer, span_love("Peace settles over you while you behold [owner]."))

/datum/coven_power/quietus/ascended_poison_cloud
	name = "Basilisk Breath"
	desc = "Spit a poison cloud that exhausts non-vampires."
	level = 6
	vitae_cost = 750
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 6
	cooldown_length = 60 SECONDS
	hostile = TRUE
	violates_masquerade = TRUE

/datum/coven_power/quietus/ascended_poison_cloud/activate(turf/target)
	. = ..()
	if(!target)
		return
	for(var/turf/opened in range(TA_ASCENDED_POISON_CLOUD_RADIUS, target))
		new /obj/effect/ta_ascended_poison_cloud(opened, owner)
	owner.visible_message(span_danger("[owner] spits a rolling cloud of dead green poison."))

/obj/effect/ta_ascended_poison_cloud
	name = "poison cloud"
	desc = "A heavy cloud of cursed poison."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 165
	color = "#5b8f2a"
	var/datum/weakref/lord_ref
	var/pulses_left = 5

/obj/effect/ta_ascended_poison_cloud/Initialize(mapload, mob/living/carbon/human/lord_body)
	. = ..()
	lord_ref = WEAKREF(lord_body)
	set_light(2, 1, 1, l_color = "#5b8f2a")
	addtimer(CALLBACK(src, PROC_REF(pulse)), 1 SECONDS)

/obj/effect/ta_ascended_poison_cloud/proc/pulse()
	if(QDELETED(src) || pulses_left <= 0)
		qdel(src)
		return
	pulses_left--
	for(var/mob/living/victim in range(0, src))
		if(victim.ta_is_vampire())
			continue
		victim.stamina_add(TA_ASCENDED_POISON_STAMINA_DRAIN)
		victim.apply_damage(TA_ASCENDED_POISON_TOX_DAMAGE, TOX, forced = TRUE)
		to_chat(victim, span_warning("The poison sinks into your lungs and steals your strength."))
	addtimer(CALLBACK(src, PROC_REF(pulse)), 2 SECONDS)

#undef TA_ASCENDED_COVEN_FILTER
#undef TA_ASCENDED_COVEN_TRAIT
#undef TA_ASCENDED_COVEN_LIGHT
#undef TA_DEMONIC_CONVERSION_VERB
#undef TA_DEMONIC_EMBRACE_STASIS_TIME
#undef TA_DEMONIC_EMBRACE_FILTER
#undef TA_DEMONIC_EMBRACE_COLOR
#undef TA_OMNIPOTENCE_DAMAGE
#undef TA_OMNIPOTENCE_MIN_ARMOR_DAMAGE
#undef TA_OMNIPOTENCE_LAUNCH_DISTANCE
#undef TA_OMNIPOTENCE_COLLISION_PUSH_DISTANCE
#undef TA_OMNIPOTENCE_BLOOD_TRAIL_AMOUNT
#undef TA_OMNIPOTENCE_FLIGHT_FILTER
#undef TA_OMNIPOTENCE_FLIGHT_COLOR
#undef TA_OMNIPOTENCE_FLIGHT_OVERLAY_TIME
#undef TA_ASCENDED_POISON_CLOUD_RADIUS
#undef TA_ASCENDED_POISON_STAMINA_DRAIN
#undef TA_ASCENDED_POISON_TOX_DAMAGE
