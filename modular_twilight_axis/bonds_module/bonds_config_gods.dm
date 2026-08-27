/datum/bond_storyteller_lens/proc/weight_for(id_a, id_b)
	if(!length(pair_weights))
		return default_weight
	var/key = bonds_stance_key(id_a, id_b)
	if(!key)
		return default_weight
	var/weight = pair_weights[key]
	return isnull(weight) ? default_weight : weight

/datum/bond_storyteller_lens/psydon
	storyteller_type = /datum/storyteller/psydon
	dream_positive_bias = 0.9
	dream_negative_bias = 1.3
	default_weight = 1
	pair_weights = list(
		"church|inquisition" = 1.8,
		"church|noble" = 1.3,
	)

/datum/bond_storyteller_lens/astrata
	storyteller_type = /datum/storyteller/astrata
	dream_positive_bias = 1.2
	dream_negative_bias = 0.9
	default_weight = 0.8
	pair_weights = list(
		"garrison|outlaw" = 1.4,
		"citywatch|outlaw" = 1.4,
	)

/datum/bond_storyteller_lens/noc
	storyteller_type = /datum/storyteller/noc
	dream_positive_bias = 1.0
	dream_negative_bias = 1.2
	default_weight = 0.9

/datum/bond_storyteller_lens/ravox
	storyteller_type = /datum/storyteller/ravox
	dream_positive_bias = 1.1
	dream_negative_bias = 1.4
	default_weight = 1.2
	pair_weights = list(
		"garrison|retinue" = 0.6,
		"citywatch|garrison" = 0.6,
	)

/datum/bond_storyteller_lens/abyssor
	storyteller_type = /datum/storyteller/abyssor
	dream_positive_bias = 0.9
	dream_negative_bias = 1.2
	default_weight = 1

/datum/bond_storyteller_lens/xylix
	storyteller_type = /datum/storyteller/xylix
	dream_positive_bias = 1.3
	dream_negative_bias = 1.2
	default_weight = 1.4

/datum/bond_storyteller_lens/necra
	storyteller_type = /datum/storyteller/necra
	dream_positive_bias = 1.1
	dream_negative_bias = 1.2
	default_weight = 1.1

/datum/bond_storyteller_lens/pestra
	storyteller_type = /datum/storyteller/pestra
	dream_positive_bias = 0.8
	dream_negative_bias = 1.3
	default_weight = 0.8

/datum/bond_storyteller_lens/malum
	storyteller_type = /datum/storyteller/malum
	dream_positive_bias = 1.1
	dream_negative_bias = 1.0
	default_weight = 1
	pair_weights = list(
		"atc|burgher" = 1.5,
	)

/datum/bond_storyteller_lens/eora
	storyteller_type = /datum/storyteller/eora
	dream_positive_bias = 1.6
	dream_negative_bias = 0.5
	default_weight = 0.6

/datum/bond_storyteller_lens/dendor
	storyteller_type = /datum/storyteller/dendor
	dream_positive_bias = 1.0
	dream_negative_bias = 1.1
	default_weight = 1.1
