/obj/item/parcel/manor_shipment
	name = "посылка из поместья"
	desc = "Посылка из имения под магической печатью."
	icon_state = "ration_large"
	dropshrink = 1
	preserves_contents = TRUE
	var/estate_dispatched = FALSE
	var/datum/weakref/recipient_ref

/obj/item/parcel/manor_shipment/Initialize(mapload)
	. = ..()
	invisibility = initial(invisibility)
	QDEL_NULL(proximity_monitor)

/obj/item/parcel/manor_shipment/proc/sendToOwner(
	datum/mind/recipient,
	list/contents_by_type,
	estate_name
)
	if(QDELETED(src) || estate_dispatched)
		return FALSE
	if(QDELETED(recipient) || !length(contents_by_type))
		qdel(src)
		return FALSE

	var/total_quantity = 0
	for(var/item_type in contents_by_type)
		var/quantity = contents_by_type[item_type]
		if(
			!ispath(item_type, /obj/item) \
			|| !isnum(quantity) \
			|| !(
				quantity >= 1 \
				&& quantity <= MANOR_SHIPMENT_MAX_UNITS - total_quantity
			) \
			|| round(quantity) != quantity
		)
			qdel(src)
			return FALSE
		total_quantity += quantity

	estate_dispatched = TRUE
	recipient_ref = WEAKREF(recipient)
	var/recipient_name = recipient.current?.real_name || recipient.name
	if(recipient_name)
		desc = "Посылка из имения под магической печатью. Адресат: \
		[html_encode(recipient_name)]."
	for(var/item_type in contents_by_type)
		var/quantity = contents_by_type[item_type]
		for(var/index in 1 to quantity)
			var/obj/item/product = new item_type(src)
			if(
				length(estate_name) \
				&& !istype(product, /obj/item/reagent_containers/food)
			)
				product.AddElement(/datum/element/manor_hallmark, estate_name)
			contained_items += product
	if(length(contained_items) == 1)
		var/obj/item/only = contained_items[1]
		if(only.w_class < WEIGHT_CLASS_NORMAL)
			icon_state = "ration_small"
	update_icon()
	return recipient.enqueueEstateCorrespondence(src)

/obj/item/parcel/manor_shipment/can_open(mob/user, silent = FALSE)
	var/datum/mind/recipient = recipient_ref?.resolve()
	if(recipient && isliving(user) && user.stat != DEAD)
		if(recipient.current == user)
			return TRUE
		var/datum/ta_retainer_contract/service = user.mind?.ta_retinue_service
		if(
			!QDELETED(service) \
			&& service.retainer_body == user \
			&& service.employer_ref?.resolve() == recipient \
			&& (service in recipient.ta_retinue_employments)
		)
			return TRUE
	if(!silent)
		to_chat(
			user,
			span_warning( \
				"Магическая печать поддаётся адресату или кому-то из его \
				свиты." \
			)
		)
	return FALSE

/obj/item/parcel/manor_shipment/examine(mob/user)
	. = ..()
	if(can_open(user, TRUE))
		. += span_notice("Ты можешь вскрыть эту посылку.")

/// Item marks survive unpacking and emptied bottles.
/datum/element/manor_hallmark
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	argument_hash_start_idx = 2
	var/estate_name

/datum/element/manor_hallmark/Attach(datum/target, estate_name)
	. = ..()
	if(!isitem(target) || !length(estate_name))
		return ELEMENT_INCOMPATIBLE
	src.estate_name = html_encode(estate_name)
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(showHallmark))

/datum/element/manor_hallmark/Detach(datum/target)
	UnregisterSignal(target, COMSIG_PARENT_EXAMINE)
	return ..()

/datum/element/manor_hallmark/proc/showHallmark(
	obj/item/source,
	mob/user,
	list/examine_list
)
	SIGNAL_HANDLER
	examine_list += span_info("Виднеется клеймо дома «[estate_name]».")
