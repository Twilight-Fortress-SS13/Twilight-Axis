#define SULTAN_HAREM_POSITIONS 3

/datum/controller/subsystem/familytree/proc/is_royal_harem_job(datum/job/job)
	return istype(job, /datum/job/roguetown/harem)

/datum/job/roguetown/harem/special_check_latejoin(client/C)
	return SSfamilytree.royal_partner_candidate_allowed(C, src)

/datum/job/roguetown/harem/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	SSfamilytree.prepare_sultan_harem_member(H)

/datum/controller/subsystem/familytree/proc/prepare_sultan_harem_member(mob/living/carbon/human/H)
	if(!H)
		return
	if(H.client?.prefs)
		H.client.prefs.polygamy_mode |= POLYGAMY_ALLOW_BE_SECOND
	H.polygamy_mode |= POLYGAMY_ALLOW_BE_SECOND
	give_sultan_surname(H, TRUE)

/mob/proc/sultan_harem_choice()
	if(!ishuman(src))
		return
	var/mob/living/carbon/human/H = src
	if(!H.client?.prefs)
		return
	SSfamilytree.refresh_royal_partner_jobs(H, H.client.prefs)

/datum/controller/subsystem/familytree/proc/refresh_sultan_harem_jobs(mob/living/carbon/human/sultan, datum/preferences/P)
	if(!sultan?.client)
		return FALSE

	if(!P)
		P = sultan.client.prefs
	if(!P)
		return FALSE

	if(current_royal_partner_owner == sultan && current_royal_partner_snapshot.len)
		return TRUE

	if(current_royal_partner_owner && current_royal_partner_owner != sultan)
		return FALSE

	load_familytree_runtime_preferences(sultan, P)

	apply_royal_partner_job_state("consort", FALSE)
	apply_royal_partner_job_state("suitor", FALSE)
	apply_royal_partner_job_state("harem", FALSE)
	set_sultan_harem_snapshot(sultan, P, "closed")
	INVOKE_ASYNC(src, PROC_REF(do_ask_sultan_harem_permission), sultan)
	return TRUE

/datum/controller/subsystem/familytree/proc/set_sultan_harem_snapshot(mob/living/carbon/human/sultan, datum/preferences/P, mode)
	current_royal_partner_owner = sultan
	current_royal_partner_mode = mode || "closed"
	current_royal_partner_snapshot = list(
		"family" = sultan.familytree_pref,
		"duke_gender" = sultan.gender,
		"duke_pronouns" = sultan.pronouns,
		"duke_species_type" = sultan.dna?.species?.type,
		"gender_choice_pref" = P.gender_choice_pref,
		"species_preference_mode" = P.species_preference_mode,
		"preferred_species_types" = islist(sultan.preferred_species_types) ? sultan.preferred_species_types.Copy() : list(),
		"preferred_species_anatomy" = P.preferred_species_anatomy,
		"setspouse" = "",
	)

/datum/controller/subsystem/familytree/proc/do_ask_sultan_harem_permission(mob/living/carbon/human/sultan)
	if(!sultan?.client)
		return
	var/result = tgui_alert(sultan, "Желаете открыть гарем при дворе Аль-Ашура?\n\nБудет открыто до трёх мест Harem Favorite. Кандидаты будут ограничены вашими семейными предпочтениями: пол, раса и анатомия.", "Гарем султана", list("Да", "Нет"), 60 SECONDS)

	if(!sultan || QDELETED(sultan))
		return

	var/datum/preferences/P = sultan.client?.prefs
	if(!P)
		return
	load_familytree_runtime_preferences(sultan, P)

	if(result != "Да")
		apply_royal_partner_job_state("harem", FALSE)
		set_sultan_harem_snapshot(sultan, P, "closed")
		ftlog("SULTAN HAREM: [sultan.real_name] kept harem closed result=[result || "timeout"]")
		to_chat(sultan, span_notice("Вы не открыли гарем. Места фаворитов останутся закрытыми."))
		return

	var/list/harem_baseline = royal_partner_job_baselines["harem"]
	if(!harem_baseline)
		ftlog("SULTAN HAREM: harem job baseline missing", FTLOG_WARN)
		set_sultan_harem_snapshot(sultan, P, "closed")
		return

	if(sultan.client?.prefs)
		sultan.client.prefs.polygamy_mode |= POLYGAMY_ALLOW_MULTIPLE
	sultan.polygamy_mode |= POLYGAMY_ALLOW_MULTIPLE

	var/list/allowed_races = get_royal_partner_allowed_races(sultan, P)
	var/list/harem_allowed_sexes = get_royal_partner_allowed_sexes(sultan, P, harem_baseline["allowed_sexes"])
	apply_royal_partner_job_state("harem", TRUE, SULTAN_HAREM_POSITIONS, allowed_races, harem_allowed_sexes)
	set_sultan_harem_snapshot(sultan, P, "harem")
	ftlog("SULTAN HAREM: [sultan.real_name] opened harem slots=[SULTAN_HAREM_POSITIONS]")
	to_chat(sultan, span_notice("Вы открыли гарем. До трёх фаворитов, подходящих вашим семейным предпочтениям, смогут прибыть ко двору."))

#undef SULTAN_HAREM_POSITIONS
