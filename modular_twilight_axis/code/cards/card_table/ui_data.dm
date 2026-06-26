/datum/card_table_session/proc/build_card_data(list/cards, hidden = FALSE)
	var/list/out = list()
	for(var/i = 1, i <= cards.len, i++)
		var/list/card = cards[i]
		out += list(list(
			"index" = i,
			"label" = hidden ? "??" : card_table_card_label(card),
			"rank" = hidden ? "?" : card["rank"],
			"suit" = hidden ? "?" : card["suit"],
			"hidden" = hidden,
			"value" = hidden ? null : blackjack_card_nominal(card),
		))
	return out

/datum/card_table_session/proc/build_xylix_peek_cards(mob/user) as /list
	var/count = min(xylix_peek_count(user), deck.len)
	if(count <= 0)
		return list()
	var/list/cards = list()
	for(var/i = 1, i <= count, i++)
		cards += list(deck[i])
	return build_card_data(cards, FALSE)

/datum/card_table_session/proc/build_solitaire_tableau() as /list
	var/list/out = list()
	for(var/i = 1, i <= solitaire_tableau.len, i++)
		var/list/column = solitaire_tableau[i]
		var/list/cards = list()
		for(var/j = 1, j <= column.len, j++)
			var/list/card = column[j]
			var/hidden = !card["face_up"]
			var/list/card_data = build_card_data(list(card), hidden)
			cards += list(card_data[1])
		out += list(list(
			"index" = i,
			"cards" = cards,
		))
	return out

/datum/card_table_session/proc/build_solitaire_foundations() as /list
	var/list/out = list()
	for(var/suit in list("H", "D", "C", "S"))
		var/list/foundation = solitaire_foundations[suit]
		var/list/top_card = (islist(foundation) && foundation.len) ? foundation[foundation.len] : null
		var/list/card_data = top_card ? build_card_data(list(top_card), FALSE) : null
		out += list(list(
			"suit" = suit,
			"card" = card_data ? card_data[1] : null,
			"count" = islist(foundation) ? foundation.len : 0,
		))
	return out

/datum/card_table_session/proc/build_fool_table_pairs() as /list
	var/list/out = list()
	for(var/i = 1, i <= table_pairs.len, i++)
		var/list/pair = table_pairs[i]
		var/list/attack = pair["attack"]
		var/list/defense = pair["defense"]
		var/list/attack_data = attack ? build_card_data(list(attack), FALSE) : null
		var/list/defense_data = defense ? build_card_data(list(defense), FALSE) : null
		out += list(list(
			"index" = i,
			"attack" = attack_data ? attack_data[1] : null,
			"defense" = defense_data ? defense_data[1] : null,
		))
	return out

/datum/card_table_session/proc/current_rules() as /list
	var/list/rules = list()
	switch(game_type)
		if(CARD_TABLE_GAME_FOOL)
			rules += "Цель: первым избавиться от всех карт после окончания колоды."
			rules += "Атакующий кладет карту, защитник бьет старшей той же масти или козырем."
			if(fool_variant == CARD_TABLE_FOOL_THROW_IN || fool_variant == CARD_TABLE_FOOL_THROW_TRANSFER)
				rules += "Этруский вариант: дополнительные карты можно подкидывать по рангу уже лежащих карт. В первом бою максимум 5 атак, дальше можно подкидывать, пока у защитника есть карты на руке."
			if(fool_variant == CARD_TABLE_FOOL_TRANSFER || fool_variant == CARD_TABLE_FOOL_THROW_TRANSFER)
				rules += "Отаванский вариант: защитник может перевести ход картой того же ранга."
			if(fool_variant == CARD_TABLE_FOOL_CLASSIC)
				rules += "Хаммерхолдский вариант: одна атака и одна защита за ход."
		if(CARD_TABLE_GAME_BLACKJACK)
			rules += "Цель: набрать ближе к 21, не перебрав."
			rules += "Взять берет карту, Оставить фиксирует руку."
			rules += "Дилер всегда один из игроков. [dealer_rotation_label()]."
			switch(blackjack_variant)
				if(CARD_TABLE_BLACKJACK_GRON)
					rules += "Гроннский: туз считается за 1; валет, дама и король за 11."
				if(CARD_TABLE_BLACKJACK_VALORIA)
					rules += "Валорийский: туз, валет, дама и король считаются за 10."
				if(CARD_TABLE_BLACKJACK_GRENZELHOFT)
					rules += "Грензельхофтский: туз за 10, но два туза дают 21; валет, дама и король за 10."
				if(CARD_TABLE_BLACKJACK_KAZENGUN)
					rules += "Казенгунский: туз, валет, дама и король считаются за 1."
				else
					rules += "Азурийский: туз за 11, но два туза дают 21; валет, дама и король за 10."
		if(CARD_TABLE_GAME_POKER)
			rules += "Цель: собрать лучшую комбинацию."
			switch(poker_variant)
				if(CARD_TABLE_POKER_TEXAS)
					rules += "Ранешенский: у игрока 2 карты, на столе 5 общих карт."
				if(CARD_TABLE_POKER_OMAHA)
					rules += "Валорийский: у игрока 4 карты, на столе 5 общих карт."
				if(CARD_TABLE_POKER_STUD)
					rules += "Гиза: игрок получает 5 личных карт без обмена."
				else
					rules += "Азурийский: игрок получает 5 карт и может один раз заменить одну карту."
			rules += "Дилер всегда один из игроков. [dealer_rotation_label()]."
		if(CARD_TABLE_GAME_SOLITAIRE)
			rules += "Цель: разложить карты по стопкам пасьянса."
			if(solitaire_variant == CARD_TABLE_SOLITAIRE_SPIDER)
				rules += "Паук: две колоды, десять колонок. Запас сдает по карте в каждую колонку."
				rules += "Переносить можно открытую нисходящую последовательность одной масти. Собранная масть от короля до туза снимается."
			else
				rules += "Солитер: семь колонок, запас и четыре базы по мастям от туза до короля."
	return rules

/datum/card_table_session/proc/build_ui_data(mob/user) as /list
	var/datum/card_table_player/me = player_for_user(user)
	var/list/player_rows = list()
	for(var/datum/card_table_player/player in players)
		var/list/player_row = player_public_data_for(player, me, user)
		var/show_hand = (stage == CARD_TABLE_STAGE_FINISHED || player == me)
		player_row["hand_value"] = (show_hand && game_type == CARD_TABLE_GAME_BLACKJACK) ? hand_value(player.hand) : null
		player_row["is_dealer"] = (player == dealer_player())
		player_rows += list(player_row)
	var/list/observer_rows = list()
	for(var/ckey in observers)
		var/mob/M = card_table_find_mob_by_ckey(ckey)
		observer_rows += M ? card_table_display_name(M) : ckey
	var/list/my_hand = me ? build_card_data(me.hand, FALSE) : list()
	var/list/waste_card = null
	if(discard.len)
		var/list/waste_data = build_card_data(list(discard[discard.len]), FALSE)
		waste_card = waste_data[1]
	var/fool_is_playing = (stage == CARD_TABLE_STAGE_PLAYING && game_type == CARD_TABLE_GAME_FOOL)
	var/datum/card_table_player/current_attacker = fool_is_playing ? fool_current_attacker() : null
	var/datum/card_table_player/current_defender = fool_is_playing ? fool_current_defender() : null
	var/datum/card_table_player/table_dealer = dealer_player()
	var/my_ckey = user ? user.ckey : null
	var/is_host = (me && player_index(me) == 1)
	var/xylix_level = xylix_tier(user)
	return list(
		"game_type" = game_type,
		"game_label" = game_label(),
		"fool_variant" = fool_variant,
		"fool_variant_label" = fool_variant_label(),
		"poker_variant" = poker_variant,
		"poker_variant_label" = poker_variant_label(),
		"blackjack_variant" = blackjack_variant,
		"blackjack_variant_label" = blackjack_variant_label(),
		"solitaire_variant" = solitaire_variant,
		"solitaire_variant_label" = solitaire_variant_label(),
		"dealer_rotates" = dealer_rotates,
		"dealer_rotation_label" = dealer_rotation_label(),
		"dealer_name" = table_dealer ? table_dealer.name : null,
		"rules" = current_rules(),
		"stage" = stage,
		"message" = message,
		"players" = player_rows,
		"observers" = observer_rows,
		"my_ckey" = my_ckey,
		"is_player" = !!me,
		"is_host" = is_host,
		"is_observer" = is_observer(user),
		"my_hand" = my_hand,
		"deck_count" = deck.len,
		"discard_count" = discard.len,
		"min_players" = min_players(),
		"max_players" = max_players(),
		"can_start" = (stage == CARD_TABLE_STAGE_LOBBY && is_host && game_type != CARD_TABLE_GAME_NONE && players.len >= min_players()),
		"can_pack" = can_pack(),
		"dealer_value" = (table_dealer && stage == CARD_TABLE_STAGE_FINISHED) ? hand_value(table_dealer.hand) : null,
		"community_cards" = build_card_data(community_cards, FALSE),
		"my_value" = me ? hand_value(me.hand) : null,
		"solitaire_tableau" = build_solitaire_tableau(),
		"solitaire_stock_count" = solitaire_stock.len,
		"solitaire_waste" = waste_card,
		"solitaire_foundations" = build_solitaire_foundations(),
		"solitaire_completed_sets" = solitaire_completed_sets,
		"attacker" = current_attacker ? current_attacker.name : null,
		"defender" = current_defender ? current_defender.name : null,
		"table_attack" = (fool_is_playing && table_attack) ? card_table_card_label(table_attack) : null,
		"table_defense" = (fool_is_playing && table_defense) ? card_table_card_label(table_defense) : null,
		"table_pairs" = fool_is_playing ? build_fool_table_pairs() : list(),
		"trump" = fool_is_playing ? trump_suit : null,
		"xylix" = list(
			"enabled" = (stage == CARD_TABLE_STAGE_PLAYING && xylix_level >= CLERIC_T0 && game_type != CARD_TABLE_GAME_SOLITAIRE),
			"tier" = xylix_level,
			"skill" = xylix_holy_skill(user),
			"caught_chance" = xylix_caught_chance(user),
			"can_choose" = xylix_can_choose_card(user),
			"cards" = build_xylix_peek_cards(user),
		),
	)
