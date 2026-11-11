/datum/mind
	var/datum/manor/owned_manor = null
	var/list/manor_packages = list()

/mob/living/carbon/human
	var/check_manor_pref = TRUE

/datum/mind/proc/get_owned_manor()
	return owned_manor

/datum/mind/proc/set_owned_manor(datum/manor/manor)
	owned_manor = manor
	return owned_manor

/datum/manor
	var/manor_name = "Неизвестное имение"
	var/manor_size = "small"
	var/manor_type = "manor"
	var/datum/virtue/origin/virtue_origin
	var/min_workers = 5
	var/total_workers = 5
	var/workers_limit = 5
	var/patron = /datum/patron/divine/astrata
	var/last_cycle_productivity = 0
	var/list/workstations = list()
	var/list/workstation_types = list(/datum/workstation/field)
	var/datum/fund/estate_treasury
	var/treasury_retention = 0
	var/retention_remainder = 0
	var/estate_withdrawal_revision = 0
	var/last_estate_cycle_day
	var/last_population_income_day
	var/list/settled_estate_phases = list()

/datum/manor/Destroy()
	if(estate_treasury)
		SStreasury?.retire_fund(estate_treasury, "Estate closed")
		QDEL_NULL(estate_treasury)
	return ..()

/datum/manor/proc/withdrawEstateMoney(
	mob/living/carbon/human/owner,
	amount,
	expected_revision = null
)
	if(!taCanManageManor(owner, src) || !SStreasury || !estate_treasury)
		return FALSE
	if(
		!isnull(expected_revision) \
		&& expected_revision != estate_withdrawal_revision
	)
		return FALSE
	if(
		!isnum(amount) \
		|| !(amount >= 1 && amount <= estate_treasury.balance) \
		|| amount != round(amount)
	)
		return FALSE

	if(paysEstateToAccount(owner))
		if(!transferEstateToAccount(owner, amount))
			return FALSE
	else
		var/obj/item/manor_delivery/delivery = makeEstateWithdrawalMail(
			owner,
			amount
		)
		if(!delivery)
			return FALSE
		if(
			!SStreasury.burn(
				estate_treasury,
				amount,
				"Estate withdrawal by mail from [manor_name]",
				LEDGER_CITIZEN_COIN_OUT
			)
		)
			qdel(delivery)
			return FALSE
		addtimer( \
			CALLBACK( \
				delivery, \
				TYPE_PROC_REF(/obj/item/manor_delivery, deliverToEstateOwner), \
				owner.mind \
			), \
			rand(20 SECONDS, 10 MINUTES) \
		)
	estate_withdrawal_revision++
	return TRUE

/datum/manor/proc/paysEstateToAccount(mob/living/carbon/human/owner)
	return owner?.taIsCityNoble()

/datum/manor/proc/transferEstateToAccount(mob/living/carbon/human/owner, amount)
	var/datum/fund/owner_account = SStreasury.get_account(owner)
	if(!owner_account)
		SStreasury.create_bank_account(owner)
		owner_account = SStreasury.get_account(owner)
	if(
		!SStreasury.transfer(
			estate_treasury,
			owner_account,
			amount,
			"Estate withdrawal from [manor_name]",
			LEDGER_CITIZEN_ESTATE,
			LEDGER_CITIZEN_ESTATE
		)
	)
		return FALSE
	SStreasury.collect_poll_levy_arrears(owner)
	return TRUE

/datum/manor/proc/get_owner_display_name(mob/living/carbon/human/owner)
	return reject_bad_name(owner?.client?.prefs?.manor_name) || "Unnamed Estate"

/datum/manor/proc/get_owner_manor_type(mob/living/carbon/human/owner)
	if(owner?.manor_type_pref)
		return owner.manor_type_pref
	if(owner?.client?.prefs?.manor_type && length(owner.client.prefs.manor_type))
		return owner.client.prefs.manor_type
	return manor_type

/datum/manor/proc/is_foreign_estate(mob/living/carbon/human/owner)
	if(!owner)
		return FALSE
	return HAS_TRAIT(owner, TRAIT_NOBLE) && HAS_TRAIT(owner, TRAIT_OUTLANDER)

/datum/manor/proc/get_manor_size(mob/living/carbon/human/owner)
	if(owner)
		if(is_foreign_estate(owner))
			if(owner?.client?.prefs?.virtue_origin && !(istype(owner.client.prefs.virtue_origin, /datum/virtue/origin/racial/ancient)))
				virtue_origin = owner.client.prefs.virtue_origin
			else
				virtue_origin = new /datum/virtue/origin/unknown
		if(!isnull(owner.mind?.ta_nobility_tier))
			switch(owner.mind.ta_nobility_tier)
				if(1)
					return "small"
				if(2)
					return "medium"
				if(3)
					return "big"
		if(is_foreign_estate(owner))
			return "small"
		if(owner.advjob == "Knight Banneret" || (owner.mind?.assigned_role in list("Marshal", "Steward", "Hand")))
			return "big"
		if(owner.mind?.assigned_role in list("Councillor", "Knight", "Royal Knight"))
			return "medium"
	return "small"

/datum/manor/proc/set_up_patron_bonuses()
	switch(patron)
		if(/datum/patron/old_god)
			var/datum/workstation/cathedral/new_cathedral = new /datum/workstation/cathedral()
			workstations += new_cathedral
		if(/datum/patron/divine/xylix)
			var/has_trade_district = FALSE
			for(var/datum/workstation/ws in workstations)
				if(istype(ws, /datum/workstation/trade))
					ws.workstation_size += 5
					has_trade_district = TRUE
			if(!has_trade_district)
				var/datum/workstation/trade/new_trade = new /datum/workstation/trade()
				workstations += new_trade
		if(/datum/patron/divine/dendor)
			var/has_hunt_district = FALSE
			for(var/datum/workstation/ws in workstations)
				if(istype(ws, /datum/workstation/hunt))
					ws.workstation_size += 5
					has_hunt_district = TRUE
			if(!has_hunt_district)
				var/datum/workstation/hunt/new_hunt = new /datum/workstation/hunt()
				workstations += new_hunt
		if(/datum/patron/divine/noc)
			for(var/datum/workstation/ws in workstations)
				ws.production_modifier = 1.1
				if(istype(ws, /datum/workstation/field) || istype(ws, /datum/workstation/fruit))
					ws.production_modifier = 0.8
				else if(istype(ws, /datum/workstation/hunt))
					ws.production_modifier = 1.3
		if(/datum/patron/inhumen/zizo)
			for(var/datum/workstation/ws in workstations)
				if(istype(ws, /datum/workstation/trade))
					ws.production_modifier = 0.5
		if(/datum/patron/divine/malum)
			var/has_mine_district = FALSE
			for(var/datum/workstation/ws in workstations)
				if(istype(ws, /datum/workstation/mining))
					ws.workstation_size += 5
					has_mine_district = TRUE
			if(!has_mine_district)
				var/datum/workstation/mining/new_mining = new /datum/workstation/mining()
				workstations += new_mining
		if(/datum/patron/divine/abyssor)
			var/has_fish_district = FALSE
			for(var/datum/workstation/ws in workstations)
				if(istype(ws, /datum/workstation/fish))
					ws.workstation_size += 5
					has_fish_district = TRUE
			if(!has_fish_district)
				var/datum/workstation/fish/new_fish = new /datum/workstation/fish()
				workstations += new_fish
		if(/datum/patron/divine/astrata, /datum/patron/divine/ravox)
			var/has_outpost = FALSE
			for(var/datum/workstation/ws in workstations)
				if(istype(ws, /datum/workstation/outpost))
					has_outpost = TRUE
			if(!has_outpost)
				var/datum/workstation/outpost/new_outpost = new /datum/workstation/outpost()
				workstations += new_outpost

/proc/taManorWorkstationTypes(type, size)
	switch(size)
		if("big")
			switch(type)
				if("village")
					return list(
						/datum/workstation/field/big,
						/datum/workstation/farm,
						/datum/workstation/trade,
					)
				if("hunter_mansion")
					return list(
						/datum/workstation/hunt/big,
						/datum/workstation/fruit,
						/datum/workstation/forest,
					)
				if("fisher_hamlet")
					return list(
						/datum/workstation/fish/medium,
						/datum/workstation/field/medium,
						/datum/workstation/trade/medium,
					)
				if("mining_settlement")
					return list(
						/datum/workstation/mining/big,
						/datum/workstation/field,
						/datum/workstation/trade,
					)
			return list(
				/datum/workstation/field/medium,
				/datum/workstation/fruit/medium,
				/datum/workstation/hunt/medium,
			)
		if("medium")
			switch(type)
				if("village")
					return list(
						/datum/workstation/field/medium,
						/datum/workstation/trade,
						/datum/workstation/farm,
					)
				if("hunter_mansion")
					return list(
						/datum/workstation/hunt/medium,
						/datum/workstation/fruit,
						/datum/workstation/forest,
					)
				if("fisher_hamlet")
					return list(
						/datum/workstation/fish/medium,
						/datum/workstation/field,
						/datum/workstation/trade,
					)
				if("mining_settlement")
					return list(
						/datum/workstation/mining/medium,
						/datum/workstation/field,
						/datum/workstation/trade,
					)
			return list(
				/datum/workstation/field/medium,
				/datum/workstation/fruit,
				/datum/workstation/hunt,
			)
		else
			switch(type)
				if("village")
					return list(
						/datum/workstation/field,
						/datum/workstation/farm,
					)
				if("hunter_mansion")
					return list(
						/datum/workstation/hunt,
						/datum/workstation/forest,
					)
				if("fisher_hamlet")
					return list(
						/datum/workstation/fish,
						/datum/workstation/field,
					)
				if("mining_settlement")
					return list(
						/datum/workstation/mining,
						/datum/workstation/trade,
					)
			return list(/datum/workstation/field, /datum/workstation/fruit)

/datum/manor/proc/update_workstation_types(type = "manor", manor_size = "big")
	workstation_types = taManorWorkstationTypes(type || manor_type, manor_size)
	switch(manor_size)
		if("big")
			min_workers = 15
		if("medium")
			min_workers = 10
		else
			min_workers = 5

/datum/manor/proc/get_owner_patron(mob/living/carbon/human/owner)
	if(!owner || !owner.mind)
		return null
	if(owner.patron)
		return owner.patron.type
	return null

/datum/manor/proc/on_creation(mob/living/carbon/human/owner)
	workers_limit = 0

	manor_name = get_owner_display_name(owner)
	manor_type = get_owner_manor_type(owner)
	manor_size = get_manor_size(owner)
	treasury_retention = owner?.manor_treasury_retention || 0
	update_workstation_types(manor_type, manor_size)

	var/owner_patron = get_owner_patron(owner)
	if(owner_patron)
		patron = owner_patron

	workstations = list()
	for(var/workstation_type in workstation_types)
		var/datum/workstation/new_workstation = new workstation_type()
		workstations += new_workstation
		workers_limit += new_workstation.workstation_size
	
	set_up_patron_bonuses()

	if(applyIndustryProfile(owner))
		return

	if(workers_limit < min_workers)
		workers_limit = min_workers
	total_workers = rand(min_workers, workers_limit)

/datum/manor/proc/ensure_initialized(mob/living/carbon/human/owner)
	if(!length(workstations))
		on_creation(owner)
	if(total_workers < min_workers)
		total_workers = min_workers
	return src

/datum/manor/proc/get_assigned_workers()
	. = 0
	for(var/datum/workstation/workstation in workstations)
		. += workstation.workers_employed

/datum/manor/proc/get_free_workers()
	return max(total_workers - get_assigned_workers(), 0)

/datum/manor/proc/get_outpost_workers()
	var/list/total = list("workers" = 0, "production_modifier" = 1)
	for(var/datum/workstation/ws in workstations)
		if(istype(ws, /datum/workstation/outpost))
			total["workers"] += ws.workers_employed
			total["production_modifier"] = ws.production_modifier
	return total

/datum/manor/proc/get_stockpile_entry_for_good(good_path)
	if(!good_path)
		return null
	var/datum/roguestock/stockpile/stockpile = new good_path()
	if(!stockpile)
		return null
	var/trade_good_id = stockpile.trade_good_id
	qdel(stockpile)
	if(!trade_good_id)
		return null
	return SSeconomy.find_stockpile_by_trade_good(trade_good_id)

/datum/manor/proc/get_readable_good_name(good_path, fallback = "Ресурс")
	if(!good_path)
		return fallback
	var/as_text = "[good_path]"
	var/last_slash = findlasttext(as_text, "/")
	if(last_slash)
		as_text = copytext(as_text, last_slash + 1)
	as_text = replacetext(as_text, "_", " ")
	if(!length(as_text))
		return fallback
	return uppertext(copytext(as_text, 1, 2)) + copytext(as_text, 2)

/datum/manor/proc/process_goods_sold_to_market(datum/roguestock/stockpile_entry, units_sold)
	var/list/region_info = SSeconomy.get_best_import_region(stockpile_entry.trade_good_id)
	var/datum/trade_good/tg = GLOB.trade_goods[stockpile_entry.trade_good_id]
	var/unit_price = region_info ? region_info["unit_price"] : (tg ? tg.base_price : 1)
	return unit_price * units_sold

/datum/manor/proc/settleGoodsLot(
	datum/roguestock/stockpile_entry,
	good_path,
	units,
	is_foreign,
	list/sold_summary,
	list/stored_summary,
	processed = FALSE
)
	if(!stockpile_entry || !units)
		return 0
	var/kept = storeWarehouseShare(
		stockpile_entry.trade_good_id,
		units,
		processed
	)
	var/sold = units - kept
	if(kept)
		stored_summary[good_path] = (stored_summary[good_path] || 0) + kept
	if(!sold)
		return 0

	sold_summary[good_path] = (sold_summary[good_path] || 0) + sold
	if(is_foreign)
		return max(process_goods_sold_to_market(stockpile_entry, sold), 1)
	stockpile_entry.stockpile_amount += sold
	return max(process_goods_sold_to_market(stockpile_entry, sold) / 3, 1)

/datum/manor/proc/collectPopulationIncome()
	if(
		!isnull(last_population_income_day) \
		&& last_population_income_day == GLOB.dayspassed
	)
		return 0
	last_population_income_day = GLOB.dayspassed
	var/peasants = industry_active ? industry_peasants : total_workers
	var/artisans = industry_active ? industry_artisans : 0
	var/income = 0
	for(var/i = 1; i <= peasants; i++)
		income += rand(1, 5)
	for(var/i = 1; i <= artisans; i++)
		income += rand(3, 15)
	return income

/datum/manor/proc/produce_resources(mob/living/carbon/human/owner, is_dawn = FALSE, is_dusk = FALSE)
	if(
		!owner \
		|| owner.mind?.get_owned_manor() != src \
		|| !SStreasury \
		|| !SSeconomy
	)
		return null
	if(!length(workstations))
		return null
	if(is_dawn && (is_dusk || !(patron in list(
		/datum/patron/divine/noc,
		/datum/patron/inhumen/zizo,
	))))
		return null
	if(is_dusk && patron == /datum/patron/divine/noc)
		return null

	var/phase = is_dawn ? "dawn" : (is_dusk ? "dusk" : "manual")
	if(last_estate_cycle_day != GLOB.dayspassed)
		last_estate_cycle_day = GLOB.dayspassed
		settled_estate_phases.Cut()
	if(phase in settled_estate_phases)
		return null
	settled_estate_phases += phase

	var/list/produced_summary = list()
	var/list/sold_summary = list()
	var/list/stored_summary = list()
	var/total_units = 0
	var/total_profit_money = 0

	var/is_foreign = virtue_origin ? TRUE : FALSE
	var/ore_path = /datum/roguestock/stockpile/iron
	var/list/mining_goods = industry_mining_priority \
		? getIndustryMiningGoods() : null
	var/mining_priority_path = mining_goods?[industry_mining_priority]
	var/run_processing = (industry_smeltery || industry_processing) \
		&& !industrySettledToday()
	var/list/fresh_goods = list()
	var/list/harvest_lots = list()
	var/list/preferred_inputs
	if(industry_processing && manor_type != "mining_settlement")
		var/list/processing_recipe = \
			industry_materials[industry_processing.material]
		preferred_inputs = processing_recipe["inputs"]

	for(var/datum/workstation/workstation in workstations)
		if(workstation.workers_employed <= 0 || !length(workstation.produce))
			continue

		var/list/available_produce = workstation.produce.Copy()
		var/list/selected_produce = list()
		var/list/preferred_produce = list()
		var/priority_path = workstation == industry_mine \
			? mining_priority_path : null
		if(priority_path)
			preferred_produce += priority_path
		else if(length(workstation.manor_resource_focus))
			for(var/produce_path in available_produce)
				var/datum/roguestock/stockpile/produce_type = produce_path
				if(
					produce_type::trade_good_id in \
						workstation.manor_resource_focus
				)
					preferred_produce |= produce_path
		else if(length(preferred_inputs))
			for(var/produce_path in available_produce)
				var/datum/roguestock/stockpile/produce_type = produce_path
				if(preferred_inputs[produce_type::trade_good_id])
					preferred_produce += produce_path
		if(length(preferred_produce))
			available_produce.RemoveAll(preferred_produce)
			selected_produce = available_produce
		else
			var/selected_count = min(length(available_produce), rand(2, 6))
			while(
				length(available_produce) \
				&& length(selected_produce) < selected_count
			)
				var/choice = pick(available_produce)
				selected_produce += choice
				available_produce -= choice

		var/this_workstation_units = 0
		var/harvest_bonus = (workstation.workstation_theme in list(
			"field",
			"farm",
			"fruit",
		)) ? 1 : 0
		for(var/i = 1; i <= workstation.workers_employed; i++)
			var/selected_good = length(preferred_produce) \
				&& (!length(selected_produce) || prob(65)) \
				? pick(preferred_produce) : pick(selected_produce)
			var/units = rand(harvest_bonus, 2 + harvest_bonus)
			if(units <= 0)
				continue

			var/datum/roguestock/stockpile_entry = get_stockpile_entry_for_good(selected_good)
			if(!stockpile_entry)
				continue

			/*if(patron == /datum/patron/inhumen/matthios)
				var/unsold_units = ceil(units * 0.3)
				units = units - unsold_units
				if(unsold_units > 0)
					total_profit_money += max(process_goods_sold_to_market(stockpile_entry, unsold_units), 1)*/ //До времен когда я сделаю привязку к экономическим регионам
			var/yield_multiplier = workstation.production_modifier
			if(patron == /datum/patron/inhumen/baotha)
				yield_multiplier *= pick(0.5, 1.0, 1.5)
			units = workstation.applyManorYieldModifier(
				stockpile_entry.trade_good_id, units, yield_multiplier)
			if(!units)
				continue
			if(run_processing)
				var/good_id = stockpile_entry.trade_good_id
				fresh_goods[good_id] = (fresh_goods[good_id] || 0) + units
				harvest_lots += list(
					list(
						"good_id" = good_id,
						"path" = selected_good,
						"units" = units,
						"stockpile" = stockpile_entry
					)
				)
			else
				total_profit_money += settleGoodsLot(
					stockpile_entry,
					selected_good,
					units,
					is_foreign,
					sold_summary,
					stored_summary
				)

			produced_summary[selected_good] = produced_summary[selected_good] ? produced_summary[selected_good] + units : units
			this_workstation_units += units

		total_units += this_workstation_units
		if(workstation.type_of_produce == "Profit")
			total_profit_money += workstation.workers_employed * 2 * workstation.production_modifier

	var/list/industry_settlement
	if(run_processing)
		var/list/reserved = fresh_goods.Copy()
		industry_settlement = processManorProduction(fresh_goods)
		for(var/good_id in reserved)
			reserved[good_id] -= fresh_goods[good_id]
		var/iron_surplus = 0
		for(var/list/lot in harvest_lots)
			var/good_id = lot["good_id"]
			var/used = min(lot["units"], reserved[good_id])
			reserved[good_id] -= used
			var/surplus = lot["units"] - used
			if(industry_smeltery && lot["path"] == ore_path)
				iron_surplus += surplus
			else
				total_profit_money += settleGoodsLot(
					lot["stockpile"],
					lot["path"],
					surplus,
					is_foreign,
					sold_summary,
					stored_summary
				)
		if(iron_surplus)
			total_profit_money += settleGoodsLot(
				get_stockpile_entry_for_good(ore_path),
				ore_path,
				iron_surplus,
				is_foreign,
				sold_summary,
				stored_summary
			)
		if(industry_settlement?["refined_units"])
			var/datum/roguestock/stockpile/refined_stockpile = \
				SSeconomy.find_stockpile_by_trade_good(
					industry_settlement["refined_good"]
				)
			if(refined_stockpile)
				total_profit_money += settleGoodsLot(
					refined_stockpile,
					refined_stockpile.type,
					industry_settlement["refined_units"],
					is_foreign,
					sold_summary,
					stored_summary,
					TRUE
				)
		if(industry_smeltery)
			industry_last_sold_ore = sold_summary[ore_path] || 0
			industry_last_stored_ore = stored_summary[ore_path] || 0

	last_cycle_productivity = max(total_units, 0)
	if(length(stored_summary) || industry_settlement?["warehouse_consumed"])
		warehouse_revision++

	if(patron == /datum/patron/inhumen/matthios && total_profit_money > 0)
		var/voluntary_multiplier = rand(50, 150) / 100
		total_profit_money *= voluntary_multiplier

	if(patron == /datum/patron/inhumen/baotha && total_profit_money > 0)
		if(prob(30))
			total_profit_money = 0
		if(prob(30))
			total_profit_money *= 2

	var/population_income = (is_dawn || is_dusk) ? collectPopulationIncome() : 0
	var/production_income = ceil(total_profit_money)
	var/gross = production_income + population_income
	var/estate_levy = 0
	var/import_tariff = 0
	if(gross > 0)
		if(!estate_treasury)
			estate_treasury = new(
				"Estate treasury: [manor_name] ([owner.real_name])",
				owner
			)
			SStreasury.register_auxiliary_fund(estate_treasury)
		estate_treasury.owner_ref = WEAKREF(owner)
		SStreasury.mint(
			estate_treasury,
			gross,
			"Estate income",
			null,
			LEDGER_CITIZEN_ESTATE
		)
		if(patron != /datum/patron/inhumen/matthios)
			if(is_foreign)
				estate_levy = SStreasury.apply_tax(
					estate_treasury,
					production_income,
					TAX_CATEGORY_ESTATE_LEVY,
					"Estate levy income"
				)
				import_tariff = SStreasury.apply_tax(
					estate_treasury,
					production_income - estate_levy,
					TAX_CATEGORY_IMPORT_TARIFF,
					"Foreign estate import tariff"
				)
				// Only shipment income pays import tax; round it separately.
				estate_treasury.tax_debt = 0
				estate_levy += SStreasury.apply_tax(
					estate_treasury,
					population_income,
					TAX_CATEGORY_ESTATE_LEVY,
					"Estate population income"
				)
				estate_treasury.tax_debt = 0
			else
				estate_levy = SStreasury.apply_tax(
					estate_treasury,
					gross,
					TAX_CATEGORY_ESTATE_LEVY,
					"Estate levy income"
				)

	var/net = gross - estate_levy - import_tariff
	var/pays_to_account = paysEstateToAccount(owner)
	// Carry fractional mammon forward to preserve the chosen percentage.
	var/retention_share = net * treasury_retention + retention_remainder
	var/retained = FLOOR(retention_share / 100, 1)
	retention_remainder = retention_share - retained * 100
	var/payout = net - retained
	if(payout > 0)
		if(pays_to_account)
			if(!transferEstateToAccount(owner, payout))
				payout = 0
		else if(
			!SStreasury.burn(
				estate_treasury,
				payout,
				"Estate income mailed from [manor_name]",
				LEDGER_CITIZEN_COIN_OUT
			)
		)
			payout = 0

	sendEstateReport(
		owner,
		sold_summary,
		gross,
		estate_levy,
		import_tariff,
		net,
		is_foreign,
		payout,
		pays_to_account,
		stored_summary,
		!!industry_settlement,
		population_income
	)

	return list(
		"products" = produced_summary,
		"stored_products" = stored_summary,
		"money" = net,
		"gross" = gross,
		"population_income" = population_income,
		"estate_levy" = estate_levy,
		"import_tariff" = import_tariff,
		"payout" = payout,
	)


/obj/structure/roguemachine/mail/proc/can_open_manor_panel(mob/living/carbon/human/user)
	if(!istype(user) || !user.mind)
		return FALSE

	var/datum/manor_panel/access_probe = new(user)
	var/allowed = access_probe.can_have_manor(user)
	qdel(access_probe)
	return allowed

/obj/structure/roguemachine/mail/proc/open_manor_panel(mob/user)
	if(.)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(!Adjacent(H))
		return

	var/datum/manor_panel/panel = new(H)
	var/datum/manor/manor = panel.get_manor_for_user(H)
	if(!manor)
		qdel(panel)
		to_chat(H, span_warning("У этого персонажа пока нет доступного поместья."))
		return TRUE

	H.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 50, FALSE, -1)
	panel.ui_interact(H)
	return TRUE
