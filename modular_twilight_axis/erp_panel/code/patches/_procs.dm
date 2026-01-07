/mob/living/proc/start_sex_session_tgui(mob/living/target_mob)
	if(!target_mob)
		return

	if(!ishuman(src) || !ishuman(target_mob))
		return

	var/mob/living/carbon/human/Hsrc = src
	var/mob/living/carbon/human/Htgt = target_mob

	if(Hsrc.is_erp_blocked_as_target())
		return

	if(Htgt.is_erp_blocked_as_target())
		return

	var/datum/sex_session_tgui/session_object = get_any_sex_session_tgui_for(Hsrc)

	if(!session_object)
		session_object = new /datum/sex_session_tgui(Hsrc, Htgt)
		LAZYADD(GLOB.sex_sessions, session_object)
	else
		session_object.add_partner(Htgt)
		session_object.target = Htgt
		session_object.current_partner_ref = REF(Htgt)
		session_object.partner_bodypart_override = null

	session_object.ui_interact(Hsrc)
	return session_object

/proc/get_any_sex_session_tgui_for(mob/living/carbon/human/user)
	if(!user)
		return null

	for(var/datum/sex_session_tgui/session_object in GLOB.sex_sessions)
		if(QDELETED(session_object))
			continue
		if(session_object.user == user)
			return session_object

	return null

/proc/return_sessions_with_user_tgui(mob/living/carbon/human/user)
	var/list/sessions = list()
	for (var/datum/datum_candidate in GLOB.sex_sessions)
		if (istype(datum_candidate, /datum/sex_session_tgui))
			var/datum/sex_session_tgui/session_object = datum_candidate
			if (user == session_object.user || user == session_object.target)
				sessions |= session_object
	return sessions

/proc/create_dullahan_head_partner(obj/item/bodypart/head/dullahan/head_dullahan)
	if(!head_dullahan)
		return null

	for(var/mob/living/carbon/human/erp_proxy/proxy_object in world)
		if(proxy_object.source_part == head_dullahan)
			return proxy_object

	var/mob/living/carbon/human/erp_proxy/new_proxy = new()
	new_proxy.source_part = head_dullahan

	var/name = head_dullahan.original_owner?.real_name
	if(!name)
		name = head_dullahan.original_owner?.name
	if(!name)
		name = head_dullahan.name

	new_proxy.name = "[name]"

	return new_proxy


/proc/sex_organ_to_zone(organ_type)
	switch(organ_type)
		if(SEX_ORGAN_PENIS, SEX_ORGAN_VAGINA, SEX_ORGAN_ANUS)
			return BODY_ZONE_PRECISE_GROIN
		if(SEX_ORGAN_BREASTS)
			return BODY_ZONE_CHEST
		if(SEX_ORGAN_MOUTH)
			return BODY_ZONE_PRECISE_MOUTH
	return null

/proc/can_access_erp_zone(mob/living/carbon/human/user, mob/living/carbon/human/target,	zone, require_grab = FALSE,	min_grab_state = GRAB_PASSIVE)
	if(!target || !zone)
		return FALSE

	var/has_zone_grab = FALSE
	var/grabstate = 0

	if(user)
		for(var/obj/item/grabbing/grab_object in target.grabbedby)
			if(grab_object.sublimb_grabbed == zone)
				has_zone_grab = TRUE
				break

		grabstate = user.get_highest_grab_state_on(target) || 0

	var/has_enough_grab = (grabstate >= min_grab_state)

	if(require_grab && !(has_zone_grab && has_enough_grab))
		return FALSE

	if(has_zone_grab && has_enough_grab)
		return TRUE

	if(!get_location_accessible(target, zone, skipundies = TRUE))
		return FALSE

	return TRUE

/proc/get_penis_organ_type_for_style(style)
	switch(style)
		if("Plain")
			return /obj/item/organ/penis
		if("Knotted")
			return /obj/item/organ/penis/knotted
		if("Flared")
			return /obj/item/organ/penis/equine
		if("Knotted 2")
			return /obj/item/organ/penis/tapered_mammal
		if("Tapered")
			return /obj/item/organ/penis/tapered
		if("Hemi")
			return /obj/item/organ/penis/tapered_double
		if("Knotted Hemi")
			return /obj/item/organ/penis/tapered_double_knotted
		if("Barbed")
			return /obj/item/organ/penis/barbed
		if("Barbed, Knotted")
			return /obj/item/organ/penis/barbed_knotted
		if("Tentacled")
			return /obj/item/organ/penis/tentacle

	return /obj/item/organ/penis

/proc/erp_filter_to_body_zone(organ_id)
	if(!organ_id)
		return BODY_ZONE_CHEST

	switch(organ_id)
		if(SEX_ORGAN_FILTER_MOUTH)
			return BODY_ZONE_HEAD

		if(SEX_ORGAN_FILTER_LHAND)
			return BODY_ZONE_L_ARM

		if(SEX_ORGAN_FILTER_RHAND)
			return BODY_ZONE_R_ARM

		if(SEX_ORGAN_FILTER_LEGS)
			return BODY_ZONE_R_LEG

		if(SEX_ORGAN_FILTER_TAIL)
			return BODY_ZONE_CHEST

		if(SEX_ORGAN_FILTER_BREASTS)
			return BODY_ZONE_CHEST

		if(SEX_ORGAN_FILTER_VAGINA, SEX_ORGAN_FILTER_PENIS, SEX_ORGAN_FILTER_ANUS)
			return BODY_ZONE_CHEST

	return BODY_ZONE_CHEST

/proc/erp_body_zone_to_organs(zone)
	var/list/types = list()
	switch(zone)
		if(BODY_ZONE_PRECISE_GROIN, BODY_ZONE_CHEST)
			types += SEX_ORGAN_VAGINA
			types += SEX_ORGAN_ANUS
		if(BODY_ZONE_PRECISE_MOUTH)
			types += SEX_ORGAN_MOUTH
	return types

/proc/collect_passive_links_for(mob/living/carbon/human/H)
	if(!H)
		return list()

	var/list/passive_links = list()
	for(var/datum/sex_session_tgui/session in GLOB.sex_sessions)
		if(!session || QDELETED(session))
			continue

		if(session.user == H)
			continue

		if(!(H in session.partners))
			continue

		for(var/id in session.current_actions)
			var/datum/sex_action_session/I = session.current_actions[id]
			if(!I || QDELETED(I))
				continue
			if(I.partner != H)
				continue

			var/datum/sex_organ/tuned_org = session.resolve_organ_datum(I.partner, I.partner_node_id)
			var/sens = tuned_org ? tuned_org.sensivity : 0
			var/pain = tuned_org ? tuned_org.pain : 0

			passive_links += list(list(
				"id"                = I.instance_id,
				"actor_organ_id"    = I.actor_node_id,
				"partner_organ_id"  = I.partner_node_id,
				"action_type"       = I.action_type,
				"action_name"       = I.action?.name,
				"speed"             = I.speed,
				"force"             = I.force,
				"do_until_finished" = session.do_until_finished,
				"sensitivity"       = sens,
				"pain"              = pain,
			))

	return passive_links

/proc/register_custom_sex_action(datum/sex_panel_action/A)
	if(!A || !A.ckey)
		return null

	if(!isnum(GLOB.sex_custom_action_seq))
		GLOB.sex_custom_action_seq = 0

	GLOB.sex_custom_action_seq++

	var/id = "custom:[A.ckey]:[GLOB.sex_custom_action_seq]"
	A.custom_key = id

	if(!islist(GLOB.sex_panel_actions))
		GLOB.sex_panel_actions = list()

	GLOB.sex_panel_actions[id] = A
	return id

/proc/unregister_custom_sex_action(datum/sex_panel_action/A)
	if(!A)
		return
	if(A.custom_key && GLOB.sex_panel_actions)
		GLOB.sex_panel_actions -= A.custom_key
	A.custom_key = null

/proc/get_custom_actions_for_ckey(ckey)
	var/list/out = list()
	if(!ckey || !islist(GLOB.sex_panel_actions))
		return out

	for(var/key in GLOB.sex_panel_actions)
		var/datum/sex_panel_action/A = GLOB.sex_panel_actions[key]
		if(!A)
			continue
		if(A.ckey != ckey)
			continue
		out += A

	return out

/proc/organ_type_to_filter_id(org_type)
	if(!org_type)
		return ORG_KEY_NONE

	switch(org_type)
		if(SEX_ORGAN_MOUTH)
			return SEX_ORGAN_FILTER_MOUTH
		if(SEX_ORGAN_HANDS)
			return SEX_ORGAN_FILTER_LHAND
		if(SEX_ORGAN_LEGS)
			return SEX_ORGAN_FILTER_LEGS
		if(SEX_ORGAN_TAIL)
			return SEX_ORGAN_FILTER_TAIL
		if(SEX_ORGAN_BREASTS)
			return SEX_ORGAN_FILTER_BREASTS
		if(SEX_ORGAN_VAGINA)
			return SEX_ORGAN_FILTER_VAGINA
		if(SEX_ORGAN_PENIS)
			return SEX_ORGAN_FILTER_PENIS
		if(SEX_ORGAN_ANUS)
			return SEX_ORGAN_FILTER_ANUS

	return ORG_KEY_NONE
	
/proc/is_maso(mob/living/carbon/human/M)
	if(!M)
		return FALSE

	return M.has_flaw(/datum/charflaw/addiction/masochist)

/proc/is_nympho(mob/living/carbon/human/M)
	if(!M)
		return FALSE

	return M.has_flaw(/datum/charflaw/addiction/lovefiend)

/datum/controller/subsystem/gamemode/refresh_alive_stats(roundstart = FALSE)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return

	GLOB.patron_follower_counts.Cut()

	var/list/statistics_to_clear = list(
		STATS_TOTAL_POPULATION,
        STATS_PSYCROSS_USERS,
        STATS_ALIVE_NOBLES,
        STATS_ALIVE_GARRISON,
        STATS_ALIVE_CLERGY,
        STATS_ALIVE_TRADESMEN,
        STATS_WEREVOLVES,
        STATS_BANDITS,
        STATS_VAMPIRES,
        STATS_DEADITES_ALIVE,
        STATS_CLINGY_PEOPLE,
        STATS_ALCOHOLICS,
        STATS_JUNKIES,
		STATS_KLEPTOMANIACS,
        STATS_GREEDY_PEOPLE,
        STATS_MALE_POPULATION,
        STATS_FEMALE_POPULATION,
        STATS_OTHER_GENDER,
        STATS_ADULT_POPULATION,
        STATS_MIDDLEAGED_POPULATION,
        STATS_ELDERLY_POPULATION,
        STATS_ALIVE_NORTHERN_HUMANS,
        STATS_ALIVE_DWARVES,
        STATS_ALIVE_DARK_ELVES,
        STATS_ALIVE_WOOD_ELVES,
        STATS_ALIVE_HALF_ELVES,
        STATS_ALIVE_HALF_ORCS,
        STATS_ALIVE_GOBLINS,
        STATS_ALIVE_KOBOLDS,
        STATS_ALIVE_LIZARDS,
        STATS_ALIVE_AASIMAR,
        STATS_ALIVE_TIEFLINGS,
        STATS_ALIVE_HALFKIN,
        STATS_ALIVE_WILDKIN,
        STATS_ALIVE_CONSTRUCTS,
        STATS_ALIVE_VERMINFOLK,
        STATS_ALIVE_DRACON,
        STATS_ALIVE_AXIAN,
        STATS_ALIVE_TABAXI,
        STATS_ALIVE_VULPS,
        STATS_ALIVE_LUPIANS,
        STATS_ALIVE_MOTHS,
        STATS_ALIVE_AURA
	)

	for(var/stat_name in statistics_to_clear)
		force_set_round_statistic(stat_name, 0)

	var/total_wealth = 0

	var/highest_strength = -1
	var/highest_intelligence = -1
	var/highest_wealth = -1
	var/highest_luck = -1
	var/highest_speed = -1

	var/lowest_intelligence
	var/lowest_speed
	var/lowest_luck

	for(var/client/client in GLOB.clients)
		if(roundstart)
			GLOB.patron_follower_counts[client.prefs.selected_patron.name]++
		var/mob/living/living = client.mob
		if(!istype(living))
			continue
		if(!living.mind)
			continue
		if(living.stat == DEAD)
			continue
		if(!roundstart)
			if(living.patron)
				GLOB.patron_follower_counts[living.patron.name]++
				if(living.job == "Grand Duke")
					force_set_round_statistic(STATS_MONARCH_PATRON, living.patron.name)
		if(living.mind.has_antag_datum(/datum/antagonist/bandit))
			record_round_statistic(STATS_BANDITS)
		if(living.mind.has_antag_datum(/datum/antagonist/werewolf))
			record_round_statistic(STATS_WEREVOLVES)
		if(living.mind.has_antag_datum(/datum/antagonist/vampire))
			record_round_statistic(STATS_VAMPIRES)
		if(living.mind.has_antag_datum(/datum/antagonist/zombie) || living.mind.has_antag_datum(/datum/antagonist/skeleton) || living.mind.has_antag_datum(/datum/antagonist/lich))
			record_round_statistic(STATS_DEADITES_ALIVE)
		if(ishuman(living))
			var/mob/living/carbon/human/human_mob = client.mob
			record_round_statistic(STATS_TOTAL_POPULATION)
			for(var/obj/item/clothing/neck/current_item in human_mob.get_equipped_items(TRUE))
				if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/aalloy, /obj/item/clothing/neck/roguetown/psicross/silver,	/obj/item/clothing/neck/roguetown/psicross/g))
					record_round_statistic(STATS_PSYCROSS_USERS)
					break
			switch(human_mob.pronouns)
				if(HE_HIM)
					record_round_statistic(STATS_MALE_POPULATION)
				if(HE_HIM_F)
					record_round_statistic(STATS_MALE_POPULATION)
				if(SHE_HER)
					record_round_statistic(STATS_FEMALE_POPULATION)
				if(SHE_HER_M)
					record_round_statistic(STATS_FEMALE_POPULATION)
				else
					record_round_statistic(STATS_OTHER_GENDER)
			switch(human_mob.age)
				if(AGE_ADULT)
					record_round_statistic(STATS_ADULT_POPULATION)
				if(AGE_MIDDLEAGED)
					record_round_statistic(STATS_MIDDLEAGED_POPULATION)
				if(AGE_OLD)
					record_round_statistic(STATS_ELDERLY_POPULATION)
			if(human_mob.is_noble())
				record_round_statistic(STATS_ALIVE_NOBLES)
			if(human_mob.mind.assigned_role in GLOB.garrison_positions)
				record_round_statistic(STATS_ALIVE_GARRISON)
			if(human_mob.mind.assigned_role in GLOB.church_positions)
				record_round_statistic(STATS_ALIVE_CLERGY)
			if((human_mob.mind.assigned_role in GLOB.yeoman_positions) || (human_mob.mind.assigned_role in GLOB.peasant_positions) || (human_mob.mind.assigned_role in GLOB.mercenary_positions))
				record_round_statistic(STATS_ALIVE_TRADESMEN)
			if(human_mob.has_flaw(/datum/charflaw/clingy))
				record_round_statistic(STATS_CLINGY_PEOPLE)
			if(human_mob.has_flaw(/datum/charflaw/addiction/alcoholic))
				record_round_statistic(STATS_ALCOHOLICS)
			if(human_mob.has_flaw(/datum/charflaw/addiction/junkie))
				record_round_statistic(STATS_JUNKIES)
			if(human_mob.has_flaw(/datum/charflaw/addiction/kleptomaniac))
				record_round_statistic(STATS_KLEPTOMANIACS)
			if(human_mob.has_flaw(/datum/charflaw/greedy))
				record_round_statistic(STATS_GREEDY_PEOPLE)

			// Races - proper alive checking (We have so fucking many, kill me..)
			if(ishumannorthern(human_mob))
				record_round_statistic(STATS_ALIVE_NORTHERN_HUMANS)
			if(isdwarf(human_mob))
				record_round_statistic(STATS_ALIVE_DWARVES)
			if(isdarkelf(human_mob))
				record_round_statistic(STATS_ALIVE_DARK_ELVES)
			if(iswoodelf(human_mob))
				record_round_statistic(STATS_ALIVE_WOOD_ELVES)
			if(ishalfelf(human_mob))
				record_round_statistic(STATS_ALIVE_HALF_ELVES)
			if(ishalforc(human_mob))
				record_round_statistic(STATS_ALIVE_HALF_ORCS)
			if(isgoblinp(human_mob))
				record_round_statistic(STATS_ALIVE_GOBLINS)
			if(iskobold(human_mob))
				record_round_statistic(STATS_ALIVE_KOBOLDS)
			if(islizard(human_mob))
				record_round_statistic(STATS_ALIVE_LIZARDS)
			if(isaasimar(human_mob))
				record_round_statistic(STATS_ALIVE_AASIMAR)
			if(istiefling(human_mob))
				record_round_statistic(STATS_ALIVE_TIEFLINGS)
			if(ishalfkin(human_mob))
				record_round_statistic(STATS_ALIVE_HALFKIN)
			if(iswildkin(human_mob))
				record_round_statistic(STATS_ALIVE_WILDKIN)
			if(isconstruct(human_mob))
				record_round_statistic(STATS_ALIVE_CONSTRUCTS)
			if(isvermin(human_mob))
				record_round_statistic(STATS_ALIVE_VERMINFOLK)
			if(isdracon(human_mob))
				record_round_statistic(STATS_ALIVE_DRACON)
			if(isaxian(human_mob))
				record_round_statistic(STATS_ALIVE_AXIAN)
			if(istabaxi(human_mob))
				record_round_statistic(STATS_ALIVE_TABAXI)
			if(isvulp(human_mob))
				record_round_statistic(STATS_ALIVE_VULPS)
			if(islupian(human_mob))
				record_round_statistic(STATS_ALIVE_LUPIANS)
			if(ismoth(human_mob))
				record_round_statistic(STATS_ALIVE_MOTHS)
			if(isaura(human_mob))
				record_round_statistic(STATS_ALIVE_AURA)

			// Chronicle statistics
			if(human_mob.STASTR > highest_strength)
				highest_strength = human_mob.STASTR
				set_chronicle_stat(CHRONICLE_STATS_STRONGEST_PERSON, human_mob)
			if(human_mob.STAINT > highest_intelligence)
				highest_intelligence = human_mob.STAINT
				set_chronicle_stat(CHRONICLE_STATS_WISEST_PERSON, human_mob)
			if(human_mob.STALUC > highest_luck)
				highest_luck = human_mob.STALUC
				set_chronicle_stat(CHRONICLE_STATS_LUCKIEST_PERSON, human_mob)
			if(human_mob.STASPD > highest_speed)
				highest_speed = human_mob.STASPD
				set_chronicle_stat(CHRONICLE_STATS_FASTEST_PERSON, human_mob)

			var/wealth = get_mammons_in_atom(human_mob)
			total_wealth += wealth
			if(wealth > highest_wealth)
				highest_wealth = wealth
				set_chronicle_stat(CHRONICLE_STATS_RICHEST_PERSON, human_mob)

			if(!lowest_intelligence)
				lowest_intelligence = human_mob.STAINT
				set_chronicle_stat(CHRONICLE_STATS_DUMBEST_PERSON, human_mob)
			else if(human_mob.STAINT < lowest_intelligence)
				lowest_intelligence = human_mob.STAINT
				set_chronicle_stat(CHRONICLE_STATS_DUMBEST_PERSON, human_mob)

			if(!lowest_speed)
				lowest_speed = human_mob.STASPD
				set_chronicle_stat(CHRONICLE_STATS_SLOWEST_PERSON, human_mob)
			else if(human_mob.STASPD < lowest_speed)
				lowest_speed = human_mob.STASPD
				set_chronicle_stat(CHRONICLE_STATS_SLOWEST_PERSON, human_mob)

			if(!lowest_luck)
				lowest_luck = human_mob.STALUC
				set_chronicle_stat(CHRONICLE_STATS_UNLUCKIEST_PERSON, human_mob)
			else if(human_mob.STALUC < lowest_luck)
				lowest_luck = human_mob.STALUC
				set_chronicle_stat(CHRONICLE_STATS_UNLUCKIEST_PERSON, human_mob)

			force_set_round_statistic(STATS_MAMMONS_HELD, total_wealth)

/mob/living/carbon/human/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	var/mob/living/carbon/human/target = src
	var/mob/living/carbon/human/human_user = user

	if(!istype(human_user))
		return
	if(user.mmb_intent)
		return ..()
	if(!istype(dragged))
		return
	// Need to drag yourself to the target.
	if(dragged != user)
		return
	if(!human_user.can_do_sex)
		to_chat(user, "<span class='warning'>I can't do this.</span>")
		return
	var/may_bang = client && client.prefs && client.prefs.sexable == TRUE
	#ifdef LOCALTEST
		may_bang = TRUE
	#endif

	if(!may_bang) // Don't bang someone that dosn't want it.
		to_chat(user, "<span class='warning'>[src] dosn't wish to be touched. (Their ERP preference under options)</span>")
		to_chat(src, "<span class='warning'>[user] failed to touch you. (Your ERP preference under options)</span>")
		return
	
	// TWILIGHT AXIS EDITION START - new ERP SYSTEM
	if(!user.start_sex_session_tgui(target)) 
		to_chat(user, "<span class='warning'>Blocked by Defiant settings or Leprosy.</span>")
	// TWILIGHT AXIS EDITION END- new ERP SYSTEM
		return

/obj/item/bodypart/head/dullahan/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	var/mob/living/carbon/human/target = src.original_owner
	if(user.mmb_intent)
		return ..()
	// Maybe call target.MiddleMouseDrop_T() instead, may have side effects and so opted not to.

	if(!istype(dragged))
		return
	if(dragged != user)
		return
	if(!user.can_do_sex())
		to_chat(user, "<span class='warning'>I can't do this.</span>")
		return
	if(!user.client.prefs.sexable)
		to_chat(user, "<span class='warning'>I don't want to touch [target]. (Your ERP preference, in the options)</span>")
		return
	if(!target.client || !target.client.prefs)
		to_chat(user, span_warning("[target] is simply not there. I can't do this."))
		log_combat(user, target, "tried ERP menu against d/ced")
		return
	if(!target.client.prefs.sexable) // Don't bang someone that doesn't want it.
		to_chat(user, "<span class='warning'>[target] doesn't want to be touched. (Their ERP preference, in the options)</span>")
		to_chat(target, "<span class='warning'>[user] failed to touch you. (Your ERP preference, in the options)</span>")
		log_combat(user, target, "tried unwanted ERP menu against")
		return
	user.start_sex_session_tgui(target)
