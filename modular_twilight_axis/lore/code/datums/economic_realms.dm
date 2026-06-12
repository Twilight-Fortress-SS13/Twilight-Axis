/datum/foreign_realm/zybantu
	id = REALM_ZYBANTU
	name = "Zybantu"
	roll_weight = TRADE_REALM_WEIGHT_DEFAULT
	demanded_categories = list(NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_POTIONS_REAGENTS)
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
		"You see shackles and think only of iron. I see labour contracts, temple fines, and war reparations. Call it what you like; the Basileus calls it revenue and I am not paid to disagree."
	)

/datum/foreign_realm/valoria
	id = REALM_VALORIA
	name = "Valoria"
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_POTIONS_REAGENTS)
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
		"Greetings from the Valorian Trade League, factor. My papers bear the seals of three councils and two very bored notaries. If that does not satisfy your harbour, nothing short of annexation will.",
		"I am a licensed factor of the League — audited, insured, and annoyingly well‑educated. Do not try to bury a clause in the small script; I hire scribes whose only vice is finding those."
	)

/datum/foreign_realm/hammerhold_ta
	id = REALM_HAMMERHOLD_TA
	name = "Hammerhold"
	roll_weight = TRADE_REALM_WEIGHT_DEFAULT
	demanded_categories = list(NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_ENGINEERING, NAVIGATOR_BUCKET_VALUABLES_CRAFTED)
	ship_name_words = list(
		"Rusalka", "Borei", "Cherno", "Morozko", "Imperatritsa",
		"Voevoda", "Snegurochka", "Zimorodok", "Koldun", "Viy",
	)
	captain_first_names = list(
		"Miroslav", "Yaromir", "Anaviel", "Elysara", "Svyat",
		"Lirya", "Vesimir", "Radoslav", "Zorya", "Evarin",
	)
	captain_last_names = list(
		"Zvenkor", "Mirovich", "Serebrin", "Zolov", "Veshtan",
		"Ryabek", "Lukavin", "Drevich", "Yarovin", "Koril",
	)
	ship_types = list(
		list("name" = "Lodya", "tonnage" = 50, "weight" = 30),
		list("name" = "Shlyup", "tonnage" = 120, "weight" = 20),
		list("name" = "Strug", "tonnage" = 400, "weight" = 10),
		list("name" = "Clipper", "tonnage" = 200, "weight" = 15),
	)
	city_tags = list(
		"Nizhe-Porosslavl", "Velikaya Ushitsa", "Yampol", "Krasen",
		"Pinsk", "Staretsk",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_COPPER_ORE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COPPER_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_STONE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_ORE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_STAPLE_EAGER, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SALUMOI, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/bear/fried, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/beer, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX),
		list("recipe" = /datum/brewing_recipe/beer/oat, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX),
		list("recipe" = /datum/brewing_recipe/mead, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX),
		list("recipe" = /datum/brewing_recipe/golden_calendula_tea, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX),
		list("recipe" = /datum/brewing_recipe/voddena, "qty_min" = VICTUALLING_QTY_TINY_MIN, "qty_max" = VICTUALLING_QTY_TINY_MAX),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/hammerhold_ta/elven,
		/datum/supply_pack/rogue/hammerhold_ta/elven_coats,
		/datum/supply_pack/rogue/hammerhold_ta/elven_furcoats,
		/datum/supply_pack/rogue/hammerhold_ta/elven_cloaks,
		/datum/supply_pack/rogue/hammerhold_ta/elven_cloaks_short,
		/datum/supply_pack/rogue/hammerhold_ta/elven_burkas,
		/datum/supply_pack/rogue/hammerhold_ta/twilight_elven_cuirass,
		/datum/supply_pack/rogue/hammerhold_ta/twilight_elven_bracers,
		/datum/supply_pack/rogue/hammerhold_ta/twilight_elven_boots,
		/datum/supply_pack/rogue/hammerhold_ta/twilight_elven_gloves,
	)
	hail_lines = list(
		"Bless the Anvil and the Crown, factor. My hold comes from Hammerhold's cold valleys and hotter forges. You will find no softer iron and no harder bargains this side of the northern ice.",
		"My charter is stamped in royal wax, not some guild's candle‑drip. If you doubt the seal, you may ride north and ask the Tsaritsa yourself – if the dead on the road do not ask you first.",
		"These ingots were smelted where goblins raid and winter never quite leaves. Pay for the steel, and I will throw in a little of Hammerhold's stubbornness for free.",
		"I have marched with levy wagons and sailed through undead fleets to bring this cargo south. If your duke wants a discount, let him bleed for the difference as my men did.",
		"Grain, salt fish, and thick furs in honest measure; silver nails, runed plate, and powder in smaller weight. Count them twice if you wish – Hammerhold weighs things once and remembers.",
		"By the White Flame and Tsaritsa's own banner, my scales are straight. To call them false is to call Hammerhold crooked, and that is a word best not spoken within arrowshot of our walls.",
		"I am a quartermaster by exam and a captain by campaign. I have balanced ledgers in snowed‑in keeps and on burning ramparts. Do not bring me market‑stall tricks; they will freeze and die on my deck.",
		"My crew hail from watch‑towers where children learn to string bows before they read their letters. They fear blizzards, dead things, and empty ale barrels – they do not fear customs clerks.",
		"You think Hammerhold is only fortresses and funeral drums? Then you have never seen our winter fairs, where one cloak can buy a horse and one cask can buy a prince's favor.",
		"Your harbor masters grumble about tariffs as if gold were scarce. In Hammerhold, we count in lives and winters. Coin is the easiest thing on this ship to replace.",
		"See this mark on the crates? That is the sigil of a fortress that has buried three necromancers and outlived two invasions. If it can keep out the dead, it can keep your goods safe enough.",
		"I sail under truce‑colors agreed by priests and generals both. Break that understanding, and the next northern ship you see will not come with trade chests but with siege ladders.",
		"Our scribes say Hammerhold has 7.9 million souls and not one truly at peace. We burn fear out of our children with drill and prayer. Haggling with you is the most restful part of my year.",
		"Your southerners dress war in bright lacquer and polished speeches. In Hammerhold, we dress it in boiled leather and good boots. These boots have marched farther than most ambassadors.",
		"I carry casks from a brewery that stands between two barrow‑fields. The dead listen to the songs inside but never rise to complain. Drink that, and your tavern will feel embarrassingly safe.",
		"Remember this: when your walls crack and your pretty banners burn, it is Hammerhold's iron and powder you will wish you had paid full price for. Better to learn that lesson now, while we are still smiling."
	)

