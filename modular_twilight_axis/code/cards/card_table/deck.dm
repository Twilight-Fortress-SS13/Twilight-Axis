/obj/item/toy/cards/deck
	var/card_table_mode = FALSE
	var/datum/card_table_session/card_table
	var/card_table_range_timer

/obj/item/toy/cards/deck/Destroy()
	if(card_table_range_timer)
		deltimer(card_table_range_timer)
		card_table_range_timer = null
	QDEL_NULL(card_table)
	return ..()

/obj/item/toy/cards/deck/proc/ensure_card_table() as /datum/card_table_session
	if(!card_table)
		card_table = new(src)
	return card_table

/obj/item/toy/cards/deck/proc/start_card_table_range_loop()
	if(card_table_range_timer)
		return
	card_table_range_timer = addtimer(CALLBACK(src, PROC_REF(card_table_range_tick)), CARD_TABLE_RANGE_CHECK_TIME, TIMER_STOPPABLE)

/obj/item/toy/cards/deck/proc/card_table_range_tick()
	card_table_range_timer = null
	if(!card_table_mode || QDELETED(src))
		return
	if(card_table)
		card_table.check_player_ranges()
		SStgui.update_uis(src)
	start_card_table_range_loop()

/obj/item/toy/cards/deck/proc/enter_card_table_mode(mob/user)
	if(user && user.is_holding(src))
		user.dropItemToGround(src)
	if(!isturf(loc) && user)
		forceMove(get_turf(user))
	card_table_mode = TRUE
	ensure_card_table()
	start_card_table_range_loop()
	if(user)
		user.visible_message(span_notice("[user] sets the deck up as a card table."), span_notice("You set the deck up as a card table."))

/obj/item/toy/cards/deck/proc/leave_card_table_mode(mob/user)
	if(!card_table_mode)
		return FALSE
	if(card_table && !card_table.can_pack())
		to_chat(user, span_warning("The card table can only be packed when everyone has left."))
		return FALSE
	card_table_mode = FALSE
	if(card_table_range_timer)
		deltimer(card_table_range_timer)
		card_table_range_timer = null
	QDEL_NULL(card_table)
	SStgui.close_uis(src)
	if(user)
		user.visible_message(span_notice("[user] packs the card table back into a normal deck."), span_notice("You pack the card table back into a normal deck."))
	return TRUE

/obj/item/toy/cards/deck/attack_right(mob/user, params)
	if(!user)
		return ..()
	if(card_table_mode)
		return leave_card_table_mode(user)
	enter_card_table_mode(user)
	return TRUE

/obj/item/toy/cards/deck/AltClick(mob/user)
	return ..()

/obj/item/toy/cards/deck/attack_hand(mob/user, params)
	if(card_table_mode)
		ui_interact(user)
		return TRUE
	draw_card(user)

/obj/item/toy/cards/deck/attack_self(mob/user)
	if(card_table_mode)
		ui_interact(user)
		return
	if(cooldown < world.time - 25)
		cards = shuffle(cards)
		playsound(src, 'sound/items/cardshuffle.ogg', 100, TRUE)
		user.visible_message("<span class='notice'>[user] shuffles the deck.</span>", "<span class='notice'>I shuffle the deck.</span>")
		cooldown = world.time

/obj/item/toy/cards/deck/MouseDrop(atom/over_object)
	if(card_table_mode)
		to_chat(usr, "<span class='warning'>The card table is in use.</span>")
		return
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || !(M.mobility_flags & MOBILITY_PICKUP))
		return
	if(Adjacent(usr))
		if(over_object == M && loc != M)
			M.put_in_hands(src)
			to_chat(usr, "<span class='notice'>I pick up the deck.</span>")
		else if(istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
				to_chat(usr, "<span class='notice'>I pick up the deck.</span>")
	else
		to_chat(usr, "<span class='warning'>I can't reach it from here!</span>")

/obj/item/toy/cards/deck/ui_state(mob/user)
	return GLOB.hold_or_view_state

/obj/item/toy/cards/deck/ui_interact(mob/user, datum/tgui/ui)
	if(!card_table_mode)
		return
	ensure_card_table()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CardTable", "Card Table")
		ui.open()

/obj/item/toy/cards/deck/ui_data(mob/user)
	if(!card_table_mode)
		return list()
	return ensure_card_table().build_ui_data(user)

/obj/item/toy/cards/deck/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!card_table_mode || !card_table)
		return FALSE
	var/mob/user = usr
	if(!user || !user.canUseTopic(src, be_close = TRUE))
		return FALSE
	switch(action)
		if("set_game")
			. = card_table.set_game(params["game"], user)
		if("set_fool_variant")
			. = card_table.set_fool_variant(params["variant"], user)
		if("set_poker_variant")
			. = card_table.set_poker_variant(params["variant"], user)
		if("set_blackjack_variant")
			. = card_table.set_blackjack_variant(params["variant"], user)
		if("set_solitaire_variant")
			. = card_table.set_solitaire_variant(params["variant"], user)
		if("set_dealer_rotation")
			. = card_table.set_dealer_rotation(params["rotates"], user)
		if("join_player")
			. = card_table.join_player(user)
		if("join_observer")
			. = card_table.join_observer(user)
		if("leave")
			. = card_table.release_user(user)
		if("start")
			. = card_table.start_game(user)
		if("reset_lobby")
			if(card_table.stage == CARD_TABLE_STAGE_FINISHED || !card_table.players.len)
				card_table.reset_to_lobby()
				. = TRUE
		if("blackjack_hit")
			. = card_table.blackjack_hit(user)
		if("blackjack_stand")
			. = card_table.blackjack_stand(user)
		if("xylix_choose_card")
			. = card_table.xylix_choose_deck_card(user, params["card_index"])
		if("solitaire_draw")
			. = card_table.solitaire_draw(user)
		if("solitaire_move")
			. = card_table.solitaire_move(params["source_type"], params["source_column"], params["source_index"], params["target_type"], params["target_column"], params["target_suit"], user)
		if("poker_discard")
			. = card_table.poker_discard(user, params["card_index"])
		if("poker_ready")
			. = card_table.poker_ready(user)
		if("poker_finish_turn")
			. = card_table.poker_finish_turn(user, params["card_index"])
		if("fool_attack")
			. = card_table.fool_attack(user, params["card_index"])
		if("fool_defend")
			. = card_table.fool_defend(user, params["card_index"])
		if("fool_transfer")
			. = card_table.fool_transfer(user, params["card_index"])
		if("fool_take")
			. = card_table.fool_take(user)
		if("fool_end_attack")
			. = card_table.fool_end_attack(user)
	if(.)
		SStgui.update_uis(src)
	return .
