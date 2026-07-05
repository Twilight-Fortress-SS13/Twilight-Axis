/datum/card_table_session
	var/obj/item/toy/cards/deck/owner
	var/game_type = CARD_TABLE_GAME_NONE
	var/stage = CARD_TABLE_STAGE_LOBBY
	var/list/players = list()
	var/list/observers = list()
	var/list/deck = list()
	var/list/discard = list()
	var/list/dealer_hand = list()
	var/list/community_cards = list()
	var/list/solitaire_tableau = list()
	var/list/solitaire_stock = list()
	var/list/solitaire_foundations = list()
	var/solitaire_completed_sets = 0
	var/list/xylix_seen_cards = list()
	var/list/xylix_cheat_used = list()
	var/message = "Выберите игру и места."
	var/fool_variant = CARD_TABLE_FOOL_CLASSIC
	var/poker_variant = CARD_TABLE_POKER_DRAW
	var/blackjack_variant = CARD_TABLE_BLACKJACK_AZURE
	var/solitaire_variant = CARD_TABLE_SOLITAIRE_KLONDIKE
	var/dealer_rotates = TRUE
	var/dealer_index = 0
	var/dealer_rounds = 0

	var/current_index = 1
	var/defender_index = 2
	var/fool_defender_start_hand = 0
	var/fool_first_bout = TRUE
	var/list/table_pairs = list()
	var/list/table_attack = null
	var/list/table_defense = null
	var/list/trump_card = null
	var/trump_suit = null

/datum/card_table_session/New(obj/item/toy/cards/deck/new_owner)
	owner = new_owner

/datum/card_table_session/Destroy()
	owner = null
	if(players)
		for(var/datum/card_table_player/P in players)
			qdel(P)
	players = null
	observers = null
	deck = null
	discard = null
	dealer_hand = null
	community_cards = null
	solitaire_tableau = null
	solitaire_stock = null
	solitaire_foundations = null
	xylix_seen_cards = null
	xylix_cheat_used = null
	table_pairs = null
	table_attack = null
	table_defense = null
	trump_card = null
	return ..()

/datum/card_table_session/proc/reset_to_lobby()
	stage = CARD_TABLE_STAGE_LOBBY
	for(var/i = players.len, i >= 1, i--)
		var/datum/card_table_player/leaver = players[i]
		if(leaver.left || leaver.is_spirit)
			players.Cut(i, i + 1)
			qdel(leaver)
	deck = list()
	discard = list()
	dealer_hand = list()
	community_cards = list()
	solitaire_tableau = list()
	solitaire_stock = list()
	solitaire_foundations = list()
	solitaire_completed_sets = 0
	xylix_seen_cards = list()
	xylix_cheat_used = list()
	table_pairs = list()
	table_attack = null
	table_defense = null
	trump_card = null
	trump_suit = null
	current_index = 1
	defender_index = 2
	fool_defender_start_hand = 0
	fool_first_bout = TRUE
	for(var/datum/card_table_player/player in players)
		player.hand = list()
		player.standing = FALSE
		player.busted = FALSE
		player.ready = FALSE
		player.draws_used = 0
		player.result = null
		player.left = FALSE
	if(dealer_index > players.len)
		dealer_index = players.len ? 1 : 0
	message = "Раунд сброшен. Игроки остаются за столом."

/datum/card_table_session/proc/game_label()
	switch(game_type)
		if(CARD_TABLE_GAME_FOOL)
			return "Дурень"
		if(CARD_TABLE_GAME_BLACKJACK)
			return "Блекджек"
		if(CARD_TABLE_GAME_POKER)
			return "Покер"
		if(CARD_TABLE_GAME_SOLITAIRE)
			return "Пасьянс"
	return "Не выбрано"

/datum/card_table_session/proc/fool_variant_label()
	switch(fool_variant)
		if(CARD_TABLE_FOOL_THROW_IN)
			return "Этруский"
		if(CARD_TABLE_FOOL_TRANSFER)
			return "Отаванский"
		if(CARD_TABLE_FOOL_THROW_TRANSFER)
			return "Грензельхофтский"
	return "Хаммерхолдский"

/datum/card_table_session/proc/poker_variant_label()
	switch(poker_variant)
		if(CARD_TABLE_POKER_TEXAS)
			return "Ранешенский"
		if(CARD_TABLE_POKER_OMAHA)
			return "Валорийский"
		if(CARD_TABLE_POKER_STUD)
			return "Гиза"
	return "Азурийский"

/datum/card_table_session/proc/blackjack_variant_label()
	switch(blackjack_variant)
		if(CARD_TABLE_BLACKJACK_GRON)
			return "Гроннский"
		if(CARD_TABLE_BLACKJACK_VALORIA)
			return "Валорийский"
		if(CARD_TABLE_BLACKJACK_GRENZELHOFT)
			return "Грензельхофтский"
		if(CARD_TABLE_BLACKJACK_KAZENGUN)
			return "Казенгунский"
	return "Азурийский"

/datum/card_table_session/proc/solitaire_variant_label()
	switch(solitaire_variant)
		if(CARD_TABLE_SOLITAIRE_SPIDER)
			return "Паук"
	return "Солитер"

/datum/card_table_session/proc/dealer_rotation_label()
	return dealer_rotates ? "Дилер меняется" : "Дилер один"

/datum/card_table_session/proc/max_players()
	switch(game_type)
		if(CARD_TABLE_GAME_FOOL)
			return 6
		if(CARD_TABLE_GAME_BLACKJACK)
			return 5
		if(CARD_TABLE_GAME_POKER)
			return 6
		if(CARD_TABLE_GAME_SOLITAIRE)
			return 1
	return 6

/datum/card_table_session/proc/max_players_for_game(new_game)
	switch(new_game)
		if(CARD_TABLE_GAME_FOOL)
			return 6
		if(CARD_TABLE_GAME_BLACKJACK)
			return 5
		if(CARD_TABLE_GAME_POKER)
			return 6
		if(CARD_TABLE_GAME_SOLITAIRE)
			return 1
	return 6

/datum/card_table_session/proc/min_players()
	switch(game_type)
		if(CARD_TABLE_GAME_BLACKJACK)
			return 1
		if(CARD_TABLE_GAME_POKER)
			return 1
		if(CARD_TABLE_GAME_FOOL)
			return 1
		if(CARD_TABLE_GAME_SOLITAIRE)
			return 1
	return 0

/datum/card_table_session/proc/can_pack()
	return !players.len && !observers.len

/datum/card_table_session/proc/player_is_active(datum/card_table_player/player)
	return player && !player.left && player.result != "Out" && player.result != "Fool"

/datum/card_table_session/proc/fool_ensure_spirit_opponent()
	if(game_type != CARD_TABLE_GAME_FOOL || players.len != 1)
		return
	var/datum/card_table_player/spirit = new()
	spirit.ckey = "card_table_spirit"
	spirit.name = "Карточный дух"
	spirit.is_spirit = TRUE
	players += spirit

/datum/card_table_session/proc/active_players_count()
	var/count = 0
	for(var/datum/card_table_player/player in players)
		if(player_is_active(player))
			count++
	return count

/datum/card_table_session/proc/player_for_user(mob/user)
	if(!user || !user.ckey)
		return null
	for(var/datum/card_table_player/player in players)
		if(!player.left && player.ckey == user.ckey)
			return player
	return null

/datum/card_table_session/proc/player_index(datum/card_table_player/target)
	if(!target)
		return 0
	for(var/i = 1, i <= players.len, i++)
		if(players[i] == target)
			return i
	return 0

/datum/card_table_session/proc/is_observer(mob/user)
	if(!user || !user.ckey)
		return FALSE
	return (user.ckey in observers)
