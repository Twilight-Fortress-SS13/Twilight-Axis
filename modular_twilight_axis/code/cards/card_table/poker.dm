/datum/card_table_session/proc/poker_discard(mob/user, card_index)
	var/datum/card_table_player/player = player_for_user(user)
	card_index = text2num("[card_index]")
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_POKER || poker_variant != CARD_TABLE_POKER_DRAW || !player || player.ready || player.draws_used >= 1)
		return FALSE
	if(card_index < 1 || card_index > player.hand.len)
		return FALSE
	discard += list(player.hand[card_index])
	player.hand.Cut(card_index, card_index + 1)
	var/list/new_card = draw_one()
	if(new_card)
		player.hand += list(new_card)
	player.draws_used = 1
	message = "[player.name] меняет карту."
	return TRUE

/datum/card_table_session/proc/poker_ready(mob/user)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_POKER || !player)
		return FALSE
	player.ready = TRUE
	message = "[player.name] готов."
	for(var/datum/card_table_player/P in players)
		if(P.left)
			continue
		if(!P.ready)
			return TRUE
	poker_finish()
	return TRUE

/datum/card_table_session/proc/poker_finish_turn(mob/user, card_index)
	var/datum/card_table_player/player = player_for_user(user)
	card_index = text2num("[card_index]")
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_POKER || !player || player.ready)
		return FALSE
	if(poker_variant == CARD_TABLE_POKER_DRAW && card_index >= 1 && card_index <= player.hand.len && player.draws_used < 1)
		discard += list(player.hand[card_index])
		player.hand.Cut(card_index, card_index + 1)
		var/list/new_card = draw_one()
		if(new_card)
			player.hand += list(new_card)
		player.draws_used = 1
	player.ready = TRUE
	message = "[player.name] завершает ход."
	for(var/datum/card_table_player/P in players)
		if(P.left)
			continue
		if(!P.ready)
			return TRUE
	poker_finish()
	return TRUE

/datum/card_table_session/proc/poker_score(list/hand)
	if(!hand)
		return 0
	var/list/counts = list()
	var/list/ranks = list()
	for(var/list/card in hand)
		var/rank = "[card["rank_value"]]"
		counts[rank] = text2num("[counts[rank]]") + 1
		ranks += card_table_card_rank_value(card)
	var/list/groups = list()
	for(var/rank_key in counts)
		groups += text2num("[counts[rank_key]]")
	groups = sortList(groups)
	var/high = 0
	for(var/value in ranks)
		high = max(high, text2num("[value]"))
	var/category = 1
	if(4 in groups)
		category = 7
	else if((3 in groups) && (2 in groups))
		category = 6
	else if(3 in groups)
		category = 4
	else
		var/pairs = 0
		for(var/group_count in groups)
			if(text2num("[group_count]") == 2)
				pairs++
		if(pairs >= 2)
			category = 3
		else if(pairs == 1)
			category = 2
	return category * 100 + high

/datum/card_table_session/proc/poker_score_for_player(datum/card_table_player/player)
	if(!player)
		return 0
	var/list/scored_hand = list()
	for(var/list/card in player.hand)
		scored_hand += list(card)
	if(poker_variant == CARD_TABLE_POKER_TEXAS || poker_variant == CARD_TABLE_POKER_OMAHA)
		for(var/list/table_card in community_cards)
			scored_hand += list(table_card)
	return poker_score(scored_hand)

/datum/card_table_session/proc/poker_finish()
	var/best_score = -1
	var/datum/card_table_player/winner = null
	for(var/datum/card_table_player/player in players)
		if(player.left)
			continue
		var/score = poker_score_for_player(player)
		if(score > best_score)
			best_score = score
			winner = player
	for(var/datum/card_table_player/P in players)
		if(P.left)
			if(!P.result)
				P.result = "Left"
		else
			P.result = (P == winner) ? "Winner" : "Lost"
	stage = CARD_TABLE_STAGE_FINISHED
	var/winner_name = winner ? winner.name : "Никто"
	message = "[winner_name] выигрывает раздачу."
