/datum/card_table_session/proc/fool_current_attacker() as /datum/card_table_player
	if(!players.len || current_index < 1 || current_index > players.len)
		return null
	var/datum/card_table_player/player = players[current_index]
	return player_is_active(player) ? player : null

/datum/card_table_session/proc/fool_current_defender() as /datum/card_table_player
	if(!players.len || defender_index < 1 || defender_index > players.len)
		return null
	var/datum/card_table_player/player = players[defender_index]
	return player_is_active(player) ? player : null

/datum/card_table_session/proc/fool_next_active_index(start_index, skip_index = 0)
	if(!players.len)
		return 0
	if(start_index < 1)
		start_index = 1
	if(start_index > players.len)
		start_index = 1
	for(var/offset = 0, offset < players.len, offset++)
		var/check_index = start_index + offset
		while(check_index > players.len)
			check_index -= players.len
		if(check_index == skip_index)
			continue
		var/datum/card_table_player/player = players[check_index]
		if(player_is_active(player))
			return check_index
	return 0

/datum/card_table_session/proc/fool_normalize_turn_after_leave()
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_FOOL)
		return
	if(active_players_count() < 2)
		stage = CARD_TABLE_STAGE_FINISHED
		for(var/datum/card_table_player/player in players)
			if(player_is_active(player))
				player.result = "Out"
		message = "Игра в дурня завершена: не хватает активных игроков."
		return
	if(!fool_current_attacker())
		current_index = fool_next_active_index(current_index + 1)
	if(!fool_current_defender() || defender_index == current_index)
		defender_index = fool_next_active_index(current_index + 1, current_index)
	var/datum/card_table_player/new_defender = fool_current_defender()
	fool_defender_start_hand = new_defender ? new_defender.hand.len : 0

/datum/card_table_session/proc/fool_can_beat(list/attack_card, list/defense_card)
	if(!attack_card || !defense_card)
		return FALSE
	var/a_suit = attack_card["suit"]
	var/d_suit = defense_card["suit"]
	if(d_suit == a_suit && card_table_card_rank_value(defense_card) > card_table_card_rank_value(attack_card))
		return TRUE
	if(d_suit == trump_suit && a_suit != trump_suit)
		return TRUE
	return FALSE

/datum/card_table_session/proc/fool_find_defense_card_index(datum/card_table_player/player)
	if(!player || !table_attack)
		return 0
	for(var/i = 1, i <= player.hand.len, i++)
		var/list/card = player.hand[i]
		if(fool_can_beat(table_attack, card))
			return i
	return 0

/datum/card_table_session/proc/fool_throwing_enabled()
	return (fool_variant == CARD_TABLE_FOOL_THROW_IN || fool_variant == CARD_TABLE_FOOL_THROW_TRANSFER)

/datum/card_table_session/proc/fool_pair_limit()
	var/datum/card_table_player/defender = fool_current_defender()
	var/limit = table_pairs.len + (defender ? defender.hand.len : 0)
	if(fool_first_bout)
		limit = min(limit, 5)
	return limit

/datum/card_table_session/proc/fool_table_ranks()
	var/list/ranks = list()
	for(var/list/pair in table_pairs)
		var/list/attack = pair["attack"]
		var/list/defense = pair["defense"]
		if(attack)
			ranks["[attack["rank"]]"] = TRUE
		if(defense)
			ranks["[defense["rank"]]"] = TRUE
	return ranks

/datum/card_table_session/proc/fool_can_throw_card(list/card)
	if(!card || !table_pairs.len || !fool_throwing_enabled())
		return FALSE
	if(table_pairs.len >= fool_pair_limit())
		return FALSE
	var/list/ranks = fool_table_ranks()
	return !!ranks["[card["rank"]]"]

/datum/card_table_session/proc/fool_player_can_throw(datum/card_table_player/player)
	if(!player || player == fool_current_defender())
		return FALSE
	for(var/list/card in player.hand)
		if(fool_can_throw_card(card))
			return TRUE
	return FALSE

/datum/card_table_session/proc/fool_find_throw_card_index(datum/card_table_player/player)
	if(!player || player == fool_current_defender())
		return 0
	for(var/i = 1, i <= player.hand.len, i++)
		var/list/card = player.hand[i]
		if(fool_can_throw_card(card))
			return i
	return 0

/datum/card_table_session/proc/fool_add_pair(list/attack_card)
	if(!attack_card)
		return
	table_pairs += list(list("attack" = attack_card, "defense" = null))
	table_attack = attack_card
	table_defense = null

/datum/card_table_session/proc/fool_set_current_defense(list/defense_card)
	if(!table_pairs.len || !defense_card)
		return
	var/list/pair = table_pairs[table_pairs.len]
	pair["defense"] = defense_card
	table_defense = defense_card

/datum/card_table_session/proc/fool_next_thrower()
	if(!fool_throwing_enabled() || !table_attack || !table_defense)
		return FALSE
	for(var/offset = 1, offset <= players.len, offset++)
		var/check_index = current_index + offset
		if(check_index > players.len)
			check_index -= players.len
		if(check_index == defender_index)
			continue
		var/datum/card_table_player/player = players[check_index]
		if(player_is_active(player) && fool_player_can_throw(player))
			current_index = check_index
			return TRUE
	return FALSE

/datum/card_table_session/proc/remove_hand_card(datum/card_table_player/player, card_index)
	card_index = text2num("[card_index]")
	if(!player || card_index < 1 || card_index > player.hand.len)
		return null
	var/list/card = player.hand[card_index]
	player.hand.Cut(card_index, card_index + 1)
	return card

/datum/card_table_session/proc/fool_spirit_card_index(datum/card_table_player/player)
	if(!player)
		return 0
	for(var/i = 1, i <= player.hand.len, i++)
		return i
	return 0

/datum/card_table_session/proc/fool_process_spirit_turn()
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_FOOL)
		return
	for(var/guard = 1, guard <= 20, guard++)
		var/datum/card_table_player/attacker = fool_current_attacker()
		var/datum/card_table_player/defender = fool_current_defender()
		if(attacker?.is_spirit)
			if(table_attack && !table_defense)
				return
			if(table_attack && table_defense)
				var/throw_index = fool_find_throw_card_index(attacker)
				if(throw_index)
					var/list/throw_card = remove_hand_card(attacker, throw_index)
					fool_add_pair(throw_card)
					message = "[attacker.name] подкидывает [card_table_card_label(throw_card)]."
					return
				message = "[attacker.name] отправляет карты в биту."
				fool_next_turn(FALSE)
				continue
			var/attack_index = fool_spirit_card_index(attacker)
			if(!attack_index)
				return
			var/list/attack_card = remove_hand_card(attacker, attack_index)
			fool_add_pair(attack_card)
			message = "[attacker.name] ходит [card_table_card_label(attack_card)]."
			return
		if(defender?.is_spirit && table_attack && !table_defense)
			var/defense_index = fool_find_defense_card_index(defender)
			if(defense_index)
				var/list/defense_card = remove_hand_card(defender, defense_index)
				fool_set_current_defense(defense_card)
				message = "[defender.name] отбивается [card_table_card_label(defense_card)]."
				return
			message = "[defender.name] забирает карты со стола."
			fool_next_turn(TRUE)
			continue
		return

/datum/card_table_session/proc/fool_refill()
	for(var/datum/card_table_player/player in players)
		if(!player_is_active(player))
			continue
		while(player.hand.len < 6 && deck.len)
			deal_to(player, 1)

/datum/card_table_session/proc/fool_next_turn(defender_takes = FALSE)
	var/datum/card_table_player/defender = fool_current_defender()
	for(var/list/pair in table_pairs)
		var/list/attack = pair["attack"]
		var/list/defense = pair["defense"]
		if(defender_takes)
			if(defender && attack)
				defender.hand += list(attack)
			if(defender && defense)
				defender.hand += list(defense)
		else
			if(attack)
				discard += list(attack)
			if(defense)
				discard += list(defense)
	table_attack = null
	table_defense = null
	table_pairs = list()
	xylix_cheat_used = list()
	fool_defender_start_hand = 0
	fool_refill()
	if(active_players_count() < 2)
		stage = CARD_TABLE_STAGE_FINISHED
		return
	if(!defender_takes)
		current_index = fool_next_active_index(defender_index)
	else
		current_index = fool_next_active_index(defender_index + 1)
	defender_index = fool_next_active_index(current_index + 1, current_index)
	fool_first_bout = FALSE
	var/datum/card_table_player/new_defender = fool_current_defender()
	fool_defender_start_hand = new_defender ? new_defender.hand.len : 0
	xylix_try_reveal_for_turn_holder(fool_current_attacker())
	for(var/datum/card_table_player/player in players)
		if(player_is_active(player) && !player.hand.len && !deck.len)
			player.result = "Out"
	var/active_count = active_players_count()
	if(active_count <= 1)
		stage = CARD_TABLE_STAGE_FINISHED
		for(var/datum/card_table_player/last in players)
			if(player_is_active(last))
				last.result = "Fool"
				message = "[last.name] - дурак."
				return
		message = "Игра в дурака завершена."
		return
	if(!fool_current_attacker())
		current_index = fool_next_active_index(current_index + 1)
	if(!fool_current_defender() || defender_index == current_index)
		defender_index = fool_next_active_index(current_index + 1, current_index)
	clamp_turns()

/datum/card_table_session/proc/fool_attack(mob/user, card_index)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_FOOL || player != fool_current_attacker())
		return FALSE
	if(table_attack && !table_defense)
		return FALSE
	var/list/card = remove_hand_card(player, card_index)
	if(!card)
		return FALSE
	if(table_pairs.len && !fool_can_throw_card(card))
		player.hand += list(card)
		return FALSE
	fool_add_pair(card)
	message = "[player.name] ходит [card_table_card_label(table_attack)]."
	fool_process_spirit_turn()
	return TRUE

/datum/card_table_session/proc/fool_defend(mob/user, card_index)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_FOOL || player != fool_current_defender() || !table_attack || table_defense)
		return FALSE
	var/defense_index = text2num("[card_index]")
	if(defense_index < 1 || defense_index > player.hand.len)
		return FALSE
	var/list/card = player.hand[defense_index]
	if(!fool_can_beat(table_attack, card))
		return FALSE
	fool_set_current_defense(remove_hand_card(player, defense_index))
	message = "[player.name] отбивается [card_table_card_label(table_defense)]."
	fool_process_spirit_turn()
	return TRUE

/datum/card_table_session/proc/fool_transfer(mob/user, card_index)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_FOOL || player != fool_current_defender() || !table_attack || table_defense)
		return FALSE
	if(fool_variant != CARD_TABLE_FOOL_TRANSFER && fool_variant != CARD_TABLE_FOOL_THROW_TRANSFER)
		return FALSE
	var/transfer_index = text2num("[card_index]")
	if(transfer_index < 1 || transfer_index > player.hand.len)
		return FALSE
	var/list/card = player.hand[transfer_index]
	if(card["rank"] != table_attack["rank"])
		return FALSE
	var/list/transfer_card = remove_hand_card(player, transfer_index)
	fool_add_pair(transfer_card)
	current_index = defender_index
	defender_index = fool_next_active_index(current_index + 1, current_index)
	var/datum/card_table_player/new_defender = fool_current_defender()
	fool_defender_start_hand = new_defender ? new_defender.hand.len : 0
	message = "[player.name] переводит ход картой [card_table_card_label(table_attack)]."
	fool_process_spirit_turn()
	return TRUE

/datum/card_table_session/proc/fool_take(mob/user)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_FOOL || player != fool_current_defender() || !table_attack)
		return FALSE
	message = "[player.name] забирает карты со стола."
	fool_next_turn(TRUE)
	fool_process_spirit_turn()
	return TRUE

/datum/card_table_session/proc/fool_end_attack(mob/user)
	var/datum/card_table_player/player = player_for_user(user)
	if(stage != CARD_TABLE_STAGE_PLAYING || game_type != CARD_TABLE_GAME_FOOL || player != fool_current_attacker() || !table_attack || !table_defense)
		return FALSE
	message = "[player.name] отправляет карты в биту."
	fool_next_turn(FALSE)
	fool_process_spirit_turn()
	return TRUE
