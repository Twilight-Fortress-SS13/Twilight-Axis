/// Divine pantheon storytellers
#define DIVINE_STORYTELLERS list( \
	/datum/storyteller/astrata, \
	/datum/storyteller/noc, \
	/datum/storyteller/ravox, \
	/datum/storyteller/abyssor, \
	/datum/storyteller/xylix, \
	/datum/storyteller/necra, \
	/datum/storyteller/pestra, \
	/datum/storyteller/malum, \
	/datum/storyteller/eora, \
	/datum/storyteller/dendor, \
	/datum/storyteller/psydon, \
)

//Yeah-yeah, he's not the same pantheon but suck it up, buttercup. We not makin' more defines.

/// Inhumen pantheon storytellers
#define INHUMEN_STORYTELLERS list( \
	/datum/storyteller/zizo, \
	/datum/storyteller/baotha, \
	/datum/storyteller/graggar, \
	/datum/storyteller/matthios, \
)

/// All storytellers
#define STORYTELLERS_ALL (DIVINE_STORYTELLERS + INHUMEN_STORYTELLERS)

/datum/storyteller
	var/ru_name = null

/datum/storyteller/proc/get_display_name()
	return ru_name || name

/datum/storyteller/psydon
	name = "Psydon"
	ru_name = "Псайдон"
	vote_desc = "Воцаряется покой. Антагонистов не будет. Его дети могут спать спокойно - они заслужили передышку."
	desc = "Обыденные и умеренные события случаются в 1.2 раза чаще. Без антагонистов и божественного вмешательства. Гноллы отключены."
	welcome_text = "Мягкий ветер проходит по тихим улицам.."
	weight = 6
	always_votable = TRUE
	color_theme = "#80ced8"
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	wretch_slot_cap = 0
	guarantees_roundstart_roleset = FALSE
	roundstart_prob = 0

	//Has no influence, your actions will not impact him his spawn rates. Cus he's asleep.
	//Tl;dr - higher event spawn rates to keep stuff interesting, no god intervention, no antags. (Raids and omens will still happen at normal rate.)
	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.2,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 0,			//No god intervention, cus he's asleep.
		EVENT_TRACK_CHARACTER_INJECTION = 0,	//No antagonist spawns.
	)

/datum/storyteller/astrata
	name = "Astrata"
	ru_name = "Астрата"
	vote_desc = "Воцаряется порядок. Великим угрозам не суждено подняться, а гноллы не смеют ступать под Её дневной свет. Её милость обращена к знати и Её указам."
	desc = "Бандиты, личи, оборотни и вампирские лорды не выпадают. Маскарад - единственный основной антагонист на старте раунда и получает вес x1.5. Гноллы отключены. Вретчи масштабируются обычным образом."
	welcome_text = "Тёплый дневной свет пробуждает вас ото сна.."
	weight = 6
	always_votable = TRUE
	follower_modifier = LOWER_FOLLOWER_MODIFIER
	color_theme = "#FFD700"
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	guarantees_roundstart_roleset = FALSE
	roundstart_prob = 0

	starting_point_multipliers = list(
		EVENT_TRACK_CHARACTER_INJECTION = 0,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_CHARACTER_INJECTION = 0,	//No antagonist spawns under Her order.
	)

	influence_sets = list(
	"Set 1" = list(
		STATS_LAWS_AND_DECREES_MADE = list("name" = "Laws and decrees:", "points" = 2.75, "capacity" = 45),
	),
	"Set 2" = list(
		STATS_ALIVE_NOBLES = list("name" = "Number of nobles:", "points" = 2.5, "capacity" = 60),
	),
	"Set 3" = list(
		STATS_NOBLE_DEATHS = list("name" = "Noble deaths:", "points" = -3.75, "capacity" = -60),
		STATS_PEOPLE_SMITTEN = list("name" = "People smitten:", "points" = 4, "capacity" = 40),
	),
	"Set 4" = list(
		STATS_ASTRATA_REVIVALS = list("name" = "Holy revivals:", "points" = 6, "capacity" = 75),
		STATS_PRAYERS_MADE = list("name" = "Prayers made:", "points" = 2.25, "capacity" = 65),
	),
	"Set 5" = list(
		STATS_TAXES_COLLECTED = list("name" = "Taxes collected:", "points" = 0.2, "capacity" = 80),
	))

/datum/storyteller/noc
	name = "Noc"
	ru_name = "Нок"
	vote_desc = "Воцаряется знание. Событий меньше чем обычно, но арканное вмешательство всё ещё возможно. Её милость обращена к тем, кто мечтает о большем."
	desc = "Магические события получают вес x1.2, события с призраками - x1.1. Разброс стоимости событий выше. Пул антагонистов без изменений. Возможен один гнолл."
	welcome_text = "Воздух потрескивает от арканной энергии.."
	weight = 4
	always_votable = TRUE
	color_theme = "#F0F0F0"
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE

	tag_multipliers = list(
		TAG_MAGICAL = 1.2,
		TAG_HAUNTED = 1.1,
	)
	cost_variance = 25

	influence_sets = list(
		"Set 1" = list(
			STATS_BOOKS_PRINTED = list("name" = "Books printed:", "points" = 2, "capacity" = 40),
		),
		"Set 2" = list(
			STATS_LITERACY_TAUGHT = list("name" = "Literacy taught:", "points" = 20, "capacity" = 140),
		),
		"Set 3" = list(
			STATS_BOOKS_BURNED = list("name" = "Books burned:", "points" = -2, "capacity" = -50),
		),
		"Set 4" = list(
			STATS_SKILLS_DREAMED = list("name" = "Skills dreamed:", "points" = 0.325, "capacity" = 100),
		),
		"Set 5" = list(
			STATS_VOYEURS = list("name" = "Voyeurs:", "points" = 5, "capacity" = 50),
		),
	)

/datum/storyteller/ravox
	name = "Ravox"
	ru_name = "Равокс"
	vote_desc = "Воцаряется слава. Набеги и знамения приходят чаще. Его милость слышна в звоне стали и военных кличах - бандиты отвечают на Его зов, но гноллы держатся в стороне."
	desc = "Трек набегов набирает очки в 2 раза быстрее, а события-набеги получают вес x1.3. Бандиты гарантированно становятся основными антагонистами на старте раунда. Обыденные и личные события подавлены. Гноллы отключены."
	welcome_text = "\"Вдалеке эхом гремят трубы Зерихо..\""
	weight = 4
	always_votable = TRUE
	color_theme = "#228822"
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	guarantees_roundstart_roleset = TRUE
	roundstart_prob = 100

	tag_multipliers = list(
		TAG_RAID = 1.3,
	)

	starting_point_multipliers = list(
		EVENT_TRACK_CHARACTER_INJECTION = 1,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.75,
		EVENT_TRACK_PERSONAL = 0.9,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,	//No midround antagonist spawns - raids and omens carry the conflict.
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 2,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_COMBAT_SKILLS = list("name" = "Combat skills learned:", "points" = 1.065, "capacity" = 90),
		),
		"Set 2" = list(
			STATS_PARRIES = list("name" = "Parries made:", "points" = 0.052, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_WARCRIES = list("name" = "Warcries made:", "points" = 0.35, "capacity" = 50),
		),
		"Set 4" = list(
			STATS_YIELDS = list("name" = "Yields made:", "points" = -4.25, "capacity" = -40),
		),
		"Set 5" = list(
			STATS_THRILLSEEKERS = list("name" = "Thrillseekers:", "points" = 5, "capacity" = 50)
		)
	)

/datum/storyteller/abyssor
	name = "Abyssor"
	ru_name = "Абиссор"
	vote_desc = "Воцаряется вода. События спокойны, но их течение меняется вместе с приливом. Его милость обращена к рыбакам, пиявкам и утопленникам - сновидцы идут глубинными путями, а гноллы не смеют выходить к Его берегам."
	desc = "Водные события получают вес x1.3, торговые - x1.2. Дримволкер получает вес x1.5 в пуле антагонистов. Гноллы отключены."
	welcome_text = "Горизонт темнеет: тучи собираются к близкой буре.."
	weight = 4
	always_votable = TRUE
	color_theme = "#3366CC"
	preferred_gnoll_mode = GNOLL_SCALING_NONE

	tag_multipliers = list(
		TAG_WATER = 1.3,
		TAG_TRADE = 1.2,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_FISH_CAUGHT = list("name" = "Fish caught:", "points" = 1.75, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_WATER_CONSUMED = list("name" = "Water consumed:", "points" = 0.014, "capacity" = 90),
		),
		"Set 3" = list(
			STATS_ABYSSOR_REMEMBERED = list("name" = "Abyssor remembered:", "points" = 1.1, "capacity" = 50),
			STATS_ALIVE_AXIAN = list("name" = "Number of axians:", "points" = 8, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_LEECHES_EMBEDDED = list("name" = "Leeches embedded:", "points" = 0.75, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_PEOPLE_DROWNED = list("name" = "People drowned:", "points" = 12, "capacity" = 75),
			STATS_BATHS_TAKEN = list("name" = "Baths taken:", "points" = 4.5, "capacity" = 60),
		)
	)

/datum/storyteller/xylix
	name = "Xylix"
	ru_name = "Ксайликс"
	vote_desc = "Воцаряется непредсказуемость. Ничто не высечено в камне, зато возможно всё. Его милость обращена к случайности, прихоти и шутке."
	desc = "Принудительные события игнорируют требования к населению, а уже сработавшие события сразу получают полный штраф за повтор. Божественное вмешательство x1.75; внедрение персонажей, знамения и набеги подавлены до 0. Все основные антагонисты, доступные на старте раунда, получают вес x1.5. Режим гноллов выбирается случайно."
	welcome_text = "\"..вот что бывает от лишних пряностей и вина!\""
	weight = 4
	always_votable = TRUE
	event_repetition_multiplier = 0
	forced = TRUE
	color_theme = "#AA8888"
	preferred_gnoll_mode = GNOLL_SCALING_RANDOM

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1.75,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 0,
		EVENT_TRACK_RAIDS = 0,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_LAUGHS_MADE = list("name" = "Laughs had:", "points" = 0.225, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_PEOPLE_MOCKED = list("name" = "People mocked:", "points" = 5, "capacity" = 60),
		),
		"Set 3" = list(
			STATS_CRITS_MADE = list("name" = "Crits made:", "points" = 0.26, "capacity" = 90),
		),
		"Set 4" = list(
			STATS_SONGS_PLAYED = list("name" = "Songs played:", "points" = 0.675, "capacity" = 70),
			STATS_MOAT_FALLERS = list("name" = "Moat fallers:", "points" = 4, "capacity" = 50),
		)
	)

/datum/storyteller/necra
	name = "Necra"
	ru_name = "Некра"
	vote_desc = "Воцаряется смерть. События случаются реже, а антагонисты выпадают неохотнее. Её милость обращена к тем, кто возвращает неупокоенных обратно в могилы."
	desc = "События с призраками получают вес x1.3. Очки появления антагонистов и набегов набирают очки вдвое медленнее; личные события тоже замедлены. Обыденные и умеренные события случаются в 1.25 раза чаще. Возможен один гнолл."
	welcome_text = "\"В феоде Зенмарка повеяло запахом тления..\""
	weight = 4
	always_votable = TRUE
	color_theme = "#888888"
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE

	tag_multipliers = list(
		TAG_HAUNTED = 1.3,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.25,
		EVENT_TRACK_PERSONAL = 0.7,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 1.25,
		EVENT_TRACK_CHARACTER_INJECTION = 0.5,
		EVENT_TRACK_OMENS = 1.25,
		EVENT_TRACK_RAIDS = 0.5,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_DEATHS = list("name" = "Total deaths:", "points" = 1.35, "capacity" = 100),
		),
		"Set 2" = list(
			STATS_GRAVES_CONSECRATED = list("name" = "Graves consecrated:", "points" = 6.25, "capacity" = 80),
		),
		"Set 3" = list(
			STATS_GRAVES_ROBBED = list("name" = "Graves robbed:", "points" = -3.75, "capacity" = -40),
		),
		"Set 4" = list(
			STATS_DEADITES_KILLED = list("name" = "Deadites killed:", "points" = 6.25, "capacity" = 90),
		),
		"Set 5" = list(
			STATS_VAMPIRES_KILLED = list("name" = "Vampires killed:", "points" = 12.5, "capacity" = 70),
		),
		"Set 6" = list(		
			STATS_SKELETONS_KILLED = list("name" = "Skeletons killed:", "points" = 5, "capacity" = 50),
		)
	)

/datum/storyteller/pestra
	name = "Pestra"
	ru_name = "Пестра"
	vote_desc = "Воцаряется исцеление. События спокойны, но умелые руки могут склонить их ход. Её милость обращена к лекарям и алхимикам."
	desc = "Алхимические и медицинские события получают вес x1.2, природные - x1.1. Все основные антагонисты выпадают с одинаковым базовым весом - без предпочтения между бандитами, личами, вервольфами и вампирскими лордами. Возможен один гнолл."
	welcome_text = "Слышится звон инструментов и бульканье алхимических чудес.."
	color_theme = "#AADDAA"
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE

	tag_multipliers = list(
		TAG_ALCHEMY = 1.2,
		TAG_MEDICAL = 1.2,
		TAG_NATURE = 1.1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_POTIONS_BREWED = list("name" = "Potions brewed:", "points" = 5.25, "capacity" = 80),
		),
		"Set 2" = list(
			STATS_WOUNDS_SEWED = list("name" = "Wounds sewed up:", "points" = 0.48, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_LUX_HARVESTED = list("name" = "Lux extracted:", "points" = 8, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_LUX_REVIVALS = list("name" = "Lux revivals:", "points" = 16, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_ROT_CURED = list("name" = "Rot cured:", "points" = 5, "capacity" = 70),
		),
		"Set 6" = list(
			STATS_FOOD_ROTTED = list("name" = "Food rotted:", "points" = 0.26, "capacity" = 80),
		)
	)

/datum/storyteller/malum
	name = "Malum"
	ru_name = "Малум"
	vote_desc = "Воцаряется труд. Божественное вмешательство случается чаще. Его милость обращена к мастерам, творящим шедевры, и шахтёрам."
	desc = "События труда получают вес x1.5. Божественное вмешательство случается в 2 раза чаще, личные события - в 1.2 раза чаще. Все основные антагонисты выпадают с одинаковым базовым весом. Возможен один гнолл."
	welcome_text = "Звон молотов разносится по округе, а жар горнов наполняют улицы.."
	color_theme = "#D4A56C"
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE

	tag_multipliers = list(
		TAG_WORK = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_MASTERWORKS_FORGED = list("name" = "Masterworks forged:", "points" = 7, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_ROCKS_MINED = list("name" = "Rocks mined:", "points" = 0.26, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_CRAFT_SKILLS = list("name" = "Craft skills learned:", "points" = 0.4, "capacity" = 80),
		),
		"Set 4" = list(
			STATS_CRAFTED_ITEMS = list("name" = "Crafted items:", "points" = 0.1, "capacity" = 100), //So he doesn't reign every round
		),
		"Set 5" = list(
			STATS_BEARDS_SHAVED = list("name" = "Beards shaved:", "points" = -4, "capacity" = -40),
			STATS_ALIVE_DWARVES = list("name" = "Number of dwarfs:", "points" = 4, "capacity" = 45),
		),
	)

/datum/storyteller/eora
	name = "Eora"
	ru_name = "Эора"
	vote_desc = "Воцаряется любовь. Добрые события приходят чаще, и Она не желает никому зла. Без антагонистов и гноллов; лишь горстка вретчей прячется на окраинах. Её милость обращена к романтике."
	desc = "Массовые события получают вес x1.5, благословения - x1.2. Без антагонистов и набегов. Божественное вмешательство случается в 2 раза чаще, личные события - в 1.4 раза чаще. вретчи жёстко ограничены 5-ю слотами. Гноллы отключены."
	welcome_text = "\"Любовь витает в воздухе? Нет же; это пахнут свежеиспечённые пироги на подоконниках!\""
	color_theme = "#9966CC"
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	wretch_slot_cap = 5
	guarantees_roundstart_roleset = FALSE
	roundstart_prob = 0

	starting_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	tag_multipliers = list(
		TAG_WIDESPREAD = 1.5,
		TAG_BOON = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.4,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 0,	//No antagonist spawns.
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 0,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_HUGS_MADE = list("name" = "Hugs made:", "points" = 2.5, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_KISSES_MADE = list("name" = "Kisses made:", "points" = 7, "capacity" = 70),
		),
		"Set 3" = list(
			STATS_CLINGY_PEOPLE = list("name" = "Clingy people:", "points" = 6.5, "capacity" = 75),
		),
		"Set 4" = list(		
			STATS_BEAUTIFUL_PEOPLE = list("name" = "Beautiful people:", "points" = 9, "capacity" = 50),
		),
		"Set 5" = list(
			STATS_MARRIAGES_MADE = list("name" = "Marriages made:", "points" = 20, "capacity" = 80), //Rare so worth a ton.
		)
	)

/datum/storyteller/dendor
	name = "Dendor"
	ru_name = "Дендор"
	vote_desc = "Воцаряется природа. Заросли и оборотни приходят чаще. Его милость обращена к урожаю и ликантропам - гноллы держатся подальше от Его диких земель."
	desc = "Природные события получают вес x1.5. Оборотень - единственный основной антагонист на старте раунда и получает вес x1.5; бандиты, личи и вампирские лорды не выпадают. Божественное вмешательство случается в 2 раза чаще. Гноллы отключены."
	welcome_text = "Перекличка сидящих на ветвях птиц и блеск утренней росы.."
	weight = 4
	always_votable = TRUE
	color_theme = "#664422"
	preferred_gnoll_mode = GNOLL_SCALING_NONE

	tag_multipliers = list(
		TAG_NATURE = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 0.8,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_TREES_CUT = list("name" = "Trees felled:", "points" = -0.35, "capacity" = -45),
		),
		"Set 2" = list(
			STATS_PLANTS_HARVESTED = list("name" = "Plants harvested:", "points" = 0.75, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_ANIMALS_TAMED = list("name" = "Animals tamed:", "points" = 3, "capacity" = 90),
		),
		"Set 4" = list(
			STATS_FOREST_DEATHS = list("name" = "Forest deaths:", "points" = 6, "capacity" = 90),
		),
		"Set 5" = list(
			STATS_WEREVOLVES = list("name" = "Number of werevolves:", "points" = 12.5, "capacity" = 65),
		),
	)

// INHUMEN

/datum/storyteller/zizo
	name = "Zizo"
	ru_name = "Зизо"
	vote_desc = "Воцаряется хаос. Личи пробуждаются охотнее, чем под властью любого другого Бога, нежить становится куда свирепее, а культисты Вознесения вылезают из своих укрытий наружу, дабы принести своей Госпоже достойную жертву. Её милость обращена к трупам - святым, знатным или восставшим."
	desc = "Магические, азартные, обманные и внезапные события получают повышенный вес (от x1.2 до x1.5). Лич/культ Вознесения гарантирован на старте раунда; бандиты, оборотни и вампирские лорды не выпадают. Сильный разброс стоимости событий. Фиксированный спавн гноллов: шанс 15%, максимум 2. Может сработать расширение количества слотов вретчей в зависимости от количества слотов гарнизона."
	welcome_text = "Мертвенный ветер несёт вой проклятых.."
	weight = 4
	always_votable = TRUE
	color_theme = "#CC4444"
	preferred_gnoll_mode = GNOLL_SCALING_FLAT
	wretch_slot_cap = 15

	tag_multipliers = list(
		TAG_MAGICAL = 1.2,
		TAG_GAMBLE = 1.5,
		TAG_TRICKERY = 1.3,
		TAG_UNEXPECTED = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1.1,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1.3,
		EVENT_TRACK_RAIDS = 0.8,
	)

	cost_variance = 50  // Events will be highly variable in cost

	influence_sets = list(
		"Set 1" = list(
			STATS_HUMEN_DEATHS = list("name" = "Humen killed:", "points" = 5.5, "capacity" = 80),
			STATS_CLERGY_DEATHS = list("name" = "Clergy killed:", "points" = 12, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_DEADITES_WOKEN_UP = list("name" = "Deadites woken up:", "points" = 4, "capacity" = 85),
		),
		"Set 3" = list(
			STATS_DEADITES_ALIVE = list("name" = "Deadites alive:", "points" = 1, "capacity" = 40),
		),
		"Set 4" = list(
			STATS_LUX_HARVESTED = list("name" = "Clergy killed:", "points" = 12, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_TORTURES = list("name" = "Tortures performed:", "points" = 5.25, "capacity" = 70),
		),
		"Set 6" = list(
			STATS_BOOKS_BURNED = list("name" = "Books burned:", "points" = 5, "capacity" = 50), //We actually gain influence from it
		),
	)

/datum/storyteller/baotha
	name = "Baotha"
	ru_name = "Баота"
	vote_desc = "Воцаряется дурман. События становятся хаотичнее и мрачнее. Её милость обращена к пьяницам и зависимым."
	desc = "События безумия, магии и бедствий получают повышенный вес (от x1.1 до x1.4). Вампирский лорд гарантирован на старте раунда; бандиты, личи и оборотни не выпадают. Все события накапливают очки быстрее. Режим гноллов выбирается случайно. Может сработать расширение количества слотов вретчей в зависимости от количества слотов гарнизона."
	welcome_text = "Воздух наполняет приторный запах хмеля и пряностей.."
	weight = 4
	always_votable = TRUE
	color_theme = "#9933FF"
	preferred_gnoll_mode = GNOLL_SCALING_RANDOM
	wretch_slot_cap = 15

	tag_multipliers = list(
		TAG_INSANITY = 1.4,
		TAG_MAGIC = 1.2,
		TAG_DISASTER = 1.1,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1.3,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 0.7,
		EVENT_TRACK_OMENS = 1.5,
		EVENT_TRACK_RAIDS = 1.2,
	)

	cost_variance = 30  // Makes events more erratic in timing

	influence_sets = list(
		"Set 1" = list(
			STATS_JUNKIES = list("name" = "Number of junkies:", "points" = 9, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_DRUGS_SNORTED = list("name" = "Drugs snorted:", "points" = 4, "capacity" = 85),
		),
		"Set 3" = list(
			STATS_ALCOHOLICS = list("name" = "Number of alcoholics:", "points" = 3.25, "capacity" = 60),
		),
		"Set 4" = list(
			STATS_ALCOHOL_CONSUMED = list("name" = "Alcohol consumed:", "points" = 0.042, "capacity" = 90),
		),
		"Set 5" = list(
			STATS_NYMPHOMANIACS = list("name" = "Number of nymphomaniacs:", "points" = 6, "capacity" = 30),
		),
		"Set 6" = list(
			STATS_PLEASURES = list("name" = "Pleasures had:", "points" = 5, "capacity" = 50),
		),
		"Set 5" = list(
			STATS_KNOTTED_NOT_LUPIANS = list("name" = "Non-Lupian knottings:", "points" = 5, "capacity" = 50),
		),
	)

/datum/storyteller/graggar
	name = "Graggar"
	ru_name = "Граггар"
	vote_desc = "Воцаряется сила. Гноллы и убийцы рыщут усерднее, чем при любом другом Боге, а набеги случаются куда чаще. Его милость обращена к кровопролитию и каннибализму."
	desc = "Боевые, кровавые и военные события получают повышенный вес (от x1.2 до x1.6). Гноллы и ассасины гарантированы на старте раунда. Набеги набирает очки в 2.5 раза быстрее. Динамическое масштабирование гноллов: стаи растут вместе с населением. Может сработать расширение количества слотов вретчей в зависимости от количества слотов гарнизона."
	welcome_text = "По улицам стелется дым, отдающий пеплом и кровью.."
	weight = 4
	always_votable = TRUE
	color_theme = "#8B3A3A"
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC
	wretch_slot_cap = 15

	tag_multipliers = list(
		TAG_BATTLE = 1.6,
		TAG_BLOOD = 1.3,
		TAG_WAR = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.8,
		EVENT_TRACK_PERSONAL = 0.7,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 0.9,
		EVENT_TRACK_RAIDS = 2.5,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_BLOOD_SPILT = list("name" = "Blood spilt:", "points" = 0.03, "capacity" = 60),
		),
		"Set 2" = list(
			STATS_ORGANS_EATEN = list("name" = "Organs eaten:", "points" = 5, "capacity" = 70),
		),
		"Set 3" = list(
			STATS_DEATHS = list("name" = "Deaths:", "points" = 5, "capacity" = 115),
		),
		"Set 4" = list(
			STATS_ASSASSINATIONS = list("name" = "Sucessful assassinations:", "points" = 20, "capacity" = 100),
		),
		"Set 5" = list(
			STATS_PEOPLE_GIBBED = list("name" = "People gibbed:", "points" = 3.5, "capacity" = 55),
		)
	)

	cost_variance = 10  // Less randomness, more direct

/datum/storyteller/matthios
	name = "Matthios"
	ru_name = "Маттиос"
	vote_desc = "Воцаряется свобода. Бандитские вылазки случаются куда чаще, чем при других Богах. Его милость обращена к кражам и подношениям у одного особого святилища."
	desc = "Торговые, коррупционные и связанные с добычей события выбираются чаще (от x1.2 до x1.4). Бандиты гарантированы на старте раунда; личи, оборотни и вампирские лорды не появляются. Очки появления антагонистов копятся в 1.5 раза быстрее. Режим гноллов выбирается случайно. Может сработать расширение количества слотов вретчей в зависимости от количества слотов гарнизона."
	welcome_text = "Звенят маммоны, а свежеподписанные награды ещё пахнут чернилами.."
	weight = 4
	always_votable = TRUE
	color_theme = "#8B4513"
	preferred_gnoll_mode = GNOLL_SCALING_RANDOM
	wretch_slot_cap = 15
	tag_multipliers = list(
		TAG_TRADE = 1.4,
		TAG_CORRUPTION = 1.3,
		TAG_LOOT = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.1,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 1.3,
		EVENT_TRACK_CHARACTER_INJECTION = 1.5,
		EVENT_TRACK_OMENS = 1.1,
		EVENT_TRACK_RAIDS = 0.6,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_NOBLE_DEATHS = list("name" = "Nobles killed:", "points" = 5.5, "capacity" = 80),
		),
		"Set 2" = list(
			STATS_SHRINE_VALUE = list("name" = "Value offered to his idol:", "points" = 0.08, "capacity" = 70),
		),
		"Set 3" = list(
			STATS_GREEDY_PEOPLE = list("name" = "Number of greedy people:", "points" = 6.5, "capacity" = 70),
			STATS_INDEBTED = list("name"= "Number of indebted people:", "points" = 5, "capacity" = 25),
		),
		"Set 4" = list(		
			STATS_ITEMS_PICKPOCKETED = list("name" = "Items pickpocketed:", "points" = 4.5, "capacity" = 80),
		),
		"Set 5" = list(
			STATS_LOCKS_PICKED = list("name" = "Locks picked:", "points" = 3.75, "capacity" = 80),
		)
	)

	cost_variance = 15  // Keeps a balance between predictability and randomness

#undef DIVINE_STORYTELLERS
#undef INHUMEN_STORYTELLERS
#undef STORYTELLERS_ALL
