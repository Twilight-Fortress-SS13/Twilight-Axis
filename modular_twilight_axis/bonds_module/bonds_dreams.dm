/datum/controller/subsystem/bonds
	var/list/archetype_index
	var/list/dream_prototypes
	var/list/dream_buckets

/datum/bond_archetype
	abstract_type = /datum/bond_archetype
	var/flag = 0
	var/list/jobs

/datum/controller/subsystem/bonds/proc/build_archetype_index()
	archetype_index = list()
	for(var/datum/bond_archetype/arch_type as anything in typesof(/datum/bond_archetype))
		if(IS_ABSTRACT(arch_type))
			continue
		var/datum/bond_archetype/arch = new arch_type()
		if(!arch.flag || !length(arch.jobs))
			qdel(arch)
			continue
		for(var/job_type in arch.jobs)
			archetype_index[job_type] |= arch.flag
		qdel(arch)
	bondlog("archetype index built: [archetype_index.len] jobs", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/archetypes_for_job(job_type)
	if(!job_type || !archetype_index)
		return 0
	var/current = job_type
	while(current)
		var/found = archetype_index[current]
		if(found)
			return found
		if(current == /datum/job)
			break
		current = type2parent(current)
	return 0

/datum/controller/subsystem/bonds/proc/archetypes_for(mob/living/carbon/human/person)
	return archetypes_for_job(job_type_of(person))

/datum/bond_event/dream
	abstract_type = /datum/bond_event/dream
	category = BOND_CATEGORY_DREAM
	timeout = 0
	scored_propagation = FALSE
	history_label = "Сон"
	var/valence = BOND_DREAM_POSITIVE
	var/scopes = BOND_DREAM_SCOPE_ANY
	var/dreamer_mask = 0
	var/other_mask = 0
	var/storyteller_type
	var/list/maps
	var/vampire_rule = BOND_DREAM_VAMPIRE_NONE
	var/story_template
	var/echo_template
	var/rarity = 10

/datum/bond_event/dream/build_story(datum/social_bond/context)
	if(story_template)
		return replacetext(story_template, "{name}", context.display_name())
	return ..()

/datum/bond_event/dream/proc/build_echo(datum/social_bond/context)
	if(echo_template)
		return replacetext(echo_template, "{name}", context.display_name())
	return build_story(context)

/datum/bond_event/dream/proc/fits(dreamer_arch, other_arch, scope)
	if(!(scopes & scope))
		return FALSE
	if(dreamer_mask && !(dreamer_arch & dreamer_mask))
		return FALSE
	if(other_mask && !(other_arch & other_mask))
		return FALSE
	return TRUE

/datum/bond_event/dream/proc/fits_round(map_type, teller_type)
	if(storyteller_type && storyteller_type != teller_type)
		return FALSE
	if(length(maps) && !(map_type in maps))
		return FALSE
	return TRUE

/datum/bond_event/dream/proc/fits_blood(mob/living/carbon/human/dreamer, mob/living/carbon/human/other)
	switch(vampire_rule)
		if(BOND_DREAM_VAMPIRE_OTHER)
			return bonds_is_vampire(other)
		if(BOND_DREAM_VAMPIRE_DREAMER)
			return bonds_is_vampire(dreamer)
	return TRUE

/proc/bonds_is_vampire(mob/living/carbon/human/person)
	return person?.mind?.has_antag_datum(/datum/antagonist/vampire) ? TRUE : FALSE

/datum/bond_event/dream/shield_wall
/datum/bond_event/dream/bound_my_wound
/datum/bond_event/dream/night_vigil
/datum/bond_event/dream/kept_confession
/datum/bond_event/dream/shared_bread
/datum/bond_event/dream/forgave_debt
/datum/bond_event/dream/stood_at_my_oath
/datum/bond_event/dream/copied_by_candle
/datum/bond_event/dream/carried_me_home
/datum/bond_event/dream/shared_the_road
/datum/bond_event/dream/left_me_in_the_line
/datum/bond_event/dream/named_me_from_the_pulpit
/datum/bond_event/dream/cut_my_purse
/datum/bond_event/dream/swore_falsely
/datum/bond_event/dream/withheld_my_wage
/datum/bond_event/dream/bled_me_wrong
/datum/bond_event/dream/botched_the_rite
/datum/bond_event/dream/flogged_me
/datum/bond_event/dream/usury
/datum/bond_event/dream/blood_price_unpaid

/datum/controller/subsystem/bonds/proc/dream_bias(valence)
	var/datum/storyteller/teller = active_storyteller()
	if(!teller)
		return 1
	var/datum/bond_storyteller_lens/lens = storyteller_lenses[teller.type]
	if(!lens)
		return 1
	return (valence == BOND_DREAM_NEGATIVE) ? lens.dream_negative_bias : lens.dream_positive_bias

/datum/controller/subsystem/bonds/proc/dream_candidates(mob/living/carbon/human/dreamer, scope)
	RETURN_TYPE(/list)
	var/list/found = list()
	var/datum/bond_faction/own = faction_for(dreamer)
	for(var/mob/living/carbon/human/person in GLOB.player_list)
		if(person == dreamer || !person.mind || !person.ckey)
			continue
		if(person.stat == DEAD)
			continue
		if(istype(person, /mob/living/carbon/human/dummy))
			continue
		var/datum/bond_faction/theirs = faction_for(person)
		if(!theirs)
			continue
		if(scope == BOND_DREAM_SCOPE_OWN)
			if(!own || theirs != own)
				continue
		else if(own && theirs == own)
			continue
		found += person
	return found

/datum/controller/subsystem/bonds/proc/build_dream_index()
	dream_prototypes = list()
	dream_buckets = list("[BOND_DREAM_POSITIVE]" = list(), "[BOND_DREAM_NEGATIVE]" = list())
	for(var/event_type in event_prototypes)
		var/datum/bond_event/dream/prototype = event_prototypes[event_type]
		if(!istype(prototype))
			continue
		dream_prototypes += event_type
		var/list/bucket = dream_buckets["[prototype.valence]"]
		if(bucket)
			bucket += event_type
	bondlog("dream index built: [dream_prototypes.len] memories", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/round_dream_pool(valence, scope)
	RETURN_TYPE(/list)
	var/list/bucket = dream_buckets?["[valence]"]
	if(!length(bucket))
		return list()
	var/map_type = current_map_type()
	var/teller_type = ruling_god_type()
	var/list/pool = list()
	for(var/event_type in bucket)
		var/datum/bond_event/dream/prototype = event_prototypes[event_type]
		if(!(prototype.scopes & scope))
			continue
		if(!prototype.fits_round(map_type, teller_type))
			continue
		pool += event_type
	return pool

/datum/controller/subsystem/bonds/proc/current_map_type()
	return SSmapping?.map_adjustment?.type

/datum/controller/subsystem/bonds/proc/dream_pool(valence, scope, dreamer_arch, other_arch, mob/living/carbon/human/dreamer, mob/living/carbon/human/other, list/round_pool)
	RETURN_TYPE(/list)
	if(isnull(round_pool))
		round_pool = round_dream_pool(valence, scope)
	var/list/pool = list()
	for(var/event_type in round_pool)
		var/datum/bond_event/dream/prototype = event_prototypes[event_type]
		if(!prototype.fits(dreamer_arch, other_arch, scope))
			continue
		if(prototype.vampire_rule != BOND_DREAM_VAMPIRE_NONE)
			if(!dreamer || !other)
				continue
			if(!prototype.fits_blood(dreamer, other))
				continue
		pool[event_type] = prototype.rarity
	return pool

/datum/controller/subsystem/bonds/proc/pick_dream(list/pool)
	var/total = 0
	for(var/event_type in pool)
		total += pool[event_type]
	if(total <= 0)
		return null
	var/roll = rand() * total
	var/cursor = 0
	for(var/event_type in pool)
		cursor += pool[event_type]
		if(roll <= cursor)
			return event_type
	return pool[pool.len]

/datum/controller/subsystem/bonds/proc/fire_dream(mob/living/carbon/human/dreamer, valence, scope, forced = FALSE)
	var/list/round_pool = round_dream_pool(valence, scope)
	if(!length(round_pool))
		BONDS_TALLY("dream.no_round_pool")
		return FALSE
	var/list/candidates = dream_candidates(dreamer, scope)
	if(!length(candidates))
		BONDS_TALLY("dream.no_candidates")
		return FALSE
	var/dreamer_arch = archetypes_for(dreamer)
	for(var/mob/living/carbon/human/other as anything in shuffle(candidates))
		var/list/pool = dream_pool(valence, scope, dreamer_arch, archetypes_for(other), dreamer, other, round_pool)
		if(!length(pool))
			continue
		var/event_type = pick_dream(pool)
		if(!event_type)
			continue
		if(!record(dreamer.mind, other.mind, event_type, other, TRUE))
			continue
		if(forced)
			BONDS_TALLY("dream.forced_fired")
		else
			BONDS_TALLY("dream.fired")
		notify_dream(dreamer, other)
		announce_echo(other, apply_echo(other.mind, dreamer.mind, event_type))
		bondlog("dream [dreamer.ckey] -> [other.ckey] [event_type]")
		return TRUE
	BONDS_TALLY("dream.no_matching_event")
	return FALSE

/datum/controller/subsystem/bonds/proc/notify_dream(mob/living/carbon/human/dreamer, mob/living/carbon/human/other)
	var/datum/social_bond/bond = get_bond(dreamer.mind, other.mind)
	if(!bond)
		return
	var/datum/bond_history/latest = LAZYLEN(bond.history) ? bond.history[bond.history.len] : null
	if(!latest)
		return
	to_chat(dreamer, span_notice("<b>Сон уводит меня назад.</b> [latest.story]"))

/datum/controller/subsystem/bonds/proc/apply_echo(subject, object, event_type)
	RETURN_TYPE(/datum/bond_history)
	var/datum/bond_event/dream/prototype = event_prototypes[event_type]
	if(!istype(prototype))
		return null
	var/datum/social_bond/bond = get_or_create_bond(subject, object)
	if(!bond || !bond.scored)
		return null
	var/warmth_delta = prototype.warmth_commit * BOND_DREAM_ECHO_SCALE
	var/weight_delta = prototype.weight_commit * BOND_DREAM_ECHO_SCALE
	bond.warmth_committed = clamp(bond.warmth_committed + warmth_delta, BOND_WARMTH_MIN, BOND_WARMTH_MAX)
	bond.weight_committed = clamp(bond.weight_committed + weight_delta, BOND_WEIGHT_MIN, BOND_WEIGHT_MAX)
	var/datum/bond_history/entry = new()
	entry.label = prototype.history_label
	entry.story = prototype.build_echo(bond)
	entry.created_at = world.time
	entry.warmth_delta = round(warmth_delta, 0.1)
	entry.weight_delta = round(weight_delta, 0.1)
	entry.dream = TRUE
	LAZYADD(bond.history, entry)
	bond.trim_history()
	bond.recalculate()
	return entry

/datum/controller/subsystem/bonds/proc/announce_echo(mob/living/carbon/human/other, datum/bond_history/entry)
	if(!other || !entry)
		return FALSE
	if(entry.warmth_delta >= 0)
		to_chat(other, span_notice("<i>Мне отчего-то думается, что обо мне сейчас вспомнили добром.</i> [entry.story]"))
	else
		to_chat(other, span_warning("<i>Мне отчего-то неспокойно, будто обо мне только что вспомнили.</i> [entry.story]"))
	return TRUE

/datum/controller/subsystem/bonds/proc/roll_dream(mob/living/carbon/human/dreamer)
	if(!reacting || !dreams_enabled)
		return FALSE
	if(!ishuman(dreamer) || !dreamer.mind)
		return FALSE
	var/negative = dream_bias(BOND_DREAM_NEGATIVE)
	var/positive = dream_bias(BOND_DREAM_POSITIVE)
	var/list/chances = list(
		BOND_DREAM_CHANCE_OWN_NEGATIVE * negative,
		BOND_DREAM_CHANCE_FOREIGN_NEGATIVE * negative,
		BOND_DREAM_CHANCE_OWN_POSITIVE * positive,
		BOND_DREAM_CHANCE_FOREIGN_POSITIVE * positive,
	)
	var/total = chances[1] + chances[2] + chances[3] + chances[4]
	BONDS_TALLY("dream.rolled")
	if(total <= 0 || !prob(total))
		BONDS_TALLY("dream.gate_failed")
		return FALSE
	BONDS_TALLY("dream.gate_passed")
	var/list/valences = list(BOND_DREAM_NEGATIVE, BOND_DREAM_NEGATIVE, BOND_DREAM_POSITIVE, BOND_DREAM_POSITIVE)
	var/list/bucket_scopes = list(BOND_DREAM_SCOPE_OWN, BOND_DREAM_SCOPE_FOREIGN, BOND_DREAM_SCOPE_OWN, BOND_DREAM_SCOPE_FOREIGN)
	var/roll = rand() * total
	var/cursor = 0
	var/chosen = length(chances)
	for(var/i in 1 to length(chances))
		cursor += chances[i]
		if(roll <= cursor)
			chosen = i
			break
	return fire_dream(dreamer, valences[chosen], bucket_scopes[chosen])

/datum/sleep_adv/advance_cycle()
	. = ..()
	if(!ishuman(mind?.current))
		return
	if(HAS_TRAIT(mind.current, TRAIT_CURSE_ABYSSOR))
		return
	SSbonds.roll_dream(mind.current)
