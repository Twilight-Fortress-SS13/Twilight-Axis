/datum/workstation
	var/workstation_name = "Угодье"
	var/list/produce = list()
	var/workstation_size = 5
	var/workers_employed = 0
	var/type_of_produce = "Goods"
	var/production_increase_per_job = 0
	var/production_modifier = 1
	var/workstation_theme = "field"

/datum/workstation/proc/get_theme_key()
	switch(workstation_theme)
		if("fruit")
			return "orchard"
	return workstation_theme

/datum/workstation/field
	workstation_name = "Поля"
	workstation_theme = "field"
	produce = list(
		/datum/roguestock/stockpile/grain,
		/datum/roguestock/stockpile/oat,
		/datum/roguestock/stockpile/rice,
		/datum/roguestock/stockpile/cabbage,
		/datum/roguestock/stockpile/potato,
		/datum/roguestock/stockpile/onion,
		/datum/roguestock/stockpile/garlick,
		/datum/roguestock/stockpile/turnip,
		/datum/roguestock/stockpile/carrot,
		/datum/roguestock/stockpile/cucumber,
		/datum/roguestock/stockpile/eggplant,
	)

/datum/workstation/field/medium
	workstation_size = 10

/datum/workstation/field/big
	workstation_size = 20

/datum/workstation/fruit
	workstation_name = "Сады"
	workstation_theme = "fruit"
	produce = list(
		/datum/roguestock/stockpile/apple,
		/datum/roguestock/stockpile/jacksberry,
		/datum/roguestock/stockpile/pear,
		/datum/roguestock/stockpile/tomato,
		/datum/roguestock/stockpile/pumpkin,
		/datum/roguestock/stockpile/plum,
		/datum/roguestock/stockpile/lime,
		/datum/roguestock/stockpile/lemon,
		/datum/roguestock/stockpile/raspberry,
		/datum/roguestock/stockpile/strawberry,
	)

/datum/workstation/fruit/medium
	workstation_size = 10

/datum/workstation/fruit/big
	workstation_size = 20

/datum/workstation/hunt
	workstation_name = "Охотничьи угодья"
	workstation_theme = "hunt"
	produce = list(
		/datum/roguestock/stockpile/hide,
		/datum/roguestock/stockpile/cured,
		/datum/roguestock/stockpile/fur,
		/datum/roguestock/stockpile/rabbit,
		/datum/roguestock/stockpile/meat,
		/datum/roguestock/stockpile/poultry,
		/datum/roguestock/stockpile/fat,
		/datum/roguestock/stockpile/tallow,
	)

/datum/workstation/hunt/medium
	workstation_size = 10

/datum/workstation/hunt/big
	workstation_size = 20

/datum/workstation/farm
	workstation_name = "Фермы"
	workstation_theme = "farm"
	produce = list(
		/datum/roguestock/stockpile/hide,
		/datum/roguestock/stockpile/meat,
		/datum/roguestock/stockpile/pork,
		/datum/roguestock/stockpile/fat,
		/datum/roguestock/stockpile/tallow,
		/datum/roguestock/stockpile/egg,
		/datum/roguestock/stockpile/butter,
		/datum/roguestock/stockpile/cheese,
	)

/datum/workstation/farm/medium
	workstation_size = 10

/datum/workstation/farm/big
	workstation_size = 20

/datum/workstation/outpost
	workstation_name = "Аванпост"
	workstation_theme = "outpost"
	produce = list()
	workstation_size = 6
	production_increase_per_job = 0
	type_of_produce = "Defense"

/datum/workstation/trade
	workstation_name = "Торговые ряды"
	workstation_theme = "trade"
	produce = list(
		/datum/roguestock/stockpile/tangerine,
		/datum/roguestock/stockpile/salt,
		/datum/roguestock/stockpile/sugar,
		/datum/roguestock/stockpile/tea,
		/datum/roguestock/stockpile/coffee,
		/datum/roguestock/stockpile/rocknut,
		/datum/roguestock/stockpile/silk,
	)
	type_of_produce = "Profit"

/datum/workstation/trade/medium
	workstation_size = 10

/datum/workstation/trade/big
	workstation_size = 20

/datum/workstation/fish
	workstation_name = "Заводи"
	workstation_theme = "fish"
	produce = list(
		/datum/roguestock/stockpile/fishmince,
		/datum/roguestock/stockpile/fishfilet,
		/datum/roguestock/stockpile/dried_fish,
		/datum/roguestock/stockpile/salmon,
		/datum/roguestock/stockpile/bass,
		/datum/roguestock/stockpile/carp,
		/datum/roguestock/stockpile/sole,
		/datum/roguestock/stockpile/cod,
		/datum/roguestock/stockpile/crab,
		/datum/roguestock/stockpile/clam,
		/datum/roguestock/stockpile/lobster,
		/datum/roguestock/stockpile/shrimp,
		/datum/roguestock/stockpile/salt,
	)

/datum/workstation/fish/medium
	workstation_size = 10

/datum/workstation/fish/big
	workstation_size = 20

/datum/workstation/mining
	workstation_name = "Шахты"
	workstation_theme = "mining"
	produce = list(
		/datum/roguestock/stockpile/iron,
		/datum/roguestock/stockpile/iron,
		/datum/roguestock/stockpile/copper,
		/datum/roguestock/stockpile/copper,
		/datum/roguestock/stockpile/tin,
		/datum/roguestock/stockpile/tin,
		/datum/roguestock/stockpile/coal,
		/datum/roguestock/stockpile/stone,
		/datum/roguestock/stockpile/clay,
	)

/datum/workstation/mining/medium
	workstation_size = 10

/datum/workstation/mining/big
	workstation_size = 20

/datum/workstation/forest
	workstation_name = "Леса"
	workstation_theme = "forest"
	produce = list(
		/datum/roguestock/stockpile/wood,
		/datum/roguestock/stockpile/wood,
		/datum/roguestock/stockpile/wood,
		/datum/roguestock/stockpile/wood,
		/datum/roguestock/stockpile/coal,
		/datum/roguestock/stockpile/coal,
	)

/datum/workstation/forest/medium
	workstation_size = 10

/datum/workstation/forest/big
	workstation_size = 20

//Special patron-related workstations
/datum/workstation/mage_tower
	workstation_name = "Башня магов"
	workstation_theme = "mage_tower"
	produce = list(
		/datum/roguestock/stockpile/cinnabar,
		/datum/roguestock/stockpile/calendula,
		/datum/roguestock/stockpile/viscera,
		/datum/roguestock/stockpile/dendor_essence,
	)

/datum/workstation/cathedral
	workstation_name = "Церковь Всеотца"
	workstation_theme = "cathedral"
	produce = list()
	production_increase_per_job = 0.05
	type_of_produce = "Boost"
