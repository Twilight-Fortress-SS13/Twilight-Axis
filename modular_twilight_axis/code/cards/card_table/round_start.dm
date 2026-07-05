/datum/card_table_session/proc/start_game(mob/user)
	if(stage != CARD_TABLE_STAGE_LOBBY || game_type == CARD_TABLE_GAME_NONE)
		return FALSE
	var/datum/card_table_player/requester = player_for_user(user)
	if(!requester || player_index(requester) != 1)
		return FALSE
	if(players.len < min_players())
		to_chat(user, span_warning("Недостаточно игроков."))
		return FALSE
	if(game_type == CARD_TABLE_GAME_FOOL)
		fool_ensure_spirit_opponent()
	if((game_type == CARD_TABLE_GAME_BLACKJACK || game_type == CARD_TABLE_GAME_POKER) && players.len)
		if(!dealer_rotates)
			dealer_index = 1
		else if(!dealer_index)
			dealer_index = 1
		else if(dealer_rotates && dealer_rounds > 0)
			advance_dealer()
		dealer_rounds++
	deck = card_table_make_deck()
	discard = list()
	dealer_hand = list()
	community_cards = list()
	solitaire_tableau = list()
	solitaire_stock = list()
	solitaire_foundations = list()
	solitaire_completed_sets = 0
	xylix_seen_cards = list()
	xylix_cheat_used = list()
	for(var/datum/card_table_player/player in players)
		player.hand = list()
		player.standing = FALSE
		player.busted = FALSE
		player.ready = FALSE
		player.draws_used = 0
		player.result = null
		player.left = FALSE
	stage = CARD_TABLE_STAGE_PLAYING
	current_index = 1
	defender_index = min(2, players.len)
	switch(game_type)
		if(CARD_TABLE_GAME_BLACKJACK)
			for(var/datum/card_table_player/bj_player in players)
				deal_to(bj_player, 2)
			for(var/datum/card_table_player/bj_reveal_player in players)
				xylix_try_reveal_for_turn_holder(bj_reveal_player)
			message = "Блекджек начался. Вариант: [blackjack_variant_label()]. [dealer_rotation_label()]."
		if(CARD_TABLE_GAME_POKER)
			for(var/datum/card_table_player/poker_player in players)
				switch(poker_variant)
					if(CARD_TABLE_POKER_TEXAS)
						deal_to(poker_player, 2)
					if(CARD_TABLE_POKER_OMAHA)
						deal_to(poker_player, 4)
					else
						deal_to(poker_player, 5)
			if(poker_variant == CARD_TABLE_POKER_TEXAS || poker_variant == CARD_TABLE_POKER_OMAHA)
				for(var/i = 1, i <= 5, i++)
					community_cards += list(draw_one())
			for(var/datum/card_table_player/poker_reveal_player in players)
				xylix_try_reveal_for_turn_holder(poker_reveal_player)
			message = "Покер начался. Вариант: [poker_variant_label()]. [dealer_rotation_label()]."
		if(CARD_TABLE_GAME_SOLITAIRE)
			if(solitaire_variant == CARD_TABLE_SOLITAIRE_SPIDER)
				deck += card_table_make_deck()
				deck = shuffle(deck)
				solitaire_foundations = list()
				for(var/spider_column_index = 1, spider_column_index <= 10, spider_column_index++)
					var/list/spider_column = list()
					var/cards_in_column = (spider_column_index <= 4) ? 6 : 5
					for(var/spider_card_index = 1, spider_card_index <= cards_in_column, spider_card_index++)
						var/list/spider_card = draw_one()
						if(!spider_card)
							break
						spider_card["face_up"] = (spider_card_index == cards_in_column)
						spider_column += list(spider_card)
					solitaire_tableau += list(spider_column)
				solitaire_stock = deck.Copy()
				deck = list()
			else
				solitaire_foundations = list("H" = list(), "D" = list(), "C" = list(), "S" = list())
				for(var/column_index = 1, column_index <= 7, column_index++)
					var/list/column = list()
					for(var/card_index = 1, card_index <= column_index, card_index++)
						var/list/card = draw_one()
						if(!card)
							break
						card["face_up"] = (card_index == column_index)
						column += list(card)
					solitaire_tableau += list(column)
				solitaire_stock = deck.Copy()
				deck = list()
			message = "Пасьянс разложен. Вариант: [solitaire_variant_label()]."
		if(CARD_TABLE_GAME_FOOL)
			for(var/datum/card_table_player/fool_player in players)
				deal_to(fool_player, 6)
			trump_card = draw_one()
			if(trump_card)
				trump_suit = trump_card["suit"]
				deck += list(trump_card)
			table_attack = null
			table_defense = null
			table_pairs = list()
			var/datum/card_table_player/starting_defender = fool_current_defender()
			fool_defender_start_hand = starting_defender ? starting_defender.hand.len : 0
			fool_first_bout = TRUE
			xylix_try_reveal_for_turn_holder(fool_current_attacker())
			message = "Дурень начался. Вариант: [fool_variant_label()]. Козырь: [trump_suit]."
			fool_process_spirit_turn()
	SStgui.update_uis(owner)
	return TRUE
