/datum/foreign_realm/zybantu
	id = REALM_ZYBANTU
	name = "Zybantu"
	roll_weight = TRADE_REALM_WEIGHT_DEFAULT
	demanded_categories = list(NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_BEVERAGE)
	ship_name_words = list(
		"Ziggurat", "Qamar", "Nasr", "Sultan", "Amir",
		"Miraj", "Zafir", "Bahr", "Sahra", "Ranesh",
		"Kamar", "Dvergeil", "Zafirabad", "Nok",
	)
	captain_first_names = list(
		"Ismail", "Amin", "Jafar", "Rashid", "Zafir",
		"Selim", "Omar", "Hassan", "Layla", "Aisha",
		"Mariam", "Zahra", "Nadia", "Fatima",
	)
	captain_last_names = list(
		"al-Zafir", "al-Naledi", "al-Ranesh", "ibn-Miraj", "al-Dvergeil",
		"al-Kamar", "ibn-Sahra", "al-Sultan", "Ben-Amin", "al-Mansapadashi",
	)
	ship_types = list(
		list("name" = "Dhow", "tonnage" = 40, "weight" = 15),
		list("name" = "Xebec", "tonnage" = 140, "weight" = 40),
		list("name" = "Carrack", "tonnage" = 320, "weight" = 25),
		list("name" = "Imperial Galleon", "tonnage" = 700, "weight" = 10),
	)
	city_tags = list(
		"Dvergeil", "Kamar", "Halediya", "Raneshpolis",
		"Servos", "Azir", "Mirazhfen",
	)
	city_tag_chance = 45
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bread, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/aqua_vitae, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX),
		list("recipe" = /datum/brewing_recipe/jack_wine, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/zybantu/stargazer_vestments,
		/datum/supply_pack/rogue/zybantu/imperial_gold_finery,
		/datum/supply_pack/rogue/zybantu/glass_decanters,
		/datum/supply_pack/rogue/zybantu/desert_rider_gear,
		/datum/supply_pack/rogue/zybantu/merchant_survey,
		/datum/supply_pack/rogue/naledi/hierophant_kit,
		/datum/supply_pack/rogue/naledi/lordmask,
		/datum/supply_pack/rogue/raneshen/janissary_kit,
		/datum/supply_pack/rogue/raneshen/shamshir,
		/datum/supply_pack/rogue/raneshen/shalal_scarf,
	)
	hail_lines = list(
		"By the Ziggurat's shadow, I bring silk, glass and gold. Come bargain with sense and coin.",
		"Spices from the South, silks from the looms of Kamar. Buy fine, or go hungry.",
		"No priests, no judges; only fair trade and sealed ledgers. Dvergeil pays on sight for true goods.",
		"My captain's word, sworn to Mansa-Padashi under Noc's gaze: masks, parchment and stargazer vestments for the right price.",
		"We take coin, charms, and rare gems. We do not take thieves or excuses.",
		"Raneshen steel and Naledi gold welcome aboard. Strong arms fetch strong coin.",
		"I bring silks, incense and the finest glass. Pay in gold, or in goods - everything has a price.",
		"Salted meat and preserved bread for crew, silver for merchants. Keep your wits and your purse closed.",
		"I will not tarry while the tide turns; I have cargo to sell and debts to collect at Dvergeil.",
		"Basileus's envoys travel with my manifest. Show papers or be turned away at the gangplank."
	)

/datum/foreign_realm/valoria
	id = REALM_VALORIA
	name = "Valoria"
	roll_weight = TRADE_REALM_WEIGHT_DEFAULT
	demanded_categories = list(NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_BEVERAGE, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_POTIONS_REAGENTS)
	ship_name_words = list(
		"Eterna", "Anizotti", "Astinia", "Valonara", "Marconza",
		"Veriben", "Monezza", "Saluzzo", "Dandolo", "Anafesto",
		"Candiano",
	)
	captain_first_names = list(
		"Mark", "Enrico", "Bartolomeo", "Lorenzo", "Francesco",
		"Giovanni", "Alessio", "Marco", "Antonio", "Lucia",
		"Giulia", "Isabella",
	)
	captain_last_names = list(
		"Anafesto", "Candiano", "Dandolo", "Milanid", "Pivomarucelli",
		"Marcon", "Livenca", "Valoni", "DeLucia", "Piarezzi",
	)
	ship_types = list(
		list("name" = "Caravel", "tonnage" = 60, "weight" = 25),
		list("name" = "Carrack", "tonnage" = 240, "weight" = 12),
		list("name" = "Galleon", "tonnage" = 650, "weight" = 6),
		list("name" = "Merchantman", "tonnage" = 380, "weight" = 18),
	)
	city_tags = list(
		"Eterna", "Anizotti", "Astinia", "Valonara",
		"Marconza", "Veribenplaza", "Monezza", "Saluzzo",
	)
	city_tag_chance = 40
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_LONGSWORD, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_STEEL_BROADSWORD, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_STEEL_FULLPLATE, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bread, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/jack_wine, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX),
		list("recipe" = /datum/brewing_recipe/aqua_vitae, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/valoria/valorian_swords,
		/datum/supply_pack/rogue/valoria/valorian_greatsword,
		/datum/supply_pack/rogue/valoria/valorian_cuirass,
		/datum/supply_pack/rogue/valoria/valorian_halfplate,
		/datum/supply_pack/rogue/valoria/valorian_plate,
		/datum/supply_pack/rogue/grenzelhoft/blacksteel_cuirass,
		/datum/supply_pack/rogue/zybantu/imperial_gold_finery,
		/datum/supply_pack/rogue/kazengun/ssangsudo,
	)
	hail_lines = list(
		"Eterna's merchants bring fine steel, fine wine, and a bill that will make you smile.",
		"By the Golden Crona—bring silks and gems. We pay fairly, and we pay fast.",
		"Valorian blades for the strong, grain for the hungry, and ledgers sealed by the Trade Guild.",
		"We don't barter with thieves or beggars. Bring coin, bring quality, or beware the docks.",
		"The Five Republics' ships sail true. Ask for papers, take your coin, and be gone before sunset.",
		"My hold carries plate and broadswords — ask the steward before you insult the mast.",
		"We favour merchants with taste: fine cloth, fine drink, and the right pedigree of coin.",
		"Eterna's agents travel with my manifest. Show papers or be turned away at the gangplank.",
	)

