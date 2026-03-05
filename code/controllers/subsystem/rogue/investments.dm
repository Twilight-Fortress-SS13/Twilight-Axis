SUBSYSTEM_DEF(investments)
	name = "investments"
	wait = 60 SECONDS 
	flags = SS_KEEP_TIMING
	var/max_available_investments = 10
	var/list/available_investments = list()
	var/list/awaiting_investments = list()
	var/list/active_investments = list()
	var/fire_num_before_regen = 2
	var/fire_num_before_hard = 3

/datum/controller/subsystem/investments/Initialize(start_timeofday)
	regenerate_investments()
	. = ..()
	
/datum/controller/subsystem/investments/fire(resumed = 0)
	process_investments()
	if(times_fired % fire_num_before_regen) 
		regenerate_investments()
	else if(times_fired % fire_num_before_hard)
		regenerate_investments(TRUE)
	

/datum/controller/subsystem/investments/proc/regenerate_investments(force_reload = FALSE)
	if(force_reload)
		for(var/datum/investment/I in available_investments)
			qdel(I)
		available_investments.Cut()

	if(available_investments.len < max_available_investments)
		var/list/datum/investment/investments = subtypesof(/datum/investment)
		var/diff = max_available_investments - available_investments.len
		for(var/i = 1, i<diff, ++i)
			var/random_investment = pick(investments)
			var/datum/investment/investment = new random_investment
			if(investment.random_values)
				investment.price = floor(investment.price * (rand(80, 130) / 100))
				if(investment.onetime_payment > 0)
					investment.onetime_payment = max(floor(investment.onetime_payment * (rand(90, 130) / 100)),investment.price+5)
				investment.pay_eta = floor(investment.pay_eta * (rand(50, 150) / 100))
				investment.regular_payment = floor(investment.regular_payment * (rand(80, 130) / 100))
				investment.fail_chance = floor(investment.fail_chance * (rand(80, 120) / 100))
			available_investments += investment
	else 
		return FALSE
	return TRUE

/datum/controller/subsystem/investments/proc/purchase_investment(datum/investment/investment)
	if(!SStreasury.withdraw_money_treasury(investment.price))
		return FALSE
	awaiting_investments += investment
	investment.time_purchased = world.time
	available_investments -= investment

	return TRUE
	

/datum/controller/subsystem/investments/proc/process_investments()
	var/money_earned = 0
	for(var/datum/investment/investment in awaiting_investments)
		if(world.time >= investment.time_purchased + investment.pay_eta)
			if(investment.fail_chance > rand(1,100))
				SStreasury.log_to_steward("Инвестиция '[investment.investment_name]' провалилась. Деньги потеряны.")
				SStreasury.steward_machine.say("Инвестиция '[investment.investment_name]' провалилась! Деньги потеряны.")
				awaiting_investments -= investment
				qdel(investment)
			else
				if(investment.regular_payment)
					active_investments += investment
					awaiting_investments -= investment
					SStreasury.steward_machine.say("Инвестиция '[investment.investment_name]' успешна, доход должен расти.")
				else
					SStreasury.steward_machine.say("Мы получили одноразовую выплату за инвестицию '[investment.investment_name]'.")
					money_earned += investment.onetime_payment
					awaiting_investments -= investment
					qdel(investment)

	for(var/datum/investment/investment in active_investments)
		money_earned += investment.regular_payment

	if(money_earned != 0)
		SStreasury.give_money_treasury(money_earned, "Инвестиции")
		SStreasury.steward_machine.say("Получено [money_earned]m за инвестиции.")
		


/////DATUMS////
/datum/investment
	var/investment_name = "Инвестиция"
	var/pay_eta = 15 MINUTES
	var/time_purchased
	var/price = 0
	var/onetime_payment = 0
	var/regular_payment = 0
	var/fail_chance = 0
	var/random_values = TRUE

/datum/investment/land
	investment_name = "Инвестиция в землю"
	price = 1000
	pay_eta = 5 MINUTES
	regular_payment = 35
	fail_chance = 7

/datum/investment/real_estate
	investment_name = "Инвестиция в недвижимость"
	price = 2500
	pay_eta = 12.5 MINUTES
	regular_payment = 64
	fail_chance = 5

/datum/investment/trade_routes
	investment_name = "Инвестиция в торговые пути"
	price = 8000
	pay_eta = 20 MINUTES
	regular_payment = 400
	fail_chance = 5

/datum/investment/royal_bond_low
	investment_name = "Выпустить дешевую облигацию"
	price = -250
	pay_eta = 30 MINUTES
	onetime_payment = -260
	fail_chance = 0
	random_values = FALSE

/datum/investment/royal_bond_mid
	investment_name = "Выпустить среднюю облигацию"
	price = -1000
	pay_eta = 30 MINUTES
	onetime_payment = -1250
	fail_chance = 0
	random_values = FALSE

/datum/investment/royal_bond_large
	investment_name = "Выпустить дорогую облигацию"
	price = -2000
	pay_eta = 30 MINUTES
	onetime_payment = -2500
	fail_chance = 0
	random_values = FALSE

/datum/investment/repair_bridge
	investment_name = "Профинансировать ремонт торговых путей"
	price = 100
	pay_eta = 7.5 MINUTES
	regular_payment = 15
	fail_chance = 3

/datum/investment/trade_loan
	investment_name = "Заем торговой гильдии"
	price = 200
	pay_eta = 5 MINUTES
	onetime_payment = 300
	fail_chance = 0

/datum/investment/trade_loan_merc
	investment_name = "Заем гильдии наемников"
	price = 100
	pay_eta = 5 MINUTES
	onetime_payment = 120
	fail_chance = 1

/datum/investment/trade_loan_unknown
	investment_name = "Срочный заем ненадежному лицу"
	price = 300
	pay_eta = 5 MINUTES
	onetime_payment = 900
	fail_chance = 50

/datum/investment/gold
	investment_name = "Инвестиция в золото"
	price = 45
	pay_eta = 2 MINUTES
	onetime_payment = 60
	fail_chance = 2

/datum/investment/silver
	investment_name = "Инвестиция в серебро"
	price = 60
	pay_eta = 2 MINUTES
	onetime_payment = 90
	fail_chance = 2

/datum/investment/gems
	investment_name = "Инвестиция в драгоценные камни"
	price = 60
	pay_eta = 2 MINUTES
	onetime_payment = 70
	fail_chance = 0

/datum/investment/gold_x5
	investment_name = "Инвестиция в золото x5"
	price = 225
	pay_eta = 3 MINUTES
	onetime_payment = 300
	fail_chance = 2

/datum/investment/silver_x5
	investment_name = "Инвестиция в серебро x5"
	price = 300
	pay_eta = 3 MINUTES
	onetime_payment = 450
	fail_chance = 2

/datum/investment/gems_x5
	investment_name = "Инвестиция в драгоценные камни x5"
	price = 225
	pay_eta = 3 MINUTES
	onetime_payment = 350
	fail_chance = 0

/datum/investment/feodal_lands
	investment_name = "Инвестиция в местные феодальные земли"
	price = 800
	pay_eta = 7.5 MINUTES
	regular_payment = 18
	fail_chance = 3

/datum/investment/overseas_feodal_lands
	investment_name = "Инвестиция в заморские феодальные земли"
	price = 850
	pay_eta = 7.5 MINUTES
	regular_payment = 22
	fail_chance = 20
