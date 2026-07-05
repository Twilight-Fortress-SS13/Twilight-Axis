/datum/foreign_realm/lingyue
	id = REALM_LINGYUE
	name = "Gyedzai" //TA EDIT
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Tianxia", "Fenghuang", "Qilin", "Longwang", "Yuanzhao",
		"Jinqi", "Lingfeng", "Yunhai", "Shanhe", "Chunqiu",
		"Mingyue", "Jianghai", "Tianlong", "Beidou", "Wanli",
	)
	captain_first_names = list(
		"Yunxu", "Tianqi", "Jingming", "Yuanzheng", "Tianyou",
		"Hean", "Yunshu", "Tianlin", "Mingzhao", "Jingwei",
		"Yunzhi", "Mingxia", "Lianhua", "Xiulan", "Chunhua",
	)
	captain_last_names = list(
		"Zou", "Su", "Lei", "Yun", "Shan",
		"Meng", "Jiang", "Mu", "Han", "Tang",
	)
	ship_types = list(
		list("name" = "Junk", "tonnage" = 80, "weight" = 20),
		list("name" = "War Junk", "tonnage" = 200, "weight" = 30),
		list("name" = "Treasure Ship", "tonnage" = 800, "weight" = 30),
	)
	city_tags = list()
	city_tag_chance = 0
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_PLUM, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_ENCHSCROLL_BASIC, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TIN_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CABBAGE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ROCKNUT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ricepork, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceporkcuc, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ricebeef, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceeggcheese, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/plum_wine),
		list("recipe" = /datum/brewing_recipe/liquor/ricespirit),
		list("recipe" = /datum/brewing_recipe/whipwine),
		list("recipe" = /datum/brewing_recipe/tangerine_wine),
		list("recipe" = /datum/brewing_recipe/rum),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/jade,
		/datum/supply_pack/rogue/food/pepper,
		/datum/supply_pack/rogue/food/sugar,
		/datum/supply_pack/rogue/lingyue/wodao,
		/datum/supply_pack/rogue/lingyue/iwodao,
		/datum/supply_pack/rogue/lingyue/dadao,
		/datum/supply_pack/rogue/lingyue/idadao,
		/datum/supply_pack/rogue/lingyue/rumahwando,
		/datum/supply_pack/rogue/lingyue/samjeongdo,
		/datum/supply_pack/rogue/merc_weapons/hwando,
		/datum/supply_pack/rogue/merc_weapons/ssangsudo,
		/datum/supply_pack/rogue/kazengun/ssangsudo,
		/datum/supply_pack/rogue/kazengun/mentorhat,
		/datum/supply_pack/rogue/lingyue/ji,
		/datum/supply_pack/rogue/lingyue/iji,
		/datum/supply_pack/rogue/lingyue/zhanmadao,
		/datum/supply_pack/rogue/merc_weapons/glaive,
		/datum/supply_pack/rogue/lingyue/cloudcloak,
		/datum/supply_pack/rogue/lingyue/leathercloak,
		/datum/supply_pack/rogue/lingyue/shirt_black,
		/datum/supply_pack/rogue/lingyue/shirt_white,
		/datum/supply_pack/rogue/lingyue/pants_cutthroat,
		/datum/supply_pack/rogue/lingyue/pants_ripped,
		/datum/supply_pack/rogue/lingyue/gloves_black,
		/datum/supply_pack/rogue/lingyue/gloves_stylish,
		/datum/supply_pack/rogue/luxury/fancyteaset,
		/datum/supply_pack/rogue/alcohol/zhonghuangjiu,
		/datum/supply_pack/rogue/alcohol/baijiu,
		/datum/supply_pack/rogue/alcohol/yaojiu,
		/datum/supply_pack/rogue/alcohol/shejiu,
		/datum/supply_pack/rogue/drugs/whipwine,
		/datum/supply_pack/rogue/alcohol/truewhipwine,
	)
	hail_lines = list(
		"Write it in your ledgers: I sail under no warlord's banner. My keel is old Gyedzai, my chop is my clan's, and Saon himself can balance the account if any man doubts it.",
		"You see ten kingdoms squabbling over a corpse; I see ten markets fighting to outpay each other. Speak to me of embargoes when our princes agree on a single calendar.",
		"These bales crossed three straits and two pirate flags. Once the corsairs read my clan mark, they charged a toll instead of a ransom. That is the difference between a name and a rumor.",
		"Our astrologer traced this voyage on the night‑sky tables long before your harbor lights appeared. The stars over Gyedzai do not lie – they merely charge a fee in incense and good ink.",
		"Do not mistake a divided throne for a weak hull. The princes may gnaw each other's borders, but their coins jingle the same when they land in my counting bowl.",
		"I keep three sets of scrolls – one for the tax‑clerks of the coast, one for the sea‑lords, and one for myself. The first two are for show. The third is the only one Saon will read.",
		"Your harbor banners change with every new rebellion. My flag has not changed since Yuanzhao's day. When the Schism passes into legend, my house mark will still be painted on hulls.",
		"In Gyedzai we say: 'A wise man trusts the scales, a fool trusts the oath, and a dead man trusts the prince.' I have brought you scales. Oaths and princes you must provide yourself.",
		"I have freighted offerings for three different courts that all claim to be the Heart of Gyedzai. Let them argue over whose shrine gets more lacquer. My concern is whose treasurer pays on time.",
		"These ceramics are from a kiln that changed hands five times in one war. The potters kept working, the generals kept dying, and the clay never once asked whose side it was on.",
		"Your customs man quotes edicts as if they were tides. Tides I can trust. Edicts wash away with the next failed campaign and the next son who calls himself 'restorer of unity'.",
		"You ask if my crew are loyal. They have survived blockades in the Inner Sea and famine levies on the mainland. If hunger did not buy them, your coins certainly will not.",
		"The saost scholars say the world turns on balance: duty against profit, honor against survival. I say a good captain learns which side of the scale he can afford to let touch the water.",
		"Your duke fancies himself a patron of eastern culture? Then let him patronize my ledger. Gyedzai silk on his shoulders will speak more eloquently than any envoy he can afford.",
		"I carry letters sealed by three rival courts, each warning me not to trade with the other two. I keep them together in one box – they make a fine cushion for hard coin.",
		"Do not haggle with a man whose homeland is at war with itself. I have learned every trick of survival from our own princes; your market squabbles are children's play in comparison."
	) //TA EDIT
