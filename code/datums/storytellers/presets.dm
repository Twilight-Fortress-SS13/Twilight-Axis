/// Code-defined gamemode presets. These replace the old storyteller gods. Players vote between them (grouped
/// into three pools - see GAMEMODE_POOL_* in __DEFINES/storytellers.dm) or admins fine-tune the roundstart
/// antag config directly.

/datum/storyteller/gamemode
	always_votable = TRUE
	hag_slots = 1

// ----------------------------------------------------------------------------------------------------------
// Extended - no hard antags, no soft antags; only a lone Hag may appear
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/extended
	name = "Extended"
	vote_desc = "Возможно, настоящими антагонистами всё это время были мы сами."
	desc = "Без крупных антагонистов, без малых антагонистов (Wretch/Gnoll/Assassin), без сноходцев (Dreamwalkers). Карга (Hag) присутствует."
	welcome_text = "Умеренный ветер прокатывается по тихим улицам..."
	color_theme = "#80ced8"
	preset_pool = GAMEMODE_POOL_EXTENDED
	block_hard = TRUE
	block_soft = TRUE
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	wretch_slot_cap = 0
	roundstart_prob = 0
	guarantees_roundstart_roleset = FALSE
	starting_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)
	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

// ----------------------------------------------------------------------------------------------------------
// Admin sandbox - NOT votable. Admins pick before the 120s mark to disable player vote and
// insert their own antags in.
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/admin
	name = "Admin Sandbox"
	vote_desc = "The Gods among us have taken the wheel."
	desc = "Admin sandbox. Soft antags default to the standard No-Antag baseline; admins open hard antags and adjust slots directly."
	welcome_text = "The threads of fate bend to an unseen hand.."
	color_theme = "#c8a13a"
	preset_pool = null
	always_votable = FALSE
	block_hard = FALSE
	block_soft = FALSE
	allow_dreamwalker = TRUE
	guaranteed_hard = FALSE
	guarantees_roundstart_roleset = FALSE
	roundstart_prob = 0
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC	// max 3
	wretch_slot_cap = 12

	starting_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)
	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

// ----------------------------------------------------------------------------------------------------------
// Atleast one main antag will be selected
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/guaranteed_antag
	name = "High Intensity"
	vote_desc = "Гарантированный крупный антагонист. Часть малых антагонистов остаётся."
	desc = "Гарантированный раундстартовый крупный антагонист. До 9 изгоев (Wretches). До 2 гноллов. Карга (Hag) присутствует. Могут появиться сноходцы (Dreamwalkers)."
	welcome_text = "Леденящий ужас плавно опускается на город..."
	color_theme = "#a43c3c"
	preset_pool = GAMEMODE_POOL_GUARANTEED
	guaranteed_hard = TRUE
	guarantees_roundstart_roleset = TRUE
	roundstart_prob = 100
	block_hard = FALSE
	block_soft = FALSE
	allow_dreamwalker = TRUE
	preferred_gnoll_mode = GNOLL_SCALING_FLAT	// max 2
	wretch_slot_cap = 9

/datum/storyteller/gamemode/guaranteed_antag/low_wretch
	name = "Medium Intensity"
	vote_desc = "Гарантированный крупный антагонист случайного типа. Также присутствует несколько малых антагонистов."
	desc = "Гарантированный раундстартовый крупный антагонист с более агрессивным масштабированием от онлайна. До 4 изгоев (Wretches). До 1 гнолла. Карга (Hag) присутствует."
	color_theme = "#7a1f1f"
	hard_mult = 2
	block_soft = FALSE
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE	// max 1
	wretch_slot_cap = 4

// ----------------------------------------------------------------------------------------------------------
// Just wretches/gnolls/hags, etc
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/no_antag	// DEFAULT
	name = "Standard Intensity"
	vote_desc = "Без крупных антагонистов. Малые антагонисты масштабируются умеренно."
	desc = "Без крупных антагонистов. Изгои (Wretches) масштабируются обычно (от 5 до 12). До 3 гноллов. Карга (Hag) присутствует. Сноходец (Dreamwalker) может появиться."
	welcome_text = "Тёплый дневной свет пробуждает вас ото сна..."
	color_theme = "#2b8c87"
	preset_pool = GAMEMODE_POOL_NOANTAG
	block_hard = TRUE
	block_soft = FALSE
	allow_dreamwalker = TRUE
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC	// max 3
	wretch_slot_cap = 12
	roundstart_prob = 50
	guarantees_roundstart_roleset = FALSE

/datum/storyteller/gamemode/no_antag/small_wretch
	name = "Low Intensity"
	vote_desc = "Без крупных антагонистов. Малых антагонистов меньше."
	desc = "Без крупных антагонистов. Изгои (Wretches) фиксированы на 5 слотах. До 1 гнолла. Карга (Hag) присутствует. Могут появиться сноходцы (Dreamwalker)."
	welcome_text = "\"Любовь витает в воздухе? Нет же; это пахнут свежеиспечённые пироги на подоконниках!\""
	color_theme = "#1f6b67"
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE	// max 1
	wretch_slot_cap = 5
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
	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)
