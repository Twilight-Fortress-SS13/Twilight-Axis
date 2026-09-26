/obj/structure/roguemachine/talkstatue/mercenary/rockhill
    desc = "A gilbronze warrior erupts from the stone bell that homes them; foreign garb, horns of stone, claws of deathly metals. The perfect central-point of a proud warrior extrinsic to this place and tyme. \n\ \n\ I can place five shillings in to message one mercenary, and gold krona for all of them."

/obj/structure/roguemachine/talkstatue/mercenary/rockhill/attackby(obj/item/P, mob/living/carbon/human/user, params)
	// Proximity check - user must be adjacent to the statue
	if(!Adjacent(user))
		to_chat(user, span_warning("I need to be closer to the statue."))
		return

	if(istype(P, /obj/item/roguecoin/copper))
		// Silver coin - message a specific mercenary
		var/obj/item/roguecoin/copper/coin = P
		if(coin.quantity != 5)
			to_chat(user, span_warning("I need to use five shillings exactly."))
			return
		message_single_mercenary(user, coin)
		return

	if(istype(P, /obj/item/roguecoin/goldkrona))
		// Gold coin - broadcast to all mercenaries
		var/obj/item/roguecoin/gold/coin = P
		if(coin.quantity > 1)
			to_chat(user, span_warning("I need to use a single krona."))
			return
		broadcast_to_mercenaries(user, coin)
		return

	return ..()
