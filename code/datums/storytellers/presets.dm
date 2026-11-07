/// Code-defined gamemode presets. These replace the old storyteller gods. Players vote between them (grouped
/// into three pools - see GAMEMODE_POOL_* in __DEFINES/storytellers.dm) or admins fine-tune the roundstart
/// antag config directly. A preset's vote pool is set by preset_pool, independent of its type hierarchy.

/datum/storyteller/gamemode
	always_votable = TRUE
	hag_slots = 1
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
// ASCENDANT pool - guaranteed roundstart hard antag. At least one main antag will be selected.
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/guaranteed_antag
	name = "High Intensity"
	vote_desc = "Гарантированный крупный антагонист. Часть малых антагонистов остаётся."
	desc = "Гарантированный раундстартовый крупный антагонист. До 7 изгоев (Wretches). До 2 гноллов. До 4 бандитов. Карга (Hag) присутствует. Сноходец (Dreamwalker) может появиться."
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
	wretch_slot_cap = 7 // TA EDIT
	// TA EDIT START
	midpop_vote_mult = 0.66
	lowpop_vote_mult = 0.16
	alternate_preset = /datum/storyteller/gamemode/guaranteed_antag/low_wretch
	// TA EDIT END
/datum/storyteller/gamemode/guaranteed_antag/low_wretch
	name = "Tempered Intensity"
	vote_desc = "Только бандиты и изгои, без крупных антагонистов." // TA EDIT
	desc = "Без крупных антагонистов. До 5 изгоев (Wretches) и до 7 бандитов. Гноллы, карги и сноходцы не появляются." // TA EDIT
	color_theme = "#7a1f1f"
	vote_hidden = TRUE // TA EDIT
	hard_mult = 2
	guaranteed_hard = FALSE // TA EDIT
	guarantees_roundstart_roleset = FALSE // TA EDIT
	roundstart_prob = 0 // TA EDIT
	block_hard = TRUE // TA EDIT
	block_soft = FALSE
	hag_slots = 0 // TA EDIT
	allow_dreamwalker = FALSE // TA EDIT
	preferred_gnoll_mode = GNOLL_SCALING_NONE // TA EDIT
	wretch_slot_cap = 5 // TA EDIT
// ----------------------------------------------------------------------------------------------------------
// TEN pool - no hard antags, soft antags only. Standard is the lighter option, Medium the default fallback.
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/no_antag	// DEFAULT (inconclusive-vote fallback)
	name = "Medium Intensity"
	vote_desc = "Без крупных антагонистов. Малые антагонисты масштабируются умеренно."
	desc = "Без крупных антагонистов. Изгои (Wretches) масштабируются обычно: от 5 до 12. До 3 гноллов. Карга (Hag) присутствует. Сноходец (Dreamwalker) может появиться."
	welcome_text = "Тёплый дневной свет пробуждает вас ото сна..."
	color_theme = "#2b8c87"
	// TA EDIT START
	preset_pool = GAMEMODE_POOL_NOANTAG
	alternate_preset = /datum/storyteller/gamemode/no_antag/standard
	midpop_vote_mult = 0.66
	lowpop_vote_mult = 0.33
	// TA EDIT END
	block_hard = TRUE
	block_soft = FALSE
	allow_dreamwalker = TRUE
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC	// max 3
	wretch_slot_cap = 12
	roundstart_prob = 50
	guarantees_roundstart_roleset = FALSE
/datum/storyteller/gamemode/no_antag/standard
	name = "Standard Intensity"
	vote_desc = "Без крупных антагонистов. Умеренное количество малых антагонистов."
	desc = "Без крупных антагонистов. До 6 изгоев (Wretches). До 2 гноллов. Карга (Hag) присутствует. Сноходцы (Dreamwalkers) не появляются."
	color_theme = "#37b3a6"
	vote_hidden = TRUE // TA EDIT
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_FLAT	// max 2
	wretch_slot_cap = 6
// ----------------------------------------------------------------------------------------------------------
// PSYDON pool - lowest intensity. No hard antags. Low Intensity opens a few wretches.
// ----------------------------------------------------------------------------------------------------------
// Low Intensity - votes in the PSYDON pool (see preset_pool) despite being a no_antag subtype.
/datum/storyteller/gamemode/no_antag/small_wretch
	name = "Low Intensity"
	vote_desc = "Без крупных антагонистов. Малых антагонистов совсем мало."
	desc = "Без крупных антагонистов. Изгои (Wretches) фиксированы на 4 слотах. Гноллы не появляются. Карга (Hag) присутствует. Сноходцы (Dreamwalkers) не появляются."
	welcome_text = "\"Любовь витает в воздухе? Нет же; это пахнут свежеиспечённые пироги на подоконниках!\""
	color_theme = "#1f6b67"
	preset_pool = GAMEMODE_POOL_EXTENDED
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	wretch_slot_cap = 4
	// TA EDIT START
	highpop_vote_mult = 1
	midpop_vote_mult = 1
	lowpop_vote_mult = 1
	alternate_preset = null
	// TA EDIT END
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
