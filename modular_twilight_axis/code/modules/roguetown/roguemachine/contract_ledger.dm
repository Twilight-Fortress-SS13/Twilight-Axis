/obj/structure/roguemachine/contractledger/rockhill/cash_in(reward, original_reward, tax_amt)
	var/list/coin_types = list(
		/obj/item/roguecoin/goldkrona = FLOOR(reward / 14, 1),
		/obj/item/roguecoin/copper = reward % 14
	)

	for(var/coin_type in coin_types)
		var/amount = coin_types[coin_type]
		if(amount > 0)
			var/obj/item/roguecoin/coin_stack = new coin_type(get_turf(src))
			coin_stack.quantity = amount
			coin_stack.update_icon()
			coin_stack.update_transform()

	if(reward > 0)
		say(reward > original_reward ? \
			"Your handler assistance-increased reward of [reward] mammons has been dispensed! The difference is [reward - original_reward] mammons. ([tax_amt] mammons taxed.)" : \
			"Your reward of [reward] mammons has been dispensed. ([tax_amt] mammons taxed.)")
