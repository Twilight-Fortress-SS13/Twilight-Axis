/datum/element/infinite_reagents
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY | ELEMENT_BESPOKE
	var/list/whitelist = list()

/datum/element/infinite_reagents/Attach(datum/target, list/whitelist)
	. = ..()
	if(!isobj(target))
		return ELEMENT_INCOMPATIBLE
    
	if(whitelist)
		src.whitelist = whitelist
	
	RegisterSignal(target, COMSIG_OBJ_PRE_TRANSFER_REAGENTS, PROC_REF(on_transfer))
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/element/infinite_reagents/Detach(datum/target)
	UnregisterSignal(target, COMSIG_OBJ_PRE_TRANSFER_REAGENTS)
	UnregisterSignal(target, COMSIG_PARENT_EXAMINE)

	return ..()

/datum/element/infinite_reagents/proc/on_transfer(obj/item/reagent_containers/glass/source, mob/living/carbon/human/target)
	SIGNAL_HANDLER
	
	if(!source.reagents || !source.reagents.reagent_list.len)
		return

	for(var/datum/reagent/reagent in source.reagents.reagent_list)
		if(!is_type_in_list(reagent, whitelist))
			continue
		
		target.reagents.add_reagent(reagent.type, source.amount_per_gulp)

	return COMPONENT_PREVENT_CONTAINER_REAGENT_TRANSFER

/datum/element/infinite_reagents/proc/on_examine(atom/atom, mob/living/carbon/human/user, list/examine_info)
	SIGNAL_HANDLER

	examine_info += span_warning("Blessed by Baotha!")
