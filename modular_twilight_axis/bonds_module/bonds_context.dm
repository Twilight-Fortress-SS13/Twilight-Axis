/datum/bond_weight_share
	abstract_type = /datum/bond_weight_share
	var/id = ""
	var/label = ""
	var/share = 0

/datum/bond_weight_share/role
	id = BOND_SHARE_ROLE
	label = "Положение"
	share = 0.40

/datum/bond_weight_share/lore
	id = BOND_SHARE_LORE
	label = "Происхождение"
	share = 0.20

/datum/bond_weight_share/storyteller
	id = BOND_SHARE_STORYTELLER
	label = "Сторителлер"
	share = 0.20

/datum/bond_weight_share/zone
	id = BOND_SHARE_ZONE
	label = "Место"
	share = 0.10

/datum/bond_weight_share/map
	id = BOND_SHARE_MAP
	label = "Карта"
	share = 0.10

/datum/controller/subsystem/bonds/proc/build_weight_shares()
	weight_shares = list()
	var/total = 0
	for(var/datum/bond_weight_share/share_type as anything in typesof(/datum/bond_weight_share))
		if(IS_ABSTRACT(share_type))
			continue
		var/datum/bond_weight_share/entry = new share_type()
		weight_shares[entry.id] = entry
		total += entry.share
		switch(entry.id)
			if(BOND_SHARE_ROLE)
				share_role = entry.share
			if(BOND_SHARE_LORE)
				share_lore = entry.share
			if(BOND_SHARE_STORYTELLER)
				share_teller = entry.share
			if(BOND_SHARE_ZONE)
				share_zone = entry.share
			if(BOND_SHARE_MAP)
				share_map = entry.share
	if(total < 0.999 || total > 1.001)
		bondlog("weight shares do not sum to 1 (got [total]) - the blend will not be neutral at rest", BONDLOG_ERROR)
	bondlog("weight shares built: [weight_shares.len], total [total]", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/blend_impact(role, lore, teller, zone, map)
	var/blended = (share_role * role) + (share_lore * lore) + (share_teller * teller) + (share_zone * zone) + (share_map * map)
	var/covered = share_role + share_lore + share_teller + share_zone + share_map
	if(!covered)
		return 1
	if(covered < 0.999)
		blended += (1 - covered)
	return blended

/datum/controller/subsystem/bonds/proc/blend_weights(list/modifiers)
	var/blended = 0
	var/covered = 0
	for(var/share_id in modifiers)
		var/datum/bond_weight_share/entry = weight_shares[share_id]
		if(!entry)
			continue
		var/value = modifiers[share_id]
		if(isnull(value))
			value = 1
		blended += entry.share * value
		covered += entry.share
	if(!covered)
		return 1
	if(covered < 0.999)
		blended += (1 - covered)
	return blended

/datum/bond_role_tier
	abstract_type = /datum/bond_role_tier
	var/weight = 1
	var/list/jobs

/datum/controller/subsystem/bonds/proc/build_role_weights()
	role_weights = list()
	for(var/datum/bond_role_tier/tier_type as anything in typesof(/datum/bond_role_tier))
		if(IS_ABSTRACT(tier_type))
			continue
		var/datum/bond_role_tier/tier = new tier_type()
		for(var/job_type in tier.jobs)
			if(isnull(role_weights[job_type]) || role_weights[job_type] < tier.weight)
				role_weights[job_type] = tier.weight
		qdel(tier)
	bondlog("role weights built: [role_weights.len] job types", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/role_weight_for_job(job_type)
	if(!job_type)
		return 1
	var/weight = role_weights[job_type]
	return isnull(weight) ? 1 : weight

/datum/controller/subsystem/bonds/proc/role_impact_weight(mob/living/carbon/human/person)
	return role_weight_for_job(job_type_of(person))

/datum/bond_zone_lens
	abstract_type = /datum/bond_zone_lens
	var/area_type
	var/weight = 1
	var/public_zone = FALSE
	var/priority = 0

/datum/bond_zone_lens/town_outdoors
	area_type = /area/rogue/outdoors/town
	weight = 1
	public_zone = TRUE
	priority = 10

/datum/bond_zone_lens/tavern
	area_type = /area/rogue/indoors/town/tavern
	weight = 1
	public_zone = TRUE
	priority = 20

/datum/bond_zone_lens/chapel
	area_type = /area/rogue/indoors/town/church/chapel
	weight = 1
	public_zone = TRUE
	priority = 20

/datum/bond_zone_lens/indoors
	area_type = /area/rogue/indoors
	weight = 1
	priority = 5

/datum/bond_zone_lens/outdoors
	area_type = /area/rogue/outdoors
	weight = 1
	priority = 5

/datum/bond_zone_lens/underground
	area_type = /area/rogue/under
	weight = 1
	priority = 10

/datum/bond_zone_lens/wilds
	area_type = /area/rogue/outdoors/mountains
	weight = 1
	priority = 10

/datum/bond_zone_lens/arena
	area_type = /area/rogue/indoors/ravoxarena
	weight = 0
	priority = 100

/datum/controller/subsystem/bonds/proc/build_zone_lenses()
	var/list/collected = list()
	for(var/datum/bond_zone_lens/lens_type as anything in typesof(/datum/bond_zone_lens))
		if(IS_ABSTRACT(lens_type))
			continue
		var/datum/bond_zone_lens/lens = new lens_type()
		if(!lens.area_type)
			qdel(lens)
			continue
		collected += lens
	sortTim(collected, GLOBAL_PROC_REF(cmp_bond_zone_priority))
	zone_lenses = collected
	bondlog("zone lenses built: [zone_lenses.len]", BONDLOG_INFO)

/proc/cmp_bond_zone_priority(datum/bond_zone_lens/a, datum/bond_zone_lens/b)
	return b.priority - a.priority

/datum/controller/subsystem/bonds/proc/zone_lens_for(atom/where)
	RETURN_TYPE(/datum/bond_zone_lens)
	var/area/spot = get_area(where)
	if(!spot)
		return null
	var/cached = zone_lens_cache[spot.type]
	if(cached)
		return cached
	if(!isnull(cached))
		return null
	var/datum/bond_zone_lens/found = null
	for(var/datum/bond_zone_lens/lens as anything in zone_lenses)
		if(istype(spot, lens.area_type))
			found = lens
			break
	zone_lens_cache[spot.type] = found || FALSE
	return found

/datum/controller/subsystem/bonds/proc/is_public_zone(atom/where)
	var/datum/bond_zone_lens/lens = zone_lens_for(where)
	return lens ? lens.public_zone : FALSE

/datum/controller/subsystem/bonds/proc/zone_weight(atom/where)
	var/datum/bond_zone_lens/lens = zone_lens_for(where)
	return lens ? lens.weight : 1

/datum/bond_map_lens
	abstract_type = /datum/bond_map_lens
	var/map_name = ""
	var/weight = 0

/datum/controller/subsystem/bonds/proc/build_map_lenses()
	map_lenses = list()
	for(var/datum/bond_map_lens/lens_type as anything in typesof(/datum/bond_map_lens))
		if(IS_ABSTRACT(lens_type))
			continue
		var/datum/bond_map_lens/lens = new lens_type()
		if(!lens.map_name)
			qdel(lens)
			continue
		map_lenses[lens.map_name] = lens
	bondlog("map lenses built: [map_lenses.len]", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/map_weight()
	if(!isnull(map_weight_cache))
		return map_weight_cache
	var/current = SSmapping?.config?.map_name
	if(!current)
		return 1
	var/datum/bond_map_lens/lens = map_lenses[current]
	map_weight_cache = (lens && lens.weight) ? lens.weight : 1
	return map_weight_cache

/datum/controller/subsystem/bonds/proc/map_blacklist()
	RETURN_TYPE(/list)
	var/datum/map_adjustment/adjustment = SSmapping?.map_adjustment
	if(!adjustment || !islist(adjustment.blacklist))
		return list()
	return adjustment.blacklist

/datum/controller/subsystem/bonds/proc/faction_present(faction_id)
	if(!faction_id)
		return FALSE
	var/datum/bond_faction/faction = faction_prototypes[faction_id]
	if(!faction)
		return FALSE
	var/list/blacklist = map_blacklist()
	var/found_any = FALSE
	for(var/job_type in faction_index)
		if(faction_index[job_type] != faction)
			continue
		found_any = TRUE
		if(!(job_type in blacklist))
			return TRUE
	return !found_any

/datum/controller/subsystem/bonds/proc/present_faction_ids()
	RETURN_TYPE(/list)
	if(present_factions_cache)
		return present_factions_cache
	var/list/out = list()
	for(var/faction_id in faction_prototypes)
		var/datum/bond_faction/faction = faction_prototypes[faction_id]
		if(istype(faction, /datum/bond_faction/clan))
			continue
		if(!faction_present(faction_id))
			continue
		out += faction_id
	present_factions_cache = out
	return out

/datum/bond_storyteller_lens
	abstract_type = /datum/bond_storyteller_lens
	var/storyteller_type
	var/list/pair_weights
	var/default_weight = 1
	var/dream_positive_bias = 1
	var/dream_negative_bias = 1

/datum/controller/subsystem/bonds/proc/build_storyteller_lenses()
	storyteller_lenses = list()
	for(var/datum/bond_storyteller_lens/lens_type as anything in typesof(/datum/bond_storyteller_lens))
		if(IS_ABSTRACT(lens_type))
			continue
		var/datum/bond_storyteller_lens/lens = new lens_type()
		if(!lens.storyteller_type)
			qdel(lens)
			continue
		storyteller_lenses[lens.storyteller_type] = lens
	bondlog("storyteller lenses built: [storyteller_lenses.len]", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/active_storyteller()
	RETURN_TYPE(/datum/storyteller)
	var/god_type = ruling_god_type()
	if(!god_type)
		return null
	return SSgamemode.storytellers?[god_type]

/datum/controller/subsystem/bonds/proc/ruling_god_type()
	return SSgamemode?.ruling_god

/datum/controller/subsystem/bonds/proc/storyteller_weight(id_a, id_b)
	var/datum/storyteller/teller = active_storyteller()
	if(!teller)
		return 1
	var/datum/bond_storyteller_lens/lens = storyteller_lenses[teller.type]
	if(!lens)
		return 1
	return lens.weight_for(id_a, id_b)

/datum/bond_origin
	abstract_type = /datum/bond_origin
	var/id = ""
	var/name = ""
	var/virtue_type

/datum/bond_origin/azuria
	id = "azuria"
	name = "Великое Герцогство Азурия"
	virtue_type = /datum/virtue/origin/azuria
/datum/bond_origin/grenzelhoft
	id = "grenzelhoft"
	name = "Грензельхофт"
	virtue_type = /datum/virtue/origin/grenzelhoft
/datum/bond_origin/zybantian
	id = "zybantu"
	name = "Зибантийская Империя"
	virtue_type = /datum/virtue/origin/zybantian
/datum/bond_origin/valorian
	id = "valoria"
	name = "Валорийский торговый союз"
	virtue_type = /datum/virtue/origin/valorian
/datum/bond_origin/otava
	id = "otava"
	name = "Отава"
	virtue_type = /datum/virtue/origin/otava
/datum/bond_origin/naledi
	id = "naledi"
	name = "Наледи"
	virtue_type = /datum/virtue/origin/naledi
/datum/bond_origin/heartfelt
	id = "heartfelt"
	name = "Хартфелт"
	virtue_type = /datum/virtue/origin/heartfelt
/datum/bond_origin/etrusca
	id = "etrusca"
	name = "Королевство Этруска"
	virtue_type = /datum/virtue/origin/etrusca
/datum/bond_origin/gronn
	id = "gronn"
	name = "Гронн"
	virtue_type = /datum/virtue/origin/gronn
/datum/bond_origin/hammerhold
	id = "hammerhold"
	name = "Царство Хаммерхолд"
	virtue_type = /datum/virtue/origin/hammerhold
/datum/bond_origin/kazengun
	id = "kazengun"
	name = "Сёгунат Казен"
	virtue_type = /datum/virtue/origin/kazengun
/datum/bond_origin/lingyue
	id = "lingyue"
	name = "Линъюэ"
	virtue_type = /datum/virtue/origin/lingyue
/datum/bond_origin/avar
	id = "avar"
	name = "Нагорье Аавнр"
	virtue_type = /datum/virtue/origin/avar
/datum/bond_origin/gyedzenese
	id = "gyedzen"
	name = "Гёдзайское Царство"
	virtue_type = /datum/virtue/origin/gyedzenese
/datum/bond_origin/raneshen
	id = "raneshen"
	name = "Ранешен"
	virtue_type = /datum/virtue/origin/raneshen
/datum/bond_origin/enigma
	id = "enigma"
	name = "Энигма"
	virtue_type = /datum/virtue/origin/enigma
/datum/bond_origin/unknown
	id = "unknown"
	name = "Неизвестно откуда"
	virtue_type = /datum/virtue/origin/unknown

/datum/controller/subsystem/bonds/proc/build_origin_index()
	origin_prototypes = list()
	origin_index = list()
	for(var/datum/bond_origin/origin_type as anything in typesof(/datum/bond_origin))
		if(IS_ABSTRACT(origin_type))
			continue
		var/datum/bond_origin/origin = new origin_type()
		origin_prototypes[origin.id] = origin
		if(origin.virtue_type)
			origin_index[origin.virtue_type] = origin
	bondlog("origin index built: [origin_prototypes.len] origins", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/origin_for(participant)
	RETURN_TYPE(/datum/bond_origin)
	var/datum/bond_actor/actor = resolve_actor(participant)
	if(!actor)
		return null
	if(actor.cached_origin_id)
		return origin_prototypes[actor.cached_origin_id]
	var/mob/living/carbon/human/body = actor.current_body()
	var/datum/virtue/virtue = body?.client?.prefs?.virtue_origin
	if(!virtue)
		return null
	var/datum/bond_origin/origin = origin_index[virtue.type]
	if(!origin)
		return null
	actor.cached_origin_id = origin.id
	return origin

/datum/controller/subsystem/bonds/proc/origin_id_for(participant)
	var/datum/bond_origin/origin = origin_for(participant)
	return origin?.id

/datum/origin_lore
	abstract_type = /datum/origin_lore
	var/origin_a = ""
	var/origin_b = ""
	var/bias = 0
	var/weight_scale = 1

/datum/origin_lore/grenzelhoft_zybantu
	origin_a = "grenzelhoft"
	origin_b = "zybantu"
	bias = -10
	weight_scale = 1.8

/datum/origin_lore/grenzelhoft_azuria
	origin_a = "grenzelhoft"
	origin_b = "azuria"
	bias = 6
	weight_scale = 0.8

/datum/origin_lore/grenzelhoft_otava
	origin_a = "grenzelhoft"
	origin_b = "otava"
	bias = 5
	weight_scale = 0.9

/datum/origin_lore/grenzelhoft_kazengun
	origin_a = "grenzelhoft"
	origin_b = "kazengun"
	bias = -4
	weight_scale = 1.2

/datum/origin_lore/azuria_valoria
	origin_a = "azuria"
	origin_b = "valoria"
	bias = 4
	weight_scale = 0.9

/datum/origin_lore/azuria_heartfelt
	origin_a = "azuria"
	origin_b = "heartfelt"
	bias = 5
	weight_scale = 0.8

/proc/bonds_origin_key(id_a, id_b)
	if(!id_a || !id_b)
		return null
	return (id_a < id_b) ? "[id_a]|[id_b]" : "[id_b]|[id_a]"

/datum/controller/subsystem/bonds/proc/build_origin_lore()
	origin_lore = list()
	for(var/datum/origin_lore/lore_type as anything in typesof(/datum/origin_lore))
		if(IS_ABSTRACT(lore_type))
			continue
		var/datum/origin_lore/lore = new lore_type()
		var/key = bonds_origin_key(lore.origin_a, lore.origin_b)
		if(!key)
			qdel(lore)
			continue
		origin_lore[key] = lore
	bondlog("origin lore built: [origin_lore.len] pairs", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/origin_lore_for(participant_a, participant_b)
	RETURN_TYPE(/datum/origin_lore)
	var/key = bonds_origin_key(origin_id_for(participant_a), origin_id_for(participant_b))
	if(!key)
		return null
	return origin_lore[key]

/datum/controller/subsystem/bonds/proc/influence_state(datum/bond_actor/actor)
	RETURN_TYPE(/list)
	if(!actor)
		return null
	var/list/state = influence_pools[actor]
	if(!state)
		state = list("left" = BOND_INFLUENCE_POOL, "refill" = world.time + BOND_INFLUENCE_REFILL, "banned_until" = 0)
		influence_pools[actor] = state
	return state

/datum/controller/subsystem/bonds/proc/spend_influence(datum/bond_actor/actor)
	var/list/state = influence_state(actor)
	if(!state)
		return FALSE

	if(world.time >= state["refill"])
		state["left"] = BOND_INFLUENCE_POOL
		state["refill"] = world.time + BOND_INFLUENCE_REFILL
		state["banned_until"] = 0

	if(state["banned_until"] && world.time < state["banned_until"])
		return FALSE

	if(state["left"] <= 0)
		state["banned_until"] = world.time + BOND_INFLUENCE_BAN
		bondlog("[actor.name_of()] exhausted their influence pool; muted for [BOND_INFLUENCE_BAN / 10]s")
		return FALSE

	state["left"]--
	return TRUE

/datum/controller/subsystem/bonds/proc/influence_left(participant)
	var/list/state = influence_pools[resolve_actor(participant)]
	if(!state)
		return BOND_INFLUENCE_POOL
	return state["left"]

/datum/controller/subsystem/bonds/proc/influence_muted(participant)
	var/list/state = influence_pools[resolve_actor(participant)]
	if(!state)
		return FALSE
	return state["banned_until"] && world.time < state["banned_until"]

/datum/controller/subsystem/bonds/proc/social_impact(subject, object, event_type, applied_scale = 1)
	var/datum/bond_event/prototype = get_event_prototype(event_type)
	if(!prototype || !prototype.scored_propagation)
		return FALSE
	var/datum/bond_actor/subject_actor = resolve_actor(subject)
	var/datum/bond_actor/object_actor = resolve_actor(object)
	if(!subject_actor || !object_actor || subject_actor == object_actor)
		return FALSE
	var/mob/living/carbon/human/subject_body = subject_actor.current_body()
	var/mob/living/carbon/human/object_body = object_actor.current_body()
	if(!ishuman(subject_body) || !ishuman(object_body))
		return FALSE

	if(!applied_scale)
		return FALSE
	var/datum/bond_zone_lens/zone = zone_lens_for(object_body)
	var/hostile = (prototype.category == BOND_CATEGORY_VIOLENCE) || (prototype.category == BOND_CATEGORY_DEATH)
	if(hostile && !zone?.public_zone)
		BONDS_TALLY("impact.blocked_private_zone")
		return FALSE

	if(!spend_influence(object_actor))
		BONDS_TALLY("impact.blocked_influence")
		return FALSE

	var/datum/origin_lore/lore = origin_lore_for(subject_actor, object_actor)
	var/subject_job = job_type_of(subject_body)
	var/object_job = job_type_of(object_body)
	var/datum/bond_faction/faction_a = faction_for_job(subject_job)
	var/datum/bond_faction/faction_b = faction_for_job(object_job)
	var/id_a = faction_a?.id
	var/id_b = faction_b?.id
	var/scale = applied_scale * blend_impact(
		role_weight_for_job(object_job) * role_weight_for_job(subject_job),
		lore ? lore.weight_scale : 1,
		storyteller_weight(id_a, id_b),
		zone ? zone.weight : 1,
		map_weight(),
	)
	var/bias = lore ? lore.bias : 0

	var/warmth_delta = (prototype.warmth_commit * scale) + bias
	var/weight_delta = abs(prototype.weight_commit) * scale
	if(!warmth_delta && !weight_delta)
		BONDS_TALLY("impact.zero_scale")
		return FALSE
	BONDS_TALLY("impact.applied")

	var/reason = "[subject_actor.name_of()] и [object_actor.name_of()]: [lowertext(prototype.history_label)]"
	apply_faction_impact(id_a, id_b, warmth_delta, weight_delta, reason)
	apply_house_impact(subject_body, object_body, warmth_delta, weight_delta, reason)
	apply_clan_impact(subject_body, object_body, warmth_delta, weight_delta, reason)
	return TRUE

/datum/controller/subsystem/bonds/proc/apply_faction_impact(id_a, id_b, warmth_delta, weight_delta, reason)
	if(!id_a || !id_b || id_a == id_b)
		return FALSE
	nudge_stance(id_a, id_b, warmth_delta, weight_delta, reason)
	if(verbose_logging)
		bondlog("faction impact [id_a] <-> [id_b] warmth [warmth_delta]")
	return TRUE

/datum/controller/subsystem/bonds/proc/apply_house_impact(mob/living/carbon/human/subject_body, mob/living/carbon/human/object_body, warmth_delta, weight_delta, reason)
	var/datum/heritage/house_a = subject_body.family_datum
	var/datum/heritage/house_b = object_body.family_datum
	if(!house_a || !house_b || house_a == house_b)
		return FALSE
	nudge_house_stance(house_a, house_b, warmth_delta, weight_delta, reason)
	return TRUE

/datum/controller/subsystem/bonds/proc/apply_clan_impact(mob/living/carbon/human/subject_body, mob/living/carbon/human/object_body, warmth_delta, weight_delta, reason)
	var/id_a = clan_faction_id_for(subject_body)
	var/id_b = clan_faction_id_for(object_body)
	if(!id_a || !id_b || id_a == id_b)
		return FALSE
	nudge_stance(id_a, id_b, warmth_delta, weight_delta, reason)
	return TRUE
