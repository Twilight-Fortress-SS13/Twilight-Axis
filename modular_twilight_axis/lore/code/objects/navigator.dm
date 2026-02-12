/obj/structure/roguemachine/balloon_pad/budget2change(budget, mob/user, specify)
	var/turf/T = get_turf(src)
	if(!budget || budget <= 0)
		return
	budget = floor(budget)
	var/type_to_put
	var/zenars_to_put
	var/highest_found = FALSE
	if(prob(20))
		switch(rand(1,2))
			if(1)
				var/kronas = floor(budget/35)
				if(kronas)
					budget -= kronas * 14
					highest_found = TRUE
					type_to_put = /obj/item/roguecoin/goldkrona
					zenars_to_put = kronas
			if(2)
				var/shu = floor(budget/18)
				if(shu)
					budget -= shu * 7
					highest_found = TRUE
					type_to_put = /obj/item/roguecoin/shucoin
					zenars_to_put = shu
	var/zenars = floor(budget/10)
	if(zenars)
		budget -= zenars * 10
		if(!highest_found)
			highest_found = TRUE
			type_to_put = /obj/item/roguecoin/gold
			zenars_to_put = zenars
		else
			// Create multiple stacks if needed
			while(zenars > 0)
				var/stack_size = min(zenars, 20)
				var/obj/item/roguecoin/gold_stack = new /obj/item/roguecoin/gold(T, stack_size)
				if(user && zenars == stack_size) // Only put first stack in hands
					user.put_in_hands(gold_stack)
				zenars -= stack_size
	zenars = floor(budget/5)
	if(zenars)
		budget -= zenars * 5
		if(!highest_found)
			highest_found = TRUE
			type_to_put = /obj/item/roguecoin/silver
			zenars_to_put = zenars
		else
			// Create multiple stacks if needed
			while(zenars > 0)
				var/stack_size = min(zenars, 20)
				var/obj/item/roguecoin/silver_stack = new /obj/item/roguecoin/silver(T, stack_size)
				if(user && zenars == stack_size) // Only put first stack in hands
					user.put_in_hands(silver_stack)
				zenars -= stack_size
	if(budget >= 1)
		if(!highest_found)
			type_to_put = /obj/item/roguecoin/copper
			zenars_to_put = budget
		else
			// Create multiple stacks if needed
			while(budget > 0)
				var/stack_size = min(budget, 20)
				var/obj/item/roguecoin/copper_stack = new /obj/item/roguecoin/copper(T, stack_size)
				if(user && budget == stack_size) // Only put first stack in hands
					user.put_in_hands(copper_stack)
				budget -= stack_size
	if(!type_to_put || zenars_to_put < 1)
		return
	// Create multiple stacks if needed for the main type
	while(zenars_to_put > 0)
		var/stack_size = min(zenars_to_put, 20)
		var/obj/item/roguecoin/G = new type_to_put(T, stack_size)
		if(user && zenars_to_put == stack_size) // Only put first stack in hands
			user.put_in_hands(G)
		zenars_to_put -= stack_size
	playsound(T, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
