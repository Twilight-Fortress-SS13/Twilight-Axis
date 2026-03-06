#define CTYPE_GOLD "tg"
#define CTYPE_COPPER "tc"
#define CTYPE_KAZEN "te"
#define MAX_COIN_STACK_SIZE 20

//OTAVAN MARQUE - WORTHLESS TO ANYONE BUT INQ.
/obj/item/roguecoin/inqcoin
	desc = "An unusual coin, minted primarily from base metals rather than gold or silver, finished with a unique wash of black dye and bearing the post-tsardom Psycross. Due to extreme export controls employed by Otava, most guilds refuse to trade in these coins, even at their face value."

//GOLD
/obj/item/roguecoin/gold
	desc = "A gold coin bearing a stylized portrait of Kaiser Alister II Grenzelhoft and the Cross of the Eleven. Minted by the Imperial Treasury, these coins can be found all across the Western Kingdoms."

//VALORIAN MONIES
/obj/item/roguecoin/goldkrona
	name = "krona"
	desc = "The krona, or 'crown' in simplified Imperial, is a gold coin minted in the Valorian capital of Eterna, serving as the national currency of Valoria and several neighbouring realms. The coin bears the Crown of Most Serene Doge and the symbol of Ten Undivided."
	icon_state = "tg1"
	sellprice = 14
	base_type = CTYPE_GOLD
	plural_name = "kronas"
	icon = 'modular_twilight_axis/lore/icons/valuable.dmi'

/obj/item/roguecoin/goldkrona/poor_pile/Initialize()
	. = ..()
	set_quantity(rand(1,3))

/obj/item/roguecoin/goldkrona/mid_pile/Initialize()
	. = ..()
	set_quantity(rand(3,6))

/obj/item/roguecoin/goldkrona/rich_pile/Initialize()
	. = ..()
	set_quantity(rand(5,10))

/obj/item/roguecoin/goldkrona/veryrich_pile/Initialize()
	. = ..()
	set_quantity(rand(10,19))

/obj/item/storage/belt/rogue/pouch/kronas
	preload = TRUE

/obj/item/storage/belt/rogue/pouch/kronas/PopulateContents()
	for(var/path in populate_contents)
		var/obj/item/new_item = SSwardrobe.provide_type(path, loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
			new_item.inventory_flip(null, TRUE)
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))

				SSwardrobe.recycle_object(new_item)

/obj/item/storage/belt/rogue/pouch/kronas/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/goldkrona/poor_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/kronas/mid/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/goldkrona/mid_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/kronas/mid/PopulateContents()
	. = ..()
	var/obj/item/roguecoin/goldkrona/mid_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/goldkrona/mid_pile, loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			SSwardrobe.recycle_object(H)

/obj/item/storage/belt/rogue/pouch/kronas/poor/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/goldkrona/poor_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/kronas/poor/PopulateContents()
	. = ..()
	var/obj/item/roguecoin/goldkrona/poor_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/goldkrona/poor_pile, loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			SSwardrobe.recycle_object(H)

/obj/item/storage/belt/rogue/pouch/kronas/rich/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/goldkrona/rich_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/kronas/rich/PopulateContents()
	. = ..()
	var/obj/item/roguecoin/goldkrona/rich_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/goldkrona/rich_pile, loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			SSwardrobe.recycle_object(H)

/obj/item/storage/belt/rogue/pouch/kronas/veryrich/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/goldkrona/veryrich_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/kronas/veryrich/PopulateContents()
	. = ..()
	var/obj/item/roguecoin/goldkrona/veryrich_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/goldkrona/veryrich_pile, loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			SSwardrobe.recycle_object(H)

/obj/item/roguecoin/copper/Initialize(mapload)
	. = ..()
	if(SSmapping.config.map_name == "Rockhill")
		name = "shilling"
		desc = "The shilling is a small copper coin minted by the Valorian Treasury. The coin bears the Lion of Most Serene Eterna and the symbol of Ten Undivided."
		icon_state = "tc1"
		sellprice = 1
		base_type = CTYPE_COPPER
		plural_name = "shillings"
		icon = 'modular_twilight_axis/lore/icons/valuable.dmi'
		update_icon()

/obj/item/roguecoin/copper/update_icon()
	. = ..()
	if(quantity == 1 && SSmapping.config.map_name == "Rockhill")
		name = "shilling"
		desc = "The shilling is a small copper coin minted by the Valorian Treasury. The coin bears the Lion of Most Serene Eterna and the symbol of Ten Undivided."

/obj/item/roguecoin/copper/ready_pile_rockhill/Initialize()
	. = ..()
	set_quantity(20)

/obj/item/roguecoin/silver/Initialize(mapload)
	. = ..()
	if(SSmapping.config.map_name == "Rockhill")
		if(quantity <= 4)
			name = "shilling"
			desc = "The shilling is a small copper coin minted by the Valorian Treasury. The coin bears the Lion of Most Serene Eterna and the symbol of Ten Undivided."
			icon_state = "tc1"
			sellprice = 1
			base_type = CTYPE_COPPER
			plural_name = "shillings"
			icon = 'modular_twilight_axis/lore/icons/valuable.dmi'
			quantity *= 5
			update_icon()
		else
			name = "krona"
			desc = "The krona, or 'crown' in simplified Imperial, is a gold coin minted in the Valorian capital of Eterna, serving as the national currency of Valoria and several neighbouring realms. The coin bears the Crown of Most Serene Doge and the symbol of Ten Undivided."
			icon_state = "tg1"
			sellprice = 14
			base_type = CTYPE_GOLD
			plural_name = "kronas"
			icon = 'modular_twilight_axis/lore/icons/valuable.dmi'
			quantity = floor(quantity/3)
			update_icon()

/obj/item/roguecoin/silver/update_icon()
	. = ..()
	if(quantity == 1 && SSmapping.config.map_name == "Rockhill")
		switch(base_type)
			if(CTYPE_COPPER)
				name = "shilling"
				desc = "The shilling is a small copper coin minted by the Valorian Treasury. The coin bears the Lion of Most Serene Eterna and the symbol of Ten Undivided."
			if(CTYPE_GOLD)
				name = "krona"
				desc = "The krona, or 'crown' in simplified Imperial, is a gold coin minted in the Valorian capital of Eterna, serving as the national currency of Valoria and several neighbouring realms. The coin bears the Crown of Most Serene Doge and the symbol of Ten Undivided."

/obj/item/roguecoin/gold/Initialize(mapload)
	. = ..()
	if(SSmapping.config.map_name == "Rockhill")
		name = "krona"
		desc = "The krona, or 'crown' in simplified Imperial, is a gold coin minted in the Valorian capital of Eterna, serving as the national currency of Valoria and several neighbouring realms. The coin bears the Crown of Most Serene Doge and the symbol of Ten Undivided."
		icon_state = "tg1"
		sellprice = 14
		base_type = CTYPE_GOLD
		plural_name = "kronas"
		icon = 'modular_twilight_axis/lore/icons/valuable.dmi'
		update_icon()

/obj/item/roguecoin/gold/update_icon()
	. = ..()
	if(quantity == 1 && SSmapping.config.map_name == "Rockhill")
		name = "krona"
		desc = "The krona, or 'crown' in simplified Imperial, is a gold coin minted in the Valorian capital of Eterna, serving as the national currency of Valoria and several neighbouring realms. The coin bears the Crown of Most Serene Doge and the symbol of Ten Undivided."

//KAZENGUNESE MONIES
/obj/item/roguecoin/shucoin
	name = "shu"
	desc = "The Shu coin, minted from an alloy of gold and silver, has been increasingly used in the Kazen Shogunate economy in recent decades, allowing the Clans to move away from direct barter. The coin has a hole in the middle, allowing for it to be carried on a string."
	icon_state = "te1"
	sellprice = 7
	base_type = CTYPE_KAZEN
	plural_name = "shu"
	icon = 'modular_twilight_axis/lore/icons/valuable.dmi'

/obj/item/roguecoin/shucoin/poor_pile/Initialize()
	. = ..()
	set_quantity(rand(2,4))

/obj/item/roguecoin/shucoin/mid_pile/Initialize()
	. = ..()
	set_quantity(rand(4,7))

/obj/item/roguecoin/shucoin/rich_pile/Initialize()
	. = ..()
	set_quantity(rand(6,12))

/obj/item/roguecoin/shucoin/veryrich_pile/Initialize()
	. = ..()
	set_quantity(rand(12,19))

/obj/item/storage/belt/rogue/pouch/shucoin
	preload = TRUE

/obj/item/storage/belt/rogue/pouch/shucoin/PopulateContents()
	for(var/path in populate_contents)
		var/obj/item/new_item = SSwardrobe.provide_type(path, loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
			new_item.inventory_flip(null, TRUE)
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))

				SSwardrobe.recycle_object(new_item)

/obj/item/storage/belt/rogue/pouch/shucoin/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/shucoin/poor_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/shucoin/mid/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/shucoin/mid_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/shucoin/mid/PopulateContents()
	. = ..()
	var/obj/item/roguecoin/shucoin/mid_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/shucoin/mid_pile, loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			SSwardrobe.recycle_object(H)
	var/obj/item/roguecoin/shucoin/poor_pile/C = SSwardrobe.provide_type(/obj/item/roguecoin/shucoin/poor_pile, loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			SSwardrobe.recycle_object(C)

/obj/item/storage/belt/rogue/pouch/shucoin/poor/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/shucoin/poor_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/shucoin/poor/PopulateContents()
	. = ..()
	var/obj/item/roguecoin/shucoin/poor_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/shucoin/poor_pile, loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			SSwardrobe.recycle_object(H)
	H = SSwardrobe.provide_type(/obj/item/roguecoin/shucoin/poor_pile, loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			SSwardrobe.recycle_object(H)

/obj/item/storage/belt/rogue/pouch/shucoin/rich/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/shucoin/rich_pile
	to_preload += /obj/item/roguecoin/shucoin/mid_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/shucoin/rich/PopulateContents()
	. = ..()
	var/obj/item/roguecoin/shucoin/rich_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/shucoin/rich_pile, loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			SSwardrobe.recycle_object(H)
	var/obj/item/roguecoin/shucoin/mid_pile/C = SSwardrobe.provide_type(/obj/item/roguecoin/shucoin/mid_pile, loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			SSwardrobe.recycle_object(C)

/obj/item/storage/belt/rogue/pouch/shucoin/veryrich/get_types_to_preload()
	var/list/to_preload = list() 
	to_preload += /obj/item/roguecoin/shucoin/veryrich_pile
	to_preload += /obj/item/roguecoin/shucoin/rich_pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/shucoin/veryrich/PopulateContents()
	. = ..()
	var/obj/item/roguecoin/shucoin/veryrich_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/shucoin/veryrich_pile, loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			SSwardrobe.recycle_object(H)
	var/obj/item/roguecoin/shucoin/rich_pile/C = SSwardrobe.provide_type(/obj/item/roguecoin/shucoin/rich_pile, loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			SSwardrobe.recycle_object(C)

//Rockhill coin pouches overrides

/obj/item/storage/belt/rogue/pouch/coins/get_types_to_preload()
	var/list/to_preload = list()
	if(SSmapping.config.map_name == "Rockhill")
		to_preload += /obj/item/roguecoin/goldkrona/poor_pile
	else
		to_preload += /obj/item/roguecoin/copper/pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/mid/get_types_to_preload()
	var/list/to_preload = list() 
	if(SSmapping.config.map_name == "Rockhill")
		to_preload += /obj/item/roguecoin/goldkrona/mid_pile
	else
		to_preload += /obj/item/roguecoin/silver/pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/mid/PopulateContents()
	if(SSmapping.config.map_name == "Rockhill")
		var/obj/item/roguecoin/goldkrona/mid_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/goldkrona/mid_pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
	else
		var/obj/item/roguecoin/silver/pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/silver/pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
		var/obj/item/roguecoin/copper/pile/C = SSwardrobe.provide_type(/obj/item/roguecoin/copper/pile, loc)
		if(istype(C))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
				SSwardrobe.recycle_object(C)

/obj/item/storage/belt/rogue/pouch/coins/poor/get_types_to_preload()
	var/list/to_preload = list() 
	if(SSmapping.config.map_name == "Rockhill")
		to_preload += /obj/item/roguecoin/goldkrona/poor_pile
	else
		to_preload += /obj/item/roguecoin/copper/pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/poor/PopulateContents()
	if(SSmapping.config.map_name == "Rockhill")
		var/obj/item/roguecoin/goldkrona/poor_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/goldkrona/poor_pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
	else
		var/obj/item/roguecoin/copper/pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/copper/pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
		if(prob(50))
			H = SSwardrobe.provide_type(/obj/item/roguecoin/copper/pile, loc)
			if(istype(H))
				if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
					SSwardrobe.recycle_object(H)

/obj/item/storage/belt/rogue/pouch/coins/rich/get_types_to_preload()
	var/list/to_preload = list() 
	if(SSmapping.config.map_name == "Rockhill")
		to_preload += /obj/item/roguecoin/goldkrona/rich_pile
	else
		to_preload += /obj/item/roguecoin/silver/pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/rich/PopulateContents()
	if(SSmapping.config.map_name == "Rockhill")
		var/obj/item/roguecoin/goldkrona/rich_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/goldkrona/rich_pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
	else
		var/obj/item/roguecoin/silver/pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/silver/pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
		H = SSwardrobe.provide_type(/obj/item/roguecoin/silver/pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
		if(prob(50))
			H = SSwardrobe.provide_type(/obj/item/roguecoin/silver/pile, loc)
			if(istype(H))
				if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
					SSwardrobe.recycle_object(H)

/obj/item/storage/belt/rogue/pouch/coins/veryrich/get_types_to_preload()
	var/list/to_preload = list() 
	if(SSmapping.config.map_name == "Rockhill")
		to_preload += /obj/item/roguecoin/goldkrona/veryrich_pile
	else
		to_preload += /obj/item/roguecoin/gold/pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/veryrich/PopulateContents()
	if(SSmapping.config.map_name == "Rockhill")
		var/obj/item/roguecoin/goldkrona/veryrich_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/goldkrona/veryrich_pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
	else
		var/obj/item/roguecoin/gold/pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/gold/pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
		H = SSwardrobe.provide_type(/obj/item/roguecoin/gold/pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
		if(prob(50))
			H = SSwardrobe.provide_type(/obj/item/roguecoin/gold/pile, loc)
			if(istype(H))
				if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
					SSwardrobe.recycle_object(H)

/obj/item/storage/belt/rogue/pouch/coins/virtuepouch/get_types_to_preload()
	var/list/to_preload = list() 
	if(SSmapping.config.map_name == "Rockhill")
		to_preload += /obj/item/roguecoin/goldkrona/rich_pile
	else
		to_preload += /obj/item/roguecoin/gold/virtuepile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/virtuepouch/PopulateContents()
	if(SSmapping.config.map_name == "Rockhill")
		var/obj/item/roguecoin/goldkrona/rich_pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/goldkrona/rich_pile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
	else
		var/obj/item/roguecoin/gold/virtuepile/H = SSwardrobe.provide_type(/obj/item/roguecoin/gold/virtuepile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)

/obj/item/storage/belt/rogue/pouch/coins/readyuppouch/get_types_to_preload()
	var/list/to_preload = list() 
	if(SSmapping.config.map_name == "Rockhill")
		to_preload += /obj/item/roguecoin/copper/ready_pile_rockhill
	else
		to_preload += /obj/item/roguecoin/silver/pile/readyuppile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/readyuppouch/PopulateContents()
	if(SSmapping.config.map_name == "Rockhill")
		var/obj/item/roguecoin/copper/ready_pile_rockhill/H = SSwardrobe.provide_type(/obj/item/roguecoin/copper/ready_pile_rockhill, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
	else
		var/obj/item/roguecoin/silver/pile/readyuppile/H = SSwardrobe.provide_type(/obj/item/roguecoin/silver/pile/readyuppile, loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)

#undef CTYPE_GOLD
#undef CTYPE_COPPER
#undef CTYPE_KAZEN
#undef MAX_COIN_STACK_SIZE
