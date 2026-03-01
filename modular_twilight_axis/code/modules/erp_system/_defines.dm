#define SEX_ORGAN_HANDS   "hands"
#define SEX_ORGAN_LEGS    "legs"
#define SEX_ORGAN_TAIL    "tail"
#define SEX_ORGAN_MOUTH   "mouth"
#define SEX_ORGAN_ANUS    "anus"
#define SEX_ORGAN_BREASTS "breasts"
#define SEX_ORGAN_VAGINA  "vagina"
#define SEX_ORGAN_PENIS   "penis"
#define SEX_ORGAN_BODY    "body"

#define REL_LOVE_POTION (1<<0)

#define SEX_POSE_BOTH_STANDING "both_standing"
#define SEX_POSE_USER_LYING    "user_lying"
#define SEX_POSE_TARGET_LYING  "target_lying"
#define SEX_POSE_BOTH_LYING    "both_lying"

#define SEX_SENSITIVITY_MAX 2
#define SEX_PAIN_MAX 2

#define ERP_SCOPE_SELF  1
#define ERP_SCOPE_OTHER 2


#define ERP_ACTION_ACTIVE_AROUSAL	"active_arousal"
#define ERP_ACTION_ACTIVE_PAIN		"active_pain"
#define ERP_ACTION_PASSIVE_AROUSAL	"passive_arousal"
#define ERP_ACTION_PASSIVE_PAIN		"passive_pain"
#define ERP_ACTION_LEGACY_AROUSAL	"arousal"
#define ERP_ACTION_LEGACY_PAIN		"pain"

var/global/list/ERP_ACTION_PREF_FIELDS = list(
	"name",
	"required_init_organ",
	"required_target_organ",
	"reserve_target_organ",
	"active_arousal_coeff",
	"passive_arousal_coeff",
	"active_pain_coeff",
	"passive_pain_coeff",
	"inject_timing",
	"inject_source",
	"inject_target_mode",
	"require_same_tile",
	"require_grab",
	"allow_when_restrained",
	"allow_sex_on_move",
	"required_item_tags",
	"action_tags",
	"message_start",
	"message_tick",
	"message_finish",
	"message_climax_active",
	"message_climax_passive",
	"action_scope"
)

var/global/list/ERP_ACTION_EDITOR_FIELDS = list(
	list("id"="name", "label"="Название", "type"="text", "section"="Основное"),
	list("id"="action_scope", "label"="Цель действия", "type"="enum", "section"="Основное"),
	list("id"="required_init_organ",   "label"="Орган инициатора", "type"="enum", "section"="Ограничения", "options"="organs"),
	list("id"="required_target_organ", "label"="Орган цели",       "type"="enum", "section"="Ограничения", "options"="organs"),
	list("id"="require_same_tile", "label"="Только с одного тайла", "type"="bool", "section"="Ограничения"),
	list("id"="allow_when_restrained", "label"="Можно в стяжках", "type"="bool", "section"="Ограничения"),
	list("id"="allow_sex_on_move", "label"="Можно на ходу", "type"="bool", "section"="Ограничения"),
	list("id"="active_arousal_coeff",  "label"="Возбуждение актера",  "type"="number", "section"="Эффекты", "min"=0, "max"=5, "step"=0.1),
	list("id"="passive_arousal_coeff", "label"="Возбуждение цели",    "type"="number", "section"="Эффекты", "min"=0, "max"=5, "step"=0.1),
	list("id"="active_pain_coeff",     "label"="Боль актера",         "type"="number", "section"="Эффекты", "min"=0, "max"=5, "step"=0.1),
	list("id"="passive_pain_coeff",    "label"="Боль цели",           "type"="number", "section"="Эффекты", "min"=0, "max"=5, "step"=0.1),
	list("id"="message_start",          "label"="Сообщение: старт",    "type"="multiline", "section"="Сообщения"),
	list("id"="message_tick",           "label"="Сообщение: тик",      "type"="multiline", "section"="Сообщения"),
	list("id"="message_finish",         "label"="Сообщение: финиш",    "type"="multiline", "section"="Сообщения"),
	list("id"="message_climax_active",  "label"="Оргазм: актер",       "type"="multiline", "section"="Сообщения"),
	list("id"="message_climax_passive", "label"="Оргазм: цель",        "type"="multiline", "section"="Сообщения"),
)

#define COMSIG_ERP_GET_LINKS "erp_get_links"
#define COMSIG_ERP_ANATOMY_CHANGED "erp_anatomy_changed"
#define COMSIG_SEX_MODIFY_EFFECT "sex_modify_effect"

#define ERP_SCENE_START_END_COLOR "#f2b7c7"
#define ERP_SCENE_CLIMAX_COLOR    "#d146f5" 

#define ERP_SP_MAX 6.0
#define ERP_SP_DECAY_INTERVAL (24 MINUTES)
#define ERP_SP_DECAY_AMOUNT 1.0

#define ERP_SP_GAIN_PARTNER 1.0
#define ERP_SP_GAIN_MASTURBATE 0.5

#define ERP_SATISFY_MAX_TIER 5

#define ERP_NYMPHO_SATED_SP 2.0

#define ERP_NYMPHO_SOFT_CAP 20
#define ERP_NYMPHO_HARD_CAP 40

#define ERP_NYMPHO_HARD_HUNGER_SP 1.0

#define ERP_NYMPHO_PRE_SATED_AROUSAL_GAIN_MULT 0.75

#define ERP_CHAIN_BONUS 20
#define ERP_CHAIN_BONUS_NYMPHO 30
#define ERP_CHAIN_LOCK_TIME (2 SECONDS)

#define ERP_OVERLOAD_SP_TRIGGER 6.0
#define ERP_OVERLOAD_MAX_OP 10
#define ERP_OVERLOAD_DECAY_INTERVAL (4 MINUTES)

#define ERP_BASE_AROUSAL_DECAY_RATE 0.20

#define ERP_AGE_BASELINE 30
#define ERP_BAOTHA_CHARGE_REGEN_MULT 1.25



GLOBAL_LIST_INIT(available_kinks, generate_kink_list())
GLOBAL_LIST_INIT(relationship_settings, list(
	REL_LOVE_POTION = list(
	"sex_mult" = 0.8,
	"other_sex_mult" = 1.2,
	"observe_min" = 10,
	"observe_gain" = 1,
	"observe_cap" = 30
	)
))
var/global/list/ERP_ORGAN_ORDER = list(
	SEX_ORGAN_BODY,
	SEX_ORGAN_MOUTH,
	SEX_ORGAN_BREASTS,
	SEX_ORGAN_HANDS,
	SEX_ORGAN_PENIS,
	SEX_ORGAN_VAGINA,
	SEX_ORGAN_ANUS,
	SEX_ORGAN_TAIL,
	SEX_ORGAN_LEGS
)

/proc/generate_kink_list()
	var/list/kinks = list()
	for(var/datum/kink/K as anything in subtypesof(/datum/kink))
		if(is_abstract(K))
			continue
		kinks[initial(K.type)] = new K
	return kinks

/proc/is_sex_toy(obj/item/I)
	if(!I)
		return FALSE

	if(istype(I, /obj/item/dildo))
		return TRUE

	return FALSE

#define INJECT_NONE         0
#define INJECT_CONTINUOUS   1
#define INJECT_ON_FINISH    2

#define INJECT_ORGAN		"organ"
#define INJECT_CONTAINER	"container"
#define INJECT_GROUND		"ground"

#define INJECT_FROM_ACTIVE  "active"
#define INJECT_FROM_PASSIVE "passive"

#define ERP_KNOT_MOVE_KEEP        0
#define ERP_KNOT_MOVE_BREAK_SOFT  1
#define ERP_KNOT_MOVE_BREAK_FORCE 2

#define ERP_KNOT_MAX_STRENGTH 100
#define ERP_KNOT_PAIN_THRESHOLD 25
#define ERP_KNOT_DECAY_STEP 1
#define ERP_KNOT_DECAY_TICK (2 SECONDS)
#define ERP_KNOT_ACTIVITY_GRACE (3 SECONDS)

#define ERP_KNOT_PULL_OWNER_BASE 55
#define ERP_KNOT_PULL_BTM_BASE 35

#define LINK_STATE_ACTIVE     1
#define LINK_STATE_FINISHED   2
