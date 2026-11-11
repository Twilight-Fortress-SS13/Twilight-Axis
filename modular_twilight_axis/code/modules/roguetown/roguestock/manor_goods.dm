#define TRADE_GOOD_MANOR_VENISON "MANOR_VENISON"
#define TRADE_GOOD_MANOR_BUSHMEAT "MANOR_BUSHMEAT"
#define TRADE_GOOD_MANOR_BEAR_MEAT "MANOR_BEAR_MEAT"
#define TRADE_GOOD_MANOR_CRAB_MEAT "MANOR_CRAB_MEAT"
#define TRADE_GOOD_MANOR_BOAR_HAM "MANOR_BOAR_HAM"

/datum/roguestock/stockpile/deer
	trade_good_id = TRADE_GOOD_MANOR_VENISON

/datum/roguestock/stockpile/volf
	trade_good_id = TRADE_GOOD_MANOR_BUSHMEAT

/datum/roguestock/stockpile/bear
	trade_good_id = TRADE_GOOD_MANOR_BEAR_MEAT

/datum/roguestock/stockpile/crabbo
	trade_good_id = TRADE_GOOD_MANOR_CRAB_MEAT

/datum/roguestock/stockpile/boarham
	trade_good_id = TRADE_GOOD_MANOR_BOAR_HAM

/datum/roguestock/stockpile/manor_rope
	name = "Rope"
	item_type = /obj/item/rope
	trade_good_id = TRADE_GOOD_ROPE
	importexport_amt = 5
	stockpile_limit = 25
	category = "Refined"

/datum/trade_good/animal_fresh/manor_venison
	id = TRADE_GOOD_MANOR_VENISON
	name = "Venison"
	base_price = 8
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga

/datum/trade_good/animal_fresh/manor_bushmeat
	id = TRADE_GOOD_MANOR_BUSHMEAT
	name = "Bushmeat"
	base_price = 2
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/wolf

/datum/trade_good/animal_fresh/manor_bear_meat
	id = TRADE_GOOD_MANOR_BEAR_MEAT
	name = "Greater Bushmeat"
	base_price = 6
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/bear

/datum/trade_good/animal_fresh/manor_crab_meat
	id = TRADE_GOOD_MANOR_CRAB_MEAT
	name = "Crab Meat"
	base_price = 4
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab

/datum/trade_good/animal_fresh/manor_boar_ham
	id = TRADE_GOOD_MANOR_BOAR_HAM
	name = "Boar Ham"
	base_price = 8
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/ham/boar

/datum/trade_good/animal_fresh/manor_honey
	id = TRADE_GOOD_HONEY
	name = "Honey"
	base_price = SELLPRICE_SUGAR
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/rogue/honey

/datum/trade_good/vegetable/manor_mushroom
	id = TRADE_GOOD_MUSHROOM
	name = "Mushroom"
	base_price = SELLPRICE_POTATO
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/rogue/mushroom

/proc/migrateManorResourceChoices(list/choices, site)
	if(!islist(choices))
		return null
	var/replacement
	switch(site)
		if("hunt")
			replacement = TRADE_GOOD_MANOR_VENISON
		if("farm")
			replacement = TRADE_GOOD_MANOR_BOAR_HAM
		if("fish")
			replacement = TRADE_GOOD_MANOR_CRAB_MEAT
	var/list/migrated = list()
	for(var/id in choices)
		if(id == TRADE_GOOD_MEAT_EXOTIC && replacement)
			id = replacement
		migrated |= id
	return migrated
