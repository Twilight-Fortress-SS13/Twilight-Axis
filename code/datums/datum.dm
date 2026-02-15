/**
  * The absolute base class for everything
  *
  * A datum instantiated has no physical world prescence, use an atom if you want something
  * that actually lives in the world
  *
  * Be very mindful about adding variables to this class, they are inherited by every single
  * thing in the entire game, and so you can easily cause memory usage to rise a lot with careless
  * use of variables at this level
  */
/datum
	/**
	  * Tick count time when this object was destroyed.
	  *
	  * If this is non zero then the object has been garbage collected and is awaiting either
	  * a hard del by the GC subsystme, or to be autocollected (if it has no references)
	  */
	var/gc_destroyed

	/// Open uis owned by this datum
	/// Lazy, since this case is semi rare
	var/list/open_uis

	/// Active timers with this datum as the target
	var/list/active_timers
	/// Status traits attached to this datum
	var/list/status_traits

	/// Components attached to this datum
	/// Lazy associated list in the structure of `type:component/list of components`
	var/list/datum_components
	/// Any datum registered to receive signals from this datum is in this list
	/// Lazy associated list in the structure of `signal:registree/list of registrees`
	var/list/comp_lookup
	/// Lazy associated list in the structure of `signals:proctype` that are run when the datum receives that signal
	var/list/list/datum/callback/signal_procs
	/// Is this datum capable of sending signals?
	/// Set to true when a signal has been registered
	var/signal_enabled = FALSE

	/// Datum level flags
	var/datum_flags = NONE

	/// A weak reference to another datum
	var/datum/weakref/weak_reference

		/*
	* Lazy associative list of currently active cooldowns.
	*
	* cooldowns [ COOLDOWN_INDEX ] = add_timer()
	* add_timer() returns the truthy value of -1 when not stoppable, and else a truthy numeric index
	*/
	var/list/cooldowns
	var/abstract_type = /datum

#ifdef TESTING
	var/running_find_references
	var/last_find_references = 0
#endif

#ifdef DATUMVAR_DEBUGGING_MODE
	var/list/cached_vars
#endif

/**
  * Called when a href for this datum is clicked
  *
  * Sends a COMSIG_TOPIC signal
  */
/datum/Topic(href, href_list[])
	..()
	SEND_SIGNAL(src, COMSIG_TOPIC, usr, href_list)

/**
  * Default implementation of clean-up code.
  *
  * This should be overridden to remove all references pointing to the object being destroyed, if
  * you do override it, make sure to call the parent and return it's return value by default
  *
  * Return an appropriate QDEL_HINT to modify handling of your deletion;
  * in most cases this is QDEL_HINT_QUEUE.
  *
  * The base case is responsible for doing the following
  * * Erasing timers pointing to this datum
  * * Erasing compenents on this datum
  * * Notifying datums listening to signals from this datum that we are going away
  *
  * Returns QDEL_HINT_QUEUE
  */
/datum/proc/Destroy(force=FALSE, ...)
	SHOULD_CALL_PARENT(TRUE)
	tag = null
	datum_flags &= ~DF_USE_TAG //In case something tries to REF us
	weak_reference = null	//ensure prompt GCing of weakref.

	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent)
			continue
		qdel(timer)

	//BEGIN: ECS SHIT
	signal_enabled = FALSE

	var/list/dc = datum_components
	if(dc)
		var/all_components = dc[/datum/component]
		if(length(all_components))
			for(var/I in all_components)
				var/datum/component/C = I
				qdel(C, FALSE, TRUE)
		else
			var/datum/component/C = all_components
			qdel(C, FALSE, TRUE)
		dc.Cut()

	clear_signal_refs()
	//END: ECS SHIT

	return QDEL_HINT_QUEUE

///Only override this if you know what you're doing. You do not know what you're doing
///This is a threat
/datum/proc/clear_signal_refs()
	var/list/lookup = comp_lookup
	if(lookup)
		for(var/sig in lookup)
			var/list/comps = lookup[sig]
			if(length(comps))
				for(var/i in comps)
					var/datum/component/comp = i
					comp.UnregisterSignal(src, sig)
			else
				var/datum/component/comp = comps
				comp.UnregisterSignal(src, sig)
		comp_lookup = lookup = null

	for(var/target in signal_procs)
		UnregisterSignal(target, signal_procs[target])

#ifdef DATUMVAR_DEBUGGING_MODE
/datum/proc/save_vars()
	cached_vars = list()
	for(var/i in vars)
		if(i == "cached_vars")
			continue
		cached_vars[i] = vars[i]

/datum/proc/check_changed_vars()
	. = list()
	for(var/i in vars)
		if(i == "cached_vars")
			continue
		if(cached_vars[i] != vars[i])
			.[i] = list(cached_vars[i], vars[i])

/datum/proc/txt_changed_vars()
	var/list/l = check_changed_vars()
	var/t = "[src]([REF(src)]) changed vars:"
	for(var/i in l)
		t += "\"[i]\" \[[l[i][1]]\] --> \[[l[i][2]]\] "
	t += "."

/datum/proc/to_chat_check_changed_vars(target = world)
	to_chat(target, txt_changed_vars())
#endif

///Return a LIST for serialize_datum to encode! Not the actual json!
/datum/proc/serialize_list(list/options)
	CRASH("Attempted to serialize datum [src] of type [type] without serialize_list being implemented!")

///Accepts a LIST from deserialize_datum. Should return src or another datum.
/datum/proc/deserialize_list(json, list/options)
	CRASH("Attempted to deserialize datum [src] of type [type] without deserialize_list being implemented!")

///Serializes into JSON. Does not encode type.
/datum/proc/serialize_json(list/options)
	. = serialize_list(options)
	if(!islist(.))
		. = null
	else
		. = json_encode(.)

///Deserializes from JSON. Does not parse type.
/datum/proc/deserialize_json(list/input, list/options)
	var/list/jsonlist = json_decode(input)
	. = deserialize_list(jsonlist)
	if(!istype(., /datum))
		. = null

///Convert a datum into a json blob
/proc/json_serialize_datum(datum/D, list/options)
	if(!istype(D))
		return
	var/list/jsonlist = D.serialize_list(options)
	if(islist(jsonlist))
		jsonlist["DATUM_TYPE"] = D.type
	return json_encode(jsonlist)

/// Convert a list of json to datum
/proc/json_deserialize_datum(list/jsonlist, list/options, target_type, strict_target_type = FALSE)
	if(!islist(jsonlist))
		if(!istext(jsonlist))
			CRASH("Invalid JSON")
		jsonlist = json_decode(jsonlist)
		if(!islist(jsonlist))
			CRASH("Invalid JSON")
	if(!jsonlist["DATUM_TYPE"])
		return
	if(!ispath(jsonlist["DATUM_TYPE"]))
		if(!istext(jsonlist["DATUM_TYPE"]))
			return
		jsonlist["DATUM_TYPE"] = text2path(jsonlist["DATUM_TYPE"])
		if(!ispath(jsonlist["DATUM_TYPE"]))
			return
	if(target_type)
		if(!ispath(target_type))
			return
		if(strict_target_type)
			if(target_type != jsonlist["DATUM_TYPE"])
				return
		else if(!ispath(jsonlist["DATUM_TYPE"], target_type))
			return
	var/typeofdatum = jsonlist["DATUM_TYPE"]			//BYOND won't directly read if this is just put in the line below, and will instead runtime because it thinks you're trying to make a new list?
	var/datum/D = new typeofdatum
	var/datum/returned = D.deserialize_list(jsonlist, options)
	if(!istype(returned, /datum))
		qdel(D)
	else
		return returned

/**
  * Callback called by a timer to end an associative-list-indexed cooldown.
  *
  * Arguments:
  * * source - datum storing the cooldown
  * * index - string index storing the cooldown on the cooldowns associative list
  *
  * This sends a signal reporting the cooldown end.
  */
/proc/end_cooldown(datum/source, index)
	if(QDELETED(source))
		return
	SEND_SIGNAL(source, COMSIG_CD_STOP(index))
	TIMER_COOLDOWN_END(source, index)


/**
  * Proc used by stoppable timers to end a cooldown before the time has ran out.
  *
  * Arguments:
  * * source - datum storing the cooldown
  * * index - string index storing the cooldown on the cooldowns associative list
  *
  * This sends a signal reporting the cooldown end, passing the time left as an argument.
  */
/proc/reset_cooldown(datum/source, index)
	if(QDELETED(source))
		return
	SEND_SIGNAL(source, COMSIG_CD_RESET(index), S_TIMER_COOLDOWN_TIMELEFT(source, index))
	TIMER_COOLDOWN_END(source, index)

/// Returns whether a type is an abstract type.
/proc/is_abstract(datum/datum_type)
	return (initial(datum_type.abstract_type) == datum_type)

// ============================================================================ //
// DISEASE SYSTEM - Contact-based transmission with probabilistic infection   //
// ============================================================================ //
// Disease System Defines (from code/__DEFINES/diseases.dm)
#define DISEASE_LIMIT 1
#define VIRUS_SYMPTOM_LIMIT 6

//Visibility Flags
#define HIDDEN_SCANNER (1<<0)
#define HIDDEN_PANDEMIC (1<<1)

//Disease Flags
#define CURABLE (1<<0)
#define CAN_CARRY (1<<1)
#define CAN_RESIST (1<<2)

//Spread Flags
#define DISEASE_SPREAD_SPECIAL (1<<0)
#define DISEASE_SPREAD_NON_CONTAGIOUS (1<<1)
#define DISEASE_SPREAD_BLOOD (1<<2)
#define DISEASE_SPREAD_CONTACT_FLUIDS (1<<3)
#define DISEASE_SPREAD_CONTACT_SKIN (1<<4)
#define DISEASE_SPREAD_AIRBORNE (1<<5)

//Severity Defines
/// Diseases that buff, heal, or at least do nothing at all
#define DISEASE_SEVERITY_POSITIVE "Positive"
/// Diseases that may have annoying effects, but nothing disruptive (sneezing)
#define DISEASE_SEVERITY_NONTHREAT "Harmless"
/// Diseases that can annoy in concrete ways (dizziness)
#define DISEASE_SEVERITY_MINOR "Minor"
/// Diseases that can do minor harm, or severe annoyance (vomit)
#define DISEASE_SEVERITY_MEDIUM "Medium"
/// Diseases that can do significant harm, or severe disruption (brainrot)
#define DISEASE_SEVERITY_HARMFUL "Harmful"
/// Diseases that can kill or maim if left untreated (flesh eating, blindness)
#define DISEASE_SEVERITY_DANGEROUS "Dangerous"
/// Diseases that can quickly kill an unprepared victim (fungal tb, gbs)
#define DISEASE_SEVERITY_BIOHAZARD "BIOHAZARD"

/datum/disease
	//Flags
	var/visibility_flags = 0
	var/disease_flags = CURABLE|CAN_CARRY|CAN_RESIST
	var/spread_flags = DISEASE_SPREAD_AIRBORNE | DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN

	//Fluff
	var/form = "Virus"
	var/name = "No disease"
	var/desc = ""
	var/agent = "some microbes"
	var/spread_text = ""
	var/cure_text = ""

	//Stages
	var/stage = 1
	var/max_stages = 0
	var/stage_prob = 2

	//Other
	var/list/viable_mobtypes = list()
	var/mob/living/carbon/affected_mob = null
	var/list/cures = list()
	var/infectivity = 41
	var/cure_chance = 4
	var/carrier = FALSE
	var/bypasses_immunity = FALSE
	var/permeability_mod = 1
	var/severity = DISEASE_SEVERITY_NONTHREAT
	var/list/required_organs = list()
	var/needs_all_cures = TRUE
	var/list/strain_data = list()
	var/infectable_biotypes = MOB_ORGANIC
	var/process_dead = FALSE
	var/copy_type = null

/datum/disease/Destroy()
	. = ..()
	if(affected_mob)
		remove_disease()
	// Note: SSdisease tracking removed due to compile-time ordering

/datum/disease/proc/try_infect(mob/living/infectee, make_copy = TRUE)
	infect(infectee, make_copy)
	return TRUE

/datum/disease/proc/infect(mob/living/infectee, make_copy = TRUE)
	var/datum/disease/D = make_copy ? Copy() : src
	LAZYADD(infectee.diseases, D)
	D.affected_mob = infectee
	// Note: SSdisease tracking removed due to compile-time ordering
	D.after_add()
	var/turf/source_turf = get_turf(infectee)
	log_virus("[key_name(infectee)] was infected by virus: [src.admin_details()] at [loc_name(source_turf)]")

/datum/disease/proc/admin_details()
	return "[src.name] : [src.type]"

/datum/disease/proc/stage_act(delta_time, times_fired)
	if(has_cure())
		if(DT_PROB(cure_chance, delta_time))
			update_stage(max(stage - 1, 1))
		if(disease_flags & CURABLE && DT_PROB(cure_chance, delta_time))
			cure()
			return FALSE
	else if(DT_PROB(stage_prob, delta_time))
		update_stage(min(stage + 1, max_stages))
	return !carrier

/datum/disease/proc/update_stage(new_stage)
	stage = new_stage

/datum/disease/proc/has_cure()
	if(!(disease_flags & CURABLE))
		return FALSE
	. = cures.len
	for(var/C_id in cures)
		if(!affected_mob.reagents.has_reagent(C_id))
			.--
	if(!. || (needs_all_cures && . < cures.len))
		return FALSE

/datum/disease/proc/spread(force_spread = 0)
	if(!affected_mob)
		return
	if(!(spread_flags & DISEASE_SPREAD_AIRBORNE) && !force_spread)
		return
	if(affected_mob.satiety > 0 && prob(affected_mob.satiety/10))
		return
	var/spread_range = 2
	if(force_spread)
		spread_range = force_spread
	var/turf/T = affected_mob.loc
	if(istype(T))
		for(var/mob/living/carbon/C in oview(spread_range, affected_mob))
			var/turf/V = get_turf(C)
			if(disease_air_spread_walk(T, V))
				C.AirborneContractDisease(src, force_spread)

/proc/disease_air_spread_walk(turf/start, turf/end)
	if(!start || !end)
		return FALSE
	while(TRUE)
		if(end == start)
			return TRUE
		var/turf/Temp = get_step_towards(end, start)
		end = Temp

/datum/disease/proc/cure(add_resistance = TRUE)
	if(affected_mob)
		if(add_resistance && (disease_flags & CAN_RESIST))
			affected_mob.add_disease_resistance(GetDiseaseID(), 10 MINUTES)
	qdel(src)

/datum/disease/proc/IsSame(datum/disease/D)
	if(istype(D, type))
		return TRUE
	return FALSE

/datum/disease/proc/Copy()
	var/static/list/copy_vars = list("name", "visibility_flags", "disease_flags", "spread_flags", "form", "desc", "agent", "spread_text",
									"cure_text", "max_stages", "stage_prob", "viable_mobtypes", "cures", "infectivity", "cure_chance",
									"bypasses_immunity", "permeability_mod", "severity", "required_organs", "needs_all_cures", "strain_data",
									"infectable_biotypes", "process_dead")
	var/datum/disease/D = copy_type ? new copy_type() : new type()
	for(var/V in copy_vars)
		var/val = vars[V]
		if(islist(val))
			var/list/L = val
			val = L.Copy()
		D.vars[V] = val
	return D

/datum/disease/proc/after_add()
	return

/datum/disease/proc/GetDiseaseID()
	return "[type]"

/datum/disease/proc/remove_disease()
	LAZYREMOVE(affected_mob.diseases, src)
	affected_mob = null

/datum/disease/proc/is_viable_mobtype(mob_type)
	if(!length(viable_mobtypes))
		return TRUE
	for(var/viable_type in viable_mobtypes)
		if(ispath(mob_type, viable_type))
			return TRUE
	if(!ispath(mob_type))
		stack_trace("Non-path argument passed to mob_type variable: [mob_type]")
	return FALSE

/proc/get_disease_severity_value(severity)
	switch(severity)
		if(DISEASE_SEVERITY_POSITIVE)
			return 1
		if(DISEASE_SEVERITY_NONTHREAT)
			return 2
		if(DISEASE_SEVERITY_MINOR)
			return 3
		if(DISEASE_SEVERITY_MEDIUM)
			return 4
		if(DISEASE_SEVERITY_HARMFUL)
			return 5
		if(DISEASE_SEVERITY_DANGEROUS)
			return 6
		if(DISEASE_SEVERITY_BIOHAZARD)
			return 7

// MOB PROCS FOR DISEASE INFECTION AND TRANSMISSION

/mob/living/proc/HasDisease(datum/disease/D)
	for(var/thing in diseases)
		var/datum/disease/DD = thing
		if(D.IsSame(DD))
			return TRUE
	return FALSE

/mob/living/proc/add_disease_resistance(disease_id, duration)
	if(!disease_id || !duration)
		return
	if(!disease_resistances)
		disease_resistances = list()
	var/expire_at = world.time + duration
	disease_resistances[disease_id] = expire_at

/mob/living/proc/expire_disease_resistance(disease_id, expected_expire_at)
	if(!disease_resistances)
		return
	if(disease_resistances[disease_id] == expected_expire_at)
		disease_resistances.Remove(disease_id)

/mob/living/proc/CanContractDisease(datum/disease/D)
	if(stat == DEAD && !D.process_dead)
		return FALSE
	if(!mind)
		return FALSE
	var/disease_id = D.GetDiseaseID()
	if(disease_id in disease_resistances)
		var/expire_at = disease_resistances[disease_id]
		if(isnum(expire_at) && expire_at <= world.time)
			disease_resistances.Remove(disease_id)
		else
			return FALSE
	if(HasDisease(D))
		return FALSE
	if(!(D.infectable_biotypes & mob_biotypes))
		return FALSE
	if(!D.is_viable_mobtype(type))
		return FALSE
	return TRUE

/mob/living/proc/ContactContractDisease(datum/disease/D)
	if(!CanContractDisease(D))
		return FALSE
	D.try_infect(src)

/mob/living/carbon/ContactContractDisease(datum/disease/D, target_zone)
	if(!CanContractDisease(D))
		return FALSE
	if(prob(15/D.permeability_mod))
		return
	if(satiety > 0 && prob(satiety / 10))
		return
	D.try_infect(src)

/mob/living/proc/SpreadContactDiseasesOnContact(mob/living/carbon/target, chance = 0)
	if(!target || !length(diseases))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_PLAGUE_MASK_WORN))
		return FALSE
	var/contact_flags = (DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN)
	for(var/thing in diseases)
		var/datum/disease/D = thing
		if(!(D.spread_flags & contact_flags))
			continue
		var/spread_chance = chance
		// Per-disease contact spread chances
		if(istype(D, /datum/disease/grime_flu))
			if(D.stage == 1)
				spread_chance = 100
			else
				spread_chance = 50
		if(istype(D, /datum/disease/flu))
			if(D.stage == 1)
				spread_chance = 100
			else
				spread_chance = 50
		if(istype(D, /datum/disease/ash_blight))
			spread_chance = 50
		if(istype(D, /datum/disease/derma_tick))
			spread_chance = 50
		if(istype(D, /datum/disease/flash_frenzy))
			spread_chance = 2
		if(spread_chance > 0 && !prob(spread_chance))
			continue
		target.ForceContractDisease(D, TRUE, FALSE)
	return TRUE

/mob/living/proc/SpreadContactDiseasesOnGrab(mob/living/carbon/target, chance = 0)
	return SpreadContactDiseasesOnContact(target, chance)

/mob/living/proc/AirborneContractDisease(datum/disease/D, force_spread)
	if(((D.spread_flags & DISEASE_SPREAD_AIRBORNE) || force_spread) && prob((50*D.permeability_mod) - 1))
		ForceContractDisease(D)

/mob/living/carbon/AirborneContractDisease(datum/disease/D, force_spread)
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return
	..()

/mob/living/proc/ForceContractDisease(datum/disease/D, make_copy = TRUE, del_on_fail = FALSE)
	if(!CanContractDisease(D))
		if(del_on_fail)
			qdel(D)
		return FALSE
	if(!D.try_infect(src, make_copy))
		if(del_on_fail)
			qdel(D)
		return FALSE
	return TRUE

/mob/living/carbon/human/CanContractDisease(datum/disease/D)
	if(dna)
		if(HAS_TRAIT(src, TRAIT_VIRUSIMMUNE) && !D.bypasses_immunity)
			return FALSE
	for(var/thing in D.required_organs)
		if(!((locate(thing) in bodyparts) || (locate(thing) in internal_organs)))
			return FALSE
	return ..()

/mob/living/proc/CanSpreadAirborneDisease()
	return !is_mouth_covered()

/mob/living/carbon/CanSpreadAirborneDisease()
	return !is_mouth_covered()

// Custom diseases moved to modular_twilight_axis/code/datums/diseases/
// This includes: grime_flu.dm, flu.dm, ash_blight.dm
