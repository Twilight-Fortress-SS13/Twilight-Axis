/obj/item/paper/steward_report
	name = "steward's morning report"
	desc = "A stamped sheet summarising yesterday's dispatches, for the Steward."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scroll"
	info = ""
	resistance_flags = FIRE_PROOF

/// Called at the end of SSeconomy.daily_tick. Prints a report onto the Nerve Master's tile.
/// `diff` is a /list produced by SSeconomy across the tick; see build_steward_report_body.
/proc/print_steward_report(list/diff)
	if(!diff)
		return
	var/obj/structure/roguemachine/steward/nm = SStreasury?.steward_machine
	if(!nm)
		return
	var/turf/drop = get_turf(nm)
	if(!drop)
		return
	var/obj/item/paper/steward_report/R = new(drop)
	R.info = build_steward_report_body(diff)
	R.update_icon()
	playsound(drop, 'sound/misc/coindispense.ogg', 40, FALSE, -1)

/proc/build_steward_report_body(list/diff)
	var/list/events_fired = diff["events_fired"]
	var/list/events_expired = diff["events_expired"]
	var/list/blockades_fired = diff["blockades_fired"]
	var/list/blockades_cleared = diff["blockades_cleared"]
	var/list/banditry_lines = diff["banditry_drain_lines"]
	var/list/outpost_manors = diff["outpost_manors"] //TA EDIT
	var/banditry_total = diff["banditry_drain_total"] || 0
	var/banditry_burned = diff["banditry_drain_burned"] || 0
	var/banditry_debt_accrued = diff["banditry_drain_accrued_debt"] || 0
	var/banditry_hoard = diff["banditry_hoard_total"] || 0
	var/orders_rolled = diff["orders_rolled"] || 0
	var/urgent_rolled = diff["urgent_rolled"] || 0
	var/day = diff["day"] || GLOB.dayspassed

	var/body = "<center><b>STEWARD'S MORNING REPORT</b></center><br>"
	body += "<center><i>Day [day]</i></center><br><hr>"

	if(length(blockades_fired))
		body += "<b>New blockades:</b><br>"
		for(var/line in blockades_fired)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(length(blockades_cleared))
		body += "<b>Blockades lifted:</b><br>"
		for(var/line in blockades_cleared)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(length(events_fired))
		body += "<b>New economic events:</b><br>"
		for(var/line in events_fired)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(length(events_expired))
		body += "<b>Events returned to normal:</b><br>"
		for(var/line in events_expired)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(banditry_total > 0)
		body += "<b>Losses to brigands:</b> <font color='#c44'>-[banditry_total]m</font><br>"
		for(var/line in banditry_lines)
			body += "&nbsp;&nbsp;- [line]<br>"
		if(diff["outpost_reduction"]) //TA EDIT START
			body += "<b>Estate outpost patrols have reduced the drain by:</b> [diff["outpost_reduction"]]m<br>"
		if(length(outpost_manors))
			body += "<b>The following estates mobilized against banditry:</b><br>"
			for(var/manor in outpost_manors)
				body += "&nbsp;&nbsp;- [manor], owned by [outpost_manors[manor]]<br>"
		if(diff["outpost_threat_reduced"])
			body += "<b>Threat relief:</b> [diff["outpost_threat_reduced"]] danger reduced by [diff["outpost_threat_reduction_amount"]] points.<br>" //TA EDIT END
		if(banditry_debt_accrued > 0)
			body += "<i>The Treasury could only pay [banditry_burned]m of the loss. The other <font color='#c44'>[banditry_debt_accrued]m</font> is added to brigand debt, which comes out of future income until it is paid off.</i><br>"
		body += "<br>"
	if(banditry_hoard > 0)
		body += "<b>Brigand Hoard:</b> <font color='#c44'>[banditry_hoard]m</font> across their hoards. Recovering a hoard or breaking a blockade reclaims it, and the Crown taxes a share as Recovered Spoils.<br><br>"
	if(orders_rolled)
		body += "<b>Standing orders posted this morning:</b> [orders_rolled]"
		if(urgent_rolled)
			body += " ([urgent_rolled] urgent)"
		body += "<br><br>"
	if(!length(blockades_fired) && !length(blockades_cleared) && !length(events_fired) && !length(events_expired) && !orders_rolled && banditry_total <= 0 && banditry_hoard <= 0)
		body += "<i>The roads are quiet. No shipment was disturbed overnight.</i><br>"

	body += "<hr><center><i>Use the Contract Ledger to post contracts in response.</i></center>"
	return body
