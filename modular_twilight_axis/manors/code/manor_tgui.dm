/datum/manor_panel
	var/mob/living/carbon/human/holder

/proc/taCanManageManor(mob/living/carbon/human/owner, datum/manor/estate)
	if(!istype(owner) || QDELETED(owner) || QDELETED(estate))
		return FALSE
	if(owner.stat != CONSCIOUS || owner.incapacitated())
		return FALSE
	return owner.mind?.current == owner \
		&& owner.mind.get_owned_manor() == estate

/datum/manor_panel/New(mob/holder_mob)
	. = ..()
	if(istype(holder_mob, /mob/living/carbon/human))
		holder = holder_mob

/datum/manor_panel/Destroy(force)
	holder = null
	return ..()

/datum/manor_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/manor_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ManorPanel", "Владение")
		ui.open()

/datum/asset/simple/manor
	assets = list(
		"field_icon.png" = 'modular_twilight_axis/manors/icons/field_icon.png',
		"fishing_icon.png" = 'modular_twilight_axis/manors/icons/fishing_icon.png',
		"forest_icon.png" = 'modular_twilight_axis/manors/icons/forest_icon.png',
		"fruit_icon.png" = 'modular_twilight_axis/manors/icons/fruit_icon.png',
		"hunting_icon.png" = 'modular_twilight_axis/manors/icons/hunting_icon.png',
		"ranch_icon.png" = 'modular_twilight_axis/manors/icons/ranch_icon.png',
		"trade_icon.png" = 'modular_twilight_axis/manors/icons/trade_icon.png',
		"mine_icon.png" = 'modular_twilight_axis/manors/icons/mine_icon.png',
		"mage_tower_icon.png" = 'modular_twilight_axis/manors/icons/mage_tower_icon.png',
		"cathedral_icon.png" = 'modular_twilight_axis/manors/icons/cathedral_icon.png',
		"outpost_icon.png" = 'modular_twilight_axis/manors/icons/outpost_icon.png',
	)

/datum/manor_panel/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/manor),
		get_asset_datum(/datum/asset/spritesheet/manor_orders),
	)

/datum/asset/spritesheet/manor_orders
	name = "manor_orders"

/datum/asset/spritesheet/manor_orders/create_spritesheets()
	Insert("manor-smeltery", 'icons/roguetown/misc/forge.dmi', "cavesmelter1")
	Insert("manor-forge", 'icons/roguetown/misc/forge.dmi', "anvil")
	var/obj/item/manor_delivery/package_type = /obj/item/manor_delivery
	Insert("manor-order-package", package_type::icon, package_type::icon_state)
	var/list/catalogue = getManorAdditionalCatalogue() + \
		getManorWorkshopRecipes()
	for(var/id in catalogue)
		var/list/entry = catalogue[id]
		var/obj/item/item_type = entry["item_type"]
		if(
			!entry["hidden"] \
			&& item_type::icon_state \
			&& icon_exists(item_type::icon, item_type::icon_state)
		)
			Insert(id, item_type::icon, item_type::icon_state)

/datum/manor_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(ui?.user != holder)
		return FALSE
	if(!taCanManageManor(holder, holder?.mind?.get_owned_manor()))
		return FALSE

	if(action == "withdraw_estate_money")
		var/mob/living/carbon/human/owner = ui?.user
		if(!istype(owner) || owner != holder)
			return FALSE
		var/datum/manor/owned_manor = owner.mind?.get_owned_manor()
		if(!owned_manor)
			return FALSE
		var/amount = params["amount"]
		var/revision = params["revision"]
		if(!isnum(revision))
			return FALSE
		if(owned_manor.withdrawEstateMoney(owner, amount, revision))
			if(owned_manor.paysEstateToAccount(owner))
				to_chat(
					owner,
					span_notice("Запрошенные средства переведены на ваш счёт.")
				)
			else
				to_chat(
					owner,
					span_notice( \
						"Потребуется некоторое время, прежде чем средства \
						прибудут из имения." \
					)
				)
		else
			to_chat(
				owner,
				span_warning( \
					"Не удалось получить запрошенные средства из казны \
					имения." \
				)
			)
		SStgui.update_uis(src)
		return TRUE

	if(action == "set_warehouse_sale" || action == "request_warehouse_shipment")
		var/mob/living/carbon/human/owner = ui?.user
		if(!istype(owner) || owner != holder)
			return FALSE
		var/datum/manor/owned_manor = owner.mind?.get_owned_manor()
		if(!owned_manor)
			return FALSE

		if(action == "set_warehouse_sale")
			if(
				!owned_manor.setWarehouseSale(
					owner,
					params["stage"],
					params["percent"]
				)
			)
				return FALSE
		else
			var/list/requested = params["items"]
			var/revision = params["revision"]
			if(!islist(requested) || !isnum(revision))
				return FALSE
			if(owned_manor.requestWarehouseShipment(owner, requested, revision))
				to_chat(
					owner,
					span_notice("Поставка из имения займёт некоторое время.")
				)
			else
				to_chat(
					owner,
					span_warning( \
						"Не удалось собрать запрошенную поставку. Сверьтесь с \
						запасами имения." \
					)
				)
		SStgui.update_uis(src)
		return TRUE

	if(action == "request_industry_order")
		var/mob/living/carbon/human/owner = ui?.user
		if(!istype(owner) || owner != holder)
			return FALSE
		var/datum/manor/owned_manor = owner.mind?.get_owned_manor()
		if(!owned_manor)
			return FALSE
		if(
			owned_manor.requestIndustryOrder(
				owner,
				params["items"],
				params["revision"]
			)
		)
			to_chat(
				owner,
				span_notice( \
					"Мастерская отправит заказ через HERMES. Доставка займёт \
					некоторое время." \
				)
			)
		else
			to_chat(
				owner,
				span_warning( \
					"Мастерская не смогла принять заказ. Сверьтесь с запасами \
					имения." \
				)
			)
		SStgui.update_uis(src)
		return TRUE

	if(
		action == "set_industry_metal" \
		|| action == "set_mining_priority" \
		|| action == "set_production_material"
	)
		var/mob/living/carbon/human/owner = ui?.user
		if(!istype(owner) || owner != holder)
			return FALSE
		var/datum/manor/owned_manor = owner.mind?.get_owned_manor()
		switch(action)
			if("set_mining_priority")
				if(
					!owned_manor?.setIndustryMiningPriority(
						owner,
						params["good_id"]
					)
				)
					return FALSE
			if("set_production_material")
				if(
					!owned_manor?.setProductionMaterial(
						owner,
						params["stage"],
						params["material"]
					)
				)
					return FALSE
			if("set_industry_metal")
				if(
					!owned_manor?.setIndustryMetal(
						owner,
						params["station"],
						params["metal"]
					)
				)
					return FALSE
		SStgui.update_uis(src)
		return TRUE

	var/mob/request_user = holder
	if(ui?.user)
		request_user = ui.user

	var/datum/manor/manor = get_manor_for_user(request_user)
	if(!manor)
		return FALSE
	if(
		manor.industry_active \
		&& (
			request_user != holder \
			|| holder.stat == DEAD \
			|| holder.mind?.get_owned_manor() != manor
		)
	)
		return FALSE

	var/id = params["id"]
	if(!isnum(id))
		id = text2num(id)
	if(!id || id < 1 || id > length(manor.workstations) || id != round(id))
		return FALSE

	var/datum/workstation/workstation = manor.workstations[id]
	if(!workstation)
		return FALSE

	switch(action)
		if("inc_workers")
			if(workstation.workers_employed >= workstation.workstation_size)
				return TRUE
			var/assigned = manor.get_assigned_workers()
			var/population = manor.total_workers
			if(manor.industry_active)
				var/artisans_assigned = manor.getAssignedArtisans()
				if(manor.isArtisanWorkstation(workstation))
					assigned = artisans_assigned
					population = manor.industry_artisans
				else
					assigned -= artisans_assigned
					population = manor.industry_peasants
			if(assigned >= population)
				return TRUE
			workstation.workers_employed += 1
			if(workstation.production_increase_per_job)
				for(var/datum/workstation/ws in manor.workstations)
					ws.production_modifier += workstation.production_increase_per_job
			SStgui.update_uis(src)
			return TRUE

		if("dec_workers")
			if(workstation.workers_employed <= 0)
				return TRUE
			workstation.workers_employed -= 1
			if(workstation.production_increase_per_job)
				for(var/datum/workstation/ws in manor.workstations)
					ws.production_modifier -= workstation.production_increase_per_job
			SStgui.update_uis(src)
			return TRUE

	return FALSE

/datum/manor_panel/proc/get_primary_role(mob/user)
	if(!user?.mind)
		return ""
	return lowertext("[user.mind.assigned_role]")

/datum/manor_panel/proc/is_allowed_manor_role(mob/user)
	var/datum/job/J = SSjob.GetJob(user.job)

	if(J)
		if(
			(J.department_flag & NOBLEMEN) \
			&& (!ishuman(user) || isnull(user:taRoleNobilityTier()))
		)
			return FALSE

	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		return FALSE

	if(HAS_TRAIT(user, TRAIT_NOBLE_UNLANDED))
		return FALSE

	if(user.mind && (user.mind.has_antag_datum(/datum/antagonist/skeleton) || user.mind.has_antag_datum(/datum/antagonist/lich) || user.mind.has_antag_datum(/datum/antagonist/vampire) || user.mind.has_antag_datum(/datum/antagonist/vampire/lord)))
		return FALSE

	if(HAS_TRAIT(user, TRAIT_NOBLE))
		return TRUE

	return FALSE

/datum/manor_panel/proc/can_have_manor(mob/user)
	if(!istype(user, /mob/living/carbon/human) || !user.mind)
		return FALSE
	var/mob/living/carbon/human/H = user
	if(
		H.mind.ta_nobility_pending \
		|| (!isnull(H.mind.ta_nobility_tier) && H.mind.ta_nobility_tier == 0)
	)
		return FALSE
	if(!H.check_manor_pref && isnull(H.mind.ta_nobility_tier))
		return FALSE
	if(user.mind.get_owned_manor())
		return TRUE
	return is_allowed_manor_role(user)

/datum/manor_panel/proc/create_manor_for_user(mob/user)
	if(!istype(user, /mob/living/carbon/human))
		return null
	if(!user.mind)
		return null
	if(!can_have_manor(user))
		return null

	var/datum/manor/existing_manor = user.mind.get_owned_manor()
	if(existing_manor)
		return existing_manor.ensure_initialized(user)

	var/datum/manor/new_manor = new /datum/manor()
	new_manor.on_creation(user)
	user.mind.set_owned_manor(new_manor)
	return new_manor

/datum/manor_panel/proc/get_manor_for_user(mob/user)
	var/datum/manor/manor = null

	if(user?.mind)
		manor = user.mind.get_owned_manor()
		if(manor)
			return manor.ensure_initialized(user)

	if(holder?.mind)
		manor = holder.mind.get_owned_manor()
		if(manor)
			return manor.ensure_initialized(holder)

	if(user)
		manor = create_manor_for_user(user)
		if(manor)
			return manor

	if(holder)
		manor = create_manor_for_user(holder)
		if(manor)
			return manor

	return null

/datum/manor_panel/proc/capitalize(text_value)
	if(!istext(text_value) || !length(text_value))
		return ""
	return "[uppertext(copytext(text_value, 1, 2))][copytext(text_value, 2)]"

/datum/manor_panel/proc/get_readable_type_name(thing_path, fallback = "Неизвестно")
	var/as_text = "[thing_path]"
	var/last_slash = findlasttext(as_text, "/")
	if(last_slash)
		as_text = copytext(as_text, last_slash + 1)
	as_text = replacetext(as_text, "_", " ")
	if(!length(as_text))
		return fallback
	return capitalize(as_text)

/datum/manor_panel/proc/get_patron_key(patron_value)
	var/as_text = lowertext("[patron_value]")
	var/last_slash = findlasttext(as_text, "/")
	if(last_slash)
		as_text = copytext(as_text, last_slash + 1)
	if(!length(as_text))
		return "astrata"
	return as_text

/datum/manor_panel/proc/serialize_workstation(
	datum/manor/manor,
	datum/workstation/workstation,
	index
)
	var/list/produce_names = list()

	for(var/stock_path in workstation.produce)
		var/datum/roguestock/stockpile/stock_type = stock_path
		var/datum/trade_good/good = GLOB.trade_goods[stock_type::trade_good_id]
		produce_names |= good?.name || get_readable_type_name(stock_path, \
			"Ресурс")

	var/industry_icon_id
	if(workstation == manor.industry_smeltery)
		produce_names += manor.getIndustryMaterialLabel(
			manor.industry_smeltery_metal
		)
		industry_icon_id = "manor-smeltery"
	else if(workstation == manor.industry_forge)
		produce_names += manor.getIndustryMaterialLabel(
			manor.industry_forge_metal
		)
		industry_icon_id = "manor-forge"
	var/station_icon
	if(industry_icon_id)
		var/datum/asset/spritesheet/sprites = get_asset_datum(
			/datum/asset/spritesheet/manor_orders
		)
		station_icon = sprites.icon_class_name(industry_icon_id)

	return list(
		"id" = index,
		"name" = workstation.workstation_name,
		"workers_employed" = workstation.workers_employed,
		"workers_max" = workstation.workstation_size,
		"produce" = produce_names,
		"kind" = workstation.get_theme_key(),
		"icon" = station_icon,
		"pool" = manor.isArtisanWorkstation(workstation) ? "artisans" \
			: "peasants",
		"type_of_produce" = workstation.type_of_produce,
		"production_bonus" = workstation.production_modifier
	)

/datum/manor_panel/ui_data(mob/user)
	var/datum/manor/manor = get_manor_for_user(user)
	if(!manor)
		return list(
			"manor_name" = "Нет доступного владения",
			"manor_type" = "manor",
			"manor_patron_key" = "astrata",
			"manor_origin" = "Неизвестно",
			"total_workers" = 0,
			"workers_assigned" = 0,
			"workers_free" = 0,
			"productivity_last_cycle" = 0,
			"estate_balance" = null,
			"estate_treasury_retention" = 0,
			"estate_withdrawal_revision" = 0,
			"warehouse" = list(),
			"warehouse_raw_sale" = 100,
			"warehouse_processed_sale" = 100,
			"warehouse_revision" = 0,
			"warehouse_shipment_limit" = MANOR_SHIPMENT_MAX_UNITS,
			"industry" = null,
			"workstations" = list()
		)

	var/list/workstations_data = list()
	var/index = 1
	for(var/datum/workstation/workstation in manor.workstations)
		workstations_data += list(
			serialize_workstation(manor, workstation, index)
		)
		index += 1
	var/origin
	if(manor.virtue_origin)
		origin = manor.virtue_origin.map_state_name
	var/is_owner = user == holder && user?.mind?.get_owned_manor() == manor
	var/list/industry_data = is_owner ? manor.getIndustryPanelData() : null
	if(industry_data)
		var/datum/asset/spritesheet/sprites = get_asset_datum(
			/datum/asset/spritesheet/manor_orders
		)
		var/package_icon = sprites.icon_class_name("manor-order-package")
		for(var/list/recipe in industry_data["recipes"])
			recipe["icon"] = sprites.icon_class_name(recipe["id"]) \
				|| package_icon
	var/list/warehouse_data = list()
	if(is_owner)
		for(var/good_id in manor.warehouse_stock)
			var/quantity = manor.warehouse_stock[good_id]
			var/datum/trade_good/good = GLOB.trade_goods[good_id]
			if(!good || quantity <= 0)
				continue
			warehouse_data += list(list(
				"id" = good_id,
				"name" = good.name,
				"quantity" = quantity,
			))

	return list(
		"manor_name" = manor.manor_name,
		"manor_type" = manor.manor_type,
		"manor_patron_key" = get_patron_key(manor.patron),
		"manor_origin" = origin,
		"total_workers" = manor.total_workers,
		"workers_assigned" = manor.get_assigned_workers(),
		"workers_free" = manor.get_free_workers(),
		"productivity_last_cycle" = manor.last_cycle_productivity,
		"estate_balance" = is_owner ? (
			manor.estate_treasury?.balance || 0
		) : null,
		"estate_treasury_retention" = is_owner ? manor.treasury_retention : 0,
		"estate_withdrawal_revision" = is_owner \
			? manor.estate_withdrawal_revision : 0,
		"warehouse" = warehouse_data,
		"warehouse_raw_sale" = is_owner ? manor.warehouse_raw_sale : 100,
		"warehouse_processed_sale" = is_owner ? manor.warehouse_processed_sale \
			: 100,
		"warehouse_revision" = is_owner ? manor.warehouse_revision : 0,
		"warehouse_shipment_limit" = MANOR_SHIPMENT_MAX_UNITS,
		"industry" = industry_data,
		"workstations" = workstations_data
	)
