// TEMPORARY: banditry drain is a placeholder consequence until proper raid/siege
// content ships. Delete this file when raids land. See BANDITRY_DRAIN_* in economy.dm.

/datum/controller/subsystem/economy/proc/preview_banditry_drain()
	var/list/result = list("total" = 0, "lines" = list(), "debt" = SStreasury?.banditry_debt || 0)
	var/pop = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		var/level = TR.get_danger_level()
		var/cost = 0
		switch(level)
			if(DANGER_LEVEL_DANGEROUS)
				cost = BANDITRY_DRAIN_DANGEROUS_FLAT + (BANDITRY_DRAIN_DANGEROUS_PER_PLAYER * pop)
			if(DANGER_LEVEL_BLEAK)
				cost = BANDITRY_DRAIN_BLEAK_FLAT + (BANDITRY_DRAIN_BLEAK_PER_PLAYER * pop)
		if(cost <= 0)
			continue
		var/base_cost = (level == DANGER_LEVEL_BLEAK) ? BANDITRY_DRAIN_BLEAK_FLAT : BANDITRY_DRAIN_DANGEROUS_FLAT
		var/per_player = (level == DANGER_LEVEL_BLEAK) ? BANDITRY_DRAIN_BLEAK_PER_PLAYER : BANDITRY_DRAIN_DANGEROUS_PER_PLAYER
		result["total"] += cost
		result["lines"] += "[TR.region_name] ([level]) -[cost]m ([base_cost] base + [per_player]m/head x [pop])"

	var/list/outpost_info = get_outpost_banditry_support() //TA EDIT START
	if(outpost_info["workers"] > 0)
		var/reduction = min(result["total"], ceil(outpost_info["workers"] * 7 * outpost_info["production_modifier"]))
		if(reduction > 0)
			result["total"] -= reduction
			result["outpost_reduction"] = reduction
			result["outpost_manors"] = outpost_info["manors"] //TA EDIT END
	return result

/datum/controller/subsystem/economy/proc/get_outpost_banditry_support() //TA EDIT START
	var/list/info = list("workers" = 0, "manors" = list(), "owners" = list(), "owner_names" = list())
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H || !H.mind)
			continue
		var/datum/manor/manor = H.mind.get_owned_manor()
		if(!manor)
			continue
		var/list/ws_info = manor.get_outpost_workers()
		if(ws_info["workers"] <= 0)
			continue
		info["production_modifier"] = ws_info["production_modifier"]
		info["workers"] += ws_info["workers"]
		info["manors"] += list("[manor.manor_name]" = "[H.real_name]")
	return info //TA EDIT END

/datum/controller/subsystem/economy/proc/tick_banditry_drain()
	if(!SStreasury?.discretionary_fund)
		return
	var/list/preview = preview_banditry_drain()
	var/total_drain = preview["total"]
	if(total_drain <= 0)
		return
	var/balance = SStreasury.discretionary_fund.balance
	var/burnable = max(0, balance - BANDITRY_DEBT_FLOOR)
	var/burn_now = min(total_drain, burnable)
	var/shortfall = total_drain - burn_now
	if(burn_now > 0)
		SStreasury.burn(SStreasury.discretionary_fund, burn_now, "Banditry losses (untended regions)")
	if(shortfall > 0)
		SStreasury.banditry_debt += shortfall
	record_round_statistic(STATS_BANDITRY_LOSSES, total_drain)
	GLOB.azure_round_stats[STATS_BANDITRY_DEBT_OUTSTANDING] = SStreasury.banditry_debt
	if(daily_report_diff)
		daily_report_diff["banditry_drain_total"] = total_drain
		daily_report_diff["banditry_drain_burned"] = burn_now
		daily_report_diff["banditry_drain_accrued_debt"] = shortfall
		daily_report_diff["banditry_drain_lines"] = preview["lines"]
		if(preview["outpost_reduction"]) //TA EDIT START
			daily_report_diff["outpost_reduction"] = preview["outpost_reduction"]
			daily_report_diff["outpost_manors"] = preview["outpost_manors"]
			daily_report_diff["outpost_owners"] = preview["outpost_owners"]

	var/outpost_reduction = preview["outpost_reduction"] || 0
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H || !H.mind)
			continue
		var/datum/manor/manor = H.mind.get_owned_manor()
		if(!manor)
			continue
		var/outpost_workers = manor.get_outpost_workers()
		if(outpost_workers <= 0)
			continue
		if(H.client)
			if(outpost_reduction > 0)
				to_chat(H, span_notice("Ваши отряды на заставе помогли снизить потери от бандитизма на [outpost_reduction] маммон."))
			else
				to_chat(H, span_notice("Ваши отряды на заставе были мобилизованы, но сильный бандитский натиск не позволил немедленно уменьшить потери."))

	var/list/outpost_candidates = list()
	var/outpost_info = get_outpost_banditry_support()
	if(outpost_info["workers"] > 0)
		for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
			if(TR.get_danger_level() > DANGER_LEVEL_SAFE)
				outpost_candidates += TR
		if(length(outpost_candidates) && prob(10))
			var/datum/threat_region/TR = pick(outpost_candidates)
			var/reduction_amount = min(TR.latent_ambush - TR.min_ambush, 5 + floor(outpost_info["workers"] / 5))
			if(reduction_amount > 0)
				TR.reduce_latent_ambush(reduction_amount)
				if(daily_report_diff)
					daily_report_diff["outpost_threat_reduced"] = TR.region_name
					daily_report_diff["outpost_threat_reduction_amount"] = reduction_amount
				for(var/mob/living/carbon/human/H in outpost_info["owners"])
					if(H.client)
						to_chat(H, span_notice("Ваши отряды на заставе помогли снизить опасность в регионе [TR.region_name].")) //TA EDIT END
