// TA: Planar convergence matrix (teleport rune), restored from Ratwood-2.0 and reworked.
// Chalk-drawn runes share one public network. Runes carved with an arcyne silver dagger
// go into a private network owned by that specific dagger.

/// Name -> rune network used by teleport runes.
/datum/ta_teleport_network
	/// Plain (not html-encoded) rune name -> rune
	var/list/runes = list()

/// Registers a rune under a unique name; returns the name actually used.
/datum/ta_teleport_network/proc/register_rune(obj/effect/decal/cleanable/roguerune/arcyne/teleport/rune, desired_name)
	var/base_name = desired_name
	var/final_name = base_name
	var/suffix = 1
	while(name_taken(final_name))
		suffix++
		final_name = "[base_name] ([suffix])"
	runes[final_name] = rune
	return final_name

/datum/ta_teleport_network/proc/name_taken(check_name)
	var/lowered = lowertext(check_name)
	for(var/existing in runes)
		if(lowertext(existing) == lowered)
			return TRUE
	return FALSE

/datum/ta_teleport_network/proc/unregister_rune(obj/effect/decal/cleanable/roguerune/arcyne/teleport/rune)
	for(var/existing in runes)
		if(runes[existing] == rune)
			runes -= existing
			return

/// Returns a sorted name -> rune list of usable destinations, excluding `exclude`.
/datum/ta_teleport_network/proc/get_destinations(obj/effect/decal/cleanable/roguerune/arcyne/teleport/exclude)
	var/list/destinations = list()
	for(var/existing in runes)
		var/obj/effect/decal/cleanable/roguerune/arcyne/teleport/rune = runes[existing]
		if(rune == exclude || QDELETED(rune) || !isturf(rune.loc))
			continue
		destinations[existing] = rune
	return sortList(destinations)

/// Public network for chalk-drawn runes.
GLOBAL_DATUM_INIT(ta_public_teleport_network, /datum/ta_teleport_network, new)

// ---------------------------------------------------------------------------
// Arcyne silver dagger: owns a private network, marks itself while scribing.
// ---------------------------------------------------------------------------

/obj/item/rogueweapon/huntingknife/idagger/steel/silver/arcyne
	/// Private network for runes carved by this dagger. Datum ref only: runes never reference the dagger.
	var/datum/ta_teleport_network/ta_teleport_network
	/// TRUE only while this dagger's attack_self (scribing) is running.
	var/ta_scribing = FALSE

/obj/item/rogueweapon/huntingknife/idagger/steel/silver/arcyne/proc/get_ta_teleport_network()
	if(!ta_teleport_network)
		ta_teleport_network = new /datum/ta_teleport_network
	return ta_teleport_network

/obj/item/rogueweapon/huntingknife/idagger/steel/silver/arcyne/attack_self(mob/living/carbon/human/user)
	ta_scribing = TRUE
	. = ..()
	ta_scribing = FALSE

/obj/item/rogueweapon/huntingknife/idagger/steel/silver/arcyne/Destroy()
	ta_teleport_network = null // runes keep the network alive among themselves
	return ..()

// ---------------------------------------------------------------------------
// Public teleport rune (chalk)
// ---------------------------------------------------------------------------

/obj/effect/decal/cleanable/roguerune/arcyne/teleport
	name = "planar convergence matrix"
	desc = "A large spiraling sigil that seems to thrum with power."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "portal"
	tier = 2
	runesize = 2
	pixel_x = -64 // 160x160 sprite centered on the tile
	pixel_y = -64
	pixel_z = 0
	invocation = "Xel'tharr un'korel!"
	req_keyword = TRUE // chalk/dagger ask for a keyword before scribing; it becomes the rune's name
	can_be_scribed = TRUE
	/// Network this rune belongs to
	var/datum/ta_teleport_network/network
	/// Unique (within network) plain-text name of this rune
	var/rune_name
	/// Resources consumed per teleport, placed within the circle
	var/list/teleport_cost = list(/obj/item/magic/artifact = 1, /obj/item/magic/leyline = 1)
	/// Time to channel the teleport
	var/channel_time = 5 SECONDS

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/Initialize(mapload, set_keyword)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	// Carved with an arcyne silver dagger -> become the sealed (private) variant instead.
	if(!mapload && type == /obj/effect/decal/cleanable/roguerune/arcyne/teleport)
		var/obj/item/rogueweapon/huntingknife/idagger/steel/silver/arcyne/dagger = find_scribing_dagger()
		if(dagger)
			new /obj/effect/decal/cleanable/roguerune/arcyne/teleport/sealed(loc, set_keyword, dagger.get_ta_teleport_network())
			return INITIALIZE_HINT_QDEL
	if(!network)
		network = GLOB.ta_public_teleport_network
	rune_name = network.register_rune(src, sanitize_rune_name(set_keyword))

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/Destroy()
	network?.unregister_rune(src)
	network = null
	return ..()

/// Finds an arcyne dagger currently scribing this rune type, held by someone on our tile.
/obj/effect/decal/cleanable/roguerune/arcyne/teleport/proc/find_scribing_dagger()
	var/turf/T = get_turf(src)
	if(!T)
		return null
	for(var/mob/living/scriber in T)
		for(var/obj/item/rogueweapon/huntingknife/idagger/steel/silver/arcyne/dagger in scriber.held_items)
			if(dagger.ta_scribing && dagger.rune_to_scribe == type)
				return dagger
	return null

/// Turns the (html-encoded) keyword into a plain, trimmed, non-empty name.
/obj/effect/decal/cleanable/roguerune/arcyne/teleport/proc/sanitize_rune_name(raw_name)
	var/clean = raw_name ? html_decode("[raw_name]") : ""
	clean = replacetext(clean, "\n", " ")
	clean = replacetext(clean, "\t", " ")
	clean = trim(clean, MAX_NAME_LEN)
	if(!length(clean))
		var/area/A = get_area(src)
		clean = A ? "[initial(A.name)]" : "nameless convergence"
	return clean

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/examine(mob/user)
	. = ..()
	if(rune_name)
		. += span_notice("The sigils of the circle spell out a name: <b>[html_encode(rune_name)]</b>.")

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Stand within the circle, place [english_list(get_cost_names())] inside it and use the rune with an empty hand to choose a destination.")
	. += span_info("Everyone standing in the circle, alive or dead, and every loose item within it will be carried along. Loose handcarts and chests come along with their contents; furniture and other structures stay behind.")

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/proc/get_cost_names()
	var/list/names = list()
	for(var/atom/path as anything in teleport_cost)
		var/count = teleport_cost[path]
		names += "[count] [initial(path.name)]"
	return names

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/proc/is_within_circle(atom/movable/AM)
	var/turf/our_turf = get_turf(src)
	var/turf/their_turf = get_turf(AM)
	if(!our_turf || !their_turf || our_turf.z != their_turf.z)
		return FALSE
	return get_dist(our_turf, their_turf) <= runesize

/// Collects the cost items in the circle. Fills `missing` with readable names of what is lacking.
/obj/effect/decal/cleanable/roguerune/arcyne/teleport/proc/gather_cost(list/missing)
	var/list/found = list()
	var/list/remaining = teleport_cost.Copy()
	for(var/turf/T in range(runesize, src))
		for(var/obj/item/I in T)
			if(I.item_flags & ABSTRACT)
				continue
			for(var/req_type in remaining)
				if(remaining[req_type] <= 0 || !istype(I, req_type))
					continue
				found += I
				remaining[req_type]--
				break
	for(var/atom/req_type as anything in remaining)
		if(remaining[req_type] > 0)
			missing += "[remaining[req_type]] [initial(req_type.name)]"
	return found

/// Everything that travels: mobs (alive or dead) and loose non-structure objects within the circle.
/obj/effect/decal/cleanable/roguerune/arcyne/teleport/proc/collect_passengers(list/exclude)
	var/list/passengers = list()
	for(var/turf/T in range(runesize, src))
		for(var/atom/movable/AM as anything in T)
			if(AM == src || (AM in exclude))
				continue
			if(ismob(AM))
				if(isliving(AM)) // no ghosts or camera eyes
					passengers += AM
				continue
			if(!isobj(AM))
				continue
			// Handcarts and crates/chests travel (with their contents) unless anchored; other structures stay.
			var/portable_structure = istype(AM, /obj/structure/handcart) || istype(AM, /obj/structure/closet/crate)
			if(!portable_structure && (istype(AM, /obj/structure) || istype(AM, /obj/machinery) || istype(AM, /obj/effect)))
				continue
			var/obj/O = AM
			if(O.anchored || O.invisibility)
				continue
			if(isitem(O))
				var/obj/item/I = O
				if(I.item_flags & ABSTRACT)
					continue
			passengers += O
	return passengers

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/attack_hand(mob/living/user)
	if(!can_use_arcyne_rune(user))
		to_chat(user, span_warning("You aren't able to understand the words of [src]."))
		return TRUE
	if(rune_in_use)
		to_chat(user, span_notice("Someone is already using this rune."))
		return TRUE
	rune_in_use = TRUE
	try_teleport(user)
	if(!QDELETED(src))
		rune_in_use = FALSE
	return TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/proc/try_teleport(mob/living/user)
	if(!is_within_circle(user))
		to_chat(user, span_warning("I must stand within [src] to invoke it."))
		return FALSE
	var/list/missing = list()
	gather_cost(missing)
	if(length(missing))
		to_chat(user, span_hierophant_warning("[src] lacks the components to open the way!"))
		to_chat(user, span_hierophant_warning("Missing: [english_list(missing)]."))
		fail_invoke()
		return FALSE
	if(!network)
		fail_invoke()
		return FALSE
	var/list/destinations = network.get_destinations(src)
	if(!length(destinations))
		to_chat(user, span_warning("[src] finds no other convergence to reach."))
		fail_invoke()
		return FALSE

	var/choice = tgui_input_list(user, "Choose the convergence to travel to", "Planar Convergence", destinations)
	if(!choice || QDELETED(src) || QDELETED(user))
		return FALSE
	var/obj/effect/decal/cleanable/roguerune/arcyne/teleport/destination = network?.runes[choice]
	if(!validate_destination(user, destination))
		return FALSE

	user.visible_message(span_warning("[user] begins to chant, and [src] starts to thrum with power!"), \
		span_notice("I begin to channel [src] towards \"[html_encode(choice)]\"..."))
	user.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
	if(!do_after(user, channel_time, target = src))
		to_chat(user, span_warning("My concentration breaks and the convergence fades."))
		return FALSE
	if(QDELETED(src) || !is_within_circle(user))
		to_chat(user, span_warning("I must stand within the circle!"))
		fail_invoke()
		return FALSE
	if(!validate_destination(user, destination))
		return FALSE
	missing = list()
	var/list/cost_items = gather_cost(missing)
	if(length(missing))
		to_chat(user, span_hierophant_warning("Missing: [english_list(missing)]."))
		fail_invoke()
		return FALSE

	do_teleport_all(user, destination, cost_items)
	return TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/proc/validate_destination(mob/living/user, obj/effect/decal/cleanable/roguerune/arcyne/teleport/destination)
	if(QDELETED(destination) || destination.network != network || !isturf(destination.loc))
		to_chat(user, span_warning("The chosen convergence no longer exists."))
		fail_invoke()
		return FALSE
	var/turf/target = get_turf(destination)
	if(target.is_blocked_turf(TRUE))
		to_chat(user, span_warning("The chosen convergence is blocked. Attempting to travel there would be massively unwise."))
		fail_invoke()
		return FALSE
	return TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/proc/do_teleport_all(mob/living/user, obj/effect/decal/cleanable/roguerune/arcyne/teleport/destination, list/cost_items)
	var/turf/origin = get_turf(src)
	var/turf/target_center = get_turf(destination)
	// Consume the components first so they don't travel along.
	for(var/obj/item/I as anything in cost_items)
		qdel(I)
	var/list/passengers = collect_passengers()
	passengers -= user
	passengers += user // the invoker goes last
	var/moved_any = FALSE
	for(var/atom/movable/AM as anything in passengers)
		if(QDELETED(AM))
			continue
		if(isliving(AM))
			var/mob/living/L = AM
			L.buckled?.unbuckle_mob(L, TRUE)
		var/turf/from = get_turf(AM)
		var/turf/dest = locate(target_center.x + (from.x - origin.x), target_center.y + (from.y - origin.y), target_center.z)
		if(!dest || dest.is_blocked_turf(TRUE))
			dest = target_center
		if(do_teleport(AM, dest, channel = TELEPORT_CHANNEL_MAGIC))
			moved_any = TRUE
	playsound(origin, 'sound/magic/cosmic_expansion.ogg', 50, TRUE)
	playsound(target_center, 'sound/magic/cosmic_expansion.ogg', 50, TRUE)
	if(moved_any)
		visible_message(span_warning("There is a sharp crack of inrushing air, and everything above the rune disappears!"), null, "<i>You hear a sharp crack.</i>")
		destination.visible_message(span_warning("There is a boom of outrushing air as something appears above the rune!"), null, "<i>You hear a boom.</i>")
	if(destination.is_within_circle(user))
		to_chat(user, span_cult("My vision blurs, and with a falling feeling I suddenly appear somewhere else."))
	else
		to_chat(user, span_cult("My vision blurs briefly, but nothing happens."))
	log_game("[key_name(user)] used teleport rune \"[rune_name]\" at [AREACOORD(origin)] to \"[destination.rune_name]\" at [AREACOORD(target_center)] ([length(passengers)] passengers).")
	do_invoke_glow()
	destination.do_invoke_glow()

// ---------------------------------------------------------------------------
// Sealed teleport rune (arcyne silver dagger): private network per dagger
// ---------------------------------------------------------------------------

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/sealed
	name = "sealed planar convergence matrix"
	desc = "A large spiraling sigil carved deep, its lines sealed with quicksilver. It thrums with a guarded power."
	color = GLOW_COLOR_DISPLACEMENT
	can_be_scribed = FALSE // created only by carving the normal matrix with an arcyne silver dagger

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/sealed/Initialize(mapload, set_keyword, datum/ta_teleport_network/dagger_network)
	// Admin-spawned without a dagger -> isolated network of its own, never the public one.
	network = dagger_network || new /datum/ta_teleport_network
	return ..()

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/sealed/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This matrix is sealed: it only connects to matrices carved by the same arcyne silver dagger.")
