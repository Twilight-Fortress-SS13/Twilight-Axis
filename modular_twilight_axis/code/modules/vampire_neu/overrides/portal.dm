#define TA_RIFT_PORTAL_VITAE_COST 1000
#define TA_RIFT_PORTAL_DURATION 3000

/obj/item/clothing/neck/portalamulet/TA
	name = "Кровавый амулет разлома"
	desc = "Носимый якорь разлома, выкованный в багровом горниле."
	uses = 3

/obj/structure/vampire/portalmaker/attack_hand(mob/living/user)
	. = TRUE
	ui_interact(user)

/obj/structure/vampire/portalmaker/ui_state(mob/user)
	return GLOB.tgui_always_state

/obj/structure/vampire/portalmaker/ui_interact(mob/user, datum/tgui/ui)
	var/mob/living/living_user = user
	if(!istype(living_user))
		return
	if(!TA_can_use_rift(living_user, TRUE))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VampireRiftGate", "Врата разлома")
		ui.open()

/obj/structure/vampire/portalmaker/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/living_user = user
	var/is_vampire = TA_can_use_rift(living_user)
	var/list/amulet_data = list()

	if(is_vampire)
		for(var/obj/item/clothing/neck/portalamulet/amulet in GLOB.vampire_objects)
			if(QDELETED(amulet) || amulet.uses <= 0)
				continue
			UNTYPED_LIST_ADD(amulet_data, list(
				"ref" = REF(amulet),
				"name" = amulet.name,
				"area" = get_area_name(amulet) || "Unknown",
				"uses" = amulet.uses,
				"isTwilight" = istype(amulet, /obj/item/clothing/neck/portalamulet/TA),
			))

	data["isVampire"] = is_vampire
	data["vitaeCost"] = TA_RIFT_PORTAL_VITAE_COST
	data["hasVitae"] = is_vampire && living_user.has_bloodpool_cost(TA_RIFT_PORTAL_VITAE_COST)
	data["sendingActive"] = sending
	data["amulets"] = amulet_data
	return data

/obj/structure/vampire/portalmaker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	var/mob/living/user = ui.user
	if(!TA_can_use_rift(user, TRUE))
		return TRUE
	if(get_dist(user, src) > 1)
		to_chat(user, span_warning("I need to be next to the rift gate."))
		return TRUE

	var/obj/item/clothing/neck/portalamulet/amulet = locate(params["amulet_ref"])
	if(!istype(amulet) || !(amulet in GLOB.vampire_objects) || amulet.uses <= 0)
		to_chat(user, span_warning("Разлом не может найти этот амулет."))
		return TRUE

	switch(action)
		if("open_return")
			TA_open_portal(user, amulet, FALSE)
			return TRUE
		if("open_sending")
			TA_open_portal(user, amulet, TRUE)
			return TRUE
	return FALSE

/obj/structure/vampire/portalmaker/proc/TA_can_use_rift(mob/living/user, feedback = FALSE)
	if(!istype(user))
		return FALSE
	if(!user.mind?.has_antag_datum(/datum/antagonist/vampire))
		if(feedback)
			to_chat(user, span_warning("Только вампир может пробудить Врата разлома."))
		return FALSE
	return TRUE

/obj/structure/vampire/portalmaker/proc/TA_open_portal(mob/living/user, obj/item/clothing/neck/portalamulet/amulet, sending_portal = FALSE)
	if(!TA_can_use_rift(user, TRUE))
		return
	if(QDELETED(amulet) || !istype(amulet) || amulet.uses <= 0)
		to_chat(user, span_warning("Разлом не может найти этот амулет."))
		return
	if(sending_portal && sending)
		to_chat(user, span_warning("Отправляющий портал уже активен."))
		return
	if(!user.has_bloodpool_cost(TA_RIFT_PORTAL_VITAE_COST))
		to_chat(user, span_warning("Это стоит [TA_RIFT_PORTAL_VITAE_COST] витэ. Мне не хватает."))
		return

	var/turf/amulet_turf = get_turf(amulet)
	if(!amulet_turf)
		to_chat(user, span_warning("У амулета нет стабильного якоря."))
		return

	user.visible_message("[user] начинает призывать портал.", "Я начинаю призывать портал.")
	if(!do_after(user, 3 SECONDS, src))
		return
	if(QDELETED(src) || QDELETED(amulet) || get_dist(user, src) > 1 || !TA_can_use_rift(user, TRUE))
		return
	if(sending_portal && sending)
		to_chat(user, span_warning("Отправляющий портал уже активен."))
		return
	if(!user.has_bloodpool_cost(TA_RIFT_PORTAL_VITAE_COST))
		to_chat(user, span_warning("Это стоит [TA_RIFT_PORTAL_VITAE_COST] витэ. Мне не хватает."))
		return

	user.adjust_bloodpool(-TA_RIFT_PORTAL_VITAE_COST)
	amulet.uses -= 1
	if(sending_portal)
		new /obj/effect/landmark/vteleportsenddest(amulet_turf)
		create_portal(null, TA_RIFT_PORTAL_DURATION)
	else
		TA_create_return_portal(amulet_turf)

	user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
	if(amulet.uses <= 0)
		amulet.visible_message("[amulet] рассыпается!")
		qdel(amulet)
	SStgui.update_uis(src)

/obj/structure/vampire/portalmaker/proc/TA_create_return_portal(turf/destination)
	if(!destination)
		return

	var/obj/structure/vampire/portal/portal = new(destination)
	portal.duration = TA_RIFT_PORTAL_DURATION
	portal.spawntime = world.time
	portal.visible_message(span_boldnotice("Раздается тошнотворный треск, и в воздухе раскрывается зловещий портал."))

/obj/structure/vampire/portal/proc/TA_can_transport(atom/movable/AM)
	var/mob/living/living_target = AM
	if(!istype(living_target))
		return FALSE
	return !!living_target.mind?.has_antag_datum(/datum/antagonist/vampire)

/obj/structure/vampire/portal/Crossed(atom/movable/AM)
	. = ..()
	if(!TA_can_transport(AM))
		return
	for(var/obj/effect/landmark/vteleport/dest in GLOB.landmarks_list)
		playsound(loc, 'sound/misc/portalenter.ogg', 100, FALSE, pressure_affected = FALSE)
		AM.forceMove(dest.loc)
		break

/obj/structure/vampire/portal/sending/Crossed(atom/movable/AM)
	if(!TA_can_transport(AM))
		return
	for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
		AM.forceMove(V.loc)
		break

/obj/structure/vampire/portal/sending/Destroy()
	for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
		qdel(V)
	for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
		P.sending = FALSE
		SStgui.update_uis(P)
	return ..()

#undef TA_RIFT_PORTAL_VITAE_COST
#undef TA_RIFT_PORTAL_DURATION
