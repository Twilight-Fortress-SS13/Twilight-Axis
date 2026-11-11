#define MANOR_SHIPMENT_MAX_UNITS 24

/datum/manor
	var/list/warehouse_stock = list()
	var/list/warehouse_remainders = list()
	var/warehouse_raw_sale = 100
	var/warehouse_processed_sale = 100
	var/warehouse_revision = 0

/datum/manor/proc/setWarehouseSale(
	mob/living/carbon/human/owner,
	stage,
	percent
)
	if(!taCanManageManor(owner, src))
		return FALSE
	if(
		!isnum(percent) \
		|| !(percent >= 0 && percent <= 100) \
		|| percent != round(percent)
	)
		return FALSE
	switch(stage)
		if("raw")
			warehouse_raw_sale = percent
		if("processed")
			warehouse_processed_sale = percent
		else
			return FALSE
	return TRUE

/// Carry fractional stock per good so small harvests are not lost.
/datum/manor/proc/storeWarehouseShare(good_id, units, processed = FALSE)
	var/datum/trade_good/good = GLOB.trade_goods[good_id]
	if(!ispath(good?.item_type, /obj/item))
		return 0

	var/sale_percent = (
		processed || good.behavior == TRADE_BEHAVIOR_INTERMEDIARY
	) ? warehouse_processed_sale : warehouse_raw_sale
	if(sale_percent == 100)
		return 0
	var/share = units * (100 - sale_percent) + (
		warehouse_remainders[good_id] || 0
	)
	var/kept = round(share / 100)
	warehouse_remainders[good_id] = share % 100
	if(kept)
		warehouse_stock[good_id] = (warehouse_stock[good_id] || 0) + kept
	return kept

/datum/manor/proc/warehouseTravelMultiplier(units, value)
	var/load = max(units, value / 5)
	return CLAMP( \
		0.5 + 1.5 * (load - 1) / (MANOR_SHIPMENT_MAX_UNITS - 1), \
		0.5, \
		2 \
	)

/datum/manor/proc/requestWarehouseShipment(
	mob/living/carbon/human/owner,
	list/requested,
	expected_revision
)
	if(!taCanManageManor(owner, src))
		return FALSE
	if(
		!islist(requested) \
		|| !length(requested) \
		|| length(requested) > MANOR_SHIPMENT_MAX_UNITS
	)
		return FALSE
	if(!isnum(expected_revision) || expected_revision != warehouse_revision)
		return FALSE

	var/list/manifest = list()
	var/total_units = 0
	var/total_value = 0
	for(var/good_id in requested)
		if(!istext(good_id))
			return FALSE
		var/quantity = requested[good_id]
		if(
			!isnum(quantity) \
			|| !(
				quantity >= 1 \
				&& quantity <= MANOR_SHIPMENT_MAX_UNITS \
				&& quantity <= (warehouse_stock[good_id] || 0)
			) \
			|| quantity != round(quantity)
		)
			return FALSE
		var/datum/trade_good/good = GLOB.trade_goods[good_id]
		if(!ispath(good?.item_type, /obj/item))
			return FALSE
		total_units += quantity
		if(total_units > MANOR_SHIPMENT_MAX_UNITS)
			return FALSE
		total_value += quantity * max(0, good.base_price)
		manifest[good.item_type] = (manifest[good.item_type] || 0) + quantity

	// Reserve stock before scheduling; the timer holds its own manifest.
	var/obj/item/parcel/manor_shipment/shipment = new
	if(QDELETED(shipment))
		return FALSE
	for(var/good_id in requested)
		warehouse_stock[good_id] -= requested[good_id]
		if(!warehouse_stock[good_id])
			warehouse_stock -= good_id
	warehouse_revision++
	var/delay = round(
		rand(
			20 SECONDS,
			5 MINUTES
		) * warehouseTravelMultiplier(total_units, total_value)
	)
	addtimer( \
		CALLBACK( \
			shipment, \
			TYPE_PROC_REF(/obj/item/parcel/manor_shipment, sendToOwner), \
			owner.mind, \
			manifest, \
			manor_name \
		), \
		delay \
	)
	return TRUE
