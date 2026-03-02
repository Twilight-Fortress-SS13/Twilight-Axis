/obj/structure/chair/arrestchair/rockhill/budget2change(budget, mob/user, specify)
	var/turf/T
	if(!user || (!ismob(user)))
		T = get_turf(src)
	else
		T = get_turf(user)
	if(!budget || budget <= 0)
		return
	budget = floor(budget)
	var/type_to_put
	var/zenars_to_put
	if(specify)
		switch(specify)
			if("GOLD", "SILVER")
				zenars_to_put = budget/14
				type_to_put = /obj/item/roguecoin/goldkrona
			if("BRONZE")
				zenars_to_put = budget
				type_to_put = /obj/item/roguecoin/copper
	else
		var/highest_found = FALSE
		var/zenars = floor(budget/14)
		if(zenars)
			budget -= zenars * 14
			highest_found = TRUE
			type_to_put = /obj/item/roguecoin/goldkrona
			zenars_to_put = zenars
		if(budget >= 1)
			if(!highest_found)
				type_to_put = /obj/item/roguecoin/copper
				zenars_to_put = budget
			else
				new /obj/item/roguecoin/copper(T, budget)
	if(!type_to_put || zenars_to_put < 1)
		return
	new type_to_put(T, floor(zenars_to_put))
	playsound(T, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
