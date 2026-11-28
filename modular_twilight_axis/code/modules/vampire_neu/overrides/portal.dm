/obj/structure/vampire/portalmaker
	var/list/rift_ends = list()
	var/rift_zone_name
	var/rift_close_time = 0
	var/rift_timer

/obj/structure/vampire/portalmaker/Destroy()
	close_rift()
	return ..()

/obj/structure/vampire/portalmaker/attack_hand(mob/living/user)
	. = TRUE
	if(!can_use_rift(user))
		to_chat(user, span_warning("Обелиск холоден под моей рукой."))
		return
	ui_interact(user)

/obj/structure/vampire/portalmaker/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/vampire/portalmaker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VampireRiftGate", "Врата разлома")
		ui.open()

/obj/structure/vampire/portalmaker/ui_static_data(mob/user)
	var/list/data = list()
	var/list/zones = list()
	for(var/area/rogue/zone in GLOB.sortedAreas)
		if(zone.town_area && !zone.hidden)
			zones |= zone.name
	data["zones"] = zones
	data["vitaeCost"] = TA_RIFT_VITAE_COST
	data["sightCost"] = TA_RIFT_SIGHT_COST
	data["riftDuration"] = TA_RIFT_DURATION / (1 SECONDS)
	return data

/obj/structure/vampire/portalmaker/ui_data(mob/user)
	var/list/data = list()
	var/list/amulets = list()
	for(var/obj/item/clothing/neck/portalamulet/amulet in GLOB.vampire_objects)
		var/turf/anchor = get_rift_anchor(amulet)
		if(!anchor)
			continue
		UNTYPED_LIST_ADD(amulets, list(
			"ref" = REF(amulet),
			"name" = amulet.name,
			"area" = get_area_name(anchor, TRUE),
			"uses" = amulet.uses,
		))
	var/mob/living/living_user = user
	data["amulets"] = amulets
	data["hasVitae"] = istype(living_user) && living_user.has_bloodpool_cost(TA_RIFT_VITAE_COST)
	data["riftZone"] = rift_zone_name
	data["riftSecondsLeft"] = rift_zone_name ? max(round((rift_close_time - world.time) / (1 SECONDS)), 0) : 0
	return data

/obj/structure/vampire/portalmaker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || ui.status != UI_INTERACTIVE)
		return

	var/mob/living/user = ui.user
	if(!can_use_rift(user))
		return

	switch(action)
		if("open_zone")
			var/zone_name = params["zone"]
			var/list/zone_areas = get_town_zone_areas(zone_name)
			if(!length(zone_areas))
				return
			open_rift(user, zone_areas, zone_name)
		if("open_amulet")
			var/obj/item/clothing/neck/portalamulet/amulet = locate(params["amulet"])
			if(!istype(amulet) || !(amulet in GLOB.vampire_objects))
				return
			var/turf/anchor = get_rift_anchor(amulet)
			if(!anchor)
				return
			var/area/anchor_area = get_area(anchor)
			open_rift(user, list(anchor_area), anchor_area.name, anchor)
		if("close_rift")
			if(length(rift_ends))
				close_rift()

/obj/structure/vampire/portalmaker/proc/can_use_rift(mob/living/user)
	var/mob/living/carbon/human/vampire = user
	return istype(vampire) && vampire.clan && !!vampire.mind?.has_antag_datum(/datum/antagonist/vampire)

/obj/structure/vampire/portalmaker/proc/get_town_zone_areas(zone_name)
	var/list/zone_areas = list()
	if(!istext(zone_name))
		return zone_areas
	for(var/area/rogue/zone in GLOB.sortedAreas)
		if(zone.town_area && !zone.hidden && zone.name == zone_name)
			zone_areas += zone
	return zone_areas

/obj/structure/vampire/portalmaker/proc/can_pay_for_rift(mob/living/user)
	if(length(rift_ends))
		to_chat(user, span_warning("Разлом уже открыт."))
		return FALSE
	if(!user.has_bloodpool_cost(TA_RIFT_VITAE_COST))
		to_chat(user, span_warning("Это стоит [TA_RIFT_VITAE_COST] витэ. Мне не хватает."))
		return FALSE
	return TRUE

/obj/structure/vampire/portalmaker/proc/open_rift(mob/living/user, list/zone_areas, zone_name, turf/arrival)
	if(!can_pay_for_rift(user))
		return FALSE
	if(!get_rift_home() || !length(get_rift_mouths()))
		to_chat(user, span_warning("Разлому не за что зацепиться в моих владениях."))
		return FALSE

	user.visible_message(span_warning("[user] начинает призывать разлом."), span_notice("Я начинаю призывать разлом."))
	if(!do_after(user, 3 SECONDS, target = src))
		return FALSE
	if(QDELETED(src) || QDELETED(user) || !user.client || !can_use_rift(user) || !can_pay_for_rift(user))
		return FALSE

	if(!arrival)
		arrival = pick_rift_arrival(zone_areas)
	if(!arrival)
		to_chat(user, span_warning("Разлому негде раскрыться: [zone_name]."))
		return FALSE

	SStgui.close_user_uis(user, src)
	var/mob/dead/observer/eye/arcane/rift/eye = user.make_observer(/mob/dead/observer/eye/arcane/rift)
	if(!eye)
		return FALSE
	user.adjust_bloodpool(-TA_RIFT_SIGHT_COST)
	eye.bind_rift(user, src, zone_areas, zone_name, arrival)
	eye.key = user.key
	return TRUE

/obj/structure/vampire/portalmaker/proc/finish_rift(mob/dead/observer/eye/arcane/rift/eye, turf/destination)
	var/mob/living/user = eye.seer
	if(!rift_can_open_at(destination, eye.scry_center_turf, eye.zone_areas))
		to_chat(eye, span_warning("Здесь разлом не раскроется."))
		return FALSE
	if(length(rift_ends))
		to_chat(eye, span_warning("Разлом уже открыт."))
		return FALSE
	var/turf/home = get_rift_home()
	var/list/mouths = get_rift_mouths()
	if(QDELETED(user) || user.stat == DEAD || get_dist(user, src) > 1 || !user.has_bloodpool_cost(TA_RIFT_OPEN_COST) || !home || !length(mouths))
		to_chat(eye, span_warning("Разлом рушится, не успев раскрыться."))
		eye.return_from_rift()
		return FALSE

	var/zone_name = eye.zone_name
	eye.return_from_rift()
	user.adjust_bloodpool(-TA_RIFT_OPEN_COST)
	tear_rift(destination, home, mouths, zone_name)
	user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
	SStgui.update_uis(src)
	return TRUE

/obj/structure/vampire/portalmaker/proc/tear_rift(turf/destination, turf/home, list/mouths, zone_name)
	var/turf/landing = get_rift_landing(destination)
	for(var/turf/mouth as anything in mouths)
		rift_ends += new /obj/structure/vampire/rift(mouth, src, landing)
	rift_ends += new /obj/structure/vampire/rift/homeward(destination, src, home)
	rift_zone_name = zone_name
	rift_close_time = world.time + TA_RIFT_DURATION
	deltimer(rift_timer)
	rift_timer = addtimer(CALLBACK(src, PROC_REF(close_rift)), TA_RIFT_DURATION, TIMER_STOPPABLE)

/obj/structure/vampire/portalmaker/proc/close_rift()
	deltimer(rift_timer)
	rift_timer = null
	rift_zone_name = null
	rift_close_time = 0
	var/list/closing = rift_ends.Copy()
	rift_ends.Cut()
	for(var/obj/structure/vampire/rift/rift_end as anything in closing)
		if(QDELETED(rift_end))
			continue
		rift_end.visible_message(span_boldnotice("[rift_end] содрогается и стремительно смыкается."))
		qdel(rift_end)
	SStgui.update_uis(src)

/obj/structure/vampire/portalmaker/proc/get_rift_home()
	for(var/obj/effect/landmark/vteleport/home in GLOB.landmarks_list)
		return get_turf(home)
	return null

/obj/structure/vampire/portalmaker/proc/get_rift_mouths()
	var/list/mouths = list()
	for(var/obj/effect/landmark/vteleportsending/mouth in GLOB.landmarks_list)
		mouths += get_turf(mouth)
	return mouths

/obj/structure/vampire/portalmaker/proc/get_rift_landing(turf/destination)
	var/list/landings = list()
	for(var/direction in GLOB.cardinals)
		var/turf/landing = get_step(destination, direction)
		if(landing && get_area(landing) == get_area(destination) && is_rift_footing(landing))
			landings += landing
	return length(landings) ? pick(landings) : destination

/obj/structure/vampire/portalmaker/proc/pick_rift_arrival(list/zone_areas)
	var/list/candidates = list()
	for(var/area/zone as anything in zone_areas)
		for(var/turf/zone_turf in zone)
			candidates += zone_turf
	for(var/turf/candidate as anything in shuffle(candidates))
		if(rift_can_open_at(candidate, candidate, zone_areas))
			return candidate
	return null

/obj/structure/vampire/portalmaker/proc/is_rift_forbidden(area/zone)
	return !zone || zone.hidden || zone.noteleport || istype(zone, /area/rogue/indoors/ravoxarena)

/obj/structure/vampire/portalmaker/proc/get_rift_anchor(obj/item/clothing/neck/portalamulet/amulet)
	if(amulet.uses <= 0)
		return null
	var/turf/anchor = get_turf(amulet)
	if(!anchor || is_rift_forbidden(get_area(anchor)))
		return null
	return anchor

/obj/structure/vampire/portalmaker/proc/is_rift_footing(turf/spot)
	return !istransparentturf(spot) && !islava(spot) && !spot.is_blocked_turf(TRUE)

/obj/structure/vampire/portalmaker/proc/rift_can_open_at(turf/destination, turf/anchor, list/zone_areas)
	if(!istype(destination) || !istype(anchor) || destination.z != anchor.z || get_dist(destination, anchor) > TA_RIFT_PLACEMENT_RANGE)
		return FALSE
	var/area/destination_area = get_area(destination)
	if(is_rift_forbidden(destination_area) || !(destination_area in zone_areas))
		return FALSE
	if(!is_rift_footing(destination))
		return FALSE
	return !(locate(/obj/structure/vampire/rift) in destination)

/obj/structure/vampire/rift
	name = "жуткий разлом"
	desc = "Рана в самой ткани мира. Из неё тянет холодом и медью."
	icon_state = "portal"
	density = FALSE
	var/obj/structure/vampire/portalmaker/gate
	var/turf/exit

/obj/structure/vampire/rift/Initialize(mapload, obj/structure/vampire/portalmaker/rift_gate, turf/rift_exit)
	. = ..()
	gate = rift_gate
	exit = rift_exit
	set_light(3, 2, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)
	playsound(loc, 'sound/misc/portalopen.ogg', 100, FALSE, pressure_affected = FALSE)
	visible_message(span_boldnotice("Раздаётся тошнотворный треск, и в воздухе раскрывается зловещий разлом."))

/obj/structure/vampire/rift/Destroy()
	var/obj/structure/vampire/portalmaker/rift_gate = gate
	gate = null
	exit = null
	if(rift_gate)
		rift_gate.rift_ends -= src
		if(rift_gate.rift_zone_name && !length(rift_gate.rift_ends))
			rift_gate.close_rift()
	return ..()

/obj/structure/vampire/rift/Crossed(atom/movable/AM, oldloc)
	. = ..()
	var/mob/living/traveler = AM
	if(!istype(traveler) || traveler.buckled || !exit)
		return
	var/turf/came_from = get_turf(oldloc)
	if(came_from && get_dist(came_from, src) > 1)
		return
	if(!can_pass(traveler))
		to_chat(traveler, span_warning("Без амулета врат на шее разлом меня не понесёт."))
		return
	if(!get_worn_gate_amulet(traveler))
		to_chat(traveler, span_warning("Без амулета врат на шее разлом не вернёт меня назад."))
	addtimer(CALLBACK(src, PROC_REF(begin_passage), traveler), 1)

/obj/structure/vampire/rift/proc/can_pass(mob/living/traveler)
	return TRUE

/obj/structure/vampire/rift/proc/get_worn_gate_amulet(mob/living/traveler)
	var/obj/item/clothing/neck/portalamulet/amulet = traveler.get_item_by_slot(SLOT_NECK)
	if(!istype(amulet) || amulet.uses <= 0)
		return null
	return amulet

/obj/structure/vampire/rift/proc/begin_passage(mob/living/traveler)
	if(QDELETED(traveler) || traveler.loc != loc || !do_after(traveler, TA_RIFT_PASSAGE_TIME, FALSE, src))
		return
	if(QDELETED(src) || !exit || QDELETED(traveler) || traveler.loc != loc || traveler.buckled || !can_pass(traveler))
		return
	var/obj/item/clothing/neck/portalamulet/amulet = get_worn_gate_amulet(traveler)
	carry_through(traveler)
	pay_passage(amulet)

/obj/structure/vampire/rift/proc/pay_passage(obj/item/clothing/neck/portalamulet/amulet)
	return

/obj/structure/vampire/rift/proc/carry_through(mob/living/traveler)
	var/list/carried = traveler.buckled_mobs ? traveler.buckled_mobs.Copy() : list()
	var/mob/living/gripped = traveler.pulling
	playsound(loc, 'sound/misc/portalenter.ogg', 100, FALSE, pressure_affected = FALSE)
	traveler.stop_pulling()
	traveler.forceMove(exit)
	for(var/mob/living/passenger as anything in carried)
		if(QDELETED(passenger))
			continue
		passenger.forceMove(exit)
		if(passenger.buckled != traveler)
			traveler.buckle_mob(passenger, TRUE, TRUE, 90, 0, 0)
	if(gripped in carried)
		traveler.start_pulling(gripped, supress_message = TRUE)

/obj/structure/vampire/rift/homeward/can_pass(mob/living/traveler)
	return !!get_worn_gate_amulet(traveler)

/obj/structure/vampire/rift/homeward/pay_passage(obj/item/clothing/neck/portalamulet/amulet)
	amulet?.spend_charge()

/obj/item/clothing/neck/portalamulet
	name = "амулет врат"
	desc = "Сгусток кристаллизованной крови на шнуре. Надетый на шею, он позволяет Вратам разлома вернуть домой хозяина и того, кого тот несёт на плече."
	uses = TA_GATE_AMULET_CHARGES

/obj/item/clothing/neck/portalamulet/examine(mob/user)
	. = ..()
	. += span_notice("Осталось возвращений: [uses].")

/obj/item/clothing/neck/portalamulet/proc/spend_charge()
	uses--
	if(uses > 0)
		return
	visible_message(span_warning("[src] рассыпается!"))
	qdel(src)

/mob/dead/observer/eye/arcane/rift
	limited_scry = TRUE
	scry_range = TA_RIFT_PLACEMENT_RANGE
	scry_verbs = list(
		/mob/dead/observer/eye/arcane/rift/proc/open_rift_here,
		/mob/dead/observer/eye/arcane/rift/proc/return_from_rift,
	)
	var/mob/living/seer
	var/obj/structure/vampire/portalmaker/gate
	var/list/zone_areas
	var/zone_name
	var/list/image/placement_images = list()
	var/client/placement_viewer
	var/sight_timer

/mob/dead/observer/eye/arcane/rift/Initialize(mapload)
	. = ..()
	remove_verb(src, list(
		/mob/dead/observer/proc/dead_tele,
		/mob/dead/observer/proc/open_spawners_menu,
		/mob/dead/observer/proc/tray_view,
	))
	name = "Взор разлома"

/mob/dead/observer/eye/arcane/rift/Destroy()
	hide_placement()
	deltimer(sight_timer)
	sight_timer = null
	seer = null
	gate = null
	zone_areas = null
	scry_center_turf = null
	return ..()

/mob/dead/observer/eye/arcane/rift/proc/bind_rift(mob/living/body, obj/structure/vampire/portalmaker/rift_gate, list/rift_zone_areas, rift_zone_name, turf/arrival)
	seer = body
	gate = rift_gate
	zone_areas = rift_zone_areas
	zone_name = rift_zone_name
	scry_center_turf = arrival
	RegisterSignal(body, COMSIG_PARENT_QDELETING, PROC_REF(on_seer_deleted))
	RegisterSignal(rift_gate, COMSIG_PARENT_QDELETING, PROC_REF(on_gate_deleted))
	forceMove(arrival)
	sight_timer = addtimer(CALLBACK(src, PROC_REF(return_from_rift)), TA_RIFT_SIGHT_DURATION, TIMER_STOPPABLE)

/mob/dead/observer/eye/arcane/rift/proc/on_seer_deleted(datum/source)
	SIGNAL_HANDLER
	seer = null

/mob/dead/observer/eye/arcane/rift/proc/on_gate_deleted(datum/source)
	SIGNAL_HANDLER
	gate = null
	INVOKE_ASYNC(src, PROC_REF(return_from_rift))

/mob/dead/observer/eye/arcane/rift/forceMove(atom/destination)
	if(scry_center_turf)
		var/turf/target_turf = get_turf(destination)
		if(!target_turf || target_turf.z != scry_center_turf.z || get_dist(target_turf, scry_center_turf) > scry_range)
			return FALSE
	return ..()

/mob/dead/observer/eye/arcane/rift/Login()
	. = ..()
	show_placement()
	to_chat(src, span_notice("Мой взор входит в [zone_name]. Отсюда я могу отойти на [scry_range] шага. За взор ушло [TA_RIFT_SIGHT_COST] витэ, разлом возьмёт ещё [TA_RIFT_OPEN_COST]. <b>Открыть разлом здесь</b> рвёт мир там, где я стою, <b>Вернуться в тело</b> отказывается от затеи."))

/mob/dead/observer/eye/arcane/rift/Logout()
	hide_placement()
	return ..()

/mob/dead/observer/eye/arcane/rift/proc/show_placement()
	hide_placement()
	if(!client || !scry_center_turf || !gate)
		return
	for(var/turf/marked in range(scry_range + 1, scry_center_turf))
		var/can_open = gate.rift_can_open_at(marked, scry_center_turf, zone_areas)
		var/image/marker = image('icons/turf/overlays.dmi', marked, can_open ? "greenOverlay" : "redOverlay")
		marker.plane = ABOVE_LIGHTING_PLANE
		marker.alpha = 100
		placement_images += marker
	placement_viewer = client
	client.images += placement_images

/mob/dead/observer/eye/arcane/rift/proc/hide_placement()
	if(placement_viewer)
		placement_viewer.images -= placement_images
	placement_viewer = null
	placement_images.Cut()

/mob/dead/observer/eye/arcane/rift/proc/open_rift_here()
	set category = "RoleUnique.Arcane Eye"
	set name = "Открыть разлом здесь"

	if(QDELETED(gate))
		return_from_rift()
		return
	gate.finish_rift(src, get_turf(src))

/mob/dead/observer/eye/arcane/rift/proc/return_from_rift()
	set category = "RoleUnique.Arcane Eye"
	set name = "Вернуться в тело"

	if(QDELETED(src))
		return
	hide_placement()
	deltimer(sight_timer)
	sight_timer = null
	if(key && !(client && reenter_corpse()) && !take_back_body())
		ghostize(FALSE)
	qdel(src)

/mob/dead/observer/eye/arcane/rift/proc/take_back_body()
	if(QDELETED(seer) || (seer.key && seer.key[1] != "@"))
		return FALSE
	seer.key = key
	return TRUE
