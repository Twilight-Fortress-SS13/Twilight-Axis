/obj/effect/spawner/lootdrop/do_spawn()
	if(prob(probby))
		if(!spawned)
			return
		var/obj/new_type = pick(spawned)
		if(SSmapping.config.map_name == "Rockhill")
			switch(new_type)
				if(/obj/item/roguecoin/silver)
					new_type = /obj/item/roguecoin/goldkrona
				if(/obj/item/roguecoin/gold)
					new_type = /obj/item/roguecoin/goldkrona
				if(/obj/item/roguecoin/copper/pile)
					new_type = /obj/item/roguecoin/goldkrona/poor_pile
				if(/obj/item/roguecoin/silver/pile)
					new_type = /obj/item/roguecoin/goldkrona/mid_pile
				if(/obj/item/roguecoin/gold/pile)
					new_type = /obj/item/roguecoin/goldkrona/rich_pile
		new new_type(get_turf(src))
