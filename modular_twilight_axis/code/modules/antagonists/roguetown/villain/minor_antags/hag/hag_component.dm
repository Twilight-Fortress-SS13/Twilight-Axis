/obj/item/clothing/neck/roguetown/psicross/hag/can_use_wyrd_power(mob/living/user, hag_allowed)
	if(hag_allowed && HAS_TRAIT(user, TRAIT_ANCIENT_HAG))
		return TRUE

	var/datum/component/hag_curio_tracker/HCT = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!HCT)
		return FALSE

	if(HCT.find_boon_by_type(user.real_name, /datum/hag_boon/item/wyrd_cross))
		return TRUE
	return FALSE

/datum/component/hag_magical_item/on_handed_over(datum/source, mob/living/receiver, mob/living/offerer)
	SIGNAL_HANDLER
	var/datum/component/hag_curio_tracker/HCT = offerer.GetComponent(/datum/component/hag_curio_tracker)
	if(!HCT)
		return

	if(HCT.user_can_receive_boon(boon_type, receiver.real_name))
		HCT.grant_boon(receiver.real_name, boon_type, boon_type.points)
		var/obj/item/O = parent
		to_chat(offerer, span_notice("You bind the [O.name] to [receiver.real_name]."))
		to_chat(receiver, span_boldnotice("The [O.name] hums with a dark, familiar energy."))
	else
		to_chat(offerer, span_warning("The connection fails. [receiver.real_name] has too many boons or curses already."))
		to_chat(receiver, span_warning("Your body can't contain more nature magic right now."))
