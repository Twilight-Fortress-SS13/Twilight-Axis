/datum/card_table_session/proc/solitaire_card_color(list/card)
	if(!islist(card))
		return null
	var/suit = "[card["suit"]]"
	return (suit == "H" || suit == "D") ? "red" : "black"

/datum/card_table_session/proc/solitaire_foundation_rank(list/card)
	if(!islist(card))
		return 0
	var/rank = "[card["rank"]]"
	if(rank == "A")
		return 1
	if(rank == "J")
		return 11
	if(rank == "Q")
		return 12
	if(rank == "K")
		return 13
	return text2num(rank)

/datum/card_table_session/proc/solitaire_top_foundation(suit)
	var/list/foundation = solitaire_foundations[suit]
	if(!islist(foundation) || !foundation.len)
		return null
	return foundation[foundation.len]

/datum/card_table_session/proc/solitaire_can_place_on_foundation(list/card, suit)
	if(!islist(card) || "[card["suit"]]" != "[suit]")
		return FALSE
	var/list/top_card = solitaire_top_foundation(suit)
	if(!top_card)
		return solitaire_foundation_rank(card) == 1
	return solitaire_foundation_rank(card) == solitaire_foundation_rank(top_card) + 1

/datum/card_table_session/proc/solitaire_can_place_on_tableau(list/card, column_index)
	if(!islist(card) || column_index < 1 || column_index > solitaire_tableau.len)
		return FALSE
	var/list/column = solitaire_tableau[column_index]
	if(!column.len)
		return solitaire_variant == CARD_TABLE_SOLITAIRE_SPIDER || solitaire_foundation_rank(card) == 13
	var/list/top_card = column[column.len]
	if(!top_card["face_up"])
		return FALSE
	if(solitaire_variant == CARD_TABLE_SOLITAIRE_SPIDER)
		return solitaire_foundation_rank(card) == solitaire_foundation_rank(top_card) - 1
	if(solitaire_card_color(card) == solitaire_card_color(top_card))
		return FALSE
	return solitaire_foundation_rank(card) == solitaire_foundation_rank(top_card) - 1

/datum/card_table_session/proc/solitaire_spider_stack_is_movable(list/column, start_index)
	if(!islist(column) || start_index < 1 || start_index > column.len)
		return FALSE
	var/list/first_card = column[start_index]
	if(!first_card["face_up"])
		return FALSE
	for(var/i = start_index + 1, i <= column.len, i++)
		var/list/previous_card = column[i - 1]
		var/list/current_card = column[i]
		if(!current_card["face_up"])
			return FALSE
		if("[current_card["suit"]]" != "[previous_card["suit"]]")
			return FALSE
		if(solitaire_foundation_rank(current_card) != solitaire_foundation_rank(previous_card) - 1)
			return FALSE
	return TRUE

/datum/card_table_session/proc/solitaire_check_spider_runs()
	if(solitaire_variant != CARD_TABLE_SOLITAIRE_SPIDER)
		return
	for(var/column_index = 1, column_index <= solitaire_tableau.len, column_index++)
		var/list/column = solitaire_tableau[column_index]
		if(!islist(column) || column.len < 13)
			continue
		var/start_index = column.len - 12
		var/list/king = column[start_index]
		if(solitaire_foundation_rank(king) != 13 || !solitaire_spider_stack_is_movable(column, start_index))
			continue
		var/list/ace = column[column.len]
		if(solitaire_foundation_rank(ace) != 1)
			continue
		column.Cut(start_index, column.len + 1)
		solitaire_completed_sets++
		solitaire_reveal_column(column_index)

/datum/card_table_session/proc/solitaire_reveal_column(column_index)
	if(column_index < 1 || column_index > solitaire_tableau.len)
		return
	var/list/column = solitaire_tableau[column_index]
	if(column.len)
		var/list/top_card = column[column.len]
		top_card["face_up"] = TRUE

/datum/card_table_session/proc/solitaire_draw(mob/user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_SOLITAIRE || !player_for_user(user))
		return FALSE
	if(solitaire_variant == CARD_TABLE_SOLITAIRE_SPIDER)
		if(solitaire_stock.len < solitaire_tableau.len)
			return FALSE
		for(var/list/column in solitaire_tableau)
			if(!column.len)
				to_chat(user, span_warning("В пауке нельзя сдавать из запаса, пока есть пустая колонка."))
				return FALSE
		for(var/column_index = 1, column_index <= solitaire_tableau.len, column_index++)
			var/list/card = solitaire_stock[solitaire_stock.len]
			solitaire_stock.Cut(solitaire_stock.len, solitaire_stock.len + 1)
			card["face_up"] = TRUE
			var/list/target_column = solitaire_tableau[column_index]
			target_column += list(card)
		solitaire_check_spider_runs()
		if(solitaire_completed_sets >= 8)
			stage = CARD_TABLE_STAGE_FINISHED
			message = "[card_table_display_name(user)] раскладывает паука."
		else
			message = "[card_table_display_name(user)] сдает ряд из запаса."
		return TRUE
	if(solitaire_stock.len)
		var/list/card = solitaire_stock[solitaire_stock.len]
		solitaire_stock.Cut(solitaire_stock.len, solitaire_stock.len + 1)
		card["face_up"] = TRUE
		discard += list(card)
		message = "[card_table_display_name(user)] открывает карту из запаса."
		return TRUE
	if(discard.len)
		for(var/i = discard.len, i >= 1, i--)
			var/list/card = discard[i]
			card["face_up"] = FALSE
			solitaire_stock += list(card)
		discard = list()
		message = "[card_table_display_name(user)] переворачивает сброс в запас."
		return TRUE
	return FALSE

/datum/card_table_session/proc/solitaire_move(source_type, source_column, source_index, target_type, target_column, target_suit, mob/user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_SOLITAIRE || !player_for_user(user))
		return FALSE
	source_column = text2num("[source_column]")
	source_index = text2num("[source_index]")
	target_column = text2num("[target_column]")
	var/list/card = null
	var/list/moving_cards = list()
	if(source_type == "waste")
		if(!discard.len)
			return FALSE
		card = discard[discard.len]
		moving_cards += list(card)
	else if(source_type == "tableau")
		if(source_column < 1 || source_column > solitaire_tableau.len)
			return FALSE
		var/list/source = solitaire_tableau[source_column]
		if(!source.len)
			return FALSE
		if(source_index < 1 || source_index > source.len)
			source_index = source.len
		card = source[source_index]
		if(!card["face_up"])
			return FALSE
		if(solitaire_variant == CARD_TABLE_SOLITAIRE_SPIDER && !solitaire_spider_stack_is_movable(source, source_index))
			return FALSE
		for(var/i = source_index, i <= source.len, i++)
			var/list/moving_card = source[i]
			if(!moving_card["face_up"])
				return FALSE
			moving_cards += list(moving_card)
	else
		return FALSE
	if(target_type == "foundation")
		if(solitaire_variant == CARD_TABLE_SOLITAIRE_SPIDER)
			return FALSE
		if(moving_cards.len != 1)
			return FALSE
		if(!solitaire_can_place_on_foundation(card, target_suit))
			return FALSE
	else if(target_type == "tableau")
		if(!solitaire_can_place_on_tableau(card, target_column))
			return FALSE
	else
		return FALSE
	if(source_type == "waste")
		discard.Cut(discard.len, discard.len + 1)
	else
		var/list/source_column_list = solitaire_tableau[source_column]
		source_column_list.Cut(source_index, source_column_list.len + 1)
		solitaire_reveal_column(source_column)
	if(target_type == "foundation")
		var/list/foundation = solitaire_foundations[target_suit]
		foundation += list(card)
		message = "[card_table_display_name(user)] кладет [card_table_card_label(card)] в базу."
	else
		var/list/target_column_list = solitaire_tableau[target_column]
		for(var/list/moving_card in moving_cards)
			target_column_list += list(moving_card)
		message = "[card_table_display_name(user)] перекладывает [card_table_card_label(card)]."
		solitaire_check_spider_runs()
		if(solitaire_variant == CARD_TABLE_SOLITAIRE_SPIDER && solitaire_completed_sets >= 8)
			stage = CARD_TABLE_STAGE_FINISHED
			message = "[card_table_display_name(user)] раскладывает паука."
	var/foundation_cards = 0
	for(var/suit in list("H", "D", "C", "S"))
		var/list/foundation_check = solitaire_foundations[suit]
		if(islist(foundation_check))
			foundation_cards += foundation_check.len
	if(foundation_cards >= 52)
		stage = CARD_TABLE_STAGE_FINISHED
		message = "[card_table_display_name(user)] раскладывает пасьянс."
	return TRUE
